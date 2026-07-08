-- ============================================================
-- DEMO seed: word_groups for a few lines so you can see the
-- box + drag-to-combine interaction working immediately, without
-- going through the Admin panel by hand first.
--
-- IMPORTANT: Edit v_topic_match below to match your poem's topic
-- title (e.g. '%பல்லாண்டு%'). This script is defensive — every step
-- checks whether the expected morphemes actually exist before
-- touching anything, and RAISEs a NOTICE either way, so it is safe
-- to run even if some of the guessed morphemes/positions don't
-- match your real data (it will just skip that group).
--
-- Run in Supabase → SQL Editor, AFTER both migration files.
-- ============================================================

DO $$
DECLARE
  v_topic_match text := '%பல்லாண்டு%';  -- <-- change this if your topic title differs
  v_page_id     uuid;
  v_line_id     uuid;
  v_group_id    uuid;
BEGIN
  SELECT p.id INTO v_page_id
  FROM pages p JOIN topics t ON t.id = p.topic_id
  WHERE t.title ILIKE v_topic_match
    AND p.page_type = 'செய்யுள் பகுதி'
  LIMIT 1;

  IF v_page_id IS NULL THEN
    RAISE EXCEPTION 'No page found for topic matching %. Edit v_topic_match at the top of this script.', v_topic_match;
  END IF;

  -- ══════════════════════════════════════════════
  -- GROUP 1: ஒற்றி + எடுத்த  →  ஒற்றியெடுத்த
  -- ══════════════════════════════════════════════
  SELECT poem_line_id INTO v_line_id
  FROM morphemes WHERE display_form = 'ஒற்றி' AND poem_line_id IN (
    SELECT id FROM poem_lines WHERE page_id = v_page_id
  ) LIMIT 1;

  IF v_line_id IS NOT NULL AND EXISTS (
    SELECT 1 FROM morphemes WHERE poem_line_id = v_line_id AND display_form = 'எடுத்த'
  ) THEN
    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'ஒற்றியெடுத்த', 'ஒற்றி எடுத்து பொறித்த / ஒற்றை நிலையாகப் பதித்த')
    RETURNING id INTO v_group_id;

    UPDATE morphemes SET word_group_id = v_group_id
    WHERE poem_line_id = v_line_id AND display_form IN ('ஒற்றி', 'எடுத்த');

    RAISE NOTICE 'GROUP 1 done — ஒற்றி + எடுத்த';
  ELSE
    RAISE NOTICE 'GROUP 1 skipped — ஒற்றி/எடுத்த not found';
  END IF;

  -- ══════════════════════════════════════════════
  -- GROUP 2: நெற்றி + மண்  →  நெற்றிமண்
  -- ══════════════════════════════════════════════
  SELECT poem_line_id INTO v_line_id
  FROM morphemes WHERE display_form = 'நெற்றி' AND poem_line_id IN (
    SELECT id FROM poem_lines WHERE page_id = v_page_id
  ) LIMIT 1;

  IF v_line_id IS NOT NULL AND EXISTS (
    SELECT 1 FROM morphemes WHERE poem_line_id = v_line_id AND display_form = 'மண்'
  ) THEN
    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'நெற்றிமண்', 'நெற்றியில் அணியும் திருமண் / நாமம்')
    RETURNING id INTO v_group_id;

    UPDATE morphemes SET word_group_id = v_group_id
    WHERE poem_line_id = v_line_id AND display_form IN ('நெற்றி', 'மண்');

    RAISE NOTICE 'GROUP 2 done — நெற்றி + மண்';
  ELSE
    RAISE NOTICE 'GROUP 2 skipped — நெற்றி/மண் not found';
  END IF;

  -- ══════════════════════════════════════════════
  -- GROUP 3: அழகு + ஏ  →  அழகே   (only if already split this way)
  -- ══════════════════════════════════════════════
  IF v_line_id IS NOT NULL AND EXISTS (
    SELECT 1 FROM morphemes WHERE poem_line_id = v_line_id AND display_form = 'அழகு'
  ) AND EXISTS (
    SELECT 1 FROM morphemes WHERE poem_line_id = v_line_id AND display_form = 'ஏ'
  ) THEN
    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'அழகே', 'அழகு + ஏ (சுட்டு/வலியுறுத்தும் இடைச்சொல்) — அழகு நிறைந்தவளே')
    RETURNING id INTO v_group_id;

    UPDATE morphemes SET word_group_id = v_group_id
    WHERE poem_line_id = v_line_id AND display_form IN ('அழகு', 'ஏ');

    RAISE NOTICE 'GROUP 3 done — அழகு + ஏ';
  ELSE
    RAISE NOTICE 'GROUP 3 skipped — அழகு/ஏ not found as separate morphemes (may already be one chip "அழகே")';
  END IF;

  -- ══════════════════════════════════════════════
  -- GROUP 4: என் + அம்மை  →  என் அம்மை   (two separate one-word boxes)
  -- ══════════════════════════════════════════════
  SELECT poem_line_id INTO v_line_id
  FROM morphemes WHERE display_form = 'அம்மை' AND poem_line_id IN (
    SELECT id FROM poem_lines WHERE page_id = v_page_id
  ) LIMIT 1;

  IF v_line_id IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM morphemes WHERE poem_line_id = v_line_id AND display_form = 'என்') THEN
      INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
      VALUES (v_line_id, 1, 'என்', 'எனது (ஒருமை உடைமைப் பெயரெச்சம்)')
      RETURNING id INTO v_group_id;
      UPDATE morphemes SET word_group_id = v_group_id
      WHERE poem_line_id = v_line_id AND display_form = 'என்';
    END IF;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'அம்மை', 'தாய், அன்னை')
    RETURNING id INTO v_group_id;
    UPDATE morphemes SET word_group_id = v_group_id
    WHERE poem_line_id = v_line_id AND display_form = 'அம்மை';

    RAISE NOTICE 'GROUP 4 done — என் / அம்மை';
  ELSE
    RAISE NOTICE 'GROUP 4 skipped — அம்மை not found';
  END IF;

END $$;

-- ── Verify: show the groups just created ────────────────────────────
SELECT pl.line_number, pl.raw_text, wg.position, wg.combined_display_form, wg.combined_meaning
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
ORDER BY pl.line_number, wg.position;
