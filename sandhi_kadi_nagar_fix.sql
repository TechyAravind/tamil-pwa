-- ============================================================================
-- கடி + நகர் — guaranteed fix, take 2.
--
-- The previous fix (sandhi_step2_fix.sql) was an UPDATE ... WHERE before_form
-- = 'கடி + நகர்', which silently affected 0 rows: this connector never had a
-- sandhi_rules row to begin with (it was a plain dot from the start, never
-- authored). Your screenshot confirms the junction flag DID take (it's now a
-- tappable amber button, not a static dot) — it's just empty because there's
-- nothing in sandhi_rules for it to find.
--
-- This version locates the connector by morpheme TEXT (கடி immediately
-- followed by நகர் inside the same word_group), computes its real
-- word_group_id + connector_index directly from that, and INSERTs the rule
-- if missing / UPDATEs it if somehow already present — so it can't miss
-- regardless of line/position numbers.
-- ============================================================================

DO $$
DECLARE
  wg_id uuid;
  conn_idx int;
  morph_id uuid;
  existing_rule_id uuid;
BEGIN
  SELECT m1.word_group_id, m1.id
    INTO wg_id, morph_id
  FROM morphemes m1
  JOIN morphemes m2
    ON m2.word_group_id = m1.word_group_id
   AND m2.is_separator = false
   AND m2.position = (
     SELECT min(m3.position) FROM morphemes m3
     WHERE m3.word_group_id = m1.word_group_id
       AND m3.position > m1.position
       AND m3.is_separator = false
   )
  WHERE m1.display_form = 'கடி'
    AND m2.display_form = 'நகர்'
    AND m1.is_separator = false
  LIMIT 1;

  IF wg_id IS NULL THEN
    RAISE NOTICE '✗ Could not find a கடி → நகர் pair in morphemes. Check the exact display_form spelling/spacing.';
    RETURN;
  END IF;

  -- connector_index = how many non-separator morphemes in this group sit
  -- before கடி (0-based, matches units.indexOf in the app).
  SELECT count(*) INTO conn_idx
  FROM morphemes
  WHERE word_group_id = wg_id
    AND is_separator = false
    AND position < (SELECT position FROM morphemes WHERE id = morph_id);

  SELECT id INTO existing_rule_id
  FROM sandhi_rules
  WHERE word_group_id = wg_id AND connector_index = conn_idx;

  IF existing_rule_id IS NOT NULL THEN
    UPDATE sandhi_rules SET
      mnemonic_tag = NULL,
      before_form = 'கடி + நகர்',
      after_form = 'கடிநகர்',
      changed_letter = NULL,
      rule_steps = '[
        {"condition": "இயல்புப் புணர்ச்சி", "rule": "எந்த விதிகளும் இல்லை", "result": "கடி + நகர்"},
        {"condition": "விளைவு", "rule": "கடி + நகர் → கடிநகர்", "result": "கடிநகர்"}
      ]'::jsonb
    WHERE id = existing_rule_id;
    RAISE NOTICE '✓ Updated existing sandhi_rules row (id=%) for கடி + நகர்.', existing_rule_id;
  ELSE
    INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, rule_steps)
    VALUES (
      wg_id, conn_idx, 'கடி + நகர்', 'கடிநகர்', NULL, NULL,
      '[
        {"condition": "இயல்புப் புணர்ச்சி", "rule": "எந்த விதிகளும் இல்லை", "result": "கடி + நகர்"},
        {"condition": "விளைவு", "rule": "கடி + நகர் → கடிநகர்", "result": "கடிநகர்"}
      ]'::jsonb
    );
    RAISE NOTICE '✓ Inserted new sandhi_rules row for கடி + நகர் (word_group_id=%, connector_index=%).', wg_id, conn_idx;
  END IF;

  UPDATE morphemes SET is_sandhi_junction = true WHERE id = morph_id;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT wg.id AS word_group_id, sr.connector_index, sr.before_form, sr.after_form, sr.rule_steps
FROM sandhi_rules sr
JOIN word_groups wg ON wg.id = sr.word_group_id
WHERE sr.before_form = 'கடி + நகர்';
