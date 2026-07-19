import { z } from "zod";

export const presentationContexts = [
  "Womenswear",
  "Menswear",
  "A mix / another context",
] as const;

export const profileSchema = z.object({
  preferredName: z.string().trim().min(1, "Enter the name you want used in your report."),
  age: z.coerce.number().int().min(18, "You must confirm that you are 18 or older.").max(120, "Enter a valid age."),
  height: z.string().trim().min(2, "Add your height in feet/inches or centimeters."),
  presentationContext: z.enum(presentationContexts),
  weight: z.string().trim().max(32, "Keep weight to 32 characters or fewer.").optional(),
  adultConfirmed: z.string().refine((value) => value === "on", "Confirm that you are 18 or older."),
});

export const brandSchema = z.object({
  brand: z.string().trim().min(2, "Enter a brand name with at least two characters.").max(80, "Keep brand names to 80 characters or fewer."),
});

export type Profile = z.infer<typeof profileSchema>;
