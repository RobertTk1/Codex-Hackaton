import { z } from "zod";

import { magicMirrorIdSchema } from "./common";

const utcTimestampSchema = z.iso
  .datetime({ offset: true })
  .refine((value) => value.endsWith("Z"), "Timestamp must use UTC Z notation.");

const mediaUrlSchema = z.string().trim().url().max(2_000);

export const supportedPhotoMediaTypeSchema = z.enum([
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/heic",
  "image/heif",
]);

export const photoStatusSchema = z.enum([
  "uploaded",
  "accepted",
  "rejected",
  "processing",
  "partial",
  "complete",
  "failed",
]);

export const extractionStateSchema = z.enum([
  "not_started",
  "processing",
  "ready",
  "partial",
  "failed",
]);

export const extractionPhotoStatusSchema = z.enum([
  "processing",
  "ready",
  "partial",
  "failed",
  "unavailable",
]);

export const tasteCandidateSourceSchema = z.enum([
  "extracted_garment",
  "shopify_catalog",
  "curated_fallback",
]);

export const tasteCandidateStatusSchema = z.enum(["ready", "unavailable", "retired"]);

export const tasteCalibrationStateSchema = z.enum([
  "generating",
  "ready",
  "complete",
  "recoverable_error",
]);

export const catalogReferenceSchema = z.strictObject({
  productRef: z.string().trim().min(1).max(512),
  shopRef: z.string().trim().min(1).max(512),
  variantRef: z.string().trim().min(1).max(512).nullable(),
});

export const photoUploadSlotSchema = z.strictObject({
  bucket: z.literal("customer-photos"),
  completionToken: z.string().min(20).max(4_000),
  expiresAt: utcTimestampSchema,
  path: z.string().trim().min(1).max(500),
  photoId: magicMirrorIdSchema,
  uploadToken: z.string().min(20).max(4_000),
});

export const photoSnapshotSchema = z.strictObject({
  acceptedGarmentCount: z.number().int().min(0).max(20),
  byteSize: z.number().int().min(1).max(15_728_640),
  displayUrl: mediaUrlSchema.nullable(),
  expiresAt: utcTimestampSchema,
  extractionState: extractionStateSchema,
  heightPx: z.number().int().min(640).max(12_000),
  id: magicMirrorIdSchema,
  mediaType: supportedPhotoMediaTypeSchema,
  position: z.number().int().min(1).max(12),
  rejectionCode: z.string().max(80).nullable(),
  rejectionMessageKey: z.string().max(120).nullable(),
  status: photoStatusSchema,
  widthPx: z.number().int().min(640).max(12_000),
});

export const acceptedPhotoSchema = z.strictObject({
  photo: photoSnapshotSchema,
  pollAfterMs: z.number().int().min(2_000),
  revision: z.number().int().positive(),
});

export const photoCollectionSchema = z.strictObject({
  items: z.array(photoSnapshotSchema).max(12),
});

export const photoOrderResultSchema = z.strictObject({
  items: z.array(photoSnapshotSchema).max(12),
  revision: z.number().int().positive(),
});

export const extractionPhotoSummarySchema = z.strictObject({
  acceptedGarmentCount: z.number().int().min(0).max(20),
  fallbackAvailable: z.boolean(),
  photoId: magicMirrorIdSchema,
  reviewRequired: z.boolean(),
  status: extractionPhotoStatusSchema,
});

export const extractionSummarySchema = z.strictObject({
  acceptedGarmentCount: z.number().int().min(0).max(240),
  confidenceDisclosure: z.string().trim().min(1).max(500),
  fallbackAvailable: z.boolean(),
  photos: z.array(extractionPhotoSummarySchema).max(12),
  profileId: magicMirrorIdSchema,
  reviewRequired: z.boolean(),
  revision: z.number().int().positive(),
});

export const tasteCandidateSchema = z.strictObject({
  catalogReference: catalogReferenceSchema.nullable(),
  category: z.string().trim().min(1).max(80),
  colorFamily: z.string().trim().min(1).max(80),
  id: magicMirrorIdSchema,
  imageUrl: mediaUrlSchema.nullable(),
  position: z.number().int().min(1).max(20),
  silhouette: z.string().trim().min(1).max(80),
  source: tasteCandidateSourceSchema,
  status: tasteCandidateStatusSchema,
});

export const tasteCalibrationSnapshotSchema = z.strictObject({
  completedReactions: z.number().int().min(0).max(20),
  currentCandidate: tasteCandidateSchema.nullable(),
  fallbackUsed: z.boolean(),
  maximumReactions: z.literal(20),
  minimumReactions: z.literal(12),
  profileId: magicMirrorIdSchema,
  revision: z.number().int().positive(),
  state: tasteCalibrationStateSchema,
});

export const acceptedTasteCalibrationSchema = z.strictObject({
  calibration: tasteCalibrationSnapshotSchema,
  pollAfterMs: z.number().int().min(2_000),
});

export type AcceptedPhoto = z.infer<typeof acceptedPhotoSchema>;
export type AcceptedTasteCalibration = z.infer<typeof acceptedTasteCalibrationSchema>;
export type CatalogReference = z.infer<typeof catalogReferenceSchema>;
export type ExtractionPhotoSummary = z.infer<typeof extractionPhotoSummarySchema>;
export type ExtractionSummary = z.infer<typeof extractionSummarySchema>;
export type PhotoCollection = z.infer<typeof photoCollectionSchema>;
export type PhotoOrderResult = z.infer<typeof photoOrderResultSchema>;
export type PhotoSnapshot = z.infer<typeof photoSnapshotSchema>;
export type PhotoUploadSlot = z.infer<typeof photoUploadSlotSchema>;
export type TasteCalibrationSnapshot = z.infer<typeof tasteCalibrationSnapshotSchema>;
export type TasteCandidate = z.infer<typeof tasteCandidateSchema>;
