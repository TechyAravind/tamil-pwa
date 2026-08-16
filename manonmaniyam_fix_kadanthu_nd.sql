-- ============================================================================
-- மனோன்மணீயம் — Line 1, கடந்து: fix the 2nd chip's meaning
--
-- The 2nd piece "ந்" is not itself the past-tense marker — it's a சந்தி
-- (junction) consonant, the mutated/realised form of "த்" (the actual
-- இறந்தகால இடைநிலை is the 3rd piece). Correcting the label.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_l uuid;
  v_group_id uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;

  SELECT pl.id INTO v_l
  FROM poem_lines pl JOIN pages p ON p.id = pl.page_id
  WHERE p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி' AND pl.line_number = 1;

  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_l AND position = 5;
  IF v_group_id IS NULL THEN
    RAISE NOTICE 'NOT FOUND: line1 position5 (கட/ந்/த்/உ box)';
  ELSE
    UPDATE morphemes SET
      word_meaning = 'சந்தி மெய் — த் என்பதன் திரிபு வடிவம்; junction consonant (mutated form of த்)'
    WHERE word_group_id = v_group_id AND position = 6 AND display_form = 'ந்';
    RAISE NOTICE '✓ Line1 ந் chip meaning corrected.';
  END IF;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT m.position, m.display_form, m.word_meaning
FROM morphemes m
JOIN poem_lines pl ON pl.id = m.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்' AND pl.line_number = 1
ORDER BY m.position;
