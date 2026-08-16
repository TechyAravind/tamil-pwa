-- ============================================================================
-- மனோன்மணீயம் — batch fix 3
--   L28 நாங்கூழ்ப்புழு (missing ப்), L29 உணர்வேன் x2 (only one copy ever got
--   its rules — SELECT with no position filter grabbed the same row twice),
--   L32 நன்மண்ணாக்குவை (ஐ not வை), L37 ஒளிக்குவை (letter-by-letter split)
--   + வாயுமோர்/உருண்டையால் meanings, L38 உழு+ஆய்+ஏல், L42 யார்க்குள,
--   L44 நடத்துதி (letter-by-letter split)
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_poem_page_id uuid;
  v_l uuid;
  v_group_id uuid;
  g1 uuid; g2 uuid; g3 uuid; g4 uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  ------------------------------------------------------------------
  -- LINE 28: நாங்கூழ்புழு -> நாங்கூழ்ப்புழு (raw chip was missing ப்)
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 28;
  UPDATE morphemes SET display_form = 'நாங்கூழ்ப்புழு'
  WHERE poem_line_id = v_l AND position = 4 AND display_form = 'நாங்கூழ்புழு';

  ------------------------------------------------------------------
  -- LINE 29: உணர்வேன்! உணர்வேன்! — TWO separate boxes at position 4 and 7.
  -- Fix by exact position so both get their rules (earlier attempt matched
  -- by text alone and both inserts silently landed on the same one row).
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 29;

  SELECT id INTO g1 FROM word_groups WHERE poem_line_id = v_l AND position = 4;
  IF g1 IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line29 position4 (உணர்வேன் #1)';
  ELSE
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g1, 0, 'சந்தி மெய் வ் வரும் (இன்னும் முழுச் சொல் இல்லை)', 'உணர் + வ்', 'உணர்வ்', NULL),
      (g1, 1, 'உணர்வேன் = நான் உணர்வேன்; I shall realise', 'உணர்வ் + ஏன்', 'உணர்வேன்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
      after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    UPDATE word_groups SET combined_display_form = 'உணர்வேன்' WHERE id = g1;
  END IF;

  SELECT id INTO g2 FROM word_groups WHERE poem_line_id = v_l AND position = 7;
  IF g2 IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line29 position7 (உணர்வேன் #2)';
  ELSE
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g2, 0, 'சந்தி மெய் வ் வரும் (இன்னும் முழுச் சொல் இல்லை)', 'உணர் + வ்', 'உணர்வ்', NULL),
      (g2, 1, 'உணர்வேன் = நான் உணர்வேன் (மீண்டும் - அழுத்தம்); I shall realise (repeated)', 'உணர்வ் + ஏன்', 'உணர்வேன்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
      after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    UPDATE word_groups SET combined_display_form = 'உணர்வேன்' WHERE id = g2;
  END IF;
  RAISE NOTICE '✓ Line29 both உணர்வேன் boxes fixed.';

  ------------------------------------------------------------------
  -- LINE 32: நன்மண்ணாக்கு + ஐ = நன்மண்ணாக்குவை  (last morpheme was
  -- wrongly stored as "வை" from the very start — it should be the raw
  -- accusative marker "ஐ", which becomes "வை" only after combining)
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 32;
  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_l AND position = 6;
  IF v_group_id IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line32 position6 (நன்மை/மண்/ஆக்கு/வை box)';
  ELSE
    UPDATE morphemes SET
      display_form = 'ஐ',
      word_meaning = 'இரண்டாம் வேற்றுமை உருபு; accusative marker'
    WHERE word_group_id = v_group_id AND position = 9;

    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'உயிர் ஈறு + ஐ இணையும்போது வகரம் வரும்', 'நன்மண்ணாக்கு + ஐ', 'நன்மண்ணாக்குவை', 'வ்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
      after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    RAISE NOTICE '✓ Line32 நன்மண்ணாக்குவை (ஐ) fixed.';
  END IF;

  ------------------------------------------------------------------
  -- LINE 37: full restructure —
  --   ஒளிக்குவை = ஒளி + க் + க் + உ + ஐ  (ஒளிக்-ஒளிக்க்-ஒளிக்கு-ஒளிக்குவை)
  --   + meaning fixes for வாயுமோர் and உருண்டையால்
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 37;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;

  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'ஒளிக்குவை', 'ஒளிக்குவை = நீ மறைக்கிறாய்; you hide, you conceal')
  RETURNING id INTO g1;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_verb, is_separator, word_group_id) VALUES
    (v_l, 1, 'ஒளி', 'ஒளித்தல் பகுதி; to hide, conceal', true, false, g1),
    (v_l, 2, 'க்',  'சந்தி மெய்; junction consonant', false, false, g1),
    (v_l, 3, 'க்',  'ஒற்று மிகுதல்; doubled consonant', false, false, g1),
    (v_l, 4, 'உ',   'எதிர்கால இடைநிலை; future marker', false, false, g1),
    (v_l, 5, 'ஐ',   'இரண்டாம் வேற்றுமை/முன்னிலை விகுதி இணைவு; verb ending glide', false, false, g1);

  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 6, 'உன்குழி', 'உன்குழி = உன்னுடைய குழி; your pit/hole')
  RETURNING id INTO g2;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 6, 'உன்', 'உன்னுடைய; your', false, g2),
    (v_l, 7, 'குழி', 'குழி; pit, hole', false, g2);

  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 8, 'வாயுமோர்', 'வாயுமோர் = வாயில் / புகுமிடம்; the mouth, an entrance/opening')
  RETURNING id INTO g3;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 8, 'வாய்', 'வாய், துவாரம்; mouth, opening', false, g3),
    (v_l, 9, 'உம்', 'சிறப்பும்மை; ''also, too''', false, g3),
    (v_l, 10, 'ஓர்', 'ஒரு; a', false, g3);

  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 11, 'உருண்டையால்', 'உருண்டையால் = உருண்டையான வாயில் வழியின் உள்ளே சென்று புகுந்துவிடுவாய்; you will go inside through the round entrance and hide')
  RETURNING id INTO g4;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 11, 'உருண்டை', 'உருண்டை; ball, round lump', false, g4),
    (v_l, 12, 'ஆல்', 'மூன்றாம் வேற்றுமை உருபு; instrumental ''with''', false, g4);

  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (g1, 0, 'ஒளித்தல் பகுதி; to hide (இன்னும் முழுச் சொல் ஆகவில்லை)', 'ஒளி + க்', 'ஒளிக்', NULL),
    (g1, 1, 'ஒளித்தல் பகுதி; to hide (இன்னும் முழுச் சொல் ஆகவில்லை) — ஒற்று மிகும்', 'ஒளிக் + க்', 'ஒளிக்க்', 'க்'),
    (g1, 2, 'எதிர்கால இடைநிலை உ இணையும்', 'ஒளிக்க் + உ', 'ஒளிக்கு', NULL),
    (g1, 3, 'உயிர் ஈறு + ஐ இணையும்போது வகரம் வரும்', 'ஒளிக்கு + ஐ', 'ஒளிக்குவை', 'வ்')
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (g2, 0, 'இணைந்த சொல் வடிவம்', 'உன் + குழி', 'உன்குழி', NULL)
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (g3, 0, 'இணைந்த சொல் வடிவம்', 'வாய் + உம்', 'வாயும்', NULL),
    (g3, 1, 'இணைந்த சொல் வடிவம்', 'வாயும் + ஓர்', 'வாயுமோர்', NULL)
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (g4, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'உருண்டை + ஆல்', 'உருண்டையால்', 'ய')
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  RAISE NOTICE '✓ Line37 fully restructured.';

  ------------------------------------------------------------------
  -- LINE 38: உழு + ஆய் + ஏல் = உழாயேல்  (2nd morpheme was "ஆ", should
  -- include the glide: "ஆய்")
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 38;
  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_l AND position = 7;
  IF v_group_id IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line38 position7 (உழு/ஆ/ஏல் box)';
  ELSE
    UPDATE morphemes SET
      display_form = 'ஆய்',
      word_meaning = 'எதிர்மறை இடைநிலை + சந்தி மெய்; negative particle + glide'
    WHERE word_group_id = v_group_id AND position = 8;

    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு ஆகாரம் ஏற்கும்', 'உழு + ஆய்', 'உழாய்', NULL),
      (v_group_id, 1, 'நிபந்தனை விகுதி ஏல் இணையும்', 'உழாய் + ஏல்', 'உழாயேல்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
      after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    RAISE NOTICE '✓ Line38 உழாயேல் fixed.';
  END IF;

  ------------------------------------------------------------------
  -- LINE 42: யார்க்கு + உள = யார்க்குள
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 42;
  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_l AND position = 9;
  IF v_group_id IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line42 position9 (யார்/க்/கு/உள box)';
  ELSE
    UPDATE word_groups SET
      combined_display_form = 'யார்க்குள',
      combined_meaning = 'யார்க்குள = யாருக்கு உள்ளது; who possesses [it]?'
    WHERE id = v_group_id;

    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'சந்தி மெய் க் வரும் (இன்னும் முழுச் சொல் இல்லை)', 'யார் + க்', 'யார்க்', NULL),
      (v_group_id, 1, 'நான்காம் வேற்றுமை உருபு கு இணையும்', 'யார்க் + கு', 'யார்க்கு', NULL),
      (v_group_id, 2, 'தொடர்ச்சியான உயிரொலியில் ஒன்று கெடும்', 'யார்க்கு + உள', 'யார்க்குள', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
      after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    RAISE NOTICE '✓ Line42 யார்க்குள fixed.';
  END IF;

  ------------------------------------------------------------------
  -- LINE 44: நடத்துதி = நட + த் + த் + உ + தி  (was stored as just
  -- 2 pieces "நடத்து" + "தி")
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 44;
  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_l AND position = 8;
  IF v_group_id IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line44 position8 (நடத்து/தி box)';
  ELSE
    -- shift the two standalone "ஆ! ஆ!" exclamations after this box
    UPDATE morphemes SET position = position + 3
    WHERE poem_line_id = v_l AND position IN (10, 11) AND word_group_id IS NULL;

    DELETE FROM morphemes WHERE word_group_id = v_group_id;
    INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_verb, is_separator, word_group_id) VALUES
      (v_l, 8,  'நட', 'நடத்துதல் பகுதி; to conduct, carry out', true, false, v_group_id),
      (v_l, 9,  'த்', 'இறந்தகால இடைநிலை; past-tense marker', false, false, v_group_id),
      (v_l, 10, 'த்', 'இறந்தகால இடைநிலை; past-tense marker', false, false, v_group_id),
      (v_l, 11, 'உ',  'வினையெச்ச/பெயரெச்ச விகுதி; participle ending', false, false, v_group_id),
      (v_l, 12, 'தி', 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person ''you [do]''', false, false, v_group_id);

    UPDATE word_groups SET
      combined_display_form = 'நடத்துதி',
      combined_meaning = 'நடத்துதி = நீ நடத்துகிறாய்; you carry out'
    WHERE id = v_group_id;

    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'நடத்துதல் பகுதி; to conduct (இன்னும் முழுச் சொல் ஆகவில்லை)', 'நட + த்', 'நடத்', NULL),
      (v_group_id, 1, 'நடத்துதல் பகுதி; to conduct (இன்னும் முழுச் சொல் ஆகவில்லை)', 'நடத் + த்', 'நடத்த்', NULL),
      (v_group_id, 2, 'நடத்து = நடத்துதல்; the act of conducting/carrying out', 'நடத்த் + உ', 'நடத்து', 'உ'),
      (v_group_id, 3, 'நடத்துதி = நீ நடத்துகிறாய்; you carry out', 'நடத்து + தி', 'நடத்துதி', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
      after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    RAISE NOTICE '✓ Line44 நடத்துதி rebuilt.';
  END IF;

END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, wg.position, wg.combined_display_form, wg.combined_meaning
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்' AND pl.line_number IN (28, 29, 32, 37, 38, 42, 44)
ORDER BY pl.line_number, wg.position;
