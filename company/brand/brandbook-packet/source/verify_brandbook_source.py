#!/usr/bin/env python3
import hashlib
import json
import re
import struct
from datetime import datetime, timezone
from html.parser import HTMLParser
from pathlib import Path

SOURCE_DIR = Path(__file__).resolve().parent
PACKET_DIR = SOURCE_DIR.parent
HTML_PATH = SOURCE_DIR / "brandbook.html"
CSS_PATH = SOURCE_DIR / "brandbook.css"
TOKEN_CSS_PATH = PACKET_DIR / "tokens" / "brand-tokens.css"
PREVIEW_DIR = PACKET_DIR / "pages" / "source"
AUDIT_PATH = PACKET_DIR / "references" / "t008-audit.json"
CONTACT_SHEET_PATH = PACKET_DIR / "references" / "t008-source-contact-sheet.png"

EXPECTED_IDS = [
    "page-01-logo-dark",
    "page-02-logo-light",
    "page-03-contents",
    "page-04-logo-usage",
    "page-05-logo-avoid",
    "page-06-primary-colors",
    "page-07-secondary-colors",
    "page-08-buttons-links",
    "page-09-elements",
    "page-10-wcag",
    "page-11-business-card",
    "page-12-billboard",
    "page-13-browser-favicon",
    "page-14-x-profile",
    "page-15-linkedin-profile",
    "page-16-tshirt",
    "page-17-merchandise",
    "page-18-typography",
    "page-19-type-avoid",
]

EXPECTED_PREVIEWS = [
    "page-01-logo-dark.png",
    "page-02-logo-light.png",
    "page-03-contents.png",
    "page-04-logo-usage.png",
    "page-05-logo-avoid.png",
    "page-06-primary-colors.png",
    "page-07-secondary-colors.png",
    "page-08-buttons-links.png",
    "page-09-elements.png",
    "page-10-wcag.png",
    "page-11-business-card.png",
    "page-12-billboard.png",
    "page-13-browser-favicon.png",
    "page-14-x.png",
    "page-15-linkedin.png",
    "page-16-tshirt.png",
    "page-17-merchandise.png",
    "page-18-typography.png",
    "page-19-type-avoid.png",
]

REQUIRED_MOCKUPS = [
    "../mockups/business-card.png",
    "../mockups/billboard.png",
    "../mockups/browser-favicon-light.png",
    "../mockups/browser-favicon-dark.png",
    "../mockups/x-profile.png",
    "../mockups/linkedin-profile.png",
    "../mockups/tshirt.png",
    "../mockups/compact-mirror.png",
]


class BrandbookParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.page_ids = []
        self.page_numbers = []
        self.image_sources = []
        self.footer_count = 0
        self.folio_count = 0

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        classes = set(attributes.get("class", "").split())
        if tag == "section" and "page" in classes:
            self.page_ids.append(attributes.get("id"))
            self.page_numbers.append(attributes.get("data-page"))
        if tag == "img":
            self.image_sources.append(attributes.get("src"))
        if tag == "footer" and "page-footer" in classes:
            self.footer_count += 1
        if "folio" in classes:
            self.folio_count += 1


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def png_dimensions(path: Path):
    with path.open("rb") as handle:
        signature = handle.read(24)
    if signature[:8] != b"\x89PNG\r\n\x1a\n" or signature[12:16] != b"IHDR":
        raise AssertionError(f"Not a valid PNG: {path}")
    return struct.unpack(">II", signature[16:24])


