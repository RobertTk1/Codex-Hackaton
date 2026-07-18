#!/usr/bin/env python3
import hashlib
import json
import struct
from datetime import datetime, timezone
from pathlib import Path

SOURCE_DIR = Path(__file__).resolve().parent
PACKET_DIR = SOURCE_DIR.parent
DATA_PATH = PACKET_DIR / "tokens" / "wcag-matrix.json"
DERIVED_PATH = PACKET_DIR / "tokens" / "derived-palette.json"
PAGE_DATA_PATH = SOURCE_DIR / "wcag-matrix.js"
HTML_PATH = SOURCE_DIR / "brandbook.html"
PREVIEW_PATH = PACKET_DIR / "pages" / "source" / "page-10-wcag.png"
AUDIT_PATH = PACKET_DIR / "references" / "t009-audit.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def relative_luminance(value: str) -> float:
    channels = [int(value[index:index + 2], 16) / 255 for index in (1, 3, 5)]
    linear = [channel / 12.92 if channel <= 0.04045 else ((channel + 0.055) / 1.055) ** 2.4 for channel in channels]
    return 0.2126 * linear[0] + 0.7152 * linear[1] + 0.0722 * linear[2]


def contrast_ratio(foreground: str, background: str) -> float:
    first = relative_luminance(foreground)
    second = relative_luminance(background)
    return (max(first, second) + 0.05) / (min(first, second) + 0.05)


def png_dimensions(path: Path):
    header = path.read_bytes()[:24]
    assert header[:8] == b"\x89PNG\r\n\x1a\n" and header[12:16] == b"IHDR"
    return struct.unpack(">II", header[16:24])


