-- Shared settings and uploaded media for the kindergarten activity site.
-- Run this once in the Supabase SQL Editor after creating a project.

create table if not exists public.ovi_settings (
    setting_key text primary key,
    json_value jsonb,
    file_path text,
    file_name text,
    file_type text,
    updated_at timestamptz not null default now(),
    updated_by uuid references auth.users (id) on delete set null
);

alter table public.ovi_settings enable row level security;
grant select, insert, update, delete on public.ovi_settings to authenticated;

drop policy if exists "Signed-in users can read shared settings" on public.ovi_settings;
create policy "Signed-in users can read shared settings"
    on public.ovi_settings for select to authenticated
    using (true);

drop policy if exists "Signed-in users can add shared settings" on public.ovi_settings;
create policy "Signed-in users can add shared settings"
    on public.ovi_settings for insert to authenticated
    with check (true);

drop policy if exists "Signed-in users can update shared settings" on public.ovi_settings;
create policy "Signed-in users can update shared settings"
    on public.ovi_settings for update to authenticated
    using (true)
    with check (true);

drop policy if exists "Signed-in users can delete shared settings" on public.ovi_settings;
create policy "Signed-in users can delete shared settings"
    on public.ovi_settings for delete to authenticated
    using (true);

insert into storage.buckets (id, name, public, file_size_limit)
values ('ovi-assets', 'ovi-assets', false, 52428800)
on conflict (id) do update
set public = false,
    file_size_limit = excluded.file_size_limit;

drop policy if exists "Signed-in users can read shared media" on storage.objects;
create policy "Signed-in users can read shared media"
    on storage.objects for select to authenticated
    using (bucket_id = 'ovi-assets');

drop policy if exists "Signed-in users can upload shared media" on storage.objects;
create policy "Signed-in users can upload shared media"
    on storage.objects for insert to authenticated
    with check (bucket_id = 'ovi-assets');

drop policy if exists "Signed-in users can update shared media" on storage.objects;
create policy "Signed-in users can update shared media"
    on storage.objects for update to authenticated
    using (bucket_id = 'ovi-assets')
    with check (bucket_id = 'ovi-assets');

drop policy if exists "Signed-in users can delete shared media" on storage.objects;
create policy "Signed-in users can delete shared media"
    on storage.objects for delete to authenticated
    using (bucket_id = 'ovi-assets');
