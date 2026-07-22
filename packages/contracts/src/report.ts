import { z } from "zod";

import { magicMirrorIdSchema } from "./common";
import { catalogReferenceSchema } from "./media";

const utcTimestampSchema = z.iso
  .datetime({ offset: true })
  .refine((value) => value.endsWith("Z"), "Timestamp must use UTC Z notation.");

const uriSchema = z.string().trim().url().max(2_000);
const boundedText = (maximum: number) => z.string().trim().min(1).max(maximum);

export const reportRunStatusSchema = z.enum([
  "queued",
  "processing",
  "succeeded",
  "failed",
  "cancelled",
]);

export const reportRunStageSchema = z.enum([
  "queued",
  "profile_analysis",
  "catalog_matching",
  "report_writing",
  "preview_generation",
  "finalizing",
]);

export const reportRunSnapshotSchema = z.strictObject({
  elapsedMs: z.number().int().nonnegative(),
  id: magicMirrorIdSchema,
  lastErrorCode: z.string().max(80).nullable(),
  profileId: magicMirrorIdSchema,
  profileRevision: z.number().int().positive(),
  retryable: z.boolean(),
  runSequence: z.number().int().min(1).max(3),
  stage: reportRunStageSchema,
  status: reportRunStatusSchema,
  updatedAt: utcTimestampSchema,
});

export const acceptedReportRunSchema = z.strictObject({
  pollAfterMs: z.number().int().min(2_000),
  run: reportRunSnapshotSchema,
});

export const notificationPreferenceSchema = z.strictObject({
  enabled: z.literal(true),
});

export const strengthItemSchema = z.strictObject({
  explanation: boundedText(500),
  label: boundedText(80),
});

