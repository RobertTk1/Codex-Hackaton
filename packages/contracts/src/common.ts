import { z } from "zod";

export const magicMirrorIdSchema = z.uuid();
export const requestIdSchema = magicMirrorIdSchema;

export const opaqueCursorSchema = z.string().trim().min(1).max(2_048);

export const paginationQuerySchema = z.strictObject({
  cursor: opaqueCursorSchema.optional(),
  limit: z
    .union([
      z.number(),
      z.string().regex(/^[1-9]\d*$/).transform(Number),
    ])
    .pipe(z.number().int().min(1).max(50))
    .default(20),
});

export function createCollectionSchema<const ItemSchema extends z.ZodType>(itemSchema: ItemSchema) {
  return z.strictObject({
    items: z.array(itemSchema).max(50),
    nextCursor: opaqueCursorSchema.nullable(),
  });
}

export const errorCodes = [
  "ACCESS_DENIED",
  "ACCOUNT_DELETION_IN_PROGRESS",
  "ADULT_ELIGIBILITY_REQUIRED",
  "ANONYMOUS_ACCOUNT_REQUIRED",
  "ANSWER_NEEDS_CLARIFICATION",
  "AUTH_CALLBACK_INVALID",
  "AUTH_METHOD_UNAVAILABLE",
  "AUTH_RATE_LIMITED",
  "AUTH_REQUIRED",
  "AUTH_SESSION_EXPIRED",
  "BAG_ITEM_NOT_FOUND",
  "BAG_SOURCE_INVALID",
  "BRAND_SIZE_INVALID",
  "CAMERA_PERMISSION_DENIED",
  "CANDIDATES_NOT_READY",
  "CANDIDATE_GENERATION_FAILED",
  "CANDIDATE_NOT_FOUND",
  "CANDIDATE_UNAVAILABLE",
  "CATALOG_QUERY_INVALID",
  "CATALOG_RATE_LIMITED",
  "CATALOG_REFERENCE_INVALID",
  "CATALOG_RESPONSE_INVALID",
  "CATALOG_TEMPORARILY_UNAVAILABLE",
  "CONSENT_REQUIRED",
  "CONSENT_VERSION_INVALID",
  "DELETION_CONFIRMATION_REQUIRED",
  "DEPENDENT_WORK_ALREADY_PUBLISHED",
  "DRAFT_ALREADY_EXISTS",
  "DUPLICATE_BRAND_GARMENT_TYPE",
  "DUPLICATE_FAVORITE_BRAND",
  "DUPLICATE_PHOTO",
  "EMAIL_NOT_AVAILABLE",
  "EXTRACTION_ATTEMPTS_EXHAUSTED",
  "FAVORITE_BRAND_INVALID",
  "FAVORITE_BRAND_REQUIRED",
  "FEEDBACK_INVALID",
  "FIT_PREFERENCE_INVALID",
  "GARMENT_NOT_FOUND",
  "GARMENT_REVIEW_NOT_REQUIRED",
  "GESTURE_LOW_CONFIDENCE",
  "GESTURE_UNAVAILABLE",
  "HANDOFF_STATE_CHANGED",
  "HANDOFF_TOKEN_EXPIRED",
  "IDEMPOTENCY_KEY_REQUIRED",
  "IDEMPOTENCY_KEY_REUSED",
  "INTERNAL_ERROR",
  "LIVE_ACTION_DUPLICATE",
  "LIVE_ACTION_INVALID",
  "LIVE_ACTION_NOT_AVAILABLE",
  "LIVE_ACTION_STALE",
  "LIVE_CONFIRMATION_EXPIRED",
  "LIVE_SESSION_LIMIT_REACHED",
  "LIVE_SESSION_NOT_FOUND",
  "LIVE_SESSION_TERMINAL",
  "LIVE_TRANSITION_INVALID",
  "MICROPHONE_PERMISSION_DENIED",
  "NO_ACTIVE_PROFILE",
  "PERMANENT_ACCOUNT_REQUIRED",
  "PHOTO_DECODE_FAILED",
  "PHOTO_DELETE_FAILED",
  "PHOTO_DIMENSIONS_INVALID",
  "PHOTO_EXPIRED",
  "PHOTO_LIMIT_REACHED",
  "PHOTO_MINIMUM_NOT_MET",
  "PHOTO_NOT_FOUND",
  "PHOTO_NOT_RETRYABLE",
  "PHOTO_ORDER_INVALID",
  "PHOTO_REJECTED",
  "PHOTO_REPLACEMENT_STALE",
  "PHOTO_TOO_LARGE",
  "PHOTO_TYPE_UNSUPPORTED",
  "PRODUCT_NOT_FOUND",
  "PRODUCT_UNAVAILABLE",
  "PROFILE_EXPIRED",
  "PROFILE_FIELD_INVALID",
  "PROFILE_INCOMPLETE",
  "PROFILE_LIMIT_REACHED",
  "PROFILE_NOT_EDITABLE",
  "PROFILE_NOT_FOUND",
  "PROVIDER_AUTHENTICATION_FAILED",
  "PROVIDER_QUOTA_EXCEEDED",
  "PROVIDER_RESPONSE_INVALID",
  "PROVIDER_TIMEOUT",
  "RATE_LIMITED",
  "REACTION_ALREADY_UNDONE",
  "REACTION_NOT_FOUND",
  "REALTIME_PROVIDER_UNAVAILABLE",
  "REALTIME_UNSUPPORTED",
  "RECALIBRATION_CONFIRMATION_REQUIRED",
  "REPORT_ALREADY_SUCCEEDED",
  "REPORT_ATTEMPTS_EXHAUSTED",
  "REPORT_GENERATION_FAILED",
  "REPORT_GENERATION_TIMEOUT",
  "REPORT_NOT_FOUND",
  "REPORT_NOT_RETRYABLE",
  "REPORT_OUTPUT_INVALID",
  "REPORT_RUN_NOT_FOUND",
  "REPORT_SECTION_NOT_FOUND",
  "RETAILER_LINK_UNAVAILABLE",
  "REVISION_CONFLICT",
  "SERVICE_UNAVAILABLE",
  "STYLE_EVIDENCE_INSUFFICIENT",
  "TASTE_MINIMUM_NOT_MET",
  "TRANSFER_ALREADY_PREPARED",
  "TRANSFER_CONFLICT_REQUIRES_CONFIRMATION",
  "TRANSFER_EXPIRED",
  "TRANSFER_NOT_FOUND",
  "TRANSFER_REPLAYED",
  "TRANSFER_SOURCE_CHANGED",
  "TRANSFER_TARGET_INVALID",
  "TRANSFER_TOKEN_MISSING",
  "UPLOAD_DECLARATION_INVALID",
  "UPLOAD_NOT_FOUND",
  "UPLOAD_SLOT_EXPIRED",
  "UPLOAD_TOKEN_INVALID",
  "VARIANT_UNAVAILABLE",
  "VOICE_CONNECTION_FAILED",
  "VOICE_REQUEST_UNCLEAR",
] as const;

