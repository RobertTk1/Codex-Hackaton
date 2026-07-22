import { z } from "zod";

import { magicMirrorIdSchema } from "./common";
import { catalogReferenceSchema } from "./media";
import { productSnapshotSchema } from "./report";

const utcTimestampSchema = z.iso
  .datetime({ offset: true })
  .refine((value) => value.endsWith("Z"), "Timestamp must use UTC Z notation.");

const boundedText = (maximum: number) => z.string().trim().min(1).max(maximum);

const selectedProductOptionSchema = z.strictObject({
  label: boundedText(80),
  name: boundedText(80),
});

export const catalogSearchInputSchema = z.strictObject({
  category: boundedText(80).optional(),
  color: boundedText(80).optional(),
  country: z.literal("US"),
  priceMinorMax: z.number().int().nonnegative().optional(),
  query: boundedText(500),
  size: boundedText(40).optional(),
  styleSignals: z.array(boundedText(80)).max(8),
});

export const productInputSchema = catalogReferenceSchema.extend({
  selectedOptions: z.array(selectedProductOptionSchema).max(12).optional(),
});

export const alternativesInputSchema = catalogReferenceSchema.extend({
  styleConstraints: z.array(boundedText(80)).max(8).optional(),
});

const bagReferenceFields = catalogReferenceSchema.shape;

export const bagItemInputSchema = z.discriminatedUnion("source", [
  z.strictObject({
    ...bagReferenceFields,
    source: z.literal("recommendation"),
    sourceId: magicMirrorIdSchema,
  }),
  z.strictObject({
    ...bagReferenceFields,
    source: z.literal("live_session"),
    sourceId: magicMirrorIdSchema,
  }),
  z.strictObject({
    ...bagReferenceFields,
    source: z.literal("product_detail"),
    sourceId: z.null(),
  }),
]);

export const handoffTokenInputSchema = z.strictObject({
  handoffToken: z.string().min(20).max(4_000),
});

export const catalogSearchResultSchema = z.strictObject({
  items: z.array(productSnapshotSchema).max(50),
  nextCursor: z.string().max(500).nullable(),
  observedAt: utcTimestampSchema,
  resultSetId: magicMirrorIdSchema,
});

export const bagItemSourceSchema = z.enum([
  "recommendation",
  "live_session",
  "product_detail",
]);

export const bagItemSnapshotSchema = z.strictObject({
  id: magicMirrorIdSchema,
  product: productSnapshotSchema.nullable(),
  reference: catalogReferenceSchema,
  savedAt: utcTimestampSchema,
  source: bagItemSourceSchema,
});

export const bagCollectionSchema = z.strictObject({
  items: z.array(bagItemSnapshotSchema).max(50),
  nextCursor: z.string().max(500).nullable(),
});

export const handoffPreviewSchema = z.strictObject({
  amountMinor: z.number().int().nonnegative().nullable(),
  availability: z.enum(["available", "unavailable", "unknown"]),
  currency: z.enum(["USD"]).nullable(),
  destinationHostname: boundedText(253),
  disclosure: boundedText(500),
  expiresAt: utcTimestampSchema,
  handoffToken: z.string().min(20).max(4_000),
  reference: catalogReferenceSchema,
  retailerName: boundedText(160),
});

export const handoffDestinationSchema = z.strictObject({
  destinationUrl: z
    .string()
    .trim()
    .url()
    .max(2_000)
    .refine((value) => new URL(value).protocol === "https:", "Retailer destination must use HTTPS."),
  expiresAt: utcTimestampSchema,
});

export type AlternativesInput = z.infer<typeof alternativesInputSchema>;
export type BagCollection = z.infer<typeof bagCollectionSchema>;
export type BagItemInput = z.infer<typeof bagItemInputSchema>;
export type BagItemSnapshot = z.infer<typeof bagItemSnapshotSchema>;
export type CatalogSearchInput = z.infer<typeof catalogSearchInputSchema>;
export type CatalogSearchResult = z.infer<typeof catalogSearchResultSchema>;
export type HandoffDestination = z.infer<typeof handoffDestinationSchema>;
export type HandoffPreview = z.infer<typeof handoffPreviewSchema>;
export type HandoffTokenInput = z.infer<typeof handoffTokenInputSchema>;
export type ProductInput = z.infer<typeof productInputSchema>;
