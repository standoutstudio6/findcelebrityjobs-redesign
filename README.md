# FindCelebrityJobs Luxe Redesign Demo

This package is a **modern luxury redesign demo** for the public website at FindCelebrityJobs.com.

## What is included
- A polished static website with a premium dark editorial design.
- Core journey pages for employers, candidates, resources, locations, press, founder, mission, and contact.
- A searchable **content library** with 203+ preserved topic pages scaffolded from the public sitemap.
- Three featured job detail pages with `JobPosting` structured-data scaffolding.
- `robots.txt`, `sitemap.xml`, and a starter redirect map for migration planning.

## What this package is trying to solve
- Too many repeated links and template remnants in the current experience.
- Manual email-first newsletter and intake flows.
- A strong authority layer that currently feels more legacy than luxury.
- A need to keep the current site easy to find while improving presentation and conversions.

## SEO preservation principles used here
1. Keep the existing content pillars visible: staffing, jobs, resources, locations, press, founder, mission.
2. Add crawlable internal links and a clear human-readable sitemap.
3. Include XML sitemap and canonical links.
4. Use structured data on the homepage and job pages.
5. Preserve topical breadth through a dedicated content library instead of deleting long-tail content.

## Important note about content migration
This demo preserves **public structure, themes, and topics**, but it does **not** reproduce every original article body verbatim.
For a live production launch, the site owner or authorized team should export the original CMS content and migrate approved copy into these templates.

## Launch notes
- Replace `https://demo.findcelebrityjobs.com` with the final canonical domain.
- Keep old URLs where possible. If not possible, use the redirect map in `migration/redirect-map.csv`.
- Validate structured data in Google tools after deployment.
- Connect the demo forms to a CRM, ATS, or secure intake workflow.

## Files of note
- `index.html` — homepage
- `hire-staff/` — employer journey
- `jobs/` — job board + job detail pages
- `resources/content-library/` — preserved topic architecture
- `sitemap.xml` — starter XML sitemap
- `migration/redirect-map.csv` — redirect planning aid
