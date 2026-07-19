"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";

import { OnboardingShell } from "@/components/onboarding-shell";
import { brandSchema } from "@/lib/onboarding";

const categories = ["Tops", "Bottoms", "Dresses / one-pieces", "Outerwear"];
const sizes = ["XS", "S", "M", "L", "XL", "0", "2", "4", "6", "8", "10", "12", "14", "16"];

export default function BrandsAndSizesPage() {
  const router = useRouter();
  const [brand, setBrand] = useState("");
  const [selectedBrand, setSelectedBrand] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  function addBrand(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const parsed = brandSchema.safeParse({ brand });
    if (!parsed.success) {
      setError(parsed.error.issues[0]?.message ?? "Enter a favorite brand.");
      return;
    }
    setSelectedBrand(parsed.data.brand);
    setBrand("");
    setError(null);
  }

  return <OnboardingShell currentStep={2}><section className="onboarding-content" aria-labelledby="brands-title"><p className="eyebrow">Step 2 of 6</p><h1 id="brands-title">What already fits you well?</h1><p className="onboarding-lead">Add a favorite brand and the sizes you know by garment category. Different categories can use different sizes.</p><p className="session-note">Your earlier profile is held only in this browser session for the tracer. It is not yet an account or a saved report.</p><form className="brand-search" noValidate onSubmit={addBrand}><label className="field">Find a favorite brand<input onChange={(event) => setBrand(event.target.value)} placeholder="e.g. COS, Levi's, Aritzia" value={brand} />{error ? <span className="field-error">{error}</span> : null}</label><button className="secondary-action" type="submit">Add brand</button></form>{selectedBrand ? <section className="brand-card" aria-label={`${selectedBrand} known sizes`}><div><p className="eyebrow">Selected brand</p><h2>{selectedBrand}</h2><p className="muted">Add only sizes that have worked for you.</p></div><button className="text-button" onClick={() => setSelectedBrand(null)} type="button">Remove</button><div className="field-grid">{categories.map((category) => <label className="field" key={category}>{category}<select defaultValue=""><option value="">Select size</option>{sizes.map((size) => <option key={size} value={size}>{size}</option>)}</select></label>)}</div></section> : null}<div className="form-footer"><button className="text-button" onClick={() => router.push("/style-report/profile")} type="button">Back</button><button className="primary-action" disabled={!selectedBrand} type="button">Continue to favorite looks</button></div></section></OnboardingShell>;
}
