-- ============================================================================
-- மனோன்மணீயம் — sandhi_rules for OTHER occurrences of the same 5 phonological
-- patterns Doc2.docx illustrated:
--   A) உகர ஈறு + இன் -> உகரம் கெட்டு இன் இணையும்   (வேண்டு+இன், முடுக்கு+இன்)
--   B) உகர ஈறு + ஆய் -> உகரம் கெட்டு ஆய் இணையும்   (விரைவு+ஆய்)
--   C) ஐகர ஈறு + உயிர்-தொடங்கும் அசை -> யகரம் வரும்  (காலை+இல்)
--   D) இகர ஈறு + உம் -> இகரம் யகரமாகத் திரியும்      (முடி+உம்)
--   E) எ + மெய்-தொடங்கும் சொல் -> ஒற்று மிகும்         (எ+வினை)
--
-- I scanned all 47 lines for every place a morpheme boundary matches one of
-- these 5 sound patterns (root's ending letter / next word's starting
-- letter), then checked the poem's own raw_text for the correct spelling
-- of that combined word (ground truth from the textbook), rather than
-- re-deriving the sandhi mechanically — a few of these are irregular/
-- lexicalised forms (சிறுமை -> சிறார் / சிறுவர்) where the textbook
-- spelling doesn't follow the plain mechanical rule, so I used the actual
-- printed word in those cases and said so in the rule_text.
--
-- Run this AFTER manonmaniyam_sandhi_from_doc2.sql. Safe to re-run.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_poem_page_id uuid;
  v_group_id uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'மனோன்மணீயம் topic not found.';
  END IF;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';


  -- Line 4, group 'எவினைஓர்குஉம்': வினை + ஓர் -> வினையோர்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 4 AND wg.combined_display_form = 'எவினைஓர்குஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும் (Doc2: காலை+இல் போன்ற வகை)', 'வினை + ஓர்', 'வினையோர்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 4 group %', 'எவினைஓர்குஉம்';
  END IF;

  -- Line 4, group 'இம்மைஇல்': இம்மை + இல் -> இம்மையில்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 4 AND wg.combined_display_form = 'இம்மைஇல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'இம்மை + இல்', 'இம்மையில்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 4 group %', 'இம்மைஇல்';
  END IF;

  -- Line 7, group 'எபொருள்': எ + பொருள் -> எப்பொருள்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 7 AND wg.combined_display_form = 'எபொருள்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'எ + மெய் தொடங்கும் சொல் இணையும்போது ஒற்று மிகும் (Doc2: எ+வினை போன்ற வகை)', 'எ + பொருள்', 'எப்பொருள்', 'ப்ப்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 7 group %', 'எபொருள்';
  END IF;

  -- Line 12, group 'நன்மைஊண்': நன்மை + ஊண் -> நல்லூண்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 12 AND wg.combined_display_form = 'நன்மைஊண்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'பாடலில் காணப்படும் இணைந்த சொல் வடிவம்', 'நன்மை + ஊண்', 'நல்லூண்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 12 group %', 'நன்மைஊண்';
  END IF;

  -- Line 15, group 'தோட்டிஉம்': தோட்டி + உம் -> தோட்டியும்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 15 AND wg.combined_display_form = 'தோட்டிஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இகர ஈறு யகரமாகத் திரிந்து உம் இணையும் (Doc2: முடி+உம் போன்ற வகை)', 'தோட்டி + உம்', 'தோட்டியும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 15 group %', 'தோட்டிஉம்';
  END IF;

  -- Line 17, group 'சிறுமைஆர்': சிறுமை + ஆர் -> சிறார்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 17 AND wg.combined_display_form = 'சிறுமைஆர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'பாடலில் காணப்படும் இணைந்த சொல் வடிவம் (சிறுமை -> சிறு, ஆர் இணைப்பு)', 'சிறுமை + ஆர்', 'சிறார்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 17 group %', 'சிறுமைஆர்';
  END IF;

  -- Line 19, group 'சிறுமைஅர்ஐப்': சிறுமை + அர் -> சிறுவர்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 19 AND wg.combined_display_form = 'சிறுமைஅர்ஐப்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'பாடலில் காணப்படும் இணைந்த சொல் வடிவம் (சிறுமை -> சிறு, அர் இணைப்பு, வகரம் வரும்)', 'சிறுமை + அர்', 'சிறுவர்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 19 group %', 'சிறுமைஅர்ஐப்';
  END IF;

  -- Line 19, group 'சிறுமைஅர்ஐப்': அர் + ஐ -> சிறுவரை
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 19 AND wg.combined_display_form = 'சிறுமைஅர்ஐப்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இரண்டாம் வேற்றுமை உருபு ஐ இணையும்', 'அர் + ஐ', 'சிறுவரை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 19 group %', 'சிறுமைஅர்ஐப்';
  END IF;

  -- Line 19, group 'சிறுமைஅர்ஐப்': ஐ + ப் -> சிறுவரைப்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 19 AND wg.combined_display_form = 'சிறுமைஅர்ஐப்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'சந்தி மெய் ப் இணையும்', 'ஐ + ப்', 'சிறுவரைப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 19 group %', 'சிறுமைஅர்ஐப்';
  END IF;

  -- Line 21, group 'பொறுமைஉம்': பொறுமை + உம் -> பொறுமையும்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 21 AND wg.combined_display_form = 'பொறுமைஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'பொறுமை + உம்', 'பொறுமையும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 21 group %', 'பொறுமைஉம்';
  END IF;

  -- Line 22, group 'சிறுமைஆச்சிந்தனை': சிறுமை + ஆ -> சிறுமையா
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 22 AND wg.combined_display_form = 'சிறுமைஆச்சிந்தனை';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'சிறுமை + ஆ', 'சிறுமையா', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 22 group %', 'சிறுமைஆச்சிந்தனை';
  END IF;

  -- Line 24, group 'ஏற்றுஅதுஓர்முயற்சிஉம்': முயற்சி + உம் -> முயற்சியும்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 24 AND wg.combined_display_form = 'ஏற்றுஅதுஓர்முயற்சிஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'இகர ஈறு யகரமாகத் திரிந்து உம் இணையும்', 'முயற்சி + உம்', 'முயற்சியும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 24 group %', 'ஏற்றுஅதுஓர்முயற்சிஉம்';
  END IF;

  -- Line 26, group 'அன்புஇன்ஆல்': அன்பு + இன் -> அன்பின்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'அன்புஇன்ஆல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகர ஈறு கெட்டு இன் இணையும் (Doc2: வேண்டு+இன் போன்ற வகை)', 'அன்பு + இன்', 'அன்பின்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'அன்புஇன்ஆல்';
  END IF;

  -- Line 26, group 'அன்புஇன்ஆல்': இன் + ஆல் -> அன்பினால்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'அன்புஇன்ஆல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இன் ஈற்றுடன் ஆல் வேற்றுமை உருபு நேரடியாக இணையும்', 'இன் + ஆல்', 'அன்பினால்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'அன்புஇன்ஆல்';
  END IF;

  -- Line 31, group 'உழுவ்ஓர்க்குஎல்லாம்விழுமைஇய': விழுமை + இய -> விழுமிய
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 31 AND wg.combined_display_form = 'உழுவ்ஓர்க்குஎல்லாம்விழுமைஇய';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 6, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'விழுமை + இய', 'விழுமிய', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 31 group %', 'உழுவ்ஓர்க்குஎல்லாம்விழுமைஇய';
  END IF;

  -- Line 32, group 'எமண்ஆய்இன்உம்': எ + மண் -> எம்மண்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 32 AND wg.combined_display_form = 'எமண்ஆய்இன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'எ + மெய் தொடங்கும் சொல் இணையும்போது ஒற்று மிகும்', 'எ + மண்', 'எம்மண்', 'ம்ம்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 32 group %', 'எமண்ஆய்இன்உம்';
  END IF;

  -- Line 34, group 'மெழுகுஇன்உம்': மெழுகு + இன் -> மெழுகின்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 34 AND wg.combined_display_form = 'மெழுகுஇன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகர ஈறு கெட்டு இன் இணையும்', 'மெழுகு + இன்', 'மெழுகின்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 34 group %', 'மெழுகுஇன்உம்';
  END IF;

  -- Line 34, group 'மெழுகுஇன்உம்': இன் + உம் -> மெழுகினும்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 34 AND wg.combined_display_form = 'மெழுகுஇன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இன் ஈற்றுடன் உம் நேரடியாக இணையும்', 'இன் + உம்', 'மெழுகினும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 34 group %', 'மெழுகுஇன்உம்';
  END IF;

  -- Line 34, group 'நேர்மைஇய': நேர்மை + இய -> நேரிய
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 34 AND wg.combined_display_form = 'நேர்மைஇய';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'நேர்மை + இய', 'நேரிய', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 34 group %', 'நேர்மைஇய';
  END IF;

  -- Line 35, group 'விழுமைஇய': விழுமை + இய -> விழுமிய
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 35 AND wg.combined_display_form = 'விழுமைஇய';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'விழுமை + இய', 'விழுமிய', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 35 group %', 'விழுமைஇய';
  END IF;

  -- Line 35, group 'சேறுஆய்': சேறு + ஆய் -> சேறாய்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 35 AND wg.combined_display_form = 'சேறுஆய்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகர ஈறு கெட்டு ஆய் இணையும் (Doc2: விரைவு+ஆய் போன்ற வகை)', 'சேறு + ஆய்', 'சேறாய்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 35 group %', 'சேறுஆய்';
  END IF;

  -- Line 37, group 'வாய்உம்ஓர்உருண்டைஆல்': உருண்டை + ஆல் -> உருண்டையால்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 37 AND wg.combined_display_form = 'வாய்உம்ஓர்உருண்டைஆல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'உருண்டை + ஆல்', 'உருண்டையால்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 37 group %', 'வாய்உம்ஓர்உருண்டைஆல்';
  END IF;

  -- Line 39, group 'எபடி': எ + படி -> எப்படி
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 39 AND wg.combined_display_form = 'எபடி';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'எ + மெய் தொடங்கும் சொல் இணையும்போது ஒற்று மிகும்', 'எ + படி', 'எப்படி', 'ப்ப்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 39 group %', 'எபடி';
  END IF;

  -- Line 41, group 'பூச்சிஉம்': பூச்சி + உம் -> பூச்சியும்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'பூச்சிஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இகர ஈறு யகரமாகத் திரிந்து உம் இணையும்', 'பூச்சி + உம்', 'பூச்சியும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'பூச்சிஉம்';
  END IF;

  -- Line 42, group 'பொறைஉம்': பொறை + உம் -> பொறையும்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 42 AND wg.combined_display_form = 'பொறைஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'பொறை + உம்', 'பொறையும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 42 group %', 'பொறைஉம்';
  END IF;

  -- Line 45, group 'இணைஇலாஇன்புஉம்': இணை + இலா -> இணையிலா
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 45 AND wg.combined_display_form = 'இணைஇலாஇன்புஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'இணை + இலா', 'இணையிலா', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 45 group %', 'இணைஇலாஇன்புஉம்';
  END IF;

  RAISE NOTICE '✓ Additional sandhi rules for similar patterns applied.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, wg.combined_display_form, sr.connector_index, sr.before_form, sr.after_form
FROM sandhi_rules sr
JOIN word_groups wg ON wg.id = sr.word_group_id
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்'
ORDER BY pl.line_number, sr.connector_index;
