import { expect, test } from "@playwright/test";

test("a visitor starts a report and completes the local profile and brand-size tracer", async ({ page }) => {
  await page.goto("/");
  const startReport = page.locator("main > .landing-hero a[href='/style-report/profile']");
  await expect(startReport).toHaveCount(1);
  await startReport.click();
  await expect(page).toHaveURL(/\/style-report\/profile$/);
  await expect(page.getByRole("heading", { name: "First, tell us about you" })).toBeVisible();

  await page.getByLabel("Preferred name").fill("Robert");
  await page.getByLabel("Age").fill("29");
  await page.getByLabel("Height").fill("6 ft 1 in");
  await page.getByLabel("I confirm that I am 18 or older.").check();
  await page.getByRole("button", { name: "Continue" }).click();

  await expect(page.getByRole("heading", { name: "What already fits you well?" })).toBeVisible();
  await expect(page.getByText("Your earlier profile is held only in this browser session for the tracer.")).toBeVisible();
  await page.getByLabel("Find a favorite brand").fill("COS");
  await page.getByRole("button", { name: "Add brand" }).click();
  await expect(page.getByRole("heading", { name: "COS" })).toBeVisible();
  await expect(page.getByRole("button", { name: "Continue to favorite looks" })).toBeEnabled();
});
