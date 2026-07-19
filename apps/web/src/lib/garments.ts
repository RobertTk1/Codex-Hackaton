export type Garment = {
  id: "onyx-blazer" | "olive-overshirt" | "russet-dress";
  name: string;
  category: string;
  imagePath: string;
  imageAlt: string;
};

export const GARMENTS: readonly Garment[] = [
  {
    id: "onyx-blazer",
    name: "Onyx blazer",
    category: "Tailored layer",
    imagePath: "/garments/onyx-blazer.png",
    imageAlt: "Charcoal tailored blazer",
  },
  {
    id: "olive-overshirt",
    name: "Olive overshirt",
    category: "Relaxed layer",
    imagePath: "/garments/olive-overshirt.png",
    imageAlt: "Olive green cotton overshirt",
  },
  {
    id: "russet-dress",
    name: "Russet dress",
    category: "Occasion piece",
    imagePath: "/garments/russet-dress.png",
    imageAlt: "Russet long-sleeve midi dress",
  },
];
