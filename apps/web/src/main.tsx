import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { RouterProvider } from "react-router-dom";

import { loadBrowserEnvironment } from "./env";
import { router } from "./router";
import "./styles.css";

loadBrowserEnvironment(import.meta.env);

const rootElement = document.querySelector<HTMLElement>("#root");
if (!rootElement) {
  throw new Error("Magic Mirror cannot start because the root element is missing.");
}

createRoot(rootElement).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>
);
