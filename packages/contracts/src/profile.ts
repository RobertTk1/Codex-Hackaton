import { z } from "zod";

import { magicMirrorIdSchema } from "./common";

const utcTimestampSchema = z.iso
  .datetime({ offset: true })
  .refine((value) => value.endsWith("Z"), "Timestamp must use UTC Z notation.");

const uniqueStrings = (values: readonly string[]) => new Set(values).size === values.length;

const brandNameSchema = z.string().trim().min(1).max(80);
const preferenceOrderSchema = z.number().int().min(1).max(20);

export const profileStatusSchema = z.enum(["draft", "submitted", "active", "archived"]);
export const profileCurrentStepSchema = z.enum([
  "welcome",
  "personal_details",
  "brand_sizing",
  "photos",
  "photo_review",
  "taste",
  "account",
  "profile_review",
  "complete",
]);
export const personalProfileFieldSchema = z.enum([
  "name",
  "adult_confirmation",
  "gender",
  "age",
  "height",
  "weight",
  "fit_preference",
]);
export const conversationTargetFieldSchema = z.enum([
  ...personalProfileFieldSchema.options,
  "favorite_brands",
  "brand_sizes",
]);
export const fitPreferenceSchema = z.enum(["fitted", "regular", "relaxed", "varies"]);
export const garmentTypeSchema = z.enum([
  "tops",
  "knitwear",
  "dresses",
  "skirts",
  "jeans",
  "trousers",
  "shorts",
  "outerwear",
  "activewear",
  "swimwear",
  "shoes",
  "other",
]);
export const consentPurposeSchema = z.enum([
  "profile_processing",
  "photo_analysis",
  "garment_extraction",
  "generated_likeness_preview",
  "account_connection",
  "live_camera",
  "live_microphone",
  "gemini_visual_context",
]);
export const consentDecisionSchema = z.enum(["granted", "revoked"]);

export const profileResumeInputSchema = z.strictObject({
  entry: z.enum(["landing", "login", "new_report"]),
});

export const conversationTurnInputSchema = z.strictObject({
  locale: z.string().trim().min(2).max(35),
  targetField: conversationTargetFieldSchema,
  text: z.string().trim().min(1).max(500),
  turnId: magicMirrorIdSchema,
});

export const profileAnswerInputSchema = z.strictObject({
  locale: z.string().trim().min(2).max(35),
  reason: z.literal("customer_edit"),
  text: z.string().trim().min(1).max(500),
  turnId: magicMirrorIdSchema,
});

export const favoriteBrandInputSchema = z.strictObject({
  brandName: brandNameSchema,
  preferenceOrder: preferenceOrderSchema,
});

export const favoriteBrandsInputSchema = z.strictObject({
  items: z.array(favoriteBrandInputSchema).min(1).max(20),
});

const knownBrandSizeInputSchema = z.strictObject({
  brandName: brandNameSchema,
  garmentType: garmentTypeSchema,
  preferenceOrder: preferenceOrderSchema,
  sizeLabel: z.string().trim().min(1).max(40),
  sizeStatus: z.literal("known"),
});

const unknownBrandSizeInputSchema = z.strictObject({
  brandName: brandNameSchema,
  garmentType: garmentTypeSchema,
  preferenceOrder: preferenceOrderSchema,
  sizeLabel: z.null(),
  sizeStatus: z.literal("unknown"),
});

const notApplicableBrandSizeInputSchema = z.strictObject({
  brandName: brandNameSchema,
  garmentType: garmentTypeSchema,
  preferenceOrder: preferenceOrderSchema,
  sizeLabel: z.null(),
  sizeStatus: z.literal("not_applicable"),
});

export const brandSizeInputSchema = z.discriminatedUnion("sizeStatus", [
  knownBrandSizeInputSchema,
  unknownBrandSizeInputSchema,
  notApplicableBrandSizeInputSchema,
]);

export const brandSizesInputSchema = z.strictObject({
  items: z.array(brandSizeInputSchema).max(20),
});

export const consentInputSchema = z.strictObject({
  copySha256: z.string().regex(/^[a-f0-9]{64}$/),
  decision: consentDecisionSchema,
  policyVersion: z.string().trim().min(1).max(80),
  purpose: consentPurposeSchema,
});

export const favoriteBrandSnapshotSchema = favoriteBrandInputSchema.extend({
  id: magicMirrorIdSchema,
});

export const brandSizeSnapshotSchema = z.discriminatedUnion("sizeStatus", [
  knownBrandSizeInputSchema.extend({ id: magicMirrorIdSchema }),
  unknownBrandSizeInputSchema.extend({ id: magicMirrorIdSchema }),
  notApplicableBrandSizeInputSchema.extend({ id: magicMirrorIdSchema }),
]);

export const consentSummarySchema = z.strictObject({
  capturedAt: utcTimestampSchema,
  decision: consentDecisionSchema,
  policyVersion: z.string().trim().min(1).max(80),
  purpose: consentPurposeSchema,
});

export const consentReceiptSchema = consentSummarySchema.extend({
  id: magicMirrorIdSchema,
});

export const photoProgressSchema = z.strictObject({
  accepted: z.number().int().min(0).max(12),
  maximum: z.literal(12),
  minimum: z.literal(8),
  total: z.number().int().min(0).max(12),
});

