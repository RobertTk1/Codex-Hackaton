import { Bookmark, ChevronDown, Menu, Sparkles, UserRound, X } from "lucide-react";
import { useEffect, useRef, useState, type KeyboardEvent as ReactKeyboardEvent } from "react";

const primaryHref = "/style-report/profile";
const loginHref = "/login";

const reportCards = [
  {
    image: "/media/landing/report-colors.png",
    title: "Your color direction",
    body: "The shades that complement you—and make getting dressed effortless.",
  },
  {
    image: "/media/landing/report-silhouettes.png",
    title: "Your proportions and silhouettes",
    body: "The shapes and fits that balance you and feel like second nature.",
  },
  {
    image: "/media/landing/report-next.png",
    title: "What to wear next",
    body: "Outfit ideas built around your life, your style, and what you already own.",
  },
] as const;

const processSteps = [
  {
    icon: Bookmark,
    title: "Show us what you love",
    body: "Save looks that speak to you—outfits, colors, and details you’re drawn to.",
  },
  {
    icon: Sparkles,
    title: "Follow your first instinct",
    body: "Answer a few visual questions to help us understand your natural preferences.",
  },
  {
    icon: UserRound,
    title: "Meet your style",
    body: "Get your personalized style report with colors, silhouettes, and outfit ideas.",
  },
] as const;

const faqs = [
  {
    question: "What do I need to get started?",
    answer: "Start with a few details and 8–12 photos of looks you love.",
  },
  {
    question: "How long does the report take?",
    answer: "Your report is usually ready in 1–2 minutes.",
  },
  {
    question: "Does Magic Mirror guarantee fit?",
    answer: "No. Your report offers personal style guidance, but fit can vary by garment and retailer.",
  },
  {
    question: "How are my photos used?",
    answer: "Your photos are used only to create and improve your personal style report.",
  },
] as const;

function PrimaryLink({ className = "" }: { className?: string }) {
  return (
    <a className={`button button-primary ${className}`} href={primaryHref} data-integration-target="anonymous-draft">
      Get my style report
    </a>
  );
}

function LoginLink({ className = "" }: { className?: string }) {
  return (
    <a className={`button button-secondary ${className}`} href={loginHref}>
      Log in
    </a>
  );
}

function MobileNavigation() {
  const [open, setOpen] = useState(false);
  const triggerRef = useRef<HTMLButtonElement>(null);
  const closeRef = useRef<HTMLButtonElement>(null);
  const sheetRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    closeRef.current?.focus();

    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === "Escape") setOpen(false);
    };
    window.addEventListener("keydown", onKeyDown);
    return () => {
      window.removeEventListener("keydown", onKeyDown);
      document.body.style.overflow = previousOverflow;
      triggerRef.current?.focus();
    };
  }, [open]);

  const close = () => setOpen(false);
  const keepFocusInMenu = (event: ReactKeyboardEvent<HTMLDivElement>) => {
    if (event.key !== "Tab") return;
    const focusable = [...(sheetRef.current?.querySelectorAll<HTMLElement>("a[href], button:not([disabled])") ?? [])];
    const first = focusable[0];
    const last = focusable.at(-1);
    if (!first || !last) return;
    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first.focus();
    }
  };

  return (
    <div className="mobile-navigation">
      <button
        aria-controls="mobile-menu"
        aria-expanded={open}
        aria-label="Open navigation"
        className="menu-button"
        onClick={() => setOpen(true)}
        ref={triggerRef}
        type="button"
      >
        <Menu aria-hidden="true" />
      </button>
      {open ? (
        <div className="mobile-menu-backdrop" role="presentation" onMouseDown={close}>
          <div
            aria-label="Mobile navigation"
            aria-modal="true"
            className="mobile-menu-sheet"
            id="mobile-menu"
            onKeyDown={keepFocusInMenu}
            onMouseDown={(event) => event.stopPropagation()}
            ref={sheetRef}
            role="dialog"
          >
            <button aria-label="Close navigation" className="menu-button menu-close" onClick={close} ref={closeRef} type="button">
              <X aria-hidden="true" />
            </button>
            <a href="#how-it-works" onClick={close}>How it works</a>
            <a href="#whats-inside" onClick={close}>What’s inside</a>
            <a href="#privacy" onClick={close}>Your privacy</a>
            <LoginLink />
            <PrimaryLink />
          </div>
        </div>
      ) : null}
    </div>
  );
}

