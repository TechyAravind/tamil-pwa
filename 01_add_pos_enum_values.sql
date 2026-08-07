-- ============================================================================
-- Run this FIRST, by itself (Run button once, nothing else in the editor).
--
-- The pos_label enum currently only allows 4 values: பெயர்ச்சொல், வினைச்சொல்,
-- இடைச்சொல், உரிச்சொல். The word-classification examples you gave
-- (ஒற்றி -> வினையெச்சம், எடுத்த -> பெயரெச்சம், வியர்த்தவர் -> வினையாலணையும்
-- பெயர்) need 3 more categories added to that enum before they can be
-- stored. Postgres requires a new enum value to be committed before it can
-- be used in an UPDATE, which is why this has to be a separate run from
-- apply_word_classification.sql.
--
-- Safe to re-run (IF NOT EXISTS guards).
-- ============================================================================

ALTER TYPE pos_label ADD VALUE IF NOT EXISTS 'வினையெச்சம்';
ALTER TYPE pos_label ADD VALUE IF NOT EXISTS 'பெயரெச்சம்';
ALTER TYPE pos_label ADD VALUE IF NOT EXISTS 'வினையாலணையும் பெயர்';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT enumlabel FROM pg_enum
WHERE enumtypid = 'pos_label'::regtype
ORDER BY enumsortorder;
