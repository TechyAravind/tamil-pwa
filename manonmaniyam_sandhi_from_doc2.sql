-- ============================================================================
-- மனோன்மணீயம் — sandhi_rules from Doc2.docx examples
--
-- Doc2.docx gave these combine pairs:
--   காலை + இல் = காலையில்
--   வேண்டு + இன் = வேண்டின்
--   விரைவு + ஆய் = விரைவாய்
--   முடுக்கு + இன் = முடுக்கின்
--   முடுக்கின் + உம் = முடுக்கினும்   (2nd-step: combining the already-merged
--                                       "முடுக்கின்" with the next "உம்")
--   முடி + உம் = முடியும்
--   எ + வினை = எவ்வினை
--
-- I searched every one of the 47 lines for other places these exact word
-- pairs occur (so the fix would apply everywhere, not just where you saw
-- it) — each pair turns out to occur exactly once in this poem, and all
-- of them are already in lines 1-4, the same lines Doc2's examples came
-- from. So there are no "other occurrences" elsewhere to fix; this script
-- covers all of them. Without a sandhi_rules row, tapping "+" just glues
-- the two words together (e.g. "எ"+"வினை" -> "எவினை") and keeps the first
-- word's meaning — these rows replace that with the correct sandhi form
-- and a real combined meaning.
--
-- Run this AFTER manonmaniyam_full_setup.sql and manonmaniyam_other_content.sql.
-- Safe to re-run.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_poem_page_id uuid;
  v_group_id uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'மனோன்மணீயம் topic not found — run manonmaniyam_full_setup.sql first.';
  END IF;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  ------------------------------------------------------------------
  -- Line 1: காலை + இல் = காலையில்
  ------------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 1 AND wg.combined_display_form = 'காலைஇல்';
  IF v_group_id IS NOT NULL THEN
    UPDATE word_groups SET combined_display_form = 'காலையில்', combined_meaning = 'காலையில் = காலைப் பொழுதில்; in the morning' WHERE id = v_group_id;
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உயிர் ஈறு + இல் வேற்றுமை உருபு இணையும்போது யகர ஒற்று வரும்', 'காலை + இல்', 'காலையில்', 'ய்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line1 காலைஇல்';
  END IF;

  ------------------------------------------------------------------
  -- Line 2: வேண்டு + இன் = வேண்டின்
  ------------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 2 AND wg.combined_display_form = 'வேண்டுஇன்';
  IF v_group_id IS NOT NULL THEN
    UPDATE word_groups SET combined_display_form = 'வேண்டின்', combined_meaning = 'வேண்டின் = விரும்பினால்; if desired/wished' WHERE id = v_group_id;
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகர ஈறு கெட்டு நிபந்தனை இடைநிலை இன் சேரும்போது வேண்டு -> வேண்டு+இன் -> வேண்டின்', 'வேண்டு + இன்', 'வேண்டின்', 'இன்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line2 வேண்டுஇன்';
  END IF;

  ------------------------------------------------------------------
  -- Line 2: விரைவு + ஆய் = விரைவாய்
  ------------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 2 AND wg.combined_display_form = 'விரைவுஆய்';
  IF v_group_id IS NOT NULL THEN
    UPDATE word_groups SET combined_display_form = 'விரைவாய்', combined_meaning = 'விரைவாய் = வேகமாக; quickly' WHERE id = v_group_id;
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகர ஈறு கெட்டு வினையெச்ச விகுதி ஆய் சேரும்போது விரைவு -> விரைவாய்', 'விரைவு + ஆய்', 'விரைவாய்', 'ஆய்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line2 விரைவுஆய்';
  END IF;

  ------------------------------------------------------------------
  -- Line 3: முடுக்கு + இன் = முடுக்கின்  (connector 0)
  --         முடுக்கின் + உம் = முடுக்கினும்  (connector 1, chained)
  ------------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 3 AND wg.combined_display_form = 'முடுக்குஇன்உம்';
  IF v_group_id IS NOT NULL THEN
    UPDATE word_groups SET combined_display_form = 'முடுக்கினும்', combined_meaning = 'முடுக்கினும் = விரைவுபடுத்தினாலும்; even if hastened' WHERE id = v_group_id;
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகர ஈறு கெட்டு நிபந்தனை இடைநிலை இன் சேரும்போது முடுக்கு -> முடுக்கின்', 'முடுக்கு + இன்', 'முடுக்கின்', 'இன்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'சிறப்பும்மை உம் சேரும்போது முடுக்கின் -> முடுக்கினும்', 'முடுக்கின் + உம்', 'முடுக்கினும்', 'உம்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line3 முடுக்குஇன்உம்';
  END IF;

  ------------------------------------------------------------------
  -- Line 3: முடி + உம் = முடியும்
  ------------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 3 AND wg.combined_display_form = 'முடிஉம்';
  IF v_group_id IS NOT NULL THEN
    UPDATE word_groups SET combined_display_form = 'முடியும்', combined_meaning = 'முடியும் = முடிவடையும்; will finish/end' WHERE id = v_group_id;
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இகர ஈறு யகரமாகத் திரிந்து எதிர்கால இடைநிலை உம் சேரும்போது முடி -> முடியும்', 'முடி + உம்', 'முடியும்', 'ய்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line3 முடிஉம்';
  END IF;

  ------------------------------------------------------------------
  -- Line 4: எ + வினை = எவ்வினை  (connector 0 only; ஓர்/கு/உம் connectors
  -- in this same group are left as simple concatenation — Doc2 did not
  -- give a rule for those)
  ------------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 4 AND wg.combined_display_form = 'எவினைஓர்குஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'குற்றியலுகரம் ஈறாக வரும் எ-கு மெய்யீட்டுப் புணர்ச்சியில் வகரம் வரும்', 'எ + வினை', 'எவ்வினை', 'வ்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line4 எவினைஓர்குஉம்';
  END IF;

  RAISE NOTICE '✓ Doc2 sandhi rules applied (7 connector rules across lines 1-4).';
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
