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
    reuseExistingServer: false,
    timeout: 120_000,
    url: webOrigin,
  },
});