export const colorItemSchema = z.strictObject({
  hex: z.string().regex(/^#[0-9A-Fa-f]{6}$/),
  name: boundedText(80),
  reason: boundedText(500),
});

export const overviewSectionSchema = z.strictObject({
  content: z.strictObject({
    priorities: z.array(strengthItemSchema).min(1).max(6),
    strengths: z.array(strengthItemSchema).min(1).max(6),
    style_identity: boundedText(120),
    summary: boundedText(2_000),
  }),
  position: z.literal(1),
  sectionType: z.literal("overview"),
});

export const colorSectionSchema = z.strictObject({
  content: z.strictObject({
    approach_with_care: z.array(colorItemSchema).max(6),
    best_colors: z.array(colorItemSchema).min(4).max(12),
    palette_name: boundedText(120),
    summary: boundedText(2_000),
  }),
  position: z.literal(2),
  sectionType: z.literal("color"),
});

export const bodyStyleSectionSchema = z.strictObject({
  content: z.strictObject({
    disclosure: boundedText(500),
    kibbe_informed_family: boundedText(120),
    proportion_guidance: z.array(strengthItemSchema).min(1).max(8),
    shape_guidance: z.array(strengthItemSchema).min(1).max(8),
    summary: boundedText(2_000),
  }),
  position: z.literal(3),
  sectionType: z.literal("body_style"),
});

export const reportSectionSchema = z.discriminatedUnion("sectionType", [
  overviewSectionSchema,
  colorSectionSchema,
  bodyStyleSectionSchema,
]);

export const reportSummarySchema = z.strictObject({
  createdAt: utcTimestampSchema,
  id: magicMirrorIdSchema,
  summary: boundedText(2_000),
  title: boundedText(120),
  version: z.number().int().positive(),
});

export const fitEvidenceSchema = z.strictObject({
  brandName: boundedText(80),
  garmentType: z.enum([
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
  ]),
  sizeLabel: boundedText(40).nullable(),
  sizeStatus: z.enum(["known", "unknown", "not_applicable"]),
});

export const garmentTypeFitGuidanceSchema = z.strictObject({
  confidence: z.enum(["low", "medium", "high"]),
  garmentType: fitEvidenceSchema.shape.garmentType,
  guidance: boundedText(500),
  hasConflict: z.boolean(),
  observations: z.array(fitEvidenceSchema).min(1).max(20),
});

export const fitProfileSnapshotSchema = z.strictObject({
  disclaimer: boundedText(500),
  garmentTypes: z.array(garmentTypeFitGuidanceSchema).min(1).max(12),
  overallPreference: z.enum(["fitted", "regular", "relaxed", "varies"]),
});

export const reportDocumentSchema = z.strictObject({
  confidenceNote: boundedText(500),
  createdAt: utcTimestampSchema,
  id: magicMirrorIdSchema,
  profileId: magicMirrorIdSchema,
  recommendationCount: z.number().int().min(1).max(24),
  sections: z.array(reportSectionSchema).length(3),
  summary: boundedText(2_000),
  title: boundedText(120),
  version: z.number().int().positive(),
});

export const productOptionValueSchema = z.strictObject({
  available: z.boolean(),
  exists: z.boolean(),
  label: boundedText(80),
});

export const productOptionSchema = z.strictObject({
  name: boundedText(80),
  values: z.array(productOptionValueSchema).max(40),
});

export const productMediaSchema = z.strictObject({
  alt: z.string().trim().max(300),
  url: uriSchema,
});

export const productSnapshotSchema = z.strictObject({
  amountMinor: z.number().int().nonnegative().nullable(),
  availability: z.enum(["available", "unavailable", "unknown"]),
  checkoutAvailable: z.boolean(),
  currency: z.enum(["USD"]).nullable(),
  description: z.string().trim().max(2_000),
  media: z.array(productMediaSchema).max(12),
  observedAt: utcTimestampSchema,
  options: z.array(productOptionSchema).max(20),
  reference: catalogReferenceSchema,
  sellerName: boundedText(160),
  title: boundedText(200),
});

const recommendationFields = {
  category: boundedText(80),
  id: magicMirrorIdSchema,
  position: z.number().int().min(1).max(24),
  previewDisclosure: z.string().trim().max(500).nullable(),
  previewUrl: uriSchema.nullable(),
  product: productSnapshotSchema.nullable(),
  rationale: boundedText(2_000),
  reference: catalogReferenceSchema,
  stylingNote: boundedText(2_000),
  title: boundedText(120),
} as const;

const standaloneRecommendationSchema = z.strictObject({
  ...recommendationFields,
  outfitGroupKey: z.null(),
  outfitGroupTitle: z.null(),
  outfitItemPosition: z.null(),
});

const groupedRecommendationSchema = z.strictObject({
  ...recommendationFields,
  outfitGroupKey: boundedText(80),
  outfitGroupTitle: boundedText(120),
  outfitItemPosition: z.number().int().min(1).max(6),
});

export const recommendationSnapshotSchema = z.union([
  standaloneRecommendationSchema,
  groupedRecommendationSchema,
]);

export const recommendationCollectionSchema = z.strictObject({
  items: z.array(recommendationSnapshotSchema).max(50),
  nextCursor: z.string().max(500).nullable(),
});

export const reportFeedbackReceiptSchema = z.strictObject({
  createdAt: utcTimestampSchema,
  id: magicMirrorIdSchema,
  kind: z.enum(["helpful", "unclear", "incorrect", "recalibrate"]),
  reportId: magicMirrorIdSchema,
  sectionType: z.enum(["overview", "color", "body_style"]).nullable(),
  status: z.literal("open"),
});

export type AcceptedReportRun = z.infer<typeof acceptedReportRunSchema>;
export type FitProfileSnapshot = z.infer<typeof fitProfileSnapshotSchema>;
export type NotificationPreference = z.infer<typeof notificationPreferenceSchema>;
export type ProductSnapshot = z.infer<typeof productSnapshotSchema>;
export type RecommendationCollection = z.infer<typeof recommendationCollectionSchema>;
export type RecommendationSnapshot = z.infer<typeof recommendationSnapshotSchema>;
export type ReportDocument = z.infer<typeof reportDocumentSchema>;
export type ReportFeedbackReceipt = z.infer<typeof reportFeedbackReceiptSchema>;
export type ReportRunSnapshot = z.infer<typeof reportRunSnapshotSchema>;
export type ReportSection = z.infer<typeof reportSectionSchema>;
export type ReportSummary = z.infer<typeof reportSummarySchema>;
