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
          // Web smoke coverage temporarily writes an invalid source fixture to
          // prove the type gate. Keep web files serial so container builds
          // never copy that deliberately invalid fixture.
          fileParallelism: false,
          include: ["apps/web/test/**/*.test.ts"],
          name: "web",
        },
      }),
      defineProject({
        test: {
          include: ["packages/contracts/test/**/*.test.ts"],
          name: "contracts",
        },
      }),
    ],
  },
});
