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

- Public website with an image-led hero, selectable stories, category collections, community purpose and report detail dialogs.
- Dedicated Explore, Resolved and About designs, with editorial typography and English, Kannada and Hindi copy.
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

## Design reference

The presentation direction follows the user-provided reference https://swaadha-khaki.vercel.app/ using an original civic layout, navy and saffron palette, serif typography, large photographs and rounded controls. The approved homepage remains unchanged during the inner-page pass. Vidhana Soudha hero photograph: https://plcorp-cdn.pinelabs.com/2025/03/Bangalore.webp . Other stock photographs use the Unsplash URLs in src/lib/editorial.ts and src/lib/data.ts.

## Separate pages and admin workspace

Public pages now have independent routes: `/`, `/explore-issues/`, `/resolved-issues/`, `/about/`, `/karnataka-map/`, `/development-watch/`, `/help/`, `/my-reports/`, and `/supported-issues/`. Each route is included in the static export and can be refreshed or opened directly. Main navigation uses Next.js links. Category tiles carry the category into the Explore URL query.

There are 14 distinct illustrative demo reports, including 10 additional reports. Issue image credits are linked in the report dialog; demo photos are illustrative, not evidence of the named locations.

### Admin access

Open `/admin/` directly. There is no admin link in the public footer. Without Supabase, use the clearly labelled demo credentials shown on the login page: `admin@voiceofyou.demo` / `VoiceOfYouDemo2026!`. They only unlock local sample-data controls; they are never accepted for live Supabase access. The responsive admin demo supports report search, status filters, evidence previews, review notes, status changes and an activity log. Demo reviews persist in this browser and update the local public demo. The demo is not a live security boundary and contains no real citizen data.

For live administration:
1. Configure Supabase as above, then run `supabase/admin.sql` after `supabase/schema.sql`.
2. Add `/admin/` to the allowed email authentication redirect URLs.
3. Enable email/password authentication and require email confirmation. Provision the intended admin with the SQL Editor example in the migration, or set `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` in your terminal and run `npm run admin:create`. It prompts for the admin email and a hidden password; it never writes or prints the password.
4. The browser checks the authenticated membership via `is_platform_admin()`. Database RLS independently protects reports, evidence and audit history. Status changes run through `admin_review_issue`, which checks membership again, locks the report, rejects stale reviews, and records an audit event atomically. Citizens have no direct UPDATE privileges. Admin membership cannot be granted from the browser.
5. Test with both an admin account and a non-admin account before using real data. Supabase integration remains unverified until an actual project is connected. Never place service-role credentials in browser environment variables.

Verified outcomes require a review note and recorded resolution evidence. Moderation records cannot be edited or deleted by ordinary browser clients. Signed attachment links expire after five minutes. Titles/descriptions are reviewed here; editing content and administering user roles remain outside this first admin implementation.

### Accounts and discussion

Public account dialogs now support email/password sign-in and sign-up, with email confirmation required before commenting. Run `supabase/comments.sql` after `schema.sql` to enable comments. Database RLS rejects anonymous or unverified comment inserts and permits comments only on approved reports. Public comment views omit account IDs and email addresses. Demo discussion is labelled illustrative and cannot accept new comments without a real signed-in Supabase account. The admin interface is always English and uses email/password sign-in. No real admin credential is hardcoded or included in the source. Public demo credentials are used only when Supabase is absent. The locally provided account-details file is excluded from Git and publishing.
