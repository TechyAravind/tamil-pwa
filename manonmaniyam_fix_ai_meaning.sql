-- ============================================================================
-- மனோன்மணீயம் — fix meaning of the "ஐ" morpheme in the வை-type verb endings
--
-- நன்மண்ணாக்கு + ஐ = நன்மண்ணாக்குவை and ஒளிக்கு + ஐ = ஒளிக்குவை: here "ஐ"
-- is NOT the accusative case marker — it's the முன்னிலை ஒருமை வினைமுற்று
-- விகுதி (2nd person singular verb ending, "you [do]"), same role the
-- original "வை" chip had. Fixing the chip meaning to match.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_poem_page_id uuid;
  v_l uuid;
  v_group_id uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  -- Line 32: நன்மண்ணாக்கு + ஐ
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 32;
  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_l AND position = 6;
  IF v_group_id IS NOT NULL THEN
    UPDATE morphemes SET
      word_meaning = 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person singular ending'
    WHERE word_group_id = v_group_id AND position = 9 AND display_form = 'ஐ';
  END IF;

  -- Line 37: ஒளிக்கு + ஐ
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 37;
  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_l AND position = 1;
  IF v_group_id IS NOT NULL THEN
    UPDATE morphemes SET
      word_meaning = 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person singular ending'
    WHERE word_group_id = v_group_id AND position = 5 AND display_form = 'ஐ';
  END IF;

  RAISE NOTICE '✓ ஐ chip meanings fixed on lines 32 and 37.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, m.position, m.display_form, m.word_meaning
FROM morphemes m
JOIN poem_lines pl ON pl.id = m.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்' AND pl.line_number IN (32, 37) AND m.display_form = 'ஐ'
ORDER BY pl.line_number;
