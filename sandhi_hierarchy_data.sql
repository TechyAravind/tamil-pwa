-- ============================================================================
-- சொற்களின் புணர்ச்சி (Sandhi) தாவல் — mnemonic_hierarchy data
--
-- Run AFTER sandhi_hierarchy_migration.sql. Populates the full root-to-leaf
-- classification chain per your exact structure:
--
--   உ | உ
--   ├─ இ ஈ ஐ | உயிர்
--   ├─ அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்
--   ├─ ஏ | உயிர்
--   └─ உ | உயிர்
--      ├─ கு | உயிர்
--      │  ├─ கு சு து பு | உயிர்
--      │  └─ டு று | உயிர்
--      │     ├─ நெடில் தொடர்க் குற்றியலுகரம் | உயிர்
--      │     └─ உயிர்த்தொடர்க் குற்றியலுகரம் | உயிர்
--      └─ மு | உயிர்
--
-- உ | மெ, மெ | உ, பூ | மெய் are their own standalone roots (consonant-
-- doubling categories from the other side of the chart, not under உ | உ).
--
-- This also SPLITS the previous single combined "நெடில்/உயிர்த் தொடர் |
-- உயிர்" tag into its two real sub-categories: நெடில் தொடர்க்
-- குற்றியலுகரம் (a single long vowel sign — ா ீ ூ ே ோ — immediately
-- before the டு/று) vs உயிர்த்தொடர்க் குற்றியலுகரம் (a compound/two-part
-- vowel sign — ை ொ ௌ — immediately before it). Both keep the same rule
-- (நெடிலோடு உயிர்த்தொடர்க் குற்றுகரங்களுள் டறஒற்று இரட்டும் வேற்றுமை
-- மிகவே) — only the category label differs, per your document.
--
-- Safe to re-run.
-- ============================================================================

-- ── Split the old combined tag into its two real sub-categories ───────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'நெடில் தொடர்க் குற்றியலுகரம் | உயிர்'
WHERE mnemonic_tag = 'நெடில்/உயிர்த் தொடர் | உயிர்'
  AND substring(split_part(before_form, ' + ', 1) from '.$') !~ '[ைொௌ]'
  AND substring(before_form from length(split_part(before_form,' + ',1)) - 2 for 1) IN ('ா','ீ','ூ','ே','ோ');

UPDATE sandhi_rules SET
  mnemonic_tag = 'உயிர்த்தொடர்க் குற்றியலுகரம் | உயிர்'
WHERE mnemonic_tag = 'நெடில்/உயிர்த் தொடர் | உயிர்';
-- (any leftover rows that didn't match the நெடில் pattern above default to
--  உயிர்த்தொடர் — safe because the rule text is identical either way)

-- ── Populate mnemonic_hierarchy per leaf tag ───────────────────────────────
UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | உ", "இ ஈ ஐ | உயிர்"]'::jsonb
WHERE mnemonic_tag = 'இ ஈ ஐ | உயிர்';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | உ", "அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்"]'::jsonb
WHERE mnemonic_tag = 'அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | உ", "ஏ | உயிர்"]'::jsonb
WHERE mnemonic_tag = 'ஏ | உயிர்';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | உ", "உ | உயிர்"]'::jsonb
WHERE mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | உ", "உ | உயிர்", "கு | உயிர்", "கு சு து பு | உயிர்"]'::jsonb
WHERE mnemonic_tag = 'கு சு து பு | உயிர்';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | உ", "உ | உயிர்", "கு | உயிர்", "டு று | உயிர்"]'::jsonb
WHERE mnemonic_tag = 'டு று | உயிர்';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | உ", "உ | உயிர்", "கு | உயிர்", "டு று | உயிர்", "நெடில் தொடர்க் குற்றியலுகரம் | உயிர்"]'::jsonb
WHERE mnemonic_tag = 'நெடில் தொடர்க் குற்றியலுகரம் | உயிர்';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | உ", "உ | உயிர்", "கு | உயிர்", "டு று | உயிர்", "உயிர்த்தொடர்க் குற்றியலுகரம் | உயிர்"]'::jsonb
WHERE mnemonic_tag = 'உயிர்த்தொடர்க் குற்றியலுகரம் | உயிர்';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | உ", "உ | உயிர்", "மு | உயிர்"]'::jsonb
WHERE mnemonic_tag = 'மு | உயிர்';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["உ | மெ"]'::jsonb
WHERE mnemonic_tag = 'உ | மெ';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["மெ | உ"]'::jsonb
WHERE mnemonic_tag = 'மெ | உ';

UPDATE sandhi_rules SET mnemonic_hierarchy =
  '["பூ | மெய்"]'::jsonb
WHERE mnemonic_tag = 'பூ | மெய்';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT mnemonic_tag, mnemonic_hierarchy, count(*)
FROM sandhi_rules
WHERE mnemonic_tag IS NOT NULL
GROUP BY 1, 2 ORDER BY 1;
