import { expect, test } from "@playwright/test";

test("local web application starts without browser errors", async ({ page }) => {
  const browserErrors: string[] = [];
  const failedRequests: string[] = [];
  page.on("console", (message) => {
    if (message.type() === "error") browserErrors.push(message.text());
  });
  page.on("pageerror", (error) => browserErrors.push(error.message));
  page.on("requestfailed", (request) => {
    failedRequests.push(`${request.method()} ${request.url()}`);
  });

  // Given the local web server, when a customer opens it, then its shell loads.
  const navigation = await page.goto("/");

  expect(navigation?.status()).toBe(200);
  await expect(page.getByRole("main", { name: "Magic Mirror application" })).toBeAttached();
  await expect(page.getByRole("heading", { name: "Magic Mirror" })).toBeAttached();
  expect(browserErrors).toEqual([]);
  expect(failedRequests).toEqual([]);
});
