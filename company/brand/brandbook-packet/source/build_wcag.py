#!/usr/bin/env python3
import hashlib
import json
from pathlib import Path

SOURCE_DIR = Path(__file__).resolve().parent
PACKET_DIR = SOURCE_DIR.parent
DERIVED_PATH = PACKET_DIR / "tokens" / "derived-palette.json"
OUTPUT_PATH = PACKET_DIR / "tokens" / "wcag-matrix.json"
PAGE_DATA_PATH = SOURCE_DIR / "wcag-matrix.js"

AA_NORMAL = 4.5
AA_LARGE = 3.0


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalize_hex(value: str) -> str:
    value = value.upper()
    if not value.startswith("#") or len(value) != 7:
        raise ValueError(f"Invalid six-digit hex color: {value}")
    int(value[1:], 16)
    return value


def relative_luminance(value: str) -> float:
    channels = [int(value[index:index + 2], 16) / 255 for index in (1, 3, 5)]
    linear = [channel / 12.92 if channel <= 0.04045 else ((channel + 0.055) / 1.055) ** 2.4 for channel in channels]
    return 0.2126 * linear[0] + 0.7152 * linear[1] + 0.0722 * linear[2]


def contrast_ratio(foreground: str, background: str) -> float:
    first = relative_luminance(foreground)
    second = relative_luminance(background)
    lighter = max(first, second)
    darker = min(first, second)
    return (lighter + 0.05) / (darker + 0.05)


def result(foreground, background):
    ratio = contrast_ratio(foreground["hex"], background["hex"])
    aa_normal = ratio >= AA_NORMAL
    aa_large = ratio >= AA_LARGE
    status = "normal" if aa_normal else "large" if aa_large else "fail"
    return {
        "foreground_id": foreground["id"],
        "background_id": background["id"],
        "ratio": round(ratio, 4),
        "ratio_display": f"{ratio:.2f}:1",
        "aa_normal": aa_normal,
        "aa_large": aa_large,
        "status": status,
    }


def build_colors(data):
    anchors = data["anchors"]
    acid = data["scales"]["acid"]
    neutral = data["scales"]["neutral"]
    colors = [
        {"id": "acid", "name": "Acid", "hex": anchors["acid"], "group": "anchor"},
        {"id": "deep", "name": "Deep", "hex": anchors["deep"], "group": "anchor"},
        {"id": "pale", "name": "Pale", "hex": anchors["pale"], "group": "anchor"},
        {"id": "ink", "name": "Ink", "hex": anchors["ink"], "group": "anchor"},
        {"id": "white", "name": "White", "hex": anchors["white"], "group": "anchor"},
        {"id": "cloud", "name": "Cloud", "hex": anchors["cloud"], "group": "anchor"},
        {"id": "black", "name": "Technical Black", "hex": anchors["black"], "group": "anchor"},
    ]
    for step in ["100", "200", "300", "400", "600", "700", "800"]:
        colors.append({"id": f"acid-{step}", "name": f"Acid {step}", "hex": acid[step], "group": "acid-derived"})
    for step in ["100", "200", "300", "400", "500", "600", "700", "800"]:
        colors.append({"id": f"neutral-{step}", "name": f"Neutral {step}", "hex": neutral[step], "group": "neutral-derived"})

    for color in colors:
        color["hex"] = normalize_hex(color["hex"])
        color["relative_luminance"] = round(relative_luminance(color["hex"]), 6)
    if len(colors) != 22 or len({color["hex"] for color in colors}) != 22:
        raise AssertionError("Expected exactly 22 unique canonical colors")
    return colors


