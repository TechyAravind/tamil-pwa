-- ============================================================================
-- சொற்களின் புணர்ச்சி (Sandhi) தாவல் — Mnemonics data seed
--
-- Run AFTER sandhi_mnemonics_migration.sql. Classifies every EXISTING
-- sandhi_rules row (305 unique rule/before/after combinations, covering
-- 328 total rows across the poem) into:
--
--   - mnemonic_tag  — a short pill (e.g. "இ ஈ ஐ | உயிர்", "உ | மெ") matching
--     the traditional நன்னூல் புணர்ச்சி sutra chart you uploaded, wherever
--     the rule cleanly maps to one of its categories.
--   - rule_steps    — a multi-step breakdown shown in order in the popup.
--     Two rows (கடந்து's 3 connectors, இச்சிறுபுல்'s 2 connectors — the
--     examples already documented in the sandhi-tab doc) get hand-authored
--     3-step pedagogical breakdowns. Every other row gets a mechanical
--     2-step wrap: step 1 = condition/sutra name + the original rule text,
--     step 2 = the literal before → after transform.
--   - is_sandhi_junction (on the underlying morpheme, via the block at the
--     end of this file) — set FALSE for connectors whose rule was only the
--     generic placeholder "இணைந்த சொல் வடிவம்", an explicit "(இன்னும் முழுச்
--     சொல் இல்லை/ஆகவில்லை)" verb-building step, or that step's culminating
--     final-meaning row (e.g. "கடந்து சென்று; having crossed") — i.e. NOT a
--     documented classical சந்தி phenomenon, just plain concatenation or
--     internal tense/person suffixing (already covered separately by this
--     app's பகுபத உறுப்பிலக்கணம் / verb_analysis feature). These become
--     "Base Merges" (subtle static dot, non-interactive) in the new UI.
--     Everything else stays TRUE ("Active Junction").
--
-- Matching is done by CONTENT (rule text + before_form + after_form), not
-- by word_group_id — intentional and safe: the same phonetic pattern
-- recurring at different lines/positions gets the same, correct
-- classification, and no live database access was available to resolve
-- UUIDs directly. Rows with no exact content match are left untouched
-- (mnemonic_tag stays NULL, is_sandhi_junction stays at its TRUE default)
-- rather than guessed.
--
-- Coverage of this pass:
--    99 combos -> Active Junction, matched to a chart mnemonic pill
--    41 combos -> Active Junction, real named sandhi rule (consonant
--                 mutation, case-marker attachment, etc.) but no clean
--                 chart-category match, so no pill shown (still fully
--                 interactive, full rule text/steps in popup)
--   165 combos -> Base Merge
--
-- Safe to re-run.
-- ============================================================================

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்", "result": "சிறுமை + பூ"}, {"condition": "விளைவு", "rule": "சிறுமை + பூ → சிறுபூ", "result": "சிறுபூ"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்'
  AND before_form = 'சிறுமை + பூ'
  AND after_form = 'சிறுபூ';

UPDATE sandhi_rules SET
  mnemonic_tag = 'பூ | மெய்',
  rule_steps = '[{"condition": "பூ | மெய்", "rule": "ஒற்று மிகும்", "result": "சிறுபூ + குலை"}, {"condition": "விளைவு", "rule": "சிறுபூ + குலை → சிறுபூக்குலை", "result": "சிறுபூக்குலை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'சிறுபூ + குலை'
  AND after_form = 'சிறுபூக்குலை';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரியும்", "result": "அடி + ஒன்று"}, {"condition": "விளைவு", "rule": "அடி + ஒன்று → அடியொன்று", "result": "அடியொன்று"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரியும்'
  AND before_form = 'அடி + ஒன்று'
  AND after_form = 'அடியொன்று';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உயர் + த்"}, {"condition": "விளைவு", "rule": "உயர் + த் → உயர்த்", "result": "உயர்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உயர் + த்'
  AND after_form = 'உயர்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உயர்த் + த்"}, {"condition": "விளைவு", "rule": "உயர்த் + த் → உயர்த்த்", "result": "உயர்த்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உயர்த் + த்'
  AND after_form = 'உயர்த்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உயர்த்த் + இ"}, {"condition": "விளைவு", "rule": "உயர்த்த் + இ → உயர்த்தி", "result": "உயர்த்தி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உயர்த்த் + இ'
  AND after_form = 'உயர்த்தி';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இதம் + உற"}, {"condition": "விளைவு", "rule": "இதம் + உற → இதமுற", "result": "இதமுற"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இதம் + உற'
  AND after_form = 'இதமுற';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "இதமுற + தேன்"}, {"condition": "விளைவு", "rule": "இதமுற + தேன் → இதமுறத்தேன்", "result": "இதமுறத்தேன்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'இதமுற + தேன்'
  AND after_form = 'இதமுறத்தேன்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இதமுறத்தேன் + துளி"}, {"condition": "விளைவு", "rule": "இதமுறத்தேன் + துளி → இதமுறத்தேன்துளி", "result": "இதமுறத்தேன்துளி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இதமுறத்தேன் + துளி'
  AND after_form = 'இதமுறத்தேன்துளி';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "தாங்கு + இ"}, {"condition": "விளைவு", "rule": "தாங்கு + இ → தாங்கி", "result": "தாங்கி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'தாங்கு + இ'
  AND after_form = 'தாங்கி';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "ஈ + கள்"}, {"condition": "விளைவு", "rule": "ஈ + கள் → ஈக்கள்", "result": "ஈக்கள்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'ஈ + கள்'
  AND after_form = 'ஈக்கள்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஈக்கள் + ஐ"}, {"condition": "விளைவு", "rule": "ஈக்கள் + ஐ → ஈக்களை", "result": "ஈக்களை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஈக்கள் + ஐ'
  AND after_form = 'ஈக்களை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "நலம் + உற"}, {"condition": "விளைவு", "rule": "நலம் + உற → நலமுற", "result": "நலமுற"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'நலம் + உற'
  AND after_form = 'நலமுற';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "அழை + த்"}, {"condition": "விளைவு", "rule": "அழை + த் → அழைத்", "result": "அழைத்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'அழை + த்'
  AND after_form = 'அழைத்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "அழைத் + த்"}, {"condition": "விளைவு", "rule": "அழைத் + த் → அழைத்த்", "result": "அழைத்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'அழைத் + த்'
  AND after_form = 'அழைத்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "அழைத்த் + உ"}, {"condition": "விளைவு", "rule": "அழைத்த் + உ → அழைத்து", "result": "அழைத்து"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'அழைத்த் + உ'
  AND after_form = 'அழைத்து';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "நல் + ஊண்"}, {"condition": "விளைவு", "rule": "நல் + ஊண் → நல்லூண்", "result": "நல்லூண்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'நல் + ஊண்'
  AND after_form = 'நல்லூண்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இகரம் ஏற்கும்", "result": "அருத்து + இ"}, {"condition": "விளைவு", "rule": "அருத்து + இ → அருத்தி", "result": "அருத்தி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இகரம் ஏற்கும்'
  AND before_form = 'அருத்து + இ'
  AND after_form = 'அருத்தி';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஆசு + இலா"}, {"condition": "விளைவு", "rule": "ஆசு + இலா → ஆசுஇலா", "result": "ஆசுஇலா"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஆசு + இலா'
  AND after_form = 'ஆசுஇலா';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "ஆசுஇலா + சிறுமை"}, {"condition": "விளைவு", "rule": "ஆசுஇலா + சிறுமை → ஆசுஇலாச்சிறுமை", "result": "ஆசுஇலாச்சிறுமை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'ஆசுஇலா + சிறுமை'
  AND after_form = 'ஆசுஇலாச்சிறுமை';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்", "result": "ஆசுஇலாச்சிறுமை + காய்"}, {"condition": "விளைவு", "rule": "ஆசுஇலாச்சிறுமை + காய் → ஆசுஇலாச்சிறுகாய்", "result": "ஆசுஇலாச்சிறுகாய்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்'
  AND before_form = 'ஆசுஇலாச்சிறுமை + காய்'
  AND after_form = 'ஆசுஇலாச்சிறுகாய்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இகரம் ஏற்கும்", "result": "ஆக்கு + இ"}, {"condition": "விளைவு", "rule": "ஆக்கு + இ → ஆக்கி", "result": "ஆக்கி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இகரம் ஏற்கும்'
  AND before_form = 'ஆக்கு + இ'
  AND after_form = 'ஆக்கி';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஓகாரம் ஏற்கும்", "result": "இது + ஓ"}, {"condition": "விளைவு", "rule": "இது + ஓ → இதோ", "result": "இதோ"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஓகாரம் ஏற்கும்'
  AND before_form = 'இது + ஓ'
  AND after_form = 'இதோ';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "தூசு + இடை"}, {"condition": "விளைவு", "rule": "தூசு + இடை → தூசிடை", "result": "தூசிடை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'தூசு + இடை'
  AND after_form = 'தூசிடை';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "தூசிடை + சிக்கு"}, {"condition": "விளைவு", "rule": "தூசிடை + சிக்கு → தூசிடைச்சிக்கு", "result": "தூசிடைச்சிக்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'தூசிடை + சிக்கு'
  AND after_form = 'தூசிடைச்சிக்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "தூசிடைச்சிக்கு + உம்"}, {"condition": "விளைவு", "rule": "தூசிடைச்சிக்கு + உம் → தூசிடைச்சிக்கும்", "result": "தூசிடைச்சிக்கும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'தூசிடைச்சிக்கு + உம்'
  AND after_form = 'தூசிடைச்சிக்கும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரியும்", "result": "தோட்டி + உம்"}, {"condition": "விளைவு", "rule": "தோட்டி + உம் → தோட்டியும்", "result": "தோட்டியும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரியும்'
  AND before_form = 'தோட்டி + உம்'
  AND after_form = 'தோட்டியும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கொடு + த்"}, {"condition": "விளைவு", "rule": "கொடு + த் → கொடுத்", "result": "கொடுத்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கொடு + த்'
  AND after_form = 'கொடுத்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கொடுத் + த்"}, {"condition": "விளைவு", "rule": "கொடுத் + த் → கொடுத்த்", "result": "கொடுத்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கொடுத் + த்'
  AND after_form = 'கொடுத்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கொடுத்த் + ஏ"}, {"condition": "விளைவு", "rule": "கொடுத்த் + ஏ → கொடுத்தே", "result": "கொடுத்தே"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கொடுத்த் + ஏ'
  AND after_form = 'கொடுத்தே';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "இ + வயின்"}, {"condition": "விளைவு", "rule": "இ + வயின் → இவ்வயின்", "result": "இவ்வயின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'இ + வயின்'
  AND after_form = 'இவ்வயின்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "யாம் + எலாம்"}, {"condition": "விளைவு", "rule": "யாம் + எலாம் → யாமெலாம்", "result": "யாமெலாம்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'யாம் + எலாம்'
  AND after_form = 'யாமெலாம்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "செவ்வி + து"}, {"condition": "விளைவு", "rule": "செவ்வி + து → செவ்விது", "result": "செவ்விது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'செவ்வி + து'
  AND after_form = 'செவ்விது';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "செவ்விது + இல்"}, {"condition": "விளைவு", "rule": "செவ்விது + இல் → செவ்விதில்", "result": "செவ்விதில்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'செவ்விது + இல்'
  AND after_form = 'செவ்விதில்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "துன் + இல்"}, {"condition": "விளைவு", "rule": "துன் + இல் → துன்னில்", "result": "துன்னில்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'துன் + இல்'
  AND after_form = 'துன்னில்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "தழைப்ப் + அது"}, {"condition": "விளைவு", "rule": "தழைப்ப் + அது → தழைப்பது", "result": "தழைப்பது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'தழைப்ப் + அது'
  AND after_form = 'தழைப்பது';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "தழைப்பது + அல்"}, {"condition": "விளைவு", "rule": "தழைப்பது + அல் → தழைப்பதல்", "result": "தழைப்பதல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'தழைப்பது + அல்'
  AND after_form = 'தழைப்பதல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "லகரம் றகரமாகத் திரியும்", "result": "தழைப்பதல் + கு"}, {"condition": "விளைவு", "rule": "தழைப்பதல் + கு → தழைப்பதற்கு", "result": "தழைப்பதற்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'லகரம் றகரமாகத் திரியும்'
  AND before_form = 'தழைப்பதல் + கு'
  AND after_form = 'தழைப்பதற்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இடம் + இலை"}, {"condition": "விளைவு", "rule": "இடம் + இலை → இடமிலை", "result": "இடமிலை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இடம் + இலை'
  AND after_form = 'இடமிலை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "பாடலில் காணப்படும் இணைந்த சொல் வடிவம் (சிறுமை -> சிறு, ஆர் இணைப்பு)", "result": "சிறுமை + ஆர்"}, {"condition": "விளைவு", "rule": "சிறுமை + ஆர் → சிறார்", "result": "சிறார்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பாடலில் காணப்படும் இணைந்த சொல் வடிவம் (சிறுமை -> சிறு, ஆர் இணைப்பு)'
  AND before_form = 'சிறுமை + ஆர்'
  AND after_form = 'சிறார்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பிழைப்ப் + அது"}, {"condition": "விளைவு", "rule": "பிழைப்ப் + அது → பிழைப்பது", "result": "பிழைப்பது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பிழைப்ப் + அது'
  AND after_form = 'பிழைப்பது';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பிழைப்பது + அல்"}, {"condition": "விளைவு", "rule": "பிழைப்பது + அல் → பிழைப்பதல்", "result": "பிழைப்பதல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பிழைப்பது + அல்'
  AND after_form = 'பிழைப்பதல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "லகரம் றகரமாகத் திரியும்", "result": "பிழைப்பதல் + கு"}, {"condition": "விளைவு", "rule": "பிழைப்பதல் + கு → பிழைப்பதற்கு", "result": "பிழைப்பதற்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'லகரம் றகரமாகத் திரியும்'
  AND before_form = 'பிழைப்பதல் + கு'
  AND after_form = 'பிழைப்பதற்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இகரம் ஏற்கும்", "result": "சிக்கு + இ"}, {"condition": "விளைவு", "rule": "சிக்கு + இ → சிக்கி", "result": "சிக்கி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இகரம் ஏற்கும்'
  AND before_form = 'சிக்கு + இ'
  AND after_form = 'சிக்கி';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "லகரம் னகரமாகத் திரியும்", "result": "செல் + மின்"}, {"condition": "விளைவு", "rule": "செல் + மின் → சென்மின்", "result": "சென்மின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'லகரம் னகரமாகத் திரியும்'
  AND before_form = 'செல் + மின்'
  AND after_form = 'சென்மின்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "என + தன்"}, {"condition": "விளைவு", "rule": "என + தன் → எனத்தன்", "result": "எனத்தன்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'என + தன்'
  AND after_form = 'எனத்தன்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "சிறுவர் + ஐ"}, {"condition": "விளைவு", "rule": "சிறுவர் + ஐ → சிறுவரை", "result": "சிறுவரை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'சிறுவர் + ஐ'
  AND after_form = 'சிறுவரை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "சிறுவரை + ப்"}, {"condition": "விளைவு", "rule": "சிறுவரை + ப் → சிறுவரைப்", "result": "சிறுவரைப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'சிறுவரை + ப்'
  AND after_form = 'சிறுவரைப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "சிறுமை + ஆ"}, {"condition": "விளைவு", "rule": "சிறுமை + ஆ → சிறுமையா", "result": "சிறுமையா"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'சிறுமை + ஆ'
  AND after_form = 'சிறுமையா';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "சிறுமையா + ச்"}, {"condition": "விளைவு", "rule": "சிறுமையா + ச் → சிறுமையாச்", "result": "சிறுமையாச்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'சிறுமையா + ச்'
  AND after_form = 'சிறுமையாச்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "சிறுமையாச் + சிந்தனை"}, {"condition": "விளைவு", "rule": "சிறுமையாச் + சிந்தனை → சிறுமையாச்சிந்தனை", "result": "சிறுமையாச்சிந்தனை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'சிறுமையாச் + சிந்தனை'
  AND after_form = 'சிறுமையாச்சிந்தனை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "பாடலில் ''இடைக்குறை'' என்னும் விகார விதிப்படி முழு வடிவம் செய்யாது என்பதன் குறுகிய வடிவே செயாது", "result": "செய் + ஆது"}, {"condition": "விளைவு", "rule": "செய் + ஆது → செயாது", "result": "செயாது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பாடலில் ''இடைக்குறை'' என்னும் விகார விதிப்படி முழு வடிவம் செய்யாது என்பதன் குறுகிய வடிவே செயாது'
  AND before_form = 'செய் + ஆது'
  AND after_form = 'செயாது';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "அடுக்குத் தொடர்", "result": "ஆங்கு + ஆங்கு"}, {"condition": "விளைவு", "rule": "ஆங்கு + ஆங்கு → ஆங்காங்கு", "result": "ஆங்காங்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'அடுக்குத் தொடர்'
  AND before_form = 'ஆங்கு + ஆங்கு'
  AND after_form = 'ஆங்காங்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "பாடலில் காணப்பட்ட புணர்ச்சி விதி (பேரழகு)", "result": "பெருமை + அழகு"}, {"condition": "விளைவு", "rule": "பெருமை + அழகு → பேரழகு", "result": "பேரழகு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பாடலில் காணப்பட்ட புணர்ச்சி விதி (பேரழகு)'
  AND before_form = 'பெருமை + அழகு'
  AND after_form = 'பேரழகு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பேரழகு + உம்"}, {"condition": "விளைவு", "rule": "பேரழகு + உம் → பேரழகும்", "result": "பேரழகும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பேரழகு + உம்'
  AND after_form = 'பேரழகும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இகரம் ஏற்கும்", "result": "குறிப்பு + இல்"}, {"condition": "விளைவு", "rule": "குறிப்பு + இல் → குறிப்பில்", "result": "குறிப்பில்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இகரம் ஏற்கும்'
  AND before_form = 'குறிப்பு + இல்'
  AND after_form = 'குறிப்பில்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "லகரம் றகரமாகத் திரியும்", "result": "குறிப்பில் + கு"}, {"condition": "விளைவு", "rule": "குறிப்பில் + கு → குறிப்பிற்கு", "result": "குறிப்பிற்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'லகரம் றகரமாகத் திரியும்'
  AND before_form = 'குறிப்பில் + கு'
  AND after_form = 'குறிப்பிற்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஏல் + து"}, {"condition": "விளைவு", "rule": "ஏல் + து → ஏற்று", "result": "ஏற்று"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஏல் + து'
  AND after_form = 'ஏற்று';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு அகரம் ஏற்கும்", "result": "ஏற்று + அ"}, {"condition": "விளைவு", "rule": "ஏற்று + அ → ஏற்ற", "result": "ஏற்ற"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு அகரம் ஏற்கும்'
  AND before_form = 'ஏற்று + அ'
  AND after_form = 'ஏற்ற';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஏற்ற + து"}, {"condition": "விளைவு", "rule": "ஏற்ற + து → ஏற்றது", "result": "ஏற்றது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஏற்ற + து'
  AND after_form = 'ஏற்றது';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஓகாரம் ஏற்கும்", "result": "ஏற்றது + ஓர்"}, {"condition": "விளைவு", "rule": "ஏற்றது + ஓர் → ஏற்றதோர்", "result": "ஏற்றதோர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஓகாரம் ஏற்கும்'
  AND before_form = 'ஏற்றது + ஓர்'
  AND after_form = 'ஏற்றதோர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரியும்", "result": "முயற்சி + உம்"}, {"condition": "விளைவு", "rule": "முயற்சி + உம் → முயற்சியும்", "result": "முயற்சியும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரியும்'
  AND before_form = 'முயற்சி + உம்'
  AND after_form = 'முயற்சியும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "உழு + ஓர்"}, {"condition": "விளைவு", "rule": "உழு + ஓர் → உழுவோர்", "result": "உழுவோர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'உழு + ஓர்'
  AND after_form = 'உழுவோர்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உழுவோர் + கு"}, {"condition": "விளைவு", "rule": "உழுவோர் + கு → உழுவோர்க்கு", "result": "உழுவோர்க்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உழுவோர் + கு'
  AND after_form = 'உழுவோர்க்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உழுவோர்க்கு + எல்லாம்"}, {"condition": "விளைவு", "rule": "உழுவோர்க்கு + எல்லாம் → உழுவோர்க்கெல்லாம்", "result": "உழுவோர்க்கெல்லாம்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உழுவோர்க்கு + எல்லாம்'
  AND after_form = 'உழுவோர்க்கெல்லாம்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "விழும் + இய"}, {"condition": "விளைவு", "rule": "விழும் + இய → விழுமிய", "result": "விழுமிய"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'விழும் + இய'
  AND after_form = 'விழுமிய';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "விடு + த்"}, {"condition": "விளைவு", "rule": "விடு + த் → விடுத்", "result": "விடுத்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'விடு + த்'
  AND after_form = 'விடுத்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "விடுத் + த்"}, {"condition": "விளைவு", "rule": "விடுத் + த் → விடுத்த்", "result": "விடுத்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'விடுத் + த்'
  AND after_form = 'விடுத்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "விடுத்த் + அன்"}, {"condition": "விளைவு", "rule": "விடுத்த் + அன் → விடுத்தன்", "result": "விடுத்தன்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'விடுத்த் + அன்'
  AND after_form = 'விடுத்தன்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "விடுத்தன் + ஐ"}, {"condition": "விளைவு", "rule": "விடுத்தன் + ஐ → விடுத்தனை", "result": "விடுத்தனை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'விடுத்தன் + ஐ'
  AND after_form = 'விடுத்தனை';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு அகரம் ஏற்கும்", "result": "இது + அன்"}, {"condition": "விளைவு", "rule": "இது + அன் → இதன்", "result": "இதன்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு அகரம் ஏற்கும்'
  AND before_form = 'இது + அன்'
  AND after_form = 'இதன்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "னகரம் றகரமாகத் திரியும்", "result": "இதன் + கு"}, {"condition": "விளைவு", "rule": "இதன் + கு → இதற்கு", "result": "இதற்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'னகரம் றகரமாகத் திரியும்'
  AND before_form = 'இதன் + கு'
  AND after_form = 'இதற்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இதற்கு + ஆ"}, {"condition": "விளைவு", "rule": "இதற்கு + ஆ → இதற்கா", "result": "இதற்கா"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இதற்கு + ஆ'
  AND after_form = 'இதற்கா';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எடு + த்"}, {"condition": "விளைவு", "rule": "எடு + த் → எடுத்", "result": "எடுத்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எடு + த்'
  AND after_form = 'எடுத்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எடுத் + த்"}, {"condition": "விளைவு", "rule": "எடுத் + த் → எடுத்த்", "result": "எடுத்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எடுத் + த்'
  AND after_form = 'எடுத்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எடுத்த் + அ"}, {"condition": "விளைவு", "rule": "எடுத்த் + அ → எடுத்த", "result": "எடுத்த"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எடுத்த் + அ'
  AND after_form = 'எடுத்த';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஒளி + க்"}, {"condition": "விளைவு", "rule": "ஒளி + க் → ஒளிக்", "result": "ஒளிக்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஒளி + க்'
  AND after_form = 'ஒளிக்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஒளிக் + கு"}, {"condition": "விளைவு", "rule": "ஒளிக் + கு → ஒளிக்கு", "result": "ஒளிக்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஒளிக் + கு'
  AND after_form = 'ஒளிக்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஒளிக்கு + வை"}, {"condition": "விளைவு", "rule": "ஒளிக்கு + வை → ஒளிக்குவை", "result": "ஒளிக்குவை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஒளிக்கு + வை'
  AND after_form = 'ஒளிக்குவை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உன் + குழி"}, {"condition": "விளைவு", "rule": "உன் + குழி → உன்குழி", "result": "உன்குழி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உன் + குழி'
  AND after_form = 'உன்குழி';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "வாய் + உம்"}, {"condition": "விளைவு", "rule": "வாய் + உம் → வாயும்", "result": "வாயும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'வாய் + உம்'
  AND after_form = 'வாயும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "வாயும் + ஓர்"}, {"condition": "விளைவு", "rule": "வாயும் + ஓர் → வாயுமோர்", "result": "வாயுமோர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'வாயும் + ஓர்'
  AND after_form = 'வாயுமோர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "உருண்டை + ஆல்"}, {"condition": "விளைவு", "rule": "உருண்டை + ஆல் → உருண்டையால்", "result": "உருண்டையால்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'உருண்டை + ஆல்'
  AND after_form = 'உருண்டையால்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "ககரம் பகரமாகத் திரியும் (ஒற்று மிகும்)", "result": "விழும் + புகழ்"}, {"condition": "விளைவு", "rule": "விழும் + புகழ் → விழுப்புகழ்", "result": "விழுப்புகழ்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ககரம் பகரமாகத் திரியும் (ஒற்று மிகும்)'
  AND before_form = 'விழும் + புகழ்'
  AND after_form = 'விழுப்புகழ்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு அகரம் ஏற்கும்", "result": "வேண்டு + அல்"}, {"condition": "விளைவு", "rule": "வேண்டு + அல் → வேண்டல்", "result": "வேண்டல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு அகரம் ஏற்கும்'
  AND before_form = 'வேண்டு + அல்'
  AND after_form = 'வேண்டல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "வேண்டல் + ஐ"}, {"condition": "விளைவு", "rule": "வேண்டல் + ஐ → வேண்டலை", "result": "வேண்டலை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'வேண்டல் + ஐ'
  AND after_form = 'வேண்டலை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "அறி + வ்"}, {"condition": "விளைவு", "rule": "அறி + வ் → அறிவ்", "result": "அறிவ்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'அறி + வ்'
  AND after_form = 'அறிவ்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "அறிவ் + ஓம்"}, {"condition": "விளைவு", "rule": "அறிவ் + ஓம் → அறிவோம்", "result": "அறிவோம்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'அறிவ் + ஓம்'
  AND after_form = 'அறிவோம்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஏன் + இது"}, {"condition": "விளைவு", "rule": "ஏன் + இது → ஏனிது", "result": "ஏனிது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஏன் + இது'
  AND after_form = 'ஏனிது';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "துதி + க்"}, {"condition": "விளைவு", "rule": "துதி + க் → துதிக்", "result": "துதிக்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'துதி + க்'
  AND after_form = 'துதிக்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "துதிக் + க்"}, {"condition": "விளைவு", "rule": "துதிக் + க் → துதிக்க்", "result": "துதிக்க்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'துதிக் + க்'
  AND after_form = 'துதிக்க்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "துதிக்க் + அல்"}, {"condition": "விளைவு", "rule": "துதிக்க் + அல் → துதிக்கல்", "result": "துதிக்கல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'துதிக்க் + அல்'
  AND after_form = 'துதிக்கல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "துதிக்கல் + அம்"}, {"condition": "விளைவு", "rule": "துதிக்கல் + அம் → துதிக்கலம்", "result": "துதிக்கலம்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'துதிக்கல் + அம்'
  AND after_form = 'துதிக்கலம்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உன் + தொழில்"}, {"condition": "விளைவு", "rule": "உன் + தொழில் → உன்தொழில்", "result": "உன்தொழில்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உன் + தொழில்'
  AND after_form = 'உன்தொழில்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "நடத்து + தி"}, {"condition": "விளைவு", "rule": "நடத்து + தி → நடத்துதி", "result": "நடத்துதி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'நடத்து + தி'
  AND after_form = 'நடத்துதி';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எங்கு + உம்"}, {"condition": "விளைவு", "rule": "எங்கு + உம் → எங்கும்", "result": "எங்கும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எங்கு + உம்'
  AND after_form = 'எங்கும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "இ + ஙனம்"}, {"condition": "விளைவு", "rule": "இ + ஙனம் → இங்ஙனம்", "result": "இங்ஙனம்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'இ + ஙனம்'
  AND after_form = 'இங்ஙனம்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இங்ஙனம் + ஏ"}, {"condition": "விளைவு", "rule": "இங்ஙனம் + ஏ → இங்ஙனே", "result": "இங்ஙனே"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இங்ஙனம் + ஏ'
  AND after_form = 'இங்ஙனே';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இன்பு + உம்"}, {"condition": "விளைவு", "rule": "இன்பு + உம் → இன்பும்", "result": "இன்பும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இன்பு + உம்'
  AND after_form = 'இன்பும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "ழகரம் ணகரமாகத் திரியும்", "result": "வாழ் + நாள்"}, {"condition": "விளைவு", "rule": "வாழ் + நாள் → வாணாள்", "result": "வாணாள்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ழகரம் ணகரமாகத் திரியும்'
  AND before_form = 'வாழ் + நாள்'
  AND after_form = 'வாணாள்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "என் + ஏ"}, {"condition": "விளைவு", "rule": "என் + ஏ → என்னே", "result": "என்னே"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'என் + ஏ'
  AND after_form = 'என்னே';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "காலை + இல்"}, {"condition": "விளைவு", "rule": "காலை + இல் → காலையில்", "result": "காலையில்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'காலை + இல்'
  AND after_form = 'காலையில்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இன் இணையும்", "result": "வேண்டு + இன்"}, {"condition": "விளைவு", "rule": "வேண்டு + இன் → வேண்டின்", "result": "வேண்டின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இன் இணையும்'
  AND before_form = 'வேண்டு + இன்'
  AND after_form = 'வேண்டின்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஆய் இணையும்", "result": "விரைவு + ஆய்"}, {"condition": "விளைவு", "rule": "விரைவு + ஆய் → விரைவாய்", "result": "விரைவாய்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஆய் இணையும்'
  AND before_form = 'விரைவு + ஆய்'
  AND after_form = 'விரைவாய்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இன் இணையும்", "result": "முடுக்கு + இன்"}, {"condition": "விளைவு", "rule": "முடுக்கு + இன் → முடுக்கின்", "result": "முடுக்கின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இன் இணையும்'
  AND before_form = 'முடுக்கு + இன்'
  AND after_form = 'முடுக்கின்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "முடுக்கின் + உம்"}, {"condition": "விளைவு", "rule": "முடுக்கின் + உம் → முடுக்கினும்", "result": "முடுக்கினும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'முடுக்கின் + உம்'
  AND after_form = 'முடுக்கினும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரியும்", "result": "முடி + உம்"}, {"condition": "விளைவு", "rule": "முடி + உம் → முடியும்", "result": "முடியும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரியும்'
  AND before_form = 'முடி + உம்'
  AND after_form = 'முடியும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "எ + வினை"}, {"condition": "விளைவு", "rule": "எ + வினை → எவ்வினை", "result": "எவ்வினை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'எ + வினை'
  AND after_form = 'எவ்வினை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எவ்வினை + ஓர்"}, {"condition": "விளைவு", "rule": "எவ்வினை + ஓர் → எவ்வினையோர்", "result": "எவ்வினையோர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எவ்வினை + ஓர்'
  AND after_form = 'எவ்வினையோர்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எவ்வினையோர் + கு"}, {"condition": "விளைவு", "rule": "எவ்வினையோர் + கு → எவ்வினையோர்க்கு", "result": "எவ்வினையோர்க்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எவ்வினையோர் + கு'
  AND after_form = 'எவ்வினையோர்க்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எவ்வினையோர்க்கு + உம்"}, {"condition": "விளைவு", "rule": "எவ்வினையோர்க்கு + உம் → எவ்வினையோர்க்கும்", "result": "எவ்வினையோர்க்கும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எவ்வினையோர்க்கு + உம்'
  AND after_form = 'எவ்வினையோர்க்கும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "இம்மை + இல்"}, {"condition": "விளைவு", "rule": "இம்மை + இல் → இம்மையில்", "result": "இம்மையில்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'இம்மை + இல்'
  AND after_form = 'இம்மையில்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "தம் + ஐ"}, {"condition": "விளைவு", "rule": "தம் + ஐ → தம்மை", "result": "தம்மை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'தம் + ஐ'
  AND after_form = 'தம்மை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இயக்கு + தல்"}, {"condition": "விளைவு", "rule": "இயக்கு + தல் → இயக்குதல்", "result": "இயக்குதல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இயக்கு + தல்'
  AND after_form = 'இயக்குதல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "லகரம் றகரமாகத் திரியும்", "result": "இயக்குதல் + கு"}, {"condition": "விளைவு", "rule": "இயக்குதல் + கு → இயக்குதற்கு", "result": "இயக்குதற்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'லகரம் றகரமாகத் திரியும்'
  AND before_form = 'இயக்குதல் + கு'
  AND after_form = 'இயக்குதற்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பயக்கு + உம்"}, {"condition": "விளைவு", "rule": "பயக்கு + உம் → பயக்கும்", "result": "பயக்கும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பயக்கு + உம்'
  AND after_form = 'பயக்கும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "வேண்டு + உம்"}, {"condition": "விளைவு", "rule": "வேண்டு + உம் → வேண்டும்", "result": "வேண்டும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'வேண்டு + உம்'
  AND after_form = 'வேண்டும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "போல் + ஆம்."}, {"condition": "விளைவு", "rule": "போல் + ஆம். → போலாம்.", "result": "போலாம்."}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'போல் + ஆம்.'
  AND after_form = 'போலாம்.';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "எ + பொருள்"}, {"condition": "விளைவு", "rule": "எ + பொருள் → எப்பொருள்", "result": "எப்பொருள்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'எ + பொருள்'
  AND after_form = 'எப்பொருள்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எப்பொருள் + தான்"}, {"condition": "விளைவு", "rule": "எப்பொருள் + தான் → எப்பொருள்தான்", "result": "எப்பொருள்தான்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எப்பொருள் + தான்'
  AND after_form = 'எப்பொருள்தான்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு அகரம் ஏற்கும்", "result": "இலக்கு + அற்று"}, {"condition": "விளைவு", "rule": "இலக்கு + அற்று → இலக்கற்று", "result": "இலக்கற்று"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு அகரம் ஏற்கும்'
  AND before_form = 'இலக்கு + அற்று'
  AND after_form = 'இலக்கற்று';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இரு + ப்"}, {"condition": "விளைவு", "rule": "இரு + ப் → இருப்", "result": "இருப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இரு + ப்'
  AND after_form = 'இருப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இருப் + ப்"}, {"condition": "விளைவு", "rule": "இருப் + ப் → இருப்ப்", "result": "இருப்ப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இருப் + ப்'
  AND after_form = 'இருப்ப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இருப்ப் + அது"}, {"condition": "விளைவு", "rule": "இருப்ப் + அது → இருப்பது", "result": "இருப்பது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இருப்ப் + அது'
  AND after_form = 'இருப்பது';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "இ + கரை"}, {"condition": "விளைவு", "rule": "இ + கரை → இக்கரை", "result": "இக்கரை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'இ + கரை'
  AND after_form = 'இக்கரை';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு அகரம் ஏற்கும்", "result": "அது + அன்"}, {"condition": "விளைவு", "rule": "அது + அன் → அதன்", "result": "அதன்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு அகரம் ஏற்கும்'
  AND before_form = 'அது + அன்'
  AND after_form = 'அதன்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஓகாரம் ஏற்கும்", "result": "குறிப்பு + ஒடு"}, {"condition": "விளைவு", "rule": "குறிப்பு + ஒடு → குறிப்பொடு", "result": "குறிப்பொடு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஓகாரம் ஏற்கும்'
  AND before_form = 'குறிப்பு + ஒடு'
  AND after_form = 'குறிப்பொடு';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு அகரம் ஏற்கும்", "result": "புக்கு + அ"}, {"condition": "விளைவு", "rule": "புக்கு + அ → புக்க", "result": "புக்க"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு அகரம் ஏற்கும்'
  AND before_form = 'புக்கு + அ'
  AND after_form = 'புக்க';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "புக்க + விட்டு"}, {"condition": "விளைவு", "rule": "புக்க + விட்டு → புக்கவிட்டு", "result": "புக்கவிட்டு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'புக்க + விட்டு'
  AND after_form = 'புக்கவிட்டு';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இகரம் ஏற்கும்", "result": "புக்கவிட்டு + இரு"}, {"condition": "விளைவு", "rule": "புக்கவிட்டு + இரு → புக்கவிட்டிரு", "result": "புக்கவிட்டிரு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இகரம் ஏற்கும்'
  AND before_form = 'புக்கவிட்டு + இரு'
  AND after_form = 'புக்கவிட்டிரு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "புக்கவிட்டிரு + க்"}, {"condition": "விளைவு", "rule": "புக்கவிட்டிரு + க் → புக்கவிட்டிருக்", "result": "புக்கவிட்டிருக்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'புக்கவிட்டிரு + க்'
  AND after_form = 'புக்கவிட்டிருக்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "புக்கவிட்டிருக் + க்"}, {"condition": "விளைவு", "rule": "புக்கவிட்டிருக் + க் → புக்கவிட்டிருக்க்", "result": "புக்கவிட்டிருக்க்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'புக்கவிட்டிருக் + க்'
  AND after_form = 'புக்கவிட்டிருக்க்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "புக்கவிட்டிருக்க் + உம்"}, {"condition": "விளைவு", "rule": "புக்கவிட்டிருக்க் + உம் → புக்கவிட்டிருக்கும்", "result": "புக்கவிட்டிருக்கும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'புக்கவிட்டிருக்க் + உம்'
  AND after_form = 'புக்கவிட்டிருக்கும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "இ + புல்"}, {"condition": "விளைவு", "rule": "இ + புல் → இப்புல்", "result": "இப்புல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'இ + புல்'
  AND after_form = 'இப்புல்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "இப்புல் + இன்"}, {"condition": "விளைவு", "rule": "இப்புல் + இன் → இப்புல்லின்", "result": "இப்புல்லின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'இப்புல் + இன்'
  AND after_form = 'இப்புல்லின்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பரிவு + உம்"}, {"condition": "விளைவு", "rule": "பரிவு + உம் → பரிவும்", "result": "பரிவும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பரிவு + உம்'
  AND after_form = 'பரிவும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "பொறுமை + உம்"}, {"condition": "விளைவு", "rule": "பொறுமை + உம் → பொறுமையும்", "result": "பொறுமையும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'பொறுமை + உம்'
  AND after_form = 'பொறுமையும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "புலன் + உம்"}, {"condition": "விளைவு", "rule": "புலன் + உம் → புலனும்", "result": "புலனும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'புலன் + உம்'
  AND after_form = 'புலனும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "காண் + ப்"}, {"condition": "விளைவு", "rule": "காண் + ப் → காண்ப்", "result": "காண்ப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'காண் + ப்'
  AND after_form = 'காண்ப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "காண்ப் + ஓர்"}, {"condition": "விளைவு", "rule": "காண்ப் + ஓர் → காண்போர்", "result": "காண்போர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'காண்ப் + ஓர்'
  AND after_form = 'காண்போர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஐகாரம் ஏற்கும்", "result": "ஒன்று + ஐ"}, {"condition": "விளைவு", "rule": "ஒன்று + ஐ → ஒன்றை", "result": "ஒன்றை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஐகாரம் ஏற்கும்'
  AND before_form = 'ஒன்று + ஐ'
  AND after_form = 'ஒன்றை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஒன்றை + உம்"}, {"condition": "விளைவு", "rule": "ஒன்றை + உம் → ஒன்றையும்", "result": "ஒன்றையும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஒன்றை + உம்'
  AND after_form = 'ஒன்றையும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார் + த்"}, {"condition": "விளைவு", "rule": "பார் + த் → பார்த்", "result": "பார்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார் + த்'
  AND after_form = 'பார்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார்த் + த்"}, {"condition": "விளைவு", "rule": "பார்த் + த் → பார்த்த்", "result": "பார்த்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார்த் + த்'
  AND after_form = 'பார்த்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார்த்த் + உ"}, {"condition": "விளைவு", "rule": "பார்த்த் + உ → பார்த்து", "result": "பார்த்து"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார்த்த் + உ'
  AND after_form = 'பார்த்து';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார்த்து + ப்"}, {"condition": "விளைவு", "rule": "பார்த்து + ப் → பார்த்துப்", "result": "பார்த்துப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார்த்து + ப்'
  AND after_form = 'பார்த்துப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார்த்துப் + பார்"}, {"condition": "விளைவு", "rule": "பார்த்துப் + பார் → பார்த்துப்பார்", "result": "பார்த்துப்பார்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார்த்துப் + பார்'
  AND after_form = 'பார்த்துப்பார்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார்த்துப்பார் + த்"}, {"condition": "விளைவு", "rule": "பார்த்துப்பார் + த் → பார்த்துப்பார்த்", "result": "பார்த்துப்பார்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார்த்துப்பார் + த்'
  AND after_form = 'பார்த்துப்பார்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார்த்துப்பார்த் + த்"}, {"condition": "விளைவு", "rule": "பார்த்துப்பார்த் + த் → பார்த்துப்பார்த்த்", "result": "பார்த்துப்பார்த்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார்த்துப்பார்த் + த்'
  AND after_form = 'பார்த்துப்பார்த்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார்த்துப்பார்த்த் + உ"}, {"condition": "விளைவு", "rule": "பார்த்துப்பார்த்த் + உ → பார்த்துப்பார்த்து", "result": "பார்த்துப்பார்த்து"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார்த்துப்பார்த்த் + உ'
  AND after_form = 'பார்த்துப்பார்த்து';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார்த்துப்பார்த்து + த்"}, {"condition": "விளைவு", "rule": "பார்த்துப்பார்த்து + த் → பார்த்துப்பார்த்துத்", "result": "பார்த்துப்பார்த்துத்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார்த்துப்பார்த்து + த்'
  AND after_form = 'பார்த்துப்பார்த்துத்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பார்த்துப்பார்த்துத் + தம்"}, {"condition": "விளைவு", "rule": "பார்த்துப்பார்த்துத் + தம் → பார்த்துப்பார்த்துத்தம்", "result": "பார்த்துப்பார்த்துத்தம்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பார்த்துப்பார்த்துத் + தம்'
  AND after_form = 'பார்த்துப்பார்த்துத்தம்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பனி + ப்"}, {"condition": "விளைவு", "rule": "பனி + ப் → பனிப்", "result": "பனிப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பனி + ப்'
  AND after_form = 'பனிப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பனிப் + ப்"}, {"condition": "விளைவு", "rule": "பனிப் + ப் → பனிப்ப்", "result": "பனிப்ப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பனிப் + ப்'
  AND after_form = 'பனிப்ப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பனிப்ப் + அ"}, {"condition": "விளைவு", "rule": "பனிப்ப் + அ → பனிப்ப", "result": "பனிப்ப"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பனிப்ப் + அ'
  AND after_form = 'பனிப்ப';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஆர் + த்"}, {"condition": "விளைவு", "rule": "ஆர் + த் → ஆர்த்", "result": "ஆர்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஆர் + த்'
  AND after_form = 'ஆர்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஆர்த் + த்"}, {"condition": "விளைவு", "rule": "ஆர்த் + த் → ஆர்த்த்", "result": "ஆர்த்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஆர்த் + த்'
  AND after_form = 'ஆர்த்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஆர்த்த் + உ"}, {"condition": "விளைவு", "rule": "ஆர்த்த் + உ → ஆர்த்து", "result": "ஆர்த்து"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஆர்த்த் + உ'
  AND after_form = 'ஆர்த்து';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு எகரம் ஏற்கும்", "result": "ஆர்த்து + எழு"}, {"condition": "விளைவு", "rule": "ஆர்த்து + எழு → ஆர்த்தெழு", "result": "ஆர்த்தெழு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு எகரம் ஏற்கும்'
  AND before_form = 'ஆர்த்து + எழு'
  AND after_form = 'ஆர்த்தெழு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஆர்த்தெழு + உம்"}, {"condition": "விளைவு", "rule": "ஆர்த்தெழு + உம் → ஆர்த்தெழும்", "result": "ஆர்த்தெழும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஆர்த்தெழு + உம்'
  AND after_form = 'ஆர்த்தெழும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இன் இணையும்", "result": "அன்பு + இன்"}, {"condition": "விளைவு", "rule": "அன்பு + இன் → அன்பின்", "result": "அன்பின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இன் இணையும்'
  AND before_form = 'அன்பு + இன்'
  AND after_form = 'அன்பின்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "அன்பின் + ஆல்"}, {"condition": "விளைவு", "rule": "அன்பின் + ஆல் → அன்பினால்", "result": "அன்பினால்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'அன்பின் + ஆல்'
  AND after_form = 'அன்பினால்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஐகாரம் ஏற்கும்", "result": "அனைத்து + ஐ"}, {"condition": "விளைவு", "rule": "அனைத்து + ஐ → அனைத்தை", "result": "அனைத்தை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஐகாரம் ஏற்கும்'
  AND before_form = 'அனைத்து + ஐ'
  AND after_form = 'அனைத்தை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "அனைத்தை + உம்"}, {"condition": "விளைவு", "rule": "அனைத்தை + உம் → அனைத்தையும்", "result": "அனைத்தையும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'அனைத்தை + உம்'
  AND after_form = 'அனைத்தையும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "மெய் நகர மாற்றம்", "result": "கல + த்(ந்)"}, {"condition": "விளைவு", "rule": "கல + த்(ந்) → கலந்", "result": "கலந்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'மெய் நகர மாற்றம்'
  AND before_form = 'கல + த்(ந்)'
  AND after_form = 'கலந்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கலந் + த்"}, {"condition": "விளைவு", "rule": "கலந் + த் → கலந்த்", "result": "கலந்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கலந் + த்'
  AND after_form = 'கலந்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கலந்த் + உ"}, {"condition": "விளைவு", "rule": "கலந்த் + உ → கலந்து", "result": "கலந்து"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கலந்த் + உ'
  AND after_form = 'கலந்து';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு எகரம் ஏற்கும்", "result": "என்பு + எலாம்"}, {"condition": "விளைவு", "rule": "என்பு + எலாம் → என்பெலாம்", "result": "என்பெலாம்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு எகரம் ஏற்கும்'
  AND before_form = 'என்பு + எலாம்'
  AND after_form = 'என்பெலாம்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கரை + க்"}, {"condition": "விளைவு", "rule": "கரை + க் → கரைக்", "result": "கரைக்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கரை + க்'
  AND after_form = 'கரைக்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கரைக் + க்"}, {"condition": "விளைவு", "rule": "கரைக் + க் → கரைக்க்", "result": "கரைக்க்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கரைக் + க்'
  AND after_form = 'கரைக்க்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கரைக்க் + உ"}, {"condition": "விளைவு", "rule": "கரைக்க் + உ → கரைக்கு", "result": "கரைக்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கரைக்க் + உ'
  AND after_form = 'கரைக்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கரைக்கு + நல்"}, {"condition": "விளைவு", "rule": "கரைக்கு + நல் → கரைக்குநல்", "result": "கரைக்குநல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கரைக்கு + நல்'
  AND after_form = 'கரைக்குநல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "திளை + ப்"}, {"condition": "விளைவு", "rule": "திளை + ப் → திளைப்", "result": "திளைப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'திளை + ப்'
  AND after_form = 'திளைப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "திளைப் + ப்"}, {"condition": "விளைவு", "rule": "திளைப் + ப் → திளைப்ப்", "result": "திளைப்ப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'திளைப் + ப்'
  AND after_form = 'திளைப்ப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "திளைப்ப் + அர்"}, {"condition": "விளைவு", "rule": "திளைப்ப் + அர் → திளைப்பர்", "result": "திளைப்பர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'திளைப்ப் + அர்'
  AND after_form = 'திளைப்பர்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஓ + க்"}, {"condition": "விளைவு", "rule": "ஓ + க் → ஓக்", "result": "ஓக்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஓ + க்'
  AND after_form = 'ஓக்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "திரிபு நிலை", "result": "ஓக் + ஓ"}, {"condition": "விளைவு", "rule": "ஓக் + ஓ → ஓகோ", "result": "ஓகோ"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'திரிபு நிலை'
  AND before_form = 'ஓக் + ஓ'
  AND after_form = 'ஓகோ';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "நாங்கூழ்ப்புழு + ஏ"}, {"condition": "விளைவு", "rule": "நாங்கூழ்ப்புழு + ஏ → நாங்கூழ்ப்புழுவே", "result": "நாங்கூழ்ப்புழுவே"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'நாங்கூழ்ப்புழு + ஏ'
  AND after_form = 'நாங்கூழ்ப்புழுவே';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "ஓவா + பாடு"}, {"condition": "விளைவு", "rule": "ஓவா + பாடு → ஓவாப்பாடு", "result": "ஓவாப்பாடு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'ஓவா + பாடு'
  AND after_form = 'ஓவாப்பாடு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஓவாப்பாடு + ஏ"}, {"condition": "விளைவு", "rule": "ஓவாப்பாடு + ஏ → ஓவாப்பாடே", "result": "ஓவாப்பாடே"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஓவாப்பாடு + ஏ'
  AND after_form = 'ஓவாப்பாடே';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உணர் + வ்"}, {"condition": "விளைவு", "rule": "உணர் + வ் → உணர்வ்", "result": "உணர்வ்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உணர் + வ்'
  AND after_form = 'உணர்வ்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உணர்வ் + ஏன்"}, {"condition": "விளைவு", "rule": "உணர்வ் + ஏன் → உணர்வேன்", "result": "உணர்வேன்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உணர்வ் + ஏன்'
  AND after_form = 'உணர்வேன்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உழை + ப்"}, {"condition": "விளைவு", "rule": "உழை + ப் → உழைப்", "result": "உழைப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உழை + ப்'
  AND after_form = 'உழைப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உழைப் + ப்"}, {"condition": "விளைவு", "rule": "உழைப் + ப் → உழைப்ப்", "result": "உழைப்ப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உழைப் + ப்'
  AND after_form = 'உழைப்ப்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஓகாரம் ஏற்கும்", "result": "உழைப்ப் + ஓர்"}, {"condition": "விளைவு", "rule": "உழைப்ப் + ஓர் → உழைப்போர்", "result": "உழைப்போர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஓகாரம் ஏற்கும்'
  AND before_form = 'உழைப்ப் + ஓர்'
  AND after_form = 'உழைப்போர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இகரம் ஏற்கும்", "result": "உழைப்பு + இல்"}, {"condition": "விளைவு", "rule": "உழைப்பு + இல் → உழைப்பில்", "result": "உழைப்பில்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இகரம் ஏற்கும்'
  AND before_form = 'உழைப்பு + இல்'
  AND after_form = 'உழைப்பில்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "உழு + வ்"}, {"condition": "விளைவு", "rule": "உழு + வ் → உழுவ்", "result": "உழுவ்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'உழு + வ்'
  AND after_form = 'உழுவ்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உழுவ் + ஓர்"}, {"condition": "விளைவு", "rule": "உழுவ் + ஓர் → உழுவோர்", "result": "உழுவோர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உழுவ் + ஓர்'
  AND after_form = 'உழுவோர்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "லகரம் னகரமாகத் திரியும்", "result": "தொழில் + மிகு"}, {"condition": "விளைவு", "rule": "தொழில் + மிகு → தொழின்மிகு", "result": "தொழின்மிகு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'லகரம் னகரமாகத் திரியும்'
  AND before_form = 'தொழில் + மிகு'
  AND after_form = 'தொழின்மிகு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "தொழின்மிகு + உம்"}, {"condition": "விளைவு", "rule": "தொழின்மிகு + உம் → தொழின்மிகும்", "result": "தொழின்மிகும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'தொழின்மிகு + உம்'
  AND after_form = 'தொழின்மிகும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "எ + மண்"}, {"condition": "விளைவு", "rule": "எ + மண் → எம்மண்", "result": "எம்மண்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'எ + மண்'
  AND after_form = 'எம்மண்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "எம்மண் + ஆய்"}, {"condition": "விளைவு", "rule": "எம்மண் + ஆய் → எம்மண்ணாய்", "result": "எம்மண்ணாய்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'எம்மண் + ஆய்'
  AND after_form = 'எம்மண்ணாய்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எம்மண்ணாய் + இன்"}, {"condition": "விளைவு", "rule": "எம்மண்ணாய் + இன் → எம்மண்ணாயின்", "result": "எம்மண்ணாயின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எம்மண்ணாய் + இன்'
  AND after_form = 'எம்மண்ணாயின்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எம்மண்ணாயின் + உம்"}, {"condition": "விளைவு", "rule": "எம்மண்ணாயின் + உம் → எம்மண்ணாயினும்", "result": "எம்மண்ணாயினும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எம்மண்ணாயின் + உம்'
  AND after_form = 'எம்மண்ணாயினும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்", "result": "நன்மை + மண்"}, {"condition": "விளைவு", "rule": "நன்மை + மண் → நன்மண்", "result": "நன்மண்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்'
  AND before_form = 'நன்மை + மண்'
  AND after_form = 'நன்மண்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "நன்மண் + ஆக்கு"}, {"condition": "விளைவு", "rule": "நன்மண் + ஆக்கு → நன்மண்ணாக்கு", "result": "நன்மண்ணாக்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'நன்மண் + ஆக்கு'
  AND after_form = 'நன்மண்ணாக்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "நன்மண்ணாக்கு + வை"}, {"condition": "விளைவு", "rule": "நன்மண்ணாக்கு + வை → நன்மண்ணாக்குவை", "result": "நன்மண்ணாக்குவை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'நன்மண்ணாக்கு + வை'
  AND after_form = 'நன்மண்ணாக்குவை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "அடுக்குத் தொடர் புணர்ச்சி (பாடநூல்)", "result": "உழுது + உழுது"}, {"condition": "விளைவு", "rule": "உழுது + உழுது → உழுதுழுது", "result": "உழுதுழுது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'அடுக்குத் தொடர் புணர்ச்சி (பாடநூல்)'
  AND before_form = 'உழுது + உழுது'
  AND after_form = 'உழுதுழுது';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு இன் இணையும்", "result": "மெழுகு + இன்"}, {"condition": "விளைவு", "rule": "மெழுகு + இன் → மெழுகின்", "result": "மெழுகின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு இன் இணையும்'
  AND before_form = 'மெழுகு + இன்'
  AND after_form = 'மெழுகின்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "மெழுகின் + உம்"}, {"condition": "விளைவு", "rule": "மெழுகின் + உம் → மெழுகினும்", "result": "மெழுகினும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'மெழுகின் + உம்'
  AND after_form = 'மெழுகினும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "நேர்மை + இய"}, {"condition": "விளைவு", "rule": "நேர்மை + இய → நேரிய", "result": "நேரிய"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'நேர்மை + இய'
  AND after_form = 'நேரிய';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "வெளி + கொணர்"}, {"condition": "விளைவு", "rule": "வெளி + கொணர் → வெளிக்கொணர்", "result": "வெளிக்கொணர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'வெளி + கொணர்'
  AND after_form = 'வெளிக்கொணர்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "மெய் நகர மாற்றம்", "result": "வெளிக்கொணர் + த்(ந்)"}, {"condition": "விளைவு", "rule": "வெளிக்கொணர் + த்(ந்) → வெளிக்கொணர்ந்", "result": "வெளிக்கொணர்ந்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'மெய் நகர மாற்றம்'
  AND before_form = 'வெளிக்கொணர் + த்(ந்)'
  AND after_form = 'வெளிக்கொணர்ந்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "வெளிக்கொணர்ந் + த்"}, {"condition": "விளைவு", "rule": "வெளிக்கொணர்ந் + த் → வெளிக்கொணர்ந்த்", "result": "வெளிக்கொணர்ந்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'வெளிக்கொணர்ந் + த்'
  AND after_form = 'வெளிக்கொணர்ந்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "வெளிக்கொணர்ந்த் + உம்"}, {"condition": "விளைவு", "rule": "வெளிக்கொணர்ந்த் + உம் → வெளிக்கொணர்ந்தும்", "result": "வெளிக்கொணர்ந்தும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'வெளிக்கொணர்ந்த் + உம்'
  AND after_form = 'வெளிக்கொணர்ந்தும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு அகரம் ஏற்கும்", "result": "வேண்டு + (ஆ)"}, {"condition": "விளைவு", "rule": "வேண்டு + (ஆ) → வேண்டா", "result": "வேண்டா"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு அகரம் ஏற்கும்'
  AND before_form = 'வேண்டு + (ஆ)'
  AND after_form = 'வேண்டா';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "வேண்டா + ஆர்"}, {"condition": "விளைவு", "rule": "வேண்டா + ஆர் → வேண்டார்", "result": "வேண்டார்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'வேண்டா + ஆர்'
  AND after_form = 'வேண்டார்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "லகரம் றகரமாகத் திரியும்", "result": "இப்புல் + பயிர்"}, {"condition": "விளைவு", "rule": "இப்புல் + பயிர் → இப்புற்பயிர்", "result": "இப்புற்பயிர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'லகரம் றகரமாகத் திரியும்'
  AND before_form = 'இப்புல் + பயிர்'
  AND after_form = 'இப்புற்பயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "இப்புற்பயிர் + நீ"}, {"condition": "விளைவு", "rule": "இப்புற்பயிர் + நீ → இப்புற்பயிர்நீ", "result": "இப்புற்பயிர்நீ"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'இப்புற்பயிர் + நீ'
  AND after_form = 'இப்புற்பயிர்நீ';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஆகாரம் ஏற்கும்", "result": "உழு + ஆ"}, {"condition": "விளைவு", "rule": "உழு + ஆ → உழா", "result": "உழா"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஆகாரம் ஏற்கும்'
  AND before_form = 'உழு + ஆ'
  AND after_form = 'உழா';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "உழா + ஏல்"}, {"condition": "விளைவு", "rule": "உழா + ஏல் → உழாயேல்", "result": "உழாயேல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'உழா + ஏல்'
  AND after_form = 'உழாயேல்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும்", "result": "எ + படி"}, {"condition": "விளைவு", "rule": "எ + படி → எப்படி", "result": "எப்படி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'எ + படி'
  AND after_form = 'எப்படி';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஆகாரம் ஏற்கும்", "result": "உண்டு + ஆம்"}, {"condition": "விளைவு", "rule": "உண்டு + ஆம் → உண்டாம்", "result": "உண்டாம்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஆகாரம் ஏற்கும்'
  AND before_form = 'உண்டு + ஆம்'
  AND after_form = 'உண்டாம்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "எண் + (ஆ)"}, {"condition": "விளைவு", "rule": "எண் + (ஆ) → எண்ணா", "result": "எண்ணா"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'எண் + (ஆ)'
  AND after_form = 'எண்ணா';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எண்ணா + து"}, {"condition": "விளைவு", "rule": "எண்ணா + து → எண்ணாது", "result": "எண்ணாது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எண்ணா + து'
  AND after_form = 'எண்ணாது';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உனக்கு + உம்"}, {"condition": "விளைவு", "rule": "உனக்கு + உம் → உனக்கும்", "result": "உனக்கும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உனக்கு + உம்'
  AND after_form = 'உனக்கும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "எறும்பு + உம்"}, {"condition": "விளைவு", "rule": "எறும்பு + உம் → எறும்பும்", "result": "எறும்பும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'எறும்பு + உம்'
  AND after_form = 'எறும்பும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரியும்", "result": "கோடி + ஆய்"}, {"condition": "விளைவு", "rule": "கோடி + ஆய் → கோடியாய்", "result": "கோடியாய்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரியும்'
  AND before_form = 'கோடி + ஆய்'
  AND after_form = 'கோடியாய்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கோடியாய் + அ"}, {"condition": "விளைவு", "rule": "கோடியாய் + அ → கோடியாய", "result": "கோடியாய"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கோடியாய் + அ'
  AND after_form = 'கோடியாய';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "கோடியாய + ப்"}, {"condition": "விளைவு", "rule": "கோடியாய + ப் → கோடியாயப்", "result": "கோடியாயப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'கோடியாய + ப்'
  AND after_form = 'கோடியாயப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "புழு + க்"}, {"condition": "விளைவு", "rule": "புழு + க் → புழுக்", "result": "புழுக்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'புழு + க்'
  AND after_form = 'புழுக்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "புழுக் + கள்"}, {"condition": "விளைவு", "rule": "புழுக் + கள் → புழுக்கள்", "result": "புழுக்கள்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'புழுக் + கள்'
  AND after_form = 'புழுக்கள்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "புழுக்கள் + உம்"}, {"condition": "விளைவு", "rule": "புழுக்கள் + உம் → புழுக்களும்", "result": "புழுக்களும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'புழுக்கள் + உம்'
  AND after_form = 'புழுக்களும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரியும்", "result": "பூச்சி + உம்"}, {"condition": "விளைவு", "rule": "பூச்சி + உம் → பூச்சியும்", "result": "பூச்சியும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரியும்'
  AND before_form = 'பூச்சி + உம்'
  AND after_form = 'பூச்சியும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பிழை + க்"}, {"condition": "விளைவு", "rule": "பிழை + க் → பிழைக்", "result": "பிழைக்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பிழை + க்'
  AND after_form = 'பிழைக்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பிழைக் + க்"}, {"condition": "விளைவு", "rule": "பிழைக் + க் → பிழைக்க்", "result": "பிழைக்க்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பிழைக் + க்'
  AND after_form = 'பிழைக்க்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பிழைக்க் + உம்"}, {"condition": "விளைவு", "rule": "பிழைக்க் + உம் → பிழைக்கும்", "result": "பிழைக்கும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பிழைக்க் + உம்'
  AND after_form = 'பிழைக்கும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பிழைக்கும் + ஆறு"}, {"condition": "விளைவு", "rule": "பிழைக்கும் + ஆறு → பிழைக்குமாறு", "result": "பிழைக்குமாறு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பிழைக்கும் + ஆறு'
  AND after_form = 'பிழைக்குமாறு';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "என் + ஐ"}, {"condition": "விளைவு", "rule": "என் + ஐ → என்னை", "result": "என்னை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'என் + ஐ'
  AND after_form = 'என்னை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "ஒழுக்கம் + உம்"}, {"condition": "விளைவு", "rule": "ஒழுக்கம் + உம் → ஒழுக்கமும்", "result": "ஒழுக்கமும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'ஒழுக்கம் + உம்'
  AND after_form = 'ஒழுக்கமும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "பொறை + உம்"}, {"condition": "விளைவு", "rule": "பொறை + உம் → பொறையும்", "result": "பொறையும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'பொறை + உம்'
  AND after_form = 'பொறையும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "ஒற்று மிகும்", "result": "உன் + ஐ"}, {"condition": "விளைவு", "rule": "உன் + ஐ → உன்னை", "result": "உன்னை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும்'
  AND before_form = 'உன் + ஐ'
  AND after_form = 'உன்னை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உன்னை + ப்"}, {"condition": "விளைவு", "rule": "உன்னை + ப் → உன்னைப்", "result": "உன்னைப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உன்னை + ப்'
  AND after_form = 'உன்னைப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "உன்னைப் + போல்"}, {"condition": "விளைவு", "rule": "உன்னைப் + போல் → உன்னைப்போல்", "result": "உன்னைப்போல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'உன்னைப் + போல்'
  AND after_form = 'உன்னைப்போல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "பங்கம் + இல்"}, {"condition": "விளைவு", "rule": "பங்கம் + இல் → பங்கமில்", "result": "பங்கமில்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'பங்கம் + இல்'
  AND after_form = 'பங்கமில்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "அன்பு + உம்"}, {"condition": "விளைவு", "rule": "அன்பு + உம் → அன்பும்", "result": "அன்பும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'அன்பு + உம்'
  AND after_form = 'அன்பும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு அகரம் ஏற்கும்", "result": "திருந்து + அ"}, {"condition": "விளைவு", "rule": "திருந்து + அ → திருந்த", "result": "திருந்த"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு அகரம் ஏற்கும்'
  AND before_form = 'திருந்து + அ'
  AND after_form = 'திருந்த';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இணைந்த சொல் வடிவம்", "result": "திருந்த + க்"}, {"condition": "விளைவு", "rule": "திருந்த + க் → திருந்தக்", "result": "திருந்தக்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இணைந்த சொல் வடிவம்'
  AND before_form = 'திருந்த + க்'
  AND after_form = 'திருந்தக்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "பரப்புதல் பகுதி; to spread (இன்னும் முழுச் சொல் ஆகவில்லை)", "result": "பரப்பி + த்"}, {"condition": "விளைவு", "rule": "பரப்பி + த் → பரப்பித்", "result": "பரப்பித்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பரப்புதல் பகுதி; to spread (இன்னும் முழுச் சொல் ஆகவில்லை)'
  AND before_form = 'பரப்பி + த்'
  AND after_form = 'பரப்பித்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "பரப்புதல் பகுதி; to spread (இன்னும் முழுச் சொல் ஆகவில்லை)", "result": "பரப்பித் + த்"}, {"condition": "விளைவு", "rule": "பரப்பித் + த் → பரப்பித்த்", "result": "பரப்பித்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பரப்புதல் பகுதி; to spread (இன்னும் முழுச் சொல் ஆகவில்லை)'
  AND before_form = 'பரப்பித் + த்'
  AND after_form = 'பரப்பித்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "பரப்பித்து = பரப்பிக்கொண்டு; having spread", "result": "பரப்பித்த் + உ"}, {"condition": "விளைவு", "rule": "பரப்பித்த் + உ → பரப்பித்து", "result": "பரப்பித்து"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பரப்பித்து = பரப்பிக்கொண்டு; having spread'
  AND before_form = 'பரப்பித்த் + உ'
  AND after_form = 'பரப்பித்து';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "தழைத்தல் பகுதி; to flourish (இன்னும் முழுச் சொல் ஆகவில்லை)", "result": "தழை + ப்"}, {"condition": "விளைவு", "rule": "தழை + ப் → தழைப்", "result": "தழைப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'தழைத்தல் பகுதி; to flourish (இன்னும் முழுச் சொல் ஆகவில்லை)'
  AND before_form = 'தழை + ப்'
  AND after_form = 'தழைப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "தழைத்தல் பகுதி; to flourish (இன்னும் முழுச் சொல் ஆகவில்லை) — ஒற்று மிகும்", "result": "தழைப் + ப்"}, {"condition": "விளைவு", "rule": "தழைப் + ப் → தழைப்ப்", "result": "தழைப்ப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'தழைத்தல் பகுதி; to flourish (இன்னும் முழுச் சொல் ஆகவில்லை) — ஒற்று மிகும்'
  AND before_form = 'தழைப் + ப்'
  AND after_form = 'தழைப்ப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "தழைப்பது = தழைத்தல்; the act of flourishing/thriving", "result": "தழைப்ப் + அது"}, {"condition": "விளைவு", "rule": "தழைப்ப் + அது → தழைப்பது", "result": "தழைப்பது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'தழைப்பது = தழைத்தல்; the act of flourishing/thriving'
  AND before_form = 'தழைப்ப் + அது'
  AND after_form = 'தழைப்பது';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இடைநிலை வடிவம், இன்னும் முழுமையடையவில்லை; intermediate form", "result": "தழைப்பது + அல்"}, {"condition": "விளைவு", "rule": "தழைப்பது + அல் → தழைப்பதல்", "result": "தழைப்பதல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இடைநிலை வடிவம், இன்னும் முழுமையடையவில்லை; intermediate form'
  AND before_form = 'தழைப்பது + அல்'
  AND after_form = 'தழைப்பதல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "பிழைத்தல் பகுதி; to survive, escape (இன்னும் முழுச் சொல் ஆகவில்லை)", "result": "பிழை + ப்"}, {"condition": "விளைவு", "rule": "பிழை + ப் → பிழைப்", "result": "பிழைப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பிழைத்தல் பகுதி; to survive, escape (இன்னும் முழுச் சொல் ஆகவில்லை)'
  AND before_form = 'பிழை + ப்'
  AND after_form = 'பிழைப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "பிழைத்தல் பகுதி; to survive, escape (இன்னும் முழுச் சொல் ஆகவில்லை) — ஒற்று மிகும்", "result": "பிழைப் + ப்"}, {"condition": "விளைவு", "rule": "பிழைப் + ப் → பிழைப்ப்", "result": "பிழைப்ப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பிழைத்தல் பகுதி; to survive, escape (இன்னும் முழுச் சொல் ஆகவில்லை) — ஒற்று மிகும்'
  AND before_form = 'பிழைப் + ப்'
  AND after_form = 'பிழைப்ப்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "பிழைப்பது = பிழைத்தல், வாழ்க்கை; livelihood, the act of surviving", "result": "பிழைப்ப் + அது"}, {"condition": "விளைவு", "rule": "பிழைப்ப் + அது → பிழைப்பது", "result": "பிழைப்பது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பிழைப்பது = பிழைத்தல், வாழ்க்கை; livelihood, the act of surviving'
  AND before_form = 'பிழைப்ப் + அது'
  AND after_form = 'பிழைப்பது';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இடைநிலை வடிவம், இன்னும் முழுமையடையவில்லை; intermediate form", "result": "பிழைப்பது + அல்"}, {"condition": "விளைவு", "rule": "பிழைப்பது + அல் → பிழைப்பதல்", "result": "பிழைப்பதல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இடைநிலை வடிவம், இன்னும் முழுமையடையவில்லை; intermediate form'
  AND before_form = 'பிழைப்பது + அல்'
  AND after_form = 'பிழைப்பதல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "மகர ஈறு கெட்டு அகர முதல் சொல் இணையும்", "result": "அயம் + அத்து"}, {"condition": "விளைவு", "rule": "அயம் + அத்து → அயத்து", "result": "அயத்து"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'மகர ஈறு கெட்டு அகர முதல் சொல் இணையும்'
  AND before_form = 'அயம் + அத்து'
  AND after_form = 'அயத்து';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "பாடலில் காணப்படும் இணைந்த சொல் வடிவம் (சிறுமை -> சிறு, அர் இணைப்பு, வகரம் வரும்)", "result": "சிறுமை + அர்"}, {"condition": "விளைவு", "rule": "சிறுமை + அர் → சிறுவர்", "result": "சிறுவர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பாடலில் காணப்படும் இணைந்த சொல் வடிவம் (சிறுமை -> சிறு, அர் இணைப்பு, வகரம் வரும்)'
  AND before_form = 'சிறுமை + அர்'
  AND after_form = 'சிறுவர்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "சந்தி மெய் வ் வரும் (இன்னும் முழுச் சொல் இல்லை)", "result": "உணர் + வ்"}, {"condition": "விளைவு", "rule": "உணர் + வ் → உணர்வ்", "result": "உணர்வ்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'சந்தி மெய் வ் வரும் (இன்னும் முழுச் சொல் இல்லை)'
  AND before_form = 'உணர் + வ்'
  AND after_form = 'உணர்வ்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "உணர்வேன் = நான் உணர்வேன்; I shall realise", "result": "உணர்வ் + ஏன்"}, {"condition": "விளைவு", "rule": "உணர்வ் + ஏன் → உணர்வேன்", "result": "உணர்வேன்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உணர்வேன் = நான் உணர்வேன்; I shall realise'
  AND before_form = 'உணர்வ் + ஏன்'
  AND after_form = 'உணர்வேன்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "உணர்வேன் = நான் உணர்வேன் (மீண்டும் - அழுத்தம்); I shall realise (repeated)", "result": "உணர்வ் + ஏன்"}, {"condition": "விளைவு", "rule": "உணர்வ் + ஏன் → உணர்வேன்", "result": "உணர்வேன்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உணர்வேன் = நான் உணர்வேன் (மீண்டும் - அழுத்தம்); I shall realise (repeated)'
  AND before_form = 'உணர்வ் + ஏன்'
  AND after_form = 'உணர்வேன்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "உயிர் ஈறு + ஐ இணையும்போது வகரம் வரும்", "result": "நன்மண்ணாக்கு + ஐ"}, {"condition": "விளைவு", "rule": "நன்மண்ணாக்கு + ஐ → நன்மண்ணாக்குவை", "result": "நன்மண்ணாக்குவை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உயிர் ஈறு + ஐ இணையும்போது வகரம் வரும்'
  AND before_form = 'நன்மண்ணாக்கு + ஐ'
  AND after_form = 'நன்மண்ணாக்குவை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "ஒளித்தல் பகுதி; to hide (இன்னும் முழுச் சொல் ஆகவில்லை)", "result": "ஒளி + க்"}, {"condition": "விளைவு", "rule": "ஒளி + க் → ஒளிக்", "result": "ஒளிக்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒளித்தல் பகுதி; to hide (இன்னும் முழுச் சொல் ஆகவில்லை)'
  AND before_form = 'ஒளி + க்'
  AND after_form = 'ஒளிக்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "ஒளித்தல் பகுதி; to hide (இன்னும் முழுச் சொல் ஆகவில்லை) — ஒற்று மிகும்", "result": "ஒளிக் + க்"}, {"condition": "விளைவு", "rule": "ஒளிக் + க் → ஒளிக்க்", "result": "ஒளிக்க்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒளித்தல் பகுதி; to hide (இன்னும் முழுச் சொல் ஆகவில்லை) — ஒற்று மிகும்'
  AND before_form = 'ஒளிக் + க்'
  AND after_form = 'ஒளிக்க்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "எதிர்கால இடைநிலை உ இணையும்", "result": "ஒளிக்க் + உ"}, {"condition": "விளைவு", "rule": "ஒளிக்க் + உ → ஒளிக்கு", "result": "ஒளிக்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'எதிர்கால இடைநிலை உ இணையும்'
  AND before_form = 'ஒளிக்க் + உ'
  AND after_form = 'ஒளிக்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "உயிர் ஈறு + ஐ இணையும்போது வகரம் வரும்", "result": "ஒளிக்கு + ஐ"}, {"condition": "விளைவு", "rule": "ஒளிக்கு + ஐ → ஒளிக்குவை", "result": "ஒளிக்குவை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உயிர் ஈறு + ஐ இணையும்போது வகரம் வரும்'
  AND before_form = 'ஒளிக்கு + ஐ'
  AND after_form = 'ஒளிக்குவை';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகரம் கெட்டு ஆகாரம் ஏற்கும்", "result": "உழு + ஆய்"}, {"condition": "விளைவு", "rule": "உழு + ஆய் → உழாய்", "result": "உழாய்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகரம் கெட்டு ஆகாரம் ஏற்கும்'
  AND before_form = 'உழு + ஆய்'
  AND after_form = 'உழாய்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "நிபந்தனை விகுதி ஏல் இணையும்", "result": "உழாய் + ஏல்"}, {"condition": "விளைவு", "rule": "உழாய் + ஏல் → உழாயேல்", "result": "உழாயேல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'நிபந்தனை விகுதி ஏல் இணையும்'
  AND before_form = 'உழாய் + ஏல்'
  AND after_form = 'உழாயேல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "சந்தி மெய் க் வரும் (இன்னும் முழுச் சொல் இல்லை)", "result": "யார் + க்"}, {"condition": "விளைவு", "rule": "யார் + க் → யார்க்", "result": "யார்க்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'சந்தி மெய் க் வரும் (இன்னும் முழுச் சொல் இல்லை)'
  AND before_form = 'யார் + க்'
  AND after_form = 'யார்க்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "நான்காம் வேற்றுமை உருபு கு இணையும்", "result": "யார்க் + கு"}, {"condition": "விளைவு", "rule": "யார்க் + கு → யார்க்கு", "result": "யார்க்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'நான்காம் வேற்றுமை உருபு கு இணையும்'
  AND before_form = 'யார்க் + கு'
  AND after_form = 'யார்க்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "தொடர்ச்சியான உயிரொலியில் ஒன்று கெடும்", "result": "யார்க்கு + உள"}, {"condition": "விளைவு", "rule": "யார்க்கு + உள → யார்க்குள", "result": "யார்க்குள"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'தொடர்ச்சியான உயிரொலியில் ஒன்று கெடும்'
  AND before_form = 'யார்க்கு + உள'
  AND after_form = 'யார்க்குள';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "நடத்துதல் பகுதி; to conduct (இன்னும் முழுச் சொல் ஆகவில்லை)", "result": "நட + த்"}, {"condition": "விளைவு", "rule": "நட + த் → நடத்", "result": "நடத்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'நடத்துதல் பகுதி; to conduct (இன்னும் முழுச் சொல் ஆகவில்லை)'
  AND before_form = 'நட + த்'
  AND after_form = 'நடத்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "நடத்துதல் பகுதி; to conduct (இன்னும் முழுச் சொல் ஆகவில்லை)", "result": "நடத் + த்"}, {"condition": "விளைவு", "rule": "நடத் + த் → நடத்த்", "result": "நடத்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'நடத்துதல் பகுதி; to conduct (இன்னும் முழுச் சொல் ஆகவில்லை)'
  AND before_form = 'நடத் + த்'
  AND after_form = 'நடத்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "நடத்து = நடத்துதல்; the act of conducting/carrying out", "result": "நடத்த் + உ"}, {"condition": "விளைவு", "rule": "நடத்த் + உ → நடத்து", "result": "நடத்து"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'நடத்து = நடத்துதல்; the act of conducting/carrying out'
  AND before_form = 'நடத்த் + உ'
  AND after_form = 'நடத்து';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "நடத்துதி = நீ நடத்துகிறாய்; you carry out", "result": "நடத்து + தி"}, {"condition": "விளைவு", "rule": "நடத்து + தி → நடத்துதி", "result": "நடத்துதி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'நடத்துதி = நீ நடத்துகிறாய்; you carry out'
  AND before_form = 'நடத்து + தி'
  AND after_form = 'நடத்துதி';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "கட (பகுதி) என்பதன் ஈற்று மெய் த், இடைநிலை முன் ந் ஆகத் திரியும்", "result": "கடந்"}, {"condition": "நிலை", "rule": "இது இன்னும் முழுச் சொல் அல்ல — வினை வேர் + சந்தி மெய் மட்டுமே", "result": "கட + ந்"}, {"condition": "விளைவு", "rule": "கட + ந் → கடந்", "result": "கடந்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'கடத்தல் பகுதி; to cross (இன்னும் முழுச் சொல் ஆகவில்லை)'
  AND before_form = 'கட + ந்'
  AND after_form = 'கடந்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "இறந்தகால இடைநிலை த் சேர்க்கப்படுகிறது", "result": "கடந்த்"}, {"condition": "நிலை", "rule": "இது இன்னும் முழுச் சொல் அல்ல — வேர் + சந்தி மெய் + கால இடைநிலை", "result": "கடந் + த்"}, {"condition": "விளைவு", "rule": "கடந் + த் → கடந்த்", "result": "கடந்த்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'கடத்தல் பகுதி; to cross (இன்னும் முழுச் சொல் ஆகவில்லை)'
  AND before_form = 'கடந் + த்'
  AND after_form = 'கடந்த்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "அடிப்படை இணைப்பு", "rule": "வினையெச்ச விகுதி உ சேர்ந்து முழுச் சொல் உருவாகிறது", "result": "கடந்து"}, {"condition": "பகுபத உறுப்பிலக்கணம்", "rule": "கட (பகுதி) + ந் (சந்தி மெய்) + த் (இறந்தகால இடைநிலை) + உ (வினையெச்ச விகுதி)", "result": "கடந்து"}, {"condition": "விளைவு", "rule": "கடந்த் + உ → கடந்து = கடந்து சென்று; having crossed", "result": "கடந்து"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'கடந்து சென்று; having crossed'
  AND before_form = 'கடந்த் + உ'
  AND after_form = 'கடந்து';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும் (இ-ஈறு + வல்லின முதல் எழுத்துடன் தொடங்கும் சொல்)", "result": "இ + சிறுமை"}, {"condition": "விளைவு", "rule": "இ + சிறுமை → இச்சிறுமை", "result": "இச்சிறுமை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும் (இ-ஈறு + வல்லின முதல் எழுத்துடன் தொடங்கும் சொல்)'
  AND before_form = 'இ + சிறுமை'
  AND after_form = 'இச்சிறுமை';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்", "result": "இச்சிறுபுல்"}, {"condition": "விளைவு", "rule": "இச்சிறுமை + புல் → இச்சிறுபுல் (மை கெட்டது) = இந்தச் சிறிய புல்; this small/tender grass", "result": "இச்சிறுபுல்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்'
  AND before_form = 'இச்சிறுமை + புல்'
  AND after_form = 'இச்சிறுபுல்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "மகர ஈறு கெட்டு உயிரெழுத்து தொடங்கும் சொல் இணையும்", "result": "பலம் + உற"}, {"condition": "விளைவு", "rule": "பலம் + உற → பலமுற", "result": "பலமுற"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'மகர ஈறு கெட்டு உயிரெழுத்து தொடங்கும் சொல் இணையும்'
  AND before_form = 'பலம் + உற'
  AND after_form = 'பலமுற';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "ஒற்று மிகும் (குற்றியலுகர ஈறு + வல்லின முதல் எழுத்துடன் தொடங்கும் சொல்)", "result": "பலமுற + தன்"}, {"condition": "விளைவு", "rule": "பலமுற + தன் → பலமுறத்தன்", "result": "பலமுறத்தன்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஒற்று மிகும் (குற்றியலுகர ஈறு + வல்லின முதல் எழுத்துடன் தொடங்கும் சொல்)'
  AND before_form = 'பலமுற + தன்'
  AND after_form = 'பலமுறத்தன்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "னகர ஈறு + அகரம் தொடங்கும் சொல் இணையும்போது அகரம் மறைந்து இணையும்", "result": "பலமுறத்தன் + அது"}, {"condition": "விளைவு", "rule": "பலமுறத்தன் + அது → பலமுறத்தனது", "result": "பலமுறத்தனது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'னகர ஈறு + அகரம் தொடங்கும் சொல் இணையும்போது அகரம் மறைந்து இணையும்'
  AND before_form = 'பலமுறத்தன் + அது'
  AND after_form = 'பலமுறத்தனது';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உயிர் வரின் உக்குறள் மெய் விட்டோடும்; உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "உழுது + உழுது"}, {"condition": "விளைவு", "rule": "உழுது + உழுது → உழுதுழுது", "result": "உழுதுழுது"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உயிர் வரின் உக்குறள் மெய் விட்டோடும்; உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே'
  AND before_form = 'உழுது + உழுது'
  AND after_form = 'உழுதுழுது';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "ஈறு போதல்; ஆதி நீடல்; இணையவும் (உகரம் கெட்டது); உடல்மேல் உயிர் வந்து ஒன்றுவது இயல்பே", "result": "பெருமை + அழகு"}, {"condition": "விளைவு", "rule": "பெருமை + அழகு → பேரழகு", "result": "பேரழகு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஈறு போதல்; ஆதி நீடல்; இணையவும் (உகரம் கெட்டது); உடல்மேல் உயிர் வந்து ஒன்றுவது இயல்பே'
  AND before_form = 'பெருமை + அழகு'
  AND after_form = 'பேரழகு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "உயிர் ஈறு + இல் வேற்றுமை உருபு இணையும்போது யகர ஒற்று வரும்", "result": "காலை + இல்"}, {"condition": "விளைவு", "rule": "காலை + இல் → காலையில்", "result": "காலையில்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உயிர் ஈறு + இல் வேற்றுமை உருபு இணையும்போது யகர ஒற்று வரும்'
  AND before_form = 'காலை + இல்'
  AND after_form = 'காலையில்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகர ஈறு கெட்டு நிபந்தனை இடைநிலை இன் சேரும்போது வேண்டு -> வேண்டு+இன் -> வேண்டின்", "result": "வேண்டு + இன்"}, {"condition": "விளைவு", "rule": "வேண்டு + இன் → வேண்டின்", "result": "வேண்டின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகர ஈறு கெட்டு நிபந்தனை இடைநிலை இன் சேரும்போது வேண்டு -> வேண்டு+இன் -> வேண்டின்'
  AND before_form = 'வேண்டு + இன்'
  AND after_form = 'வேண்டின்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகர ஈறு கெட்டு வினையெச்ச விகுதி ஆய் சேரும்போது விரைவு -> விரைவாய்", "result": "விரைவு + ஆய்"}, {"condition": "விளைவு", "rule": "விரைவு + ஆய் → விரைவாய்", "result": "விரைவாய்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகர ஈறு கெட்டு வினையெச்ச விகுதி ஆய் சேரும்போது விரைவு -> விரைவாய்'
  AND before_form = 'விரைவு + ஆய்'
  AND after_form = 'விரைவாய்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகர ஈறு கெட்டு நிபந்தனை இடைநிலை இன் சேரும்போது முடுக்கு -> முடுக்கின்", "result": "முடுக்கு + இன்"}, {"condition": "விளைவு", "rule": "முடுக்கு + இன் → முடுக்கின்", "result": "முடுக்கின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகர ஈறு கெட்டு நிபந்தனை இடைநிலை இன் சேரும்போது முடுக்கு -> முடுக்கின்'
  AND before_form = 'முடுக்கு + இன்'
  AND after_form = 'முடுக்கின்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "சிறப்பும்மை உம் சேரும்போது முடுக்கின் -> முடுக்கினும்", "result": "முடுக்கின் + உம்"}, {"condition": "விளைவு", "rule": "முடுக்கின் + உம் → முடுக்கினும்", "result": "முடுக்கினும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'சிறப்பும்மை உம் சேரும்போது முடுக்கின் -> முடுக்கினும்'
  AND before_form = 'முடுக்கின் + உம்'
  AND after_form = 'முடுக்கினும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரிந்து எதிர்கால இடைநிலை உம் சேரும்போது முடி -> முடியும்", "result": "முடி + உம்"}, {"condition": "விளைவு", "rule": "முடி + உம் → முடியும்", "result": "முடியும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரிந்து எதிர்கால இடைநிலை உம் சேரும்போது முடி -> முடியும்'
  AND before_form = 'முடி + உம்'
  AND after_form = 'முடியும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "குற்றியலுகரம் ஈறாக வரும் எ-கு மெய்யீட்டுப் புணர்ச்சியில் வகரம் வரும்", "result": "எ + வினை"}, {"condition": "விளைவு", "rule": "எ + வினை → எவ்வினை", "result": "எவ்வினை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'குற்றியலுகரம் ஈறாக வரும் எ-கு மெய்யீட்டுப் புணர்ச்சியில் வகரம் வரும்'
  AND before_form = 'எ + வினை'
  AND after_form = 'எவ்வினை';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும் (Doc2: காலை+இல் போன்ற வகை)", "result": "வினை + ஓர்"}, {"condition": "விளைவு", "rule": "வினை + ஓர் → வினையோர்", "result": "வினையோர்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும் (Doc2: காலை+இல் போன்ற வகை)'
  AND before_form = 'வினை + ஓர்'
  AND after_form = 'வினையோர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "எ + மெய் தொடங்கும் சொல் இணையும்போது ஒற்று மிகும் (Doc2: எ+வினை போன்ற வகை)", "result": "எ + பொருள்"}, {"condition": "விளைவு", "rule": "எ + பொருள் → எப்பொருள்", "result": "எப்பொருள்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'எ + மெய் தொடங்கும் சொல் இணையும்போது ஒற்று மிகும் (Doc2: எ+வினை போன்ற வகை)'
  AND before_form = 'எ + பொருள்'
  AND after_form = 'எப்பொருள்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "பாடலில் காணப்படும் இணைந்த சொல் வடிவம்", "result": "நன்மை + ஊண்"}, {"condition": "விளைவு", "rule": "நன்மை + ஊண் → நல்லூண்", "result": "நல்லூண்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'பாடலில் காணப்படும் இணைந்த சொல் வடிவம்'
  AND before_form = 'நன்மை + ஊண்'
  AND after_form = 'நல்லூண்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரிந்து உம் இணையும் (Doc2: முடி+உம் போன்ற வகை)", "result": "தோட்டி + உம்"}, {"condition": "விளைவு", "rule": "தோட்டி + உம் → தோட்டியும்", "result": "தோட்டியும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரிந்து உம் இணையும் (Doc2: முடி+உம் போன்ற வகை)'
  AND before_form = 'தோட்டி + உம்'
  AND after_form = 'தோட்டியும்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "இரண்டாம் வேற்றுமை உருபு ஐ இணையும்", "result": "அர் + ஐ"}, {"condition": "விளைவு", "rule": "அர் + ஐ → சிறுவரை", "result": "சிறுவரை"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இரண்டாம் வேற்றுமை உருபு ஐ இணையும்'
  AND before_form = 'அர் + ஐ'
  AND after_form = 'சிறுவரை';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "சந்தி மெய் ப் இணையும்", "result": "ஐ + ப்"}, {"condition": "விளைவு", "rule": "ஐ + ப் → சிறுவரைப்", "result": "சிறுவரைப்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'சந்தி மெய் ப் இணையும்'
  AND before_form = 'ஐ + ப்'
  AND after_form = 'சிறுவரைப்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "சிறுமை + ஆ"}, {"condition": "விளைவு", "rule": "சிறுமை + ஆ → சிறுமையா", "result": "சிறுமையா"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'சிறுமை + ஆ'
  AND after_form = 'சிறுமையா';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரிந்து உம் இணையும்", "result": "முயற்சி + உம்"}, {"condition": "விளைவு", "rule": "முயற்சி + உம் → முயற்சியும்", "result": "முயற்சியும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரிந்து உம் இணையும்'
  AND before_form = 'முயற்சி + உம்'
  AND after_form = 'முயற்சியும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகர ஈறு கெட்டு இன் இணையும் (Doc2: வேண்டு+இன் போன்ற வகை)", "result": "அன்பு + இன்"}, {"condition": "விளைவு", "rule": "அன்பு + இன் → அன்பின்", "result": "அன்பின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகர ஈறு கெட்டு இன் இணையும் (Doc2: வேண்டு+இன் போன்ற வகை)'
  AND before_form = 'அன்பு + இன்'
  AND after_form = 'அன்பின்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "இன் ஈற்றுடன் ஆல் வேற்றுமை உருபு நேரடியாக இணையும்", "result": "இன் + ஆல்"}, {"condition": "விளைவு", "rule": "இன் + ஆல் → அன்பினால்", "result": "அன்பினால்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இன் ஈற்றுடன் ஆல் வேற்றுமை உருபு நேரடியாக இணையும்'
  AND before_form = 'இன் + ஆல்'
  AND after_form = 'அன்பினால்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "விழுமை + இய"}, {"condition": "விளைவு", "rule": "விழுமை + இய → விழுமிய", "result": "விழுமிய"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'விழுமை + இய'
  AND after_form = 'விழுமிய';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "எ + மெய் தொடங்கும் சொல் இணையும்போது ஒற்று மிகும்", "result": "எ + மண்"}, {"condition": "விளைவு", "rule": "எ + மண் → எம்மண்", "result": "எம்மண்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'எ + மெய் தொடங்கும் சொல் இணையும்போது ஒற்று மிகும்'
  AND before_form = 'எ + மண்'
  AND after_form = 'எம்மண்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகர ஈறு கெட்டு இன் இணையும்", "result": "மெழுகு + இன்"}, {"condition": "விளைவு", "rule": "மெழுகு + இன் → மெழுகின்", "result": "மெழுகின்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகர ஈறு கெட்டு இன் இணையும்'
  AND before_form = 'மெழுகு + இன்'
  AND after_form = 'மெழுகின்';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "இன் ஈற்றுடன் உம் நேரடியாக இணையும்", "result": "இன் + உம்"}, {"condition": "விளைவு", "rule": "இன் + உம் → மெழுகினும்", "result": "மெழுகினும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இன் ஈற்றுடன் உம் நேரடியாக இணையும்'
  AND before_form = 'இன் + உம்'
  AND after_form = 'மெழுகினும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | உயிர்',
  rule_steps = '[{"condition": "உ | உயிர்", "rule": "உகர ஈறு கெட்டு ஆய் இணையும் (Doc2: விரைவு+ஆய் போன்ற வகை)", "result": "சேறு + ஆய்"}, {"condition": "விளைவு", "rule": "சேறு + ஆய் → சேறாய்", "result": "சேறாய்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உகர ஈறு கெட்டு ஆய் இணையும் (Doc2: விரைவு+ஆய் போன்ற வகை)'
  AND before_form = 'சேறு + ஆய்'
  AND after_form = 'சேறாய்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'உ | மெ',
  rule_steps = '[{"condition": "உ | மெ", "rule": "எ + மெய் தொடங்கும் சொல் இணையும்போது ஒற்று மிகும்", "result": "எ + படி"}, {"condition": "விளைவு", "rule": "எ + படி → எப்படி", "result": "எப்படி"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'எ + மெய் தொடங்கும் சொல் இணையும்போது ஒற்று மிகும்'
  AND before_form = 'எ + படி'
  AND after_form = 'எப்படி';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "இகர ஈறு யகரமாகத் திரிந்து உம் இணையும்", "result": "பூச்சி + உம்"}, {"condition": "விளைவு", "rule": "பூச்சி + உம் → பூச்சியும்", "result": "பூச்சியும்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'இகர ஈறு யகரமாகத் திரிந்து உம் இணையும்'
  AND before_form = 'பூச்சி + உம்'
  AND after_form = 'பூச்சியும்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'இ ஈ ஐ | உயிர்',
  rule_steps = '[{"condition": "இ ஈ ஐ | உயிர்", "rule": "ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்", "result": "இணை + இலா"}, {"condition": "விளைவு", "rule": "இணை + இலா → இணையிலா", "result": "இணையிலா"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்'
  AND before_form = 'இணை + இலா'
  AND after_form = 'இணையிலா';

UPDATE sandhi_rules SET
  mnemonic_tag = 'மெ | உ',
  rule_steps = '[{"condition": "மெ | உ", "rule": "வேற்றுமை இடைநிலை \"கு\" முன் வல்லின மெய் மிகும்", "result": "வியர்த்தவர் + கு"}, {"condition": "விளைவு", "rule": "வியர்த்தவர் + கு → வியர்த்தவர்க்கு", "result": "வியர்த்தவர்க்கு"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'வேற்றுமை இடைநிலை "கு" முன் வல்லின மெய் மிகும்'
  AND before_form = 'வியர்த்தவர் + கு'
  AND after_form = 'வியர்த்தவர்க்கு';

UPDATE sandhi_rules SET
  mnemonic_tag = NULL,
  rule_steps = '[{"condition": "விதி", "rule": "உம்மைத் தொகைச்சொல் \"எல்லாம்\" இணைந்து முழுச் சொல் உருவாகும்", "result": "வியர்த்தவர்க்கு + எல்லாம்"}, {"condition": "விளைவு", "rule": "வியர்த்தவர்க்கு + எல்லாம் → வியர்த்தவர்க்கெல்லாம்", "result": "வியர்த்தவர்க்கெல்லாம்"}]'::jsonb
WHERE rule_steps -> 0 ->> 'rule' = 'உம்மைத் தொகைச்சொல் "எல்லாம்" இணைந்து முழுச் சொல் உருவாகும்'
  AND before_form = 'வியர்த்தவர்க்கு + எல்லாம்'
  AND after_form = 'வியர்த்தவர்க்கெல்லாம்';

-- ── Propagate base-merge classification onto morphemes.is_sandhi_junction ──
WITH ranked AS (
  SELECT m.id AS morpheme_id, m.word_group_id,
         ROW_NUMBER() OVER (PARTITION BY m.word_group_id ORDER BY m.position) - 1 AS conn_idx
  FROM morphemes m
  WHERE m.word_group_id IS NOT NULL AND m.is_separator = false
)
UPDATE morphemes
SET is_sandhi_junction = false
FROM ranked r
JOIN sandhi_rules sr
  ON sr.word_group_id = r.word_group_id AND sr.connector_index = r.conn_idx
WHERE morphemes.id = r.morpheme_id
  AND sr.rule_steps -> 0 ->> 'condition' = 'அடிப்படை இணைப்பு';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT
  count(*) FILTER (WHERE mnemonic_tag IS NOT NULL) AS with_mnemonic,
  count(*) FILTER (WHERE rule_steps -> 0 ->> 'condition' = 'அடிப்படை இணைப்பு') AS base_merge_rules,
  count(*) AS total
FROM sandhi_rules;

SELECT count(*) FILTER (WHERE is_sandhi_junction = false) AS base_merge_morphemes,
       count(*) AS total_morphemes
FROM morphemes WHERE word_group_id IS NOT NULL AND is_separator = false;
