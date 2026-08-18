-- ============================================================================
-- 1. செவ்விது + இல் → செவ்விதில் — குற்றியலுகரம், கு சு து பு | உயிர்
-- 2 & 3. தழைப்பதற்கு and பிழைப்பதற்கு chains — both share the same shape
--    (root, ப், ப், அது, அல், கு). For each, fixing the SAME two spots:
--      - ப்(1st) → ப்(2nd): currently shows the wrong "ப்" text badge —
--        this is just the future-tense consonant doubling merging with
--        itself, no real sandhi phenomenon, so → dot + இயல்புப் புணர்ச்சி.
--      - ப்(2nd) → அது: → மெ | உ, உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே.
--    அது → அல் and அல் → கு are NOT touched (not requested).
-- ============================================================================

-- ── 1. செவ்விது + இல் ──────────────────────────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "கு | உயிர்", "கு சு து பு | உயிர்"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி 1", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "செவ்வித் + «உ» + இல் → செவ்வித் + இல்"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "செவ்வித் + இல் = செவ்விதில்"}
  ]'::jsonb
WHERE before_form = 'செவ்விது + இல்' AND after_form = 'செவ்விதில்';

-- ── 2 & 3. தழை/பிழை + ப் + ப் + அது + அல் + கு chains ─────────────────────
DO $$
DECLARE
  spec RECORD;
  wg_id uuid;
  ci1 int; -- ப்(1st) → ப்(2nd)
  ci2 int; -- ப்(2nd) → அது
  before1 text; after1 text;
  before2 text; after2 text;
BEGIN
  FOR spec IN SELECT * FROM (VALUES ('தழை'), ('பிழை')) AS t(root_word)
  LOOP
    SELECT m1.word_group_id,
           (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m1.position),
           (SELECT count(*) FROM morphemes x WHERE x.word_group_id = m1.word_group_id AND x.is_separator = false AND x.position < m2.position)
      INTO wg_id, ci1, ci2
    FROM morphemes m0
    JOIN morphemes m1 ON m1.word_group_id = m0.word_group_id AND m1.is_separator = false AND m1.display_form = 'ப்'
      AND m1.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m0.position AND x.is_separator = false)
    JOIN morphemes m2 ON m2.word_group_id = m0.word_group_id AND m2.is_separator = false AND m2.display_form = 'ப்'
      AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m1.position AND x.is_separator = false)
    JOIN morphemes m3 ON m3.word_group_id = m0.word_group_id AND m3.is_separator = false AND m3.display_form = 'அது'
      AND m3.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m2.position AND x.is_separator = false)
    WHERE m0.display_form = spec.root_word AND m0.is_separator = false
    LIMIT 1;

    IF wg_id IS NULL THEN
      RAISE NOTICE '✗ Could not find the %/ப்/ப்/அது chain.', spec.root_word;
      CONTINUE;
    END IF;

    before1 := spec.root_word || 'ப் + ப்';
    after1  := spec.root_word || 'ப்ப்';
    before2 := spec.root_word || 'ப்ப் + அது';
    after2  := spec.root_word || 'ப்பது';

    -- ப்(1st) → ப்(2nd): dot + இயல்புப் புணர்ச்சி
    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = ci1) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = NULL, mnemonic_hierarchy = NULL, changed_letter = NULL,
        before_form = before1, after_form = after1,
        rule_steps = jsonb_build_array(
          jsonb_build_object('condition','இயல்புப் புணர்ச்சி','rule','எந்த விதிகளும் இல்லை','result',before1),
          jsonb_build_object('condition','விளைவு','rule',before1 || ' → ' || after1,'result',after1))
      WHERE word_group_id = wg_id AND connector_index = ci1;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, rule_steps)
      VALUES (wg_id, ci1, before1, after1, NULL, NULL, jsonb_build_array(
        jsonb_build_object('condition','இயல்புப் புணர்ச்சி','rule','எந்த விதிகளும் இல்லை','result',before1),
        jsonb_build_object('condition','விளைவு','rule',before1 || ' → ' || after1,'result',after1)));
    END IF;

    -- ப்(2nd) → அது: மெ | உ, norm rule
    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = ci2) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = 'மெ | உ', mnemonic_hierarchy = '["மெ | உ"]'::jsonb, changed_letter = NULL,
        before_form = before2, after_form = after2,
        rule_steps = jsonb_build_array(
          jsonb_build_object('condition','விதி','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',before2),
          jsonb_build_object('condition','விளைவு','rule',before2 || ' → ' || after2,'result',after2))
      WHERE word_group_id = wg_id AND connector_index = ci2;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
      VALUES (wg_id, ci2, before2, after2, NULL, 'மெ | உ', '["மெ | உ"]'::jsonb, jsonb_build_array(
        jsonb_build_object('condition','விதி','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',before2),
        jsonb_build_object('condition','விளைவு','rule',before2 || ' → ' || after2,'result',after2)));
    END IF;

    RAISE NOTICE '✓ % chain fixed (word_group_id=%, ci1=%, ci2=%)', spec.root_word, wg_id, ci1, ci2;
  END LOOP;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, changed_letter, rule_steps
FROM sandhi_rules
WHERE before_form = 'செவ்விது + இல்'
   OR before_form LIKE 'தழை%' OR before_form LIKE 'பிழை%'
ORDER BY before_form;
