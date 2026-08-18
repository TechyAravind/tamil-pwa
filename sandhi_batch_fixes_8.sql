-- ============================================================================
-- Three fixes:
--
-- 1. பலமுறத்தன் + அது → பலமுறத்தனது — rule text only, NO மெ | உ tag.
--    "தன்" here is a நெடுமுதல் குறுகிய சொல் (shortened from நெடில் "தான்"),
--    which per classical grammar (see your uploaded note) does NOT double
--    even though it superficially looks தனிக்குறில் — its consonant stays
--    single because its TRUE origin is a long vowel. The applicable rule
--    is நெடுமுதல் குறுகுதல் (long-vowel shortening), not the doubling
--    rule at all. Noted for future practice: தன்/என்/நம்/தம் (and
--    anything built on them) should always be treated this way, never
--    run through the தனிக்குறில் doubling check.
--
-- 2. பரப்பி / த் / த் / உ chain — same 4-tile shape as முளைத்த் and
--    உயர்த்தி (த் is a separate tile, not fused into "பரப்பித்த்"). The
--    last connector (2nd த் → உ) currently shows the wrong "உ" text badge
--    (changed_letter wrongly set to உ) instead of a dot. Fixed to
--    changed_letter = NULL (dot) + மெ | உ tag + the norm rule, per your
--    explicit instruction this time (unlike கடந்து's equivalent last
--    connector, which you asked to leave untagged).
--
-- 3. ஆசுஇலாச்சிறுமை + காய் → ஆசுஇலாச்சிறுகாய் — reclassified from the
--    wrong இ ஈ ஐ | உயிர் (glide insertion) to பண்பு / பண்புப்பெயர்
--    (ஈறு போதல்) — it ends in "மை", same family as சிறுமை.
-- ============================================================================

-- ── 1. பலமுறத்தன் + அது ────────────────────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  mnemonic_hierarchy = NULL,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "நெடுமுதல் குறுகுதல்", "result": "பலமுறத்தன் + அது"},
    {"condition": "விளைவு", "rule": "பலமுறத்தன் + அது → பலமுறத்தனது", "result": "பலமுறத்தனது"}
  ]'::jsonb
WHERE before_form = 'பலமுறத்தன் + அது' AND after_form = 'பலமுறத்தனது';

-- ── 3. ஆசுஇலாச்சிறுமை + காய் ──────────────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'பண்பு',
  mnemonic_hierarchy = '["பண்புப்பெயர்"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "ஈறு போதல்", "result": "ஆசுஇலாச்சிறுமை + காய்"},
    {"condition": "விளைவு", "rule": "ஆசுஇலாச்சிறுமை + காய் → ஆசுஇலாச்சிறுகாய்", "result": "ஆசுஇலாச்சிறுகாய்"}
  ]'::jsonb
WHERE before_form = 'ஆசுஇலாச்சிறுமை + காய்' AND after_form = 'ஆசுஇலாச்சிறுகாய்';

-- ── 2. பரப்பி / த் / த் / உ — locate the chain, fix the last connector ────
DO $$
DECLARE
  wg_id uuid;
  conn_idx int;
  bform text;
  aform text;
BEGIN
  SELECT m3.word_group_id,
         (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m3.word_group_id AND x.is_separator = false AND x.position < m3.position)
    INTO wg_id, conn_idx
  FROM morphemes m0
  JOIN morphemes m1 ON m1.word_group_id = m0.word_group_id AND m1.is_separator = false
    AND m1.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m0.position AND x.is_separator = false)
  JOIN morphemes m2 ON m2.word_group_id = m0.word_group_id AND m2.is_separator = false
    AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m1.position AND x.is_separator = false)
  JOIN morphemes m3 ON m3.word_group_id = m0.word_group_id AND m3.is_separator = false
    AND m3.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m2.position AND x.is_separator = false)
  WHERE m0.display_form = 'பரப்பி' AND m1.display_form = 'த்' AND m2.display_form = 'த்' AND m3.display_form = 'உ'
    AND m0.is_separator = false
  LIMIT 1;

  IF wg_id IS NULL THEN
    RAISE NOTICE '✗ Could not find the பரப்பி / த் / த் / உ chain.';
    RETURN;
  END IF;

  SELECT sr.before_form, sr.after_form INTO bform, aform
  FROM sandhi_rules sr WHERE sr.word_group_id = wg_id AND sr.connector_index = conn_idx;

  IF bform IS NULL THEN
    bform := 'பரப்பித்த் + உ'; aform := 'பரப்பித்து';
  END IF;

  IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = conn_idx) THEN
    UPDATE sandhi_rules SET
      mnemonic_tag = 'மெ | உ', mnemonic_hierarchy = '["மெ | உ"]'::jsonb, changed_letter = NULL,
      rule_steps = jsonb_build_array(
        jsonb_build_object('condition','விதி','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',bform),
        jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform))
    WHERE word_group_id = wg_id AND connector_index = conn_idx;
  ELSE
    INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
    VALUES (wg_id, conn_idx, bform, aform, NULL, 'மெ | உ', '["மெ | உ"]'::jsonb,
      jsonb_build_array(
        jsonb_build_object('condition','விதி','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',bform),
        jsonb_build_object('condition','விளைவு','rule',bform || ' → ' || aform,'result',aform)));
  END IF;

  RAISE NOTICE '✓ பரப்பி chain fixed: before_form=%, after_form=%', bform, aform;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, mnemonic_hierarchy, changed_letter, rule_steps
FROM sandhi_rules
WHERE before_form IN ('பலமுறத்தன் + அது', 'ஆசுஇலாச்சிறுமை + காய்') OR before_form LIKE 'பரப்பி%';
