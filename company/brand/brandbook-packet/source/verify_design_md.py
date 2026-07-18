#!/usr/bin/env python3
import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import unquote

SOURCE_DIR = Path(__file__).resolve().parent
PACKET_DIR = SOURCE_DIR.parent
DESIGN_PATH = PACKET_DIR / "DESIGN.md"
TOKENS_PATH = PACKET_DIR / "tokens" / "brand-tokens.json"
WCAG_PATH = PACKET_DIR / "tokens" / "wcag-matrix.json"
PDF_PATH = PACKET_DIR / "Magic-Mirror-Brandbook.pdf"
AUDIT_PATH = PACKET_DIR / "references" / "t011-audit.json"

REQUIRED_SECTIONS = [
    "Brand summary",
    "Source assets",
    "Logo system",
    "Logo usage rules",
    "What to avoid",
    "Primary palette",
    "Secondary shades and tints",
    "WCAG-approved pairings",
    "Buttons and links",
    "Badges, callouts, headers, and tooltips",
    "Typography system",
    "Typography to avoid",
    "Application examples",
    "Production notes and caveats",
]

REQUIRED_MOCKUPS = [
    "mockups/business-card.png",
    "mockups/billboard.png",
    "mockups/browser-favicon-light.png",
    "mockups/browser-favicon-dark.png",
    "mockups/x-profile.png",
    "mockups/linkedin-profile.png",
    "mockups/tshirt.png",
    "mockups/compact-mirror.png",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main():
    assert DESIGN_PATH.is_file() and DESIGN_PATH.stat().st_size > 0
    assert PDF_PATH.is_file() and PDF_PATH.stat().st_size > 0
    text = DESIGN_PATH.read_text(encoding="utf-8")

    headings = re.findall(r"^## \d+\. (.+)$", text, flags=re.MULTILINE)
    assert headings == REQUIRED_SECTIONS, f"Unexpected DESIGN.md section sequence: {headings}"

    link_targets = re.findall(r"\[[^\]]+\]\(([^)]+)\)", text)
    local_targets = [target for target in link_targets if not re.match(r"^[a-z]+://", target)]
    missing_links = []
    resolved_links = []
    for target in local_targets:
        clean_target = unquote(target.split("#", 1)[0])
        resolved = (PACKET_DIR / clean_target).resolve()
        if not resolved.exists():
            missing_links.append(target)
        else:
            resolved_links.append(str(resolved.relative_to(PACKET_DIR.parent.parent)))
    assert not missing_links, f"Missing local links: {missing_links}"

    tokens = json.loads(TOKENS_PATH.read_text(encoding="utf-8"))
    anchors = tokens["color"]["anchor"]
    for name, value in anchors.items():
        assert value in text, f"DESIGN.md missing anchor {name}: {value}"

    for family in ("Instrument Serif", "Space Grotesk"):
        assert family in text, f"DESIGN.md missing typography family: {family}"

    wcag = json.loads(WCAG_PATH.read_text(encoding="utf-8"))
    recommended = wcag["recommended_pairings"]
    for pairing in recommended:
        assert pairing["label"] in text, f"DESIGN.md missing WCAG pair: {pairing['label']}"
        assert pairing["ratio_display"] in text, f"DESIGN.md missing WCAG ratio: {pairing['ratio_display']}"

    for relative in REQUIRED_MOCKUPS:
        assert f"./{relative}" in text, f"DESIGN.md missing mockup link: {relative}"
        assert (PACKET_DIR / relative).is_file() and (PACKET_DIR / relative).stat().st_size > 0

    required_phrases = [
        "working name Magic Mirror",
        "Simplified favicon",
        "32 px and above",
        "16 px",
        "Twitter/X",
        "LinkedIn-specific",
        "US Letter landscape",
        "19 pages",
        "ImageGen",
    ]
    for phrase in required_phrases:
        assert phrase in text, f"DESIGN.md missing required phrase: {phrase}"

    audit = {
        "task_id": "T011",
        "status": "passed",
        "verified_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
        "design_md": {
            "path": str(DESIGN_PATH.relative_to(PACKET_DIR)),
            "bytes": DESIGN_PATH.stat().st_size,
            "sha256": sha256(DESIGN_PATH),
            "required_section_count": len(REQUIRED_SECTIONS),
            "required_sections": REQUIRED_SECTIONS,
        },
        "links": {
            "markdown_link_count": len(link_targets),
            "local_link_count": len(local_targets),
            "resolved_local_link_count": len(resolved_links),
            "missing_local_links": missing_links,
        },
        "consistency": {
            "anchor_count": len(anchors),
            "anchors_matched": anchors,
            "font_families_matched": ["Instrument Serif", "Space Grotesk"],
            "recommended_wcag_pair_count": len(recommended),
            "recommended_wcag_pairs_matched": [pairing["label"] for pairing in recommended],
            "required_mockup_count": len(REQUIRED_MOCKUPS),
            "required_mockups_matched": REQUIRED_MOCKUPS,
            "pdf_sha256": sha256(PDF_PATH),
        },
        "caveats": [
            "Magic Mirror remains a hackathon working title.",
            "Social and company/profile examples are concepts and do not imply live accounts.",
            "Natural colors in raster mockups are contextual photography, not reusable brand tokens.",
        ],
        "decision": "Accepted DESIGN.md after verifying all 14 required sections, every local link, all approved anchors, both font families, all eight WCAG recommendations, all eight final mockups, production notes, and prototype caveats against the final packet.",
    }
    AUDIT_PATH.write_text(json.dumps(audit, indent=2) + "\n", encoding="utf-8")
    print(f"T011 passed: {len(REQUIRED_SECTIONS)} sections, {len(local_targets)} local links, {len(REQUIRED_MOCKUPS)} mockups")


if __name__ == "__main__":
    main()
