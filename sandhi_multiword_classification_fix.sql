-- ============================================================================
-- Four connector fixes across the எவ்வினையோர்க்கும், பயக்கும், வேண்டும்
-- word groups, located by matching the actual adjacent morpheme text (not
-- guessed line/position), so this applies correctly everywhere the same
-- pair occurs in the poem.
--
--   வினை → ஓர்   : இ ஈ ஐ | உயிர்  (எவ்வினை ends in ஐ; இ ஈ ஐ வழி யவ்வும்,
--                   ய் glide inserted, then உடல்மேல் உயிர்வந்து ஒன்றுவது
--                   இயல்பே)
--   ஓர் → கு     : left untouched, per "leave this point empty"
--   கு → உம்     : கு சு து பு | உயிர்  (குற்றியலுகர உகர elision — கு drops
--                   its உ before உம்)
--   பயக்கு → உம் : கு சு து பு | உயிர்  (same elision pattern)
--   வேண்டு → உம் : கு சு து பு | உயிர்  (same elision pattern — per your
--                   explicit instruction this specific வேண்டு+உம்
--                   combination classifies under கு சு து பு, distinct
--                   from the earlier வேண்டு + இன் case)
-- ============================================================================

DO $$
DECLARE
  rec RECORD;
  wg_id uuid;
  conn_idx int;
  left_morph_id uuid;
  before_form text;
  after_form text;
  part1 text;
  part2 text;
  elided text;
  step1_result text;
  step2_result text;
  n int;
  pulli text := chr(3021);       -- ்
  vowel_sign_u text := chr(3009); -- ு
BEGIN
  ------------------------------------------------------------------
  -- 1. வினை → ஓர் : இ ஈ ஐ | உயிர் (glide insertion)
  ------------------------------------------------------------------
  n := 0;
  FOR rec IN
    SELECT m1.word_group_id AS wg, m1.id AS lid,
           (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position) AS ci
    FROM morphemes m1
    JOIN morphemes m2 ON m2.word_group_id = m1.word_group_id AND m2.is_separator = false
      AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.position > m1.position AND x.is_separator = false)
    WHERE m1.display_form = 'வினை' AND m2.display_form = 'ஓர்' AND m1.is_separator = false
  LOOP
    SELECT sr.before_form, sr.after_form INTO before_form, after_form
    FROM sandhi_rules sr WHERE sr.word_group_id = rec.wg AND sr.connector_index = rec.ci;

    IF before_form IS NULL THEN
      before_form := 'வினை + ஓர்'; after_form := 'வினையோர்';
    END IF;
    part1 := trim(split_part(before_form, ' + ', 1));
    part2 := trim(split_part(before_form, ' + ', 2));
    step1_result := part1 || ' + ய் + ' || part2 || ' → ' || part1 || 'ய் + ' || part2;
    step2_result := part1 || 'ய் + ' || part2 || ' = ' || after_form;

    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = rec.wg AND connector_index = rec.ci) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = 'இ ஈ ஐ | உயிர்', mnemonic_hierarchy = '["உ | உ", "இ ஈ ஐ | உயிர்"]'::jsonb,
        changed_letter = 'ய்',
        rule_steps = jsonb_build_array(
          jsonb_build_object('condition','விதி 1','rule','இ ஈ ஐ வழி யவ்வும்','result',step1_result),
          jsonb_build_object('condition','விதி 2','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',step2_result)
        )
      WHERE word_group_id = rec.wg AND connector_index = rec.ci;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
      VALUES (rec.wg, rec.ci, before_form, after_form, 'ய்', 'இ ஈ ஐ | உயிர்', '["உ | உ", "இ ஈ ஐ | உயிர்"]'::jsonb,
        jsonb_build_array(
          jsonb_build_object('condition','விதி 1','rule','இ ஈ ஐ வழி யவ்வும்','result',step1_result),
          jsonb_build_object('condition','விதி 2','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',step2_result)
        ));
    END IF;
    n := n + 1;
  END LOOP;
  RAISE NOTICE '✓ வினை → ஓர்: % row(s) fixed.', n;

  ------------------------------------------------------------------
  -- 2. கு → உம், பயக்கு → உம், வேண்டு → உம் : கு சு து பு | உயிர் (elision)
  ------------------------------------------------------------------
  n := 0;
  FOR rec IN
    SELECT m1.word_group_id AS wg, m1.id AS lid,
           (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position) AS ci
    FROM morphemes m1
    JOIN morphemes m2 ON m2.word_group_id = m1.word_group_id AND m2.is_separator = false
      AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.position > m1.position AND x.is_separator = false)
    WHERE m1.display_form IN ('கு', 'பயக்கு', 'வேண்டு') AND m2.display_form = 'உம்' AND m1.is_separator = false
  LOOP
    SELECT sr.before_form, sr.after_form INTO before_form, after_form
    FROM sandhi_rules sr WHERE sr.word_group_id = rec.wg AND sr.connector_index = rec.ci;

    IF before_form IS NULL THEN
      CONTINUE; -- need a real after_form to compute the result; skip if we can't find one
    END IF;

    part1 := trim(split_part(before_form, ' + ', 1));
    part2 := trim(split_part(before_form, ' + ', 2));

    IF right(part1, 1) = vowel_sign_u THEN
      elided := left(part1, length(part1) - 1) || pulli;
    ELSE
      elided := part1;
    END IF;

    step1_result := elided || ' + «உ» + ' || part2 || ' → ' || elided || ' + ' || part2;
    step2_result := elided || ' + ' || part2 || ' = ' || after_form;

    UPDATE sandhi_rules SET
      mnemonic_tag = 'கு சு து பு | உயிர்',
      mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "கு | உயிர்", "கு சு து பு | உயிர்"]'::jsonb,
      changed_letter = NULL,
      rule_steps = jsonb_build_array(
        jsonb_build_object('condition','விதி 1','rule','உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்','result',step1_result),
        jsonb_build_object('condition','விதி 2','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',step2_result)
      )
    WHERE word_group_id = rec.wg AND connector_index = rec.ci;
    n := n + 1;
  END LOOP;
  RAISE NOTICE '✓ கு/பயக்கு/வேண்டு → உம்: % row(s) fixed.', n;

  -- ஓர் → கு is intentionally left untouched ("leave this point empty").
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT sr.before_form, sr.after_form, sr.mnemonic_tag, sr.changed_letter, sr.rule_steps
FROM sandhi_rules sr
WHERE sr.before_form LIKE 'வினை%' OR sr.before_form LIKE 'கு %' OR sr.before_form LIKE 'பயக்கு%' OR sr.before_form LIKE 'வேண்டு%'
ORDER BY sr.before_form;
