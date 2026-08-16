-- ============================================================================
-- மனோன்மணீயம் — Line 1 full classification pass: காலையில், கடிநகர், கடந்து
--
-- காலை/இல் and கடி/நகர் are word-COMPOUNDS — each piece is a real
-- standalone word with its own பெ/வி/இ/உ class (unlike கட/ந்/த்/உ inside
-- கடந்து, which are one verb's internal பகுதி+இடைநிலை+விகுதி morphology).
-- So these bound pieces get morphemes.grammatical_label directly, not
-- structural_role.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_l uuid;
  v_g1 uuid;  -- காலையில்
  v_g2 uuid;  -- கடிநகர்
  v_g3 uuid;  -- கடந்து
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  SELECT pl.id INTO v_l FROM poem_lines pl JOIN pages p ON p.id = pl.page_id
  WHERE p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி' AND pl.line_number = 1;

  SELECT id INTO v_g1 FROM word_groups WHERE poem_line_id = v_l AND position = 1;
  SELECT id INTO v_g2 FROM word_groups WHERE poem_line_id = v_l AND position = 3;
  SELECT id INTO v_g3 FROM word_groups WHERE poem_line_id = v_l AND position = 5;

  ------------------------------------------------------------------
  -- காலையில் = காலை (பெயர்ச்சொல்) + இல் (இடைச்சொல் — வேற்றுமை உருபு)
  -- No இலக்கணக்குறிப்பு — a plain case-inflected noun needs no special note.
  ------------------------------------------------------------------
  IF v_g1 IS NOT NULL THEN
    UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE word_group_id = v_g1 AND position = 1; -- காலை
    UPDATE morphemes SET grammatical_label = 'இடைச்சொல்'   WHERE word_group_id = v_g1 AND position = 2; -- இல்
    UPDATE word_groups SET
      combined_grammatical_label = 'பெயர்ச்சொல்',
      combined_grammar_note = NULL
    WHERE id = v_g1;
  END IF;

  ------------------------------------------------------------------
  -- கடிநகர் = கடி (உரிச்சொல்) + நகர் (பெயர்ச்சொல்)
  -- இலக்கணக்குறிப்பு: உரிச்சொல் தொடர்
  ------------------------------------------------------------------
  IF v_g2 IS NOT NULL THEN
    UPDATE morphemes SET grammatical_label = 'உரிச்சொல்'   WHERE word_group_id = v_g2 AND position = 3; -- கடி
    UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE word_group_id = v_g2 AND position = 4; -- நகர்
    UPDATE word_groups SET
      combined_grammatical_label = 'பெயர்ச்சொல்',
      combined_grammar_note = 'உரிச்சொல் தொடர்'
    WHERE id = v_g2;
  END IF;

  ------------------------------------------------------------------
  -- கடந்து = கட (வினைச்சொல், verb root — AND its structural role is
  -- வினைப் பகுதி) + ந்/த்/உ (pure sub-word morphology, structural_role only)
  -- இலக்கணக்குறிப்பு: வினையெச்சம் (already set by the earlier backfill,
  -- reasserted here for completeness)
  ------------------------------------------------------------------
  IF v_g3 IS NOT NULL THEN
    UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE word_group_id = v_g3 AND position = 5; -- கட
    UPDATE word_groups SET
      combined_grammatical_label = 'வினைச்சொல்',
      combined_grammar_note = 'வினையெச்சம்'
    WHERE id = v_g3;
  END IF;

  RAISE NOTICE '✓ Line1 classification complete: காலையில், கடிநகர், கடந்து.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT m.position, m.display_form, m.grammatical_label, m.structural_role, m.role_category
FROM morphemes m
JOIN poem_lines pl ON pl.id = m.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்' AND pl.line_number = 1
ORDER BY m.position;

SELECT wg.position, wg.combined_display_form, wg.combined_grammatical_label, wg.combined_grammar_note
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
WHERE pl.line_number = 1
ORDER BY wg.position;
