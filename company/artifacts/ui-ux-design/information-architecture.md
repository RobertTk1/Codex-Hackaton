# Magic Mirror Information Architecture

Status: Ready for review
Source: Approved PRD v1.0.0, 2026-07-19

## Organizing principle

Magic Mirror is organized around a customer's progression from learning what the product can do, to teaching it their taste, to understanding their report, and finally acting on recommendations. The report—not shopping inventory—is the primary product object.

## Content hierarchy

1. **Public discovery**
   - Landing page
   - Unified account access
2. **Style-report onboarding**
   - Personal profile
   - Brands and known sizes
   - Favorite-look photo upload
   - Taste calibration
   - Permanent account connection
   - Analysis processing and recovery
3. **Personal style system**
   - Report overview
   - Color report
   - Body-style report
   - Recommendations
4. **Returning-customer workspace**
   - Style home
   - Report highlights and resumable work
   - Selected recommendations and bag
5. **Live styling**
   - Camera permission
   - Ready session
   - Microphone permission and voice interpretation
   - Hand-gesture guide and recognition
   - Product detail drawer
6. **Commerce handoff**
   - Magic Mirror bag grouped by retailer
   - Retailer-owned checkout confirmation

## Hierarchy and ownership

```text
Magic Mirror
├── Public
│   ├── Landing
│   └── Account access
├── Anonymous authenticated onboarding
│   ├── Profile
│   ├── Brands and sizes
│   ├── Favorite-look photos
│   ├── Taste calibration
│   └── Account connection
├── Analysis
│   ├── Processing
│   ├── Slow processing
│   └── Error recovery
├── Permanent account
│   ├── Style home
│   ├── Style report
│   │   ├── Overview
│   │   ├── Colors
│   │   ├── Body style
│   │   └── Recommendations
│   ├── Live styling
│   │   ├── Permissions
│   │   ├── Session
│   │   ├── Voice controls
│   │   ├── Gesture controls
│   │   └── Product detail
│   └── Bag
└── External retailer
    └── Checkout, payment, fulfillment, and returns
```

## Object model visible to customers

| Object | Customer meaning | Created or changed where |
|---|---|---|
| Style profile | Personal context, brands, sizes, and taste signals | Onboarding and later account settings |
| Favorite looks | 8–12 customer-selected outfit photos used as style evidence | Photo upload |
| Taste choice | Love, Hate, or Maybe for a presented look or item | Taste calibration |
| Style report | Versioned analysis of style identity, color, body-style guidance, and recommendations | Analysis; viewed in report sections |
| Recommendation | A report-linked garment or outfit with a reason | Report and style home |
| Live session | A camera-based styling session with active product and control state | Live styling |
| Bag item | A selected retailer product saved for handoff | Product detail, live session, and bag |

## Access boundaries

- Public pages expose no customer data.
- Onboarding data is owned by an anonymous authenticated identity from the first step.
- Google or email magic-link authentication connects that identity to a permanent account without copying or losing inputs.
- Report, photos, sessions, and bag are private to the owning identity.
- Retailer destinations receive only the navigation/product context required for handoff; retailer checkout remains outside Magic Mirror.

## Findability rules

- The primary public action is always **Get your style report**.
- During onboarding, one dominant **Continue** action advances the sequence; progress and save state remain visible.
- After report completion, the persistent product navigation exposes **Home, Report, Live styling, Bag, Account**.
- Report subsections stay visible as local navigation so customers can compare findings without returning to overview.
- Permission, processing, error, and handoff states preserve a clear route back to the customer's last safe state.

## Responsive structure

- Desktop uses a restrained top navigation plus contextual left rail where comparison across report sections matters.
- Mobile uses a compact header; completed-account destinations move to a five-item bottom navigation.
- Onboarding remains linear on both viewports; desktop may show a progress rail while mobile uses a compact step indicator.
- Live styling prioritizes the camera canvas; controls become a reachable bottom tray on mobile and a right-side control panel on desktop.
