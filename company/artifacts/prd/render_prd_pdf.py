#!/usr/bin/env python3
"""Render the canonical Magic Mirror PRD Markdown as a branded PDF."""

from pathlib import Path
import re
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.pagesizes import LETTER
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import inch
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import PageBreak, Paragraph, SimpleDocTemplate, Spacer


ROOT = Path(__file__).resolve().parents[3]
SOURCE = Path(__file__).with_name("prd.md")
OUTPUT = Path(__file__).with_name("prd-report.pdf")
FONT_ROOT = ROOT / "company/brand/brandbook-packet/assets/fonts"

INK = colors.HexColor("#17171A")
ACID = colors.HexColor("#D7FF3F")
DEEP = colors.HexColor("#263300")
MUTED = colors.HexColor("#666567")
WHITE = colors.white


def register_fonts() -> None:
    pdfmetrics.registerFont(
        TTFont(
            "InstrumentSerif",
            str(FONT_ROOT / "instrument-serif/InstrumentSerif-Regular.ttf"),
        )
    )
    pdfmetrics.registerFont(
        TTFont(
            "SpaceGrotesk",
            str(FONT_ROOT / "space-grotesk/SpaceGrotesk[wght].ttf"),
        )
    )


def inline_markdown(value: str) -> str:
    text = escape(value.strip())
    text = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", text)
    text = re.sub(r"`(.+?)`", r'<font name="Courier">\1</font>', text)
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"<u>\1</u>", text)
    return text


def build_story() -> list:
    body = ParagraphStyle(
        "Body",
        fontName="SpaceGrotesk",
        fontSize=9.2,
        leading=13.2,
        textColor=INK,
        spaceAfter=6,
    )
    bullet = ParagraphStyle(
        "Bullet",
        parent=body,
        leftIndent=15,
        firstLineIndent=-7,
        bulletIndent=3,
        spaceAfter=4,
    )
    numbered = ParagraphStyle(
        "Numbered",
        parent=body,
        leftIndent=19,
        firstLineIndent=-12,
        spaceAfter=4,
    )
    h1 = ParagraphStyle(
        "H1",
        fontName="InstrumentSerif",
        fontSize=26,
        leading=29,
        textColor=INK,
        spaceBefore=16,
        spaceAfter=9,
        keepWithNext=True,
    )
    h2 = ParagraphStyle(
        "H2",
        fontName="SpaceGrotesk",
        fontSize=14,
        leading=18,
        textColor=DEEP,
        spaceBefore=13,
        spaceAfter=6,
        keepWithNext=True,
    )
    h3 = ParagraphStyle(
        "H3",
        fontName="SpaceGrotesk",
        fontSize=10.5,
        leading=14,
        textColor=INK,
        spaceBefore=9,
        spaceAfter=4,
        keepWithNext=True,
    )
    callout = ParagraphStyle(
        "Callout",
        fontName="SpaceGrotesk",
        fontSize=10,
        leading=14,
        textColor=INK,
        leftIndent=12,
        rightIndent=12,
        borderColor=ACID,
        borderWidth=1,
        borderPadding=10,
        backColor=colors.HexColor("#F2FFD0"),
        spaceBefore=6,
        spaceAfter=10,
    )

    raw = SOURCE.read_text(encoding="utf-8").translate(
        str.maketrans(
            {
                "\u2011": "-",
                "\u2013": "-",
                "\u2014": "-",
                "\u2018": "'",
                "\u2019": "'",
                "\u201c": '"',
                "\u201d": '"',
            }
        )
    )
    parts = raw.split("---", 2)
    markdown = parts[2] if len(parts) >= 3 else raw

    story = []
    for line in markdown.splitlines():
        value = line.strip()
        if not value:
            story.append(Spacer(1, 4))
        elif value.startswith("# "):
            continue
        elif value.startswith("## "):
            story.append(Paragraph(inline_markdown(value[3:]), h1))
        elif value.startswith("### "):
            story.append(Paragraph(inline_markdown(value[4:]), h2))
        elif value.startswith("#### "):
            story.append(Paragraph(inline_markdown(value[5:]), h3))
        elif re.match(r"^\d+\.\s+", value):
            match = re.match(r"^(\d+)\.\s+(.*)", value)
            assert match is not None
            story.append(
                Paragraph(
                    inline_markdown(match.group(2)),
                    numbered,
                    bulletText=f"{match.group(1)}.",
                )
            )
        elif value.startswith("- "):
            story.append(
                Paragraph(inline_markdown(value[2:]), bullet, bulletText="-")
            )
        elif value.startswith("Status:"):
            story.append(Paragraph(inline_markdown(value), callout))
        else:
            story.append(Paragraph(inline_markdown(value), body))
    return story


