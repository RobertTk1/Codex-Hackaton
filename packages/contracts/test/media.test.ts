import { describe, expect, expectTypeOf, test } from "vitest";

import {
  acceptedPhotoSchema,
  acceptedTasteCalibrationSchema,
  extractionSummarySchema,
  photoCollectionSchema,
  photoOrderResultSchema,
  photoSnapshotSchema,
  photoUploadSlotSchema,
  tasteCalibrationSnapshotSchema,
  tasteCandidateSchema,
  type AcceptedPhoto,
  type ExtractionSummary,
  type PhotoUploadSlot,
  type TasteCalibrationSnapshot,
} from "../src/media";

const profileId = "11111111-1111-4111-8111-111111111111";
const photoId = "22222222-2222-4222-8222-222222222222";
const candidateId = "33333333-3333-4333-8333-333333333333";

const photoFixture = {
  acceptedGarmentCount: 2,
  byteSize: 4_200_000,
  displayUrl: "https://assets.example.test/photos/preview",
  expiresAt: "2026-08-20T12:00:00Z",
  extractionState: "ready",
  heightPx: 2400,
  id: photoId,
  mediaType: "image/jpeg",
  position: 1,
  rejectionCode: null,
  rejectionMessageKey: null,
  status: "complete",
  widthPx: 1600,
} as const;

const candidateFixture = {
  catalogReference: {
    productRef: "gid://shopify/Product/123",
    shopRef: "shop-123",
    variantRef: "gid://shopify/ProductVariant/456",
  },
  category: "Jackets",
  colorFamily: "Warm brights",
  id: candidateId,
  imageUrl: "https://catalog.example.test/product/123.jpg",
  position: 1,
  silhouette: "Structured cropped",
  source: "shopify_catalog",
  status: "ready",
} as const;

