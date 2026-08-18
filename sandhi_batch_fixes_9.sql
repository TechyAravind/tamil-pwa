-- ============================================================================
-- Switching to direct before_form/after_form text matching for all three —
-- the morpheme-chain locator missed பரப்பித்து and உயர்த்தி twice now
-- (likely picking up the wrong word_group when a similar tile sequence
-- repeats elsewhere in the poem, or an off-by-one in connector_index).
-- Since all three rows are confirmed to already exist with this exact
-- text (visible in your screenshots), matching directly on that text is
-- more reliable than re-deriving the connector from morpheme adjacency.
-- ============================================================================

-- ── பரப்பித்த் + உ — was showing the word's MEANING/gloss text as if it
--    were the rule (a leftover data mix-up), plus the wrong "உ" badge.
UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "பரப்பித்த் + உ"},
    {"condition": "விளைவு", "rule": "பரப்பித்த் + உ → பரப்பித்து", "result": "பரப்பித்து"}
  ]'::jsonb
WHERE before_form = 'பரப்பித்த் + உ' AND after_form = 'பரப்பித்து';

-- ── தூசு + இடை — குற்றியலுகரம், கு சு து பு | உயிர்
UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  mnemonic_hierarchy = '["உ | உ", "உ | உயிர்", "கு | உயிர்", "கு சு து பு | உயிர்"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி 1", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "தூச் + «உ» + இடை → தூச் + இடை"},
    {"condition": "விதி 2", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "தூச் + இடை = தூசிடை"}
  ]'::jsonb
WHERE before_form = 'தூசு + இடை' AND after_form = 'தூசிடை';

-- ── உயர்த்த் + இ — மெ | உ, norm rule (3rd attempt — direct text match)
UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
  changed_letter = NULL,
  rule_steps = '[
    {"condition": "விதி", "rule": "உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "உயர்த்த் + இ"},
    {"condition": "விளைவு", "rule": "உயர்த்த் + இ → உயர்த்தி", "result": "உயர்த்தி"}
  ]'::jsonb
WHERE before_form = 'உயர்த்த் + இ' AND after_form = 'உயர்த்தி';

-- ── Verify — this MUST show 3 rows with the correct content below.
--    If any are missing, the exact before_form/after_form text on your
--    live DB differs (extra space, different trailing mark) from what's
--    shown in the popup titles — tell me and I'll match differently.
SELECT before_form, after_form, mnemonic_tag, changed_letter, rule_steps
FROM sandhi_rules
WHERE before_form IN ('பரப்பித்த் + உ', 'தூசு + இடை', 'உயர்த்த் + இ');
