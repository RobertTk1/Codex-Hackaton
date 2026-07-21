import { describe, expect, expectTypeOf, test } from "vitest";

import {
  gestureStateSchema,
  liveActionProposalSchema,
  liveSessionInputSchema,
  liveSessionSnapshotSchema,
  realtimeCredentialBundleSchema,
  realtimeCredentialInputSchema,
  voiceStateSchema,
  type LiveActionProposal,
  type LiveSessionInput,
  type RealtimeCredentialInput,
} from "../src/live";

const id = "11111111-1111-4111-8111-111111111111";
const secondId = "22222222-2222-4222-8222-222222222222";
const catalogReference = {
  productRef: "gid://shopify/Product/opaque",
  shopRef: "opaque-shop-reference",
  variantRef: "gid://shopify/ProductVariant/opaque",
} as const;

describe("live contract schemas", () => {
  test("a valid live action fixture parses to the expected normalized value", () => {
    const action = liveActionProposalSchema.parse({
      actionId: id,
      arguments: {
        ...catalogReference,
        recommendationId: null,
      },
      confidence: 0.94,
      observedAt: "2026-07-20T12:00:00Z",
      sequence: 12,
      sessionId: secondId,
      source: "gesture",
      type: "select_item",
    });

    expect(action).toEqual({
      actionId: id,
      arguments: { ...catalogReference, recommendationId: null },
      confidence: 0.94,
      observedAt: "2026-07-20T12:00:00Z",
      sequence: 12,
      sessionId: secondId,
      source: "gesture",
      type: "select_item",
    });
    expectTypeOf(action).toEqualTypeOf<LiveActionProposal>();
  });

  test("every approved action discriminator accepts only its exact argument shape", () => {
    const base = {
      actionId: id,
      confidence: null,
      observedAt: "2026-07-20T12:00:00Z",
      sequence: 1,
      sessionId: secondId,
      source: "direct",
    } as const;
    const fixtures = [
      { ...base, arguments: {}, type: "next_item" },
      { ...base, arguments: {}, type: "previous_item" },
      { ...base, arguments: {}, type: "end_session" },
      { ...base, arguments: {}, type: "undo_last_selection" },
      {
        ...base,
        arguments: { ...catalogReference, recommendationId: null },
        type: "select_item",
      },
      {
        ...base,
        arguments: { query: "more color", resultSetId: id },
        type: "refine_results",
      },
      {
        ...base,
        arguments: {
          ...catalogReference,
          source: "live_session",
          sourceId: secondId,
        },
        type: "add_to_bag",
      },
      {
        ...base,
        arguments: { bagItemId: id },
        type: "remove_from_bag",
      },
      { ...base, arguments: catalogReference, type: "open_retailer" },
    ] as const;

    expect(fixtures.map((fixture) => liveActionProposalSchema.parse(fixture).type)).toEqual([
      "next_item",
      "previous_item",
      "end_session",
      "undo_last_selection",
      "select_item",
      "refine_results",
      "add_to_bag",
      "remove_from_bag",
      "open_retailer",
    ]);
  });

  test("valid session and realtime consent fixtures infer strict types", () => {
    const session = liveSessionInputSchema.parse({
      ...catalogReference,
      cameraConsentRecordId: id,
      recommendationId: null,
    });
    const structuredVoice = realtimeCredentialInputSchema.parse({
      geminiContextMode: "structured_state",
      geminiVisualConsentRecordId: null,
      microphoneConsentRecordId: id,
      providers: ["decart", "gemini"],
    });
    const sampledVideo = realtimeCredentialInputSchema.parse({
      geminiContextMode: "sampled_video",
      geminiVisualConsentRecordId: secondId,
      microphoneConsentRecordId: id,
      providers: ["gemini"],
    });
    const sessionSnapshot = liveSessionSnapshotSchema.parse({
      connectionMs: 420,
      firstFrameMs: 1_250,
      geminiContextMode: null,
      id,
      lastActionLatencyMs: null,
      lastActionSequence: 0,
      lastErrorCode: null,
      profileId: secondId,
      recommendationId: null,
      resultSetId: null,
      selectedReference: catalogReference,
      status: "ready",
      updatedAt: "2026-07-20T12:00:00Z",
      voiceEnabled: false,
    });
    const bundle = realtimeCredentialBundleSchema.parse({
      credentials: [{
        expiresAt: "2026-07-20T12:01:00Z",
        provider: "decart",
        token: "xxxxxxxxxxxxxxxxxxxx",
      }],
      session: sessionSnapshot,
    });

    expect(session.cameraConsentRecordId).toBe(id);
    if (!("geminiVisualConsentRecordId" in structuredVoice)) {
      throw new Error("Expected a Gemini structured-state credential fixture.");
    }
    if (!("geminiVisualConsentRecordId" in sampledVideo)) {
      throw new Error("Expected a Gemini sampled-video credential fixture.");
    }
    expect(structuredVoice.geminiVisualConsentRecordId).toBeNull();
    expect(sampledVideo.geminiVisualConsentRecordId).toBe(secondId);
    expect(bundle.credentials[0]?.provider).toBe("decart");
    expectTypeOf(session).toEqualTypeOf<LiveSessionInput>();
    expectTypeOf(structuredVoice).toMatchTypeOf<RealtimeCredentialInput>();
  });

  test("unknown fields are rejected at top-level and nested boundaries", () => {
    expect(liveActionProposalSchema.safeParse({
      actionId: id,
      arguments: { destinationUrl: "https://retailer.example" },
      confidence: null,
      observedAt: "2026-07-20T12:00:00Z",
      sequence: 1,
      sessionId: secondId,
      source: "direct",
      type: "next_item",
    }).success).toBe(false);

    expect(liveSessionInputSchema.safeParse({
      ...catalogReference,
      cameraConsentRecordId: id,
      recommendationId: null,
      ownerId: secondId,
    }).success).toBe(false);
  });

  test("an invalid action discriminator is rejected", () => {
    expect(liveActionProposalSchema.safeParse({
      actionId: id,
      arguments: {},
      confidence: null,
      observedAt: "2026-07-20T12:00:00Z",
      sequence: 1,
      sessionId: secondId,
      source: "direct",
      type: "purchase_item",
    }).success).toBe(false);
  });

  test("source confidence and gesture vocabulary rules are enforced", () => {
    const base = {
      actionId: id,
      arguments: {},
      observedAt: "2026-07-20T12:00:00Z",
      sequence: 1,
      sessionId: secondId,
      type: "next_item",
    } as const;

    expect(liveActionProposalSchema.safeParse({
      ...base,
      confidence: 0.8,
      source: "direct",
    }).success).toBe(false);
    expect(liveActionProposalSchema.safeParse({
      ...base,
      confidence: null,
      source: "gesture",
    }).success).toBe(false);
    expect(liveActionProposalSchema.safeParse({
      ...base,
      arguments: { query: "more color", resultSetId: id },
      confidence: 0.9,
      source: "gesture",
      type: "refine_results",
    }).success).toBe(false);
  });

  test("consent and source-lineage combinations reject malformed input", () => {
    expect(realtimeCredentialInputSchema.safeParse({
      geminiContextMode: "structured_state",
      geminiVisualConsentRecordId: secondId,
      microphoneConsentRecordId: id,
      providers: ["gemini"],
    }).success).toBe(false);
    expect(realtimeCredentialInputSchema.safeParse({
      geminiContextMode: "sampled_video",
      geminiVisualConsentRecordId: null,
      microphoneConsentRecordId: id,
      providers: ["gemini"],
    }).success).toBe(false);
    expect(liveActionProposalSchema.safeParse({
      actionId: id,
      arguments: {
        ...catalogReference,
        source: "product_detail",
        sourceId: secondId,
      },
      confidence: null,
      observedAt: "2026-07-20T12:00:00Z",
      sequence: 1,
      sessionId: secondId,
      source: "direct",
      type: "add_to_bag",
    }).success).toBe(false);
  });

  test("sequence, time, and transient-state discriminators stay bounded", () => {
    expect(liveActionProposalSchema.safeParse({
      actionId: id,
      arguments: {},
      confidence: null,
      observedAt: "2026-07-20T08:00:00-04:00",
      sequence: 0,
      sessionId: secondId,
      source: "direct",
      type: "next_item",
    }).success).toBe(false);
    expect(voiceStateSchema.safeParse("recording_transcript").success).toBe(false);
    expect(gestureStateSchema.safeParse("purchase_confirmed").success).toBe(false);
  });
});
