-- ============================================================
-- STEP 2 of 3 — Tables + Topics + Pages
-- Run AFTER prose_step1_enum.sql succeeds.
-- Safe to re-run (uses IF NOT EXISTS / existence checks).
-- ============================================================

-- ── 1. New tables ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS prose_paragraphs (
  id                uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id           uuid        NOT NULL REFERENCES pages(id) ON DELETE CASCADE,
  paragraph_number  int         NOT NULL,
  raw_text          text        NOT NULL,
  paragraph_meaning text,
  created_at        timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS prose_hard_words (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id     uuid        NOT NULL REFERENCES pages(id) ON DELETE CASCADE,
  word        text        NOT NULL,
  definition  text        NOT NULL,
  order_index int         NOT NULL DEFAULT 0,
  created_at  timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS prose_summary (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id      uuid        NOT NULL REFERENCES pages(id) ON DELETE CASCADE,
  summary_text text        NOT NULL,
  order_index  int         NOT NULL DEFAULT 0,
  created_at   timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_prose_paragraphs_page ON prose_paragraphs (page_id, paragraph_number);
CREATE INDEX IF NOT EXISTS idx_prose_hard_words_page ON prose_hard_words (page_id, order_index);
CREATE INDEX IF NOT EXISTS idx_prose_summary_page    ON prose_summary    (page_id, order_index);

-- ── 2. Row Level Security ─────────────────────────────────────────────────────

ALTER TABLE prose_paragraphs ENABLE ROW LEVEL SECURITY;
ALTER TABLE prose_hard_words ENABLE ROW LEVEL SECURITY;
ALTER TABLE prose_summary    ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='prose_paragraphs' AND policyname='prose_paragraphs_read') THEN
    CREATE POLICY prose_paragraphs_read ON prose_paragraphs FOR SELECT TO anon, authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='prose_paragraphs' AND policyname='prose_paragraphs_write') THEN
    CREATE POLICY prose_paragraphs_write ON prose_paragraphs FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='prose_hard_words' AND policyname='prose_hard_words_read') THEN
    CREATE POLICY prose_hard_words_read ON prose_hard_words FOR SELECT TO anon, authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='prose_hard_words' AND policyname='prose_hard_words_write') THEN
    CREATE POLICY prose_hard_words_write ON prose_hard_words FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='prose_summary' AND policyname='prose_summary_read') THEN
    CREATE POLICY prose_summary_read ON prose_summary FOR SELECT TO anon, authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='prose_summary' AND policyname='prose_summary_write') THEN
    CREATE POLICY prose_summary_write ON prose_summary FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
END $$;

-- ── 3. Insert Topics + Pages ──────────────────────────────────────────────────
-- Uses SELECT-then-INSERT (no ON CONFLICT on topics — no unique constraint there).
-- Pages use ON CONFLICT which works fine (pages table has the constraint).

DO $$
DECLARE
  v_section_id uuid;
  v_topic_id   uuid;
