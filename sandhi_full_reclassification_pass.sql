-- ============================================================================
-- Full re-sweep of the உ | உயிர் family with two refinements:
--
-- 1. கு சு து பு vs டு று split — check the ACTUAL final consonant of the
--    நிலைமொழி: ட்/ற் → டு று | உயிர்; க்/ச்/த்/ப் → கு சு து பு | உயிர்.
--    (வேண்டு ends in ட், so வேண்டு + உம் moves from கு சு து பு → டு று.)
--
-- 2. New exception, per your latest note: if the letter immediately before
--    the குற்றியலுகர syllable is a SINGLE standalone short vowel (இ, அ,
--    உ, எ, ஒ) — i.e. the whole word is just [short vowel] + [consonant+உ],
--    like இது, அது, எது — it does NOT count as குற்றியலுகரம் at all,
--    despite the consonant matching. It's முற்றியலுகரம் (மு | உயிர்),
--    rule "முற்றும் அற்று ஒரோவழி". (இது + ஓ was wrongly left under
--    கு சு து பு | உயிர்.)
--
-- Also direct-fixes போல் + ஆம் and இருப்ப் + அது, which weren't part of
-- the மெ | உ family before (they were sitting as இயல்புப் புணர்ச்சி) —
-- both are மெ | உ, and both fail the தனிக்குறில் test (போ is நெடில்;
-- இரு is polysyllabic), so both get the single-step norm rule.
-- ============================================================================

DO $$
DECLARE
  rec RECORD;
  part1 text;
  part2 text;
  base_consonant text;
  prefix text;
  elided text;
  new_tag text;
  new_hierarchy jsonb;
  sutra1 text;
  step1_result text;
  step2_result text;
  n int := 0;
  pulli text := chr(3021);        -- ்
  vowel_sign_u text := chr(3009); -- ு
  kutriyal_consonants text[] := ARRAY['க','ச','ட','த','ப','ற'];
  duru_consonants text[] := ARRAY['ட','ற'];
  standalone_short_vowels text[] := ARRAY['அ','இ','உ','எ','ஒ'];
BEGIN
  FOR rec IN
    SELECT id, before_form, after_form
    FROM sandhi_rules
    WHERE mnemonic_tag IN ('உ | உயிர்', 'கு சு து பு | உயிர்', 'டு று | உயிர்', 'மு | உயிர்')
  LOOP
    part1 := trim(split_part(rec.before_form, ' + ', 1));
    part2 := trim(split_part(rec.before_form, ' + ', 2));

    IF right(part1, 1) <> vowel_sign_u THEN
      CONTINUE; -- unexpected shape, don't touch
    END IF;

    base_consonant := substring(part1 FROM length(part1) - 1 FOR 1);
    prefix := left(part1, length(part1) - 2);
    elided := left(part1, length(part1) - 1) || pulli;

    IF base_consonant = ANY(kutriyal_consonants) AND prefix = ANY(standalone_short_vowels) THEN
      -- exception: single short vowel prefix → முற்றியலுகரம்
      new_tag := 'மு | உயிர்';
      new_hierarchy := '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb;
      sutra1 := 'முற்றும் அற்று ஒரோவழி';
    ELSIF base_consonant = ANY(kutriyal_consonants) THEN
      IF base_consonant = ANY(duru_consonants) THEN
        new_tag := 'டு று | உயிர்';
      ELSE
        new_tag := 'கு சு து பு | உயிர்';
      END IF;
      new_hierarchy := ('["உ | உ", "உ | உயிர்", "கு | உயிர்", "' || new_tag || '"]')::jsonb;
      sutra1 := 'உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்';
    ELSE
      -- consonant not in the குற்றியலுகர set at all → முற்றியலுகரம்
      new_tag := 'மு | உயிர்';
      new_hierarchy := '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb;
      sutra1 := 'முற்றும் அற்று ஒரோவழி';
    END IF;

    step1_result := elided || ' + «உ» + ' || part2 || ' → ' || elided || ' + ' || part2;
    step2_result := elided || ' + ' || part2 || ' = ' || rec.after_form;

    UPDATE sandhi_rules SET
      mnemonic_tag = new_tag,
      mnemonic_hierarchy = new_hierarchy,
      changed_letter = NULL,
      rule_steps = jsonb_build_array(
        jsonb_build_object('condition','விதி 1','rule',sutra1,'result',step1_result),
        jsonb_build_object('condition','விதி 2','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',step2_result)
      )
    WHERE id = rec.id;

    n := n + 1;
  END LOOP;

  RAISE NOTICE '✓ Reclassified % rows in the உ | உயிர் family.', n;
END $$;

-- ── Guaranteed direct fix for வேண்டு + உம் ────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'டு று | உயிர்',
  mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "கு | உயிர்", "டு று | உயிர்"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி 1", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "வேண்ட் + «உ» + உம் → வேண்ட் + உம்"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "வேண்ட் + உம் = வேண்டும்"}
  ]'::jsonb
WHERE before_form = 'வேண்டு + உம்' AND after_form = 'வேண்டும்';

-- ── Guaranteed direct fix for இது + ஓ ──────────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'மு | உயிர்',
  mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி 1", "rule": "முற்றும் அற்று ஒரோவழி", "result": "இத் + «உ» + ஓ → இத் + ஓ"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "இத் + ஓ = இதோ"}
  ]'::jsonb
WHERE before_form = 'இது + ஓ' AND after_form = 'இதோ';

-- ── போல் + ஆம் and இருப்ப் + அது — new to the மெ | உ family ───────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "போல் + ஆம்"},
    {"condition": "விளைவு", "rule": "போல் + ஆம் → போலாம்", "result": "போலாம்"}
  ]'::jsonb
WHERE before_form = 'போல் + ஆம்' AND after_form = 'போலாம்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "இருப்ப் + அது"},
    {"condition": "விளைவு", "rule": "இருப்ப் + அது → இருப்பது", "result": "இருப்பது"}
  ]'::jsonb
WHERE before_form = 'இருப்ப் + அது' AND after_form = 'இருப்பது';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, mnemonic_hierarchy, changed_letter, rule_steps
FROM sandhi_rules
WHERE mnemonic_tag IN ('உ | உயிர்', 'கு சு து பு | உயிர்', 'டு று | உயிர்', 'மு | உயிர்', 'மெ | உ')
ORDER BY mnemonic_tag, before_form;
