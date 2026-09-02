-- Sea N Shore Global Shipping Community
-- Production-oriented PostgreSQL / Supabase schema
-- Run in a new Supabase project after Auth providers and environment variables are configured.

create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  full_name text not null,
  avatar_url text,
  profile_type text not null check (profile_type in ('Seafarer','Maritime Professional','Company','Trainer','Mentor','Recruiter','Maritime Service Provider')),
  rank text,
  current_company text,
  current_vessel text,
  sailing_experience_years numeric(5,2) default 0,
  vessel_types text[] default '{}',
  trading_areas text[] default '{}',
  coc_details jsonb default '{}'::jsonb,
  stcw_certifications jsonb default '[]'::jsonb,
  certificates jsonb default '[]'::jsonb,
  skills text[] default '{}',
  professional_summary text,
  career_interests text[] default '{}',
  shore_career_preference text,
  availability text,
  location text,
  verification_badge text,
  verification_status text not null default 'unverified' check (verification_status in ('unverified','pending','verified','rejected')),
  reputation_points integer not null default 0,
  is_admin boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger profiles_updated_at before update on public.profiles for each row execute function public.set_updated_at();

create table if not exists public.companies (
  id uuid primary key default gen_random_uuid(),
  owner_profile_id uuid references public.profiles(id) on delete set null,
  name text not null,
  slug text unique not null,
  logo_url text,
  about text,
  fleet_details jsonb default '{}'::jsonb,
  offices jsonb default '[]'::jsonb,
  website text,
  verified boolean not null default false,
  verification_status text not null default 'unverified',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger companies_updated_at before update on public.companies for each row execute function public.set_updated_at();

create table if not exists public.groups (
  id uuid primary key default gen_random_uuid(),
  owner_profile_id uuid references public.profiles(id) on delete set null,
  name text not null,
  slug text unique not null,
  description text,
  image_url text,
  visibility text not null default 'public' check (visibility in ('public','private')),
  category text,
  member_count integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger groups_updated_at before update on public.groups for each row execute function public.set_updated_at();

create table if not exists public.group_members (
  group_id uuid references public.groups(id) on delete cascade,
  profile_id uuid references public.profiles(id) on delete cascade,
  role text not null default 'member' check (role in ('member','moderator','admin')),
  joined_at timestamptz not null default now(),
  primary key (group_id, profile_id)
);

create table if not exists public.follows (
  follower_id uuid references public.profiles(id) on delete cascade,
  followed_profile_id uuid references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (follower_id, followed_profile_id),
  check (follower_id <> followed_profile_id)
);

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references public.profiles(id) on delete cascade,
  group_id uuid references public.groups(id) on delete cascade,
  category text not null,
  post_type text not null default 'standard' check (post_type in ('standard','question','poll','article')),
  body text not null,
  tags text[] default '{}',
  visibility text not null default 'public' check (visibility in ('public','connections','group')),
  status text not null default 'published' check (status in ('draft','published','hidden','removed')),
  share_count integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists posts_feed_idx on public.posts(status, created_at desc);
create index if not exists posts_author_idx on public.posts(author_id, created_at desc);
create index if not exists posts_group_idx on public.posts(group_id, created_at desc);
create trigger posts_updated_at before update on public.posts for each row execute function public.set_updated_at();

create table if not exists public.post_media (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  media_type text not null check (media_type in ('image','video','document')),
  storage_path text not null,
  alt_text text,
  sort_order integer not null default 0
);

create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  author_id uuid not null references public.profiles(id) on delete cascade,
  parent_comment_id uuid references public.comments(id) on delete cascade,
  body text not null,
  status text not null default 'published',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists comments_post_idx on public.comments(post_id, created_at);
create trigger comments_updated_at before update on public.comments for each row execute function public.set_updated_at();

create table if not exists public.post_reactions (
  post_id uuid references public.posts(id) on delete cascade,
  profile_id uuid references public.profiles(id) on delete cascade,
  reaction text not null default 'appreciate',
  created_at timestamptz not null default now(),
  primary key (post_id, profile_id)
);

create table if not exists public.post_saves (
  post_id uuid references public.posts(id) on delete cascade,
  profile_id uuid references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, profile_id)
);

create table if not exists public.polls (
  id uuid primary key default gen_random_uuid(),
  post_id uuid unique not null references public.posts(id) on delete cascade,
  question text not null,
  closes_at timestamptz
);
create table if not exists public.poll_options (
  id uuid primary key default gen_random_uuid(),
  poll_id uuid not null references public.polls(id) on delete cascade,
  label text not null,
  sort_order integer not null default 0
);
create table if not exists public.poll_votes (
  poll_id uuid references public.polls(id) on delete cascade,
  option_id uuid references public.poll_options(id) on delete cascade,
  profile_id uuid references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (poll_id, profile_id)
);

create table if not exists public.company_reviews (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  reviewer_profile_id uuid not null references public.profiles(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  title text,
  body text,
  status text not null default 'published',
  created_at timestamptz not null default now()
);

create table if not exists public.jobs (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  posted_by uuid references public.profiles(id) on delete set null,
  title text not null,
  rank text,
  vessel_type text,
  contract_duration text,
  salary_min numeric,
  salary_max numeric,
  salary_currency text,
  salary_display text,
  joining_date date,
  experience_required text,
  certificates_required text[] default '{}',
  skills_required text[] default '{}',
  location text,
  description text not null,
  employment_type text not null default 'contract',
  status text not null default 'draft' check (status in ('draft','published','paused','closed')),
  featured boolean not null default false,
  closes_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists jobs_discovery_idx on public.jobs(status, vessel_type, created_at desc);
create trigger jobs_updated_at before update on public.jobs for each row execute function public.set_updated_at();

create table if not exists public.job_applications (
  id uuid primary key default gen_random_uuid(),
  job_id uuid not null references public.jobs(id) on delete cascade,
  candidate_id uuid not null references public.profiles(id) on delete cascade,
  cover_note text,
  cv_storage_path text,
  status text not null default 'applied' check (status in ('applied','profile_viewed','shortlisted','interview','offer','hired','rejected','withdrawn')),
  recruiter_notes text,
  applied_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(job_id,candidate_id)
);
create index if not exists applications_candidate_idx on public.job_applications(candidate_id, applied_at desc);
create index if not exists applications_job_idx on public.job_applications(job_id, status);
create trigger applications_updated_at before update on public.job_applications for each row execute function public.set_updated_at();

create table if not exists public.saved_jobs (
  job_id uuid references public.jobs(id) on delete cascade,
  profile_id uuid references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key(job_id,profile_id)
);

create table if not exists public.interviews (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.job_applications(id) on delete cascade,
  scheduled_at timestamptz not null,
  duration_minutes integer not null default 30,
  meeting_url text,
  status text not null default 'scheduled',
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.courses (
  id uuid primary key default gen_random_uuid(),
  created_by uuid references public.profiles(id) on delete set null,
  title text not null,
  slug text unique not null,
  category text not null,
  level text,
  description text,
  thumbnail_path text,
  price_minor integer not null default 0,
  currency text not null default 'INR',
  status text not null default 'draft' check (status in ('draft','published','archived')),
  certificate_enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger courses_updated_at before update on public.courses for each row execute function public.set_updated_at();

create table if not exists public.course_lessons (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  title text not null,
  lesson_type text not null check (lesson_type in ('video','document','quiz','article')),
  content_url text,
  body text,
  duration_seconds integer,
  sort_order integer not null default 0,
  is_preview boolean not null default false
);
create index if not exists course_lessons_order_idx on public.course_lessons(course_id,sort_order);

create table if not exists public.course_enrollments (
  course_id uuid references public.courses(id) on delete cascade,
  profile_id uuid references public.profiles(id) on delete cascade,
  progress_percent integer not null default 0 check (progress_percent between 0 and 100),
  status text not null default 'active' check (status in ('active','completed','refunded','cancelled')),
  enrolled_at timestamptz not null default now(),
  completed_at timestamptz,
  certificate_storage_path text,
  primary key(course_id,profile_id)
);

create table if not exists public.lesson_progress (
  lesson_id uuid references public.course_lessons(id) on delete cascade,
  profile_id uuid references public.profiles(id) on delete cascade,
  completed boolean not null default false,
  last_position_seconds integer not null default 0,
  updated_at timestamptz not null default now(),
  primary key(lesson_id,profile_id)
);

create table if not exists public.course_discussions (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  lesson_id uuid references public.course_lessons(id) on delete cascade,
  author_id uuid not null references public.profiles(id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.quizzes (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  lesson_id uuid references public.course_lessons(id) on delete cascade,
  title text not null,
  pass_percent integer not null default 70
);
create table if not exists public.quiz_questions (
  id uuid primary key default gen_random_uuid(),
  quiz_id uuid not null references public.quizzes(id) on delete cascade,
  question text not null,
  options jsonb not null,
  correct_option integer not null,
  explanation text,
  sort_order integer not null default 0
);
create table if not exists public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  quiz_id uuid not null references public.quizzes(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  score_percent integer not null,
  answers jsonb not null default '{}'::jsonb,
  passed boolean not null,
  attempted_at timestamptz not null default now()
);

create table if not exists public.mentor_profiles (
  profile_id uuid primary key references public.profiles(id) on delete cascade,
  expertise text[] not null default '{}',
  bio text,
  experience_summary text,
  session_price_minor integer not null default 0,
  currency text not null default 'INR',
  default_duration_minutes integer not null default 45,
  meeting_provider text,
  active boolean not null default true,
  average_rating numeric(3,2) not null default 0,
  review_count integer not null default 0
);
create table if not exists public.mentor_availability (
  id uuid primary key default gen_random_uuid(),
  mentor_profile_id uuid not null references public.mentor_profiles(profile_id) on delete cascade,
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  booked boolean not null default false
);
create table if not exists public.mentor_bookings (
  id uuid primary key default gen_random_uuid(),
  mentor_profile_id uuid not null references public.mentor_profiles(profile_id) on delete cascade,
  client_profile_id uuid not null references public.profiles(id) on delete cascade,
  availability_id uuid references public.mentor_availability(id) on delete set null,
  starts_at timestamptz not null,
  duration_minutes integer not null default 45,
  agenda text,
  meeting_url text,
  amount_minor integer not null default 0,
  currency text not null default 'INR',
  status text not null default 'confirmed' check (status in ('pending_payment','confirmed','completed','cancelled','refunded')),
  created_at timestamptz not null default now()
);
create table if not exists public.mentor_reviews (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid unique not null references public.mentor_bookings(id) on delete cascade,
  reviewer_profile_id uuid not null references public.profiles(id) on delete cascade,
  mentor_profile_id uuid not null references public.mentor_profiles(profile_id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  body text,
  created_at timestamptz not null default now()
);

create table if not exists public.wellness_content (
  id uuid primary key default gen_random_uuid(),
  author_id uuid references public.profiles(id) on delete set null,
  title text not null,
  category text not null,
  content_type text not null check (content_type in ('article','webinar','programme','session')),
  body text,
  media_url text,
  status text not null default 'published',
  created_at timestamptz not null default now()
);

create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  created_by uuid references public.profiles(id) on delete set null,
  title text not null,
  slug text unique not null,
  event_type text not null,
  description text,
  starts_at timestamptz not null,
  ends_at timestamptz,
  mode text,
  location text,
  meeting_url text,
  capacity integer,
  price_minor integer not null default 0,
  currency text not null default 'INR',
  speakers jsonb not null default '[]'::jsonb,
  status text not null default 'draft' check (status in ('draft','published','completed','cancelled')),
  sponsored boolean not null default false,
  created_at timestamptz not null default now()
);
create table if not exists public.event_registrations (
  event_id uuid references public.events(id) on delete cascade,
  profile_id uuid references public.profiles(id) on delete cascade,
  status text not null default 'registered',
  registered_at timestamptz not null default now(),
  primary key(event_id,profile_id)
);
create table if not exists public.event_media (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references public.events(id) on delete cascade,
  media_type text not null,
  storage_path text not null,
  caption text,
  sort_order integer not null default 0
);

create table if not exists public.knowledge_articles (
  id uuid primary key default gen_random_uuid(),
  author_id uuid references public.profiles(id) on delete set null,
  title text not null,
  slug text unique not null,
  category text not null,
  summary text,
  body text not null,
  source_label text,
  source_url text,
  status text not null default 'draft' check (status in ('draft','published','archived')),
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger articles_updated_at before update on public.knowledge_articles for each row execute function public.set_updated_at();
create table if not exists public.article_comments (
  id uuid primary key default gen_random_uuid(),
  article_id uuid not null references public.knowledge_articles(id) on delete cascade,
  author_id uuid not null references public.profiles(id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.cv_assets (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  storage_path text not null,
  target_role text,
  audit_result jsonb,
  created_at timestamptz not null default now()
);
create table if not exists public.branding_audits (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  audit_type text not null check (audit_type in ('cv','linkedin','personal_brand')),
  input jsonb not null default '{}'::jsonb,
  result jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.verification_requests (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references public.profiles(id) on delete cascade,
  company_id uuid references public.companies(id) on delete cascade,
  requested_badge text not null,
  methods text[] not null default '{}',
  evidence jsonb not null default '{}'::jsonb,
  status text not null default 'pending' check (status in ('pending','in_review','approved','rejected')),
  reviewed_by uuid references public.profiles(id) on delete set null,
  reviewer_notes text,
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz,
  check ((profile_id is not null) or (company_id is not null))
);

create table if not exists public.reputation_events (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  source_type text not null,
  source_id uuid,
  points integer not null,
  reason text not null,
  created_at timestamptz not null default now()
);
create index if not exists reputation_profile_idx on public.reputation_events(profile_id,created_at desc);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  notification_type text not null,
  title text not null,
  body text,
  action_url text,
  read_at timestamptz,
  created_at timestamptz not null default now()
);
create index if not exists notifications_profile_idx on public.notifications(profile_id,read_at,created_at desc);

create table if not exists public.subscription_plans (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  name text not null,
  audience text not null,
  price_minor integer not null,
  currency text not null default 'INR',
  billing_interval text not null,
  entitlements jsonb not null default '{}'::jsonb,
  active boolean not null default true
);
create table if not exists public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references public.profiles(id) on delete cascade,
  company_id uuid references public.companies(id) on delete cascade,
  plan_id uuid not null references public.subscription_plans(id),
  provider text,
  provider_subscription_id text,
  status text not null,
  current_period_end timestamptz,
  created_at timestamptz not null default now(),
  check ((profile_id is not null) or (company_id is not null))
);
create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references public.profiles(id) on delete set null,
  company_id uuid references public.companies(id) on delete set null,
  purpose text not null,
  reference_id uuid,
  amount_minor integer not null,
  currency text not null default 'INR',
  provider text,
  provider_payment_id text,
  status text not null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  subject_type text not null,
  subject_id uuid not null,
  reason text not null,
  details text,
  status text not null default 'open' check (status in ('open','reviewing','resolved','dismissed')),
  assigned_to uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  resolved_at timestamptz
);
create table if not exists public.audit_logs (
  id bigint generated always as identity primary key,
  actor_id uuid references public.profiles(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
create table if not exists public.analytics_events (
  id bigint generated always as identity primary key,
  profile_id uuid references public.profiles(id) on delete set null,
  event_name text not null,
  entity_type text,
  entity_id text,
  properties jsonb not null default '{}'::jsonb,
  occurred_at timestamptz not null default now()
);
create index if not exists analytics_name_time_idx on public.analytics_events(event_name,occurred_at desc);

-- Admin helper avoids recursive RLS checks.
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$ select coalesce((select is_admin from public.profiles where id = auth.uid()), false) $$;

-- Enable row-level security.
alter table public.profiles enable row level security;
alter table public.companies enable row level security;
alter table public.groups enable row level security;
alter table public.group_members enable row level security;
alter table public.follows enable row level security;
alter table public.posts enable row level security;
alter table public.post_media enable row level security;
alter table public.comments enable row level security;
alter table public.post_reactions enable row level security;
alter table public.post_saves enable row level security;
alter table public.polls enable row level security;
alter table public.poll_options enable row level security;
alter table public.poll_votes enable row level security;
alter table public.jobs enable row level security;
alter table public.job_applications enable row level security;
alter table public.saved_jobs enable row level security;
alter table public.interviews enable row level security;
alter table public.courses enable row level security;
alter table public.course_lessons enable row level security;
alter table public.course_enrollments enable row level security;
alter table public.lesson_progress enable row level security;
alter table public.course_discussions enable row level security;
alter table public.mentor_profiles enable row level security;
alter table public.mentor_availability enable row level security;
alter table public.mentor_bookings enable row level security;
alter table public.mentor_reviews enable row level security;
alter table public.events enable row level security;
alter table public.event_registrations enable row level security;
alter table public.knowledge_articles enable row level security;
alter table public.article_comments enable row level security;
alter table public.verification_requests enable row level security;
alter table public.reputation_events enable row level security;
alter table public.notifications enable row level security;
alter table public.subscriptions enable row level security;
alter table public.payments enable row level security;
alter table public.reports enable row level security;
alter table public.audit_logs enable row level security;
alter table public.analytics_events enable row level security;

-- Public professional discovery; users control their own profile.
create policy "profiles public read" on public.profiles for select using (true);
create policy "profiles self insert" on public.profiles for insert with check (id = auth.uid());
create policy "profiles self update" on public.profiles for update using (id = auth.uid() or public.is_admin()) with check (id = auth.uid() or public.is_admin());

create policy "companies public read" on public.companies for select using (true);
create policy "companies owner write" on public.companies for all using (owner_profile_id = auth.uid() or public.is_admin()) with check (owner_profile_id = auth.uid() or public.is_admin());

create policy "groups public read" on public.groups for select using (visibility='public' or owner_profile_id=auth.uid() or public.is_admin());
create policy "groups authenticated create" on public.groups for insert with check (owner_profile_id=auth.uid());
create policy "groups owner update" on public.groups for update using (owner_profile_id=auth.uid() or public.is_admin());
create policy "memberships visible" on public.group_members for select using (true);
create policy "memberships self manage" on public.group_members for insert with check (profile_id=auth.uid());
create policy "memberships self delete" on public.group_members for delete using (profile_id=auth.uid() or public.is_admin());

create policy "follows public read" on public.follows for select using (true);
create policy "follows self insert" on public.follows for insert with check (follower_id=auth.uid());
create policy "follows self delete" on public.follows for delete using (follower_id=auth.uid());

create policy "posts public read" on public.posts for select using (status='published' and (visibility='public' or author_id=auth.uid()) or author_id=auth.uid() or public.is_admin());
create policy "posts self insert" on public.posts for insert with check (author_id=auth.uid());
create policy "posts self update" on public.posts for update using (author_id=auth.uid() or public.is_admin());
create policy "posts self delete" on public.posts for delete using (author_id=auth.uid() or public.is_admin());
create policy "post media readable" on public.post_media for select using (true);
create policy "post media author write" on public.post_media for all using (exists(select 1 from public.posts p where p.id=post_id and (p.author_id=auth.uid() or public.is_admin()))) with check (exists(select 1 from public.posts p where p.id=post_id and (p.author_id=auth.uid() or public.is_admin())));

create policy "comments public read" on public.comments for select using (status='published' or author_id=auth.uid() or public.is_admin());
create policy "comments self insert" on public.comments for insert with check (author_id=auth.uid());
create policy "comments self modify" on public.comments for update using (author_id=auth.uid() or public.is_admin());
create policy "comments self delete" on public.comments for delete using (author_id=auth.uid() or public.is_admin());
create policy "reactions read" on public.post_reactions for select using (true);
create policy "reactions self" on public.post_reactions for all using (profile_id=auth.uid()) with check (profile_id=auth.uid());
create policy "saves self read" on public.post_saves for select using (profile_id=auth.uid());
create policy "saves self" on public.post_saves for all using (profile_id=auth.uid()) with check (profile_id=auth.uid());
create policy "polls read" on public.polls for select using (true);
create policy "poll options read" on public.poll_options for select using (true);
create policy "poll votes read" on public.poll_votes for select using (true);
create policy "poll votes self" on public.poll_votes for insert with check (profile_id=auth.uid());

create policy "published jobs read" on public.jobs for select using (status='published' or posted_by=auth.uid() or public.is_admin());
create policy "company jobs write" on public.jobs for all using (posted_by=auth.uid() or public.is_admin() or exists(select 1 from public.companies c where c.id=company_id and c.owner_profile_id=auth.uid())) with check (posted_by=auth.uid() or public.is_admin() or exists(select 1 from public.companies c where c.id=company_id and c.owner_profile_id=auth.uid()));
create policy "applications candidate or recruiter read" on public.job_applications for select using (candidate_id=auth.uid() or public.is_admin() or exists(select 1 from public.jobs j join public.companies c on c.id=j.company_id where j.id=job_id and c.owner_profile_id=auth.uid()));
create policy "applications candidate insert" on public.job_applications for insert with check (candidate_id=auth.uid());
create policy "applications candidate recruiter update" on public.job_applications for update using (candidate_id=auth.uid() or public.is_admin() or exists(select 1 from public.jobs j join public.companies c on c.id=j.company_id where j.id=job_id and c.owner_profile_id=auth.uid()));
create policy "saved jobs self" on public.saved_jobs for all using (profile_id=auth.uid()) with check (profile_id=auth.uid());
create policy "interviews participant read" on public.interviews for select using (public.is_admin() or exists(select 1 from public.job_applications a join public.jobs j on j.id=a.job_id join public.companies c on c.id=j.company_id where a.id=application_id and (a.candidate_id=auth.uid() or c.owner_profile_id=auth.uid())));

create policy "published courses read" on public.courses for select using (status='published' or created_by=auth.uid() or public.is_admin());
create policy "course admin write" on public.courses for all using (created_by=auth.uid() or public.is_admin()) with check (created_by=auth.uid() or public.is_admin());
create policy "lessons read enrolled or preview" on public.course_lessons for select using (is_preview or public.is_admin() or exists(select 1 from public.course_enrollments e where e.course_id=course_id and e.profile_id=auth.uid()));
create policy "enrollments self" on public.course_enrollments for all using (profile_id=auth.uid() or public.is_admin()) with check (profile_id=auth.uid() or public.is_admin());
create policy "lesson progress self" on public.lesson_progress for all using (profile_id=auth.uid()) with check (profile_id=auth.uid());
create policy "course discussions read" on public.course_discussions for select using (true);
create policy "course discussions self insert" on public.course_discussions for insert with check (author_id=auth.uid());

create policy "mentor profiles public read" on public.mentor_profiles for select using (active or profile_id=auth.uid() or public.is_admin());
create policy "mentor profile self" on public.mentor_profiles for all using (profile_id=auth.uid() or public.is_admin()) with check (profile_id=auth.uid() or public.is_admin());
create policy "mentor availability read" on public.mentor_availability for select using (true);
create policy "mentor availability self write" on public.mentor_availability for all using (mentor_profile_id=auth.uid() or public.is_admin()) with check (mentor_profile_id=auth.uid() or public.is_admin());
create policy "bookings participants" on public.mentor_bookings for select using (mentor_profile_id=auth.uid() or client_profile_id=auth.uid() or public.is_admin());
create policy "bookings client insert" on public.mentor_bookings for insert with check (client_profile_id=auth.uid());
create policy "bookings participants update" on public.mentor_bookings for update using (mentor_profile_id=auth.uid() or client_profile_id=auth.uid() or public.is_admin());
create policy "mentor reviews public read" on public.mentor_reviews for select using (true);
create policy "mentor reviews self insert" on public.mentor_reviews for insert with check (reviewer_profile_id=auth.uid());

create policy "events public read" on public.events for select using (status in ('published','completed') or created_by=auth.uid() or public.is_admin());
create policy "events creator write" on public.events for all using (created_by=auth.uid() or public.is_admin()) with check (created_by=auth.uid() or public.is_admin());
create policy "event registrations self" on public.event_registrations for all using (profile_id=auth.uid() or public.is_admin()) with check (profile_id=auth.uid() or public.is_admin());

create policy "articles public read" on public.knowledge_articles for select using (status='published' or author_id=auth.uid() or public.is_admin());
create policy "articles author write" on public.knowledge_articles for all using (author_id=auth.uid() or public.is_admin()) with check (author_id=auth.uid() or public.is_admin());
create policy "article comments read" on public.article_comments for select using (true);
create policy "article comments self insert" on public.article_comments for insert with check (author_id=auth.uid());

create policy "verification owner read" on public.verification_requests for select using (profile_id=auth.uid() or public.is_admin() or exists(select 1 from public.companies c where c.id=company_id and c.owner_profile_id=auth.uid()));
create policy "verification owner submit" on public.verification_requests for insert with check (profile_id=auth.uid() or exists(select 1 from public.companies c where c.id=company_id and c.owner_profile_id=auth.uid()));
create policy "verification admin update" on public.verification_requests for update using (public.is_admin());
create policy "reputation public read" on public.reputation_events for select using (true);
create policy "reputation admin write" on public.reputation_events for insert with check (public.is_admin());
create policy "notifications self" on public.notifications for all using (profile_id=auth.uid() or public.is_admin()) with check (profile_id=auth.uid() or public.is_admin());
create policy "subscriptions owner read" on public.subscriptions for select using (profile_id=auth.uid() or public.is_admin() or exists(select 1 from public.companies c where c.id=company_id and c.owner_profile_id=auth.uid()));
create policy "payments owner read" on public.payments for select using (profile_id=auth.uid() or public.is_admin() or exists(select 1 from public.companies c where c.id=company_id and c.owner_profile_id=auth.uid()));
create policy "reports reporter insert" on public.reports for insert with check (reporter_id=auth.uid());
create policy "reports reporter admin read" on public.reports for select using (reporter_id=auth.uid() or public.is_admin());
create policy "reports admin update" on public.reports for update using (public.is_admin());
create policy "audit logs admin read" on public.audit_logs for select using (public.is_admin());
create policy "analytics authenticated insert" on public.analytics_events for insert with check (profile_id=auth.uid() or profile_id is null);
create policy "analytics admin read" on public.analytics_events for select using (public.is_admin());

-- Suggested storage buckets (create through Supabase Storage UI or migrations as appropriate):
-- avatars (public), post-media (public), certificates (private), course-media (private), event-media (public), cvs (private).
