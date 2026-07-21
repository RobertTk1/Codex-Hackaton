import { defineConfig, defineProject } from "vitest/config";

export default defineConfig({
  test: {
    projects: [
      defineProject({
        test: {
          include: ["tests/**/*.test.ts"],
          name: "repository",
        },
      }),
      defineProject({
        test: {
          include: ["apps/api/test/**/*.test.ts"],
          name: "api",
        },
      }),
      defineProject({
        test: {
          include: ["apps/web/test/**/*.test.ts"],
          name: "web",
        },
      }),
    ],
  },
});
