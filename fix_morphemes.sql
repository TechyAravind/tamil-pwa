-- ============================================================
-- Morpheme Fix Script — 5 issues corrected
-- Run in Supabase → SQL Editor
-- ============================================================

DO $$
DECLARE
  v_page_id    uuid;
  v_line2_id   uuid;   -- ஒற்றியெடுத்த        (line 2)
  v_line3_id   uuid;   -- நெற்றிமண் அழகே       (line 3)
  v_line10_id  uuid;   -- பாடத்தான் வேண்டும்!   (line 10)
  v_line19_id  uuid;   -- விரல் முனையைத்...    (line 19)
  v_line20_id  uuid;   -- திசைகளின்...          (line 20)
  v_line21_id  uuid;   -- எழுகின்ற யுகத்தினோர் (line 21)
  v_netri_pos  int;
BEGIN
  -- ── Get page ─────────────────────────────────────────────────
  SELECT p.id INTO v_page_id
  FROM pages p JOIN topics t ON t.id = p.topic_id
  WHERE t.title ILIKE '%யுகத்தின்%'
    AND p.page_type = 'செய்யுள் பகுதி'
  LIMIT 1;

  IF v_page_id IS NULL THEN
    RAISE EXCEPTION 'யுகத்தின் பாடல் page not found';
  END IF;

  -- ── Get line IDs ─────────────────────────────────────────────
  SELECT id INTO v_line2_id  FROM poem_lines WHERE page_id = v_page_id AND line_number = 2;
  SELECT id INTO v_line3_id  FROM poem_lines WHERE page_id = v_page_id AND line_number = 3;
  SELECT id INTO v_line10_id FROM poem_lines WHERE page_id = v_page_id AND line_number = 10;
  SELECT id INTO v_line19_id FROM poem_lines WHERE page_id = v_page_id AND line_number = 19;
  SELECT id INTO v_line20_id FROM poem_lines WHERE page_id = v_page_id AND line_number = 20;
  SELECT id INTO v_line21_id FROM poem_lines WHERE page_id = v_page_id AND line_number = 21;

  -- ════════════════════════════════════════════════════════════
  -- FIX 1: Move நெற்றிமண் அழகே morphemes → Line 3
  --
  -- Old line 2 was "ஒற்றியெடுத்த நெற்றிமண் அழகே".
  -- We split it, but all morphemes stayed on line 2.
  -- Move everything from நெற்றி's position onward to line 3.
  -- ════════════════════════════════════════════════════════════

  SELECT MIN(position) INTO v_netri_pos
  FROM morphemes
  WHERE poem_line_id = v_line2_id AND display_form = 'நெற்றி';

  IF v_netri_pos IS NOT NULL THEN
    -- Move நெற்றி, மண், அழகே (and any separators among them) to line 3
    UPDATE morphemes
    SET poem_line_id = v_line3_id
    WHERE poem_line_id = v_line2_id
      AND position >= v_netri_pos;

    -- Remove any trailing separator left at the end of line 2
    DELETE FROM morphemes
    WHERE poem_line_id = v_line2_id
      AND is_separator = true
      AND position = (SELECT MAX(position) FROM morphemes WHERE poem_line_id = v_line2_id);

    RAISE NOTICE 'FIX 1 done — நெற்றிமண் அழகே moved to line 3';
  ELSE
    RAISE NOTICE 'FIX 1 skipped — நெற்றி not found on line 2 (already moved?)';
  END IF;

  -- ════════════════════════════════════════════════════════════
  -- FIX 2: Remove sandhi த் from விரல் முனையைத் தீயிலே தோய்த்து
  --
  -- The chip "த்" between ஐ and தீ is a word-joining ஒற்று —
  -- delete it. The த்+த்+உ at the end (தோய்த்து analysis) stays.
  -- ════════════════════════════════════════════════════════════

  DELETE FROM morphemes
  WHERE poem_line_id = v_line19_id
    AND display_form = 'த்'
    AND is_separator = false
    AND position > (
          SELECT MIN(position) FROM morphemes
          WHERE poem_line_id = v_line19_id AND display_form = 'ஐ')
    AND position < (
          SELECT MIN(position) FROM morphemes
          WHERE poem_line_id = v_line19_id AND display_form = 'தீ');

  RAISE NOTICE 'FIX 2 done — sandhi த் removed from விரல் line';

  -- ════════════════════════════════════════════════════════════
  -- FIX 3: Remove sandhi த் from பாடத்தான் (line 10)
  --
  -- Handles both storage forms:
  --   A) separate "த்" chip between "பாட" and "தான்"
  --   B) chip stored as "த்தான்" → rename to "தான்"
  --   C) chip stored as "த்தான்!" → rename to "தான்!"
  -- ════════════════════════════════════════════════════════════

  -- Case A — standalone "த்" chip after "பாட"
  DELETE FROM morphemes
  WHERE poem_line_id = v_line10_id
    AND display_form = 'த்'
    AND is_separator = false
    AND position > (
          SELECT MIN(position) FROM morphemes
          WHERE poem_line_id = v_line10_id AND display_form = 'பாட');

  -- Case B / C — rename "த்தான்" prefix
  UPDATE morphemes SET display_form = 'தான்'
  WHERE poem_line_id = v_line10_id AND display_form = 'த்தான்';

  UPDATE morphemes SET display_form = 'தான்!'
  WHERE poem_line_id = v_line10_id AND display_form = 'த்தான்!';

  RAISE NOTICE 'FIX 3 done — sandhi த் removed from பாடத்தான் line';

  -- ════════════════════════════════════════════════════════════
  -- FIX 4: Remove sandhi த் from எழுதத்தான் (line 20)
  --
  -- Same three cases as Fix 3, for "எழுத" + sandhi-த் + "தான்"
  -- ════════════════════════════════════════════════════════════

  -- Case A — standalone "த்" chip after "எழுத"
  DELETE FROM morphemes
  WHERE poem_line_id = v_line20_id
    AND display_form = 'த்'
    AND is_separator = false
    AND position > (
          SELECT MIN(position) FROM morphemes
          WHERE poem_line_id = v_line20_id AND display_form = 'எழுத');

  -- Case B — rename "த்தான்"
  UPDATE morphemes SET display_form = 'தான்'
  WHERE poem_line_id = v_line20_id AND display_form = 'த்தான்';

  RAISE NOTICE 'FIX 4 done — sandhi த் removed from எழுதத்தான் line';

  -- ════════════════════════════════════════════════════════════
  -- FIX 5: Add morphemes for line 21 — எழுகின்ற யுகத்தினோர் பாடலை.
  --
  -- These are shown as whole words (no sub-morpheme separators)
  -- ════════════════════════════════════════════════════════════

  -- Only insert if line 21 has no morphemes yet
  IF NOT EXISTS (SELECT 1 FROM morphemes WHERE poem_line_id = v_line21_id) THEN

    INSERT INTO morphemes
      (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    VALUES
      (v_line21_id, 10,
       'எழுகின்ற',
       'வளர்ந்து எழுகின்ற; ஒவ்வொரு தலைமுறையினரும் எழுகின்ற யுகத்தினோர் என அழைக்கப்படுகின்றனர்',
       'வினைச்சொல்', false, false),

      (v_line21_id, 20,
       'யுகத்தினோர்',
       'யுகம் + இன் + ஓர்; இக்காலத்தில் வாழ்கின்ற மக்கள்; நம் தலைமுறையினர்',
       'பெயர்ச்சொல்', false, false),

      (v_line21_id, 30,
       'பாடலை.',
       'பாடல் + ஐ (ஐந்தாம் வேற்றுமை உருபு); அந்தக் காலத்தினோரின் பாடலை எழுத வேண்டும் என்று கவிஞர் உணர்த்துகிறார்',
       'பெயர்ச்சொல்', false, false);

    RAISE NOTICE 'FIX 5 done — morphemes added for line 21';
  ELSE
    RAISE NOTICE 'FIX 5 skipped — line 21 already has morphemes';
  END IF;

END $$;

-- ── Verify: show final morphemes for affected lines ─────────────────
SELECT
  pl.line_number,
  pl.raw_text,
  m.position,
  m.display_form,
  m.is_separator
FROM poem_lines pl
JOIN morphemes m ON m.poem_line_id = pl.id
WHERE pl.page_id = (
  SELECT p.id FROM pages p JOIN topics t ON t.id = p.topic_id
  WHERE t.title ILIKE '%யுகத்தின்%' AND p.page_type = 'செய்யுள் பகுதி' LIMIT 1
)
AND pl.line_number IN (2, 3, 10, 19, 20, 21)
ORDER BY pl.line_number, m.position;
