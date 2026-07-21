# QA Research Basis

Read this file when revising QA policy, not during ordinary case execution.

## Primary Guidance Applied

- [W3C WCAG 2.2](https://www.w3.org/TR/WCAG22/) and [W3C accessibility evaluation guidance](https://www.w3.org/WAI/test-evaluate/): test complete processes; cover keyboard, focus, inputs, error identification, and programmatically perceivable status messages; automated tools cannot establish accessibility alone.
- [W3C Error Identification guidance](https://www.w3.org/WAI/WCAG22/Understanding/error-identification): a failed operation must identify the error in text; simply redisplaying a form or unchanged interface is insufficient.
- [OWASP Web Security Testing Guide — Error Handling](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/08-Testing_for_Error_Handling/01-Testing_For_Improper_Error_Handling): exercise invalid inputs and error conditions while preventing disclosure of sensitive internal details.
- [OWASP Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html): record validation, authentication, authorization, application, connectivity, third-party, and file-processing failures with sufficient safe context for analysis.
- [Playwright testing best practices](https://playwright.dev/docs/best-practices) and [test isolation guidance](https://playwright.dev/docs/browser-contexts): verify user-visible behavior, use resilient accessible locators, control test data, and make cases independent and reproducible. These principles apply even though execution uses the in-app Browser rather than the Playwright test runner.
- [Google SRE — Testing for Reliability](https://sre.google/sre-book/testing-reliability/) and [cascading-failure guidance](https://sre.google/sre-book/addressing-cascading-failures/): do not infer reliability from the happy path; deliberately test unavailable and never-returning dependencies, and require failures to be detectable before release.
- [web.dev Core Web Vitals thresholds](https://web.dev/articles/defining-core-web-vitals-thresholds): use LCP, INP, and CLS only when adopted by the approved performance requirements, and distinguish synthetic QA measurements from production field data.

## Adaptation Decision

The original Founder Skills QA contract was built around Stagehand, Convex, npm, and a second per-ticket test-writing phase. This workflow retains its one-case-per-session discipline, evidence requirements, defect/retest loop, and final report, but moves ticket-level testing into Developer and makes QA an independent, Browser-driven evaluation of the integrated customer experience.
