-- ============================================================
-- Fix: Consolidate தோய்த்து into one intact chip
--
-- Before: தோய் [chip] + [+] + த் [chip] + [+] + த் [chip] + [+] + உ [chip]
-- After:  தோய்த்து [chip] (verb analysis popup still works in grammar tab)
--
-- Run in Supabase → SQL Editor
-- ============================================================

DO $$
DECLARE
  v_page_id   uuid;
  v_line19_id uuid;
  v_verb_id   uuid;
  v_verb_pos  int;
BEGIN
  SELECT p.id INTO v_page_id
  FROM pages p JOIN topics t ON t.id = p.topic_id
  WHERE t.title ILIKE '%யுகத்தின்%'
    AND p.page_type = 'செய்யுள் பகுதி'
  LIMIT 1;

  SELECT id INTO v_line19_id
  FROM poem_lines WHERE page_id = v_page_id AND line_number = 19;

  -- Find the தோய் chip (the verb root stored as a chip)
  SELECT id, position INTO v_verb_id, v_verb_pos
  FROM morphemes
  WHERE poem_line_id = v_line19_id
    AND display_form = 'தோய்'
    AND is_separator = false
  LIMIT 1;

  IF v_verb_id IS NULL THEN
    RAISE NOTICE 'தோய் chip not found — may already be fixed as தோய்த்து';
    RETURN;
  END IF;

  -- Step 1: Rename the chip to the full intact verb form
  UPDATE morphemes
  SET
    display_form = 'தோய்த்து',
    word_meaning = 'தீயில் நனைத்து; தோய்த்து என்பது தொட்டு, நனைத்து என்று பொருள்படும். விரல் முனையை நெருப்பில் தோய்த்து எழுதுவது என்று கவிஞர் உணர்த்துகிறார்'
  WHERE id = v_verb_id;

  -- Step 2: Delete all chips that come AFTER தோய்'s position in this line
  -- (these are the leftover suffix chips: +, த், +, த், +, உ)
  -- தோய்த்து is the LAST word in this line, so nothing valid follows it.
  DELETE FROM morphemes
  WHERE poem_line_id = v_line19_id
    AND position > v_verb_pos;

  RAISE NOTICE 'Done — "தோய்" consolidated to "தோய்த்து". Suffix chips deleted.';
  RAISE NOTICE 'Verb analysis popup (grammar tab) remains intact for பகுபத உறுப்பிலக்கணம்.';

END $$;

-- ── Verify line 19 ────────────────────────────────────────────────────────
SELECT
  m.position,
  m.display_form,
  m.is_separator,
  m.is_verb,
  m.word_meaning
FROM morphemes m
WHERE m.poem_line_id = (
  SELECT id FROM poem_lines WHERE page_id = (
    SELECT p.id FROM pages p JOIN topics t ON t.id = p.topic_id
    WHERE t.title ILIKE '%யுகத்தின்%'
      AND p.page_type = 'செய்யுள் பகுதி'
    LIMIT 1
  ) AND line_number = 19
)
ORDER BY m.position;