BEGIN
  SELECT id INTO v_section_id FROM sections WHERE name = 'உரை நடை' LIMIT 1;
  IF v_section_id IS NULL THEN
    RAISE EXCEPTION 'Section "உரை நடை" not found. Check sections table.';
  END IF;

  -- ── Topic 1 ──────────────────────────────────────────────────────────────
  SELECT id INTO v_topic_id FROM topics
    WHERE section_id = v_section_id AND title = 'பேச்சுமொழியும் கவிதைமொழியும்';
  IF v_topic_id IS NULL THEN
    INSERT INTO topics (section_id, title, topic_type, order_index)
    VALUES (v_section_id, 'பேச்சுமொழியும் கவிதைமொழியும்', 'prose', 10)
    RETURNING id INTO v_topic_id;
  ELSE
    UPDATE topics SET order_index = 10 WHERE id = v_topic_id;
  END IF;
  INSERT INTO pages (topic_id, page_type) VALUES
    (v_topic_id, 'நுழையும் முன்'::page_type),
    (v_topic_id, 'உரைநடைப் பகுதி'::page_type),
    (v_topic_id, 'துணைக் குறிப்புகள்'::page_type),
    (v_topic_id, 'நூல் வெளி'::page_type)
  ON CONFLICT (topic_id, page_type) DO NOTHING;
  RAISE NOTICE 'Topic 1 done: பேச்சுமொழியும் கவிதைமொழியும் (id=%)', v_topic_id;

  -- ── Topic 2 ──────────────────────────────────────────────────────────────
  SELECT id INTO v_topic_id FROM topics
    WHERE section_id = v_section_id AND title = 'இசைத்தமிழர் இருவர்';
  IF v_topic_id IS NULL THEN
    INSERT INTO topics (section_id, title, topic_type, order_index)
    VALUES (v_section_id, 'இசைத்தமிழர் இருவர்', 'prose', 20)
    RETURNING id INTO v_topic_id;
  ELSE
    UPDATE topics SET order_index = 20 WHERE id = v_topic_id;
  END IF;
  INSERT INTO pages (topic_id, page_type) VALUES
    (v_topic_id, 'நுழையும் முன்'::page_type),
    (v_topic_id, 'உரைநடைப் பகுதி'::page_type),
    (v_topic_id, 'துணைக் குறிப்புகள்'::page_type),
    (v_topic_id, 'நூல் வெளி'::page_type)
  ON CONFLICT (topic_id, page_type) DO NOTHING;
  RAISE NOTICE 'Topic 2 done: இசைத்தமிழர் இருவர் (id=%)', v_topic_id;

  -- ── Topic 3 ──────────────────────────────────────────────────────────────
  SELECT id INTO v_topic_id FROM topics
    WHERE section_id = v_section_id AND title = 'இயற்கை வேளாண்மை';
  IF v_topic_id IS NULL THEN
    INSERT INTO topics (section_id, title, topic_type, order_index)
    VALUES (v_section_id, 'இயற்கை வேளாண்மை', 'prose', 30)
    RETURNING id INTO v_topic_id;
  ELSE
    UPDATE topics SET order_index = 30 WHERE id = v_topic_id;
  END IF;
  INSERT INTO pages (topic_id, page_type) VALUES
    (v_topic_id, 'நுழையும் முன்'::page_type),
    (v_topic_id, 'உரைநடைப் பகுதி'::page_type),
    (v_topic_id, 'துணைக் குறிப்புகள்'::page_type),
    (v_topic_id, 'நூல் வெளி'::page_type)
  ON CONFLICT (topic_id, page_type) DO NOTHING;
  RAISE NOTICE 'Topic 3 done: இயற்கை வேளாண்மை (id=%)', v_topic_id;

  -- ── Topic 4 ──────────────────────────────────────────────────────────────
  SELECT id INTO v_topic_id FROM topics
    WHERE section_id = v_section_id AND title = 'காற்றில் கலந்த பேரோசை';
  IF v_topic_id IS NULL THEN
    INSERT INTO topics (section_id, title, topic_type, order_index)
    VALUES (v_section_id, 'காற்றில் கலந்த பேரோசை', 'prose', 40)
    RETURNING id INTO v_topic_id;
  ELSE
    UPDATE topics SET order_index = 40 WHERE id = v_topic_id;
  END IF;
  INSERT INTO pages (topic_id, page_type) VALUES
    (v_topic_id, 'நுழையும் முன்'::page_type),
    (v_topic_id, 'உரைநடைப் பகுதி'::page_type),
    (v_topic_id, 'துணைக் குறிப்புகள்'::page_type),
    (v_topic_id, 'நூல் வெளி'::page_type)
  ON CONFLICT (topic_id, page_type) DO NOTHING;
  RAISE NOTICE 'Topic 4 done: காற்றில் கலந்த பேரோசை (id=%)', v_topic_id;

END $$;

-- ── 4. Verify ─────────────────────────────────────────────────────────────────
SELECT
  t.order_index,
  t.title        AS topic,
  p.page_type
FROM topics t
JOIN sections s ON s.id = t.section_id
JOIN pages    p ON p.topic_id = t.id
WHERE s.name = 'உரை நடை'
ORDER BY t.order_index, p.page_type;
