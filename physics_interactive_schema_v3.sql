-- ============================================================
-- Interactive Physics — Phase 1 Schema (v3)
-- Run AFTER physics_interactive_schema_v2.sql.
--
--   1. group_key on physics_ip_lessons -- which of the 7 Main Sub
--      Topics a lesson belongs to (used by the grouped Interactive
--      Physics list and the new Formulas page).
--   2. takeaway_fact / takeaway_fact_ta on physics_ip_questions --
--      a one-line "what this proves" sentence shown after a correct
--      answer.
--   3. physics_formulas -- a curated, chapter-wide formula sheet
--      (the primary content source for the new Formulas tab).
--
-- Idempotent: IF NOT EXISTS / on conflict do nothing throughout.
-- ============================================================

alter table physics_ip_lessons
  add column if not exists group_key text;

alter table physics_ip_questions
  add column if not exists takeaway_fact    text,
  add column if not exists takeaway_fact_ta text;

create table if not exists physics_formulas (
  id              uuid primary key default gen_random_uuid(),
  chapter_id      uuid references physics_chapters(id) on delete cascade,
  group_key       text not null,
  formula_latex   text not null,
  description     text not null,
  description_ta  text,
  order_index     int not null default 0,
  created_at      timestamptz default now()
);

alter table physics_formulas enable row level security;
drop policy if exists "public read physics_formulas" on physics_formulas;
create policy "public read physics_formulas" on physics_formulas for select using (true);
drop policy if exists "admin write physics_formulas" on physics_formulas;
create policy "admin write physics_formulas" on physics_formulas for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create index if not exists idx_physics_formulas_chapter on physics_formulas (chapter_id, group_key, order_index);

-- ------------------------------------------------------------
-- Tag every existing lesson with its Main Sub Topic group.
-- Keys: introduction, newtons_laws, application, lamis_theorem,
--       momentum, friction, circular_motion
-- ------------------------------------------------------------
update physics_ip_lessons set group_key = 'introduction'    where id = '77777777-7777-7777-7777-000000000001'; -- Aristotle vs Galileo
update physics_ip_lessons set group_key = 'newtons_laws'    where id = '77777777-7777-7777-7777-000000000008'; -- Reference Frames
update physics_ip_lessons set group_key = 'newtons_laws'    where id = '77777777-7777-7777-7777-000000000002'; -- Three Rules
update physics_ip_lessons set group_key = 'application'     where id = '77777777-7777-7777-7777-000000000003'; -- Force Diagram
update physics_ip_lessons set group_key = 'lamis_theorem'   where id = '77777777-7777-7777-7777-000000000004'; -- Three Forces in Balance
update physics_ip_lessons set group_key = 'momentum'        where id = '77777777-7777-7777-7777-000000000005'; -- Collision
update physics_ip_lessons set group_key = 'friction'        where id = '77777777-7777-7777-7777-000000000006'; -- Friction
update physics_ip_lessons set group_key = 'circular_motion' where id = '77777777-7777-7777-7777-000000000007'; -- Circular Motion
