-- ============================================================================
-- Move all the NON-செய்யுள்-பகுதி pages/content from "யுகத்தின் பாடல்" onto
-- "என் அம்மை", then delete "யுகத்தின் பாடல்" entirely.
--
-- WHY: என் அம்மை was set up with only the new செய்யுள் பகுதி framework
-- (word_groups / drag-combine). Everything else — நுழையும் முன், இலக்கணப்
-- பகுதி, துணைக் குறிப்புகள், நூல் வெளி, தேர்வுக்குப் படித்தல், வினாடிவினா,
-- plus the இலக்கிய நயம் notes that live alongside the poem lines — still
-- only exists under the old யுகத்தின் பாடல் topic. This script copies all
-- of that over to என் அம்மை, then removes யுகத்தின் பாடல் for good.
--
-- WHAT IT DOES, STEP BY STEP
-- ----------------------------------------------------------------------
-- 1. For every page_type EXCEPT செய்யுள் பகுதி under யுகத்தின் பாடல்:
--      - creates the same page_type under என் அம்மை (skips if already there)
--      - copies prose_content rows to the new page
--      - copies study_cards rows to the new page (தேர்வுக்குப் படித்தல் /
--        வினாடிவினா)
-- 2. Copies literary_notes (இலக்கிய நயம்) from the OLD செய்யுள் பகுதி page
--    onto the NEW செய்யுள் பகுதி page that already exists under என் அம்மை
--    (does NOT touch poem_lines/morphemes/word_groups — those stay as the
--    new framework you already built)
-- 3. Deletes the யுகத்தின் பாடல் topic. Its pages, poem_lines, morphemes,
--    word_groups, sandhi_rules, prose_content, study_cards and
--    literary_notes all cascade-delete automatically with it.
--
-- Safe to re-run up to the DELETE step (ON CONFLICT guards prevent
-- duplicate pages). Once யுகத்தின் பாடல் is deleted, re-running does
-- nothing (source topic no longer found), which is also safe.
-- ============================================================================

DO $$
DECLARE
  v_old_topic_id uuid;
  v_new_topic_id uuid;

  v_old_page   RECORD;
  v_new_page_id uuid;

  v_old_poem_page_id uuid;
  v_new_poem_page_id uuid;
BEGIN

  ----------------------------------------------------------------
  -- 0. Locate both topics
  ----------------------------------------------------------------
  SELECT id INTO v_old_topic_id FROM topics WHERE title = 'யுகத்தின் பாடல்' LIMIT 1;
  SELECT id INTO v_new_topic_id FROM topics WHERE title = 'என் அம்மை' LIMIT 1;

  IF v_old_topic_id IS NULL THEN
    RAISE EXCEPTION 'யுகத்தின் பாடல் topic not found — nothing to migrate (maybe already deleted?).';
  END IF;
  IF v_new_topic_id IS NULL THEN
    RAISE EXCEPTION 'என் அம்மை topic not found — run en_ammai_full_setup.sql first.';
  END IF;

  RAISE NOTICE 'Old topic (யுகத்தின் பாடல்) = %, New topic (என் அம்மை) = %', v_old_topic_id, v_new_topic_id;

  ----------------------------------------------------------------
  -- 1. Copy every page EXCEPT செய்யுள் பகுதி, with its content
  ----------------------------------------------------------------
  FOR v_old_page IN
    SELECT id, page_type FROM pages
    WHERE topic_id = v_old_topic_id
      AND page_type <> 'செய்யுள் பகுதி'
  LOOP
    -- create (or reuse) the matching page under என் அம்மை
    INSERT INTO pages (topic_id, page_type)
    VALUES (v_new_topic_id, v_old_page.page_type)
    ON CONFLICT (topic_id, page_type) DO NOTHING;

    SELECT id INTO v_new_page_id FROM pages
    WHERE topic_id = v_new_topic_id AND page_type = v_old_page.page_type;

    -- copy prose_content (நுழையும் முன் / இலக்கணப் பகுதி / துணைக் குறிப்புகள் / நூல் வெளி)
    INSERT INTO prose_content (page_id, content_text, order_index)
    SELECT v_new_page_id, content_text, order_index
    FROM prose_content
    WHERE page_id = v_old_page.id;

    -- copy study_cards (தேர்வுக்குப் படித்தல் / வினாடிவினா)
    INSERT INTO study_cards (page_id, text_content, audio_url, video_url, order_index)
    SELECT v_new_page_id, text_content, audio_url, video_url, order_index
    FROM study_cards
    WHERE page_id = v_old_page.id;

    RAISE NOTICE 'Copied page % (old id=%) -> new id=%', v_old_page.page_type, v_old_page.id, v_new_page_id;
  END LOOP;

  ----------------------------------------------------------------
  -- 2. Copy literary_notes (இலக்கிய நயம்) from OLD செய்யுள் பகுதி page
  --    onto the NEW செய்யுள் பகுதி page (already exists, don't recreate)
  ----------------------------------------------------------------
  SELECT id INTO v_old_poem_page_id FROM pages
  WHERE topic_id = v_old_topic_id AND page_type = 'செய்யுள் பகுதி' LIMIT 1;

  SELECT id INTO v_new_poem_page_id FROM pages
  WHERE topic_id = v_new_topic_id AND page_type = 'செய்யுள் பகுதி' LIMIT 1;

  IF v_old_poem_page_id IS NOT NULL AND v_new_poem_page_id IS NOT NULL THEN
    INSERT INTO literary_notes (page_id, content_text, order_index)
    SELECT v_new_poem_page_id, content_text, order_index
    FROM literary_notes
    WHERE page_id = v_old_poem_page_id;

    RAISE NOTICE 'Copied இலக்கிய நயம் notes from old poem page (%) to new poem page (%)', v_old_poem_page_id, v_new_poem_page_id;
  ELSE
    RAISE NOTICE 'Skipped இலக்கிய நயம் copy — old or new செய்யுள் பகுதி page missing';
  END IF;

  ----------------------------------------------------------------
  -- 3. Delete the old topic (cascades: pages, poem_lines, morphemes,
  --    word_groups, sandhi_rules, prose_content, study_cards,
  --    literary_notes all go with it)
  ----------------------------------------------------------------
  DELETE FROM topics WHERE id = v_old_topic_id;
  RAISE NOTICE '✓ யுகத்தின் பாடல் topic deleted. Migration complete.';

END $$;

-- ── Verify: என் அம்மை now has all page types, யுகத்தின் பாடல் is gone ──────
SELECT t.title AS topic, p.page_type
FROM topics t
JOIN pages p ON p.topic_id = t.id
WHERE t.title IN ('என் அம்மை', 'யுகத்தின் பாடல்')
ORDER BY t.title, p.page_type;
