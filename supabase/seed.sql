-- Local-only deterministic identities for SQL policy tests.
-- The reserved .test domain guarantees these are synthetic fixtures.
insert into auth.users (id, email)
values
  ('11111111-1111-4111-8111-111111111111', 'owner-a@magic-mirror.test'),
  ('22222222-2222-4222-8222-222222222222', 'owner-b@magic-mirror.test')
on conflict (id) do nothing;
