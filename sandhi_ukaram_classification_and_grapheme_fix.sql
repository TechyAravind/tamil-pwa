-- ============================================================================
-- Two-part fix for the உ | உயிர் family (குற்றியலுகரம் / முற்றியலுகரம்).
--
-- BUG 1 (grapheme handling): the previous elision scripts checked for the
-- standalone உ letter (U+0B89) at the end of part1. But a word-final "u"
-- sound in Tamil is almost always written as the COMBINING VOWEL SIGN U
-- (ு, U+0BC1) attached to the preceding consonant — e.g. "விரைவு" is
-- வ்+ரை+வ்+ு, not வ்+ரை+வ்+உ. The check silently never matched, so the
-- உ was never actually dropped — producing the duplicated garbage
-- "விரைவு + உ + ஆய் → விரைவு + ஆய்" you saw. Fixed by detecting the
-- combining vowel sign and replacing it with a pulli (dead-consonant mark)
-- to get the correct bare-consonant form (விரைவு → விரைவ்).
--
-- BUG 2 (classification, per your rule): குற்றியலுகரம் only occurs when
-- the consonant carrying the final உ is one of க ச ட த ப ற (i.e. the word
-- ends in -கு -சு -டு -து -பு -று). Any other consonant + உ ending
-- (like -வு in விரைவு) is முற்றியலுகரம், tagged மு | உயிர். This pass
-- checks every currently-தொகுக்கப்பட்ட row in this family and reclassifies
-- any that were wrongly left under a குற்றியலுகரம் leaf even though their
-- final consonant isn't in that set.
--
-- Safe to re-run.
-- ============================================================================

DO $$
DECLARE
  rec RECORD;
  part1 text;
  part2 text;
  last_char text;
  base_consonant text;
  elided text;
  is_kutriyalukaram boolean;
  new_tag text;
  new_hierarchy jsonb;
  sutra1 text;
  step1_result text;
  step2_result text;
  n int := 0;
  vowel_sign_u text := chr(3009); -- ு  (TAMIL VOWEL SIGN U, U+0BC1)
  pulli text := chr(3021);        -- ்  (TAMIL SIGN VIRAMA, U+0BCD)
  kutriyal_consonants text[] := ARRAY['க','ச','ட','த','ப','ற'];
BEGIN
  FOR rec IN
    SELECT id, before_form, after_form, mnemonic_tag
    FROM sandhi_rules
    WHERE mnemonic_tag IN ('உ | உயிர்', 'கு சு து பு | உயிர்', 'டு று | உயிர்', 'மு | உயிர்')
  LOOP
    part1 := trim(split_part(rec.before_form, ' + ', 1));
    part2 := trim(split_part(rec.before_form, ' + ', 2));
    last_char := right(part1, 1);

    IF last_char = vowel_sign_u THEN
      elided := left(part1, length(part1) - 1) || pulli;
      base_consonant := substring(part1 FROM length(part1) - 1 FOR 1);
    ELSIF last_char = 'உ' THEN
      elided := left(part1, length(part1) - 1);
      base_consonant := NULL;
    ELSE
      elided := part1; -- unexpected shape; leave as-is, don't reclassify
      base_consonant := NULL;
    END IF;

    is_kutriyalukaram := base_consonant IS NOT NULL AND base_consonant = ANY(kutriyal_consonants);

    -- Reclassify only when we could actually determine the base consonant
    -- and it does NOT belong to the குற்றியலுகர set — move to மு | உயிர்.
    -- Never move the other direction automatically (existing sub-leaf
    -- choices like கு சு து பு vs டு று were hand-classified earlier and
    -- shouldn't be second-guessed here).
    IF base_consonant IS NOT NULL AND NOT is_kutriyalukaram AND rec.mnemonic_tag <> 'மு | உயிர்' THEN
      new_tag := 'மு | உயிர்';
      new_hierarchy := '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb;
    ELSE
      new_tag := rec.mnemonic_tag;
      new_hierarchy := NULL; -- leave hierarchy untouched
    END IF;

    sutra1 := CASE WHEN new_tag = 'மு | உயிர்'
      THEN 'முற்றும் அற்று ஒரோவழி'
      ELSE 'உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்' END;

    step1_result := elided || ' + «உ» + ' || part2 || ' → ' || elided || ' + ' || part2;
    step2_result := elided || ' + ' || part2 || ' = ' || rec.after_form;

    UPDATE sandhi_rules SET
      mnemonic_tag = new_tag,
      mnemonic_hierarchy = COALESCE(new_hierarchy, mnemonic_hierarchy),
      changed_letter = NULL,
      rule_steps = jsonb_build_array(
        jsonb_build_object('condition', 'விதி 1', 'rule', sutra1, 'result', step1_result),
        jsonb_build_object('condition', 'விதி 2', 'rule', 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே', 'result', step2_result)
      )
    WHERE id = rec.id;

    n := n + 1;
  END LOOP;

  RAISE NOTICE '✓ Reprocessed % rows (grapheme fix + reclassification pass).', n;
END $$;

-- ── Guaranteed direct fix for விரைவு + ஆய் ────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'மு | உயிர்',
  mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி 1", "rule": "முற்றும் அற்று ஒரோவழி", "result": "விரைவ் + «உ» + ஆய் → விரைவ் + ஆய்"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "விரைவ் + ஆய் = விரைவாய்"}
  ]'::jsonb
WHERE before_form = 'விரைவு + ஆய்' AND after_form = 'விரைவாய்';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, mnemonic_hierarchy, changed_letter, rule_steps
FROM sandhi_rules
WHERE mnemonic_tag IN ('உ | உயிர்', 'கு சு து பு | உயிர்', 'டு று | உயிர்', 'மு | உயிர்')
ORDER BY mnemonic_tag, before_form;
