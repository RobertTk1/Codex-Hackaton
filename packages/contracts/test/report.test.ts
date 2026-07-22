import { describe, expect, expectTypeOf, test } from "vitest";

import {
  acceptedReportRunSchema,
  fitProfileSnapshotSchema,
  recommendationCollectionSchema,
  recommendationSnapshotSchema,
  reportDocumentSchema,
  reportFeedbackReceiptSchema,
  reportRunSnapshotSchema,
  reportSectionSchema,
  type AcceptedReportRun,
  type FitProfileSnapshot,
  type RecommendationCollection,
  type ReportDocument,
} from "../src/report";

const profileId = "11111111-1111-4111-8111-111111111111";
const reportId = "22222222-2222-4222-8222-222222222222";
const recommendationId = "33333333-3333-4333-8333-333333333333";
const runId = "44444444-4444-4444-8444-444444444444";

const strength = {
  explanation: "A clear waist creates a deliberate silhouette.",
  label: "Defined shape",
} as const;

const color = {
  hex: "#D7FF3F",
  name: "Acid chartreuse",
  reason: "The warm brightness supports high-contrast styling.",
} as const;

const sections = [
  {
    content: {
      priorities: [strength],
      strengths: [strength],
      style_identity: "  Polished color maximalist  ",
      summary: "Your strongest looks pair decisive color with a clean silhouette.",
    },
    position: 1,
    sectionType: "overview",
  },
  {
    content: {
      approach_with_care: [],
      best_colors: [color, color, color, color],
      palette_name: "Electric warm brights",
      summary: "Clear warm hues echo the energy already present in your favorite looks.",
    },
    position: 2,
    sectionType: "color",
  },
  {
    content: {
      disclosure: "This is styling guidance, not an objective body classification.",
      kibbe_informed_family: "Soft dramatic-informed",
      proportion_guidance: [strength],
      shape_guidance: [strength],
      summary: "Long lines and deliberate waist definition support your preferred proportions.",
    },
    position: 3,
    sectionType: "body_style",
  },
] as const;

const reportFixture = {
  confidenceNote: "Recommendations reflect the evidence you shared and can be refined.",
  createdAt: "2026-07-22T14:30:00Z",
  id: reportId,
  profileId,
  recommendationCount: 1,
  sections,
  summary: "A confident, high-color wardrobe grounded by strong proportions.",
  title: "Your style report",
  version: 2,
} as const;

const reference = {
  productRef: "gid://shopify/Product/123",
  shopRef: "shop-123",
  variantRef: "gid://shopify/ProductVariant/456",
} as const;

const product = {
  amountMinor: 12_900,
  availability: "available",
  checkoutAvailable: true,
  currency: "USD",
  description: "A structured jacket in a saturated warm pink.",
  media: [{ alt: "Pink structured jacket", url: "https://catalog.example.test/jacket.jpg" }],
  observedAt: "2026-07-22T14:29:00Z",
  options: [{
    name: "Size",
    values: [{ available: true, exists: true, label: "M" }],
  }],
  reference,
  sellerName: "Example retailer",
  title: "Structured pink jacket",
} as const;

const recommendationFixture = {
  category: "Outerwear",
  id: recommendationId,
  outfitGroupKey: null,
  outfitGroupTitle: null,
  outfitItemPosition: null,
  position: 1,
  previewDisclosure: "AI-generated visualization; verify the current product details with the retailer.",
  previewUrl: "https://assets.example.test/previews/recommendation.jpg",
  product,
  rationale: "The saturated color and defined shoulder line reinforce two report findings.",
  reference,
  stylingNote: "Wear over a clean column of color to preserve the long line.",
  title: "A sharper layer for high-color looks",
} as const;

