-- ============================================================================
-- சொற்களின் புணர்ச்சி (Sandhi) தாவல் — Corrections pass 3
--
-- Fixes three problems visible in your latest screenshots:
--
--  BUG FOUND — Part 5 of sandhi_corrections_2.sql checked is_verb on only
--  the ONE morpheme immediately before each connector, to decide whether a
--  connector belongs to a verb பகுபதம் chain (which should stay a Base
--  Merge dot) or a genuine word+word combination (which should be Active).
--  That works for a chain's FIRST connector (கட + ந், where கட itself is
--  the verb root, is_verb = true) but breaks for every connector AFTER it
--  in the same chain (ந் + த், த் + உ) — ந் and த் are not themselves
--  marked is_verb, so those connectors got wrongly reactivated as fake
--  "இயல்புப் புணர்ச்சி" junctions, which is exactly the extra "(த்) (த்)
--  (உ)" clutter you flagged inside கடந்து.
--
--  PART 1 — undo that: ANY connector belonging to a word_group whose
--    combined_is_verb = true (the whole group is one verb build-up, not
--    just its first piece) is forced back to a silent Base Merge dot,
--    regardless of which single morpheme sits immediately before it.
--
--  PART 2 — redo the இயல்புப் புணர்ச்சி reactivation correctly, scoped by
--    the GROUP's combined_is_verb flag instead of the flawed per-morpheme
--    check: only connectors inside a non-verb word_group (a genuine
--    word+word compound) that are still sitting as a Base Merge with no
--    real sandhi rule get reactivated with "இயல்புப் புணர்ச்சி — எந்த
--    விதிகளும் இல்லை". This also finally reactivates கடி + நகர், which
--    Part 5 missed.
--
--  PART 3 — காலை + இல் specifically: your screenshot shows it still has
--    no mnemonic pill and the old paraphrased text, meaning it never
--    actually received a mnemonic_tag in your live database (matching by
--    the original rule_text evidently missed this exact row). Fixed here
--    by an explicit, guaranteed update keyed directly on before_form /
--    after_form, with the correct நூற்பா content built straight in.
--
-- IMPORTANT: run sandhi_nurpa_correction.sql AGAIN after this script —
-- Part 2 here (re)assigns mnemonic_tag to more rows (including கடி + நகர்
-- getting reactivated, and any similar case), and நூற்பா correction only
-- fills in rule_steps for rows that currently HAVE a mnemonic_tag.
--
-- Safe to re-run.
-- ============================================================================

-- ── PART 1: force every connector in a verb-chain group back to Base Merge ──
DO $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT sr.id AS rule_id, sr.before_form, sr.after_form, m.id AS morpheme_id
    FROM sandhi_rules sr
    JOIN word_groups wg ON wg.id = sr.word_group_id
    JOIN LATERAL (
      SELECT mm.id FROM morphemes mm
      WHERE mm.word_group_id = wg.id
      ORDER BY mm.position
      OFFSET sr.connector_index LIMIT 1
    ) m ON true
    WHERE wg.combined_is_verb = true
      AND sr.rule_steps -> 0 ->> 'condition' <> 'அடிப்படை இணைப்பு'
  LOOP
    UPDATE sandhi_rules SET
      mnemonic_tag = NULL,
      rule_steps = jsonb_build_array(
        jsonb_build_object('condition', 'அடிப்படை இணைப்பு', 'rule', 'வினை வேர் + இடைநிலை/விகுதி இணைப்பு — பகுபத உறுப்பிலக்கணப் பகுதி, தனி புணர்ச்சி விதி இல்லை', 'result', rec.before_form),
        jsonb_build_object('condition', 'விளைவு', 'rule', rec.before_form || ' → ' || rec.after_form, 'result', rec.after_form)
      )
    WHERE id = rec.rule_id;

    UPDATE morphemes SET is_sandhi_junction = false WHERE id = rec.morpheme_id;

    RAISE NOTICE 'Reverted verb-chain connector % → % back to Base Merge', rec.before_form, rec.after_form;
  END LOOP;

  RAISE NOTICE '✓ Part 1 complete — verb-chain connectors restored to Base Merge.';
END $$;

-- ── PART 2: reactivate Base Merges correctly, scoped by GROUP verb flag ────
DO $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT sr.id AS rule_id, sr.before_form, sr.after_form, m.id AS morpheme_id
    FROM sandhi_rules sr
    JOIN word_groups wg ON wg.id = sr.word_group_id
    JOIN LATERAL (
      SELECT mm.id FROM morphemes mm
      WHERE mm.word_group_id = wg.id
      ORDER BY mm.position
      OFFSET sr.connector_index LIMIT 1
    ) m ON true
    WHERE sr.rule_steps -> 0 ->> 'condition' = 'அடிப்படை இணைப்பு'
      AND COALESCE(wg.combined_is_verb, false) = false
  LOOP
    UPDATE sandhi_rules SET
      mnemonic_tag = NULL,
      rule_steps = jsonb_build_array(
        jsonb_build_object('condition', 'இயல்புப் புணர்ச்சி', 'rule', 'எந்த விதிகளும் இல்லை', 'result', rec.before_form),
        jsonb_build_object('condition', 'விளைவு', 'rule', rec.before_form || ' → ' || rec.after_form, 'result', rec.after_form)
      )
    WHERE id = rec.rule_id;

    UPDATE morphemes SET is_sandhi_junction = true WHERE id = rec.morpheme_id;

    RAISE NOTICE 'Reactivated word-compound connector % → % as இயல்புப் புணர்ச்சி', rec.before_form, rec.after_form;
  END LOOP;

  RAISE NOTICE '✓ Part 2 complete.';
END $$;

-- ── PART 3: காலை + இல் — guaranteed direct fix ──────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  changed_letter = 'ய்',
  rule_steps = '[
    {"condition": "விதி 1", "rule": "இ ஈ ஐ வழி யவ்வும்", "result": "காலை + ய் + இல் → காலைய் + இல்"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "காலை + இல் = காலையில்"}
  ]'::jsonb
WHERE before_form = 'காலை + இல்' AND after_form = 'காலையில்';

UPDATE morphemes SET is_sandhi_junction = true
WHERE id = (
  SELECT m.id FROM morphemes m
  JOIN word_groups wg ON wg.id = m.word_group_id
  JOIN poem_lines pl ON pl.id = wg.poem_line_id
  JOIN pages p ON p.id = pl.page_id
  JOIN topics t ON t.id = p.topic_id
  WHERE t.title = 'மனோன்மணீயம்' AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 1 AND wg.position = 1
  ORDER BY m.position LIMIT 1
);

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, rule_steps -> 0 ->> 'condition' AS step1_label
FROM sandhi_rules WHERE before_form IN ('காலை + இல்', 'கடி + நகர்', 'கட + ந்', 'ந் + த்', 'த் + உ');

SELECT count(*) FILTER (WHERE rule_steps -> 0 ->> 'condition' = 'அடிப்படை இணைப்பு') AS base_merges,
       count(*) FILTER (WHERE rule_steps -> 0 ->> 'condition' = 'இயல்புப் புணர்ச்சி') AS natural_no_rule,
       count(*) FILTER (WHERE mnemonic_tag IS NOT NULL) AS with_mnemonic,
       count(*) AS total
FROM sandhi_rules;
