-- ============================================================================
-- Phase 3 migration — சொல்வகை popup enhancements
--   (from "சொல்வகை Changes.docx": richer individual-morpheme classification
--   + இலக்கணக்குறிப்பு macro-note on combined words)
--
-- Additive only — safe to run anytime, no data loss, existing rows unaffected
-- (new columns default to NULL, UI gracefully hides empty sections).
-- ============================================================================

-- 1. morphemes — granular structural role for BOUND sub-word pieces
--    (பகுதி/இடைநிலை/விகுதி/சந்தி மெய் — NOT the 4-way பெ/வி/இ/உ word-class,
--    which stays reserved for morphemes.grammatical_label on whole words only)
alter table morphemes
  add column if not exists structural_role text,  -- e.g. "வினையெச்ச விகுதி"
  add column if not exists role_category   text;  -- broad base: பகுதி / இடைநிலை / விகுதி / சந்தி மெய்

-- 2. word_groups — இலக்கணக்குறிப்பு macro-classification for the combined word
--    (e.g. "வினையெச்சம்", "உரிச்சொல் தொடர்", "ஏழாம் வேற்றுமை விரி")
alter table word_groups
  add column if not exists combined_grammar_note text;

-- Note: the "Derivation Summary" formula (கட (பகுதி) + ... = வினையெச்சம்)
-- is NOT stored — it's assembled at render time in the app from each
-- morpheme's structural_role/role_category plus the already-stored
-- sandhi_rules, so it never drifts out of sync with the data above.