describe("report, recommendation, and asset contract schemas", () => {
  test("valid report and recommendation fixtures normalize and infer strict types", () => {
    const report = reportDocumentSchema.parse(reportFixture);
    const recommendations = recommendationCollectionSchema.parse({
      items: [{ ...recommendationFixture, title: "  A sharper layer for high-color looks  " }],
      nextCursor: null,
    });

    const overview = report.sections[0];
    expect(overview?.sectionType).toBe("overview");
    if (!overview || overview.sectionType !== "overview") {
      throw new Error("Expected the first fixture section to be the overview variant.");
    }
    expect(overview.content.style_identity).toBe("Polished color maximalist");
    expect(recommendations.items[0]?.title).toBe("A sharper layer for high-color looks");
    expect(recommendations.items[0]?.product?.availability).toBe("available");
    expectTypeOf(report).toEqualTypeOf<ReportDocument>();
    expectTypeOf(recommendations).toEqualTypeOf<RecommendationCollection>();
  });

  test("unknown fields are rejected at report, section, recommendation, and product boundaries", () => {
    expect(reportDocumentSchema.safeParse({ ...reportFixture, modelReasoning: "private" }).success).toBe(false);
    expect(reportDocumentSchema.safeParse({
      ...reportFixture,
      sections: [{ ...sections[0], content: { ...sections[0].content, hiddenScore: 0.9 } }, sections[1], sections[2]],
    }).success).toBe(false);
    expect(recommendationSnapshotSchema.safeParse({
      ...recommendationFixture,
      product: { ...product, checkoutUrl: "https://retailer.example.test/product" },
    }).success).toBe(false);
  });

  test("invalid report and feedback discriminators are rejected", () => {
    expect(reportSectionSchema.safeParse({ ...sections[0], sectionType: "fit" }).success).toBe(false);
    expect(reportSectionSchema.safeParse({ ...sections[0], position: 2 }).success).toBe(false);
    expect(reportFeedbackReceiptSchema.safeParse({
      createdAt: "2026-07-22T14:30:00Z",
      id: recommendationId,
      kind: "dismissed",
      reportId,
      sectionType: "overview",
      status: "open",
    }).success).toBe(false);
  });

  test("report documents require exactly three bounded section variants", () => {
    expect(reportDocumentSchema.safeParse({ ...reportFixture, sections: sections.slice(0, 2) }).success).toBe(false);
    expect(reportDocumentSchema.safeParse({ ...reportFixture, recommendationCount: 25 }).success).toBe(false);
    expect(reportDocumentSchema.safeParse({
      ...reportFixture,
      sections: [sections[0], {
        ...sections[1],
        content: { ...sections[1].content, best_colors: [color, color, color] },
      }, sections[2]],
    }).success).toBe(false);
  });

  test("report-run contracts preserve durable progress and reject unsupported states", () => {
    const accepted = acceptedReportRunSchema.parse({
      pollAfterMs: 2_000,
      run: {
        elapsedMs: 14_000,
        id: runId,
        lastErrorCode: null,
        profileId,
        profileRevision: 3,
        retryable: false,
        runSequence: 1,
        stage: "report_writing",
        status: "processing",
        updatedAt: "2026-07-22T14:30:00Z",
      },
    });

    expect(accepted.run.stage).toBe("report_writing");
    expectTypeOf(accepted).toEqualTypeOf<AcceptedReportRun>();
    expect(reportRunSnapshotSchema.safeParse({ ...accepted.run, stage: "model_thinking" }).success).toBe(false);
    expect(reportRunSnapshotSchema.safeParse({ ...accepted.run, runSequence: 4 }).success).toBe(false);
  });

  test("fit guidance remains garment-specific and bounded", () => {
    const fit = fitProfileSnapshotSchema.parse({
      disclaimer: "Fit guidance is directional and does not guarantee retailer sizing.",
      garmentTypes: [{
        confidence: "medium",
        garmentType: "jeans",
        guidance: "Start with the labeled waist and compare the retailer measurement chart.",
        hasConflict: true,
        observations: [{
          brandName: "Zara",
          garmentType: "jeans",
          sizeLabel: "L",
          sizeStatus: "known",
        }],
      }],
      overallPreference: "fitted",
    });

    expect(fit.garmentTypes[0]?.observations[0]?.garmentType).toBe("jeans");
    expectTypeOf(fit).toEqualTypeOf<FitProfileSnapshot>();
    expect(fitProfileSnapshotSchema.safeParse({
      ...fit,
      garmentTypes: [{ ...fit.garmentTypes[0], confidence: "certain" }],
    }).success).toBe(false);
  });

  test("outfit grouping is all-or-nothing and generated previews remain optional", () => {
    expect(recommendationSnapshotSchema.safeParse({
      ...recommendationFixture,
      outfitGroupKey: "event-night",
      outfitGroupTitle: null,
    }).success).toBe(false);
    expect(recommendationSnapshotSchema.safeParse({
      ...recommendationFixture,
      previewDisclosure: null,
      previewUrl: null,
    }).success).toBe(true);
    expect(recommendationSnapshotSchema.safeParse({
      ...recommendationFixture,
      outfitGroupKey: "event-night",
      outfitGroupTitle: "Event-night color story",
      outfitItemPosition: 1,
    }).success).toBe(true);
  });

  test("product projections and generated-preview metadata reject malformed external data", () => {
    expect(recommendationSnapshotSchema.safeParse({
      ...recommendationFixture,
      previewUrl: "not a valid URI",
    }).success).toBe(false);
    expect(recommendationSnapshotSchema.safeParse({
      ...recommendationFixture,
      product: { ...product, availability: "in_stock" },
    }).success).toBe(false);
    expect(recommendationSnapshotSchema.safeParse({
      ...recommendationFixture,
      product: { ...product, observedAt: "2026-07-22T10:30:00-04:00" },
    }).success).toBe(false);
  });
});
