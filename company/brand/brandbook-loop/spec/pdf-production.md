# PDF Production Spec

Use this file for rendering and visual QA.

## Source

HTML/CSS with a print stylesheet is the default source format, but any source format is acceptable if it can reliably produce:

- final PDF;
- one source preview per page;
- one PDF-rendered preview per page.

Magic Mirror output requirements:

- Final PDF: `company/brand/brandbook-packet/Magic-Mirror-Brandbook.pdf`
- Expected page count: exactly 19
- Source previews: `company/brand/brandbook-packet/pages/source/`
- PDF-rendered previews: `company/brand/brandbook-packet/pages/pdf/`
- Contact sheet: `company/brand/brandbook-packet/pages/contact-sheet.png`

## Rendering

After rendering the PDF:

1. Check the PDF page count.
2. Render the PDF back to images.
3. Create or inspect a contact sheet.
4. Visually inspect pages with logos, mockups, dense tables, typography, and any user-requested fixes.
5. Fix source and re-render until the PDF-rendered previews pass.

## Verification

Record:

- PDF path;
- PDF byte size;
- page count;
- preview count;
- inspected page list;
- any caveats.