export function LandingPage() {
  const [openFaq, setOpenFaq] = useState<number | null>(null);

  return (
    <main id="main-content" aria-label="Magic Mirror application">
      <div className="page-start" id="page-start" tabIndex={-1} />
      <nav aria-label="Primary navigation" className="site-navigation">
        <a aria-label="Magic Mirror home" className="brand-link" href="#page-start">
          <img alt="Magic Mirror" height="52" src="/brand/magic-mirror-wordmark.svg" width="208" />
        </a>
        <div className="desktop-navigation">
          <a href="#how-it-works">How it works</a>
          <a href="#whats-inside">What’s inside</a>
          <a href="#privacy">Your privacy</a>
          <a href={loginHref}>Log in</a>
          <PrimaryLink />
        </div>
        <MobileNavigation />
      </nav>

      <header className="hero section-shell">
        <div className="hero-copy reveal">
          <h1>Your style already<br className="desktop-break" /> has a point of view.</h1>
          <p>Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.</p>
          <div className="button-row hero-actions">
            <PrimaryLink />
            <LoginLink />
          </div>
        </div>
        <img
          alt="A style report preview beside an editorial portrait"
          className="hero-image reveal reveal-delay-1"
          height="424"
          src="/media/landing/hero-editorial.png"
          width="697"
        />
      </header>

      <section aria-labelledby="report-preview-heading" className="report-preview" id="report-preview" tabIndex={-1}>
        <div className="report-preview-copy reveal">
          <p className="eyebrow">Your report</p>
          <h2 id="report-preview-heading">See what makes<br /> your style yours.</h2>
          <p>Discover the colors, shapes, and details you return to—and where to take them next.</p>
          <div className="button-row">
            <PrimaryLink />
            <LoginLink />
          </div>
        </div>
        <img alt="An open style report with color and outfit guidance" height="298" loading="lazy" src="/media/landing/report-book.png" width="448" />
      </section>

      <section aria-labelledby="process-heading" className="process section-shell" id="how-it-works" tabIndex={-1}>
        <p className="eyebrow centered">How it works</p>
        <h2 className="centered" id="process-heading">From favorite looks<br /> to your style report.</h2>
        <ol className="process-grid">
          {processSteps.map(({ body, icon: Icon, title }, index) => (
            <li className="process-step reveal" key={title}>
              <div className="step-marker" aria-hidden="true"><span>{index + 1}</span></div>
              <Icon aria-hidden="true" className="step-icon" strokeWidth={1.5} />
              <h3>{title}</h3>
              <p>{body}</p>
            </li>
          ))}
        </ol>
      </section>

      <section aria-labelledby="contents-heading" className="report-contents section-shell" id="whats-inside" tabIndex={-1}>
        <p className="eyebrow centered">Your style report includes</p>
        <h2 className="centered" id="contents-heading">A guide you can actually wear.</h2>
        <div className="report-grid">
          {reportCards.map((card) => (
            <article className="report-card reveal" key={card.title}>
              <img alt="" height="110" loading="lazy" src={card.image} width="208" />
              <div>
                <h3>{card.title}</h3>
                <p>{card.body}</p>
              </div>
            </article>
          ))}
        </div>
      </section>

      <section aria-labelledby="privacy-heading" className="privacy-section" id="privacy" tabIndex={-1}>
        <div className="privacy-copy reveal">
          <p className="eyebrow">Your privacy, always</p>
          <h2 id="privacy-heading">Your style. Your photos.<br /> Your choice.</h2>
          <p>Your photos create your private report. When you find something you love, you’ll shop directly with the retailer.</p>
          <div className="button-row">
            <PrimaryLink />
            <LoginLink />
          </div>
        </div>
        <img alt="" height="204" loading="lazy" src="/media/landing/privacy-wardrobe.png" width="393" />
      </section>

      <section aria-labelledby="faq-heading" className="faq section-shell">
        <p className="eyebrow centered">FAQ</p>
        <h2 className="centered" id="faq-heading">Good questions, answered.</h2>
        <div className="faq-list">
          {faqs.map((faq, index) => {
            const expanded = openFaq === index;
            const answerId = `faq-answer-${index}`;
            return (
              <div className={`faq-item ${expanded ? "faq-item-open" : ""}`} key={faq.question}>
                <button
                  aria-controls={answerId}
                  aria-expanded={expanded}
                  onClick={() => setOpenFaq(expanded ? null : index)}
                  type="button"
                >
                  <span>{faq.question}</span>
                  <ChevronDown aria-hidden="true" />
                </button>
                <div className="faq-answer" id={answerId} hidden={!expanded}>
                  <p>{faq.answer}</p>
                </div>
              </div>
            );
          })}
        </div>
        <PrimaryLink className="faq-cta" />
      </section>

      <section aria-labelledby="closing-heading" className="closing-section section-shell">
        <img alt="" height="135" src="/media/landing/closing-model.png" width="411" />
        <div className="closing-copy">
          <h2 id="closing-heading">Meet the style<br /> that’s already yours.</h2>
          <p>Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.</p>
          <div className="button-row">
            <PrimaryLink />
            <LoginLink />
          </div>
        </div>
      </section>

      <footer className="site-footer section-shell">
        <div className="footer-brand">
          <img alt="Magic Mirror" height="52" src="/brand/magic-mirror-wordmark.svg" width="208" />
          <p>Turn the looks you love into a personal guide to colors, silhouettes, and what to wear next.</p>
        </div>
        <nav aria-label="Explore">
          <p>Explore</p>
          <a href="#how-it-works">How it works</a>
          <a href="#report-preview">Your style report</a>
          <a href="#page-start">About</a>
        </nav>
        <nav aria-label="Company information">
          <p>Company</p>
          <a href="/privacy">Privacy</a>
          <a href="/terms">Terms</a>
          <a href="mailto:hello@magicmirror.style">Contact</a>
        </nav>
      </footer>
    </main>
  );
}
