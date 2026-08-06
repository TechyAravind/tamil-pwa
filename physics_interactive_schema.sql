-- ============================================================
-- Interactive Physics — Lesson Engine Schema
-- Run this FIRST (after the earlier physics_schema.sql), before
-- physics_interactive_seed_ch3.sql.
--
-- A "lesson" belongs to a chapter and appears in that chapter's
-- Interactive Physics tab. Each lesson is a short LINEAR sequence
-- of "steps" (motivation -> explanation -> example -> question,
-- question, question...) navigated with a stepper UI. Steps of
-- type 'question' point at a row in physics_ip_questions, whose
-- `data` jsonb shape depends on question_type:
--
--   mcq         { "options": [...4 strings...], "correct_index": 0 }
--   fill_blank  { "blanks": [ { "label": "...", "type": "dropdown"|"number",
--                                "choices": [...] (dropdown only), "correct": ... }, ... ] }
--   match       { "left": [...], "right": [...], "correct_pairs": [[0,2],[1,0],...] }
--   rank        { "items": [...], "correct_order": [2,0,1,...] }  -- greatest -> smallest
--
-- Safe to re-run: guarded with IF NOT EXISTS / DROP POLICY IF EXISTS.
-- ============================================================

create table if not exists physics_ip_lessons (
  id           uuid primary key default gen_random_uuid(),
  chapter_id   uuid references physics_chapters(id) on delete cascade,
  title        text not null,
  hook_summary text,
  order_index  int not null default 0,
  created_at   timestamptz default now()
);

create table if not exists physics_ip_questions (
  id               uuid primary key default gen_random_uuid(),
  question_type    text not null check (question_type in ('mcq','fill_blank','match','rank','graph_point')),
  prompt_text      text not null,
  data             jsonb not null,
  explanation_text text,
  common_mistake   text,
  created_at       timestamptz default now()
);

create table if not exists physics_ip_steps (
  id           uuid primary key default gen_random_uuid(),
  lesson_id    uuid references physics_ip_lessons(id) on delete cascade,
  step_type    text not null check (step_type in ('motivation','explanation','example','question')),
  title        text,
  body_text    text,
  diagram_note text,
  question_id  uuid references physics_ip_questions(id) on delete set null,
  order_index  int not null default 0,
  created_at   timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
alter table physics_ip_lessons   enable row level security;
alter table physics_ip_questions enable row level security;
alter table physics_ip_steps     enable row level security;

drop policy if exists "public read physics_ip_lessons"   on physics_ip_lessons;
drop policy if exists "public read physics_ip_questions" on physics_ip_questions;
drop policy if exists "public read physics_ip_steps"     on physics_ip_steps;

create policy "public read physics_ip_lessons"   on physics_ip_lessons   for select using (true);
create policy "public read physics_ip_questions" on physics_ip_questions for select using (true);
create policy "public read physics_ip_steps"     on physics_ip_steps     for select using (true);

drop policy if exists "admin write physics_ip_lessons"   on physics_ip_lessons;
drop policy if exists "admin write physics_ip_questions" on physics_ip_questions;
drop policy if exists "admin write physics_ip_steps"     on physics_ip_steps;

create policy "admin write physics_ip_lessons"   on physics_ip_lessons   for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write physics_ip_questions" on physics_ip_questions for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write physics_ip_steps"     on physics_ip_steps     for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ============================================================
-- INDEXES
-- ============================================================
create index if not exists idx_physics_ip_lessons_chapter on physics_ip_lessons (chapter_id, order_index);
create index if not exists idx_physics_ip_steps_lesson     on physics_ip_steps  (lesson_id, order_index);
create index if not exists idx_physics_ip_steps_question   on physics_ip_steps  (question_id);
