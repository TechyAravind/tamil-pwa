-- ============================================================================
-- மனோன்மணீயம் — fix combined_display_form for EVERY word_group
--
-- WHY: the fully-combined ("double-tap") view of a box reads
-- word_groups.combined_display_form directly — it is a stored column, not
-- something recomputed live from the individual sandhi_rules steps. The
-- earlier scripts added ~240 connector-level sandhi_rules (so tapping "+"
-- one connector at a time now shows the right form), but only the 19
-- restructured lines got their combined_display_form corrected. Every other
-- box still has the old raw concatenation (e.g. "எவினைஓர்குஉம்" instead of
-- "எவ்வினையோர்க்கும்") in that one field, which is what you saw.
--
-- WHAT THIS DOES: for every word_group in மனோன்மணீயம், it walks the
-- group's morphemes in order and rebuilds the correct combined form by
-- applying whatever sandhi_rules already exist for each connector (falling
-- back to plain concatenation where no rule exists) — i.e. it derives the
-- "double-tap" text the same way the app derives each individual "+" tap,
-- so the two now agree. It does NOT touch combined_meaning.
--
-- Run this AFTER manonmaniyam_evvinai_rebuild.sql. Safe to re-run any time
-- you add more sandhi_rules later — just run this again and it will
-- recompute every combined_display_form fresh.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  grp_rec RECORD;
  morph_rec RECORD;
  cur_form text;
  idx int;
  rule_after text;
  n_updated int := 0;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'மனோன்மணீயம் topic not found.';
  END IF;

  FOR grp_rec IN
    SELECT wg2.id
    FROM word_groups wg2
    JOIN poem_lines pl2 ON pl2.id = wg2.poem_line_id
    JOIN pages p2 ON p2.id = pl2.page_id
    WHERE p2.topic_id = v_topic_id AND p2.page_type = 'செய்யுள் பகுதி'
  LOOP
    cur_form := NULL;
    idx := 0;
    FOR morph_rec IN SELECT display_form FROM morphemes WHERE word_group_id = grp_rec.id ORDER BY position LOOP
      IF cur_form IS NULL THEN
        cur_form := morph_rec.display_form;
      ELSE
        SELECT after_form INTO rule_after FROM sandhi_rules
        WHERE word_group_id = grp_rec.id AND connector_index = idx;
        IF rule_after IS NOT NULL THEN
          cur_form := rule_after;
        ELSE
          cur_form := cur_form || morph_rec.display_form;
        END IF;
        idx := idx + 1;
      END IF;
    END LOOP;
    UPDATE word_groups SET combined_display_form = cur_form WHERE id = grp_rec.id;
    n_updated := n_updated + 1;
  END LOOP;

  RAISE NOTICE '✓ Recomputed combined_display_form for % word_groups.', n_updated;
END $$;

-- ── Verify: spot-check the box from your screenshot ─────────────────────────
SELECT pl.line_number, wg.combined_display_form
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்' AND pl.line_number = 4
ORDER BY wg.position;
