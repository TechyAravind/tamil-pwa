-- ============================================================
-- யுகத்தின் பாடல் — Poem Line Reorder
-- Fixes line order to match the updated PDF.
-- Run in Supabase → SQL Editor
-- ============================================================

DO $$
DECLARE
  v_page_id uuid;
BEGIN
  -- Find the செய்யுள் பகுதி page for யுகத்தின் பாடல்
  SELECT p.id INTO v_page_id
  FROM pages p
  JOIN topics t ON t.id = p.topic_id
  WHERE t.title ILIKE '%யுகத்தின்%'
    AND p.page_type = 'செய்யுள் பகுதி'
  LIMIT 1;

  IF v_page_id IS NULL THEN
    RAISE EXCEPTION 'Could not find யுகத்தின் பாடல் page. Check topic title.';
  END IF;

  -- ── STEP 1: Move all lines to temporary high numbers (×100) ───────────────
  -- This avoids unique-constraint conflicts while we reshuffle.
  UPDATE poem_lines
  SET line_number = line_number * 100
  WHERE page_id = v_page_id;

  -- ── STEP 2: Line 1 (என் அம்மை,) — unchanged ───────────────────────────────
  UPDATE poem_lines SET line_number = 1
  WHERE page_id = v_page_id AND line_number = 100;

  -- ── STEP 3: Split old Line 2 into two lines ────────────────────────────────
  -- Old line 2 was: "ஒற்றியெடுத்த நெற்றிமண் அழகே"
  -- New line 2:      "ஒற்றியெடுத்த"
  -- New line 3:      "நெற்றிமண் அழகே"  (inserted fresh, no morphemes yet)
  UPDATE poem_lines
  SET line_number = 2,
      raw_text    = 'ஒற்றியெடுத்த'
  WHERE page_id = v_page_id AND line_number = 200;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_id, 3, 'நெற்றிமண் அழகே');

  -- ── STEP 4: Shift old lines 3–12 up by one (→ new lines 4–13) ────────────
  -- Old L3  → New L4   வழிவழி நினதடி தொழுதவர்,
  UPDATE poem_lines SET line_number = 4  WHERE page_id = v_page_id AND line_number = 300;
  -- Old L4  → New L5   உழுதவர், விதைத்தவர்,
  UPDATE poem_lines SET line_number = 5  WHERE page_id = v_page_id AND line_number = 400;
  -- Old L5  → New L6   வியர்த்தவர்க்கெல்லாம்
  UPDATE poem_lines SET line_number = 6  WHERE page_id = v_page_id AND line_number = 500;
  -- Old L6  → New L7   நிறைமணி தந்தவளே,
  UPDATE poem_lines SET line_number = 7  WHERE page_id = v_page_id AND line_number = 600;
  -- Old L7  → New L8   உனக்குப் பல்லாண்டு பல்லாண்டு;
  UPDATE poem_lines SET line_number = 8  WHERE page_id = v_page_id AND line_number = 700;
  -- Old L8  → New L9   பல்லாயிரத்தாண்டு.
  UPDATE poem_lines SET line_number = 9  WHERE page_id = v_page_id AND line_number = 800;
  -- Old L9  → New L10  பாடத்தான் வேண்டும்!
  UPDATE poem_lines SET line_number = 10 WHERE page_id = v_page_id AND line_number = 900;
  -- Old L10 → New L11  காற்றிலேறி, கனைகடலை, நெருப்பாற்றை,
  UPDATE poem_lines SET line_number = 11 WHERE page_id = v_page_id AND line_number = 1000;
  -- Old L11 → New L12  மலை முகடுகளைக் கடந்து
  UPDATE poem_lines SET line_number = 12 WHERE page_id = v_page_id AND line_number = 1100;
  -- Old L12 → New L13  செல் எனச் செல்லுமோர் பாடலை.
  UPDATE poem_lines SET line_number = 13 WHERE page_id = v_page_id AND line_number = 1200;

  -- ── STEP 5: Reshuffle old lines 13–20 into correct PDF order ──────────────
  --
  -- PDF correct order:
  --   L14: கபாட புரங்களைக் காவு கொண்டபின்னும்   ← was old L15
  --   L15: காலத்தால் சாகாத தொல் கனிமங்களின்      ← was old L17
  --   L16: உரமெலாம் சேரப் பாடத்தான் வேண்டும்.   ← was old L19
  --   L17: ஏடு தொடக்கிவைத்து என்னம்மை           ← was old L13
  --   L18: மண்ணிலே தீட்டித் தீட்டி எழுதுவித்த  ← was old L14
  --   L19: விரல் முனையைத் தீயிலே தோய்த்து       ← was old L16
  --   L20: திசைகளின் சுவரெலாம் எழுதத்தான் வேண்டும்
  --        எழுகின்ற யுகத்தினோர் பாடலை.           ← combines old L18 + L20

  -- Old L13 (ஏடு)         → New L17
  UPDATE poem_lines SET line_number = 17 WHERE page_id = v_page_id AND line_number = 1300;
  -- Old L14 (மண்ணிலே)    → New L18
  UPDATE poem_lines SET line_number = 18 WHERE page_id = v_page_id AND line_number = 1400;
  -- Old L15 (கபாட)        → New L14
  UPDATE poem_lines SET line_number = 14 WHERE page_id = v_page_id AND line_number = 1500;
  -- Old L16 (விரல்)       → New L19
  UPDATE poem_lines SET line_number = 19 WHERE page_id = v_page_id AND line_number = 1600;
  -- Old L17 (காலத்தால்)  → New L15
  UPDATE poem_lines SET line_number = 15 WHERE page_id = v_page_id AND line_number = 1700;
  -- Old L18 (திசைகளின்) → New L20
  UPDATE poem_lines SET line_number = 20
  WHERE page_id = v_page_id AND line_number = 1800;
  -- Old L19 (உரமெலாம்)  → New L16
  UPDATE poem_lines SET line_number = 16 WHERE page_id = v_page_id AND line_number = 1900;
  -- Old L20 (எழுகின்ற)  → New L21 (stays as a separate line)
  UPDATE poem_lines SET line_number = 21 WHERE page_id = v_page_id AND line_number = 2000;

  RAISE NOTICE 'Reorder complete for page_id = %', v_page_id;
END $$;

-- ── Verify result ─────────────────────────────────────────────────────────────
SELECT line_number, raw_text
FROM poem_lines
WHERE page_id = (
  SELECT p.id FROM pages p
  JOIN topics t ON t.id = p.topic_id
  WHERE t.title ILIKE '%யுகத்தின்%'
    AND p.page_type = 'செய்யுள் பகுதி'
  LIMIT 1
)
ORDER BY line_number;