def cover_story() -> list:
    kicker = ParagraphStyle(
        "Kicker",
        fontName="SpaceGrotesk",
        fontSize=10,
        leading=12,
        textColor=ACID,
        tracking=2,
    )
    title = ParagraphStyle(
        "CoverTitle",
        fontName="InstrumentSerif",
        fontSize=47,
        leading=48,
        textColor=WHITE,
    )
    subtitle = ParagraphStyle(
        "CoverSubtitle",
        fontName="SpaceGrotesk",
        fontSize=14,
        leading=20,
        textColor=WHITE,
    )
    meta = ParagraphStyle(
        "CoverMeta",
        fontName="SpaceGrotesk",
        fontSize=9,
        leading=12,
        textColor=ACID,
        tracking=1,
    )
    status = ParagraphStyle(
        "CoverStatus",
        fontName="SpaceGrotesk",
        fontSize=10,
        leading=14,
        textColor=WHITE,
    )
    return [
        Spacer(1, 1.15 * inch),
        Paragraph("MAGIC MIRROR", kicker),
        Spacer(1, 0.24 * inch),
        Paragraph("Product Requirements<br/>Document", title),
        Spacer(1, 0.28 * inch),
        Paragraph(
            "Style intelligence, personal report, live styling, and retailer action",
            subtitle,
        ),
        Spacer(1, 1.3 * inch),
        Paragraph("DRAFT  /  VERSION 0.1.0  /  18 JULY 2026", meta),
        Spacer(1, 0.16 * inch),
        Paragraph("Awaiting founder approval before UX design", status),
        PageBreak(),
    ]


def draw_cover(canvas, _doc) -> None:
    canvas.saveState()
    canvas.setFillColor(INK)
    canvas.rect(0, 0, LETTER[0], LETTER[1], stroke=0, fill=1)
    canvas.setFillColor(ACID)
    canvas.rect(0.62 * inch, 0.54 * inch, 1.15 * inch, 0.08 * inch, stroke=0, fill=1)
    canvas.restoreState()


def draw_body_chrome(canvas, doc) -> None:
    canvas.saveState()
    width, height = LETTER
    canvas.setStrokeColor(colors.HexColor("#D6D5D4"))
    canvas.setLineWidth(0.5)
    canvas.line(0.68 * inch, 0.52 * inch, width - 0.68 * inch, 0.52 * inch)
    canvas.setFont("SpaceGrotesk", 7.5)
    canvas.setFillColor(MUTED)
    canvas.drawString(
        0.68 * inch,
        0.3 * inch,
        "MAGIC MIRROR  /  PRODUCT REQUIREMENTS DOCUMENT  /  DRAFT",
    )
    canvas.drawRightString(width - 0.68 * inch, 0.3 * inch, str(doc.page))
    canvas.setFillColor(ACID)
    canvas.rect(
        0.68 * inch,
        height - 0.42 * inch,
        0.52 * inch,
        0.055 * inch,
        stroke=0,
        fill=1,
    )
    canvas.restoreState()


def main() -> None:
    register_fonts()
    document = SimpleDocTemplate(
        str(OUTPUT),
        pagesize=LETTER,
        rightMargin=0.72 * inch,
        leftMargin=0.72 * inch,
        topMargin=0.62 * inch,
        bottomMargin=0.66 * inch,
        title="Magic Mirror Product Requirements Document",
        author="Magic Mirror",
    )
    document.build(
        cover_story() + build_story(),
        onFirstPage=draw_cover,
        onLaterPages=draw_body_chrome,
    )
    print(OUTPUT)


if __name__ == "__main__":
    main()
