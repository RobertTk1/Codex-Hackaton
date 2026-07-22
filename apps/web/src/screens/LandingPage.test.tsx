import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, test } from "vitest";

import { LandingPage } from "./LandingPage";

describe("LandingPage", () => {
  test("renders every approved section and customer-facing headline", () => {
    const html = renderToStaticMarkup(<LandingPage />);
    const text = html.replace(/<[^>]*>/g, " ").replace(/\s+/g, " ");

    for (const copy of [
      "Your style already has a point of view.",
      "See what makes",
      "From favorite looks",
      "A guide you can actually wear.",
      "Your style. Your photos.",
      "Good questions, answered.",
      "Meet the style",
    ]) {
      expect(text).toContain(copy);
    }

    expect(html).toContain("/media/landing/hero-editorial.png");
    expect(html).toContain("/media/landing/report-book.png");
    expect(html).toContain("/media/landing/privacy-wardrobe.png");
  });

  test("exposes stable, accessible navigation and CTA targets", () => {
    const html = renderToStaticMarkup(<LandingPage />);

    expect(html).toContain('href="#how-it-works"');
    expect(html).toContain('href="#whats-inside"');
    expect(html).toContain('href="#privacy"');
    expect(html).toContain('href="/style-report/profile"');
    expect(html).toContain('data-integration-target="anonymous-draft"');
    expect(html).toContain('href="/login"');
    expect(html).toContain('aria-label="Open navigation"');
    expect(html).toContain('aria-expanded="false"');
  });
});
