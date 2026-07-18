#!/usr/bin/env python3
import hashlib
import json
import struct
from datetime import datetime, timezone
from pathlib import Path

from pypdf import PdfReader

SOURCE_DIR = Path(__file__).resolve().parent
PACKET_DIR = SOURCE_DIR.parent
PDF_PATH = PACKET_DIR / "Magic-Mirror-Brandbook.pdf"
SOURCE_PREVIEW_DIR = PACKET_DIR / "pages" / "source"
PDF_PREVIEW_DIR = PACKET_DIR / "pages" / "pdf"
CONTACT_SHEET_PATH = PACKET_DIR / "pages" / "contact-sheet.png"
AUDIT_PATH = PACKET_DIR / "references" / "t010-audit.json"

EXPECTED_TEXT = [
    "LOGO ON DARK BACKGROUND",
    "LOGO ON LIGHT BACKGROUND",
    "Magic Mirror brand standards.",
    "Use the simplest approved signature.",
    "Protect recognition by keeping the artwork intact.",
    "Acid energy, grounded by Ink.",
    "Build depth from approved anchors.",
    "Make the next action obvious.",
    "Editorial structure with technical signals.",
    "Contrast decisions, calculated.",
    "Compact, confident, easy to remember.",
    "High visibility for virtual try-on.",
    "Use the app icon in browser chrome.",
    "A recognizable X profile for the prototype.",
    "Professional context, platform-specific structure.",
    "On dark fabric, use the Acid icon.",
    "Useful objects should still feel editorial.",
    "Instrument Serif character, Space Grotesk clarity.",
    "Readability beats decorative noise.",
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


def page_number(path: Path) -> int:
    return int(path.stem.split("-")[-1])


def main():
    assert PDF_PATH.is_file() and PDF_PATH.stat().st_size > 0
    reader = PdfReader(str(PDF_PATH))
    assert len(reader.pages) == 19, f"Expected 19 PDF pages, found {len(reader.pages)}"

    page_text = []
    page_boxes = []
    for index, page in enumerate(reader.pages):
        width = float(page.mediabox.width)
        height = float(page.mediabox.height)
        assert abs(width - 792.0) <= 0.5 and abs(height - 612.0) <= 0.5, f"Page {index + 1} has unexpected media box {width}x{height}"
        text = page.extract_text() or ""
        assert EXPECTED_TEXT[index] in text, f"Page {index + 1} missing expected text: {EXPECTED_TEXT[index]}"
        assert f"{index + 1:02d}" in text, f"Page {index + 1} missing folio"
        page_text.append(text)
        page_boxes.append({"page": index + 1, "width_pt": width, "height_pt": height})

    source_previews = sorted(SOURCE_PREVIEW_DIR.glob("page-*.png"))
    pdf_previews = sorted(PDF_PREVIEW_DIR.glob("page-*.png"), key=page_number)
    assert len(source_previews) == 19
    assert len(pdf_previews) == 19

    preview_records = []
    for index, path in enumerate(pdf_previews, start=1):
        assert path.name == f"page-{index:02d}.png"
        width, height = png_dimensions(path)
        assert (width, height) == (2112, 1632), f"Unexpected PDF preview dimensions: {path.name} {width}x{height}"
        preview_records.append({
            "page": index,
            "path": str(path.relative_to(PACKET_DIR)),
            "width_px": width,
            "height_px": height,
            "bytes": path.stat().st_size,
            "sha256": sha256(path),
        })

    assert CONTACT_SHEET_PATH.is_file() and CONTACT_SHEET_PATH.stat().st_size > 0
    contact_width, contact_height = png_dimensions(CONTACT_SHEET_PATH)
    assert (contact_width, contact_height) == (1320, 816)

    audit = {
        "task_id": "T010",
        "status": "passed",
        "verified_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
        "pdf": {
            "path": str(PDF_PATH.relative_to(PACKET_DIR)),
            "bytes": PDF_PATH.stat().st_size,
            "sha256": sha256(PDF_PATH),
            "page_count": len(reader.pages),
            "page_size_points": {"width": 792.0, "height": 612.0},
            "page_size_inches": {"width": 11.0, "height": 8.5},
            "page_boxes": page_boxes,
            "expected_text_checks": len(EXPECTED_TEXT),
            "missing_expected_text": 0,
            "missing_folios": 0,
        },
        "previews": {
            "source_count": len(source_previews),
            "pdf_rendered_count": len(pdf_previews),
            "pdf_render_dpi": 192,
            "pdf_render_dimensions": "2112x1632",
            "files": preview_records,
            "contact_sheet": {
                "path": str(CONTACT_SHEET_PATH.relative_to(PACKET_DIR)),
                "width_px": contact_width,
                "height_px": contact_height,
                "bytes": CONTACT_SHEET_PATH.stat().st_size,
                "sha256": sha256(CONTACT_SHEET_PATH),
            },
        },
        "visual_review": {
            "method": "Full PDF-derived contact-sheet review followed by original-resolution inspection of identity, dense system, all application, accessibility, and typography pages.",
            "contact_sheet_reviewed": True,
            "original_resolution_pages": [1, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
            "results": {
                "clipped_or_overlapping_text": 0,
                "broken_or_missing_images": 0,
                "black_square_or_glyph_failures": 0,
                "unreadable_tables_or_labels": 0,
                "mockup_crop_failures": 0,
                "header_footer_or_folio_failures": 0,
                "section_transition_failures": 0,
                "passed": True,
            },
        },
        "resolved_defects": [
            "Updated the paused renderer from the superseded 1600x1000 editorial canvas to the approved US Letter landscape canvas and 192-DPI PDF preview dimensions.",
            "Replaced Unicode dash glyphs in PDF-visible source text with ASCII hyphens for predictable extraction and rendering.",
            "Moved the browser mockup crop to the top edge so both light and dark examples visibly retain the favicon, tab title, navigation controls, and address bar."
        ],
        "decision": "Accepted the final 19-page PDF and its PDF-derived previews. The PDF opens, every page has the expected 792x612-point US Letter landscape media box, representative text and all folios extract correctly, exactly 19 2112x1632 PDF previews and 19 source previews exist, and direct visual review found no formatting or rendering defects.",
    }
    AUDIT_PATH.write_text(json.dumps(audit, indent=2) + "\n", encoding="utf-8")
    print(f"T010 passed: {len(reader.pages)} PDF pages, {PDF_PATH.stat().st_size} bytes, {len(pdf_previews)} PDF previews")


if __name__ == "__main__":
    main()
