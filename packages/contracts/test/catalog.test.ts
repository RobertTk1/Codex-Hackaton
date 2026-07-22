import { describe, expect, expectTypeOf, test } from "vitest";

import {
  alternativesInputSchema,
  bagCollectionSchema,
  bagItemInputSchema,
  catalogSearchInputSchema,
  catalogSearchResultSchema,
  handoffDestinationSchema,
  handoffPreviewSchema,
  handoffTokenInputSchema,
  productInputSchema,
  type BagCollection,
  type BagItemInput,
  type CatalogSearchInput,
  type CatalogSearchResult,
  type HandoffDestination,
  type HandoffPreview,
} from "../src/catalog";

const bagItemId = "11111111-1111-4111-8111-111111111111";
const resultSetId = "22222222-2222-4222-8222-222222222222";
const sourceId = "33333333-3333-4333-8333-333333333333";

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

const bagItem = {
  id: bagItemId,
  product,
  reference,
  savedAt: "2026-07-22T14:30:00Z",
  source: "recommendation",
} as const;

describe("catalog, bag, and retailer-handoff contract schemas", () => {
  test("valid contract fixtures normalize and infer strict TypeScript types", () => {
    const input = catalogSearchInputSchema.parse({
      category: "  Outerwear  ",
      country: "US",
      query: "  structured pink jacket  ",
      styleSignals: ["  saturated color  "],
    });
    const result = catalogSearchResultSchema.parse({
      items: [product],
      nextCursor: null,
      observedAt: "2026-07-22T14:30:00Z",
      resultSetId,
    });
    const bag = bagCollectionSchema.parse({ items: [bagItem], nextCursor: null });
    const preview = handoffPreviewSchema.parse({
      amountMinor: 12_900,
      availability: "available",
      currency: "USD",
      destinationHostname: "  retailer.example.test  ",
      disclosure: "You are continuing to the retailer, where price and availability may change.",
      expiresAt: "2026-07-22T14:35:00Z",
      handoffToken: "x".repeat(20),
      reference,
      retailerName: "Example retailer",
    });
    const destination = handoffDestinationSchema.parse({
      destinationUrl: "  https://retailer.example.test/products/jacket  ",
      expiresAt: "2026-07-22T14:35:00Z",
    });

    expect(input).toEqual({
      category: "Outerwear",
      country: "US",
      query: "structured pink jacket",
      styleSignals: ["saturated color"],
    });
    expect(result.items[0]?.reference).toEqual(reference);
    expect(bag.items[0]?.product?.observedAt).toBe("2026-07-22T14:29:00Z");
    expect(preview.destinationHostname).toBe("retailer.example.test");
    expect(destination.destinationUrl).toBe("https://retailer.example.test/products/jacket");
    expectTypeOf(input).toEqualTypeOf<CatalogSearchInput>();
    expectTypeOf(result).toEqualTypeOf<CatalogSearchResult>();
    expectTypeOf(bag).toEqualTypeOf<BagCollection>();
    expectTypeOf(preview).toEqualTypeOf<HandoffPreview>();
    expectTypeOf(destination).toEqualTypeOf<HandoffDestination>();
  });

  test("unknown fields are rejected at request, product, bag, and handoff boundaries", () => {
    expect(catalogSearchInputSchema.safeParse({
      country: "US",
      query: "jacket",
      providerPrompt: "hidden",
      styleSignals: [],
    }).success).toBe(false);
    expect(catalogSearchResultSchema.safeParse({
      items: [{ ...product, checkoutUrl: "https://retailer.example.test/jacket" }],
      nextCursor: null,
      observedAt: "2026-07-22T14:30:00Z",
      resultSetId,
    }).success).toBe(false);
    expect(bagCollectionSchema.safeParse({ items: [{ ...bagItem, ownerId: sourceId }], nextCursor: null }).success).toBe(false);
    expect(handoffPreviewSchema.safeParse({
      amountMinor: 12_900,
      availability: "available",
      checkoutUrl: "https://retailer.example.test/jacket",
      currency: "USD",
      destinationHostname: "retailer.example.test",
      disclosure: "Continue to the retailer.",
      expiresAt: "2026-07-22T14:35:00Z",
      handoffToken: "x".repeat(20),
      reference,
      retailerName: "Example retailer",
    }).success).toBe(false);
  });

  test("invalid source and availability discriminators are rejected", () => {
    expect(bagItemInputSchema.safeParse({ ...reference, source: "wishlist", sourceId }).success).toBe(false);
    expect(bagCollectionSchema.safeParse({
      items: [{ ...bagItem, source: "wishlist" }],
      nextCursor: null,
    }).success).toBe(false);
    expect(handoffPreviewSchema.safeParse({
      amountMinor: 12_900,
      availability: "in_stock",
      currency: "USD",
      destinationHostname: "retailer.example.test",
      disclosure: "Continue to the retailer.",
      expiresAt: "2026-07-22T14:35:00Z",
      handoffToken: "x".repeat(20),
      reference,
      retailerName: "Example retailer",
    }).success).toBe(false);
  });

  test("bag-source inputs require the matching source identifier", () => {
    const recommendation = bagItemInputSchema.parse({ ...reference, source: "recommendation", sourceId });
    const productDetail = bagItemInputSchema.parse({ ...reference, source: "product_detail", sourceId: null });

    expect(recommendation.sourceId).toBe(sourceId);
    expect(productDetail.sourceId).toBeNull();
    expectTypeOf(recommendation).toMatchTypeOf<BagItemInput>();
    expect(bagItemInputSchema.safeParse({ ...reference, source: "recommendation", sourceId: null }).success).toBe(false);
    expect(bagItemInputSchema.safeParse({ ...reference, source: "product_detail", sourceId }).success).toBe(false);
  });

  test("request bounds, UTC timestamps, short tokens, and non-HTTPS destinations fail closed", () => {
    expect(catalogSearchInputSchema.safeParse({ country: "CA", query: "jacket", styleSignals: [] }).success).toBe(false);
    expect(catalogSearchInputSchema.safeParse({
      country: "US",
      query: "jacket",
      styleSignals: Array.from({ length: 9 }, (_, index) => `signal-${index}`),
    }).success).toBe(false);
    expect(productInputSchema.safeParse({
      ...reference,
      selectedOptions: [{ label: "M", name: "Size", providerId: "private" }],
    }).success).toBe(false);
    expect(alternativesInputSchema.safeParse({ ...reference, styleConstraints: ["warm color"] }).success).toBe(true);
    expect(handoffTokenInputSchema.safeParse({ handoffToken: "too-short" }).success).toBe(false);
    expect(handoffDestinationSchema.safeParse({
      destinationUrl: "http://retailer.example.test/products/jacket",
      expiresAt: "2026-07-22T14:35:00Z",
    }).success).toBe(false);
    expect(handoffDestinationSchema.safeParse({
      destinationUrl: "https://retailer.example.test/products/jacket",
      expiresAt: "2026-07-22T10:35:00-04:00",
    }).success).toBe(false);
  });
});
