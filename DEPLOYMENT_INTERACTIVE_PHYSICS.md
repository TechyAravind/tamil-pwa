# Interactive Physics — Deployment Guide

Covers everything built across the UI/UX overhaul, KaTeX fixes, and the
Phase 1–3 "Start Building" work. Skip any SQL file you've already run in
a previous session — every file is idempotent, so re-running is harmless.

## 1. Install dependencies

```bash
npm install
```

(Adds `katex`, already in `package.json`.)

## 2. Run SQL in Supabase, in this exact order

```
physics_schema.sql                              -- base chapters/subtopics (if not already applied)
physics_seed.sql
physics_seed_ch2_ch3_subtopics.sql
physics_seed_ch3_real_toc.sql

physics_interactive_schema.sql                   -- lesson engine tables
physics_interactive_seed_ch3.sql                 -- original 6 Laws of Motion lessons

physics_interactive_schema_v2.sql                -- bilingual + video_url + diagram_key columns
physics_interactive_seed_ch3_v2.sql              -- Lesson 1 rewrite + new "Reference Frames" lesson

physics_interactive_katex_retrofit.sql           -- fixes plain-text formulas on old lessons

physics_interactive_schema_v3.sql                -- group_key, takeaway_fact, physics_formulas table
physics_interactive_phase1_content.sql           -- takeaway facts + formula sheet data
physics_interactive_presentation_retrofit.sql    -- bullet/equation formatting pass
physics_interactive_phase3_content.sql           -- "One Mark Questions" + "Book Back Problems" lessons
```

If you're unsure what's already applied, check in the Supabase SQL editor:

```sql
select column_name from information_schema.columns
where table_name = 'physics_ip_lessons' and column_name = 'group_key';
-- if this returns a row, schema_v3 is already applied

select count(*) from physics_ip_lessons where group_key = 'book_back';
-- if this returns 1, phase3_content is already applied
```

## 3. Build and deploy

```bash
npm run build
git add -A
git commit -m "Interactive Physics: Phase 1-3 (routing, bilingual content, formulas tab, one-mark/book-back sections, Manim scripts)"
git push
```

Vercel picks up the push automatically. No environment variable or
`vercel.json` changes were needed for any of this work.

## 4. Manim videos (optional, do this on your own machine)

The sandbox used to build this couldn't install Manim's system
dependencies (no root access). Full setup + render instructions are in
`manim_scripts/README.md`. Short version: `pip install manim`, then
`manim -pqh manim_scripts/fbd_scene.py FBDFlatGround` (and same for
`incline_scene.py`). Upload the resulting `.mp4` to YouTube, then:

```sql
update physics_ip_steps set video_url = 'https://www.youtube.com/embed/VIDEO_ID'
where id = '<step-id>';
```

The step ids for the two diagram-bearing steps are documented at the top
of each script's matching lesson content — search `diagram_key` for
`force_vs_noforce` (FBD, flat ground) in `physics_interactive_seed_ch3_v2.sql`
to find the right step, or add `video_url` to any new step you write.

## 5. What's in the Interactive Physics tab now

Eight original + new lessons, grouped under 7 Main Sub Topics (matches
the syllabus structure), plus two trailing sections:

- Introduction — Aristotle vs. Galileo
- Newton's Laws — Reference Frames; Three Rules
- Application of Newton's Laws — Force Diagram
- Lami's Theorem — Three Forces in Balance
- Law of Conservation of Linear Momentum — Collision
- Friction
- Dynamics of Circular Motion
- **1 Mark Questions** — 10 rapid MCQs spanning the whole chapter
- **Book Back Problems** — 6 fully-worked numerical problems

The Formulas tab pulls from the dedicated `physics_formulas` table (14
curated entries), grouped the same way.

## 6. Repeating this process for a future chapter

This is the reusable recipe from Phase 3, written for whoever tags the
next chapter (e.g. Work, Energy and Power):

1. **Get clean source text.** A real PDF text layer (`pdftotext file.pdf out.txt`)
   is far more reliable than OCR — check for one before falling back to
   `pdftoppm` + `tesseract`.
2. **Define the chapter's Main Sub Topics.** Usually the textbook's own
   numbered section headers (e.g. `4.1`, `4.2`, ...) map directly to
   `group_key` values — keep them short, lowercase, `snake_case`.
   Add them to `MAIN_SUB_TOPICS` in `src/utils/physicsGroups.js`.
3. **Write lessons per sub-topic**, each following the existing step
   pattern: `motivation` (hook) → 1-3 `explanation` steps → 1 `example`
   step with real numbers → 3-5 `question` steps. Always write both
   English and `_ta` Tamil columns; leave `_ta` off only for `null`
   fields.
4. **Tag every lesson** with `update physics_ip_lessons set group_key = '...' where id = '...'`
   — this is what makes the grouped Interactive Physics list and the
   Formulas page work automatically; no frontend changes needed.
5. **Mine worked examples** (`grep -n -i "^\s*EXA" chapter.txt` was the
   pattern that worked for Laws of Motion's OCR'd text — adjust for
   however the new chapter's text is spaced) for material to turn into
   `fill_blank` numerical questions with full step-by-step solutions in
   `explanation_text`.
6. **Add the two trailing sections** the same way `physics_interactive_phase3_content.sql`
   did: new lessons tagged `group_key = 'one_mark'` and `'book_back'`
   respectively — `PhysicsChapterInteractivePage.jsx`'s `EXTRA_SECTIONS`
   already renders any lesson with those keys as its own trailing
   section, for every chapter, automatically.
7. **Add formula rows** to `physics_formulas` (`chapter_id`, `group_key`,
   `formula_latex`, `description`/`description_ta`) — the Formulas tab
   picks these up per chapter with zero extra code.
8. **Validate before running:** count `$$` occurrences in your SQL file
   and confirm it's even (paired) — a stray unmatched `$$` is the most
   common authoring mistake. Never use `"..."` for a string with an
   apostrophe in Postgres (that's identifier syntax, not a string) —
   use `'...'` with a curly `'` instead of a straight `'`, or wrap the
   whole string in `$$...$$`.
9. **Build-verify** (`npm run build`) before committing — this catches
   any accidental JSX/route breakage even though most of this work is
   pure SQL content.
