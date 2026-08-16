-- ============================================================================
-- மனோன்மணீயம் — Line 13, box "பலம் + உற + தன் + அது": fix the sandhi
--
-- Currently no sandhi_rules exist for this box's 3 connectors, so each tap
-- just glues raw text together (பலம்உற, பலம்உறதன், பலம்உறதன்அது) and keeps
-- showing பலம்'s own meaning throughout — exactly your screenshots.
--
-- Correct chain:
--   பலம் + உற        -> பலமுற        (மகர ஈறு கெட்டு உயிரெழுத்து இணையும்)
--   பலமுற + தன்      -> பலமுறத்தன்   (ஒற்று மிகும்: த் இரட்டிக்கும்)
--   பலமுறத்தன் + அது -> பலமுறத்தனது (னகர ஈறு + அகர முதல் சொல் இணையும்)
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

  -- Stable key: line 13, position 1 (the பலம்/உற/தன்/அது box)
  SELECT wg.id INTO v_group_id
  FROM word_groups wg
  JOIN poem_lines pl ON pl.id = wg.poem_line_id
  JOIN pages p ON p.id = pl.page_id
  WHERE p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 13 AND wg.position = 1;

  IF v_group_id IS NULL THEN
    RAISE EXCEPTION 'Box not found: line 13 position 1 (பலம்/உற/தன்/அது).';
  END IF;

  UPDATE word_groups SET
    combined_display_form = 'பலமுறத்தனது',
    combined_meaning = 'பலமுறத்தனது = பயன் மிகுதியாகத் தன்னுடைய; abundantly, its own'
  WHERE id = v_group_id;

  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (v_group_id, 0, 'மகர ஈறு கெட்டு உயிரெழுத்து தொடங்கும் சொல் இணையும்', 'பலம் + உற', 'பலமுற', NULL),
    (v_group_id, 1, 'ஒற்று மிகும் (குற்றியலுகர ஈறு + வல்லின முதல் எழுத்துடன் தொடங்கும் சொல்)', 'பலமுற + தன்', 'பலமுறத்தன்', 'த்'),
    (v_group_id, 2, 'னகர ஈறு + அகரம் தொடங்கும் சொல் இணையும்போது அகரம் மறைந்து இணையும்', 'பலமுறத்தன் + அது', 'பலமுறத்தனது', NULL)
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  RAISE NOTICE '✓ பலம்+உற+தன்+அது box fixed (id=%).', v_group_id;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT wg.combined_display_form, wg.combined_meaning, sr.connector_index, sr.before_form, sr.after_form
FROM word_groups wg
LEFT JOIN sandhi_rules sr ON sr.word_group_id = wg.id
JOIN poem_lines pl ON pl.id = wg.poem_line_id
WHERE pl.line_number = 13 AND wg.position = 1
ORDER BY sr.connector_index;
