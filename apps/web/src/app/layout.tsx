import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Magic Mirror | Style report",
  description: "A personal style-report onboarding tracer.",
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
