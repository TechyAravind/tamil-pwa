-- ============================================================================
-- Batch fix: இயல்புப் புணர்ச்சி fills, மெ|உ / மு|உயிர் reclassifications,
-- and the new பண்பு (பண்புப்பெயர்ப் புணர்ச்சி, ஈறு போதல்) family.
--
-- Every connector below is located by matching the actual adjacent
-- morpheme text within its word_group (never a guessed line/position), so
-- this is safe to re-run and applies wherever the same pair occurs.
--
-- Categories:
--   'இயல்புப்' — like கடி + நகர்: no real sandhi, changed_letter = NULL,
--     2-step இயல்புப் புணர்ச்சி / எந்த விதிகளும் இல்லை template.
--   'மெ_உ'     — மெ | உ family, single-step norm rule (உடல்மேல் உயிர்வந்து
--     ஒன்றுவது இயல்பே) — these already failed the தனிக்குறில் test.
--   'மு_உயிர்' — முற்றியலுகரம் (single short-vowel prefix before a
--     "குற்றியலுகரம்-looking" ending) — the உ still drops (elision,
--     shown with the «உ» strike marker), rule "முற்றும் அற்று ஒரோவழி".
--   'பண்பு'    — பண்புப்பெயர்ப் புணர்ச்சி (words ending in "மை"): ஈறு
--     போதல் — the whole "மை" ending is simply dropped, single step.
--
-- For pairs whose sandhi_rules row already exists (போல்+ஆம், உயர்த்த்+இ,
-- அது+அன்), the row's OWN stored before_form/after_form are reused as-is
-- (this avoids the trailing-period mismatch that made an earlier fix to
-- போல் + ஆம். silently miss). For brand-new pairs (no row yet — உயிர்+க்,
-- க்+கு, தூண்டு+கோல், சாரு+தல், முளைத்த்(2nd)+அ, சிறுமை+புல், சிறுமை+பூ)
-- explicit before_form/after_form are supplied and a new row is inserted.
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
  pulli text := chr(3021);        -- ்
  vowel_sign_u text := chr(3009); -- ு
