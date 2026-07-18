#!/usr/bin/env python3
"""Verify T002 Magic Mirror 19-page asset and mockup plan."""

from __future__ import annotations

import json
from pathlib import Path
import re


PACKET_ROOT = Path(__file__).resolve().parents[1]
BRAND_ROOT = PACKET_ROOT.parent
REPO_ROOT = BRAND_ROOT.parents[1]
PLAN = PACKET_ROOT / "asset-plan.md"

REQUIRED_INPUTS = (
    "company/brand/exports/wordmark/png/transparent/acid/magic-mirror-wordmark-acid-2048px.png",
    "company/brand/exports/wordmark/png/transparent/ink/magic-mirror-wordmark-ink-2048px.png",
    "company/brand/exports/combined/png/transparent/acid/magic-mirror-combined-acid-2048px.png",
    "company/brand/exports/combined/png/transparent/ink/magic-mirror-combined-ink-2048px.png",
    "company/brand/exports/icon/png/transparent/acid/magic-mirror-icon-acid-1024px.png",
    "company/brand/exports/icon/png/transparent/ink/magic-mirror-icon-ink-1024px.png",
    "company/brand/exports/icon/favicon/favicon-16x16.png",
    "company/brand/exports/icon/favicon/apple-touch-icon-180x180.png",
    "company/brand/brand-colors.json",
    "company/brand/brandbook-packet/tokens/brand-tokens.json",
    "company/brand/brandbook-packet/tokens/brand-tokens.css",
    "company/brand/brandbook-packet/references/mockup-direction/browser-light-reference.png",
    "company/brand/brandbook-packet/references/mockup-direction/browser-dark-reference.png",
    "company/brand/brandbook-packet/references/mockup-direction/social-phone-reference.png",
)

FINAL_MOCKUPS = (
    "mockups/business-card.png",
    "mockups/billboard.png",
    "mockups/browser-favicon-light.png",
    "mockups/browser-favicon-dark.png",
    "mockups/x-profile.png",
    "mockups/linkedin-profile.png",
    "mockups/tshirt.png",
    "mockups/compact-mirror.png",
)


def main() -> None:
    text = PLAN.read_text(encoding="utf-8")
    rows = []
    for line in text.splitlines():
        match = re.match(r"^\| (\d{2}) \|", line)
        if match:
            columns = [column.strip() for column in line.strip().strip("|").split("|")]
            assert len(columns) == 7, f"Page row {match.group(1)} has {len(columns)} columns"
            rows.append({"number": match.group(1), "title": columns[1], "method": columns[2], "output": columns[4]})

    assert [row["number"] for row in rows] == [f"{index:02d}" for index in range(1, 20)]
    assert len({row["title"] for row in rows}) == 19
    assert all(".png`" in row["output"] for row in rows)

    for path in REQUIRED_INPUTS:
        assert path in text, f"Plan missing required input: {path}"
        resolved = REPO_ROOT / path
        assert resolved.is_file() and resolved.stat().st_size > 100, f"Input missing/empty: {resolved}"

    planned_mockups = sorted(set(re.findall(r"mockups/[a-z0-9-]+\.png", text)))
    assert planned_mockups == sorted(FINAL_MOCKUPS)
    assert all(not output.endswith(".svg") for output in planned_mockups)

    for prompt in ("IG-01", "IG-02", "IG-03", "IG-04", "IG-05", "IG-06", "IG-07", "IG-08"):
        assert f"### {prompt}" in text, f"Missing ImageGen plan {prompt}"
    assert "### DS-" not in text
    assert text.count("Target: `1536×1024` PNG") == 6
    assert text.count("Target: `1852×850` PNG") == 2
    assert "all created with ImageGen" in text
    assert "roughly 95% fidelity" in text
    assert "Retry once" in text or "retry once" in text
    assert "No SVG mockup outputs" in text

    methods = {
        "imagegen_page_rows": sum(
            row["method"] == "ImageGen" and "mockups/" in row["output"]
            for row in rows
        ),
        "non_imagegen_mockup_page_rows": sum(
            row["method"] == "HTML/CSS screenshot" and "mockups/" in row["output"]
            for row in rows
        ),
        "other_page_rows": sum("mockups/" not in row["output"] for row in rows),
    }
    assert methods == {
        "imagegen_page_rows": 7,
        "non_imagegen_mockup_page_rows": 0,
        "other_page_rows": 12,
    }

    mockup_existence = {
        output: (PACKET_ROOT / output).exists()
        for output in FINAL_MOCKUPS
    }
    evidence = {
        "task": "T002-revision",
        "status": "passed",
        "plan": str(PLAN.relative_to(REPO_ROOT)),
        "page_count": len(rows),
        "pages": rows,
        "method_counts": methods,
        "required_input_count": len(REQUIRED_INPUTS),
        "required_inputs_verified": list(REQUIRED_INPUTS),
        "planned_mockup_count": len(planned_mockups),
        "planned_mockups": planned_mockups,
        "imagegen_plan_count": 8,
        "non_imagegen_mockup_plan_count": 0,
        "browser_light_dark_output_count": 2,
        "all_mockup_outputs_raster_png": True,
        "planned_output_existence_at_revision": mockup_existence,
        "revision_reason": "Owner required every application mockup to use ImageGen and browser/favicon to have separate light and dark outputs; prior deterministic browser/social plan was rejected.",
        "qa_gate": "Complete ImageGen attempt, visual QA at roughly 95%, one targeted retry, exact compositing fallback only afterward.",
    }
    output = PACKET_ROOT / "references/t002-revision-audit.json"
    output.write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
    print(
        f"T002 revision passed: {len(rows)} pages, {len(REQUIRED_INPUTS)} inputs, "
        f"{methods['imagegen_page_rows']} ImageGen mockup page rows, "
        f"{methods['non_imagegen_mockup_page_rows']} non-ImageGen mockup page rows"
    )


if __name__ == "__main__":
    main()
