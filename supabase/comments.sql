-- Run after schema.sql. Only verified, signed-in accounts may add comments.
create table if not exists public.comments (
 id uuid primary key default gen_random_uuid(),
 issue_reference text not null references public.issues(reference) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 display_name text not null default 'Citizen' check(length(trim(display_name)) between 1 and 60),
 body text not null check(length(trim(body)) between 3 and 2000),
 created_at timestamptz not null default now()
);
alter table public.comments enable row level security;
revoke all on public.comments from anon,authenticated;
grant insert,select on public.comments to authenticated;
create policy "Read own comments" on public.comments for select to authenticated using(user_id=auth.uid());
create policy "Verified citizens comment on approved issues" on public.comments for insert to authenticated with check(
 user_id=auth.uid() and public.current_user_email_verified() and exists(select 1 from public.public_issues where reference=issue_reference)
);
create or replace view public.public_comments with (security_barrier=true) as
 select c.id,c.issue_reference,c.display_name,c.body,c.created_at from public.comments c
 where exists(select 1 from public.public_issues i where i.reference=c.issue_reference);
grant select on public.public_comments to anon,authenticated;
create index if not exists comments_issue_created_idx on public.comments(issue_reference,created_at);
