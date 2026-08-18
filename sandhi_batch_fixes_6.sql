-- ============================================================================
-- Fixes 2 of last batch's 3 that silently no-op'd (both relied on an
-- already-existing row and NULL explicit forms — அது + அன் had no row at
-- all, and "உயர்த்த்" isn't a real single tile, so the text match for it
-- found nothing). This time every category gets an explicit before/after
-- form so nothing can be skipped for that reason again.
--
-- Plus: தாங்கு + இ (reclassify to கு சு து பு | உயிர்) and the new
-- ஈக்கள் + ஐ (மெ | உ, norm rule).
-- ============================================================================

DO $$
DECLARE
  spec RECORD;
  wg_id uuid;
  conn_idx int;
  bform text;
  aform text;
  part1 text;
  part2 text;
  elided text;
  step1_result text;
  step2_result text;
  pulli text := chr(3021);
  vowel_sign_u text := chr(3009);
BEGIN
  -- ── Simple two-tile pairs ──────────────────────────────────────────────
  FOR spec IN
    SELECT * FROM (VALUES
      ('அது',   'அன்', 'மு_உயிர்', 'அது + அன்',   'அதன்'),
      ('தாங்கு','இ',   'கு_சு_து_பு', 'தாங்கு + இ', 'தாங்கி'),
      ('ஈக்கள்','ஐ',   'மெ_உ',     'ஈக்கள் + ஐ',  'ஈக்களை')
    ) AS t(left_text, right_text, category, explicit_before, explicit_after)
  LOOP
    SELECT m1.word_group_id,
           (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position)
      INTO wg_id, conn_idx
    FROM morphemes m1
    JOIN morphemes m2 ON m2.word_group_id = m1.word_group_id AND m2.is_separator = false
      AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.position > m1.position AND x.is_separator = false)
    WHERE m1.display_form = spec.left_text AND m2.display_form = spec.right_text AND m1.is_separator = false
    LIMIT 1;

    IF wg_id IS NULL THEN
      RAISE NOTICE '✗ Could not find % → %.', spec.left_text, spec.right_text;
      CONTINUE;
    END IF;

    SELECT COALESCE(sr.before_form, spec.explicit_before), COALESCE(sr.after_form, spec.explicit_after)
      INTO bform, aform
    FROM (SELECT 1) x
    LEFT JOIN sandhi_rules sr ON sr.word_group_id = wg_id AND sr.connector_index = conn_idx;

    IF spec.category = 'மு_உயிர்' THEN
      part1 := trim(split_part(bform, ' + ', 1));
      part2 := trim(split_part(bform, ' + ', 2));
      IF right(part1, 1) = vowel_sign_u THEN elided := left(part1, length(part1) - 1) || pulli; ELSE elided := part1; END IF;
      step1_result := elided || ' + «உ» + ' || part2 || ' → ' || elided || ' + ' || part2;
      step2_result := elided || ' + ' || part2 || ' = ' || aform;

      IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
        UPDATE sandhi_rules SET
          mnemonic_tag = 'மு | உயிர்', mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb, changed_letter = NULL,
          before_form = bform, after_form = aform,
          rule_steps = jsonb_build_array(
            jsonb_build_object('condition','விதி 1','rule','முற்றும் அற்று ஒரோவழி','result',step1_result),
            jsonb_build_object('condition','விதி 2','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',step2_result))
        WHERE word_group_id = wg_id AND connector_index = conn_idx;
      ELSE
        INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
        VALUES (wg_id, conn_idx, bform, aform, NULL, 'மு | உயிர்', '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb,
          jsonb_build_array(
            jsonb_build_object('condition','விதி 1','rule','முற்றும் அற்று ஒரோவழி','result',step1_result),
            jsonb_build_object('condition','விதி 2','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',step2_result)));
      END IF;

    ELSIF spec.category = 'கு_சு_து_பு' THEN
      part1 := trim(split_part(bform, ' + ', 1));
      part2 := trim(split_part(bform, ' + ', 2));
      IF right(part1, 1) = vowel_sign_u THEN elided := left(part1, length(part1) - 1) || pulli; ELSE elided := part1; END IF;
      step1_result := elided || ' + «உ» + ' || part2 || ' → ' || elided || ' + ' || part2;
      step2_result := elided || ' + ' || part2 || ' = ' || aform;

      UPDATE sandhi_rules SET
        mnemonic_tag = 'கு சு து பு | உயிர்', mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "கு | உயிர்", "கு சு து பு | உயிர்"]'::jsonb, changed_letter = NULL,
        before_form = bform, after_form = aform,
        rule_steps = jsonb_build_array(
          jsonb_build_object('condition','விதி 1','rule','உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்','result',step1_result),
          jsonb_build_object('condition','விதி 2','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',step2_result))
      WHERE word_group_id = wg_id AND connector_index = conn_idx;

    ELSIF spec.category = 'மெ_உ' THEN
      IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
        UPDATE sandhi_rules SET
          mnemonic_tag = 'மெ | உ', mnemonic_hierarchy = '["மெ | உ"]'::jsonb, changed_letter = NULL,
          before_form = bform, after_form = aform,
          rule_steps = jsonb_build_array(
            jsonb_build_object('condition','விதி','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',bform),
            jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform))
        WHERE word_group_id = wg_id AND connector_index = conn_idx;
      ELSE
        INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
        VALUES (wg_id, conn_idx, bform, aform, NULL, 'மெ | உ', '["மெ | உ"]'::jsonb,
          jsonb_build_array(
            jsonb_build_object('condition','விதி','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',bform),
            jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform)));
      END IF;
    END IF;
  END LOOP;

  ------------------------------------------------------------------
  -- உயர்த்தி — "உயர்த்த்" is 4 separate tiles (உயர் / த் / த் / இ), not one
  -- tile, so it's located as a chain and the LAST connector (2nd த் → இ)
  -- is the one fixed, same structure as முளைத்த் earlier.
  ------------------------------------------------------------------
  DECLARE
    wg2 uuid; ci2 int;
  BEGIN
    SELECT m3.word_group_id,
           (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m3.word_group_id AND x.is_separator = false AND x.position < m3.position)
      INTO wg2, ci2
    FROM morphemes m0
    JOIN morphemes m1 ON m1.word_group_id = m0.word_group_id AND m1.is_separator = false
      AND m1.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m0.position AND x.is_separator = false)
    JOIN morphemes m2 ON m2.word_group_id = m0.word_group_id AND m2.is_separator = false
      AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m1.position AND x.is_separator = false)
    JOIN morphemes m3 ON m3.word_group_id = m0.word_group_id AND m3.is_separator = false
      AND m3.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m2.position AND x.is_separator = false)
    WHERE m0.display_form = 'உயர்' AND m1.display_form = 'த்' AND m2.display_form = 'த்' AND m3.display_form = 'இ'
      AND m0.is_separator = false
    LIMIT 1;

    IF wg2 IS NULL THEN
      RAISE NOTICE '✗ Could not find the உயர் / த் / த் / இ chain.';
    ELSE
      UPDATE sandhi_rules SET
        mnemonic_tag = 'மெ | உ', mnemonic_hierarchy = '["மெ | உ"]'::jsonb, changed_letter = NULL,
        before_form = 'உயர்த்த் + இ', after_form = 'உயர்த்தி',
        rule_steps = '[
          {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "உயர்த்த் + இ"},
          {"condition": "விளைவு", "rule": "உயர்த்த் + இ → உயர்த்தி", "result": "உயர்த்தி"}
        ]'::jsonb
      WHERE word_group_id = wg2 AND connector_index = ci2;

      IF NOT FOUND THEN
        INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
        VALUES (wg2, ci2, 'உயர்த்த் + இ', 'உயர்த்தி', NULL, 'மெ | உ', '["மெ | உ"]'::jsonb, '[
          {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "உயர்த்த் + இ"},
          {"condition": "விளைவு", "rule": "உயர்த்த் + இ → உயர்த்தி", "result": "உயர்த்தி"}
        ]'::jsonb);
      END IF;
      RAISE NOTICE '✓ உயர்த்தி fixed: word_group_id=%, connector_index=%', wg2, ci2;
    END IF;
  END;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, mnemonic_hierarchy, rule_steps
FROM sandhi_rules
WHERE before_form IN ('அது + அன்', 'தாங்கு + இ', 'ஈக்கள் + ஐ', 'உயர்த்த் + இ')
ORDER BY before_form;
