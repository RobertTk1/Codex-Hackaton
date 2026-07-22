import { createClient } from "@supabase/supabase-js";
import { z } from "zod";

const localStatusSchema = z.object({
  API_URL: z.url(),
  PUBLISHABLE_KEY: z.string().min(1),
  SERVICE_ROLE_KEY: z.string().min(1),
});
const acceptedPhotoSchema = z.object({
  expires_at: z.iso.datetime({ offset: true }),
  owner_id: z.uuid(),
  status: z.literal("accepted"),
  storage_path: z.string().min(1),
});

const statusProcess = Bun.spawnSync(["supabase", "status", "-o", "json"], {
  stderr: "pipe",
  stdout: "pipe",
});

if (statusProcess.exitCode !== 0) {
  throw new Error("Local Supabase status is unavailable.");
}

const statusJson: unknown = JSON.parse(statusProcess.stdout.toString());
const status = localStatusSchema.parse(statusJson);
const server = createClient(status.API_URL, status.SERVICE_ROLE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});
const publicClient = createClient(status.API_URL, status.PUBLISHABLE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

const runId = crypto.randomUUID();
const ownerEmail = `photo-owner-${runId}@example.test`;
const otherEmail = `photo-other-${runId}@example.test`;
const password = `Storage-${runId}!`;
const profileId = crypto.randomUUID();
const photoId = crypto.randomUUID();
const directPhotoId = crypto.randomUUID();
const createdAt = new Date(Date.now() - 24 * 60 * 60 * 1_000);
const futureExpiry = new Date(Date.now() + 24 * 60 * 60 * 1_000);
const expiredAt = new Date(Date.now() - 60 * 60 * 1_000);
const pngBytes = Uint8Array.from(
  Buffer.from(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=",
    "base64",
  ),
);

let ownerId: string | undefined;
let otherId: string | undefined;
let objectPath: string | undefined;
let directPath: string | undefined;

function requireNoError(error: { message: string } | null, action: string): void {
  if (error) {
    throw new Error(`${action} failed: ${error.message}`);
  }
}

try {
  const ownerResult = await server.auth.admin.createUser({
    email: ownerEmail,
    email_confirm: true,
    password,
  });
  requireNoError(ownerResult.error, "Create owner fixture");
  ownerId = ownerResult.data.user?.id;

  const otherResult = await server.auth.admin.createUser({
    email: otherEmail,
    email_confirm: true,
    password,
  });
  requireNoError(otherResult.error, "Create cross-owner fixture");
  otherId = otherResult.data.user?.id;

  if (!ownerId || !otherId) {
    throw new Error("Auth fixture creation returned no user ID.");
  }

  const ownerClient = createClient(status.API_URL, status.PUBLISHABLE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
  const otherClient = createClient(status.API_URL, status.PUBLISHABLE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  requireNoError(
    (await ownerClient.auth.signInWithPassword({ email: ownerEmail, password })).error,
    "Sign in owner fixture",
  );
  requireNoError(
    (await otherClient.auth.signInWithPassword({ email: otherEmail, password })).error,
    "Sign in cross-owner fixture",
  );

  objectPath = `customer-photos/${ownerId}/${profileId}/${photoId}/original.png`;

  requireNoError(
    (
      await server.from("profiles").insert({
        created_at: createdAt.toISOString(),
        current_step: "photos",
        id: profileId,
        last_activity_at: createdAt.toISOString(),
        owner_id: ownerId,
        updated_at: createdAt.toISOString(),
      })
    ).error,
    "Create profile fixture",
  );

  requireNoError(
    (
      await server.from("photos").insert({
        byte_size: pngBytes.byteLength,
        created_at: createdAt.toISOString(),
        expires_at: futureExpiry.toISOString(),
        height_px: 640,
        id: photoId,
        media_type: "image/png",
        owner_id: ownerId,
        position: 1,
        profile_id: profileId,
        sha256: "\\x" + "01".repeat(32),
        storage_path: objectPath,
        updated_at: createdAt.toISOString(),
        width_px: 640,
      })
    ).error,
    "Create photo metadata fixture",
  );

  const signedSlot = await server.storage
    .from("customer-photos")
    .createSignedUploadUrl(objectPath, { upsert: false });
  requireNoError(signedSlot.error, "Create one-path signed upload slot");

  if (!signedSlot.data?.token) {
    throw new Error("Signed upload slot returned no token.");
  }

  requireNoError(
    (
      await publicClient.storage
        .from("customer-photos")
        .uploadToSignedUrl(objectPath, signedSlot.data.token, pngBytes, {
          cacheControl: "0",
          contentType: "image/png",
          upsert: false,
        })
    ).error,
    "Upload exact signed object",
  );

  const overwrite = await publicClient.storage
    .from("customer-photos")
    .uploadToSignedUrl(objectPath, signedSlot.data.token, pngBytes, {
      cacheControl: "0",
      contentType: "image/png",
      upsert: false,
    });

  if (!overwrite.error) {
    throw new Error("Signed immutable upload unexpectedly overwrote an existing object.");
  }

  directPath = `customer-photos/${ownerId}/${profileId}/${directPhotoId}/original.png`;
  const directUpload = await ownerClient.storage
    .from("customer-photos")
    .upload(directPath, pngBytes, { contentType: "image/png", upsert: false });

  if (!directUpload.error) {
    throw new Error("General authenticated Storage insert unexpectedly succeeded.");
  }

  const acceptedPhotoResult = await server
    .from("photos")
    .update({ accepted_at: new Date().toISOString(), status: "accepted" })
    .eq("id", photoId)
    .select("expires_at,owner_id,status,storage_path")
    .single();
  requireNoError(acceptedPhotoResult.error, "Accept uploaded photo metadata");
  const acceptedPhoto = acceptedPhotoSchema.parse(acceptedPhotoResult.data);

  if (acceptedPhoto.owner_id !== ownerId || acceptedPhoto.storage_path !== objectPath) {
    throw new Error("Accepted photo metadata does not match the signed object owner and path.");
  }

  requireNoError(
    (await server.storage.from("customer-photos").info(objectPath)).error,
    "Verify exact uploaded object",
  );

  requireNoError(
    (await ownerClient.storage.from("customer-photos").download(objectPath)).error,
    "Read owned accepted object",
  );

  const crossOwnerRead = await otherClient.storage
    .from("customer-photos")
    .download(objectPath);
  if (!crossOwnerRead.error) {
    throw new Error("Cross-owner authenticated object read unexpectedly succeeded.");
  }

  const listResult = await ownerClient.storage
    .from("customer-photos")
    .list(ownerId, { limit: 100 });
  if (!listResult.error && (listResult.data?.length ?? 0) > 0) {
    throw new Error("Authenticated bucket listing unexpectedly exposed an object.");
  }

  const expiredPhotoResult = await server
    .from("photos")
    .update({ expires_at: expiredAt.toISOString() })
    .eq("id", photoId)
    .select("expires_at,owner_id,status,storage_path")
    .single();
  requireNoError(expiredPhotoResult.error, "Expire photo metadata");
  const expiredPhoto = acceptedPhotoSchema.parse(expiredPhotoResult.data);

  if (Date.parse(expiredPhoto.expires_at) > Date.now()) {
    throw new Error("Photo metadata did not reach its logical expiry deadline.");
  }

  const expiredRead = await ownerClient.storage
    .from("customer-photos")
    .download(objectPath, { cacheNonce: crypto.randomUUID() });
  if (!expiredRead.error) {
    throw new Error("Expired photo object read unexpectedly succeeded.");
  }

  console.log("Photo Storage integration test passed.");
} finally {
  if (objectPath) {
    await server.storage.from("customer-photos").remove([objectPath]);
  }
  if (directPath) {
    await server.storage.from("customer-photos").remove([directPath]);
  }
  await server.from("profiles").delete().eq("id", profileId);
  if (ownerId) {
    await server.auth.admin.deleteUser(ownerId);
  }
  if (otherId) {
    await server.auth.admin.deleteUser(otherId);
  }
}
