-- ============================================================================
-- மனோன்மணீயம் — Line 8, box "இ + சிறுமை + புல்": fix the sandhi
--
-- Currently there is NO sandhi_rules row for this box's connectors, so
-- tapping "+" just glues the raw chips together: இ + சிறுமை -> "இசிறுமை"
-- (and keeps showing இ's own meaning, "சுட்டு இடைச்சொல்; demonstrative
-- 'this'"), exactly as your screenshot shows.
--
-- Correct grammar (same ஒற்று மிகும் + மை-dropping pattern already used
-- elsewhere in this poem for இலா+சிறுமை and சிறுமை+பூ):
--   இ + சிறுமை  -> இச்சிறுமை   (ஒற்று மிகும்: ச் doubles)
--   இச்சிறுமை + புல் -> இச்சிறுபுல்  (ஐகர ஈறு "மை" கெட்டு அடுத்த சொல் இணையும்)
-- Final box meaning: இச்சிறுபுல் = இந்தச் சிறிய புல்; this small/tender grass
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_group_id uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'மனோன்மணீயம் topic not found.';
  END IF;

  -- Find the box by its STABLE key: line 8, position 10 (not by text,
  -- since the text is exactly what we're about to fix)
  SELECT wg.id INTO v_group_id
  FROM word_groups wg
  JOIN poem_lines pl ON pl.id = wg.poem_line_id
  JOIN pages p ON p.id = pl.page_id
  WHERE p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 8 AND wg.position = 10;

  IF v_group_id IS NULL THEN
    RAISE EXCEPTION 'Box not found: line 8 position 10 (இ/சிறுமை/புல்).';
  END IF;

  UPDATE word_groups SET
    combined_display_form = 'இச்சிறுபுல்',
    combined_meaning = 'இச்சிறுபுல் = இந்தச் சிறிய புல்; this small/tender grass'
  WHERE id = v_group_id;

  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (v_group_id, 0, 'ஒற்று மிகும் (இ-ஈறு + வல்லின முதல் எழுத்துடன் தொடங்கும் சொல்)', 'இ + சிறுமை', 'இச்சிறுமை', 'ச்'),
    (v_group_id, 1, 'ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்', 'இச்சிறுமை + புல்', 'இச்சிறுபுல்', NULL)
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  RAISE NOTICE '✓ இ+சிறுமை+புல் box fixed (id=%).', v_group_id;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT wg.combined_display_form, wg.combined_meaning, sr.connector_index, sr.before_form, sr.after_form
FROM word_groups wg
LEFT JOIN sandhi_rules sr ON sr.word_group_id = wg.id
JOIN poem_lines pl ON pl.id = wg.poem_line_id
WHERE pl.line_number = 8 AND wg.position = 10
ORDER BY sr.connector_index;
