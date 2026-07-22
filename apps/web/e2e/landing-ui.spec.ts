import { expect, test, type Page } from "@playwright/test";

const expectedHeadings = [
  "Your style already has a point of view.",
  "See what makes your style yours.",
  "From favorite looks to your style report.",
  "A guide you can actually wear.",
  "Your style. Your photos. Your choice.",
  "Good questions, answered.",
  "Meet the style that’s already yours.",
];

function collectBrowserFailures(page: Page) {
  const consoleErrors: string[] = [];
  const failedRequests: string[] = [];
  page.on("console", (message: { type(): string; text(): string }) => {
    if (message.type() === "error") consoleErrors.push(message.text());
  });
  page.on("pageerror", (error: Error) => consoleErrors.push(error.message));
  page.on("requestfailed", (request: { method(): string; url(): string }) => {
    failedRequests.push(`${request.method()} ${request.url()}`);
  });
  return { consoleErrors, failedRequests };
}

test("desktop landing page presents the approved report-led story", async ({ page }) => {
  const failures = collectBrowserFailures(page);
  await page.setViewportSize({ width: 1440, height: 1000 });

  const response = await page.goto("/");
  expect(response?.status()).toBe(200);

  for (const heading of expectedHeadings) {
    await expect(page.getByRole("heading", { name: heading })).toBeVisible();
  }

  const primaryCta = page.getByRole("link", { name: "Get my style report" }).first();
  await expect(primaryCta).toHaveAttribute("href", "/style-report/profile");
  await expect(page.getByRole("link", { name: "Log in" }).first()).toHaveAttribute("href", "/login");
  await expect(page.getByRole("navigation", { name: "Primary navigation" })).toBeVisible();

  await page.getByRole("link", { name: "What’s inside" }).click();
  await expect(page.locator("#whats-inside")).toBeInViewport();

  const faq = page.getByRole("button", { name: "How long does the report take?" });
  await faq.click();
  await expect(faq).toHaveAttribute("aria-expanded", "true");
  await expect(page.getByText("Your report is usually ready in 1–2 minutes.")).toBeVisible();

  expect(failures.consoleErrors).toEqual([]);
  expect(failures.failedRequests).toEqual([]);
});

test("mobile landing page offers a keyboard-operable compact menu", async ({ page }) => {
  const failures = collectBrowserFailures(page);
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto("/");

  const menu = page.getByRole("button", { name: "Open navigation" });
  await expect(menu).toBeVisible();
  await menu.focus();
  await page.keyboard.press("Enter");
  await expect(page.getByRole("dialog", { name: "Mobile navigation" })).toBeVisible();
  await expect(page.getByRole("link", { name: "Your privacy" })).toBeVisible();
  await expect(page.getByRole("button", { name: "Close navigation" })).toBeFocused();
  await page.keyboard.press("Shift+Tab");
  await expect(page.getByRole("dialog", { name: "Mobile navigation" }).getByRole("link", { name: "Get my style report" })).toBeFocused();
  await page.keyboard.press("Tab");
  await expect(page.getByRole("button", { name: "Close navigation" })).toBeFocused();
  await page.keyboard.press("Escape");
  await expect(page.getByRole("dialog", { name: "Mobile navigation" })).toBeHidden();
  await expect(menu).toBeFocused();

  for (const heading of expectedHeadings) {
    await expect(page.getByRole("heading", { name: heading })).toBeAttached();
  }

  expect(failures.consoleErrors).toEqual([]);
  expect(failures.failedRequests).toEqual([]);
});
