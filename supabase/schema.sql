-- Run in your Supabase SQL Editor. No service-role key is needed in the browser.
create extension if not exists pgcrypto;
create table if not exists public.issues (
 id uuid primary key default gen_random_uuid(),
 reference text unique not null,
 user_id uuid not null references auth.users(id) on delete cascade,
 title text not null check(length(title) between 1 and 140),
 description text not null check(length(description) between 20 and 4000),
 category text not null check(category in ('roads','water','sanitation','electricity','drainage','transport','health','education','safety','parks','environment','construction','services','other')),
 district text not null check(length(district) between 1 and 100),
 locality text not null check(length(locality) between 1 and 180),
 status text not null default 'submitted' check(status in ('submitted','review','information_required','published','complaint_filed','followup','action_reported','verified','closed','rejected','withdrawn','restricted')),
 consent boolean not null check(consent = true),
 created_at timestamptz not null default now()
);
alter table public.issues enable row level security;
revoke all on public.issues from anon, authenticated;
grant select,insert on public.issues to authenticated;
create policy "Citizens see their own reports" on public.issues for select to authenticated using(user_id = auth.uid());
create or replace function public.current_user_email_verified() returns boolean
language sql stable security definer set search_path = '' as $$
 select exists(select 1 from auth.users where id = auth.uid() and email_confirmed_at is not null);
$$;
revoke all on function public.current_user_email_verified() from public;
grant execute on function public.current_user_email_verified() to authenticated;
create policy "Verified citizens submit pending reports" on public.issues for insert to authenticated with check(
 user_id = auth.uid() and status = 'submitted' and public.current_user_email_verified()
);
-- Only a trusted moderator/backend with elevated privileges may change status.
-- Public projection deliberately excludes user_id and private account details.
create or replace view public.public_issues with (security_barrier = true) as
 select reference,title,description,category,district,locality,status,created_at
 from public.issues where status in ('published','complaint_filed','followup','action_reported','verified','closed');
grant select on public.public_issues to anon,authenticated;
create index if not exists issues_district_status_idx on public.issues(district,status,created_at desc);
create index if not exists issues_owner_idx on public.issues(user_id);
create table if not exists public.supports (
 issue_reference text not null references public.issues(reference) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 created_at timestamptz not null default now(),
 primary key(issue_reference,user_id)
);
alter table public.supports enable row level security;
revoke all on public.supports from anon, authenticated;
grant select, insert, delete on public.supports to authenticated;
create policy "Read own supports" on public.supports for select to authenticated using(user_id=auth.uid());
create policy "Support approved issues" on public.supports for insert to authenticated with check(user_id=auth.uid() and exists(select 1 from public.public_issues where reference=issue_reference));
create policy "Remove own support" on public.supports for delete to authenticated using(user_id=auth.uid());
create or replace view public.support_counts with (security_barrier = true) as select issue_reference,count(*)::integer as count from public.supports group by issue_reference;
grant select on public.support_counts to anon,authenticated;
create table if not exists public.evidence (
 id uuid primary key default gen_random_uuid(),
 issue_id uuid not null references public.issues(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 path text not null,
 created_at timestamptz not null default now()
);
alter table public.evidence enable row level security;
revoke all on public.evidence from anon, authenticated;
grant select,insert on public.evidence to authenticated;
create policy "Read own evidence" on public.evidence for select to authenticated using(user_id=auth.uid());
create policy "Attach evidence to own report" on public.evidence for insert to authenticated with check(user_id=auth.uid() and exists(select 1 from public.issues where id=issue_id and user_id=auth.uid()));
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('evidence','evidence',false,5242880,array['image/jpeg','image/png','image/webp']) on conflict(id) do nothing;
create policy "Upload into own private folder" on storage.objects for insert to authenticated with check(bucket_id='evidence' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Read own private evidence" on storage.objects for select to authenticated using(bucket_id='evidence' and (storage.foldername(name))[1] = auth.uid()::text);
-- Public media must use a separate, moderated and metadata-stripped publishing pipeline.
-- Never make the evidence bucket public.
