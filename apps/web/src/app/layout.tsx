import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Magic Mirror | First look",
  description: "A first virtual try-on prototype.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
