-- ============================================================================
-- 1. ஏகு + மின் → ஏகுமின் — இயல்புப் புணர்ச்சி (re-applied, in case the
--    earlier attempt didn't land — safe/idempotent to re-run).
-- 2. சிறுவர் + ஐ → சிறுவரை — the 2nd connector in the சிறுமை/அர்/ஐ/ப்
--    chain (அர் → ஐ), using the already-fixed accumulated form "சிறுவர்".
--    மெ | உ, norm rule (ர் dead consonant, polysyllabic stem — not
--    தனிக்குறில், so no doubling).
-- 3. புக்கவிட்டிருக்க் + உம் → புக்கவிட்டிருக்கும் — மெ | உ, norm rule.
-- ============================================================================

-- ── 1. ஏகு + மின் ──────────────────────────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = NULL, mnemonic_hierarchy = NULL, changed_letter = NULL,
  rule_steps = '[
    {"condition": "இயல்புப் புணர்ச்சி", "rule": "எந்த விதிகளும் இல்லை", "result": "ஏகு + மின்"},
    {"condition": "விளைவு", "rule": "ஏகு + மின் → ஏகுமின்", "result": "ஏகுமின்"}
  ]'::jsonb
WHERE before_form = 'ஏகு + மின்' AND after_form = 'ஏகுமின்';

-- ── 3. புக்கவிட்டிருக்க் + உம் ──────────────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "புக்கவிட்டிருக்க் + உம்"},
    {"condition": "விளைவு", "rule": "புக்கவிட்டிருக்க் + உம் → புக்கவிட்டிருக்கும்", "result": "புக்கவிட்டிருக்கும்"}
  ]'::jsonb
WHERE before_form = 'புக்கவிட்டிருக்க் + உம்' AND after_form = 'புக்கவிட்டிருக்கும்';

-- ── 2. சிறுவர் + ஐ (2nd connector: அர் → ஐ in the சிறுமை/அர்/ஐ/ப் chain) ──
DO $$
DECLARE
  wg_id uuid;
  conn_idx int;
BEGIN
  SELECT m1.word_group_id,
         (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position)
    INTO wg_id, conn_idx
  FROM morphemes m0
  JOIN morphemes m1 ON m1.word_group_id = m0.word_group_id AND m1.is_separator = false AND m1.display_form = 'அர்'
    AND m1.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m0.position AND x.is_separator = false)
  JOIN morphemes m2 ON m2.word_group_id = m0.word_group_id AND m2.is_separator = false AND m2.display_form = 'ஐ'
    AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m1.position AND x.is_separator = false)
  WHERE m0.display_form = 'சிறுமை' AND m0.is_separator = false
  LIMIT 1;

  IF wg_id IS NULL THEN
    RAISE NOTICE '✗ Could not find the சிறுமை/அர்/ஐ chain.';
    RETURN;
  END IF;

  IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
    UPDATE sandhi_rules SET
      mnemonic_tag = 'மெ | உ', mnemonic_hierarchy = '["மெ | உ"]'::jsonb, changed_letter = NULL,
      before_form = 'சிறுவர் + ஐ', after_form = 'சிறுவரை',
      rule_steps = '[
        {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "சிறுவர் + ஐ"},
        {"condition": "விளைவு", "rule": "சிறுவர் + ஐ → சிறுவரை", "result": "சிறுவரை"}
      ]'::jsonb
    WHERE word_group_id = wg_id AND connector_index = conn_idx;
  ELSE
    INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
    VALUES (wg_id, conn_idx, 'சிறுவர் + ஐ', 'சிறுவரை', NULL, 'மெ | உ', '["மெ | உ"]'::jsonb, '[
      {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "சிறுவர் + ஐ"},
      {"condition": "விளைவு", "rule": "சிறுவர் + ஐ → சிறுவரை", "result": "சிறுவரை"}
    ]'::jsonb);
  END IF;
  RAISE NOTICE '✓ சிறுவர் + ஐ fixed (word_group_id=%, connector_index=%)', wg_id, conn_idx;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, rule_steps
FROM sandhi_rules
WHERE before_form IN ('ஏகு + மின்', 'புக்கவிட்டிருக்க் + உம்', 'சிறுவர் + ஐ');
