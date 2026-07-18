#!/usr/bin/env python3
import argparse
import hashlib
import json
import re
import struct
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import unquote

from pypdf import PdfReader

SOURCE_DIR = Path(__file__).resolve().parent
PACKET_DIR = SOURCE_DIR.parent
BRAND_DIR = PACKET_DIR.parent
COMPANY_DIR = BRAND_DIR.parent
REPO_DIR = COMPANY_DIR.parent
TASKS_PATH = BRAND_DIR / "brandbook-loop" / "tasks.json"
PROGRESS_PATH = BRAND_DIR / "brandbook-loop" / "progress.txt"
DESIGN_PATH = PACKET_DIR / "DESIGN.md"
PDF_PATH = PACKET_DIR / "Magic-Mirror-Brandbook.pdf"
HTML_PATH = SOURCE_DIR / "brandbook.html"
PLAN_PATH = COMPANY_DIR / "plan.md"
ACTIVITY_PATH = COMPANY_DIR / "activity.md"
RUN_LOG_PATH = COMPANY_DIR / "run-log.md"
AUDIT_PATH = PACKET_DIR / "audit.json"

TASK_EVIDENCE = {
    "T001": ["references/t001-audit.json"],
    "T002": ["references/t002-audit.json", "references/t002-revision-audit.json"],
    "T003": ["references/t003-audit.json"],
    "T004": ["references/t004-audit.json"],
    "T005": ["references/t005-audit.json"],
    "T006": ["references/t006-correction-audit.json"],
    "T007": ["references/t007-audit.json"],
    "T008": ["references/t008-audit.json"],
    "T009": ["references/t009-audit.json"],
    "T010": ["references/t010-audit.json"],
    "T011": ["references/t011-audit.json"],
}

MOCKUPS = [
    "business-card.png",
    "billboard.png",
    "browser-favicon-light.png",
    "browser-favicon-dark.png",
    "x-profile.png",
    "linkedin-profile.png",
    "tshirt.png",
    "compact-mirror.png",
]

FONT_FILES = [
    "assets/fonts/instrument-serif/InstrumentSerif-Regular.ttf",
    "assets/fonts/instrument-serif/InstrumentSerif-Italic.ttf",
    "assets/fonts/space-grotesk/SpaceGrotesk[wght].ttf",
]

