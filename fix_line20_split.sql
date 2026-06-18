-- ============================================================
-- Quick fix: Split combined line 20 into two separate lines
-- Line 20: திசைகளின் சுவரெலாம் எழுதத்தான் வேண்டும்
-- Line 21: எழுகின்ற யுகத்தினோர் பாடலை.
-- Run in Supabase → SQL Editor
-- ============================================================

DO $$
DECLARE
  v_page_id uuid;
BEGIN
  SELECT p.id INTO v_page_id
  FROM pages p
  JOIN topics t ON t.id = p.topic_id
  WHERE t.title ILIKE '%யுகத்தின்%'
    AND p.page_type = 'செய்யுள் பகுதி'
  LIMIT 1;

  -- Fix line 20 text (remove the merged second half)
  UPDATE poem_lines
  SET raw_text = 'திசைகளின் சுவரெலாம் எழுதத்தான் வேண்டும்'
  WHERE page_id = v_page_id AND line_number = 20;

  -- Insert line 21 as a new separate line
  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_id, 21, 'எழுகின்ற யுகத்தினோர் பாடலை.');

  RAISE NOTICE 'Done — lines 20 and 21 are now separate.';
END $$;

-- Verify
SELECT line_number, raw_text
FROM poem_lines
WHERE page_id = (
  SELECT p.id FROM pages p JOIN topics t ON t.id = p.topic_id
  WHERE t.title ILIKE '%யுகத்தின்%' AND p.page_type = 'செய்யுள் பகுதி' LIMIT 1
)
ORDER BY line_number;
