create type public.tryon_session_status as enum (
  'queued',
  'generating',
  'succeeded',
  'failed',
  'deleted'
);

create table public.tryon_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  garment_id text not null check (char_length(garment_id) > 0),
  source_photo_ref text not null check (char_length(source_photo_ref) > 0),
  status public.tryon_session_status not null default 'queued',
  provider text,
  provider_request_id text,
  latency_ms integer check (latency_ms is null or latency_ms >= 0),
  failure_code text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (id, user_id)
);

create table public.generated_assets (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null,
  user_id uuid not null references auth.users (id) on delete cascade,
  bucket_id text not null default 'tryon-assets' check (bucket_id = 'tryon-assets'),
  object_path text not null check (char_length(object_path) > 0),
  created_at timestamptz not null default now(),
  foreign key (session_id, user_id) references public.tryon_sessions (id, user_id) on delete cascade,
  unique (bucket_id, object_path)
);

create index tryon_sessions_user_created_at_idx on public.tryon_sessions (user_id, created_at desc);
create index generated_assets_session_id_idx on public.generated_assets (session_id);
create index generated_assets_user_id_idx on public.generated_assets (user_id);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger tryon_sessions_set_updated_at
before update on public.tryon_sessions
for each row execute function public.set_updated_at();

alter table public.tryon_sessions enable row level security;
alter table public.generated_assets enable row level security;

create policy "Users can read their own try-on sessions"
on public.tryon_sessions for select
using ((select auth.uid()) = user_id);

create policy "Users can create their own try-on sessions"
on public.tryon_sessions for insert
with check ((select auth.uid()) = user_id);

create policy "Users can update their own try-on sessions"
on public.tryon_sessions for update
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "Users can delete their own try-on sessions"
on public.tryon_sessions for delete
using ((select auth.uid()) = user_id);

create policy "Users can read their own generated assets"
on public.generated_assets for select
using ((select auth.uid()) = user_id);

create policy "Users can create their own generated assets"
on public.generated_assets for insert
with check ((select auth.uid()) = user_id);

create policy "Users can delete their own generated assets"
on public.generated_assets for delete
using ((select auth.uid()) = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'tryon-assets',
  'tryon-assets',
  false,
  10485760,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do nothing;

create policy "Users can read their own try-on files"
on storage.objects for select
using (
  bucket_id = 'tryon-assets'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

create policy "Users can upload their own try-on files"
on storage.objects for insert
with check (
  bucket_id = 'tryon-assets'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

create policy "Users can delete their own try-on files"
on storage.objects for delete
using (
  bucket_id = 'tryon-assets'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);
