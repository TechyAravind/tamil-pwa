-- ============================================================================
-- மனோன்மணீயம் — Line 1: split கடந்து into proper stepped morphemes
--
-- Old state: "கடந்து" was stored as ONE standalone morpheme (position 5,
-- no word_group) — so it could never be tapped apart, it just always
-- showed the finished meaning.
--
-- New state: a real word_group with 4 morphemes —
--   கட  (root, its own meaning)  +  ந்  +  த்  +  உ
-- Tapping "+" step by step:
--   கட + ந்   -> கடந்   (still shows the root meaning — "இன்னும் முழுச்
--                          சொல் இல்லை", exactly like the முடி box you
--                          showed me)
--   கடந் + த் -> கடந்த்  (same — still just a part of the word)
--   கடந்த் + உ -> கடந்து (double-tap final box — shows the REAL meaning
--                          "கடந்து சென்று; having crossed")
--
-- நமது (which was position 6, right after கடந்து) is shifted to position 9
-- to make room for கடந்து's 4 morphemes (positions 5,6,7,8). Safe to re-run.
-- ============================================================================

DO $$
DECLARE
  v_topic_id  uuid;
  v_line_id   uuid;
  v_group_id  uuid;
  v_old_exists boolean;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'மனோன்மணீயம் topic not found.';
  END IF;

  SELECT pl.id INTO v_line_id
  FROM poem_lines pl
  JOIN pages p ON p.id = pl.page_id
  WHERE p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி' AND pl.line_number = 1;

  IF v_line_id IS NULL THEN
    RAISE EXCEPTION 'Line 1 not found.';
  END IF;

  -- Has the old un-split "கடந்து" morpheme not been replaced yet?
  SELECT EXISTS (
    SELECT 1 FROM morphemes
    WHERE poem_line_id = v_line_id AND position = 5
      AND display_form = 'கடந்து' AND word_group_id IS NULL
  ) INTO v_old_exists;

  IF v_old_exists THEN
    -- Make room: shift "நமது" from position 6 to position 9
    UPDATE morphemes SET position = 9
    WHERE poem_line_id = v_line_id AND position = 6 AND display_form = 'நமது';

    -- Remove the old single-chip "கடந்து"
    DELETE FROM morphemes
    WHERE poem_line_id = v_line_id AND position = 5 AND display_form = 'கடந்து' AND word_group_id IS NULL;

    RAISE NOTICE 'Old standalone கடந்து removed, நமது shifted to position 9.';
  END IF;

  -- Find (or create) the word_group at position 5 for this line
  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_line_id AND position = 5;

  IF v_group_id IS NULL THEN
    INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
    VALUES (v_line_id, 5, 'கடந்து', 'கடந்து = கடந்து சென்று; having crossed')
    RETURNING id INTO v_group_id;
  ELSE
    UPDATE word_groups SET
      combined_display_form = 'கடந்து',
      combined_meaning = 'கடந்து = கடந்து சென்று; having crossed'
    WHERE id = v_group_id;
  END IF;

  -- (Re)insert the 4 morphemes, idempotent via delete-then-insert for this group
  DELETE FROM morphemes WHERE word_group_id = v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_verb, is_separator, word_group_id) VALUES
    (v_line_id, 5, 'கட', 'கடத்தல் பகுதி; to cross', true, false, v_group_id),
    (v_line_id, 6, 'ந்',  'இறந்தகால இடைநிலை; past-tense marker', false, false, v_group_id),
    (v_line_id, 7, 'த்',  'இறந்தகால இடைநிலை; past-tense marker', false, false, v_group_id),
    (v_line_id, 8, 'உ',   'வினையெச்ச விகுதி; participle ending', false, false, v_group_id);

  -- Step-by-step sandhi rules: connector 0 and 1 keep the "not finished yet"
  -- root meaning (so the intermediate chip reads like the முடிக்/முடிக்கு
  -- example you showed), connector 2 is the real final combine.
  INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
    (v_group_id, 0, 'கடத்தல் பகுதி; to cross (இன்னும் முழுச் சொல் ஆகவில்லை)', 'கட + ந்', 'கடந்', 'ந்'),
    (v_group_id, 1, 'கடத்தல் பகுதி; to cross (இன்னும் முழுச் சொல் ஆகவில்லை)', 'கடந் + த்', 'கடந்த்', 'த்'),
    (v_group_id, 2, 'கடந்து சென்று; having crossed', 'கடந்த் + உ', 'கடந்து', 'உ')
  ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
    rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form,
    after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;

  RAISE NOTICE '✓ கடந்து rebuilt as a 4-morpheme word_group (id=%).', v_group_id;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT m.position, m.display_form, m.word_meaning, m.word_group_id
FROM morphemes m
JOIN poem_lines pl ON pl.id = m.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்' AND pl.line_number = 1
ORDER BY m.position;
