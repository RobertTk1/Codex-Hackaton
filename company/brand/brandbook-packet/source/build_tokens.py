#!/usr/bin/env python3
"""Generate exact Magic Mirror brandbook color and typography tokens."""

from __future__ import annotations

import json
import math
from pathlib import Path


PACKET_ROOT = Path(__file__).resolve().parents[1]
TOKENS_ROOT = PACKET_ROOT / "tokens"

ANCHORS = {
    "acid": "#D7FF3F",
    "deep": "#263300",
    "pale": "#F2FFD0",
    "ink": "#17171A",
    "white": "#FFFFFF",
    "cloud": "#F4F3F1",
    "black": "#000000",
}


def hex_to_rgb(value: str) -> tuple[float, float, float]:
    value = value.lstrip("#")
    return tuple(int(value[index : index + 2], 16) / 255 for index in (0, 2, 4))


def rgb_to_hex(rgb: tuple[float, float, float]) -> str:
    values = [max(0, min(255, round(channel * 255))) for channel in rgb]
    return "#" + "".join(f"{value:02X}" for value in values)


def srgb_to_linear(channel: float) -> float:
    if channel <= 0.04045:
        return channel / 12.92
    return ((channel + 0.055) / 1.055) ** 2.4


def linear_to_srgb(channel: float) -> float:
    if channel <= 0.0031308:
        return 12.92 * channel
    return 1.055 * (channel ** (1 / 2.4)) - 0.055


def rgb_to_oklab(rgb: tuple[float, float, float]) -> tuple[float, float, float]:
    red, green, blue = (srgb_to_linear(channel) for channel in rgb)
    l_value = 0.4122214708 * red + 0.5363325363 * green + 0.0514459929 * blue
    m_value = 0.2119034982 * red + 0.6806995451 * green + 0.1073969566 * blue
    s_value = 0.0883024619 * red + 0.2817188376 * green + 0.6299787005 * blue
    l_root = math.copysign(abs(l_value) ** (1 / 3), l_value)
    m_root = math.copysign(abs(m_value) ** (1 / 3), m_value)
    s_root = math.copysign(abs(s_value) ** (1 / 3), s_value)
    return (
        0.2104542553 * l_root + 0.7936177850 * m_root - 0.0040720468 * s_root,
        1.9779984951 * l_root - 2.4285922050 * m_root + 0.4505937099 * s_root,
        0.0259040371 * l_root + 0.7827717662 * m_root - 0.8086757660 * s_root,
    )


def oklab_to_rgb(lab: tuple[float, float, float]) -> tuple[float, float, float]:
    lightness, a_value, b_value = lab
    l_root = lightness + 0.3963377774 * a_value + 0.2158037573 * b_value
    m_root = lightness - 0.1055613458 * a_value - 0.0638541728 * b_value
    s_root = lightness - 0.0894841775 * a_value - 1.2914855480 * b_value
    l_value = l_root**3
    m_value = m_root**3
    s_value = s_root**3
    red = 4.0767416621 * l_value - 3.3077115913 * m_value + 0.2309699292 * s_value
    green = -1.2684380046 * l_value + 2.6097574011 * m_value - 0.3413193965 * s_value
    blue = -0.0041960863 * l_value - 0.7034186147 * m_value + 1.7076147010 * s_value
    return tuple(max(0.0, min(1.0, linear_to_srgb(channel))) for channel in (red, green, blue))


def mix_oklab(start: str, end: str, amount: float) -> str:
    start_lab = rgb_to_oklab(hex_to_rgb(start))
    end_lab = rgb_to_oklab(hex_to_rgb(end))
    mixed = tuple(
        start_channel + (end_channel - start_channel) * amount
        for start_channel, end_channel in zip(start_lab, end_lab)
    )
    return rgb_to_hex(oklab_to_rgb(mixed))


