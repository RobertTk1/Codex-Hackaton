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
    "company/brand/brand-colors.json",
    "company/brand/brandbook-packet/tokens/brand-tokens.json",
    "company/brand/brandbook-packet/tokens/brand-tokens.css",
)

FINAL_MOCKUPS = (
    "mockups/business-card.png",
    "mockups/billboard.png",
    "mockups/browser-favicon.png",
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

    for prompt in ("IG-01", "IG-02", "IG-03", "IG-04", "DS-01", "DS-02", "DS-03"):
        assert f"### {prompt}" in text, f"Missing prompt/screenshot plan {prompt}"
    assert text.count("Target: `1536×1024` PNG") == 4
    assert text.count("Canvas: `1600×1000`") == 3
    assert "ImageGen" in text and "HTML/CSS screenshot" in text
    assert "roughly 95% fidelity" in text
    assert "Retry once" in text or "retry once" in text
    assert "No SVG mockup outputs" in text

    methods = {
        "imagegen_page_rows": sum(
            row["method"] == "ImageGen" and "mockups/" in row["output"]
            for row in rows
        ),
        "deterministic_mockup_page_rows": sum(
            row["method"] == "HTML/CSS screenshot" and "mockups/" in row["output"]
            for row in rows
        ),
        "other_page_rows": sum("mockups/" not in row["output"] for row in rows),
    }
    assert methods == {
        "imagegen_page_rows": 4,
        "deterministic_mockup_page_rows": 3,
        "other_page_rows": 12,
    }

    mockup_existence = {
        output: (PACKET_ROOT / output).exists()
        for output in FINAL_MOCKUPS
    }
    assert not any(mockup_existence.values()), "Mockup generation started before T002 plan acceptance"

    evidence = {
        "task": "T002",
        "status": "passed",
        "plan": str(PLAN.relative_to(REPO_ROOT)),
        "page_count": len(rows),
        "pages": rows,
        "method_counts": methods,
        "required_input_count": len(REQUIRED_INPUTS),
        "required_inputs_verified": list(REQUIRED_INPUTS),
        "planned_mockup_count": len(planned_mockups),
        "planned_mockups": planned_mockups,
        "imagegen_plan_count": 4,
        "deterministic_screenshot_plan_count": 3,
        "all_mockup_outputs_raster_png": True,
        "mockups_absent_before_generation": mockup_existence,
        "qa_gate": "Complete ImageGen attempt, visual QA at roughly 95%, one targeted retry, exact compositing fallback only afterward.",
    }
    output = PACKET_ROOT / "references/t002-audit.json"
    output.write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
    print(
        f"T002 passed: {len(rows)} pages, {len(REQUIRED_INPUTS)} inputs, "
        f"{methods['imagegen_page_rows']} ImageGen mockups, "
        f"{methods['deterministic_mockup_page_rows']} deterministic mockups"
    )


if __name__ == "__main__":
    main()
