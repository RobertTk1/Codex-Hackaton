import { describe, expect, expectTypeOf, test } from "vitest";

import {
  brandSizeInputSchema,
  brandSizesInputSchema,
  consentInputSchema,
  consentReceiptSchema,
  conversationTurnInputSchema,
  conversationTurnResultSchema,
  favoriteBrandsInputSchema,
  profileAnswerInputSchema,
  profileResumeInputSchema,
  profileSnapshotSchema,
  transferConsumeInputSchema,
  transferPrepareInputSchema,
  transferPreparationSchema,
  transferResultSchema,
  type ConsentReceipt,
  type ConversationTurnInput,
  type ProfileSnapshot,
  type TransferResult,
} from "../src/profile";

const id = "11111111-1111-4111-8111-111111111111";
const secondId = "22222222-2222-4222-8222-222222222222";

const profileFixture = {
  adultConfirmed: true,
  age: 34,
  brandSizes: [
    {
      brandName: "Zara",
      garmentType: "jeans",
      id: secondId,
      preferenceOrder: 1,
      sizeLabel: "L",
      sizeStatus: "known",
    },
  ],
  completionBlockers: ["PHOTO_MINIMUM_NOT_MET"],
  consents: [
    {
      capturedAt: "2026-07-20T12:00:00Z",
      decision: "granted",
      policyVersion: "v1",
      purpose: "profile_processing",
    },
  ],
  currentStep: "photos",
  favoriteBrands: [
    { brandName: "Zara", id: secondId, preferenceOrder: 1 },
  ],
  fitPreference: "regular",
  gender: "woman",
  heightCm: 168,
  id,
  name: "Talisha",
  photoProgress: { accepted: 0, maximum: 12, minimum: 8, total: 0 },
  revision: 4,
  status: "draft",
  tasteProgress: { active: 0, maximum: 20, minimum: 12 },
  updatedAt: "2026-07-20T12:00:00Z",
  weightKg: null,
} as const;

