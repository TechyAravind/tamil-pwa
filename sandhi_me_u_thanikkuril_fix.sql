-- ============================================================================
-- மெ | உ family — தனிக்குறில் check.
--
-- Per your rule: for a மெ | உ row, look at the நிலைமொழி's (part1's) final
-- letter — it's always a dead consonant (ஒற்று). Check what precedes it:
--   - if it's exactly ONE short-vowel (குறில்) syllable and nothing else
--     (a genuinely monosyllabic stem, e.g. "கல்") → தனிக்குறில் முன் ஒற்று
--     உயிர்வரின் இரட்டும் (the consonant doubles)
--   - anything else (a polysyllabic stem, e.g. "முடுக்கின்" = மு-டு-க்-கி-ன்)
--     → the norm: உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே (plain concatenation,
--     single step, no doubling)
--
-- Heuristic used for "how many syllables in the stem": strip all Tamil
-- combining vowel signs / pulli (U+0BBE–U+0BCD) from the stem and count
-- remaining base letters — genuinely monosyllabic stems reduce to exactly 1.
--
-- Scope: முடுக்கின் + உம் is fixed directly (guaranteed). Every OTHER row
-- already tagged மெ | உ is re-checked with the same heuristic; rows found
-- to be polysyllabic (not தனிக்குறில்) are converted to the single-step
-- norm rule + changed_letter cleared to NULL (so the connector shows a dot,
-- not the wrong "whole suffix as a letter" badge you saw — உம் — which
-- was never a real "added letter" to begin with). Rows that DO look
-- genuinely monosyllabic are left untouched, since I can't safely
-- reconstruct their doubled intermediate form without seeing each one —
-- flag those for a manual look if any show up in the verify query below.
-- ============================================================================

DO $$
DECLARE
  rec RECORD;
  part1 text;
  part2 text;
  stem text;
  stripped text;
  is_thanik boolean;
  pulli text := chr(3021); -- ்
  n_fixed int := 0;
  n_left_as_doubling int := 0;
BEGIN
  FOR rec IN
    SELECT id, before_form, after_form FROM sandhi_rules WHERE mnemonic_tag = 'மெ | உ'
  LOOP
    part1 := trim(split_part(rec.before_form, ' + ', 1));
    part2 := trim(split_part(rec.before_form, ' + ', 2));

    IF right(part1, 1) = pulli THEN
      stem := left(part1, length(part1) - 2); -- drop final [consonant][pulli]
      stripped := regexp_replace(stem, '[' || chr(3006) || '-' || chr(3021) || ']', '', 'g');
      is_thanik := length(stripped) = 1;
    ELSE
      is_thanik := true; -- unexpected shape; don't touch, leave as doubling
    END IF;

    IF NOT is_thanik THEN
      UPDATE sandhi_rules SET
        changed_letter = NULL,
        rule_steps = jsonb_build_array(
          jsonb_build_object('condition', 'விதி', 'rule', 'உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே', 'result', rec.before_form),
          jsonb_build_object('condition', 'விளைவு', 'rule', rec.before_form || ' → ' || rec.after_form, 'result', rec.after_form)
        )
      WHERE id = rec.id;
      n_fixed := n_fixed + 1;
    ELSE
      n_left_as_doubling := n_left_as_doubling + 1;
    END IF;
  END LOOP;

  RAISE NOTICE '✓ Converted % non-தனிக்குறில் மெ | உ rows to the norm rule. % rows look genuinely monosyllabic and were left as doubling — check them manually.', n_fixed, n_left_as_doubling;
END $$;

-- ── Guaranteed direct fix for முடுக்கின் + உம் ────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "முடுக்கின் + உம்"},
    {"condition": "விளைவு", "rule": "முடுக்கின் + உம் → முடுக்கினும்", "result": "முடுக்கினும்"}
  ]'::jsonb
WHERE before_form = 'முடுக்கின் + உம்' AND after_form = 'முடுக்கினும்';

-- ── Verify — rows left as doubling get flagged for a manual look ─────────
SELECT before_form, after_form, changed_letter, rule_steps,
  CASE WHEN rule_steps::text LIKE '%இரட்டும்%' THEN '⚠ still doubling — verify manually' ELSE 'norm rule' END AS status
FROM sandhi_rules WHERE mnemonic_tag = 'மெ | உ'
ORDER BY status DESC, before_form;
