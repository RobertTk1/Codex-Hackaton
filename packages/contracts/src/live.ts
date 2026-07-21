import { z } from "zod";

import { errorCodeSchema, magicMirrorIdSchema } from "./common";

const boundedReferenceSchema = z.string().trim().min(1).max(500);
const boundedTokenSchema = z.string().min(20).max(4_000);
const latencySchema = z.number().int().min(0).max(600_000).nullable();

export const utcTimestampSchema = z.iso
  .datetime({ offset: true })
  .refine((value) => value.endsWith("Z"), "Timestamp must use UTC Z notation.");

const catalogReferenceShape = {
  productRef: boundedReferenceSchema,
  shopRef: boundedReferenceSchema,
  variantRef: boundedReferenceSchema.nullable(),
} as const;

export const catalogReferenceSchema = z.strictObject(catalogReferenceShape);

export const liveSessionStatusSchema = z.enum([
  "created",
  "connecting",
  "ready",
  "reconnecting",
  "ended",
  "failed",
]);

export const voiceStateSchema = z.enum([
  "off",
  "requesting_permission",
  "connecting",
  "listening",
  "interpreting",
  "confirming",
  "acting",
  "reconnecting",
  "direct_controls",
]);

export const gestureStateSchema = z.enum([
  "off",
  "guide",
  "observing",
  "interpreting",
  "confirming",
  "accepted",
  "ignored",
  "direct_controls",
]);

export const liveSessionInputSchema = catalogReferenceSchema.extend({
  cameraConsentRecordId: magicMirrorIdSchema,
  recommendationId: magicMirrorIdSchema.nullable(),
});

export const liveTransitionInputSchema = z.strictObject({
  connectionMs: z.number().int().min(0).max(600_000).optional(),
  errorCode: errorCodeSchema.nullable().optional(),
  firstFrameMs: z.number().int().min(0).max(600_000).optional(),
  lastActionLatencyMs: z.number().int().min(0).max(600_000).optional(),
  status: z.enum(["connecting", "ready", "reconnecting", "ended", "failed"]),
});

const geminiProvidersSchema = z
  .array(z.enum(["decart", "gemini"]))
  .min(1)
  .max(2)
  .refine((providers) => new Set(providers).size === providers.length, "Providers must be unique.")
  .refine((providers) => providers.includes("gemini"), "Gemini configuration must include Gemini.");

const decartCredentialInputSchema = z.strictObject({
  providers: z.tuple([z.literal("decart")]),
});

const structuredStateCredentialInputSchema = z.strictObject({
  geminiContextMode: z.literal("structured_state"),
  geminiVisualConsentRecordId: z.null(),
  microphoneConsentRecordId: magicMirrorIdSchema,
  providers: geminiProvidersSchema,
});

const sampledVideoCredentialInputSchema = z.strictObject({
  geminiContextMode: z.literal("sampled_video"),
  geminiVisualConsentRecordId: magicMirrorIdSchema,
  microphoneConsentRecordId: magicMirrorIdSchema,
  providers: geminiProvidersSchema,
});

export const realtimeCredentialInputSchema = z.union([
  decartCredentialInputSchema,
  structuredStateCredentialInputSchema,
  sampledVideoCredentialInputSchema,
]);

export const liveSessionSnapshotSchema = z.strictObject({
  connectionMs: latencySchema,
  firstFrameMs: latencySchema,
  geminiContextMode: z.enum(["structured_state", "sampled_video"]).nullable(),
  id: magicMirrorIdSchema,
  lastActionLatencyMs: latencySchema,
  lastActionSequence: z.number().int().nonnegative(),
  lastErrorCode: errorCodeSchema.nullable(),
  profileId: magicMirrorIdSchema,
  recommendationId: magicMirrorIdSchema.nullable(),
  resultSetId: magicMirrorIdSchema.nullable(),
  selectedReference: catalogReferenceSchema,
  status: liveSessionStatusSchema,
  updatedAt: utcTimestampSchema,
  voiceEnabled: z.boolean(),
});

export const providerCredentialSchema = z.strictObject({
  expiresAt: utcTimestampSchema,
  provider: z.enum(["decart", "gemini"]),
  token: boundedTokenSchema,
});

