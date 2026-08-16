-- ============================================================================
-- மனோன்மணீயம் — batch fix: பரப்பித்து (L13), தழைப்பதற்கு/பிழைப்பதற்கு (L17
-- restructure to letter-by-letter), அயத்து (L18), சிறுவர் (L19 missing rule)
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_poem_page_id uuid;
  v_l uuid;
  v_group_id uuid;
  g_a uuid;  -- L17 தழை group
  g_d uuid;  -- L17 பிழை group
  g_b uuid;  -- L17 இடம்+இலை group
  g_c uuid;  -- L17 சிறுமை+ஆர் group
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'மனோன்மணீயம் topic not found.';
  END IF;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  ------------------------------------------------------------------
  -- LINE 13: பரப்பி + த் + த் + உ = பரப்பித்து
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 13;
  SELECT wg.id INTO v_group_id FROM word_groups wg WHERE wg.poem_line_id = v_l AND wg.position = 6;
  IF v_group_id IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line13 position6 (பரப்பி box)';
  ELSE
    UPDATE word_groups SET
      combined_display_form = 'பரப்பித்து',
      combined_meaning = 'பரப்பித்து = பரப்பிக்கொண்டு; having spread'
    WHERE id = v_group_id;

    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'பரப்புதல் பகுதி; to spread (இன்னும் முழுச் சொல் ஆகவில்லை)', 'பரப்பி + த்', 'பரப்பித்', NULL),
      (v_group_id, 1, 'பரப்புதல் பகுதி; to spread (இன்னும் முழுச் சொல் ஆகவில்லை)', 'பரப்பித் + த்', 'பரப்பித்த்', NULL),
      (v_group_id, 2, 'பரப்பித்து = பரப்பிக்கொண்டு; having spread', 'பரப்பித்த் + உ', 'பரப்பித்து', 'உ')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
      after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    RAISE NOTICE '✓ Line13 பரப்பித்து fixed.';
  END IF;

  ------------------------------------------------------------------
  -- LINE 17: full restructure so தழை and பிழை split letter-by-letter
  -- தழை + ப் = தழைப் ; +ப் = தழைப்ப் ; +அது = தழைப்பது ; +அல் = தழைப்பதல்
  -- (intermediate) ; +கு = தழைப்பதற்கு        (same for பிழை)
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 17;
  IF v_l IS NULL THEN
    RAISE EXCEPTION 'Line 17 not found.';
  END IF;

  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;

  -- Group A: தழை (positions 1-6)
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'தழைப்பதற்கு', 'தழைப்பதற்கு = தழைத்து வளர்வதற்கு; in order to flourish')
  RETURNING id INTO g_a;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_verb, is_separator, word_group_id) VALUES
    (v_l, 1, 'தழை', 'தழைத்தல் பகுதி; to flourish, thrive', true, false, g_a),
    (v_l, 2, 'ப்',  'சந்தி மெய்; junction consonant', false, false, g_a),
    (v_l, 3, 'ப்',  'ஒற்று மிகுதல்; doubled consonant', false, false, g_a),
    (v_l, 4, 'அது', 'தொழிற்பெயர் விகுதி; verbal-noun ''-ing''', false, false, g_a),
    (v_l, 5, 'அல்', 'உருபு இடைநிலை; case-marker glide', false, false, g_a),
    (v_l, 6, 'கு',  'நான்காம் வேற்றுமை உருபு; dative ''in order to''', false, false, g_a);

  -- Group B: இடம் + இலை (positions 7-8)
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'இடமிலை', 'இடமிலை = இடம் + இலை இணைந்த சொல்')
  RETURNING id INTO g_b;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'இடம்', 'இடம், வெளி; space, place', false, g_b),
    (v_l, 8, 'இலை', 'இல்லை; not present, absent', false, g_b);

  -- Group C: சிறுமை + ஆர் = சிறார் (positions 9-10)
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 9, 'சிறார்', 'சிறார் = சிறுவர்கள்; the young ones, children')
  RETURNING id INTO g_c;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 9, 'சிறுமை', 'சிறிய தன்மை; smallness (root for ''young ones'')', false, g_c),
    (v_l, 10, 'ஆர்', 'பலர்பால் விகுதி; plural person suffix', false, g_c);

  -- standalone நீர் (position 11)
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 11, 'நீர்', 'நீங்கள் (முன்னிலைப் பன்மை பழந்தமிழ் வடிவம்); you (archaic plural/respectful)', false, NULL);

  -- Group D: பிழை (positions 12-17)
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 12, 'பிழைப்பதற்கு', 'பிழைப்பதற்கு = பிழைத்து வாழ்வதற்கு; in order to survive')
  RETURNING id INTO g_d;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_verb, is_separator, word_group_id) VALUES
    (v_l, 12, 'பிழை', 'பிழைத்தல் பகுதி; to survive, escape', true, false, g_d),
    (v_l, 13, 'ப்',  'சந்தி மெய்; junction consonant', false, false, g_d),
    (v_l, 14, 'ப்',  'ஒற்று மிகுதல்; doubled consonant', false, false, g_d),
    (v_l, 15, 'அது', 'தொழிற்பெயர் விகுதி; verbal-noun ''-ing''', false, false, g_d),
    (v_l, 16, 'அல்', 'உருபு இடைநிலை; case-marker glide', false, false, g_d),
    (v_l, 17, 'கு',  'நான்காம் வேற்றுமை உருபு; dative ''in order to''', false, false, g_d);

  -- ── sandhi_rules: Group A (தழை) ──
  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (g_a, 0, 'தழைத்தல் பகுதி; to flourish (இன்னும் முழுச் சொல் ஆகவில்லை)', 'தழை + ப்', 'தழைப்', NULL),
    (g_a, 1, 'தழைத்தல் பகுதி; to flourish (இன்னும் முழுச் சொல் ஆகவில்லை) — ஒற்று மிகும்', 'தழைப் + ப்', 'தழைப்ப்', 'ப்'),
    (g_a, 2, 'தழைப்பது = தழைத்தல்; the act of flourishing/thriving', 'தழைப்ப் + அது', 'தழைப்பது', NULL),
    (g_a, 3, 'இடைநிலை வடிவம், இன்னும் முழுமையடையவில்லை; intermediate form', 'தழைப்பது + அல்', 'தழைப்பதல்', NULL),
    (g_a, 4, 'லகரம் றகரமாகத் திரியும்', 'தழைப்பதல் + கு', 'தழைப்பதற்கு', 'ற்')
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  -- ── sandhi_rules: Group D (பிழை) ──
  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (g_d, 0, 'பிழைத்தல் பகுதி; to survive, escape (இன்னும் முழுச் சொல் ஆகவில்லை)', 'பிழை + ப்', 'பிழைப்', NULL),
    (g_d, 1, 'பிழைத்தல் பகுதி; to survive, escape (இன்னும் முழுச் சொல் ஆகவில்லை) — ஒற்று மிகும்', 'பிழைப் + ப்', 'பிழைப்ப்', 'ப்'),
    (g_d, 2, 'பிழைப்பது = பிழைத்தல், வாழ்க்கை; livelihood, the act of surviving', 'பிழைப்ப் + அது', 'பிழைப்பது', NULL),
    (g_d, 3, 'இடைநிலை வடிவம், இன்னும் முழுமையடையவில்லை; intermediate form', 'பிழைப்பது + அல்', 'பிழைப்பதல்', NULL),
    (g_d, 4, 'லகரம் றகரமாகத் திரியும்', 'பிழைப்பதல் + கு', 'பிழைப்பதற்கு', 'ற்')
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  -- ── sandhi_rules: Group B (இடமிலை) and Group C (சிறார்) — unchanged content ──
  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (g_b, 0, 'இணைந்த சொல் வடிவம்', 'இடம் + இலை', 'இடமிலை', NULL)
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (g_c, 0, 'பாடலில் காணப்படும் இணைந்த சொல் வடிவம் (சிறுமை -> சிறு, ஆர் இணைப்பு)', 'சிறுமை + ஆர்', 'சிறார்', NULL)
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  RAISE NOTICE '✓ Line17 fully restructured (தழை and பிழை now split letter-by-letter).';

  ------------------------------------------------------------------
  -- LINE 18: அயம் + அத்து = அயத்து
  ------------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 18 AND wg.position = 6;
  IF v_group_id IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line18 position6 (அயம்/அத்து box)';
  ELSE
    UPDATE word_groups SET
      combined_display_form = 'அயத்து',
      combined_meaning = 'அயத்து = கால்நடைகள் (ஆடு, குதிரை) இருக்குமிடத்தில்; where the livestock are'
    WHERE id = v_group_id;

    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'மகர ஈறு கெட்டு அகர முதல் சொல் இணையும்', 'அயம் + அத்து', 'அயத்து', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
      after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    RAISE NOTICE '✓ Line18 அயத்து fixed.';
  END IF;

  ------------------------------------------------------------------
  -- LINE 19: சிறுமை + அர் = சிறுவர்  (connector 0 was missing — this is
  -- why the box still showed raw "சிறுமைஅர்")
  ------------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 19 AND wg.position = 8;
  IF v_group_id IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line19 position8 (சிறுமை/அர்/ஐ/ப் box)';
  ELSE
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'பாடலில் காணப்படும் இணைந்த சொல் வடிவம் (சிறுமை -> சிறு, அர் இணைப்பு, வகரம் வரும்)', 'சிறுமை + அர்', 'சிறுவர்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
      after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    RAISE NOTICE '✓ Line19 சிறுவர் (missing connector 0) fixed.';
  END IF;

END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, wg.position, wg.combined_display_form, wg.combined_meaning
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்' AND pl.line_number IN (13, 17, 18, 19)
ORDER BY pl.line_number, wg.position;
