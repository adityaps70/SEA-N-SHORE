# Sea N Shore Global Shipping Community — Production App

Startup-grade maritime professional ecosystem built with Next.js App Router, TypeScript, Tailwind CSS and a Supabase-ready PostgreSQL/auth architecture.

## Product surfaces

- `/home` — professional maritime social feed
- `/jobs` — candidate jobs marketplace
- `/recruiter` — company/recruiter hiring workspace
- `/community` — professional groups
- `/learn` — Sea N Shore Academy
- `/mentorship` — expert marketplace
- `/wellness` — seafarer wellbeing
- `/branding` — CV and LinkedIn optimisation
- `/events` — maritime events
- `/knowledge` — regulations, safety and industry knowledge
- `/assistant` — AI Maritime Assistant
- `/profile` — maritime professional identity and reputation
- `/verification` — certificate/company/identity verification workflow
- `/admin` — platform administration and analytics
- `/login` + `/auth/callback` — Supabase email/Google authentication flow

## Local setup

1. Use Node.js 22.
2. Copy `.env.example` to `.env.local`.
3. Create a dedicated Supabase project for Sea N Shore.
4. Apply `supabase/schema.sql` to that project.
5. Add the project URL and publishable key to `.env.local`.
6. Run:

```bash
npm install
npm test
npm run typecheck
npm run dev
```

Open `http://localhost:3000`.

## Required environment variables

```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=
SUPABASE_SERVICE_ROLE_KEY=
NEXT_PUBLIC_APP_URL=http://localhost:3000
AI_PROVIDER_API_KEY=
RAZORPAY_KEY_ID=
RAZORPAY_KEY_SECRET=
```

Never expose the Supabase service role key in client code.

## Database and security

`supabase/schema.sql` contains the normalized production model for identity, companies, social graph, posts, groups, jobs, applications, courses, mentorship, events, knowledge, verification, reputation, notifications, subscriptions, payments, moderation and analytics.

The schema enables Row Level Security on all exposed public tables and keeps privileged authorization helpers in a non-exposed `private` schema.

## Authentication

The app uses `@supabase/ssr` browser/server clients and a Next.js proxy for cookie refresh. Email magic links and Google OAuth return through `/auth/callback`, which exchanges the PKCE auth code server-side before routing into the network.

## Production deployment

Recommended target: Vercel + a dedicated Supabase project in an India/Asia-adjacent region suitable for your user base.

On Vercel:

1. Import this folder as the project root.
2. Add the environment variables above.
3. Set Supabase Auth redirect URLs to include:
   - `https://YOUR_DOMAIN/auth/callback`
   - your Vercel preview callback URL while testing
4. Deploy a preview.
5. Run smoke tests on `/`, `/login`, `/home`, `/jobs`, `/recruiter`, `/learn`, `/assistant`, `/admin`.
6. Promote the verified preview to production.

## Current implementation mode

The production UI is complete at MVP interaction level and uses realistic maritime seed data for immediate review. Authentication is wired for Supabase. Marketplace/social interactions are currently optimistic client interactions; the schema and security model are ready for persistence wiring as the next backend integration layer.

## Verification commands

```bash
npm test
npm run typecheck
npm run build
```

CI under `.github/workflows/verify.yml` runs all three on pushes and pull requests.
