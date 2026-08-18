-- ============================================================================
-- 1. இடம் + இலை → இடமிலை — மெ | உ, norm rule.
-- 2. சிறுமை + ஆர் → சிறார் — a COMPOUND process (பண்பு ஈறு போதல், THEN
--    குற்றியலுகர elision on the resulting சிறு): rendered as 3 rule_steps.
--    mnemonic_hierarchy shows the full chain "பண்புப்பெயர் → உ | உ → ... →
--    டு று | உயிர்" (சிறு ends in று, ற் is a டு/று-branch consonant);
--    the box-level pill (ROOT_OF_TAG) still resolves this to "உ | உ".
-- 3. சிறுமை + அர் → (existing after_form, or சிறுவர் if the row is new) —
--    same பண்பு-then-glide compound, but this branch takes ஏனை உயிர்வழி
--    வவ்வும் (வ் insertion) instead of elision, per your instruction.
-- 4. ஏகு + மின் → ஏகுமின் — இயல்புப் புணர்ச்சி.
-- ============================================================================

-- ── 1. இடம் + இலை ──────────────────────────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "இடம் + இலை"},
    {"condition": "விளைவு", "rule": "இடம் + இலை → இடமிலை", "result": "இடமிலை"}
  ]'::jsonb
WHERE before_form = 'இடம் + இலை' AND after_form = 'இடமிலை';

-- ── 2 & 3. சிறுமை + ஆர் / சிறுமை + அர் ────────────────────────────────────
DO $$
DECLARE
  wg_id uuid;
  conn_idx int;
  bform text;
  aform text;
BEGIN
  ------------------------------------------------------------------
  -- சிறுமை + ஆர் → சிறார்
  ------------------------------------------------------------------
  SELECT m1.word_group_id,
         (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position)
    INTO wg_id, conn_idx
  FROM morphemes m1
  JOIN morphemes m2 ON m2.word_group_id = m1.word_group_id AND m2.is_separator = false
    AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.position > m1.position AND x.is_separator = false)
  WHERE m1.display_form = 'சிறுமை' AND m2.display_form = 'ஆர்' AND m1.is_separator = false
  LIMIT 1;

  IF wg_id IS NOT NULL THEN
    SELECT COALESCE(sr.before_form, 'சிறுமை + ஆர்'), COALESCE(sr.after_form, 'சிறார்') INTO bform, aform
    FROM (SELECT 1) x LEFT JOIN sandhi_rules sr ON sr.word_group_id = wg_id AND sr.connector_index = conn_idx;

    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = 'டு று | உயிர்',
        mnemonic_hierarchy = '["பண்புப்பெயர்", "உ | உ", "உ | உயிர்", "கு | உயிர்", "டு று | உயிர்"]'::jsonb,
        changed_letter = NULL,
        rule_steps = jsonb_build_array(
          jsonb_build_object('condition','விதி 1','rule','ஈறு போதல்','result','சிறுமை + ஆர் → சிறு + ஆர்'),
          jsonb_build_object('condition','விதி 2','rule','உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்','result','சிற் + «உ» + ஆர் → சிற் + ஆர்'),
          jsonb_build_object('condition','விதி 3','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result','சிற் + ஆர் = ' || aform)
        )
      WHERE word_group_id = wg_id AND connector_index = conn_idx;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
      VALUES (wg_id, conn_idx, bform, aform, NULL, 'டு று | உயிர்', '["பண்புப்பெயர்", "உ | உ", "உ | உயிர்", "கு | உயிர்", "டு று | உயிர்"]'::jsonb,
        jsonb_build_array(
          jsonb_build_object('condition','விதி 1','rule','ஈறு போதல்','result','சிறுமை + ஆர் → சிறு + ஆர்'),
          jsonb_build_object('condition','விதி 2','rule','உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்','result','சிற் + «உ» + ஆர் → சிற் + ஆர்'),
          jsonb_build_object('condition','விதி 3','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result','சிற் + ஆர் = ' || aform)));
    END IF;
    RAISE NOTICE '✓ சிறுமை + ஆர் fixed → %', aform;
  ELSE
    RAISE NOTICE '✗ Could not find சிறுமை → ஆர்.';
  END IF;

  ------------------------------------------------------------------
  -- சிறுமை + அர் → (existing after_form, or சிறுவர் fallback)
  ------------------------------------------------------------------
  SELECT m1.word_group_id,
         (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position)
    INTO wg_id, conn_idx
  FROM morphemes m1
  JOIN morphemes m2 ON m2.word_group_id = m1.word_group_id AND m2.is_separator = false
    AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.position > m1.position AND x.is_separator = false)
  WHERE m1.display_form = 'சிறுமை' AND m2.display_form = 'அர்' AND m1.is_separator = false
  LIMIT 1;

  IF wg_id IS NOT NULL THEN
    SELECT COALESCE(sr.before_form, 'சிறுமை + அர்'), COALESCE(sr.after_form, 'சிறுவர்') INTO bform, aform
    FROM (SELECT 1) x LEFT JOIN sandhi_rules sr ON sr.word_group_id = wg_id AND sr.connector_index = conn_idx;

    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = 'அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்',
        mnemonic_hierarchy = '["பண்புப்பெயர்", "உ | உ", "அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்"]'::jsonb,
        changed_letter = NULL,
        rule_steps = jsonb_build_array(
          jsonb_build_object('condition','விதி 1','rule','ஈறு போதல்','result','சிறுமை + அர் → சிறு + அர்'),
          jsonb_build_object('condition','விதி 2','rule','ஏனை உயிர்வழி வவ்வும்','result','சிறு + வ் + அர் → சிறுவ் + அர்'),
          jsonb_build_object('condition','விதி 3','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result','சிறுவ் + அர் = ' || aform)
        )
      WHERE word_group_id = wg_id AND connector_index = conn_idx;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
      VALUES (wg_id, conn_idx, bform, aform, NULL, 'அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்', '["பண்புப்பெயர்", "உ | உ", "அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்"]'::jsonb,
        jsonb_build_array(
          jsonb_build_object('condition','விதி 1','rule','ஈறு போதல்','result','சிறுமை + அர் → சிறு + அர்'),
          jsonb_build_object('condition','விதி 2','rule','ஏனை உயிர்வழி வவ்வும்','result','சிறு + வ் + அர் → சிறுவ் + அர்'),
          jsonb_build_object('condition','விதி 3','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result','சிறுவ் + அர் = ' || aform)));
    END IF;
    RAISE NOTICE '✓ சிறுமை + அர் fixed → % (verify this is the right target word!)', aform;
  ELSE
    RAISE NOTICE '✗ Could not find சிறுமை → அர்.';
  END IF;
END $$;

-- ── 4. ஏகு + மின் → ஏகுமின் ────────────────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = NULL, mnemonic_hierarchy = NULL, changed_letter = NULL,
  rule_steps = '[
    {"condition": "இயல்புப் புணர்ச்சி", "rule": "எந்த விதிகளும் இல்லை", "result": "ஏகு + மின்"},
    {"condition": "விளைவு", "rule": "ஏகு + மின் → ஏகுமின்", "result": "ஏகுமின்"}
  ]'::jsonb
WHERE before_form = 'ஏகு + மின்' AND after_form = 'ஏகுமின்';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, mnemonic_hierarchy, rule_steps
FROM sandhi_rules
WHERE before_form IN ('இடம் + இலை', 'சிறுமை + ஆர்', 'சிறுமை + அர்', 'ஏகு + மின்');
