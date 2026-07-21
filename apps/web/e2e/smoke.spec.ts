import { expect, test } from "@playwright/test";

test("local web application starts without browser errors", async ({ page }) => {
  const browserErrors: string[] = [];
  page.on("console", (message) => {
    if (message.type() === "error") browserErrors.push(message.text());
  });
  page.on("pageerror", (error) => browserErrors.push(error.message));

  // Given the local web server, when a customer opens it, then its shell loads.
  await page.goto("/");

  await expect(page.getByRole("main", { name: "Magic Mirror application" })).toBeAttached();
  await expect(page.getByRole("heading", { name: "Magic Mirror" })).toBeAttached();
  expect(browserErrors).toEqual([]);
});
