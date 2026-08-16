-- ============================================================================
-- சொற்களின் புணர்ச்சி (Sandhi) தாவல் — Mnemonics + multi-step rule upgrade
--
-- 1. morphemes.is_sandhi_junction  — visual-hierarchy flag. TRUE (default) =
--    "Active Junction" (interactive mnemonic button, real phonetic sandhi).
--    FALSE = "Base Merge" (subtle static dot, pure verb-morphology suffixing
--    with no real letter change — e.g. building கடந்து letter by letter).
--    The flag lives on the morpheme BEFORE the gap: morphemes.position = P's
--    flag controls the connector between P and the next position.
--
-- 2. sandhi_rules.mnemonic_tag — short pill label (e.g. "இ ஈ ஐ | உயிர்",
--    "மெ | மெ") matching the traditional நன்னூல் புணர்ச்சி sutra chart.
--
-- 3. sandhi_rules.rule_steps — multi-step jsonb array replacing rule_text.
--    Each element: {"condition": "...", "rule": "...", "result": "..."}.
--    Existing single rule_text rows are wrapped as a 1-step array first,
--    then selectively overwritten with real multi-step breakdowns by the
--    follow-up data-seed script (sandhi_mnemonics_data.sql).
--
-- Safe to re-run.
-- ============================================================================

DO $$
BEGIN
  -- 1. Visual hierarchy flag on morphemes
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'morphemes' AND column_name = 'is_sandhi_junction'
  ) THEN
    ALTER TABLE morphemes ADD COLUMN is_sandhi_junction BOOLEAN DEFAULT TRUE;
  END IF;

  -- 2. Mnemonic tag on sandhi_rules
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'sandhi_rules' AND column_name = 'mnemonic_tag'
  ) THEN
    ALTER TABLE sandhi_rules ADD COLUMN mnemonic_tag TEXT;
  END IF;

  -- 3. Multi-step JSONB array, migrated from rule_text, then rule_text dropped
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'sandhi_rules' AND column_name = 'rule_steps'
  ) THEN
    ALTER TABLE sandhi_rules ADD COLUMN rule_steps JSONB DEFAULT '[]'::jsonb;

    UPDATE sandhi_rules
    SET rule_steps = jsonb_build_array(
      jsonb_build_object(
        'condition', 'விதி',
        'rule', rule_text,
        'result', after_form
      )
    )
    WHERE rule_text IS NOT NULL;

    ALTER TABLE sandhi_rules DROP COLUMN rule_text;
  END IF;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT column_name, data_type FROM information_schema.columns
WHERE table_name = 'morphemes' AND column_name = 'is_sandhi_junction'
UNION ALL
SELECT column_name, data_type FROM information_schema.columns
WHERE table_name = 'sandhi_rules' AND column_name IN ('mnemonic_tag', 'rule_steps');

SELECT count(*) AS total_rules,
       count(*) FILTER (WHERE jsonb_array_length(rule_steps) > 0) AS with_steps
FROM sandhi_rules;
