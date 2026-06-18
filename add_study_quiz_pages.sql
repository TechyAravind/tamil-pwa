-- ============================================================
-- தேர்வுக்குப் படித்தல் & வினாடிவினா — Schema + Pages
-- Run in Supabase → SQL Editor
-- ============================================================
-- This script:
--   1. Adds two new page_type enum values
--   2. Creates the study_cards table (audio + video cards per page)
--   3. Adds the two new pages to ALL existing செய்யுள் topics
-- Safe to re-run (uses IF NOT EXISTS / ON CONFLICT guards)
-- ============================================================

-- ══════════════════════════════════════════════════════════════════════════════
-- ▶▶ STEP 1 — Run ONLY these two lines first, then click Run.
--             After they succeed, scroll down and run STEP 2.
-- ══════════════════════════════════════════════════════════════════════════════
ALTER TYPE page_type ADD VALUE IF NOT EXISTS 'தேர்வுக்குப் படித்தல்';
ALTER TYPE page_type ADD VALUE IF NOT EXISTS 'வினாடிவினா';

-- ══════════════════════════════════════════════════════════════════════════════
-- ▶▶ STEP 2 — Select from here to the end, then click Run.
--             (PostgreSQL requires enum values to be committed before use.)
-- ══════════════════════════════════════════════════════════════════════════════

-- ── 2. Create study_cards table ──────────────────────────────────────────────
-- Each row = one content card.
-- audio_url : direct link to an audio file (mp3, ogg, etc.)
-- video_url : YouTube watch / short / embed URL
-- Both can be NULL (placeholders shown in UI until content is added)
CREATE TABLE IF NOT EXISTS study_cards (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id       uuid NOT NULL REFERENCES pages(id) ON DELETE CASCADE,
  text_content  text NOT NULL,
  audio_url     text,
  video_url     text,
  order_index   int  NOT NULL DEFAULT 0,
  created_at    timestamptz DEFAULT now()
);

-- Index for fast lookup by page
CREATE INDEX IF NOT EXISTS idx_study_cards_page_id
  ON study_cards (page_id, order_index);

-- ── 3. Row Level Security ────────────────────────────────────────────────────
ALTER TABLE study_cards ENABLE ROW LEVEL SECURITY;

-- Anyone can read
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'study_cards' AND policyname = 'study_cards_read'
  ) THEN
    EXECUTE 'CREATE POLICY study_cards_read ON study_cards
               FOR SELECT TO anon, authenticated USING (true)';
  END IF;
END $$;

-- Only authenticated (admin) can write
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'study_cards' AND policyname = 'study_cards_write'
  ) THEN
    EXECUTE 'CREATE POLICY study_cards_write ON study_cards
               FOR ALL TO authenticated USING (true) WITH CHECK (true)';
  END IF;
END $$;

-- ── 4. Add new pages to ALL existing செய்யுள் topics ────────────────────────
DO $$
DECLARE
  v_topic_id uuid;
BEGIN
  FOR v_topic_id IN
    SELECT t.id
    FROM topics t
    JOIN sections s ON s.id = t.section_id
    WHERE s.name = 'செய்யுள்'
  LOOP
    -- தேர்வுக்குப் படித்தல்
    INSERT INTO pages (topic_id, page_type)
    VALUES (v_topic_id, 'தேர்வுக்குப் படித்தல்')
    ON CONFLICT (topic_id, page_type) DO NOTHING;

    -- வினாடிவினா
    INSERT INTO pages (topic_id, page_type)
    VALUES (v_topic_id, 'வினாடிவினா')
    ON CONFLICT (topic_id, page_type) DO NOTHING;

    RAISE NOTICE 'Added study+quiz pages for topic %', v_topic_id;
  END LOOP;
END $$;

-- ── Verify ───────────────────────────────────────────────────────────────────
SELECT
  t.title       AS topic,
  s.name        AS section,
  p.page_type
FROM pages p
JOIN topics t  ON t.id = p.topic_id
JOIN sections s ON s.id = t.section_id
WHERE p.page_type IN ('தேர்வுக்குப் படித்தல்', 'வினாடிவினா')
ORDER BY s.name, t.title, p.page_type;
