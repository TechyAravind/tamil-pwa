-- ============================================================================
-- யுகத்தின் பாடல் — word_groups + morpheme splits, transcribed directly
-- from your instruction document (சொல் பொருள்.docx, handwritten boxes).
--
-- HOW THIS WORKS
-- ----------------------------------------------------------------------
-- This script assumes the poem's LINES already exist in `poem_lines` with
-- the exact `raw_text` shown in each block below (add them via Admin first
-- if you haven't). For each line it finds by exact text match, the script:
--   1. Deletes any morphemes/word_groups already attached to that line
--      (clean slate, so re-running this script is always safe/idempotent)
--   2. Re-inserts the morphemes in the split order from your doc
--   3. Creates a word_group + links morphemes for every multi-part word
--      (so it renders as a draggable combine-box on the site)
--   4. Leaves single, unsplit words as plain morphemes — they still get
--      an automatic box (per the auto-boxing fix already live), they just
--      won't have a drag-to-combine interaction since there's nothing to combine
--
-- WHAT YOU STILL NEED TO DO AFTER RUNNING THIS
-- ----------------------------------------------------------------------
-- - `word_meaning` / `combined_meaning` are filled with a placeholder
--   '[பொருள் சேர்க்கவும்]' — replace with the real Tamil meaning via
--   /admin/morphemes (the doc didn't give meanings for this poem, only splits)
-- - `grammatical_label` / `is_verb` are left blank — assign these via
--   /admin/morphemes and /admin/verbanalysis when you're ready for the
--   இலக்கணக்குறிப்பு tab (the doc didn't specify per-word grammar tags
--   for this particular poem either)
-- - ONE LINE COULD NOT BE READ: the line right after "நெல் எனச் செல்லுமோர்
--   பாடலை" (page featuring "...காயவிட்டு கொண்ட..[unclear]..") — the
--   handwriting there was too degraded for me to transcribe reliably.
--   Please type out that line + its split boxes and I'll add it in a
--   follow-up script rather than risk inserting wrong data.
-- - The sandhi rule below (காற்று + இல் → காற்றில்) is the only rule the
--   doc spelled out explicitly for this poem; add more via /admin/sandhirules
--   as you fill in the rest.
-- ============================================================================

DO $$
DECLARE
  v_line_id  uuid;
  v_group_id uuid;
BEGIN

  ----------------------------------------------------------------
  -- LINE 1: பல்லாயிரத்தாண்டு
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'பல்லாயிரத்தாண்டு' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — பல்லாயிரத்தாண்டு';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'பல்லாயிரத்தாண்டு', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'பல்',    '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'ஆயிரம்', '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'அத்து',  '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'ஆண்டு',  '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — பல்லாயிரத்தாண்டு';
  END IF;

  ----------------------------------------------------------------
  -- LINE 2: பாடத்தான் வேண்டும்
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'பாடத்தான் வேண்டும்' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — பாடத்தான் வேண்டும்';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'பாடத்தான்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'பாட', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'தான்', '[பொருள்]', false, v_group_id);

    -- வேண்டும் — standalone, doc explicitly says it is auxiliary (must/should),
    -- NOT a verb form, so no பகுபத உறுப்பிலக்கணம் needed for it.
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 3, 'வேண்டும்', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — பாடத்தான் வேண்டும்';
  END IF;

  ----------------------------------------------------------------
  -- LINE 3: காற்றிலேறி கனகடலை நெருப்பாற்றை
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'காற்றிலேறி கனகடலை நெருப்பாற்றை' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — காற்றிலேறி கனகடலை நெருப்பாற்றை';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'காற்றிலேறி', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'காற்று', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'இல்',    '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'ஏறி',    '[பொருள்]', false, v_group_id);

    -- sandhi rule for this group's first connector: காற்று + இல் -> காற்றில்
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter)
    VALUES (v_group_id, 0,
      'உயிரெழுத்தில் தொடங்கும் விகுதி வரும்போது, முன்னொட்டின் இறுதி உகரம் (று) மெய்யெழுத்தாக மாறும் — காற்று + இல் = காற்றில்',
      'காற்று + இல்', 'காற்றில்', NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'கனகடலை', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'கனை',  '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'கடல்', '[பொருள்]', false, v_group_id),
      (v_line_id, 6, 'ஐ',    '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 3, 'நெருப்பாற்றை', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 7, 'நெருப்பு', '[பொருள்]', false, v_group_id),
      (v_line_id, 8, 'ஆறு',     '[பொருள்]', false, v_group_id),
      (v_line_id, 9, 'ஐ',       '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — காற்றிலேறி கனகடலை நெருப்பாற்றை (+ 1 sandhi rule)';
  END IF;

  ----------------------------------------------------------------
  -- LINE 4: மலை முகடுகளைக் கடந்து
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'மலை முகடுகளைக் கடந்து' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — மலை முகடுகளைக் கடந்து';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    -- மலை — standalone whole word, no split shown in doc
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'மலை', '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'முகடுகளைக் கடந்து', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 2, 'முகடு',  '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'கள்',    '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'ஐ',      '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'கடந்து', '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — மலை முகடுகளைக் கடந்து';
  END IF;

  ----------------------------------------------------------------
  -- LINE 5: நெல் எனச் செல்லுமோர் பாடலை
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'நெல் எனச் செல்லுமோர் பாடலை' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — நெல் எனச் செல்லுமோர் பாடலை';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'நெல்', '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'எனச்செல்லுமோர்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 2, 'என்',  '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'செல்', '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'உம்',  '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'ஓர்',  '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 3, 'பாடலை', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'பாடல்', '[பொருள்]', false, v_group_id),
      (v_line_id, 7, 'ஐ',     '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — நெல் எனச் செல்லுமோர் பாடலை';
  END IF;

  -- ⚠️  LINE SKIPPED — could not reliably read the handwriting for the line
  -- right after this one (mentions "...காயவிட்டு கொண்ட..."). Please send me
  -- the typed text + splits and I'll add it in a follow-up script.

  ----------------------------------------------------------------
  -- LINE 7: காலத்தால் சாகாத நெல் களிம்புகளின்
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'காலத்தால் சாகாத நெல் களிம்புகளின்' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — காலத்தால் சாகாத நெல் களிம்புகளின்';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'காலத்தால்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'காலம்', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'அத்து', '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'ஆல்',   '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'சாகாத', '[பொருள்]', false, NULL),
      (v_line_id, 5, 'நெல்',   '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'களிம்புகளின்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'களிம்பு', '[பொருள்]', false, v_group_id),
      (v_line_id, 7, 'கள்',     '[பொருள்]', false, v_group_id),
      (v_line_id, 8, 'இன்',     '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — காலத்தால் சாகாத நெல் களிம்புகளின்';
  END IF;

  ----------------------------------------------------------------
  -- LINE 8: உறவெனும் தேய் படர்ந்தால் வேண்டும்
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'உறவெனும் தேய் படர்ந்தால் வேண்டும்' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — உறவெனும் தேய் படர்ந்தால் வேண்டும்';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'உறவெனும்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'உறவு', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'எனும்', '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'படர்ந்தால்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 3, 'தேய்',    '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'படர்',    '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'ந்தால்',  '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'வேண்டும்', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — உறவெனும் தேய் படர்ந்தால் வேண்டும்';
  END IF;

  ----------------------------------------------------------------
  -- LINE 9: றை தொடக்கி வளர்த்து எள்ளாமை
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'றை தொடக்கி வளர்த்து எள்ளாமை' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — றை தொடக்கி வளர்த்து எள்ளாமை';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'றை', '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'தொடக்கிவளர்த்து', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 2, 'தொடக்கி',  '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'வளர்த்து', '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'எள்ளாமை', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'என்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'ஆமை',  '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — றை தொடக்கி வளர்த்து எள்ளாமை';
  END IF;

  ----------------------------------------------------------------
  -- LINE 10: மண்ணிலே தீட்டித்தீட்டு எழுதுவித்த
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'மண்ணிலே தீட்டித்தீட்டு எழுதுவித்த' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — மண்ணிலே தீட்டித்தீட்டு எழுதுவித்த';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'மண்ணிலே', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'மண்', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'இல்', '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'ஏ',   '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'தீட்டித்தீட்டு', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'தீட்டு', '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'தீட்டு', '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'எழுதுவித்த', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — மண்ணிலே தீட்டித்தீட்டு எழுதுவித்த';
  END IF;

  ----------------------------------------------------------------
  -- LINE 11: விரல் முனையைத் தீவே தோய்த்து
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'விரல் முனையைத் தீவே தோய்த்து' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — விரல் முனையைத் தீவே தோய்த்து';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'விரல்முனையைத்தீவே', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'விரல்', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'முனை',  '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'ஐ',     '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'தீ',    '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'இல்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 6, 'ஏ',     '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 7, 'தோய்த்து', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — விரல் முனையைத் தீவே தோய்த்து';
  END IF;

  ----------------------------------------------------------------
  -- LINE 12: திரைகளில் கவலையாம் எழுதத்தான் வேண்டும்
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'திரைகளில் கவலையாம் எழுதத்தான் வேண்டும்' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — திரைகளில் கவலையாம் எழுதத்தான் வேண்டும்';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'திரைகளில்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'திரை', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'கள்',  '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'இல்',  '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'கவலையாம்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'கவலை', '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'ஆம்',  '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 3, 'எழுதத்தான்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'எழுது', '[பொருள்]', false, v_group_id),
      (v_line_id, 7, 'தான்',  '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 8, 'வேண்டும்', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — திரைகளில் கவலையாம் எழுதத்தான் வேண்டும்';
  END IF;

  ----------------------------------------------------------------
  -- LINE 13: எழுதின்று யுகத்தினோர் பாடலை
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'எழுதின்று யுகத்தினோர் பாடலை' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — எழுதின்று யுகத்தினோர் பாடலை';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'எழுதின்று', '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'யுகத்தினை', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 2, 'யுகம்', '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'அத்து', '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'இன்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'ஐ',     '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'பாடலை', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'பாடல்', '[பொருள்]', false, v_group_id),
      (v_line_id, 7, 'ஐ',     '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — எழுதின்று யுகத்தினோர் பாடலை';
  END IF;

END $$;

-- ── Verify: show every group just created for this poem's lines ──────────
SELECT pl.line_number, pl.raw_text, wg.position, wg.combined_display_form
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
ORDER BY pl.line_number, wg.position;
