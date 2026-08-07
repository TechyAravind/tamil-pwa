-- ============================================================
-- Interactive Physics — UI/UX Overhaul Migration (v2)
-- Run this AFTER physics_interactive_schema.sql and
-- physics_interactive_seed_ch3.sql (safe to re-run any time —
-- every change below is guarded with IF NOT EXISTS).
--
-- Adds, per the "Changes in UIUX" review:
--   1. Tamil sibling columns for every bilingual text field, plus a
--      `data_ta` jsonb mirror of `data` for question option/choice text.
--      Components fall back to the English field whenever the Tamil
--      one is null, so existing (untranslated) lessons keep working.
--   2. `video_url` on steps — a YouTube link for a Manim companion
--      video, rendered as an embed when present. Nullable/optional.
--   3. `diagram_key` on steps — a short string the frontend maps to a
--      built-in inline SVG diagram component (see
--      src/components/interactive/diagrams/DiagramSlot.jsx). Nullable.
--   4. `question_type` check constraint widened to allow 'mark_choices'
--      and 'graph_point' (framework-ready; only mark_choices is wired
--      up alongside mcq/fill_blank/match/rank for now).
-- ============================================================

alter table physics_ip_lessons
  add column if not exists title_ta        text,
  add column if not exists hook_summary_ta text;

alter table physics_ip_questions
  add column if not exists prompt_text_ta      text,
  add column if not exists data_ta              jsonb,
  add column if not exists explanation_text_ta text,
  add column if not exists common_mistake_ta   text;

alter table physics_ip_steps
  add column if not exists title_ta        text,
  add column if not exists body_text_ta    text,
  add column if not exists diagram_note_ta text,
  add column if not exists video_url       text,
  add column if not exists diagram_key     text;

-- Widen the question_type constraint to include 'mark_choices' (a
-- multi-select variant of mcq) without dropping existing rows.
alter table physics_ip_questions drop constraint if exists physics_ip_questions_question_type_check;
alter table physics_ip_questions add constraint physics_ip_questions_question_type_check
  check (question_type in ('mcq','fill_blank','match','rank','mark_choices','graph_point'));

-- data_ta shapes mirror `data` exactly, translating only the
-- human-readable strings (options/left/right/items text; indices and
-- correct-answer keys stay identical to `data` since they're positional):
--   mcq          { "options": [...] }
--   fill_blank   { "blanks": [ { "label": "...", "choices": [...] }, ... ] }
--   match        { "left": [...], "right": [...] }
--   rank         { "items": [...] }
--   mark_choices { "options": [...] }