describe("profile, consent, and transfer contract schemas", () => {
  test("valid profile contract fixtures parse to normalized values and infer strict types", () => {
    const profile = profileSnapshotSchema.parse({
      ...profileFixture,
      name: "  Talisha  ",
    });
    const turn = conversationTurnInputSchema.parse({
      locale: "  en-US  ",
      targetField: "fit_preference",
      text: "  Regular  ",
      turnId: secondId,
    });
    const consent = consentReceiptSchema.parse({
      capturedAt: "2026-07-20T12:00:00Z",
      decision: "granted",
      id: secondId,
      policyVersion: "  v1  ",
      purpose: "profile_processing",
    });
    const transfer = transferResultSchema.parse({
      conflictPreserved: false,
      profileId: id,
      resume: {
        currentStep: "photos",
        destination: "/onboarding",
        liveSessionId: null,
        profileId: id,
        profileStatus: "draft",
        reportRunId: null,
      },
      targetState: "transferred_draft",
    });

    expect(profile.name).toBe("Talisha");
    expect(turn).toEqual({
      locale: "en-US",
      targetField: "fit_preference",
      text: "Regular",
      turnId: secondId,
    });
    expect(consent.policyVersion).toBe("v1");
    expect(transfer.resume.destination).toBe("/onboarding");
    expectTypeOf(profile).toEqualTypeOf<ProfileSnapshot>();
    expectTypeOf(turn).toEqualTypeOf<ConversationTurnInput>();
    expectTypeOf(consent).toEqualTypeOf<ConsentReceipt>();
    expectTypeOf(transfer).toEqualTypeOf<TransferResult>();
  });

  test("unknown fields are rejected at top-level and nested profile boundaries", () => {
    expect(profileSnapshotSchema.safeParse({
      ...profileFixture,
      email: "must-not-enter-profile@example.com",
    }).success).toBe(false);

    expect(profileSnapshotSchema.safeParse({
      ...profileFixture,
      brandSizes: [{
        ...profileFixture.brandSizes[0],
        retailerProductId: "must-not-enter-profile",
      }],
    }).success).toBe(false);

    expect(transferPrepareInputSchema.safeParse({
      method: "google",
      ownerId: secondId,
      profileId: id,
    }).success).toBe(false);
  });

  test("approved profile mutation and transfer boundaries accept their exact shapes", () => {
    expect(profileResumeInputSchema.parse({ entry: "landing" })).toEqual({ entry: "landing" });
    expect(profileAnswerInputSchema.parse({
      locale: "en-US",
      reason: "customer_edit",
      text: "Relaxed",
      turnId: id,
    }).reason).toBe("customer_edit");
    expect(favoriteBrandsInputSchema.parse({
      items: [{ brandName: "Zara", preferenceOrder: 1 }],
    }).items).toHaveLength(1);
    expect(brandSizesInputSchema.parse({
      items: [{
        brandName: "Zara",
        garmentType: "tops",
        preferenceOrder: 1,
        sizeLabel: null,
        sizeStatus: "unknown",
      }],
    }).items[0]?.sizeStatus).toBe("unknown");
    expect(conversationTurnResultSchema.parse({
      acceptedField: "fit_preference",
      displayValue: "Regular",
      invalidatedSteps: ["taste", "account"],
      profile: profileFixture,
      turnId: id,
    }).invalidatedSteps).toEqual(["taste", "account"]);
    expect(transferPreparationSchema.parse({
      expiresAt: "2026-07-20T12:05:00Z",
      method: "magic_link",
      profileId: id,
    }).method).toBe("magic_link");
  });

  test("invalid discriminators are rejected", () => {
    expect(profileSnapshotSchema.safeParse({
      ...profileFixture,
      status: "processing",
    }).success).toBe(false);
    expect(consentInputSchema.safeParse({
      copySha256: "a".repeat(64),
      decision: "accepted",
      policyVersion: "v1",
      purpose: "profile_processing",
    }).success).toBe(false);
    expect(transferConsumeInputSchema.safeParse({
      confirmation: "overwrite_existing_profile",
      profileId: id,
    }).success).toBe(false);
  });

  test("brand and garment sizing states preserve garment-level fit evidence", () => {
    expect(brandSizeInputSchema.parse({
      brandName: "  Zara  ",
      garmentType: "jeans",
      preferenceOrder: 1,
      sizeLabel: "  L  ",
      sizeStatus: "known",
    })).toEqual({
      brandName: "Zara",
      garmentType: "jeans",
      preferenceOrder: 1,
      sizeLabel: "L",
      sizeStatus: "known",
    });
    expect(brandSizeInputSchema.safeParse({
      brandName: "Zara",
      garmentType: "tops",
      preferenceOrder: 2,
      sizeLabel: "M",
      sizeStatus: "unknown",
    }).success).toBe(false);
    expect(brandSizeInputSchema.safeParse({
      brandName: "Zara",
      garmentType: "jeans",
      preferenceOrder: 1,
      sizeLabel: null,
      sizeStatus: "known",
    }).success).toBe(false);
  });

  test("consent evidence rejects malformed hashes, versions, and timestamps", () => {
    expect(consentInputSchema.safeParse({
      copySha256: "A".repeat(64),
      decision: "granted",
      policyVersion: "v1",
      purpose: "photo_analysis",
    }).success).toBe(false);
    expect(consentReceiptSchema.safeParse({
      capturedAt: "2026-07-20T08:00:00-04:00",
      decision: "granted",
      id,
      policyVersion: "v1",
      purpose: "photo_analysis",
    }).success).toBe(false);
    expect(consentInputSchema.safeParse({
      copySha256: "a".repeat(64),
      decision: "granted",
      policyVersion: "   ",
      purpose: "photo_analysis",
    }).success).toBe(false);
  });

  test("transfer contracts accept only approved methods, confirmations, and destinations", () => {
    expect(transferPrepareInputSchema.safeParse({ method: "google", profileId: id }).success).toBe(true);
    expect(transferPrepareInputSchema.safeParse({ method: "password", profileId: id }).success).toBe(false);
    expect(transferConsumeInputSchema.safeParse({
      confirmation: "activate_if_no_existing_profile",
      profileId: id,
    }).success).toBe(true);
    expect(transferResultSchema.safeParse({
      conflictPreserved: false,
      profileId: id,
      resume: {
        currentStep: "photos",
        destination: "https://attacker.example",
        liveSessionId: null,
        profileId: id,
        profileStatus: "draft",
        reportRunId: null,
      },
      targetState: "transferred_draft",
    }).success).toBe(false);
  });
});
