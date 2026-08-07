-- ============================================================================
-- என் அம்மை — word_groups + morpheme splits, transcribed directly from your
-- typed document (என் அம்மை.docx). Unlike the handwritten doc, this one has
-- typed text boxes, so I parsed the file's XML directly (position + text of
-- every box) rather than relying on OCR — much higher confidence than the
-- யுகத்தின் பாடல் script.
--
-- HOW THIS WORKS (same pattern as the யுகத்தின் பாடல் script)
-- ----------------------------------------------------------------------
-- Assumes the poem's 21 lines already exist in `poem_lines` with the exact
-- `raw_text` shown in each block below (add them via Admin first if you
-- haven't). For each line found by exact text match:
--   1. Deletes any morphemes/word_groups already attached to that line
--      (safe to re-run any time)
--   2. Re-inserts the morphemes in the split order from your doc
--   3. Creates a word_group + links morphemes for every multi-part word
--      (renders as a draggable combine-box)
--   4. Leaves single, unsplit words as plain morphemes (auto-boxed already,
--      no combine needed since there's nothing to combine)
--
-- ONE THING I HAD TO RESOLVE MYSELF
-- ----------------------------------------------------------------------
-- Line 13 "செல் எனச் செல்லுமோர் பாடலை." had a stray duplicate "மலை" text
-- box left over in the file (probably an old copy-paste that didn't get
-- deleted) — it doesn't fit anywhere in this line's text, so I ignored it.
-- The standalone "செல்" at the start of that line also has no separate
-- split box in your doc (only the "செல்" inside "எனச்செல்லுமோர்" has one),
-- so it's inserted as a plain unsplit morpheme. Let me know if that's wrong.
--
-- WHAT YOU STILL NEED TO DO AFTER RUNNING THIS
-- ----------------------------------------------------------------------
-- `word_meaning` / `combined_meaning` are placeholders — fill the real
-- Tamil meaning via /admin/morphemes. `grammatical_label` / `is_verb` are
-- left blank too — this doc only gave splits, not grammar tags.
-- ============================================================================

DO $$
DECLARE
  v_line_id  uuid;
  v_group_id uuid;
BEGIN

  ----------------------------------------------------------------
  -- LINE 1: என் அம்மை,
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'என் அம்மை,' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — என் அம்மை,';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'என் அம்மை', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'என்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'அம்மை', '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — என் அம்மை,';
  END IF;

  ----------------------------------------------------------------
  -- LINE 2: ஒற்றியெடுத்த
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'ஒற்றியெடுத்த' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — ஒற்றியெடுத்த';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'ஒற்றியெடுத்த', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'ஒற்றி',  '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'எடுத்த', '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — ஒற்றியெடுத்த';
  END IF;

  ----------------------------------------------------------------
  -- LINE 3: நெற்றிமண் அழகே
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'நெற்றிமண் அழகே' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — நெற்றிமண் அழகே';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'நெற்றிமண்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'நெற்றி', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'மண்',    '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'அழகே', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 3, 'அழகு', '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'ஏ',    '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — நெற்றிமண் அழகே';
  END IF;

  ----------------------------------------------------------------
  -- LINE 4: வழிவழி நினதடி தொழுதவர்,
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'வழிவழி நினதடி தொழுதவர்,' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — வழிவழி நினதடி தொழுதவர்,';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'வழிவழி', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'வழி', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'வழி', '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'நினதடி', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 3, 'நின்', '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'அது', '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'அடி', '[பொருள்]', false, v_group_id);

    -- தொழுதவர் — வினையாலணையும் பெயர் form, counted as one single word (no split)
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'தொழுதவர்', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — வழிவழி நினதடி தொழுதவர்,';
  END IF;

  ----------------------------------------------------------------
  -- LINE 5: உழுதவர், விதைத்தவர்,
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'உழுதவர், விதைத்தவர்,' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — உழுதவர், விதைத்தவர்,';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    -- both வினையாலணையும் பெயர் forms — single whole words, no split
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'உழுதவர்',    '[பொருள்]', false, NULL),
      (v_line_id, 2, 'விதைத்தவர்', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — உழுதவர், விதைத்தவர்,';
  END IF;

  ----------------------------------------------------------------
  -- LINE 6: வியர்த்தவர்க்கெல்லாம்
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'வியர்த்தவர்க்கெல்லாம்' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — வியர்த்தவர்க்கெல்லாம்';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'வியர்த்தவர்க்கெல்லாம்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'வியர்த்தவர்', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'கு',          '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'எல்லாம்',     '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — வியர்த்தவர்க்கெல்லாம்';
  END IF;

  ----------------------------------------------------------------
  -- LINE 7: நிறைமணி தந்தவளே,
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'நிறைமணி தந்தவளே,' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — நிறைமணி தந்தவளே,';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'நிறைமணி', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'நிறை', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'மணி',  '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'தந்தவளே', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 3, 'தந்தவள்', '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'ஏ',       '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — நிறைமணி தந்தவளே,';
  END IF;

  ----------------------------------------------------------------
  -- LINE 8: உனக்குப் பல்லாண்டு பல்லாண்டு;
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'உனக்குப் பல்லாண்டு பல்லாண்டு;' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — உனக்குப் பல்லாண்டு பல்லாண்டு;';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'உனக்குப்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'உன்', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'அ',   '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'கு',  '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'பல்லாண்டு', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'பல்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'ஆண்டு', '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 3, 'பல்லாண்டு', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'பல்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 7, 'ஆண்டு', '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — உனக்குப் பல்லாண்டு பல்லாண்டு;';
  END IF;

  ----------------------------------------------------------------
  -- LINE 9: பல்லாயிரத்தாண்டு.
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'பல்லாயிரத்தாண்டு.' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — பல்லாயிரத்தாண்டு.';
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

    RAISE NOTICE 'DONE — பல்லாயிரத்தாண்டு.';
  END IF;

  ----------------------------------------------------------------
  -- LINE 10: பாடத்தான் வேண்டும்
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'பாடத்தான் வேண்டும்' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — பாடத்தான் வேண்டும் (1st)';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'பாடத்தான்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'பாட', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'தான்', '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 3, 'வேண்டும்', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — பாடத்தான் வேண்டும் (1st)';
  END IF;

  ----------------------------------------------------------------
  -- LINE 11: காற்றிலேறி, கனைகடலை, நெருப்பாற்றை,
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'காற்றிலேறி, கனைகடலை, நெருப்பாற்றை,' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — காற்றிலேறி, கனைகடலை, நெருப்பாற்றை,';
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

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'கனைகடலை', '[பொருள் சேர்க்கவும்]')
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

    RAISE NOTICE 'DONE — காற்றிலேறி, கனைகடலை, நெருப்பாற்றை,';
  END IF;

  ----------------------------------------------------------------
  -- LINE 12: மலை முகடுகளைக் கடந்து
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'மலை முகடுகளைக் கடந்து' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — மலை முகடுகளைக் கடந்து';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

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
  -- LINE 13: செல் எனச் செல்லுமோர் பாடலை.
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'செல் எனச் செல்லுமோர் பாடலை.' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — செல் எனச் செல்லுமோர் பாடலை.';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    -- செல் — standalone, no split box given for this occurrence
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'செல்', '[பொருள்]', false, NULL);

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

    RAISE NOTICE 'DONE — செல் எனச் செல்லுமோர் பாடலை. (stray duplicate மலை box ignored)';
  END IF;

  ----------------------------------------------------------------
  -- LINE 14: கபாட புரங்களைக் காவு கொண்டபின்னும்
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'கபாட புரங்களைக் காவு கொண்டபின்னும்' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — கபாட புரங்களைக் காவு கொண்டபின்னும்';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'கபாடபுரங்கள்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'கபாடபுரம்', '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'கள்',       '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 3, 'காவு', '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'கொண்டபின்னும்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'கொண்ட', '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'பின்',  '[பொருள்]', false, v_group_id),
      (v_line_id, 6, 'உம்',   '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — கபாட புரங்களைக் காவு கொண்டபின்னும்';
  END IF;

  ----------------------------------------------------------------
  -- LINE 15: காலத்தால் சாகாத தொல் கனிமங்களின்
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'காலத்தால் சாகாத தொல் கனிமங்களின்' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — காலத்தால் சாகாத தொல் கனிமங்களின்';
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
      (v_line_id, 5, 'தொல்',   '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'கனிமங்களின்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'கனிமம்', '[பொருள்]', false, v_group_id),
      (v_line_id, 7, 'கள்',    '[பொருள்]', false, v_group_id),
      (v_line_id, 8, 'இன்',    '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — காலத்தால் சாகாத தொல் கனிமங்களின்';
  END IF;

  ----------------------------------------------------------------
  -- LINE 16: உரமெலாம் சேரப் பாடத்தான் வேண்டும்.
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'உரமெலாம் சேரப் பாடத்தான் வேண்டும்.' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — உரமெலாம் சேரப் பாடத்தான் வேண்டும்.';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'உரமெலாம்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'உரம்',  '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'எலாம்', '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 3, 'சேர', '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'பாடத்தான்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'பாட', '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'தான்', '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'வேண்டும்', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — உரமெலாம் சேரப் பாடத்தான் வேண்டும்.';
  END IF;

  ----------------------------------------------------------------
  -- LINE 17: ஏடு தொடக்கிவைத்து என்னம்மை
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'ஏடு தொடக்கிவைத்து என்னம்மை' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — ஏடு தொடக்கிவைத்து என்னம்மை';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'ஏடு', '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'தொடக்கிவைத்து', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 2, 'தொடக்கி', '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'வைத்து',  '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 3, 'என்னம்மை', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'என்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'அம்மை', '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — ஏடு தொடக்கிவைத்து என்னம்மை';
  END IF;

  ----------------------------------------------------------------
  -- LINE 18: மண்ணிலே தீட்டித் தீட்டி எழுதுவித்த
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'மண்ணிலே தீட்டித் தீட்டி எழுதுவித்த' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — மண்ணிலே தீட்டித் தீட்டி எழுதுவித்த';
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
    VALUES (v_line_id, 2, 'தீட்டித்தீட்டி', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 4, 'தீட்டி', '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'தீட்டி', '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'எழுதுவித்த', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — மண்ணிலே தீட்டித் தீட்டி எழுதுவித்த';
  END IF;

  ----------------------------------------------------------------
  -- LINE 19: விரல் முனையைத் தீயிலே தோய்த்து
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'விரல் முனையைத் தீயிலே தோய்த்து' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — விரல் முனையைத் தீயிலே தோய்த்து';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'விரல்முனையைத்தீயிலே', '[பொருள் சேர்க்கவும்]')
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

    RAISE NOTICE 'DONE — விரல் முனையைத் தீயிலே தோய்த்து';
  END IF;

  ----------------------------------------------------------------
  -- LINE 20: திசைகளின்சுவரெலாம் எழுதத்தான்வேண்டும்
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'திசைகளின்சுவரெலாம் எழுதத்தான்வேண்டும்' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — திசைகளின்சுவரெலாம் எழுதத்தான்வேண்டும்';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 1, 'திசைகளின்சுவரெலாம்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'திசை',  '[பொருள்]', false, v_group_id),
      (v_line_id, 2, 'கள்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'இன்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'சுவர்', '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'எலாம்', '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'எழுதத்தான்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'எழுத', '[பொருள்]', false, v_group_id),
      (v_line_id, 7, 'தான்',  '[பொருள்]', false, v_group_id);

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 8, 'வேண்டும்', '[பொருள்]', false, NULL);

    RAISE NOTICE 'DONE — திசைகளின்சுவரெலாம் எழுதத்தான்வேண்டும்';
  END IF;

  ----------------------------------------------------------------
  -- LINE 21: எழுகின்ற யுகத்தினோர் பாடலை.
  ----------------------------------------------------------------
  SELECT id INTO v_line_id FROM poem_lines WHERE raw_text = 'எழுகின்ற யுகத்தினோர் பாடலை.' LIMIT 1;
  IF v_line_id IS NULL THEN
    RAISE NOTICE 'SKIP (line not found) — எழுகின்ற யுகத்தினோர் பாடலை.';
  ELSE
    DELETE FROM morphemes WHERE poem_line_id = v_line_id;
    DELETE FROM word_groups WHERE poem_line_id = v_line_id;

    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 1, 'எழுகின்ற', '[பொருள்]', false, NULL);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 2, 'யுகத்தினோர்', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 2, 'யுகம்', '[பொருள்]', false, v_group_id),
      (v_line_id, 3, 'அத்து', '[பொருள்]', false, v_group_id),
      (v_line_id, 4, 'இன்',   '[பொருள்]', false, v_group_id),
      (v_line_id, 5, 'ஓர்',   '[பொருள்]', false, v_group_id);

    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 3, 'பாடலை', '[பொருள் சேர்க்கவும்]')
    RETURNING id INTO v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
      (v_line_id, 6, 'பாடல்', '[பொருள்]', false, v_group_id),
      (v_line_id, 7, 'ஐ',     '[பொருள்]', false, v_group_id);

    RAISE NOTICE 'DONE — எழுகின்ற யுகத்தினோர் பாடலை.';
  END IF;

END $$;

-- ── Verify: show every group just created for this poem's lines ──────────
SELECT pl.line_number, pl.raw_text, wg.position, wg.combined_display_form
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
ORDER BY pl.line_number, wg.position;
