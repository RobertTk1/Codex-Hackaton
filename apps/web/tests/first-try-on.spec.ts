import { expect, test } from "@playwright/test";

test("a user can upload a photo, select a garment, and receive a mock result", async ({ page }) => {
  await page.goto("/");
  await page.locator("#photo-upload").setInputFiles({
    name: "person.png",
    mimeType: "image/png",
    buffer: Buffer.from(
      "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScLWhAAAAABJRU5ErkJggg==",
      "base64",
    ),
  });
  await expect(page.getByAltText("Selected photo preview")).toBeVisible();
  await page.getByRole("radio", { name: /onyx blazer/i }).click();
  await expect(page.getByRole("radio", { name: /onyx blazer/i })).toHaveAttribute("aria-checked", "true");
  await expect(page.getByRole("button", { name: "Try it on" })).toBeEnabled();
  await page.getByRole("button", { name: "Try it on" }).click();
  await expect(page.getByText("Creating your preview")).toBeVisible();
  await expect(page.getByText("Mock render")).toBeVisible({ timeout: 8_000 });
  await expect(page.getByText(/Onyx blazer on your selected photo/i)).toBeVisible();
});