def main():
    derived = json.loads(DERIVED_PATH.read_text(encoding="utf-8"))
    colors = build_colors(derived)
    by_id = {color["id"]: color for color in colors}

    pairings = [result(foreground, background) for foreground in colors for background in colors]
    anchors = [by_id[color_id] for color_id in ["acid", "deep", "pale", "ink", "white", "cloud", "black"]]
    anchor_matrix = [result(foreground, background) for foreground in anchors for background in anchors]

    recommended_ids = [
        ("ink", "acid"),
        ("acid", "ink"),
        ("ink", "white"),
        ("white", "ink"),
        ("ink", "cloud"),
        ("deep", "pale"),
        ("deep", "acid"),
        ("acid", "deep"),
    ]
    recommendations = []
    pair_lookup = {(item["foreground_id"], item["background_id"]): item for item in pairings}
    for foreground_id, background_id in recommended_ids:
        item = dict(pair_lookup[(foreground_id, background_id)])
        item["label"] = f"{by_id[foreground_id]['name']} on {by_id[background_id]['name']}"
        if not item["aa_normal"]:
            raise AssertionError(f"Recommended pair does not pass normal AA: {item['label']}")
        recommendations.append(item)

    summary = {
        "color_count": len(colors),
        "ordered_pairing_count": len(pairings),
        "normal_aa_pass_count": sum(item["aa_normal"] for item in pairings),
        "large_aa_pass_count": sum(item["aa_large"] for item in pairings),
        "normal_only_failure_count": sum(item["aa_large"] and not item["aa_normal"] for item in pairings),
        "all_text_failure_count": sum(not item["aa_large"] for item in pairings),
    }

    payload = {
        "meta": {
            "brand": "Magic Mirror",
            "standard": "WCAG 2.x relative luminance and contrast ratio",
            "formula": "(L1 + 0.05) / (L2 + 0.05), where L1 is the lighter relative luminance",
            "scope": "Every ordered foreground/background combination across 22 unique approved anchor and documented derived colors, including self-pairs and failures.",
            "source": "tokens/derived-palette.json",
            "source_sha256": sha256(DERIVED_PATH),
            "thresholds": {"aa_normal": AA_NORMAL, "aa_large": AA_LARGE},
        },
        "colors": colors,
        "summary": summary,
        "pairings": pairings,
        "anchor_matrix": {
            "color_ids": [color["id"] for color in anchors],
            "pairings": anchor_matrix,
        },
        "recommended_pairings": recommendations,
    }
    OUTPUT_PATH.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")

    page_payload = {
        "thresholds": payload["meta"]["thresholds"],
        "summary": summary,
        "colors": [{"id": color["id"], "name": color["name"], "hex": color["hex"]} for color in anchors],
        "matrix": anchor_matrix,
        "recommended": recommendations,
        "raw_data_path": "tokens/wcag-matrix.json",
        "raw_data_sha256": sha256(OUTPUT_PATH),
    }
    javascript = f"const WCAG_PAGE_DATA = {json.dumps(page_payload, separators=(',', ':'))};\n" + r'''
document.addEventListener('DOMContentLoaded', () => {
  const matrix = document.getElementById('wcag-matrix');
  const recommendations = document.getElementById('wcag-recommendations');
  const summary = document.getElementById('wcag-summary');
  if (!matrix || !recommendations || !summary) return;

  const colorById = Object.fromEntries(WCAG_PAGE_DATA.colors.map((color) => [color.id, color]));
  const corner = document.createElement('div');
  corner.className = 'matrix-corner';
  corner.innerHTML = '<span>TEXT ↓</span><span>SURFACE →</span>';
  matrix.appendChild(corner);

  for (const color of WCAG_PAGE_DATA.colors) {
    const header = document.createElement('div');
    header.className = 'matrix-column-label';
    header.innerHTML = `<i style="--swatch:${color.hex}"></i><span>${color.name}</span>`;
    matrix.appendChild(header);
  }

  for (const foreground of WCAG_PAGE_DATA.colors) {
    const row = document.createElement('div');
    row.className = 'matrix-row-label';
    row.innerHTML = `<i style="--swatch:${foreground.hex}"></i><span>${foreground.name}</span>`;
    matrix.appendChild(row);
    for (const background of WCAG_PAGE_DATA.colors) {
      const item = WCAG_PAGE_DATA.matrix.find((entry) => entry.foreground_id === foreground.id && entry.background_id === background.id);
      const cell = document.createElement('div');
      cell.className = `matrix-cell status-${item.status}`;
      cell.setAttribute('aria-label', `${foreground.name} on ${background.name}: ${item.ratio_display}; ${item.aa_normal ? 'AA normal pass' : item.aa_large ? 'AA large only' : 'fail'}`);
      cell.innerHTML = `<strong>${item.ratio.toFixed(2)}</strong><span>${item.status === 'normal' ? 'AA' : item.status === 'large' ? 'L' : '×'}</span>`;
      matrix.appendChild(cell);
    }
  }

  for (const item of WCAG_PAGE_DATA.recommended) {
    const foreground = colorById[item.foreground_id];
    const background = colorById[item.background_id];
    const row = document.createElement('div');
    row.className = 'recommendation-row';
    row.innerHTML = `<span class="pair-sample" style="--pair-fg:${foreground.hex};--pair-bg:${background.hex}">Aa</span><span class="pair-name">${item.label}</span><strong>${item.ratio_display}</strong>`;
    recommendations.appendChild(row);
  }

  summary.textContent = `${WCAG_PAGE_DATA.summary.color_count} colors / ${WCAG_PAGE_DATA.summary.ordered_pairing_count} ordered pairs / ${WCAG_PAGE_DATA.summary.normal_aa_pass_count} normal-AA passes`;
});
'''
    PAGE_DATA_PATH.write_text(javascript, encoding="utf-8")
    print(f"WCAG data built: {summary['color_count']} colors, {summary['ordered_pairing_count']} ordered pairings, {summary['normal_aa_pass_count']} normal-AA passes")


if __name__ == "__main__":
    main()
