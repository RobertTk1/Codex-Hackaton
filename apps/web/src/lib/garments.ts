export type Garment = {
  id: "onyx-blazer" | "olive-overshirt" | "russet-dress";
  name: string;
  category: string;
  tone: "onyx" | "olive" | "russet";
};

export const GARMENTS: readonly Garment[] = [
  { id: "onyx-blazer", name: "Onyx blazer", category: "Tailored layer", tone: "onyx" },
  { id: "olive-overshirt", name: "Olive overshirt", category: "Relaxed layer", tone: "olive" },
  { id: "russet-dress", name: "Russet dress", category: "Occasion piece", tone: "russet" },
];
