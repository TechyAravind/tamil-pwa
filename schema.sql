-- ============================================================
-- 11ஆம் தமிழ்ப் பாடம் — Supabase Schema
-- Run this in the Supabase SQL Editor before seeding.
-- ============================================================

-- -------------------------
-- 1. SECTIONS (செய்யுள், உரை நடை, துணைப்பாடம்)
-- -------------------------
create table if not exists sections (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  order_index int  not null default 0,
  created_at  timestamptz default now()
);

-- -------------------------
-- 2. TOPICS (poems / prose topics within a section)
-- -------------------------
create table if not exists topics (
  id          uuid primary key default gen_random_uuid(),
  section_id  uuid references sections(id) on delete cascade,
  title       text not null,
  order_index int  not null default 0,
  created_at  timestamptz default now()
);

-- -------------------------
-- 3. PAGES (sub-pages for each topic)
-- -------------------------
create type page_type as enum (
  'நுழையும் முன்',
  'செய்யுள் பகுதி',
  'இலக்கணப் பகுதி',
  'துணைக் குறிப்புகள்',
  'நூல் வெளி'
);

create table if not exists pages (
  id         uuid primary key default gen_random_uuid(),
  topic_id   uuid references topics(id) on delete cascade,
  page_type  page_type not null,
  created_at timestamptz default now(),
  unique(topic_id, page_type)
);

-- -------------------------
-- 4. PROSE CONTENT (for non-poem pages)
-- -------------------------
create table if not exists prose_content (
  id           uuid primary key default gen_random_uuid(),
  page_id      uuid references pages(id) on delete cascade,
  content_text text not null,
  order_index  int not null default 0,
  created_at   timestamptz default now()
);

-- -------------------------
-- 5. POEM LINES (lines of a poem in செய்யுள் பகுதி page)
-- -------------------------
create table if not exists poem_lines (
  id          uuid primary key default gen_random_uuid(),
  page_id     uuid references pages(id) on delete cascade,
  line_number int  not null,
  raw_text    text not null,
  created_at  timestamptz default now(),
  unique(page_id, line_number)
);

-- -------------------------
-- 6. GRAMMATICAL PART-OF-SPEECH ENUM
-- -------------------------
create type pos_label as enum (
  'பெயர்ச்சொல்',
  'வினைச்சொல்',
  'இடைச்சொல்',
  'உரிச்சொல்'
);

-- -------------------------
-- 7. MORPHEMES (syllable/morpheme units for each poem line)
-- -------------------------
create table if not exists morphemes (
  id                 uuid primary key default gen_random_uuid(),
  poem_line_id       uuid references poem_lines(id) on delete cascade,
  position           int  not null,           -- ordering within the line
  display_form       text not null,           -- e.g. "த்", "விரல்", "(ய்)"
  word_meaning       text,                    -- meaning shown in சொல் பொருள் popup
  grammatical_label  pos_label,               -- part-of-speech
  is_verb            boolean default false,   -- true → show பகுபத உறுப்பிலக்கணம்
  is_separator       boolean default false,   -- true for "+" display separators
  created_at         timestamptz default now()
);

-- -------------------------
-- 8. VERB ANALYSIS (பகுபத உறுப்பிலக்கணம்)
-- -------------------------
create table if not exists verb_analysis (
  id           uuid primary key default gen_random_uuid(),
  morpheme_id  uuid references morphemes(id) on delete cascade unique,
  -- jsonb array: [{"part": "தோய்", "label": "பகுதி"}, ...]
  analysis     jsonb not null default '[]',
  created_at   timestamptz default now()
);

-- -------------------------
-- 9. LITERARY NOTES (இலக்கிய நயம்)
-- -------------------------
create table if not exists literary_notes (
  id           uuid primary key default gen_random_uuid(),
  page_id      uuid references pages(id) on delete cascade,
  content_text text not null,
  order_index  int  not null default 0,
  created_at   timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

alter table sections       enable row level security;
alter table topics         enable row level security;
alter table pages          enable row level security;
alter table prose_content  enable row level security;
alter table poem_lines     enable row level security;
alter table morphemes      enable row level security;
alter table verb_analysis  enable row level security;
alter table literary_notes enable row level security;

-- Public SELECT (students can read everything)
create policy "public read sections"       on sections       for select using (true);
create policy "public read topics"         on topics         for select using (true);
create policy "public read pages"          on pages          for select using (true);
create policy "public read prose"          on prose_content  for select using (true);
create policy "public read poem_lines"     on poem_lines     for select using (true);
create policy "public read morphemes"      on morphemes      for select using (true);
create policy "public read verb_analysis"  on verb_analysis  for select using (true);
create policy "public read literary_notes" on literary_notes for select using (true);

-- Admin-only write (INSERT / UPDATE / DELETE require authenticated user)
create policy "admin write sections"       on sections       for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write topics"         on topics         for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write pages"          on pages          for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write prose"          on prose_content  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write poem_lines"     on poem_lines     for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write morphemes"      on morphemes      for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write verb_analysis"  on verb_analysis  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "admin write literary_notes" on literary_notes for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ============================================================
-- INDEXES for faster lookups
-- ============================================================
create index on topics         (section_id);
create index on pages          (topic_id);
create index on prose_content  (page_id);
create index on poem_lines     (page_id, line_number);
create index on morphemes      (poem_line_id, position);
create index on literary_notes (page_id);