describe("photo, extraction, and taste contract schemas", () => {
  test("valid media fixtures parse to normalized values and infer strict types", () => {
    const slot = photoUploadSlotSchema.parse({
      bucket: "customer-photos",
      completionToken: "completion-token-1234567890",
      expiresAt: "2026-07-22T14:00:00Z",
      path: "  profiles/anonymous/photos/source.jpg  ",
      photoId,
      uploadToken: "upload-token-1234567890",
    });
    const accepted = acceptedPhotoSchema.parse({
      photo: photoFixture,
      pollAfterMs: 2_000,
      revision: 3,
    });
    const calibration = tasteCalibrationSnapshotSchema.parse({
      completedReactions: 5,
      currentCandidate: { ...candidateFixture, category: "  Jackets  " },
      fallbackUsed: false,
      maximumReactions: 20,
      minimumReactions: 12,
      profileId,
      revision: 7,
      state: "ready",
    });

    expect(slot.path).toBe("profiles/anonymous/photos/source.jpg");
    expect(accepted.photo.mediaType).toBe("image/jpeg");
    expect(calibration.currentCandidate?.category).toBe("Jackets");
    expectTypeOf(slot).toEqualTypeOf<PhotoUploadSlot>();
    expectTypeOf(accepted).toEqualTypeOf<AcceptedPhoto>();
    expectTypeOf(calibration).toEqualTypeOf<TasteCalibrationSnapshot>();
  });

  test("unknown fields are rejected at top-level and nested media boundaries", () => {
    expect(photoSnapshotSchema.safeParse({
      ...photoFixture,
      rawStoragePath: "must-not-cross-the-boundary",
    }).success).toBe(false);
    expect(tasteCandidateSchema.safeParse({
      ...candidateFixture,
      catalogReference: {
        ...candidateFixture.catalogReference,
        checkoutUrl: "https://retailer.example.test/checkout",
      },
    }).success).toBe(false);
    expect(extractionSummarySchema.safeParse({
      acceptedGarmentCount: 2,
      confidenceDisclosure: "Some garments may need review.",
      fallbackAvailable: true,
      photos: [{
        acceptedGarmentCount: 2,
        fallbackAvailable: true,
        photoId,
        providerPayload: {},
        reviewRequired: false,
        status: "ready",
      }],
      profileId,
      reviewRequired: false,
      revision: 1,
    }).success).toBe(false);
  });

  test("invalid photo, extraction, and taste discriminators are rejected", () => {
    expect(photoSnapshotSchema.safeParse({
      ...photoFixture,
      status: "approved",
    }).success).toBe(false);
    expect(extractionSummarySchema.safeParse({
      acceptedGarmentCount: 0,
      confidenceDisclosure: "Extraction is unavailable, so direct style signals will be used.",
      fallbackAvailable: true,
      photos: [{
        acceptedGarmentCount: 0,
        fallbackAvailable: true,
        photoId,
        reviewRequired: false,
        status: "timed_out",
      }],
      profileId,
      reviewRequired: false,
      revision: 1,
    }).success).toBe(false);
    expect(tasteCandidateSchema.safeParse({
      ...candidateFixture,
      source: "model_generated",
    }).success).toBe(false);
    expect(tasteCalibrationSnapshotSchema.safeParse({
      completedReactions: 0,
      currentCandidate: null,
      fallbackUsed: false,
      maximumReactions: 20,
      minimumReactions: 12,
      profileId,
      revision: 1,
      state: "failed",
    }).success).toBe(false);
  });

  test("photo contracts enforce approved upload and image bounds", () => {
    expect(photoUploadSlotSchema.safeParse({
      bucket: "public-photos",
      completionToken: "completion-token-1234567890",
      expiresAt: "2026-07-22T14:00:00Z",
      path: "profiles/anonymous/photos/source.jpg",
      photoId,
      uploadToken: "upload-token-1234567890",
    }).success).toBe(false);
    expect(photoSnapshotSchema.safeParse({
      ...photoFixture,
      byteSize: 15_728_641,
    }).success).toBe(false);
    expect(photoSnapshotSchema.safeParse({
      ...photoFixture,
      mediaType: "image/gif",
    }).success).toBe(false);
    expect(photoSnapshotSchema.safeParse({
      ...photoFixture,
      widthPx: 639,
    }).success).toBe(false);
  });

  test("media timestamps and display URLs fail closed", () => {
    expect(photoSnapshotSchema.safeParse({
      ...photoFixture,
      displayUrl: "not a valid URI",
    }).success).toBe(false);
    expect(photoSnapshotSchema.safeParse({
      ...photoFixture,
      expiresAt: "2026-08-20T08:00:00-04:00",
    }).success).toBe(false);
    expect(photoUploadSlotSchema.safeParse({
      bucket: "customer-photos",
      completionToken: "short",
      expiresAt: "2026-07-22T14:00:00Z",
      path: "profiles/anonymous/photos/source.jpg",
      photoId,
      uploadToken: "short",
    }).success).toBe(false);
  });

  test("collection and extraction contracts preserve bounded partial progress", () => {
    expect(photoCollectionSchema.parse({ items: [photoFixture] }).items).toHaveLength(1);
    expect(photoOrderResultSchema.parse({
      items: [photoFixture],
      revision: 4,
    }).revision).toBe(4);
    const extraction = extractionSummarySchema.parse({
      acceptedGarmentCount: 2,
      confidenceDisclosure: "  Two garments were found; one photo needs review.  ",
      fallbackAvailable: true,
      photos: [{
        acceptedGarmentCount: 2,
        fallbackAvailable: true,
        photoId,
        reviewRequired: true,
        status: "partial",
      }],
      profileId,
      reviewRequired: true,
      revision: 5,
    });

    expect(extraction.confidenceDisclosure).toBe("Two garments were found; one photo needs review.");
    expect(extraction.photos[0]?.status).toBe("partial");
    expectTypeOf(extraction).toEqualTypeOf<ExtractionSummary>();
  });

  test("taste contracts preserve all approved candidate sources and fallback state", () => {
    for (const [source, catalogReference] of [
      ["extracted_garment", null],
      ["shopify_catalog", candidateFixture.catalogReference],
      ["curated_fallback", null],
    ] as const) {
      expect(tasteCandidateSchema.safeParse({
        ...candidateFixture,
        catalogReference,
        source,
      }).success).toBe(true);
    }
    const accepted = acceptedTasteCalibrationSchema.parse({
      calibration: {
        completedReactions: 0,
        currentCandidate: null,
        fallbackUsed: true,
        maximumReactions: 20,
        minimumReactions: 12,
        profileId,
        revision: 2,
        state: "generating",
      },
      pollAfterMs: 2_000,
    });

    expect(accepted.calibration.fallbackUsed).toBe(true);
    expect(tasteCalibrationSnapshotSchema.safeParse({
      ...accepted.calibration,
      maximumReactions: 21,
    }).success).toBe(false);
  });
});
