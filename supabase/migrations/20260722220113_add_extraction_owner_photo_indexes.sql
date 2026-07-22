begin;

create index photo_style_signals_owner_photo_idx
on public.photo_style_signals (owner_id, photo_id);

create index extracted_garments_owner_photo_idx
on public.extracted_garments (owner_id, source_photo_id);

commit;
