-- ============================================================================
-- Three direct fixes, matched by exact before_form/after_form text.
-- ============================================================================

-- ── தூசிடைச்சிக்கு + உம் — குற்றியலுகரம், கு சு து பு | உயிர் (elision)
UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "கு | உயிர்", "கு சு து பு | உயிர்"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி 1", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "தூசிடைச்சிக் + «உ» + உம் → தூசிடைச்சிக் + உம்"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "தூசிடைச்சிக் + உம் = தூசிடைச்சிக்கும்"}
  ]'::jsonb
WHERE before_form = 'தூசிடைச்சிக்கு + உம்' AND after_form = 'தூசிடைச்சிக்கும்';

-- ── கொடுத்த் + ஏ — மெ | உ, norm rule
UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "கொடுத்த் + ஏ"},
    {"condition": "விளைவு", "rule": "கொடுத்த் + ஏ → கொடுத்தே", "result": "கொடுத்தே"}
  ]'::jsonb
WHERE before_form = 'கொடுத்த் + ஏ' AND after_form = 'கொடுத்தே';

-- ── யாம் + எலாம் — மெ | உ, norm rule
UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "யாம் + எலாம்"},
    {"condition": "விளைவு", "rule": "யாம் + எலாம் → யாமெலாம்", "result": "யாமெலாம்"}
  ]'::jsonb
WHERE before_form = 'யாம் + எலாம்' AND after_form = 'யாமெலாம்';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, rule_steps
FROM sandhi_rules
WHERE before_form IN ('தூசிடைச்சிக்கு + உம்', 'கொடுத்த் + ஏ', 'யாம் + எலாம்');
