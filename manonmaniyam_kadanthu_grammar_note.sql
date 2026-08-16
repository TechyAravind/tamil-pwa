-- ============================================================================
-- மனோன்மணீயம் — Line 1, கடந்து: backfill example for the new சொல்வகை fields
-- (structural_role / role_category on morphemes, combined_grammar_note on
-- word_groups). Run AFTER word_groups_phase3_migration.sql.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_l uuid;
  v_group_id uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  SELECT pl.id INTO v_l FROM poem_lines pl JOIN pages p ON p.id = pl.page_id
  WHERE p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி' AND pl.line_number = 1;

  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_l AND position = 5;
  IF v_group_id IS NULL THEN
    RAISE EXCEPTION 'Box not found: line 1 position 5 (கட/ந்/த்/உ).';
  END IF;

  -- bound-piece roles (specific tag + broad category)
  UPDATE morphemes SET structural_role = 'வினைப் பகுதி',              role_category = 'பகுதி'
    WHERE word_group_id = v_group_id AND position = 5;  -- கட
  UPDATE morphemes SET structural_role = 'சந்தி மெய் (த் இன் திரிபு)', role_category = 'சந்தி மெய்'
    WHERE word_group_id = v_group_id AND position = 6;  -- ந்
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை',          role_category = 'இடைநிலை'
    WHERE word_group_id = v_group_id AND position = 7;  -- த்
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி',          role_category = 'விகுதி'
    WHERE word_group_id = v_group_id AND position = 8;  -- உ

  -- whole-word grammar
  UPDATE word_groups SET
    combined_grammatical_label = 'வினைச்சொல்',
    combined_grammar_note = 'வினையெச்சம்'
  WHERE id = v_group_id;

  RAISE NOTICE '✓ Line1 கடந்து — சொல்வகை fields backfilled.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT m.position, m.display_form, m.structural_role, m.role_category
FROM morphemes m
JOIN poem_lines pl ON pl.id = m.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்' AND pl.line_number = 1
ORDER BY m.position;

SELECT wg.combined_display_form, wg.combined_grammatical_label, wg.combined_grammar_note
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
WHERE pl.line_number = 1 AND wg.position = 5;
