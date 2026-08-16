-- ============================================================================
-- சொற்களின் புணர்ச்சி (Sandhi) தாவல் — mnemonic_hierarchy column
--
-- Adds sandhi_rules.mnemonic_hierarchy (jsonb array of text, root-to-leaf),
-- e.g. for a கு சு து பு word: ["உ | உ", "உ | உயிர்", "கு | உயிர்",
-- "கு சு து பு | உயிர்"]. mnemonic_tag stays as the single LEAF label
-- (used for the compact pill shown above the connector button in the box
-- itself); mnemonic_hierarchy is the full ancestry chain shown stacked in
-- the popup's top-right corner.
--
-- Safe to re-run.
-- ============================================================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'sandhi_rules' AND column_name = 'mnemonic_hierarchy'
  ) THEN
    ALTER TABLE sandhi_rules ADD COLUMN mnemonic_hierarchy JSONB;
  END IF;
END $$;