BEGIN
  FOR spec IN
    SELECT * FROM (VALUES
      -- (left_text, right_text, category, explicit_before, explicit_after)
      ('உயிர்',   'க்',   'இயல்புப்', 'உயிர் + க்',       'உயிர்க்'),
      ('க்',      'கு',   'இயல்புப்', 'க் + கு',          'க்கு'),
      ('தூண்டு',  'கோல்', 'இயல்புப்', 'தூண்டு + கோல்',    'தூண்டுகோல்'),
      ('சாரு',    'தல்',  'இயல்புப்', 'சாரு + தல்',       'சாருதல்'),
      ('போல்',    'ஆம்.', 'மெ_உ',     NULL,               NULL),
      ('த்',      'அ',    'மெ_உ',     'முளைத்த் + அ',     'முளைத்த'),
      ('உயர்த்த்','இ',    'மெ_உ',     NULL,               NULL),
      ('அது',     'அன்',  'மு_உயிர்', NULL,               NULL),
      ('சிறுமை',  'புல்', 'பண்பு',    'சிறுமை + புல்',    'சிறுபுல்'),
      ('சிறுமை',  'பூ',   'பண்பு',    'சிறுமை + பூ',      'சிறுபூ')
    ) AS t(left_text, right_text, category, explicit_before, explicit_after)
  LOOP
    -- Locate the connector by matching the actual adjacent morpheme pair.
    SELECT m1.word_group_id,
           (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position)
      INTO wg_id, conn_idx
    FROM morphemes m1
    JOIN morphemes m2 ON m2.word_group_id = m1.word_group_id AND m2.is_separator = false
      AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.position > m1.position AND x.is_separator = false)
    WHERE m1.display_form = spec.left_text AND m2.display_form = spec.right_text AND m1.is_separator = false
    LIMIT 1;

    IF wg_id IS NULL THEN
      RAISE NOTICE '✗ Could not find % → % — check exact spelling on your live DB.', spec.left_text, spec.right_text;
      CONTINUE;
    END IF;

    -- Use the row's own stored before/after form if it already exists;
    -- otherwise fall back to the explicit values supplied above.
    SELECT sr.before_form, sr.after_form INTO bform, aform
    FROM sandhi_rules sr WHERE sr.word_group_id = wg_id AND sr.connector_index = conn_idx;

    IF bform IS NULL THEN
      bform := spec.explicit_before;
      aform := spec.explicit_after;
    END IF;

    IF bform IS NULL THEN
      RAISE NOTICE '✗ % → %: no existing row AND no explicit form supplied — skipped.', spec.left_text, spec.right_text;
      CONTINUE;
    END IF;

    IF spec.category = 'இயல்புப்' THEN
      IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
        UPDATE sandhi_rules SET
          mnemonic_tag = NULL, mnemonic_hierarchy = NULL, changed_letter = NULL,
          before_form = bform, after_form = aform,
          rule_steps = jsonb_build_array(
            jsonb_build_object('condition','இயல்புப் புணர்ச்சி','rule','எந்த விதிகளும் இல்லை','result',bform),
            jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform)
          )
        WHERE word_group_id = wg_id AND connector_index = conn_idx;
      ELSE
        INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, rule_steps)
        VALUES (wg_id, conn_idx, bform, aform, NULL, NULL, jsonb_build_array(
          jsonb_build_object('condition','இயல்புப் புணர்ச்சி','rule','எந்த விதிகளும் இல்லை','result',bform),
          jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform)
        ));
      END IF;

    ELSIF spec.category = 'மெ_உ' THEN
      IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
        UPDATE sandhi_rules SET
          mnemonic_tag = 'மெ | உ', mnemonic_hierarchy = '["மெ | உ"]'::jsonb, changed_letter = NULL,
          before_form = bform, after_form = aform,
          rule_steps = jsonb_build_array(
            jsonb_build_object('condition','விதி','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',bform),
            jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform)
          )
        WHERE word_group_id = wg_id AND connector_index = conn_idx;
      ELSE
        INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
        VALUES (wg_id, conn_idx, bform, aform, NULL, 'மெ | உ', '["மெ | உ"]'::jsonb, jsonb_build_array(
          jsonb_build_object('condition','விதி','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',bform),
          jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform)
        ));
      END IF;

    ELSIF spec.category = 'மு_உயிர்' THEN
      part1 := trim(split_part(bform, ' + ', 1));
      part2 := trim(split_part(bform, ' + ', 2));
      IF right(part1, 1) = vowel_sign_u THEN
        elided := left(part1, length(part1) - 1) || pulli;
      ELSE
        elided := part1;
      END IF;
      step1_result := elided || ' + «உ» + ' || part2 || ' → ' || elided || ' + ' || part2;
      step2_result := elided || ' + ' || part2 || ' = ' || aform;

      IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
        UPDATE sandhi_rules SET
          mnemonic_tag = 'மு | உயிர்', mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb, changed_letter = NULL,
          rule_steps = jsonb_build_array(
            jsonb_build_object('condition','விதி 1','rule','முற்றும் அற்று ஒரோவழி','result',step1_result),
            jsonb_build_object('condition','விதி 2','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',step2_result)
          )
        WHERE word_group_id = wg_id AND connector_index = conn_idx;
      ELSE
        INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
        VALUES (wg_id, conn_idx, bform, aform, NULL, 'மு | உயிர்', '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb, jsonb_build_array(
          jsonb_build_object('condition','விதி 1','rule','முற்றும் அற்று ஒரோவழி','result',step1_result),
          jsonb_build_object('condition','விதி 2','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',step2_result)
        ));
      END IF;

    ELSIF spec.category = 'பண்பு' THEN
      IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
        UPDATE sandhi_rules SET
          mnemonic_tag = 'பண்பு', mnemonic_hierarchy = '["பண்புப்பெயர்"]'::jsonb, changed_letter = NULL,
          before_form = bform, after_form = aform,
          rule_steps = jsonb_build_array(
            jsonb_build_object('condition','விதி','rule','ஈறு போதல்','result',bform),
            jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform)
          )
        WHERE word_group_id = wg_id AND connector_index = conn_idx;
      ELSE
        INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
        VALUES (wg_id, conn_idx, bform, aform, NULL, 'பண்பு', '["பண்புப்பெயர்"]'::jsonb, jsonb_build_array(
          jsonb_build_object('condition','விதி','rule','ஈறு போதல்','result',bform),
          jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform)
        ));
      END IF;
    END IF;
  END LOOP;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT sr.before_form, sr.after_form, sr.mnemonic_tag, sr.mnemonic_hierarchy, sr.rule_steps
FROM sandhi_rules sr
WHERE sr.before_form IN (
  'உயிர் + க்', 'க் + கு', 'தூண்டு + கோல்', 'சாரு + தல்',
  'முளைத்த் + அ', 'உயர்த்த் + இ', 'அது + அன்',
  'சிறுமை + புல்', 'சிறுமை + பூ'
) OR sr.after_form LIKE 'போலாம்%'
ORDER BY sr.before_form;
