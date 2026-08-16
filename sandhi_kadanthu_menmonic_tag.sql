-- ============================================================================
-- கடந்த் + உ → கடந்து — add the மெ | உ mnemonic label so the pill shows
-- both above the box and top-right in the popup (blue, per your request —
-- SandhiGroupBox.jsx's MNEMONIC_COLOR map was just changed from amber to
-- blue for this tag).
-- ============================================================================

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb
WHERE before_form = 'கடந்த் + உ' AND after_form = 'கடந்து';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, mnemonic_hierarchy, rule_steps
FROM sandhi_rules WHERE before_form = 'கடந்த் + உ';