def build_scales() -> dict[str, dict[str, str]]:
    acid = {
        "50": ANCHORS["pale"],
        "100": mix_oklab(ANCHORS["pale"], ANCHORS["acid"], 0.20),
        "200": mix_oklab(ANCHORS["pale"], ANCHORS["acid"], 0.40),
        "300": mix_oklab(ANCHORS["pale"], ANCHORS["acid"], 0.60),
        "400": mix_oklab(ANCHORS["pale"], ANCHORS["acid"], 0.80),
        "500": ANCHORS["acid"],
        "600": mix_oklab(ANCHORS["acid"], ANCHORS["deep"], 0.25),
        "700": mix_oklab(ANCHORS["acid"], ANCHORS["deep"], 0.50),
        "800": mix_oklab(ANCHORS["acid"], ANCHORS["deep"], 0.75),
        "900": ANCHORS["deep"],
    }
    neutral_amounts = {
        "50": 0.00,
        "100": 0.12,
        "200": 0.24,
        "300": 0.36,
        "400": 0.48,
        "500": 0.60,
        "600": 0.70,
        "700": 0.80,
        "800": 0.90,
        "900": 1.00,
    }
    neutral = {
        step: mix_oklab(ANCHORS["cloud"], ANCHORS["ink"], amount)
        for step, amount in neutral_amounts.items()
    }
    neutral["0"] = ANCHORS["white"]
    return {"acid": acid, "neutral": neutral}


def build_tokens() -> dict[str, object]:
    scales = build_scales()
    return {
        "$schema": "https://tr.designtokens.org/format/",
        "meta": {
            "brand": "Magic Mirror",
            "direction": "Acid Dispatch / Editorial Edge",
            "method": "Derived colors use linear interpolation in OKLab between approved Acid Dispatch anchors; values are rounded to 8-bit sRGB hex.",
        },
        "color": {
            "anchor": ANCHORS,
            "scale": scales,
            "semantic": {
                "surface": {
                    "default": ANCHORS["white"],
                    "subtle": ANCHORS["cloud"],
                    "soft": ANCHORS["pale"],
                    "dark": ANCHORS["ink"],
                    "primary": ANCHORS["acid"],
                },
                "text": {
                    "default": ANCHORS["ink"],
                    "strong": ANCHORS["black"],
                    "onPrimary": ANCHORS["ink"],
                    "onDark": ANCHORS["acid"],
                    "soft": ANCHORS["deep"],
                },
                "border": {
                    "default": scales["neutral"]["200"],
                    "strong": scales["neutral"]["500"],
                },
                "focus": {
                    "ring": ANCHORS["acid"],
                    "offset": ANCHORS["ink"],
                },
            },
        },
        "typography": {
            "family": {
                "display": "Instrument Serif",
                "ui": "Space Grotesk",
                "displayStack": "'Instrument Serif', 'Times New Roman', serif",
                "uiStack": "'Space Grotesk', Inter, Arial, sans-serif",
            },
            "weight": {
                "display": 400,
                "body": 400,
                "medium": 500,
                "semibold": 600,
                "bold": 700,
            },
            "style": {
                "display": {"size": "72px", "lineHeight": 0.94, "tracking": "-0.03em"},
                "h1": {"size": "56px", "lineHeight": 1.0, "tracking": "-0.025em"},
                "h2": {"size": "40px", "lineHeight": 1.05, "tracking": "-0.02em"},
                "h3": {"size": "28px", "lineHeight": 1.15, "tracking": "-0.012em"},
                "lead": {"size": "22px", "lineHeight": 1.4, "tracking": "-0.01em"},
                "body": {"size": "16px", "lineHeight": 1.55, "tracking": "0em"},
                "caption": {"size": "13px", "lineHeight": 1.4, "tracking": "0.01em"},
                "label": {"size": "12px", "lineHeight": 1.2, "tracking": "0.12em"},
                "number": {"size": "16px", "lineHeight": 1.2, "tracking": "-0.01em", "featureSettings": "'tnum' 1"},
            },
            "sources": {
                "display": "assets/fonts/instrument-serif/InstrumentSerif-Regular.ttf",
                "displayItalic": "assets/fonts/instrument-serif/InstrumentSerif-Italic.ttf",
                "uiVariable": "assets/fonts/space-grotesk/SpaceGrotesk[wght].ttf",
            },
        },
        "radius": {
            "button": "999px",
            "card": "24px",
            "badge": "999px",
            "tooltip": "12px",
        },
        "state": {
            "primary": {
                "default": {"background": ANCHORS["acid"], "foreground": ANCHORS["ink"]},
                "hover": {"background": scales["acid"]["600"], "foreground": ANCHORS["ink"]},
                "focusRing": ANCHORS["acid"],
            },
            "secondary": {
                "default": {"background": ANCHORS["pale"], "foreground": ANCHORS["deep"]},
                "hover": {"background": scales["acid"]["100"], "foreground": ANCHORS["deep"]},
                "focusRing": ANCHORS["acid"],
            },
            "link": {
                "default": ANCHORS["deep"],
                "hover": ANCHORS["ink"],
                "focusRing": ANCHORS["acid"],
            },
            "disabled": {
                "background": scales["neutral"]["100"],
                "foreground": scales["neutral"]["600"],
            },
        },
    }


