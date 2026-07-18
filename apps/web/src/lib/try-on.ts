import { z } from "zod";
import { GARMENTS } from "@/lib/garments";

export const MAX_PHOTO_SIZE_BYTES = 10 * 1024 * 1024;
const garmentIds = GARMENTS.map((garment) => garment.id) as [string, ...string[]];

export const tryOnRequestSchema = z.object({
  garmentId: z.enum(garmentIds),
  photo: z.object({
    name: z.string().trim().min(1).max(180),
    size: z.number().int().positive().max(MAX_PHOTO_SIZE_BYTES),
    type: z.enum(["image/jpeg", "image/png", "image/webp"]),
  }),
  simulation: z.enum(["success", "failure", "timeout"]).optional().default("success"),
});
export const tryOnResponseSchema = z.object({ requestId: z.string().uuid(), status: z.literal("succeeded"), message: z.string(), latencyMs: z.number().int().positive() });
export const tryOnErrorSchema = z.object({ error: z.string(), code: z.string(), details: z.string() });
export type TryOnRequest = z.infer<typeof tryOnRequestSchema>;
export type TryOnResponse = z.infer<typeof tryOnResponseSchema>;
export type TryOnError = z.infer<typeof tryOnErrorSchema>;
