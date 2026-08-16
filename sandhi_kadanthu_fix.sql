-- ============================================================================
-- கடந்து (கட + ந் + த் + உ) — connector badges currently show each NEXT
-- morpheme's own letter (ந், த், உ) inside the amber circle instead of a
-- plain dot, because changed_letter on these rows was wrongly set equal to
-- the adjacent morpheme's text rather than left NULL (SandhiGroupBox.jsx
-- renders the badge as: changed_letter, if present, else a plain dot — so a
-- non-null changed_letter here is exactly why letters are showing instead
-- of dots).
--
-- Fix, per your instruction:
--   கட → ந்   : இயல்புப் புணர்ச்சி (no real sandhi here), changed_letter = NULL
--   ந் → த்   : இயல்புப் புணர்ச்சி (no real sandhi here), changed_letter = NULL
--   த் → உ    : the ONE real rule in this chain — உடல்மேல் உயிர்வந்து
--               ஒன்றுவது இயல்பே — changed_letter = NULL (single-shot, no
--               letter inserted, so it's a dot too, just with real content)
--
-- All three stay tappable (Active Junction, not silent Base Merge) since
-- each needs its own popup content — only the badge glyph becomes a dot.
--
-- Located by morpheme TEXT sequence (கட, ந், த், உ consecutive, non-
-- separator, same word_group), not by guessed line/position.
-- ============================================================================

DO $$
DECLARE
  wg_id uuid;
  p0 int; p1 int; p2 int; p3 int; -- positions of கட, ந், த், உ
BEGIN
  SELECT m0.word_group_id, m0.position, m1.position, m2.position, m3.position
    INTO wg_id, p0, p1, p2, p3
  FROM morphemes m0
  JOIN morphemes m1 ON m1.word_group_id = m0.word_group_id AND m1.is_separator = false
    AND m1.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m0.position AND x.is_separator = false)
  JOIN morphemes m2 ON m2.word_group_id = m0.word_group_id AND m2.is_separator = false
    AND m2.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m1.position AND x.is_separator = false)
  JOIN morphemes m3 ON m3.word_group_id = m0.word_group_id AND m3.is_separator = false
    AND m3.position = (SELECT min(position) FROM morphemes x WHERE x.word_group_id = m0.word_group_id AND x.position > m2.position AND x.is_separator = false)
  WHERE m0.display_form = 'கட' AND m1.display_form = 'ந்' AND m2.display_form = 'த்' AND m3.display_form = 'உ'
    AND m0.is_separator = false
  LIMIT 1;

  IF wg_id IS NULL THEN
    RAISE NOTICE '✗ Could not find the கட / ந் / த் / உ morpheme sequence. Check exact spellings.';
    RETURN;
  END IF;

  -- connector_index = count of non-separator morphemes before the LEFT
  -- morpheme of each pair, within this word_group.
  DECLARE
    ci0 int; ci1 int; ci2 int;
  BEGIN
    SELECT count(*) INTO ci0 FROM morphemes WHERE word_group_id = wg_id AND is_separator = false AND position < p0;
    SELECT count(*) INTO ci1 FROM morphemes WHERE word_group_id = wg_id AND is_separator = false AND position < p1;
    SELECT count(*) INTO ci2 FROM morphemes WHERE word_group_id = wg_id AND is_separator = false AND position < p2;

    -- கட → ந் : இயல்புப் புணர்ச்சி, dot
    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = ci0) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = NULL, changed_letter = NULL,
        before_form = 'கட + ந்', after_form = 'கடந்',
        rule_steps = '[
          {"condition": "இயல்புப் புணர்ச்சி", "rule": "எந்த விதிகளும் இல்லை", "result": "கட + ந்"},
          {"condition": "விளைவு", "rule": "கட + ந் → கடந்", "result": "கடந்"}
        ]'::jsonb
      WHERE word_group_id = wg_id AND connector_index = ci0;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, rule_steps)
      VALUES (wg_id, ci0, 'கட + ந்', 'கடந்', NULL, NULL, '[
          {"condition": "இயல்புப் புணர்ச்சி", "rule": "எந்த விதிகளும் இல்லை", "result": "கட + ந்"},
          {"condition": "விளைவு", "rule": "கட + ந் → கடந்", "result": "கடந்"}
        ]'::jsonb);
    END IF;

    -- ந் → த் : இயல்புப் புணர்ச்சி, dot
    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = ci1) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = NULL, changed_letter = NULL,
        before_form = 'கடந் + த்', after_form = 'கடந்த்',
        rule_steps = '[
          {"condition": "இயல்புப் புணர்ச்சி", "rule": "எந்த விதிகளும் இல்லை", "result": "கடந் + த்"},
          {"condition": "விளைவு", "rule": "கடந் + த் → கடந்த்", "result": "கடந்த்"}
        ]'::jsonb
      WHERE word_group_id = wg_id AND connector_index = ci1;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, rule_steps)
      VALUES (wg_id, ci1, 'கடந் + த்', 'கடந்த்', NULL, NULL, '[
          {"condition": "இயல்புப் புணர்ச்சி", "rule": "எந்த விதிகளும் இல்லை", "result": "கடந் + த்"},
          {"condition": "விளைவு", "rule": "கடந் + த் → கடந்த்", "result": "கடந்த்"}
        ]'::jsonb);
    END IF;

    -- த் → உ : the real rule — உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே, dot
    IF EXISTS (SELECT 1 FROM sandhi_rules WHERE word_group_id = wg_id AND connector_index = ci2) THEN
      UPDATE sandhi_rules SET
        mnemonic_tag = NULL, changed_letter = NULL,
        before_form = 'கடந்த் + உ', after_form = 'கடந்து',
        rule_steps = '[
          {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "கடந்த் + உ → கடந்து"}
        ]'::jsonb
      WHERE word_group_id = wg_id AND connector_index = ci2;
    ELSE
      INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, rule_steps)
      VALUES (wg_id, ci2, 'கடந்த் + உ', 'கடந்து', NULL, NULL, '[
          {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "கடந்த் + உ → கடந்து"}
        ]'::jsonb);
    END IF;

    RAISE NOTICE '✓ கடந்து chain fixed: word_group_id=%, connectors at %,%,%', wg_id, ci0, ci1, ci2;
  END;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT sr.connector_index, sr.before_form, sr.after_form, sr.changed_letter, sr.rule_steps
FROM sandhi_rules sr
JOIN morphemes m ON m.word_group_id = sr.word_group_id
WHERE m.display_form = 'கட' AND m.is_separator = false
ORDER BY sr.connector_index;
