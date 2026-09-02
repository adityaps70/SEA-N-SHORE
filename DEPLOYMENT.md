# Production Deployment Checklist

## 1. Supabase

Create a **new Sea N Shore Supabase project**. Do not reuse an unrelated existing database.

Apply `supabase/schema.sql`, then configure:

- Email authentication
- Google OAuth
- Site URL
- `/auth/callback` redirect URLs
- Storage buckets: `avatars`, `post-media`, `certificates`, `course-media`, `event-media`, `cvs`
- Private buckets for certificates, course media and CVs

Run Supabase security/performance advisors after applying the schema.

## 2. Vercel

Import the repository/folder, choose the `production` directory as project root if this lives inside the full handoff package, and add all environment variables.

Deploy preview first. Do not promote until the build, auth callback and major routes have been verified.

## 3. Payments

The schema supports payments/subscriptions. Connect Razorpay (India-first) server-side only; never expose secret keys in browser code.

## 4. AI

Connect a server-side model provider to the AI assistant. For regulatory answers, retrieve and cite controlling official maritime sources and their effective dates rather than relying on model memory alone.

## 5. Production acceptance

Verify:

- signup / email login / Google login / sign out
- profile create + edit
- verification submission
- post create / comment / reaction / save
- group join + posting permissions
- candidate job apply / save / tracking
- recruiter post job / shortlist / interview workflow
- course enrollment / progress / quiz / certificate
- mentor booking / payment / review
- event registration
- article discussion
- notifications
- admin moderation / audit logging
- mobile layouts
- accessibility keyboard paths
- payment webhooks and idempotency
