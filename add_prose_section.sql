-- ============================================================
-- உரைநடை Section — Schema + Topics + Pages
-- Run in Supabase → SQL Editor
-- ============================================================
-- STEP 1 (run alone first — enum commit required):
--   ALTER TYPE lines only
-- STEP 2 (run separately after Step 1):
--   Everything else
-- ============================================================

-- ══════════════════════════════════════════════════════════════════════════════
-- ▶▶ STEP 1 — Run ONLY this block first, then click Run.
-- ══════════════════════════════════════════════════════════════════════════════
ALTER TYPE page_type ADD VALUE IF NOT EXISTS 'உரைநடைப் பகுதி';

-- ══════════════════════════════════════════════════════════════════════════════
-- ▶▶ STEP 2 — Select from here to the end and run separately.
-- ══════════════════════════════════════════════════════════════════════════════

-- ── Table: prose_paragraphs ───────────────────────────────────────────────────
-- Each row = one paragraph of the prose lesson.
-- raw_text stores the text WITH /hard word/ markers for அருஞ்சொற்பொருள் tab.
-- paragraph_meaning stores the explanation (added later) for பத்தியின் பொருள் tab.
CREATE TABLE IF NOT EXISTS prose_paragraphs (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id            uuid NOT NULL REFERENCES pages(id) ON DELETE CASCADE,
  paragraph_number   int  NOT NULL,
  raw_text           text NOT NULL,
  paragraph_meaning  text,          -- admin fills this later
  created_at         timestamptz DEFAULT now(),
  UNIQUE (page_id, paragraph_number)
);
CREATE INDEX IF NOT EXISTS idx_prose_paragraphs_page
  ON prose_paragraphs (page_id, paragraph_number);

-- ── Table: prose_hard_words ───────────────────────────────────────────────────
-- One row per hard word per page. word is matched by text when rendering chips.
CREATE TABLE IF NOT EXISTS prose_hard_words (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id      uuid NOT NULL REFERENCES pages(id) ON DELETE CASCADE,
  word         text NOT NULL,
  definition   text NOT NULL,
  order_index  int  NOT NULL DEFAULT 0,
  created_at   timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_prose_hard_words_page
  ON prose_hard_words (page_id, order_index);

-- ── Table: prose_summary ──────────────────────────────────────────────────────
-- AI-generated சுருக்க உரை — one row per summary paragraph.
CREATE TABLE IF NOT EXISTS prose_summary (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id      uuid NOT NULL REFERENCES pages(id) ON DELETE CASCADE,
  summary_text text NOT NULL,
  order_index  int  NOT NULL DEFAULT 0,
  created_at   timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_prose_summary_page
  ON prose_summary (page_id, order_index);

-- ── Row Level Security ────────────────────────────────────────────────────────
ALTER TABLE prose_paragraphs ENABLE ROW LEVEL SECURITY;
ALTER TABLE prose_hard_words ENABLE ROW LEVEL SECURITY;
ALTER TABLE prose_summary    ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['prose_paragraphs','prose_hard_words','prose_summary']
  LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = t AND policyname = t||'_read') THEN
      EXECUTE format('CREATE POLICY %I ON %I FOR SELECT TO anon, authenticated USING (true)', t||'_read', t);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = t AND policyname = t||'_write') THEN
      EXECUTE format('CREATE POLICY %I ON %I FOR ALL TO authenticated USING (true) WITH CHECK (true)', t||'_write', t);
    END IF;
  END LOOP;
END $$;

-- ── Create உரைநடை topics + pages ─────────────────────────────────────────────
DO $$
DECLARE
  v_section_id  uuid;
  v_topic_id    uuid;
