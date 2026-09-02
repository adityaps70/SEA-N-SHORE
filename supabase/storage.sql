-- Sea N Shore Storage buckets and policies.
-- Run after schema.sql. Private buckets must be served through signed URLs.
insert into storage.buckets (id,name,public) values
  ('avatars','avatars',true),
  ('post-media','post-media',true),
  ('company-media','company-media',true),
  ('course-media','course-media',false),
  ('event-media','event-media',true),
  ('certificates','certificates',false),
  ('cv-assets','cv-assets',false)
on conflict (id) do update set public=excluded.public;

create policy "avatars public read" on storage.objects for select using (bucket_id='avatars');
create policy "avatars owner insert" on storage.objects for insert to authenticated with check (bucket_id='avatars' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "avatars owner update" on storage.objects for update to authenticated using (bucket_id='avatars' and owner_id=(select auth.uid())) with check (bucket_id='avatars' and owner_id=(select auth.uid()));
create policy "avatars owner delete" on storage.objects for delete to authenticated using (bucket_id='avatars' and owner_id=(select auth.uid()));

create policy "post media public read" on storage.objects for select using (bucket_id='post-media');
create policy "post media owner insert" on storage.objects for insert to authenticated with check (bucket_id='post-media' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "post media owner update" on storage.objects for update to authenticated using (bucket_id='post-media' and owner_id=(select auth.uid())) with check (bucket_id='post-media' and owner_id=(select auth.uid()));
create policy "post media owner delete" on storage.objects for delete to authenticated using (bucket_id='post-media' and owner_id=(select auth.uid()));

create policy "event media public read" on storage.objects for select using (bucket_id='event-media');

create policy "certificates self read" on storage.objects for select to authenticated using (bucket_id='certificates' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "certificates self insert" on storage.objects for insert to authenticated with check (bucket_id='certificates' and (storage.foldername(name))[1]=(select auth.uid())::text);

create policy "cv self read" on storage.objects for select to authenticated using (bucket_id='cv-assets' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "cv self insert" on storage.objects for insert to authenticated with check (bucket_id='cv-assets' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "cv self update" on storage.objects for update to authenticated using (bucket_id='cv-assets' and owner_id=(select auth.uid())) with check (bucket_id='cv-assets' and owner_id=(select auth.uid()));
create policy "cv self delete" on storage.objects for delete to authenticated using (bucket_id='cv-assets' and owner_id=(select auth.uid()));