export const tasteProgressSchema = z.strictObject({
  active: z.number().int().min(0).max(20),
  maximum: z.literal(20),
  minimum: z.literal(12),
});

export const profileSnapshotSchema = z.strictObject({
  adultConfirmed: z.boolean(),
  age: z.number().int().min(18).max(120).nullable(),
  brandSizes: z.array(brandSizeSnapshotSchema).max(20),
  completionBlockers: z.array(z.string().min(1).max(80).regex(/^[A-Z0-9_]+$/)).max(20),
  consents: z.array(consentSummarySchema).max(8),
  currentStep: profileCurrentStepSchema,
  favoriteBrands: z.array(favoriteBrandSnapshotSchema).max(20),
  fitPreference: fitPreferenceSchema.nullable(),
  gender: z.string().trim().min(1).max(80).nullable(),
  heightCm: z.number().min(80).max(250).nullable(),
  id: magicMirrorIdSchema,
  name: z.string().trim().min(1).max(120).nullable(),
  photoProgress: photoProgressSchema,
  revision: z.number().int().positive(),
  status: profileStatusSchema,
  tasteProgress: tasteProgressSchema,
  updatedAt: utcTimestampSchema,
  weightKg: z.number().min(25).max(400).nullable(),
});

const invalidatedStepSchema = z.enum([
  "personal_details",
  "brand_sizing",
  "photos",
  "photo_review",
  "taste",
  "account",
  "profile_review",
]);

export const conversationTurnResultSchema = z.strictObject({
  acceptedField: conversationTargetFieldSchema,
  displayValue: z.string().trim().min(1).max(500),
  invalidatedSteps: z
    .array(invalidatedStepSchema)
    .max(8)
    .refine(uniqueStrings, "Invalidated steps must be unique."),
  profile: profileSnapshotSchema,
  turnId: magicMirrorIdSchema,
});

const nullableProfileStatusSchema = z.union([profileStatusSchema, z.null()]);
const nullableProfileStepSchema = z.union([profileCurrentStepSchema, z.null()]);

export const resumeDestinationSchema = z.union([
  z.literal("/"),
  z.literal("/onboarding"),
  z.literal("/report"),
  z.literal("/style-home"),
  z.string().regex(/^\/(analysis|live)\/[0-9a-f-]{36}$/),
]);

export const resumeDecisionSchema = z.strictObject({
  currentStep: nullableProfileStepSchema,
  destination: resumeDestinationSchema,
  liveSessionId: magicMirrorIdSchema.nullable(),
  profileId: magicMirrorIdSchema.nullable(),
  profileStatus: nullableProfileStatusSchema,
  reportRunId: magicMirrorIdSchema.nullable(),
});

export const transferPrepareInputSchema = z.strictObject({
  method: z.enum(["google", "magic_link"]),
  profileId: magicMirrorIdSchema,
});

export const transferConsumeInputSchema = z.strictObject({
  confirmation: z.enum(["preserve_as_new_draft", "activate_if_no_existing_profile"]),
  profileId: magicMirrorIdSchema,
});

export const transferPreparationSchema = z.strictObject({
  expiresAt: utcTimestampSchema,
  method: z.enum(["google", "magic_link"]),
  profileId: magicMirrorIdSchema,
});

export const transferResultSchema = z.strictObject({
  conflictPreserved: z.boolean(),
  profileId: magicMirrorIdSchema,
  resume: resumeDecisionSchema,
  targetState: z.enum(["transferred_draft", "derived_draft"]),
});

export type BrandSizeInput = z.infer<typeof brandSizeInputSchema>;
export type BrandSizeSnapshot = z.infer<typeof brandSizeSnapshotSchema>;
export type BrandSizesInput = z.infer<typeof brandSizesInputSchema>;
export type ConsentInput = z.infer<typeof consentInputSchema>;
export type ConsentReceipt = z.infer<typeof consentReceiptSchema>;
export type ConsentSummary = z.infer<typeof consentSummarySchema>;
export type ConversationTurnInput = z.infer<typeof conversationTurnInputSchema>;
export type ConversationTurnResult = z.infer<typeof conversationTurnResultSchema>;
export type FavoriteBrandInput = z.infer<typeof favoriteBrandInputSchema>;
export type FavoriteBrandsInput = z.infer<typeof favoriteBrandsInputSchema>;
export type FitPreference = z.infer<typeof fitPreferenceSchema>;
export type GarmentType = z.infer<typeof garmentTypeSchema>;
export type ProfileAnswerInput = z.infer<typeof profileAnswerInputSchema>;
export type ProfileResumeInput = z.infer<typeof profileResumeInputSchema>;
export type ProfileSnapshot = z.infer<typeof profileSnapshotSchema>;
export type ResumeDecision = z.infer<typeof resumeDecisionSchema>;
export type TransferConsumeInput = z.infer<typeof transferConsumeInputSchema>;
export type TransferPrepareInput = z.infer<typeof transferPrepareInputSchema>;
export type TransferPreparation = z.infer<typeof transferPreparationSchema>;
export type TransferResult = z.infer<typeof transferResultSchema>;
