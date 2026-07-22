import { createBrowserRouter } from "react-router-dom";
import { LandingPage } from "./screens/LandingPage";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <LandingPage />
  }
]);
