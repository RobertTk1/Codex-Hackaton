# Verification Spec

Use this file for final packet verification.

Final audit should confirm:

- all tasks are complete with notes;
- final PDF exists and has expected page count;
- page previews exist;
- PDF-rendered previews exist;
- all source image references resolve;
- all final mockups exist and are non-zero;
- token JSON/CSS exists and parses;
- WCAG data exists;
- `DESIGN.md` exists and local links resolve;
- forbidden copied reference names and disallowed colors are absent from final source docs;
- company/project logs are updated if the workspace uses them.

For Magic Mirror, require exactly 19 source previews and 19 PDF-rendered previews, verify all references remain inside `company/brand/`, and scan final source/docs for non-approved designed colors outside the documented derived token set. Verify that the complete icon is not presented as the recommended 16px favicon.

Save audit evidence as `company/brand/brandbook-packet/audit.json` or an equivalent clear report.
