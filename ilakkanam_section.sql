-- ============================================================
-- இலக்கணம் Section — Schema & Seed
-- Run in Supabase → SQL Editor
-- ============================================================

-- ── 1. Add 'விளக்கம்' to page_type enum ──────────────────────────────────────
ALTER TYPE page_type ADD VALUE IF NOT EXISTS 'விளக்கம்';

-- ── 2. Add topic_type column to topics ───────────────────────────────────────
-- 'poem' (default) → shows TopicPage sub-pages
-- 'grammar'        → goes directly to ProsePage விளக்கம்
ALTER TABLE topics
  ADD COLUMN IF NOT EXISTS topic_type text NOT NULL DEFAULT 'poem';

-- ── 3. Add இலக்கணம் section ──────────────────────────────────────────────────
DO $$
DECLARE
  v_section_id uuid;
  v_topic_id   uuid;
  v_page_id    uuid;

  grammar_topics text[] := ARRAY[
    'தமிழ் எழுத்துகள்',
    'சொல் அமைப்புகள்',
    'வேர்ச்சொற்கள்',
    'சொல் உருவாக்கங்கள்',
    'சொல் வகைகள்',
    'பெயர்ச்சொல் வகைகள்',
    'வினை வடிவங்கள்',
    'இடைச்சொற்கள்',
    'உரிச்சொற்கள்',
    'சொற்றொடர் அமைப்புகள்',
    'சொல் சேர்க்கைகள் (புணர்ச்சி)',
    'வேற்றுமை இலக்கணம்',
    'பகுபத இலக்கணம்'
  ];
  t text;
  idx int := 0;
BEGIN

  -- Insert the section (skip if already exists)
  INSERT INTO sections (name, order_index)
  VALUES ('இலக்கணம்', 4)
  ON CONFLICT DO NOTHING
  RETURNING id INTO v_section_id;

  -- If it already existed, get its ID
  IF v_section_id IS NULL THEN
    SELECT id INTO v_section_id FROM sections WHERE name = 'இலக்கணம்';
  END IF;

  RAISE NOTICE 'இலக்கணம் section id = %', v_section_id;

  -- Insert each grammar topic + its விளக்கம் page
  FOREACH t IN ARRAY grammar_topics LOOP
    idx := idx + 1;

    -- Skip if topic already exists under this section
    IF EXISTS (
      SELECT 1 FROM topics WHERE section_id = v_section_id AND title = t
    ) THEN
      RAISE NOTICE 'Skipping existing topic: %', t;
      CONTINUE;
    END IF;

    INSERT INTO topics (section_id, title, order_index, topic_type)
    VALUES (v_section_id, t, idx * 10, 'grammar')
    RETURNING id INTO v_topic_id;

    -- Create the விளக்கம் page for this topic
    INSERT INTO pages (topic_id, page_type)
    VALUES (v_topic_id, 'விளக்கம்')
    RETURNING id INTO v_page_id;

    RAISE NOTICE 'Added topic: % (id=%, page=%)', t, v_topic_id, v_page_id;
  END LOOP;

  RAISE NOTICE 'Done — % grammar topics created under இலக்கணம்', array_length(grammar_topics, 1);
END $$;

-- ── Verify ───────────────────────────────────────────────────────────────────
SELECT
  s.name AS section,
  t.title AS topic,
  t.topic_type,
  p.page_type
FROM sections s
JOIN topics t ON t.section_id = s.id
JOIN pages p  ON p.topic_id   = t.id
WHERE s.name = 'இலக்கணம்'
ORDER BY t.order_index;
