-- ============================================================
-- Physics (Classical Physics · 11th Standard) — Supabase Schema
-- Run this FIRST in the Supabase SQL Editor, before physics_seed.sql.
-- Safe to re-run: every statement is guarded with IF NOT EXISTS /
-- DROP POLICY IF EXISTS so re-running won't error on a partially
-- applied schema.
-- ============================================================

-- -------------------------
-- 1. GROUPS ("three broad general topics" shown under Content)
-- -------------------------
create table if not exists physics_groups (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  order_index int  not null default 0,
  created_at  timestamptz default now()
);

-- -------------------------
-- 2. CHAPTERS (Table of Contents entries within a group)
-- -------------------------
create table if not exists physics_chapters (
  id          uuid primary key default gen_random_uuid(),
  group_id    uuid references physics_groups(id) on delete cascade,
  title       text not null,
  order_index int  not null default 0,
  created_at  timestamptz default now()
);

-- -------------------------
-- 3. SUBTOPICS (Theory outline within a chapter — self-referencing
--    so "1. Science – Introduction" can have a child "1.1 Scientific
--    Method". parent_id is null for top-level rows.)
-- -------------------------
create table if not exists physics_subtopics (
  id          uuid primary key default gen_random_uuid(),
  chapter_id  uuid references physics_chapters(id) on delete cascade,
  parent_id   uuid references physics_subtopics(id) on delete cascade,
  title       text not null,
  order_index int  not null default 0,
  created_at  timestamptz default now()
);

-- -------------------------
-- 4. SUBTOPIC TEXT (Text tab — ordered paragraphs)
-- -------------------------
create table if not exists physics_subtopic_text (
  id           uuid primary key default gen_random_uuid(),
  subtopic_id  uuid references physics_subtopics(id) on delete cascade,
  content_text text not null,
  order_index  int  not null default 0,
  created_at   timestamptz default now()
);

-- -------------------------
-- 5. SLIDES (Presentation tab — carousel of image + caption)
-- -------------------------
create table if not exists physics_slides (
  id          uuid primary key default gen_random_uuid(),
  subtopic_id uuid references physics_subtopics(id) on delete cascade,
  image_url   text,
  caption     text,
  order_index int not null default 0,
  created_at  timestamptz default now()
);

-- -------------------------
-- 6. VIDEOS (Videos tab — Instagram-style post: caption + YouTube embed)
-- -------------------------
create table if not exists physics_videos (
  id          uuid primary key default gen_random_uuid(),
  subtopic_id uuid references physics_subtopics(id) on delete cascade,
  video_url   text not null,
  caption     text,
  order_index int not null default 0,
  created_at  timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

alter table physics_groups        enable row level security;
alter table physics_chapters       enable row level security;
alter table physics_subtopics      enable row level security;
alter table physics_subtopic_text  enable row level security;
alter table physics_slides         enable row level security;
alter table physics_videos         enable row level security;

-- Public SELECT (students can read everything)
drop policy if exists "public read physics_groups"       on physics_groups;
drop policy if exists "public read physics_chapters"      on physics_chapters;
drop policy if exists "public read physics_subtopics"     on physics_subtopics;
drop policy if exists "public read physics_subtopic_text" on physics_subtopic_text;
drop policy if exists "public read physics_slides"        on physics_slides;
drop policy if exists "public read physics_videos"        on physics_videos;

create policy "public read physics_groups"       on physics_groups       for select using (true);
create policy "public read physics_chapters"      on physics_chapters      for select using (true);
create policy "public read physics_subtopics"     on physics_subtopics     for select using (true);
create policy "public read physics_subtopic_text" on physics_subtopic_text for select using (true);
create policy "public read physics_slides"        on physics_slides        for select using (true);
create policy "public read physics_videos"        on physics_videos        for select using (true);

-- Admin-only write (INSERT / UPDATE / DELETE require authenticated user —
-- same rule the admin login already uses for the Tamil tables)
drop policy if exists "admin write physics_groups"       on physics_groups;
drop policy if exists "admin write physics_chapters"      on physics_chapters;
drop policy if exists "admin write physics_subtopics"     on physics_subtopics;
drop policy if exists "admin write physics_subtopic_text" on physics_subtopic_text;
drop policy if exists "admin write physics_slides"        on physics_slides;
drop policy if exists "admin write physics_videos"        on physics_videos;

create policy "admin write physics_groups"       on physics_groups       for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write physics_chapters"      on physics_chapters      for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write physics_subtopics"     on physics_subtopics     for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write physics_subtopic_text" on physics_subtopic_text for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write physics_slides"        on physics_slides        for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write physics_videos"        on physics_videos        for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ============================================================
-- INDEXES for faster lookups
-- ============================================================
create index if not exists idx_physics_chapters_group        on physics_chapters       (group_id);
create index if not exists idx_physics_subtopics_chapter      on physics_subtopics      (chapter_id);
create index if not exists idx_physics_subtopics_parent       on physics_subtopics      (parent_id);
create index if not exists idx_physics_subtopic_text_subtopic on physics_subtopic_text  (subtopic_id, order_index);
create index if not exists idx_physics_slides_subtopic        on physics_slides         (subtopic_id, order_index);
create index if not exists idx_physics_videos_subtopic        on physics_videos         (subtopic_id, order_index);
