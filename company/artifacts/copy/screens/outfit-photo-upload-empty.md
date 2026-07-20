# Outfit Photo Upload — Empty

Status: Approved  
Screen ID: `bfc87225-7f0e-45c1-90f7-6623d96e9dad`  
Screen slug: `outfit-photo-upload-empty`  
State: `empty`  
Audience: Photo guidance, analysis consent, upload entry, count rules, and image-use explanation before any image is selected.

## Job and primary action

- **User job:** Photo guidance, analysis consent, upload entry, count rules, and image-use explanation before any image is selected.
- **Primary action:** Choose photos

## Recommended exact copy in wireframe order

### SEC-001 — Onboarding progress

```json
{
  "eyebrow": "STEP 3 OF 4",
  "headline": "Show us your favorite looks.",
  "supporting_copy": "Add 8–12 full-body photos of outfits you feel great in.",
  "labels": {
    "count": "0 of 8 required photos",
    "accepted": "JPG, PNG, HEIC, or WebP"
  },
  "helper_text": {
    "quality": "Choose clear, well-lit photos that show your full outfit. One person per photo works best.",
    "range": "8 photos minimum. 12 maximum."
  }
}
```

### SEC-002 — Photo guidance

```json
{
  "eyebrow": "STEP 3 OF 4",
  "headline": "Show us your favorite looks.",
  "supporting_copy": "Add 8–12 full-body photos of outfits you feel great in.",
  "labels": {
    "count": "0 of 8 required photos",
    "accepted": "JPG, PNG, HEIC, or WebP"
  },
  "helper_text": {
    "quality": "Choose clear, well-lit photos that show your full outfit. One person per photo works best.",
    "range": "8 photos minimum. 12 maximum."
  }
}
```

### SEC-003 — Upload workspace

```json
{
  "eyebrow": "STEP 3 OF 4",
  "headline": "Show us your favorite looks.",
  "supporting_copy": "Add 8–12 full-body photos of outfits you feel great in.",
  "labels": {
    "count": "0 of 8 required photos",
    "accepted": "JPG, PNG, HEIC, or WebP"
  },
  "helper_text": {
    "quality": "Choose clear, well-lit photos that show your full outfit. One person per photo works best.",
    "range": "8 photos minimum. 12 maximum."
  }
}
```

### SEC-004 — Step actions

```json
{
  "primary_cta": "Choose photos",
  "secondary_cta": "Back",
  "tertiary_cta": "Save and exit"
}
```

## Complete implementation object

```json
{
  "eyebrow": "STEP 3 OF 4",
  "headline": "Show us your favorite looks.",
  "supporting_copy": "Add 8–12 full-body photos of outfits you feel great in.",
  "primary_cta": "Choose photos",
  "secondary_cta": "Back",
  "tertiary_cta": "Save and exit",
  "navigation": {},
  "labels": {
    "count": "0 of 8 required photos",
    "accepted": "JPG, PNG, HEIC, or WebP"
  },
  "helper_text": {
    "quality": "Choose clear, well-lit photos that show your full outfit. One person per photo works best.",
    "range": "8 photos minimum. 12 maximum."
  },
  "validation": {
    "consent": "Agree to photo use before continuing."
  },
  "status_messages": {},
  "consent": {
    "photos": "I agree to let Magic Mirror use these photos to create my style report.",
    "isolation": "Only you can access the photos you add."
  },
  "metadata": {},
  "accessibility": {},
  "sections": [
    {
      "section_id": "SEC-001",
      "section_name": "Onboarding progress",
      "copy": {
        "eyebrow": "STEP 3 OF 4",
        "headline": "Show us your favorite looks.",
        "supporting_copy": "Add 8–12 full-body photos of outfits you feel great in.",
        "labels": {
          "count": "0 of 8 required photos",
          "accepted": "JPG, PNG, HEIC, or WebP"
        },
        "helper_text": {
          "quality": "Choose clear, well-lit photos that show your full outfit. One person per photo works best.",
          "range": "8 photos minimum. 12 maximum."
        }
      }
    },
    {
      "section_id": "SEC-002",
      "section_name": "Photo guidance",
      "copy": {
        "eyebrow": "STEP 3 OF 4",
        "headline": "Show us your favorite looks.",
        "supporting_copy": "Add 8–12 full-body photos of outfits you feel great in.",
        "labels": {
          "count": "0 of 8 required photos",
          "accepted": "JPG, PNG, HEIC, or WebP"
        },
        "helper_text": {
          "quality": "Choose clear, well-lit photos that show your full outfit. One person per photo works best.",
          "range": "8 photos minimum. 12 maximum."
        }
      }
    },
    {
      "section_id": "SEC-003",
      "section_name": "Upload workspace",
      "copy": {
        "eyebrow": "STEP 3 OF 4",
        "headline": "Show us your favorite looks.",
        "supporting_copy": "Add 8–12 full-body photos of outfits you feel great in.",
        "labels": {
          "count": "0 of 8 required photos",
          "accepted": "JPG, PNG, HEIC, or WebP"
        },
        "helper_text": {
          "quality": "Choose clear, well-lit photos that show your full outfit. One person per photo works best.",
          "range": "8 photos minimum. 12 maximum."
        }
      }
    },
    {
      "section_id": "SEC-004",
      "section_name": "Step actions",
      "copy": {
        "primary_cta": "Choose photos",
        "secondary_cta": "Back",
        "tertiary_cta": "Save and exit"
      }
    }
  ]
}
```

## Proof and claims

No testimonial, customer count, rating, fit guarantee, retailer partnership, or measured outcome claim is used. Timing and capability language is limited to the approved product contract and identified as a design target where relevant.

## Alternatives

No alternate is recommended for this state; clarity and state fidelity take priority.

## Voice notes

Clear, editorial, practical, and transparent.

## Layout constraints

Keep the headline concise, actions predictable, and state guidance readable on mobile.

## Approval and revision notes

- 2026-07-19: Initial draft created from the approved PRD, UX package, company context, and draft voice system.
- Founder approval: Approved by Talisha White on 2026-07-19.
