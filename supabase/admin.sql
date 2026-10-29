-- Run AFTER schema.sql. Admin membership is provisioned only through the SQL Editor.
create table if not exists public.admin_users (
 user_id uuid primary key references auth.users(id) on delete cascade,
 created_at timestamptz not null default now()
);
alter table public.admin_users enable row level security;
revoke all on public.admin_users from anon,authenticated;
create or replace function public.is_platform_admin() returns boolean
language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.admin_users where user_id=auth.uid());
$$;
revoke all on function public.is_platform_admin() from public;
grant execute on function public.is_platform_admin() to authenticated;
create policy "Admins read reports" on public.issues for select to authenticated using(public.is_platform_admin());
alter table public.issues add column if not exists resolution_evidence text not null default '';
create table if not exists public.moderation_events (
 id uuid primary key default gen_random_uuid(),
 issue_reference text not null,
 actor_id uuid not null references auth.users(id),
 old_status text not null,
 new_status text not null,
 note text not null check(length(note) between 10 and 2000),
 resolution_evidence text not null default '',
 created_at timestamptz not null default now()
);
alter table public.moderation_events enable row level security;
revoke all on public.moderation_events from anon,authenticated;
grant select on public.moderation_events to authenticated;
create policy "Admins read audit history" on public.moderation_events for select to authenticated using(public.is_platform_admin());
create index if not exists moderation_events_created_idx on public.moderation_events(created_at desc);
create or replace function public.admin_review_issue(p_reference text,p_status text,p_note text,p_resolution_evidence text,p_expected_status text)
returns void language plpgsql security definer set search_path='' as $$
declare current_issue public.issues%rowtype;
begin
 if not public.is_platform_admin() then raise exception 'Administrator access required'; end if;
 if p_status is null or p_status not in ('submitted','review','information_required','published','complaint_filed','followup','action_reported','verified','closed','rejected','withdrawn','restricted') then raise exception 'Invalid status'; end if;
 if p_note is null or length(trim(p_note))<10 or length(p_note)>2000 then raise exception 'A review note of 10 to 2000 characters is required'; end if;
 if coalesce(length(p_resolution_evidence),0)>4000 then raise exception 'Resolution evidence exceeds 4000 characters'; end if;
 if p_status='verified' and coalesce(length(trim(p_resolution_evidence)),0)<10 then raise exception 'Document resolution evidence before verifying'; end if;
 select * into current_issue from public.issues where reference=p_reference for update;
 if not found then raise exception 'Report not found'; end if;
 if p_expected_status is distinct from current_issue.status then raise exception 'Another reviewer changed this report. Refresh before reviewing again.'; end if;
 update public.issues set status=p_status,resolution_evidence=coalesce(p_resolution_evidence,'') where id=current_issue.id;
 insert into public.moderation_events(issue_reference,actor_id,old_status,new_status,note,resolution_evidence)
 values(p_reference,auth.uid(),current_issue.status,p_status,trim(p_note),coalesce(p_resolution_evidence,''));
end;
$$;
revoke all on function public.admin_review_issue(text,text,text,text,text) from public;
grant execute on function public.admin_review_issue(text,text,text,text,text) to authenticated;
create policy "Admins read private attachment records" on public.evidence for select to authenticated using(public.is_platform_admin());
create policy "Admins read private attachment files" on storage.objects for select to authenticated using(bucket_id='evidence' and public.is_platform_admin());
-- After the intended admin has signed in and verified their email:
-- insert into public.admin_users(user_id) select id from auth.users where email='YOUR_ADMIN_EMAIL' and email_confirmed_at is not null;
-- Never let browser clients write to admin_users or store a service-role key in the frontend.