LICENSE_FILES = [
    "assets/fonts/instrument-serif/OFL.txt",
    "assets/fonts/space-grotesk/OFL.txt",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def png_dimensions(path: Path):
    header = path.read_bytes()[:24]
    assert header[:8] == b"\x89PNG\r\n\x1a\n" and header[12:16] == b"IHDR", f"Invalid PNG: {path}"
    return struct.unpack(">II", header[16:24])


def is_inside(path: Path, parent: Path) -> bool:
    try:
        path.resolve().relative_to(parent.resolve())
        return True
    except ValueError:
        return False


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--preflight", action="store_true")
    return parser.parse_args()


def main():
    args = parse_args()
    tasks_data = json.loads(TASKS_PATH.read_text(encoding="utf-8"))
    tasks = tasks_data["tasks"]
    assert len(tasks) == 12, f"Expected 12 tasks, found {len(tasks)}"
    task_by_id = {task["id"]: task for task in tasks}
    assert set(task_by_id) == {f"T{number:03d}" for number in range(1, 13)}

    for task_id in [f"T{number:03d}" for number in range(1, 12)]:
        task = task_by_id[task_id]
        assert task["status"] == "complete", f"{task_id} is not complete"
        assert task["notes"].strip(), f"{task_id} has no evidence notes"
    if args.preflight:
        assert task_by_id["T012"]["status"] in {"in_progress", "complete"}
    else:
        assert task_by_id["T012"]["status"] == "complete"
        assert task_by_id["T012"]["notes"].strip()

    evidence_records = {}
    for task_id, relatives in TASK_EVIDENCE.items():
        records = []
        for relative in relatives:
            path = PACKET_DIR / relative
            assert path.is_file() and path.stat().st_size > 0, f"Missing evidence: {relative}"
            data = json.loads(path.read_text(encoding="utf-8"))
            assert data.get("status") == "passed", f"Evidence did not pass: {relative}"
            records.append({"path": relative, "bytes": path.stat().st_size, "sha256": sha256(path)})
        evidence_records[task_id] = records

    required_files = [
        PDF_PATH,
        DESIGN_PATH,
        PACKET_DIR / "asset-plan.md",
        HTML_PATH,
        SOURCE_DIR / "brandbook.css",
        PACKET_DIR / "tokens" / "brand-tokens.json",
        PACKET_DIR / "tokens" / "brand-tokens.css",
        PACKET_DIR / "tokens" / "derived-palette.json",
        PACKET_DIR / "tokens" / "wcag-matrix.json",
        PACKET_DIR / "pages" / "contact-sheet.png",
        PACKET_DIR / "references" / "t008-mayven-comparison-contact-sheet.png",
    ]
    for path in required_files:
        assert path.is_file() and path.stat().st_size > 0, f"Missing required packet file: {path}"

    reader = PdfReader(str(PDF_PATH))
    assert len(reader.pages) == 19
    for index, page in enumerate(reader.pages, start=1):
        assert abs(float(page.mediabox.width) - 792.0) <= 0.5
        assert abs(float(page.mediabox.height) - 612.0) <= 0.5
        assert f"{index:02d}" in (page.extract_text() or ""), f"PDF page {index} missing folio"

    source_previews = sorted((PACKET_DIR / "pages" / "source").glob("page-*.png"))
    pdf_previews = sorted((PACKET_DIR / "pages" / "pdf").glob("page-*.png"))
    assert len(source_previews) == 19
    assert len(pdf_previews) == 19
    for path in source_previews + pdf_previews:
        assert png_dimensions(path) == (2112, 1632), f"Unexpected preview dimensions: {path}"

    mockup_records = []
    for name in MOCKUPS:
        path = PACKET_DIR / "mockups" / name
        assert path.is_file() and path.stat().st_size > 0, f"Missing mockup: {name}"
        width, height = png_dimensions(path)
        mockup_records.append({
            "path": str(path.relative_to(PACKET_DIR)),
            "width_px": width,
            "height_px": height,
            "bytes": path.stat().st_size,
            "sha256": sha256(path),
        })

    for relative in FONT_FILES + LICENSE_FILES:
        path = PACKET_DIR / relative
        assert path.is_file() and path.stat().st_size > 0, f"Missing font or license: {relative}"

    token_records = []
    for name in ["brand-tokens.json", "derived-palette.json", "wcag-matrix.json"]:
        path = PACKET_DIR / "tokens" / name
        json.loads(path.read_text(encoding="utf-8"))
        token_records.append({"path": str(path.relative_to(PACKET_DIR)), "bytes": path.stat().st_size, "sha256": sha256(path)})
    css_tokens = PACKET_DIR / "tokens" / "brand-tokens.css"
    assert css_tokens.stat().st_size > 0 and ":root" in css_tokens.read_text(encoding="utf-8")

    html = HTML_PATH.read_text(encoding="utf-8")
    local_refs = [target for target in re.findall(r'(?:src|href)="([^"]+)"', html) if not target.startswith("#")]
    resolved_refs = []
    for target in local_refs:
        assert not re.match(r"^[a-z]+://", target), f"External source reference: {target}"
        resolved = (SOURCE_DIR / unquote(target)).resolve()
        assert resolved.exists(), f"Missing source reference: {target}"
        assert is_inside(resolved, BRAND_DIR), f"Source reference escapes company/brand: {target}"
        resolved_refs.append(str(resolved.relative_to(BRAND_DIR)))
    assert not re.search(r"Mayven|Captain Blue|cruise", html, flags=re.IGNORECASE)

    t008 = json.loads((PACKET_DIR / "references" / "t008-audit.json").read_text(encoding="utf-8"))
    assert t008["content_scans"]["forbidden_reference_terms"] == 0
    assert t008["content_scans"]["external_urls"] == 0
    assert t008["content_scans"]["literal_hex_colors_in_page_css"] == []
    t010 = json.loads((PACKET_DIR / "references" / "t010-audit.json").read_text(encoding="utf-8"))
    assert t010["visual_review"]["results"]["passed"] is True
    assert all(value == 0 for key, value in t010["visual_review"]["results"].items() if key != "passed")
    t011 = json.loads((PACKET_DIR / "references" / "t011-audit.json").read_text(encoding="utf-8"))
    assert t011["links"]["missing_local_links"] == []
    assert t011["links"]["resolved_local_link_count"] == t011["links"]["local_link_count"]

    mayven_pages = sorted((PACKET_DIR / "references" / "layout-direction" / "mayven" / "pages").glob("page-*.png"))
    assert len(mayven_pages) == 19
    design_text = DESIGN_PATH.read_text(encoding="utf-8")
    assert "Never present the complete icon as the recommended 16 px favicon" in design_text
    assert "working title" in design_text

    assert PROGRESS_PATH.is_file() and "task T011 | complete" in PROGRESS_PATH.read_text(encoding="utf-8")
    if not args.preflight:
        plan_text = PLAN_PATH.read_text(encoding="utf-8")
        activity_text = ACTIVITY_PATH.read_text(encoding="utf-8")
        run_log_text = RUN_LOG_PATH.read_text(encoding="utf-8")
        assert "[x] Complete the reusable 19-page brandbook loop" in plan_text
        assert re.search(r"\[note-\d{4}\].*brandbook", activity_text, flags=re.IGNORECASE)
        assert re.search(r"2026-07-18[\s\S]*brandbook", run_log_text, flags=re.IGNORECASE)
        assert "task T012 | complete" in PROGRESS_PATH.read_text(encoding="utf-8")

    if args.preflight:
        print("T012 preflight passed: packet, task evidence, PDF, previews, assets, fonts, tokens, and source boundaries are complete")
        return

    audit = {
        "task_id": "T012",
        "status": "passed",
        "verified_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
        "tasks": {
            "count": len(tasks),
            "complete_count": sum(task["status"] == "complete" for task in tasks),
            "tasks_with_notes": sum(bool(task["notes"].strip()) for task in tasks),
            "evidence": evidence_records,
        },
        "packet": {
            "pdf": {"path": str(PDF_PATH.relative_to(BRAND_DIR)), "bytes": PDF_PATH.stat().st_size, "sha256": sha256(PDF_PATH), "page_count": 19, "page_size": "11x8.5in US Letter landscape"},
            "design_md": {"path": str(DESIGN_PATH.relative_to(BRAND_DIR)), "bytes": DESIGN_PATH.stat().st_size, "sha256": sha256(DESIGN_PATH)},
            "source_preview_count": len(source_previews),
            "pdf_preview_count": len(pdf_previews),
            "preview_dimensions": "2112x1632",
            "mockups": mockup_records,
            "font_file_count": len(FONT_FILES),
            "font_license_count": len(LICENSE_FILES),
            "token_files": token_records,
            "css_token_path": str(css_tokens.relative_to(PACKET_DIR)),
            "mayven_reference_page_count": len(mayven_pages),
        },
        "source_integrity": {
            "local_reference_count": len(local_refs),
            "resolved_inside_company_brand": resolved_refs,
            "missing_references": [],
            "external_references": [],
            "copied_reference_terms_in_final_html": 0,
            "literal_off-token_page_css_colors": 0,
            "complete_icon_recommended_at_16px": False,
        },
        "visual_verification": {
            "source_contact_sheet": "brandbook-packet/references/t008-source-contact-sheet.png",
            "mayven_comparison": "brandbook-packet/references/t008-mayven-comparison-contact-sheet.png",
            "pdf_contact_sheet": "brandbook-packet/pages/contact-sheet.png",
            "pdf_original_resolution_pages_inspected": t010["visual_review"]["original_resolution_pages"],
            "remaining_visual_defects": 0,
        },
        "operating_memory": {
            "plan": str(PLAN_PATH.relative_to(REPO_DIR)),
            "activity": str(ACTIVITY_PATH.relative_to(REPO_DIR)),
            "run_log": str(RUN_LOG_PATH.relative_to(REPO_DIR)),
            "progress": str(PROGRESS_PATH.relative_to(REPO_DIR)),
            "current": True,
        },
        "caveats": [
            "Magic Mirror is a hackathon working title.",
            "Social and company/profile mockups are concepts and do not imply live accounts.",
            "Natural environmental colors in raster mockups are contextual photography, not reusable brand tokens.",
            "Mayven is composition authority only; its identity, copy, colors, and travel imagery are not Magic Mirror assets.",
        ],
        "decision": "Accepted the complete Magic Mirror brandbook packet after verifying all 12 tasks and evidence notes, the 19-page PDF, 38 source/PDF previews, eight ImageGen mockups, source and reference boundaries, fonts and licenses, tokens and WCAG data, DESIGN.md links, Mayven composition audit, final visual review, and company operating-memory updates.",
    }
    AUDIT_PATH.write_text(json.dumps(audit, indent=2) + "\n", encoding="utf-8")
    print("T012 passed: 12 tasks, 19-page PDF, 38 previews, 8 mockups, complete packet and operating memory")


if __name__ == "__main__":
    main()
