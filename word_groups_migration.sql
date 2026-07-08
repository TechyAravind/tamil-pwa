-- ============================================================
-- Langfluencer — Phase 1 (சொல் பொருள் tab) migration
-- Adds "word group" concept: clubs the individual morpheme
-- chips that make up one சீர்/word inside a shared box, and
-- stores the combined word's own meaning (separate from the
-- meaning of each individual morpheme).
--
-- Run in Supabase → SQL Editor. Safe to re-run (guards included).
-- ============================================================

-- -------------------------
-- 1. WORD GROUPS
--    One row = one box container = one சீர்/word made of 1+ morphemes.
-- -------------------------
create table if not exists word_groups (
  id                    uuid primary key default gen_random_uuid(),
  poem_line_id          uuid references poem_lines(id) on delete cascade,
  position              int  not null,           -- ordering of boxes within the line
  combined_display_form text not null,           -- e.g. "பல்லாண்டு" — the whole word, unsplit
  combined_meaning      text,                    -- meaning shown once fully combined
  created_at            timestamptz default now(),
  unique(poem_line_id, position)
);

-- -------------------------
-- 2. Link morphemes to their word group
--    NULL = not yet grouped (renders with the old flat/legacy layout).
-- -------------------------
alter table morphemes
  add column if not exists word_group_id uuid references word_groups(id) on delete set null;

-- -------------------------
-- 3. RLS
-- -------------------------
alter table word_groups enable row level security;

drop policy if exists "public read word_groups" on word_groups;
create policy "public read word_groups" on word_groups for select using (true);

drop policy if exists "admin write word_groups" on word_groups;
create policy "admin write word_groups" on word_groups
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- -------------------------
-- 4. Indexes
-- -------------------------
create index if not exists idx_word_groups_line     on word_groups (poem_line_id, position);
create index if not exists idx_morphemes_word_group  on morphemes   (word_group_id);
