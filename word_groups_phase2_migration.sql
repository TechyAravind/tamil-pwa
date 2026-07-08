-- ============================================================
-- Langfluencer — Phase 2 migration
--   (a) இலக்கணக்குறிப்பு tab: combined-word grammar classification
--   (b) இலக்கணம் tab: புணர்ச்சி (சந்தி) combination rules
--
-- Run this AFTER word_groups_migration.sql (Phase 1).
-- Run in Supabase → SQL Editor. Safe to re-run (guards included).
-- ============================================================

-- -------------------------
-- 1. word_groups — grammar fields for the combined word
--    (parallel to combined_meaning added in Phase 1)
-- -------------------------
alter table word_groups
  add column if not exists combined_grammatical_label pos_label,
  add column if not exists combined_is_verb boolean not null default false;

-- -------------------------
-- 2. verb_analysis — allow a breakdown to belong to a whole word_group
--    instead of only a single morpheme (used by the combined chip in the
--    இலக்கணக்குறிப்பு tab). Exactly one of morpheme_id / word_group_id
--    must be set.
-- -------------------------
alter table verb_analysis
  alter column morpheme_id drop not null;

alter table verb_analysis
  add column if not exists word_group_id uuid references word_groups(id) on delete cascade;

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'verb_analysis_one_target_chk'
  ) then
    alter table verb_analysis
      add constraint verb_analysis_one_target_chk
      check (
        (morpheme_id is not null and word_group_id is null) or
        (morpheme_id is null and word_group_id is not null)
      );
  end if;
end $$;

create unique index if not exists verb_analysis_word_group_uidx
  on verb_analysis (word_group_id) where word_group_id is not null;

-- -------------------------
-- 3. sandhi_rules (புணர்ச்சி விதிகள்)
--    One row = one junction point inside a word_group, i.e. the "+"
--    connector between unit #connector_index and unit #connector_index+1
--    (0-based, counting only the non-separator morphemes in the group).
-- -------------------------
create table if not exists sandhi_rules (
  id              uuid primary key default gen_random_uuid(),
  word_group_id   uuid references word_groups(id) on delete cascade,
  connector_index int  not null,          -- 0-based junction position within the group
  rule_text       text not null,          -- e.g. "உயிர் வரின் மிக்குறும் மெய்யீட்டு பேறே"
  before_form     text,                  -- e.g. "காற்று + இல்"
  after_form      text,                  -- e.g. "காற்றில்"
  changed_letter  text,                  -- e.g. "ற்" — highlighted in the combined form; null if no change
  created_at      timestamptz default now(),
  unique(word_group_id, connector_index)
);

alter table sandhi_rules enable row level security;

drop policy if exists "public read sandhi_rules" on sandhi_rules;
create policy "public read sandhi_rules" on sandhi_rules for select using (true);

drop policy if exists "admin write sandhi_rules" on sandhi_rules;
create policy "admin write sandhi_rules" on sandhi_rules
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create index if not exists idx_sandhi_rules_group on sandhi_rules (word_group_id, connector_index);