export const errorCodeSchema = z.enum(errorCodes);

const messageKeySchema = z.string().trim().min(1).max(120).regex(/^[A-Za-z][A-Za-z0-9_.-]*$/);
const fieldNameSchema = z.string().trim().min(1).max(120).regex(/^[A-Za-z][A-Za-z0-9_.-]*$/);

const emptyErrorDetailsSchema = z.strictObject({});
const fieldErrorDetailsSchema = z.strictObject({
  field: fieldNameSchema,
  reason: messageKeySchema,
});
const fieldsErrorDetailsSchema = z.strictObject({
  fields: z.array(fieldErrorDetailsSchema).min(1).max(50),
});
const revisionErrorDetailsSchema = z.strictObject({
  currentRevision: z.number().int().positive(),
  expectedRevision: z.number().int().positive(),
});
const retryErrorDetailsSchema = z.strictObject({
  retryAfterMs: z.number().int().nonnegative(),
  retryable: z.boolean(),
});
const stageErrorDetailsSchema = z.strictObject({
  retryable: z.boolean(),
  stage: messageKeySchema,
});
const itemErrorDetailsSchema = z.strictObject({
  itemId: magicMirrorIdSchema,
  reason: messageKeySchema,
});
const minimumErrorDetailsSchema = z.strictObject({
  current: z.number().int().nonnegative(),
  minimum: z.number().int().nonnegative(),
});
const authMethodsErrorDetailsSchema = z.strictObject({
  allowedMethods: z
    .array(z.enum(["google", "magic_link"]))
    .min(1)
    .max(2)
    .refine((methods) => new Set(methods).size === methods.length, "Auth methods must be unique."),
});

export const errorDetailsSchema = z.union([
  emptyErrorDetailsSchema,
  fieldErrorDetailsSchema,
  fieldsErrorDetailsSchema,
  revisionErrorDetailsSchema,
  retryErrorDetailsSchema,
  stageErrorDetailsSchema,
  itemErrorDetailsSchema,
  minimumErrorDetailsSchema,
  authMethodsErrorDetailsSchema,
]);

export const normalizedErrorSchema = z.strictObject({
  code: errorCodeSchema,
  details: errorDetailsSchema,
  error: z.string().trim().min(1).max(240),
  requestId: requestIdSchema,
});

export type ErrorCode = z.infer<typeof errorCodeSchema>;
export type MagicMirrorId = z.infer<typeof magicMirrorIdSchema>;
export type NormalizedError = z.infer<typeof normalizedErrorSchema>;
export type PaginationQuery = z.infer<typeof paginationQuerySchema>;