export const realtimeCredentialBundleSchema = z
  .strictObject({
    credentials: z.array(providerCredentialSchema).min(1).max(2),
    session: liveSessionSnapshotSchema,
  })
  .superRefine((bundle, context) => {
    const providers = bundle.credentials.map((credential) => credential.provider);
    if (new Set(providers).size !== providers.length) {
      context.addIssue({
        code: "custom",
        message: "Credential providers must be unique.",
        path: ["credentials"],
      });
    }
  });

const liveActionBaseShape = {
  actionId: magicMirrorIdSchema,
  confidence: z.number().min(0).max(1).nullable(),
  observedAt: utcTimestampSchema,
  sequence: z.number().int().positive(),
  sessionId: magicMirrorIdSchema,
  source: z.enum(["direct", "voice", "gesture"]),
} as const;

const emptyArgumentsSchema = z.strictObject({});

const noArgumentActionSchema = z.strictObject({
  ...liveActionBaseShape,
  arguments: emptyArgumentsSchema,
  type: z.enum([
    "next_item",
    "previous_item",
    "end_session",
    "undo_last_selection",
  ]),
});

const selectItemActionSchema = z.strictObject({
  ...liveActionBaseShape,
  arguments: catalogReferenceSchema.extend({
    recommendationId: magicMirrorIdSchema.nullable(),
  }),
  type: z.literal("select_item"),
});

const refineResultsActionSchema = z.strictObject({
  ...liveActionBaseShape,
  arguments: z.strictObject({
    query: z.string().trim().min(1).max(300),
    resultSetId: magicMirrorIdSchema,
  }),
  type: z.literal("refine_results"),
});

const addToBagArgumentsSchema = z.discriminatedUnion("source", [
  z.strictObject({
    ...catalogReferenceShape,
    source: z.literal("recommendation"),
    sourceId: magicMirrorIdSchema,
  }),
  z.strictObject({
    ...catalogReferenceShape,
    source: z.literal("live_session"),
    sourceId: magicMirrorIdSchema,
  }),
  z.strictObject({
    ...catalogReferenceShape,
    source: z.literal("product_detail"),
    sourceId: z.null(),
  }),
]);

const addToBagActionSchema = z.strictObject({
  ...liveActionBaseShape,
  arguments: addToBagArgumentsSchema,
  type: z.literal("add_to_bag"),
});

const removeFromBagActionSchema = z.strictObject({
  ...liveActionBaseShape,
  arguments: z.strictObject({ bagItemId: magicMirrorIdSchema }),
  type: z.literal("remove_from_bag"),
});

const openRetailerActionSchema = z.strictObject({
  ...liveActionBaseShape,
  arguments: catalogReferenceSchema,
  type: z.literal("open_retailer"),
});

export const liveActionProposalSchema = z
  .discriminatedUnion("type", [
    noArgumentActionSchema,
    selectItemActionSchema,
    refineResultsActionSchema,
    addToBagActionSchema,
    removeFromBagActionSchema,
    openRetailerActionSchema,
  ])
  .superRefine((action, context) => {
    if (action.source === "direct" && action.confidence !== null) {
      context.addIssue({
        code: "custom",
        message: "Direct actions require null confidence.",
        path: ["confidence"],
      });
    }

    if (action.source === "gesture" && action.confidence === null) {
      context.addIssue({
        code: "custom",
        message: "Gesture actions require confidence.",
        path: ["confidence"],
      });
    }

    if (action.source === "gesture" && action.type === "refine_results") {
      context.addIssue({
        code: "custom",
        message: "Gestures cannot refine results.",
        path: ["type"],
      });
    }
  });

export const liveActionDecisionSchema = z.strictObject({
  actionId: magicMirrorIdSchema,
  confirmationToken: boundedTokenSchema.nullable(),
  decision: z.enum(["execute", "confirm", "reject"]),
  expiresAt: utcTimestampSchema.nullable(),
  reason: z.string().trim().min(1).max(120).nullable(),
  resultSetId: magicMirrorIdSchema.nullable(),
  sequence: z.number().int().positive(),
});

export const confirmationTokenInputSchema = z.strictObject({
  confirmationToken: boundedTokenSchema,
});

export const liveEndInputSchema = z.strictObject({
  reason: z.enum(["customer", "provider_failure", "timeout"]),
});

export type LiveActionProposal = z.infer<typeof liveActionProposalSchema>;
export type LiveSessionInput = z.infer<typeof liveSessionInputSchema>;
export type LiveSessionSnapshot = z.infer<typeof liveSessionSnapshotSchema>;
export type RealtimeCredentialInput = z.infer<typeof realtimeCredentialInputSchema>;
