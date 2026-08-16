-- ============================================================================
-- சொற்களின் புணர்ச்சி (Sandhi) தாவல் — நூற்பா correction
--
-- CRITICAL FIX per "Based on my Pnarchi Short Cut Classification.docx":
-- every row that carries a mnemonic_tag was previously showing a
-- paraphrased/descriptive sentence (the pre-existing rule_text this whole
-- feature inherited, e.g. "உயிர் ஈறு + இல் வேற்றுமை உருபு இணையும்போது யகர
-- ஒற்று வரும்") as its step content. That is NOT what "விதி" is supposed
-- to hold — it must be the actual நூற்பா (the traditional grammar sutra
-- line itself, e.g. "இ ஈ ஐ வழி யவ்வும்"), exactly as laid out in your
-- document's காலை + இல் example:
--
--   விதி 1 : இ ஈ ஐ வழி யவ்வும்      → காலை + ய் + இல் → காலைய் + இல்
--   விதி 2 : உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே  → காலைய் + இல் = காலையில்
--
-- This replaces rule_steps for EVERY sandhi_rules row that has a
-- mnemonic_tag with the correct நூற்பா for that tag (from the mnemonic
-- chart you uploaded earlier), condition labelled "விதி 1"/"விதி 2"
-- (SandhiRulePopup.jsx no longer auto-prefixes "படி N:" — see the paired
-- JSX fix), and a result line that shows the glide-letter insertion step
-- explicitly wherever changed_letter is known.
--
-- Categories whose sutra already fully describes a complete, one-shot
-- change (நெடில்/உயிர்த் தொடர் | உயிர், உ | மெ, பூ | மெய்) get a single
-- விதி step plus a விளைவு (result) step, rather than the universal
-- "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே" settling rule, since that settling
-- rule specifically describes a life/vowel merging back onto a body/base —
-- it does not apply to a pure consonant-doubling event.
--
-- Rows WITHOUT a mnemonic_tag (base merges, இயல்புப் புணர்ச்சி, and the
-- ~41 consonant-mutation rules with no clean chart match) are untouched —
-- there is no authoritative நூற்பா to substitute in for those, so their
-- existing descriptive step content is left as-is rather than guessed at.
--
-- Safe to re-run.
-- ============================================================================

DO $$
DECLARE
  rec RECORD;
  part1 text;
  part2 text;
  sutra1 text;
  sutra2 text;      -- NULL when the category has no universal 2nd sutra
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
        sutra1 := 'இ ஈ ஐ வழி யவ்வும்';
        sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்' THEN
        sutra1 := 'ஏனை உயிர்வழி வவ்வும்';
        sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'ஏ | உயிர்' THEN
        sutra1 := 'ஏமுன் இவ்விருமையும்';
        sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'உ | உயிர்' THEN
        sutra1 := 'உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்';
        sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'கு சு து பு | உயிர்' THEN
        sutra1 := 'உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்';
        sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'டு று | உயிர்' THEN
        sutra1 := 'உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்';
        sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'நெடில்/உயிர்த் தொடர் | உயிர்' THEN
        sutra1 := 'நெடிலோடு உயிர்த்தொடர்க் குற்றுகரங்களுள் டறஒற்று இரட்டும் வேற்றுமை மிகவே';
        sutra2 := NULL;
      WHEN 'மு | உயிர்' THEN
        sutra1 := 'முற்றும் அற்று ஒரோவழி';
        sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'உ | மெ' THEN
        sutra1 := 'இயல்பினும் விதியினும் நின்ற உயிர்முன் க ச த ப மிகும்';
        sutra2 := NULL;
      WHEN 'மெ | உ' THEN
        sutra1 := 'தனிக்குறில்முன் ஒற்று உயிர்வரின் இரட்டும்';
        sutra2 := 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே';
      WHEN 'பூ | மெய்' THEN
        sutra1 := 'பூப்பெயர்முன் இனமென்மையும் தோன்றும்';
        sutra2 := NULL;
      ELSE
        sutra1 := NULL;
    END CASE;

    IF sutra1 IS NULL THEN
      CONTINUE;  -- unknown tag (shouldn't happen) — leave row untouched
    END IF;

    -- Step 1 result: show the glide/changed letter being inserted when we
    -- know it (part1 + letter + part2 → part1+letter joined + part2);
    -- otherwise just restate the starting point.
    IF rec.changed_letter IS NOT NULL AND part2 <> '' THEN
      step1_result := part1 || ' + ' || rec.changed_letter || ' + ' || part2
                    || ' → ' || part1 || rec.changed_letter || ' + ' || part2;
    ELSE
      step1_result := rec.before_form;
    END IF;

    step2_result := rec.before_form || ' = ' || rec.after_form;

    IF sutra2 IS NOT NULL THEN
      steps := jsonb_build_array(
        jsonb_build_object('condition', 'விதி 1', 'rule', sutra1, 'result', step1_result),
        jsonb_build_object('condition', 'விதி 2', 'rule', sutra2, 'result', step2_result)
      );
    ELSE
      steps := jsonb_build_array(
        jsonb_build_object('condition', 'விதி', 'rule', sutra1, 'result', step1_result),
        jsonb_build_object('condition', 'விளைவு', 'rule', rec.before_form || ' → ' || rec.after_form, 'result', rec.after_form)
      );
    END IF;

    UPDATE sandhi_rules SET rule_steps = steps WHERE id = rec.id;
  END LOOP;

  RAISE NOTICE '✓ நூற்பா correction applied to all mnemonic-tagged sandhi_rules rows.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT mnemonic_tag,
       rule_steps -> 0 ->> 'condition' AS step1_label,
       rule_steps -> 0 ->> 'rule'      AS step1_sutra,
       count(*) AS n
FROM sandhi_rules
WHERE mnemonic_tag IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY 1;

-- Spot-check காலை + இல்
SELECT before_form, after_form, mnemonic_tag, rule_steps
FROM sandhi_rules WHERE before_form = 'காலை + இல்';
