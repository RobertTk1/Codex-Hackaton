import Link from "next/link";
import type { ReactNode } from "react";

const steps = ["About you", "Brands & sizes", "Favorite looks", "Your taste", "Save progress", "Analysis"];

export function OnboardingShell({ children, currentStep }: { children: ReactNode; currentStep: number }) {
  return <main className="onboarding-page"><header className="onboarding-header"><Link className="wordmark" href="/">Magic Mirror</Link><p>Style report</p></header><div className="onboarding-shell"><aside className="progress-panel" aria-label="Style report progress"><strong>Style report</strong><ol>{steps.map((step, index) => <li className={index + 1 === currentStep ? "is-current" : index + 1 < currentStep ? "is-complete" : ""} key={step}>{index + 1}. {step}</li>)}</ol><p>Prototype mode: this progress stays only in this browser session.</p></aside>{children}</div></main>;
}
