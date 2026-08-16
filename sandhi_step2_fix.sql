-- ============================================================================
-- சொற்களின் புணர்ச்சி (Sandhi) தாவல் — step 2 result fix + கடி + நகர்
--
-- BUG in sandhi_nurpa_correction.sql: step 2's "result" field was built as
-- before_form || ' = ' || after_form — i.e. the ORIGINAL "காலை + இல்",
-- silently dropping the inserted glide letter that step 1 had just shown
-- forming "காலைய் + இல்". Per your document's own worked example, step 2
-- must carry the GLIDE-INSERTED intermediate form forward:
--   விதி 2: உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே → காலைய் + இல் = காலையில்
-- not "காலை + இல் = காலையில்". This re-runs the நூற்பா pass for every
-- mnemonic-tagged row with that fixed, so it corrects every occurrence of
-- the same bug across the whole poem, not just காலை + இல்.
--
-- Also includes a guaranteed, direct fix for கடி + நகர் — same pattern as
-- the காலை + இல் fix from corrections_3.sql, since the indirect
-- group-verb-flag matching in that script evidently still isn't reaching
-- this specific row on your live database.
--
-- Safe to re-run.
-- ============================================================================

-- ── Re-run நூற்பா step generation with the step-2 glide bug fixed ─────────
DO $$
DECLARE
  rec RECORD;
  part1 text;
  part2 text;
  sutra1 text;
  sutra2 text;
  glided_before text;
  step1_result text;
  step2_result text;
  steps jsonb;
BEGIN
  FOR rec IN
    SELECT id, mnemonic_tag, before_form, after_form, changed_letter
    FROM sandhi_rules
    WHERE mnemonic_tag IS NOT NULL
  LOOP
    part1 := trim(split_part(rec.before_form, ' + ', 1));
    part2 := trim(split_part(rec.before_form, ' + ', 2));

    sutra1 := NULL;
    sutra2 := NULL;

    CASE rec.mnemonic_tag
      WHEN 'இ ஈ ஐ | உயிர்' THEN
        sutra1 := 'இ ஈ ஐ வழி யவ்வும்'; sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்' THEN
        sutra1 := 'ஏனை உயிர்வழி வவ்வும்'; sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'ஏ | உயிர்' THEN
        sutra1 := 'ஏமுன் இவ்விருமையும்'; sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'உ | உயிர்' THEN
        sutra1 := 'உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்'; sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'கு சு து பு | உயிர்' THEN
        sutra1 := 'உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்'; sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'டு று | உயிர்' THEN
        sutra1 := 'உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்'; sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'நெடில் தொடர்க் குற்றியலுகரம் | உயிர்' THEN
        sutra1 := 'நெடிலோடு உயிர்த்தொடர்க் குற்றுகரங்களுள் டறஒற்று இரட்டும் வேற்றுமை மிகவே'; sutra2 := NULL;
      WHEN 'உயிர்த்தொடர்க் குற்றியலுகரம் | உயிர்' THEN
        sutra1 := 'நெடிலோடு உயிர்த்தொடர்க் குற்றுகரங்களுள் டறஒற்று இரட்டும் வேற்றுமை மிகவே'; sutra2 := NULL;
      WHEN 'நெடில்/உயிர்த் தொடர் | உயிர்' THEN
        sutra1 := 'நெடிலோடு உயிர்த்தொடர்க் குற்றுகரங்களுள் டறஒற்று இரட்டும் வேற்றுமை மிகவே'; sutra2 := NULL;
      WHEN 'மு | உயிர்' THEN
        sutra1 := 'முற்றும் அற்று ஒரோவழி'; sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'உ | மெ' THEN
        sutra1 := 'இயல்பினும் விதியினும் நின்ற உயிர்முன் க ச த ப மிகும்'; sutra2 := NULL;
      WHEN 'மெ | உ' THEN
        sutra1 := 'தனிக்குறில்முன் ஒற்று உயிர்வரின் இரட்டும்'; sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'பூ | மெய்' THEN
        sutra1 := 'பூப்பெயர்முன் இனமென்மையும் தோன்றும்'; sutra2 := NULL;
      ELSE
        sutra1 := NULL;
    END CASE;

    IF sutra1 IS NULL THEN
      CONTINUE;
    END IF;

    -- The glide-inserted intermediate form (e.g. "காலைய் + இல்"), carried
    -- forward into BOTH steps once it exists — this is the fix.
    IF rec.changed_letter IS NOT NULL AND part2 <> '' THEN
      glided_before := part1 || rec.changed_letter || ' + ' || part2;
      step1_result := part1 || ' + ' || rec.changed_letter || ' + ' || part2 || ' → ' || glided_before;
    ELSE
      glided_before := rec.before_form;
      step1_result := rec.before_form;
    END IF;

    step2_result := glided_before || ' = ' || rec.after_form;

    IF sutra2 IS NOT NULL THEN
      steps := jsonb_build_array(
        jsonb_build_object('condition', 'விதி 1', 'rule', sutra1, 'result', step1_result),
        jsonb_build_object('condition', 'விதி 2', 'rule', sutra2, 'result', step2_result)
      );
    ELSE
      steps := jsonb_build_array(
        jsonb_build_object('condition', 'விதி', 'rule', sutra1, 'result', step1_result),
        jsonb_build_object('condition', 'விளைவு', 'rule', glided_before || ' → ' || rec.after_form, 'result', rec.after_form)
      );
    END IF;

    UPDATE sandhi_rules SET rule_steps = steps WHERE id = rec.id;
  END LOOP;

  RAISE NOTICE '✓ step 2 glide-letter fix applied to all mnemonic-tagged rows.';
END $$;

-- ── கடி + நகர் — guaranteed direct fix (இயல்புப் புணர்ச்சி) ──────────────
UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[
    {"condition": "இயல்புப் புணர்ச்சி", "rule": "எந்த விதிகளும் இல்லை", "result": "கடி + நகர்"},
    {"condition": "விளைவு", "rule": "கடி + நகர் → கடிநகர்", "result": "கடிநகர்"}
  ]'::jsonb
WHERE before_form = 'கடி + நகர்' AND after_form = 'கடிநகர்';

UPDATE morphemes SET is_sandhi_junction = true
WHERE id = (
  SELECT m.id FROM morphemes m
  JOIN word_groups wg ON wg.id = m.word_group_id
  JOIN poem_lines pl ON pl.id = wg.poem_line_id
  JOIN pages p ON p.id = pl.page_id
  JOIN topics t ON t.id = p.topic_id
  WHERE t.title = 'மனோன்மணீயம்' AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 1 AND wg.position = 3
  ORDER BY m.position LIMIT 1
);

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, rule_steps
FROM sandhi_rules WHERE before_form IN ('காலை + இல்', 'கடி + நகர்');
