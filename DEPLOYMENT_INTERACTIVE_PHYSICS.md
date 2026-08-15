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
physics_interactive_phase3_content.sql           -- original "One Mark Questions" + "Book Back Problems" (6) lessons

physics_interactive_schema_v4.sql                -- diagram_key column on physics_ip_questions
physics_interactive_phase4_content.sql           -- renames phase3's quiz to "Extra One Mark Questions" (last);
                                                  -- adds real "Book Back One Mark Questions" (15 textbook MCQs);
                                                  -- replaces Book Back Problems with all 15 real textbook problems

physics_interactive_ch4_content.sql              -- Chapter 4 (Work, Energy and Power), full build:
                                                  -- 7 Main Sub Topic lessons, Book Back One Mark Questions
                                                  -- (15 real MCQs), Book Back Problems (5 real problems),
                                                  -- Extra One Mark Questions (10 supplementary), Formulas tab
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
the syllabus structure), plus three trailing sections, in this order:

- Introduction — Aristotle vs. Galileo
- Newton's Laws — Reference Frames; Three Rules
- Application of Newton's Laws — Force Diagram
- Lami's Theorem — Three Forces in Balance
- Law of Conservation of Linear Momentum — Collision
- Friction
- Dynamics of Circular Motion
- **Book Back One Mark Questions** — the real 15 MCQs from the textbook's
  evaluation section, book's own answer key, each with a full explanation
  and a 2D diagram wherever the original question has one
- **Book Back Problems** — all 15 real numerical problems from the
  textbook's evaluation section, fully worked out
- **Extra One Mark Questions** — the original 10 supplementary MCQs
  (concept review, not from the book-back section) — kept, renamed, moved
  to the end so it doesn't get confused with the real book-back questions

The Formulas tab pulls from the dedicated `physics_formulas` table (14
curated entries), grouped the same way.

Question cards can now show a 2D diagram too, not just lesson steps —
`physics_ip_questions.diagram_key` (added in schema v4) is rendered by
`McqQuestion.jsx` and `FillBlankQuestion.jsx` right below the prompt, via
the same `DiagramSlot` component the lesson steps use. Five new diagrams
were added for this round: `block_against_wall`, `double_incline`,
`two_blocks_force`, `block_on_rough_incline`, `force_components`.

### Chapter 4 — Work, Energy and Power

Built the same way as Chapter 3, all from `physics_interactive_ch4_content.sql`.
Seven Main Sub Topic lessons, each with a bilingual hook, 2-3 explanation
steps, a worked example pulled straight from the textbook (numbers
independently re-derived and checked), and 3 practice questions:

- What Is Work, Really? (zero/positive/negative work, `force_components` diagram)
- Kinetic Energy, Potential Energy, and the Work-Energy Theorem (`spring_pe` diagram)
- Conservative Forces & the Law of Conservation of Energy
- Motion in a Vertical Circle (`vertical_circle` diagram; string vs. rigid-rod distinction)
- Power: The Rate of Doing Work (P = W/t and P = F·v; kWh-is-energy-not-power warning)
- Elastic & Inelastic Collisions (`elastic_collision` / `inelastic_collision` diagrams)
- Loss of Kinetic Energy & Coefficient of Restitution

Trailing sections, same structure as Chapter 3:

- **Book Back One Mark Questions** — all 15 real MCQs from the Unit 4
  evaluation section, verified against the official answer key
  (1c 2d 3a 4a 5b 6a 7c 8b 9b 10b 11c 12c 13c 14d 15b), each with a full
  worked explanation
- **Book Back Problems** — all 5 real numerical problems from the same
  evaluation section, fully worked (including the rod-vs-string vertical
  circle comparison and the g=9.8 bullet-pendulum problem)
- **Extra One Mark Questions** — 10 supplementary questions spanning all
  7 sub-topics, kept last

Four new diagrams were added for this chapter: `spring_pe`, `vertical_circle`,
`elastic_collision`, `inelastic_collision`. The Formulas tab picks up 14
new rows across the 7 `wep_*` group_keys automatically — no frontend
changes were needed for any of this, same as Chapter 3.

As with Chapter 3, every lesson step's `video_url` is left `null` — drop
in a Manim animation link later with a one-line
`update physics_ip_steps set video_url = '...' where id = '<id>'`.

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
