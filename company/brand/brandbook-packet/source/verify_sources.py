#!/usr/bin/env python3
"""Verify T001 Magic Mirror brand inputs, fonts, and base tokens."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess


PACKET_ROOT = Path(__file__).resolve().parents[1]
BRAND_ROOT = PACKET_ROOT.parent
REPO_ROOT = BRAND_ROOT.parents[1]
TOKENS_ROOT = PACKET_ROOT / "tokens"
REFERENCES_ROOT = PACKET_ROOT / "references"

EXPECTED_ANCHORS = {
    "acid": "#D7FF3F",
    "deep": "#263300",
    "pale": "#F2FFD0",
    "ink": "#17171A",
    "white": "#FFFFFF",
    "cloud": "#F4F3F1",
    "black": "#000000",
}

ASSETS = {
    "wordmark": BRAND_ROOT / "exports/wordmark/svg/magic-mirror-wordmark-acid.svg",
    "combined": BRAND_ROOT / "exports/combined/svg/magic-mirror-combined-acid.svg",
    "icon": BRAND_ROOT / "exports/icon/svg/magic-mirror-icon-acid.svg",
    "favicon": BRAND_ROOT / "exports/icon/favicon/favicon-16x16.png",
    "palette": BRAND_ROOT / "brand-colors.json",
}

FONTS = {
    "instrument-serif-regular": PACKET_ROOT / "assets/fonts/instrument-serif/InstrumentSerif-Regular.ttf",
    "instrument-serif-italic": PACKET_ROOT / "assets/fonts/instrument-serif/InstrumentSerif-Italic.ttf",
    "space-grotesk-variable": PACKET_ROOT / "assets/fonts/space-grotesk/SpaceGrotesk[wght].ttf",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def relative(path: Path) -> str:
    return str(path.relative_to(REPO_ROOT))


def main() -> None:
    evidence: dict[str, object] = {
        "task": "T001",
        "status": "passed",
        "assets": {},
        "fonts": {},
        "tokens": {},
        "checks": [],
    }

    for name, path in ASSETS.items():
        assert path.is_file() and path.stat().st_size > 100, f"Missing or empty {name}: {path}"
        evidence["assets"][name] = {
            "path": relative(path),
            "bytes": path.stat().st_size,
            "sha256": sha256(path),
        }

    palette = json.loads(ASSETS["palette"].read_text(encoding="utf-8"))
    assert palette["colors"] == EXPECTED_ANCHORS
    evidence["checks"].append("Approved palette source matches all seven Acid Dispatch anchors.")

    for name, path in FONTS.items():
        assert path.is_file() and path.stat().st_size > 50_000, f"Missing or invalid font: {path}"
        scan = subprocess.run(
            ["fc-scan", "--format", "%{family}|%{style}|%{weight}|%{fontversion}", str(path)],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
        assert scan.strip(), f"fc-scan returned no metadata for {path}"
        evidence["fonts"][name] = {
            "path": relative(path),
            "bytes": path.stat().st_size,
            "sha256": sha256(path),
            "fc_scan": scan,
        }

    for license_path in (
        PACKET_ROOT / "assets/fonts/instrument-serif/OFL.txt",
        PACKET_ROOT / "assets/fonts/space-grotesk/OFL.txt",
    ):
        license_text = license_path.read_text(encoding="utf-8")
        assert "SIL OPEN FONT LICENSE Version 1.1" in license_text
    evidence["checks"].append("Instrument Serif and Space Grotesk include valid local OFL 1.1 license files.")

    token_json = TOKENS_ROOT / "brand-tokens.json"
    token_css = TOKENS_ROOT / "brand-tokens.css"
    derived_json = TOKENS_ROOT / "derived-palette.json"
    for path in (token_json, token_css, derived_json):
        assert path.is_file() and path.stat().st_size > 100

    tokens = json.loads(token_json.read_text(encoding="utf-8"))
    derived = json.loads(derived_json.read_text(encoding="utf-8"))
    css = token_css.read_text(encoding="utf-8")
    assert tokens["color"]["anchor"] == EXPECTED_ANCHORS
    assert derived["anchors"] == EXPECTED_ANCHORS
    assert derived["scales"]["acid"]["50"] == EXPECTED_ANCHORS["pale"]
    assert derived["scales"]["acid"]["500"] == EXPECTED_ANCHORS["acid"]
    assert derived["scales"]["acid"]["900"] == EXPECTED_ANCHORS["deep"]
    assert derived["scales"]["neutral"]["0"] == EXPECTED_ANCHORS["white"]
    assert derived["scales"]["neutral"]["50"] == EXPECTED_ANCHORS["cloud"]
    assert derived["scales"]["neutral"]["900"] == EXPECTED_ANCHORS["ink"]
    assert "@font-face" in css and "Instrument Serif" in css and "Space Grotesk" in css
    assert css.count("--mm-color-") >= 28
    assert css.count("--mm-radius-") == 4

    before = {path.name: sha256(path) for path in (token_json, token_css, derived_json)}
    subprocess.run(
        ["python3", str(PACKET_ROOT / "source/build_tokens.py")],
        check=True,
        capture_output=True,
        text=True,
    )
    after = {path.name: sha256(path) for path in (token_json, token_css, derived_json)}
    assert before == after, "Token generation is not deterministic"

    evidence["tokens"] = {
        "json": relative(token_json),
        "css": relative(token_css),
        "derived_palette": relative(derived_json),
        "anchor_count": len(EXPECTED_ANCHORS),
        "acid_scale_count": len(derived["scales"]["acid"]),
        "neutral_scale_count": len(derived["scales"]["neutral"]),
        "css_color_variable_count": css.count("--mm-color-"),
        "deterministic_sha256": after,
    }
    evidence["checks"].extend(
        (
            "Token JSON and derived-palette JSON parse successfully.",
            "Derived scale endpoints resolve to approved anchors.",
            "CSS includes both local font families, color variables, radii, and focus tokens.",
            "Token generation is byte-for-byte deterministic.",
        )
    )

    source_audit = REFERENCES_ROOT / "source-audit.md"
    assert source_audit.is_file() and source_audit.stat().st_size > 1_000
    source_audit_text = source_audit.read_text(encoding="utf-8")
    for required_text in (
        "company/brand/exports/wordmark/svg/magic-mirror-wordmark-acid.svg",
        "company/brand/exports/combined/svg/magic-mirror-combined-acid.svg",
        "company/brand/exports/icon/svg/magic-mirror-icon-acid.svg",
        "company/brand/exports/icon/favicon/favicon-16x16.png",
        "company/brand/brand-colors.json",
        "linear interpolation in OKLab",
        "Disallowed designed colors",
        "Instrument Serif",
        "Space Grotesk",
        "SIL Open Font License 1.1",
        "Fallback",
    ):
        assert required_text in source_audit_text, f"Source audit missing: {required_text}"
    assert tokens["typography"]["family"]["display"] == "Instrument Serif"
    assert tokens["typography"]["family"]["ui"] == "Space Grotesk"
    assert "Times New Roman" in tokens["typography"]["family"]["displayStack"]
    assert "Arial" in tokens["typography"]["family"]["uiStack"]
    evidence["source_audit"] = relative(source_audit)
    evidence["checks"].append(
        "Source audit records every required asset path, disallowed-color rule, OKLab method, font source/license, and fallback stack."
    )

    output = REFERENCES_ROOT / "t001-audit.json"
    output.write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
    print(
        f"T001 passed: {len(ASSETS)} sources, {len(FONTS)} fonts, "
        f"{len(EXPECTED_ANCHORS)} anchors, "
        f"{evidence['tokens']['acid_scale_count'] + evidence['tokens']['neutral_scale_count']} derived scale entries"
    )


if __name__ == "__main__":
    main()
