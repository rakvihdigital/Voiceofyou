# Voice of You

Responsive citizen participation app built from the supplied project brief and logo using Next.js App Router, React, TypeScript, Tailwind CSS 4, Lucide and Supabase JS.

## Run locally

```sh
npm install
npm run dev
```

Open http://localhost:3000. The interface supports English, Kannada and Hindi, remembering the selected language. Sample reports and photos are illustrative, not verified complaints or impact claims. Demo submissions and supported reports persist only in the current browser. Demo image evidence is stored in browser local storage (5 MB file limit; storage may fill sooner).

## Connect Supabase

1. Create a Supabase project and run `supabase/schema.sql` in its SQL Editor once.
2. Copy `.env.example` to `.env.local`. Set the project URL and **publishable** key. Never use a service role key in a `NEXT_PUBLIC_` variable.
3. In Supabase Authentication, enable email sign-in, require email confirmation, and configure the Site URL and allowed redirect URLs for localhost and your deployment.
4. Restart the server or rebuild the deployment. Sign in with an email magic link before submitting.
5. Review pending issues in the Supabase dashboard with a trusted operator account. Publish only after verification and redaction. Browser users cannot approve their own reports.

The database has row level security, private evidence storage and an approved public projection that excludes account IDs. Each report gets a unique reference. The UI never describes a citizen submission as an official government complaint. Language selection translates interface and sample content; user-submitted text remains in its original language.

## Included

- Branded overview, illustrative metrics, issue cards and report detail dialogs.
- Search, district/category/status filters, recent/oldest/most-supported sorting.
- Interactive schematic Karnataka map and list switching. Locations are illustrative and approximate, not a geographic navigation map.
- Report form with consent, client validation, optional private photo, reference confirmation.
- Local demo mode and Supabase-backed email auth, submission, own reports and support persistence when configured.
- Resolved issues, roads-focused development watch, own/supported reports, reference search, About, Help and preliminary community/privacy copy.
- Mobile navigation, keyboard modal focus containment, Escape dismissal and reduced motion support.

## Verification

```sh
npm run typecheck
npm run build
```

Build produces the static `out/` export. Supabase access runs in the browser under database RLS. Environment variables are embedded at build time; rebuild after changing them.

## Before public launch

This is an initial implementation, not the complete operational system described in the brief. Configure and integration-test a real Supabase project. Add a full role-based moderation dashboard, immutable status audit history, notification delivery, rate limiting/abuse protection, upload malware scanning and metadata stripping, geographic map provider and coordinates, configurable categories, full appeal/deletion/contact workflows and reviewed legal policies. Validate translations with native speakers. Current photos are illustrative stock imagery. The logo is the user-provided image, including its embedded watermark. New Sites deployments are private by default.

Documentation: https://nextjs.org/docs/app/getting-started and https://supabase.com/docs/guides/getting-started/quickstarts/nextjs
