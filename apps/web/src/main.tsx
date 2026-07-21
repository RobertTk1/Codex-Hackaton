import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { RouterProvider } from "react-router-dom";

import { loadBrowserEnvironment, loadBrowserRuntimeEnvironment } from "./env";
import { router } from "./router";
import "./styles.css";

const runtimeEnvironment = window.__MAGIC_MIRROR_RUNTIME_CONFIG__;
loadBrowserEnvironment(
  runtimeEnvironment === undefined
    ? import.meta.env
    : {
        ...import.meta.env,
        ...loadBrowserRuntimeEnvironment(runtimeEnvironment),
      },
);

const rootElement = document.querySelector<HTMLElement>("#root");
if (!rootElement) {
  throw new Error("Magic Mirror cannot start because the root element is missing.");
}

createRoot(rootElement).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>
);
