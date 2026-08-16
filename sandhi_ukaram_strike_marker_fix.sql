-- ============================================================================
-- Replace the Unicode combining-strikethrough உ̶ (unreliable rendering across
-- fonts) with a «உ» marker, which SandhiRulePopup.jsx now renders as a real
-- CSS strikethrough (<s>) instead. Re-runs the same உ-elision family as
-- sandhi_ukaram_elision_fix.sql, just swapping how "dropped" is expressed.
-- Safe to re-run; overwrites rule_steps for the same rows again.
-- ============================================================================

DO $$
DECLARE
  rec RECORD;
  part1 text;
  part2 text;
  elided text;
  step1_result text;
  step2_result text;
  n int := 0;
BEGIN
  FOR rec IN
    SELECT id, before_form, after_form
    FROM sandhi_rules
    WHERE mnemonic_tag IN ('உ | உயிர்', 'கு சு து பு | உயிர்', 'டு று | உயிர்', 'மு | உயிர்')
  LOOP
    part1 := trim(split_part(rec.before_form, ' + ', 1));
    part2 := trim(split_part(rec.before_form, ' + ', 2));

    IF right(part1, 1) = 'உ' THEN
      elided := left(part1, length(part1) - 1);
    ELSE
      elided := part1;
    END IF;

    step1_result := elided || ' + «உ» + ' || part2 || ' → ' || elided || ' + ' || part2;
    step2_result := elided || ' + ' || part2 || ' = ' || rec.after_form;

    UPDATE sandhi_rules SET
      changed_letter = NULL,
      rule_steps = jsonb_build_array(
        jsonb_build_object('condition', 'விதி 1', 'rule', 'உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்', 'result', step1_result),
        jsonb_build_object('condition', 'விதி 2', 'rule', 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே', 'result', step2_result)
      )
    WHERE id = rec.id;

    n := n + 1;
  END LOOP;

  RAISE NOTICE '✓ Fixed % குற்றியலுகர உகர-elision rows with «» strike marker.', n;
END $$;

-- Guaranteed direct fix for வேண்டு + இன், same as before, marker version.
UPDATE sandhi_rules SET
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி 1", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "வேண்ட் + «உ» + இன் → வேண்ட் + இன்"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "வேண்ட் + இன் = வேண்டின்"}
  ]'::jsonb
WHERE before_form = 'வேண்டு + இன்' AND after_form = 'வேண்டின்';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, changed_letter, rule_steps
FROM sandhi_rules
WHERE mnemonic_tag IN ('உ | உயிர்', 'கு சு து பு | உயிர்', 'டு று | உயிர்', 'மு | உயிர்')
   OR (before_form = 'வேண்டு + இன்');