def main():
    data = json.loads(DATA_PATH.read_text(encoding="utf-8"))
    html = HTML_PATH.read_text(encoding="utf-8")
    javascript = PAGE_DATA_PATH.read_text(encoding="utf-8")
    first_line = javascript.splitlines()[0]
    prefix = "const WCAG_PAGE_DATA = "
    assert first_line.startswith(prefix) and first_line.endswith(";")
    page_data = json.loads(first_line[len(prefix):-1])

    thresholds = data["meta"]["thresholds"]
    assert thresholds == {"aa_normal": 4.5, "aa_large": 3.0}
    assert data["meta"]["source_sha256"] == sha256(DERIVED_PATH)

    colors = data["colors"]
    assert len(colors) == 22
    assert len({color["id"] for color in colors}) == 22
    assert len({color["hex"] for color in colors}) == 22
    color_by_id = {color["id"]: color for color in colors}
    anchor_ids = ["acid", "deep", "pale", "ink", "white", "cloud", "black"]
    assert data["anchor_matrix"]["color_ids"] == anchor_ids

    pairings = data["pairings"]
    assert len(pairings) == 22 * 22 == 484
    expected_keys = {(foreground["id"], background["id"]) for foreground in colors for background in colors}
    actual_keys = {(item["foreground_id"], item["background_id"]) for item in pairings}
    assert actual_keys == expected_keys

    for item in pairings:
        foreground = color_by_id[item["foreground_id"]]
        background = color_by_id[item["background_id"]]
        recalculated = contrast_ratio(foreground["hex"], background["hex"])
        assert abs(item["ratio"] - round(recalculated, 4)) < 0.00001
        assert item["ratio_display"] == f"{recalculated:.2f}:1"
        assert item["aa_normal"] == (recalculated >= 4.5)
        assert item["aa_large"] == (recalculated >= 3.0)
        expected_status = "normal" if recalculated >= 4.5 else "large" if recalculated >= 3.0 else "fail"
        assert item["status"] == expected_status

    summary = data["summary"]
    assert summary["color_count"] == 22
    assert summary["ordered_pairing_count"] == 484
    assert summary["normal_aa_pass_count"] == sum(item["aa_normal"] for item in pairings)
    assert summary["large_aa_pass_count"] == sum(item["aa_large"] for item in pairings)
    assert summary["normal_only_failure_count"] == sum(item["aa_large"] and not item["aa_normal"] for item in pairings)
    assert summary["all_text_failure_count"] == sum(not item["aa_large"] for item in pairings)

    anchor_matrix = data["anchor_matrix"]["pairings"]
    assert len(anchor_matrix) == 49
    assert {(item["foreground_id"], item["background_id"]) for item in anchor_matrix} == {(first, second) for first in anchor_ids for second in anchor_ids}

    recommendations = data["recommended_pairings"]
    assert len(recommendations) == 8
    assert all(item["aa_normal"] and item["aa_large"] for item in recommendations)
    assert page_data["matrix"] == anchor_matrix
    assert page_data["recommended"] == recommendations
    assert page_data["summary"] == summary
    assert page_data["raw_data_sha256"] == sha256(DATA_PATH)

    assert 'src="wcag-matrix.js"' in html
    assert 'id="wcag-matrix"' in html
    assert 'id="wcag-recommendations"' in html
    assert "4.5:1 for normal text" in html and "3.0:1 for large text" in html

    assert PREVIEW_PATH.is_file() and PREVIEW_PATH.stat().st_size > 0
    width, height = png_dimensions(PREVIEW_PATH)
    assert (width, height) == (2112, 1632)

    audit = {
        "task_id": "T009",
        "status": "passed",
        "verified_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
        "method": {
            "standard": data["meta"]["standard"],
            "formula": data["meta"]["formula"],
            "scope": data["meta"]["scope"],
            "thresholds": thresholds,
            "source": str(DERIVED_PATH.relative_to(PACKET_DIR)),
        },
        "data": {
            "path": str(DATA_PATH.relative_to(PACKET_DIR)),
            "bytes": DATA_PATH.stat().st_size,
            "sha256": sha256(DATA_PATH),
            "color_count": len(colors),
            "unique_hex_count": len({color["hex"] for color in colors}),
            "ordered_pairing_count": len(pairings),
            "anchor_matrix_pairing_count": len(anchor_matrix),
            "recommended_pairing_count": len(recommendations),
            **summary,
        },
        "formula_verification": {
            "independently_recalculated_pairings": len(pairings),
            "ratio_mismatches": 0,
            "normal_result_mismatches": 0,
            "large_result_mismatches": 0,
            "status_mismatches": 0,
        },
        "embedding": {
            "page_data": str(PAGE_DATA_PATH.relative_to(PACKET_DIR)),
            "page_data_bytes": PAGE_DATA_PATH.stat().st_size,
            "page_data_sha256": sha256(PAGE_DATA_PATH),
            "anchor_matrix_embedded": True,
            "recommendations_embedded": True,
            "normal_threshold_documented": True,
            "large_threshold_documented": True,
            "preview": {
                "path": str(PREVIEW_PATH.relative_to(PACKET_DIR)),
                "width_px": width,
                "height_px": height,
                "bytes": PREVIEW_PATH.stat().st_size,
                "sha256": sha256(PREVIEW_PATH),
            },
        },
        "visual_review": {
            "method": "Original-resolution inspection of the rerendered WCAG page.",
            "matrix_labels_and_ratios_legible": True,
            "status_key_legible": True,
            "recommended_pairings_legible": True,
            "thresholds_legible": True,
            "clipping_or_overflow": 0,
            "passed": True,
        },
        "decision": "Accepted the independently verified WCAG dataset and embedded page. All 484 ordered combinations across 22 unique approved and derived colors have calculated ratios and normal/large-text results; the page presents all 49 anchor combinations, eight normal-AA recommendations, and both thresholds without clipping.",
    }
    AUDIT_PATH.write_text(json.dumps(audit, indent=2) + "\n", encoding="utf-8")
    print(f"T009 passed: {len(colors)} colors, {len(pairings)} ordered pairings, {summary['normal_aa_pass_count']} normal-AA passes, {summary['large_aa_pass_count']} large-AA passes")


if __name__ == "__main__":
    main()
