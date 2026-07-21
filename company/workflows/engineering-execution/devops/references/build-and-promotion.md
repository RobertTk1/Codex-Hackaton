# Build and Candidate Promotion

## Reproducible Candidate

Build from the QA-approved Git commit in a clean CI environment using the pinned Bun lockfile and Dockerfiles. Produce:

- one web image digest;
- one API image digest used by both `api` and `worker`;
- build logs and software/dependency/security scan results;
- an image-to-commit provenance record.

Use Linux AMD64 images supported by App Platform. Keep images minimal and free of source secrets, `.env` files, test data, local caches, and development-only runtime tooling.

## Promotion Rule

QA must test the same immutable digests that DevOps promotes. If any image is rebuilt after QA, its digest changes and the affected QA approval is invalid until the new image is redeployed to dev and required QA/regression cases rerun.

## Verification

- Build both images from a clean checkout.
- Run the complete test/build commands before publishing.
- Inspect image history/filesystem for secret and fixture inclusion.
- Start web, API, and worker commands using production configuration names with safe non-production values.
- Verify missing required server configuration fails startup loudly.
- Push immutable images, record registry/repository/digest, and never overwrite a digest.

Production app spec promotion changes only to the approved digests and reviewed production configuration.
