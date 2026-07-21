import { createBrowserRouter } from "react-router-dom";

function ApplicationShell() {
  return (
    <main id="main-content" aria-label="Magic Mirror application">
      <h1 className="sr-only">Magic Mirror</h1>
    </main>
  );
}

export const router = createBrowserRouter([
  {
    path: "/",
    element: <ApplicationShell />
  }
]);
