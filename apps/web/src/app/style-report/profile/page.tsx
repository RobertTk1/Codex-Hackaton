"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";

import { OnboardingShell } from "@/components/onboarding-shell";
import { presentationContexts, profileSchema } from "@/lib/onboarding";

type FieldName = "preferredName" | "age" | "height" | "presentationContext" | "adultConfirmed";
type FieldErrors = Partial<Record<FieldName, string>>;

function getFieldErrors(issues: { path: PropertyKey[]; message: string }[]): FieldErrors {
  const errors: FieldErrors = {};
  for (const issue of issues) {
    const field = issue.path[0];
    if (typeof field === "string" && field in errors === false) {
      if (field === "preferredName" || field === "age" || field === "height" || field === "presentationContext" || field === "adultConfirmed") errors[field] = issue.message;
    }
  }
  return errors;
}

export default function ProfilePage() {
  const router = useRouter();
  const [errors, setErrors] = useState<FieldErrors>({});

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    const parsed = profileSchema.safeParse({
      preferredName: formData.get("preferredName"),
      age: formData.get("age"),
      height: formData.get("height"),
      presentationContext: formData.get("presentationContext"),
      weight: formData.get("weight") || undefined,
      adultConfirmed: formData.get("adultConfirmed"),
    });

    if (!parsed.success) {
      setErrors(getFieldErrors(parsed.error.issues));
      return;
    }

    sessionStorage.setItem("magic-mirror-profile-tracer", JSON.stringify(parsed.data));
    router.push("/style-report/brands-and-sizes");
  }

  return <OnboardingShell currentStep={1}><section className="onboarding-content" aria-labelledby="profile-title"><p className="eyebrow">Step 1 of 6</p><h1 id="profile-title">First, tell us about you</h1><p className="onboarding-lead">These details help interpret proportions and shopping context. Weight is optional.</p><form className="form-stack" noValidate onSubmit={handleSubmit}><label className="field">Preferred name<input aria-describedby={errors.preferredName ? "preferredName-error" : undefined} aria-invalid={Boolean(errors.preferredName)} defaultValue="" name="preferredName" placeholder="Name used in your report" />{errors.preferredName ? <span className="field-error" id="preferredName-error">{errors.preferredName}</span> : null}</label><div className="field-grid"><label className="field">Age<input aria-describedby={errors.age ? "age-error" : undefined} aria-invalid={Boolean(errors.age)} inputMode="numeric" name="age" placeholder="18+" />{errors.age ? <span className="field-error" id="age-error">{errors.age}</span> : null}</label><label className="field">Height<input aria-describedby={errors.height ? "height-error" : undefined} aria-invalid={Boolean(errors.height)} name="height" placeholder="Feet / inches or centimeters" />{errors.height ? <span className="field-error" id="height-error">{errors.height}</span> : null}</label></div><fieldset className="field"><legend>Style-presentation context</legend><span className="field-hint">Choose the context that best matches how you want recommendations presented.</span><div className="choice-grid">{presentationContexts.map((context) => <label className="choice" key={context}><input defaultChecked={context === "Womenswear"} name="presentationContext" type="radio" value={context} />{context}</label>)}</div>{errors.presentationContext ? <span className="field-error">{errors.presentationContext}</span> : null}</fieldset><label className="field">Weight <span className="muted">(optional)</span><input name="weight" placeholder="Skip if you prefer" /></label><label className="checkbox-field"><input name="adultConfirmed" type="checkbox" />I confirm that I am 18 or older.</label>{errors.adultConfirmed ? <span className="field-error">{errors.adultConfirmed}</span> : null}<div className="form-footer"><button className="text-button" onClick={() => router.push("/")} type="button">Exit</button><button className="primary-action" type="submit">Continue</button></div></form></section></OnboardingShell>;
}