def css_variables(tokens: dict[str, object]) -> str:
    anchors = tokens["color"]["anchor"]
    scales = tokens["color"]["scale"]
    lines = [
        "@font-face {",
        "  font-family: 'Instrument Serif';",
        "  src: url('../assets/fonts/instrument-serif/InstrumentSerif-Regular.ttf') format('truetype');",
        "  font-style: normal;",
        "  font-weight: 400;",
        "  font-display: swap;",
        "}",
        "",
        "@font-face {",
        "  font-family: 'Instrument Serif';",
        "  src: url('../assets/fonts/instrument-serif/InstrumentSerif-Italic.ttf') format('truetype');",
        "  font-style: italic;",
        "  font-weight: 400;",
        "  font-display: swap;",
        "}",
        "",
        "@font-face {",
        "  font-family: 'Space Grotesk';",
        "  src: url('../assets/fonts/space-grotesk/SpaceGrotesk[wght].ttf') format('truetype-variations');",
        "  font-style: normal;",
        "  font-weight: 300 700;",
        "  font-display: swap;",
        "}",
        "",
        ":root {",
    ]
    for name, value in anchors.items():
        lines.append(f"  --mm-color-{name}: {value};")
    for family, scale in scales.items():
        for step, value in scale.items():
            lines.append(f"  --mm-color-{family}-{step}: {value};")
    lines.extend(
        [
            "  --mm-font-display: 'Instrument Serif', 'Times New Roman', serif;",
            "  --mm-font-ui: 'Space Grotesk', Inter, Arial, sans-serif;",
            "  --mm-radius-button: 999px;",
            "  --mm-radius-card: 24px;",
            "  --mm-radius-badge: 999px;",
            "  --mm-radius-tooltip: 12px;",
            "  --mm-focus-ring: 0 0 0 3px var(--mm-color-acid);",
            "  --mm-focus-offset: 0 0 0 5px var(--mm-color-ink);",
            "}",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> None:
    TOKENS_ROOT.mkdir(parents=True, exist_ok=True)
    tokens = build_tokens()
    (TOKENS_ROOT / "brand-tokens.json").write_text(
        json.dumps(tokens, indent=2) + "\n",
        encoding="utf-8",
    )
    (TOKENS_ROOT / "brand-tokens.css").write_text(css_variables(tokens), encoding="utf-8")
    (TOKENS_ROOT / "derived-palette.json").write_text(
        json.dumps(
            {
                "method": tokens["meta"]["method"],
                "anchors": tokens["color"]["anchor"],
                "scales": tokens["color"]["scale"],
            },
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    print("Wrote brand-tokens.json, brand-tokens.css, and derived-palette.json")


if __name__ == "__main__":
    main()