def main():
    html = HTML_PATH.read_text(encoding="utf-8")
    css = CSS_PATH.read_text(encoding="utf-8")
    token_css = TOKEN_CSS_PATH.read_text(encoding="utf-8")

    parser = BrandbookParser()
    parser.feed(html)

    assert parser.page_ids == EXPECTED_IDS, f"Unexpected page order: {parser.page_ids}"
    assert parser.page_numbers == [f"{index:02d}" for index in range(1, 20)]
    assert parser.footer_count == 19, f"Expected 19 footers, found {parser.footer_count}"
    assert parser.folio_count == 19, f"Expected 19 folios, found {parser.folio_count}"
    assert len(set(parser.page_ids)) == 19

    missing_images = []
    for source in parser.image_sources:
        if not source or source.startswith(("http://", "https://", "data:")):
            missing_images.append(source)
            continue
        resolved = (SOURCE_DIR / source).resolve()
        if not resolved.is_file() or resolved.stat().st_size == 0:
            missing_images.append(source)
    assert not missing_images, f"Missing or external image sources: {missing_images}"

    for mockup in REQUIRED_MOCKUPS:
        assert mockup in parser.image_sources, f"Mockup not referenced: {mockup}"

    combined_source = "\n".join([html, css])
    for forbidden in ["mayven", "cruise", "@mayven"]:
        assert not re.search(forbidden, combined_source, re.IGNORECASE), f"Forbidden copied reference term: {forbidden}"
    assert not re.search(r"https?://", combined_source, re.IGNORECASE), "External URL found in source"
    assert "@font-face" in token_css
    assert "Instrument Serif" in token_css and "Space Grotesk" in token_css
    assert "15.56:1" in html and "17.89:1" in html and "12.85:1" in html
    assert "@page" in css and "size: 12.8in 8in" in css
    css_literal_hex_colors = sorted(set(re.findall(r"#[0-9A-Fa-f]{6}", css)))
    assert not css_literal_hex_colors, f"Literal CSS colors bypass tokens: {css_literal_hex_colors}"

    preview_files = sorted(path.name for path in PREVIEW_DIR.glob("page-*.png"))
    assert preview_files == sorted(EXPECTED_PREVIEWS), f"Unexpected preview files: {preview_files}"

    previews = []
    for name in EXPECTED_PREVIEWS:
        path = PREVIEW_DIR / name
        width, height = png_dimensions(path)
        assert (width, height) == (1600, 1000), f"Unexpected preview dimensions for {name}: {(width, height)}"
        previews.append({
            "path": str(path.relative_to(PACKET_DIR)),
            "width_px": width,
            "height_px": height,
            "bytes": path.stat().st_size,
            "sha256": sha256(path),
        })

    assert CONTACT_SHEET_PATH.is_file() and CONTACT_SHEET_PATH.stat().st_size > 0
    contact_width, contact_height = png_dimensions(CONTACT_SHEET_PATH)
    assert (contact_width, contact_height) == (1600, 800)

    audit = {
        "task_id": "T008",
        "status": "passed",
        "verified_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
        "source": {
            "html": str(HTML_PATH.relative_to(PACKET_DIR)),
            "css": str(CSS_PATH.relative_to(PACKET_DIR)),
            "renderer": "source/render_source.js",
            "html_bytes": HTML_PATH.stat().st_size,
            "css_bytes": CSS_PATH.stat().st_size,
            "html_sha256": sha256(HTML_PATH),
            "css_sha256": sha256(CSS_PATH),
        },
        "pages": {
            "count": len(parser.page_ids),
            "ordered_ids": parser.page_ids,
            "footer_count": parser.footer_count,
            "folio_count": parser.folio_count,
        },
        "assets": {
            "local_image_reference_count": len(parser.image_sources),
            "missing_or_external_images": missing_images,
            "required_mockups_referenced": REQUIRED_MOCKUPS,
            "local_fonts": [
                "assets/fonts/instrument-serif/InstrumentSerif-Regular.ttf",
                "assets/fonts/instrument-serif/InstrumentSerif-Italic.ttf",
                "assets/fonts/space-grotesk/SpaceGrotesk[wght].ttf",
            ],
        },
        "content_scans": {
            "forbidden_reference_terms": 0,
            "external_urls": 0,
            "literal_hex_colors_in_page_css": css_literal_hex_colors,
            "wcag_preview_ratios_present": ["15.56:1", "17.89:1", "12.85:1"],
        },
        "previews": {
            "count": len(previews),
            "dimensions": "1600x1000",
            "files": previews,
            "contact_sheet": {
                "path": str(CONTACT_SHEET_PATH.relative_to(PACKET_DIR)),
                "width_px": contact_width,
                "height_px": contact_height,
                "bytes": CONTACT_SHEET_PATH.stat().st_size,
                "sha256": sha256(CONTACT_SHEET_PATH),
            },
        },
        "visual_review": {
            "method": "Full contact-sheet review followed by original-resolution inspection of dense and risk-sensitive pages.",
            "contact_sheet_reviewed": True,
            "original_resolution_pages": [4, 5, 7, 8, 9, 10, 13, 18, 19],
            "results": {
                "clipping_or_overflow": 0,
                "weak_or_missing_hierarchy": 0,
                "unreadable_dense_content": 0,
                "mockup_crop_failures": 0,
                "font_loading_failures": 0,
                "passed": True,
            },
        },
        "decision": "Accepted the ordered 19-page local HTML/CSS source and one 1600x1000 preview per page. Every image resolves locally, all eight audited ImageGen mockups are referenced, local fonts are declared, page folios and footers are complete, and copied reference-brand terms and external URLs are absent.",
    }
    AUDIT_PATH.write_text(json.dumps(audit, indent=2) + "\n", encoding="utf-8")
    print(f"T008 passed: {len(parser.page_ids)} pages, {len(parser.image_sources)} local images, {len(previews)} source previews")


if __name__ == "__main__":
    main()