BEGIN
  -- Get the உரை நடை section id
  SELECT id INTO v_section_id FROM sections WHERE name = 'உரை நடை' LIMIT 1;
  IF v_section_id IS NULL THEN
    RAISE EXCEPTION 'உரை நடை section not found. Ensure it exists in the sections table.';
  END IF;

  -- ── Topic 1: பேச்சுமொழியும் கவிதைமொழியும் ─────────────────────────────
  INSERT INTO topics (section_id, title, topic_type, order_index)
  VALUES (v_section_id, 'பேச்சுமொழியும் கவிதைமொழியும்', 'prose', 10)
  ON CONFLICT (section_id, title) DO NOTHING
  RETURNING id INTO v_topic_id;

  IF v_topic_id IS NOT NULL THEN
    INSERT INTO pages (topic_id, page_type) VALUES
      (v_topic_id, 'நுழையும் முன்'),
      (v_topic_id, 'உரைநடைப் பகுதி'),
      (v_topic_id, 'துணைக் குறிப்புகள்'),
      (v_topic_id, 'நூல் வெளி')
    ON CONFLICT (topic_id, page_type) DO NOTHING;
    RAISE NOTICE 'Created topic: பேச்சுமொழியும் கவிதைமொழியும்';
  END IF;

  -- ── Topic 2: இசைத்தமிழர் இருவர் ──────────────────────────────────────
  INSERT INTO topics (section_id, title, topic_type, order_index)
  VALUES (v_section_id, 'இசைத்தமிழர் இருவர்', 'prose', 20)
  ON CONFLICT (section_id, title) DO NOTHING
  RETURNING id INTO v_topic_id;

  IF v_topic_id IS NOT NULL THEN
    INSERT INTO pages (topic_id, page_type) VALUES
      (v_topic_id, 'நுழையும் முன்'),
      (v_topic_id, 'உரைநடைப் பகுதி'),
      (v_topic_id, 'துணைக் குறிப்புகள்'),
      (v_topic_id, 'நூல் வெளி')
    ON CONFLICT (topic_id, page_type) DO NOTHING;
    RAISE NOTICE 'Created topic: இசைத்தமிழர் இருவர்';
  END IF;

  -- ── Topic 3: இயற்கை வேளாண்மை ──────────────────────────────────────────
  INSERT INTO topics (section_id, title, topic_type, order_index)
  VALUES (v_section_id, 'இயற்கை வேளாண்மை', 'prose', 30)
  ON CONFLICT (section_id, title) DO NOTHING
  RETURNING id INTO v_topic_id;

  IF v_topic_id IS NOT NULL THEN
    INSERT INTO pages (topic_id, page_type) VALUES
      (v_topic_id, 'நுழையும் முன்'),
      (v_topic_id, 'உரைநடைப் பகுதி'),
      (v_topic_id, 'துணைக் குறிப்புகள்'),
      (v_topic_id, 'நூல் வெளி')
    ON CONFLICT (topic_id, page_type) DO NOTHING;
    RAISE NOTICE 'Created topic: இயற்கை வேளாண்மை';
  END IF;

  -- ── Topic 4: காற்றில் கலந்த பேரோசை ────────────────────────────────────
  INSERT INTO topics (section_id, title, topic_type, order_index)
  VALUES (v_section_id, 'காற்றில் கலந்த பேரோசை', 'prose', 40)
  ON CONFLICT (section_id, title) DO NOTHING
  RETURNING id INTO v_topic_id;

  IF v_topic_id IS NOT NULL THEN
    INSERT INTO pages (topic_id, page_type) VALUES
      (v_topic_id, 'நுழையும் முன்'),
      (v_topic_id, 'உரைநடைப் பகுதி'),
      (v_topic_id, 'துணைக் குறிப்புகள்'),
      (v_topic_id, 'நூல் வெளி')
    ON CONFLICT (topic_id, page_type) DO NOTHING;
    RAISE NOTICE 'Created topic: காற்றில் கலந்த பேரோசை';
  END IF;

END $$;

-- ── Verify ────────────────────────────────────────────────────────────────────
SELECT
  t.title     AS topic,
  s.name      AS section,
  p.page_type
FROM pages p
JOIN topics   t ON t.id = p.topic_id
JOIN sections s ON s.id = t.section_id
WHERE s.name = 'உரை நடை'
ORDER BY t.order_index, p.page_type;
