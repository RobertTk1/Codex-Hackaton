# Demo Catalog Plan

**Status:** Implemented

## User Outcome

A user can recognize and choose one of three distinct garments before requesting the mock try-on, making the first interaction feel like a product choice rather than a color swatch.

## Scope

- Three local, ImageGen-created catalog images: Onyx blazer, Olive overshirt, and Russet dress.
- Static images served from `apps/web/public/garments/` and referenced by the existing typed catalog.
- No retailer data, live inventory, product claims, or provider integration.

## Acceptance Criteria

- [x] Each catalog choice has a distinct accessible product image.
- [x] Selecting any image-backed garment preserves the existing mock try-on flow.
- [x] No external configuration is required to run locally.
