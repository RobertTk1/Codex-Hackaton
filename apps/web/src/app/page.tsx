"use client";

import { ChangeEvent, useState } from "react";

import { GARMENTS, type Garment } from "@/lib/garments";
import {
  MAX_PHOTO_SIZE_BYTES,
  type TryOnError,
  type TryOnResponse,
} from "@/lib/try-on";

type ViewState = "ready" | "generating" | "slow" | "succeeded" | "failed";

function getSimulationMode(): "success" | "failure" | "timeout" {
  if (typeof window === "undefined") return "success";
  const mode = new URLSearchParams(window.location.search).get("simulate");
  return mode === "failure" || mode === "timeout" ? mode : "success";
}

function getPhotoError(file: File): string | null {
  if (!file.type.startsWith("image/")) return "Choose an image file (JPG, PNG, or WebP).";
  if (file.size > MAX_PHOTO_SIZE_BYTES) return "Choose an image smaller than 10 MB.";
  return null;
}

export default function Home() {
  const [photo, setPhoto] = useState<File | null>(null);
  const [photoPreview, setPhotoPreview] = useState<string | null>(null);
  const [photoError, setPhotoError] = useState<string | null>(null);
  const [selectedGarment, setSelectedGarment] = useState<Garment | null>(null);
  const [viewState, setViewState] = useState<ViewState>("ready");
  const [result, setResult] = useState<TryOnResponse | null>(null);
  const [requestError, setRequestError] = useState<TryOnError | null>(null);
  const simulation = getSimulationMode();

  function handlePhotoChange(event: ChangeEvent<HTMLInputElement>) {
    const nextPhoto = event.target.files?.[0] ?? null;
    setResult(null);
    setRequestError(null);
    setViewState("ready");

    if (!nextPhoto) {
      setPhoto(null);
      setPhotoError(null);
      if (photoPreview) URL.revokeObjectURL(photoPreview);
      setPhotoPreview(null);
      return;
    }

    const error = getPhotoError(nextPhoto);
    if (error) {
      setPhoto(null);
      setPhotoError(error);
      if (photoPreview) URL.revokeObjectURL(photoPreview);
      setPhotoPreview(null);
      return;
    }

    setPhoto(nextPhoto);
    setPhotoError(null);
    if (photoPreview) URL.revokeObjectURL(photoPreview);
    setPhotoPreview(URL.createObjectURL(nextPhoto));
  }

  async function requestTryOn() {
    if (!photo || !selectedGarment) return;

    setViewState("generating");
    setResult(null);
    setRequestError(null);
    const slowTimer = window.setTimeout(() => setViewState("slow"), 1400);

    try {
      const response = await fetch("/api/try-on", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          garmentId: selectedGarment.id,
          photo: { name: photo.name, size: photo.size, type: photo.type },
          simulation,
        }),
      });
      const body: unknown = await response.json();

      if (!response.ok) {
        setRequestError(body as TryOnError);
        setViewState("failed");
        return;
      }

      setResult(body as TryOnResponse);
      setViewState("succeeded");
    } catch {
      setRequestError({
        error: "We could not start the mock render.",
        code: "NETWORK_ERROR",
        details: "Check your connection and try again.",
      });
      setViewState("failed");
    } finally {
      window.clearTimeout(slowTimer);
    }
  }

  const canRequest = Boolean(photo && selectedGarment && viewState !== "generating" && viewState !== "slow");

  return (
    <main className="site-shell">
      <section className="hero" aria-labelledby="page-title">
        <p className="eyebrow">Magic Mirror / First look</p>
        <h1 id="page-title">See one piece on you before you decide.</h1>
        <p className="hero-copy">This first build is a safe, local-flow prototype. Your photo stays in this browser preview and the result below is a mock render.</p>
      </section>

      <section className="workspace" aria-label="Try-on inputs">
        <div className="step-card">
          <div className="step-heading">
            <span className="step-number">01</span>
            <div><h2>Add a photo</h2><p>Choose a clear image of yourself. JPG, PNG, or WebP up to 10 MB.</p></div>
          </div>
          <label className="upload-zone" htmlFor="photo-upload">
            <input id="photo-upload" accept="image/jpeg,image/png,image/webp" className="sr-only" onChange={handlePhotoChange} type="file" />
            {photoPreview ? (
              // Object URLs stay in the browser and cannot use Next.js image optimization.
              // eslint-disable-next-line @next/next/no-img-element
              <img className="photo-preview" src={photoPreview} alt="Selected photo preview" />
            ) : (
              <span className="upload-placeholder"><span className="upload-icon" aria-hidden="true">+</span><strong>Upload photo</strong><small>Nothing is sent to a provider in this prototype.</small></span>
            )}
          </label>
          {photoError ? <p className="field-error" role="alert">{photoError}</p> : null}
        </div>

        <div className="step-card">
          <div className="step-heading">
            <span className="step-number">02</span>
            <div><h2>Pick one piece</h2><p>A tiny curated catalog for the first interaction.</p></div>
          </div>
          <div className="garment-grid" role="radiogroup" aria-label="Available garments">
            {GARMENTS.map((garment) => {
              const isSelected = selectedGarment?.id === garment.id;
              return (
                <button className={`garment-card ${isSelected ? "is-selected" : ""}`} key={garment.id} onClick={() => {
                  setSelectedGarment(garment); setResult(null); setRequestError(null); setViewState("ready");
                }} role="radio" aria-checked={isSelected} type="button">
                  <span className={`garment-swatch ${garment.tone}`} aria-hidden="true" />
                  <span className="garment-details"><strong>{garment.name}</strong><small>{garment.category}</small></span>
                  <span className="selection-mark" aria-hidden="true">{isSelected ? "✓" : ""}</span>
                </button>
              );
            })}
          </div>
        </div>
      </section>

      <section className="action-panel" aria-label="Create mock try-on">
        <div><p className="eyebrow">03 / Generate</p><h2>Ready when you are.</h2></div>
        <button className="primary-action" disabled={!canRequest} onClick={requestTryOn} type="button">
          {viewState === "generating" || viewState === "slow" ? "Creating preview…" : "Try it on"}
        </button>
      </section>

      <section className="result-section" aria-live="polite" aria-labelledby="result-heading">
        <div className="result-heading"><p className="eyebrow">Result</p><h2 id="result-heading">Your first look</h2></div>
        {viewState === "ready" ? <div className="result-empty"><span aria-hidden="true">↘</span><p>Your mock result will appear here after you select a photo and one piece.</p></div> : null}
        {viewState === "generating" || viewState === "slow" ? (
          <div className="result-loading"><div className="spinner" aria-hidden="true" /><div><h3>{viewState === "slow" ? "Still creating your preview" : "Creating your preview"}</h3><p>{viewState === "slow" ? "The mock provider is taking longer than expected. Your choices are still safe." : "Matching your selected photo and garment…"}</p></div></div>
        ) : null}
        {viewState === "failed" && requestError ? (
          <div className="result-error" role="alert"><div><p className="eyebrow">Render failed</p><h3>{requestError.error}</h3><p>{requestError.details}</p></div><button className="secondary-action" onClick={requestTryOn} type="button">Try again</button></div>
        ) : null}
        {viewState === "succeeded" && result && photoPreview && selectedGarment ? (
          <div className="result-success"><div className="result-image-wrap">
            {/* Object URLs stay in the browser and cannot use Next.js image optimization. */}
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img className="result-image" src={photoPreview} alt="Mock try-on preview using the selected photo" />
            <span className="mock-badge">Mock render</span>
          </div><div className="result-copy"><p className="eyebrow">Preview ready</p><h3>{selectedGarment.name} on your selected photo</h3><p>{result.message}</p><dl className="result-meta"><div><dt>Garment</dt><dd>{selectedGarment.category}</dd></div><div><dt>Mock time</dt><dd>{result.latencyMs} ms</dd></div></dl><p className="disclaimer">Visualization only. A real provider has not been connected yet, and this does not predict fit.</p></div></div>
        ) : null}
      </section>
    </main>
  );
}
