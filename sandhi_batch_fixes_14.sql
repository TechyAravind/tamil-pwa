-- ============================================================================
-- Five fixes.
-- ============================================================================

-- ── 1. புல் + இன் → புல்லின் — fix the stray "இப்" prefix AND reclassify
--    as genuine தனிக்குறில் doubling (பு reduces to a single base letter,
--    so ல் really does double here, unlike the polysyllabic மெ | உ cases
--    fixed earlier).
UPDATE sandhi_rules SET
  before_form = 'புல் + இன்',
  after_form = 'புல்லின்',
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = 'ல்',
  rule_steps = '[
    {"condition": "விதி 1", "rule": "தனிக்குறில் முன் ஒற்று உயிர்வரின் இரட்டும்", "result": "புல் + ல் + இன் → புல்ல் + இன்"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "புல்ல் + இன் = புல்லின்"}
  ]'::jsonb
WHERE before_form = 'இப்புல் + இன்' AND after_form = 'இப்புல்லின்';

-- ── 2. பரிவு + உம் → பரிவும் — முற்றியலுகரம் (வ் not a குற்றியலுகர consonant)
UPDATE sandhi_rules SET
  mnemonic_tag = 'மு | உயிர்',
  mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி 1", "rule": "முற்றும் அற்று ஒரோவழி", "result": "பரிவ் + «உ» + உம் → பரிவ் + உம்"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "பரிவ் + உம் = பரிவும்"}
  ]'::jsonb
WHERE before_form = 'பரிவு + உம்' AND after_form = 'பரிவும்';

-- ── 3. புலன் + உம் → புலனும் — மெ | உ, norm rule
UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "புலன் + உம்"},
    {"condition": "விளைவு", "rule": "புலன் + உம் → புலனும்", "result": "புலனும்"}
  ]'::jsonb
WHERE before_form = 'புலன் + உம்' AND after_form = 'புலனும்';

-- ── 4 & 5. காண்/ப்/ஓர் and ஒன்று/ஐ/உம் chains — 2nd connector in each ─────
DO $$
DECLARE
  wg_id uuid;
  conn_idx int;
BEGIN
  ------------------------------------------------------------------
  -- 4. காண்ப் + ஓர் → காண்போர் (ப் → ஓர்)
  ------------------------------------------------------------------
  SELECT m1.word_group_id,
         (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position)
    INTO wg_id, conn_idx
  FROM morphemes m0
  JOIN morphemes m1 ON m1.word_group_id = m0.word_group_id AND m1.is_separator = false AND m1.display_form = 'ப்'
    AND m1.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m0.position AND x.is_separator = false)
  JOIN morphemes m2 ON m2.word_group_id = m0.word_group_id AND m2.is_separator = false AND m2.display_form = 'ஓர்'
    AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m1.position AND x.is_separator = false)
  WHERE m0.display_form = 'காண்' AND m0.is_separator = false
  LIMIT 1;

  IF wg_id IS NULL THEN
    RAISE NOTICE '✗ Could not find காண்/ப்/ஓர் chain.';
  ELSE
    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = 'மெ | உ', mnemonic_hierarchy = '["மெ | உ"]'::jsonb, changed_letter = NULL,
        before_form = 'காண்ப் + ஓர்', after_form = 'காண்போர்',
        rule_steps = '[
          {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "காண்ப் + ஓர்"},
          {"condition": "விளைவு", "rule": "காண்ப் + ஓர் → காண்போர்", "result": "காண்போர்"}
        ]'::jsonb
      WHERE word_group_id = wg_id AND connector_index = conn_idx;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
      VALUES (wg_id, conn_idx, 'காண்ப் + ஓர்', 'காண்போர்', NULL, 'மெ | உ', '["மெ | உ"]'::jsonb, '[
        {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "காண்ப் + ஓர்"},
        {"condition": "விளைவு", "rule": "காண்ப் + ஓர் → காண்போர்", "result": "காண்போர்"}
      ]'::jsonb);
    END IF;
    RAISE NOTICE '✓ காண்ப் + ஓர் fixed.';
  END IF;

  ------------------------------------------------------------------
  -- 5. ஒன்றை + உம் → ஒன்றையும் (ஐ → உம்)
  ------------------------------------------------------------------
  SELECT m1.word_group_id,
         (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position)
    INTO wg_id, conn_idx
  FROM morphemes m0
  JOIN morphemes m1 ON m1.word_group_id = m0.word_group_id AND m1.is_separator = false AND m1.display_form = 'ஐ'
    AND m1.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m0.position AND x.is_separator = false)
  JOIN morphemes m2 ON m2.word_group_id = m0.word_group_id AND m2.is_separator = false AND m2.display_form = 'உம்'
    AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m1.position AND x.is_separator = false)
  WHERE m0.display_form = 'ஒன்று' AND m0.is_separator = false
  LIMIT 1;

  IF wg_id IS NULL THEN
    RAISE NOTICE '✗ Could not find ஒன்று/ஐ/உம் chain.';
  ELSE
    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = 'இ ஈ ஐ | உயிர்', mnemonic_hierarchy = '["உ | உ", "இ ஈ ஐ | உயிர்"]'::jsonb, changed_letter = 'ய்',
        before_form = 'ஒன்றை + உம்', after_form = 'ஒன்றையும்',
        rule_steps = '[
          {"condition": "விதி 1", "rule": "இ ஈ ஐ வழி யவ்வும்", "result": "ஒன்றை + ய் + உம் → ஒன்றைய் + உம்"},
          {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "ஒன்றைய் + உம் = ஒன்றையும்"}
        ]'::jsonb
      WHERE word_group_id = wg_id AND connector_index = conn_idx;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
      VALUES (wg_id, conn_idx, 'ஒன்றை + உம்', 'ஒன்றையும்', 'ய்', 'இ ஈ ஐ | உயிர்', '["உ | உ", "இ ஈ ஐ | உயிர்"]'::jsonb, '[
        {"condition": "விதி 1", "rule": "இ ஈ ஐ வழி யவ்வும்", "result": "ஒன்றை + ய் + உம் → ஒன்றைய் + உம்"},
        {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "ஒன்றைய் + உம் = ஒன்றையும்"}
      ]'::jsonb);
    END IF;
    RAISE NOTICE '✓ ஒன்றை + உம் fixed.';
  END IF;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, changed_letter, rule_steps
FROM sandhi_rules
WHERE before_form IN ('புல் + இன்', 'பரிவு + உம்', 'புலன் + உம்', 'காண்ப் + ஓர்', 'ஒன்றை + உம்');
