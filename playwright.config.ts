import { defineConfig, devices } from "@playwright/test";

const webOrigin = "http://127.0.0.1:5173";

export default defineConfig({
  forbidOnly: true,
  fullyParallel: true,
  projects: [
    {
      name: "chromium",
      use: devices["Desktop Chrome"],
    },
  ],
  reporter: "list",
  testDir: "./apps/web/e2e",
  use: {
    baseURL: webOrigin,
    screenshot: "only-on-failure",
    trace: "retain-on-failure",
  },
  webServer: {
    command: "bun run dev:web",
    env: {
      ...process.env,
      VITE_API_BASE_URL: "http://127.0.0.1:3000",
      VITE_SUPABASE_PUBLISHABLE_KEY: "synthetic-playwright-public-key",
      VITE_SUPABASE_URL: "https://playwright.supabase.co",
    },
    reuseExistingServer: false,
    timeout: 120_000,
    url: webOrigin,
  },
});
