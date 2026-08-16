-- ============================================================================
-- சொற்களின் புணர்ச்சி (Sandhi) தாவல் — Corrections pass 2
-- Based on "Based on my Pnarchi Short Cut Classification.docx"
--
-- Run this AFTER sandhi_mnemonics_migration.sql + sandhi_mnemonics_data.sql
-- (confirmed already applied). Everything here is an UPDATE matched by
-- CONTENT (before_form/after_form, or explicit line/position lookups) —
-- safe to re-run, and safe regardless of exactly which prior state your
-- live database is in.
--
-- This file does FOUR things:
--
--  PART 1 — குற்றியலுகரம் sub-classification. Your document gives a precise
--    decision tree (உ | உயிர் → கு | உயிர் → டு/று | உயிர் → நெடில்/உயிர்த்
--    தொடர் | உயிர், with மு | உயிர் handled separately). The previous pass
--    gave all short-உ-ending connectors one flat "உ | உயிர்" tag; this
--    walks each of those 29 unique combinations through your tree and
--    assigns the correct, more specific tag + matching rule text. The
--    classifier looks at how the FIRST word ends: டு/று-ending words check
--    whether a long vowel sign (ா ீ ூ ே ை ொ ோ ௌ) sits immediately before
--    that syllable (நெடில்/உயிர்த் தொடர் bucket) or not (plain டு று
--    bucket); கு/சு/து/பு-ending and மு-ending words go to their own
--    buckets. A handful (உழு-type ழ-ending words, and one word — உழைப்ப் +
--    ஓர் — whose stored before_form doesn't actually end in a vowel at all
--    and looks like a separate data bug worth checking) don't cleanly fit
--    any bucket and are left at the generic "உ | உயிர்" tag rather than
--    force-classified.
--
--  PART 2 — இதம் + உற (line 11, இதமுறத்தேன்துளி's first connector) was
--    marked a Base Merge in the previous pass because its stored rule was
--    just the generic "இணைந்த சொல் வடிவம்" placeholder. You flagged this as
--    wrong: இதம் ends in a மெய் (ம்) and உற starts with a short உ, so it's
--    a real "மெ | உ" doubling junction (உடல்மேல் உயிர்வந்து ஒன்றுவது
--    இயல்பே) and should be Active, not a static dot. This section restores
--    it to an Active Junction with the correct tag and undoes the
--    is_sandhi_junction = false flag on the இதம் morpheme.
--
--  PART 3 — changed_letter பிழை fix: a handful of connector badges show a
--    bare consonant BASE letter (e.g. "ய") where it should be the மெய்
--    form with புள்ளி ("ய்") — you flagged this on இம்மை+இல் and
--    அடி+ஒன்று specifically, but since a bare base consonant letter with
--    no vowel sign and no புள்ளி is never valid standalone Tamil, this
--    fixes EVERY sandhi_rules row with that exact mistake across the whole
--    poem, not just the two you happened to screenshot.
--
--  PART 4 — duplicate morpheme தேடல் + சரிசெய்தல்: you flagged two
--    concrete instances (வேண்டு + இன் showing an extra useless "இன்" tile,
--    and முடுக்கு...+உம் similarly duplicating "உம்"). Rather than hardcode
--    just those two spots (my own reconstruction of the poem's current
--    live state may not be perfectly in sync with your database after the
--    admin-page edits and script runs since we last spoke), this runs a
--    general loop across the whole poem — BUT restricted to a fixed
--    allow-list of grammatical particles (இன், உம், இல், ஐ, ஆல், உள). That
--    restriction is deliberate: the poem also contains legitimate
--    intentional repeated CONTENT words (அடுக்குத் தொடர், e.g.
--    உழுது + உழுது -> உழுதுழுது, பார்த்து + பார்த்து, நில் + நில்) which a
--    blanket "any two adjacent identical morphemes" rule would have wrongly
--    deleted. Only a repeated single-use grammatical marker is ever
--    removed; content-word repetitions are never touched. When it does
--    remove one, it re-sequences every later position in that line (both
--    morphemes and word_groups) down by one so nothing is left with a gap.
--    A read-only diagnostic query after it lists any other adjacent
--    identical-morpheme pairs left in the poem for you to eyeball.
--
-- Safe to re-run — parts 1-3 are idempotent by construction; part 4 exits
-- immediately with nothing to do once the duplicates are gone.
-- ============================================================================

-- ── PART 1: குற்றியலுகரம் sub-classification ────────────────────────────
UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "அருத்து + இ"}, {"condition": "விளைவு", "rule": "அருத்து + இ → அருத்தி", "result": "அருத்தி"}]'::jsonb
WHERE before_form = 'அருத்து + இ'
  AND after_form = 'அருத்தி'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "ஆக்கு + இ"}, {"condition": "விளைவு", "rule": "ஆக்கு + இ → ஆக்கி", "result": "ஆக்கி"}]'::jsonb
WHERE before_form = 'ஆக்கு + இ'
  AND after_form = 'ஆக்கி'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "இது + ஓ"}, {"condition": "விளைவு", "rule": "இது + ஓ → இதோ", "result": "இதோ"}]'::jsonb
WHERE before_form = 'இது + ஓ'
  AND after_form = 'இதோ'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "சிக்கு + இ"}, {"condition": "விளைவு", "rule": "சிக்கு + இ → சிக்கி", "result": "சிக்கி"}]'::jsonb
WHERE before_form = 'சிக்கு + இ'
  AND after_form = 'சிக்கி'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "குறிப்பு + இல்"}, {"condition": "விளைவு", "rule": "குறிப்பு + இல் → குறிப்பில்", "result": "குறிப்பில்"}]'::jsonb
WHERE before_form = 'குறிப்பு + இல்'
  AND after_form = 'குறிப்பில்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'டு று | உயிர்',
  rule_steps = '[{"condition": "டு று | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "ஏற்று + அ"}, {"condition": "விளைவு", "rule": "ஏற்று + அ → ஏற்ற", "result": "ஏற்ற"}]'::jsonb
WHERE before_form = 'ஏற்று + அ'
  AND after_form = 'ஏற்ற'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "ஏற்றது + ஓர்"}, {"condition": "விளைவு", "rule": "ஏற்றது + ஓர் → ஏற்றதோர்", "result": "ஏற்றதோர்"}]'::jsonb
WHERE before_form = 'ஏற்றது + ஓர்'
  AND after_form = 'ஏற்றதோர்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "இது + அன்"}, {"condition": "விளைவு", "rule": "இது + அன் → இதன்", "result": "இதன்"}]'::jsonb
WHERE before_form = 'இது + அன்'
  AND after_form = 'இதன்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'டு று | உயிர்',
  rule_steps = '[{"condition": "டு று | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "வேண்டு + அல்"}, {"condition": "விளைவு", "rule": "வேண்டு + அல் → வேண்டல்", "result": "வேண்டல்"}]'::jsonb
WHERE before_form = 'வேண்டு + அல்'
  AND after_form = 'வேண்டல்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'டு று | உயிர்',
  rule_steps = '[{"condition": "டு று | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "வேண்டு + இன்"}, {"condition": "விளைவு", "rule": "வேண்டு + இன் → வேண்டின்", "result": "வேண்டின்"}]'::jsonb
WHERE before_form = 'வேண்டு + இன்'
  AND after_form = 'வேண்டின்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "முடுக்கு + இன்"}, {"condition": "விளைவு", "rule": "முடுக்கு + இன் → முடுக்கின்", "result": "முடுக்கின்"}]'::jsonb
WHERE before_form = 'முடுக்கு + இன்'
  AND after_form = 'முடுக்கின்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "இலக்கு + அற்று"}, {"condition": "விளைவு", "rule": "இலக்கு + அற்று → இலக்கற்று", "result": "இலக்கற்று"}]'::jsonb
WHERE before_form = 'இலக்கு + அற்று'
  AND after_form = 'இலக்கற்று'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "அது + அன்"}, {"condition": "விளைவு", "rule": "அது + அன் → அதன்", "result": "அதன்"}]'::jsonb
WHERE before_form = 'அது + அன்'
  AND after_form = 'அதன்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "குறிப்பு + ஒடு"}, {"condition": "விளைவு", "rule": "குறிப்பு + ஒடு → குறிப்பொடு", "result": "குறிப்பொடு"}]'::jsonb
WHERE before_form = 'குறிப்பு + ஒடு'
  AND after_form = 'குறிப்பொடு'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "புக்கு + அ"}, {"condition": "விளைவு", "rule": "புக்கு + அ → புக்க", "result": "புக்க"}]'::jsonb
WHERE before_form = 'புக்கு + அ'
  AND after_form = 'புக்க'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'டு று | உயிர்',
  rule_steps = '[{"condition": "டு று | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "புக்கவிட்டு + இரு"}, {"condition": "விளைவு", "rule": "புக்கவிட்டு + இரு → புக்கவிட்டிரு", "result": "புக்கவிட்டிரு"}]'::jsonb
WHERE before_form = 'புக்கவிட்டு + இரு'
  AND after_form = 'புக்கவிட்டிரு'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'டு று | உயிர்',
  rule_steps = '[{"condition": "டு று | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "ஒன்று + ஐ"}, {"condition": "விளைவு", "rule": "ஒன்று + ஐ → ஒன்றை", "result": "ஒன்றை"}]'::jsonb
WHERE before_form = 'ஒன்று + ஐ'
  AND after_form = 'ஒன்றை'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "ஆர்த்து + எழு"}, {"condition": "விளைவு", "rule": "ஆர்த்து + எழு → ஆர்த்தெழு", "result": "ஆர்த்தெழு"}]'::jsonb
WHERE before_form = 'ஆர்த்து + எழு'
  AND after_form = 'ஆர்த்தெழு'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "அன்பு + இன்"}, {"condition": "விளைவு", "rule": "அன்பு + இன் → அன்பின்", "result": "அன்பின்"}]'::jsonb
WHERE before_form = 'அன்பு + இன்'
  AND after_form = 'அன்பின்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "அனைத்து + ஐ"}, {"condition": "விளைவு", "rule": "அனைத்து + ஐ → அனைத்தை", "result": "அனைத்தை"}]'::jsonb
WHERE before_form = 'அனைத்து + ஐ'
  AND after_form = 'அனைத்தை'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "என்பு + எலாம்"}, {"condition": "விளைவு", "rule": "என்பு + எலாம் → என்பெலாம்", "result": "என்பெலாம்"}]'::jsonb
WHERE before_form = 'என்பு + எலாம்'
  AND after_form = 'என்பெலாம்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "உழைப்பு + இல்"}, {"condition": "விளைவு", "rule": "உழைப்பு + இல் → உழைப்பில்", "result": "உழைப்பில்"}]'::jsonb
WHERE before_form = 'உழைப்பு + இல்'
  AND after_form = 'உழைப்பில்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "மெழுகு + இன்"}, {"condition": "விளைவு", "rule": "மெழுகு + இன் → மெழுகின்", "result": "மெழுகின்"}]'::jsonb
WHERE before_form = 'மெழுகு + இன்'
  AND after_form = 'மெழுகின்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'டு று | உயிர்',
  rule_steps = '[{"condition": "டு று | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "வேண்டு + (ஆ)"}, {"condition": "விளைவு", "rule": "வேண்டு + (ஆ) → வேண்டா", "result": "வேண்டா"}]'::jsonb
WHERE before_form = 'வேண்டு + (ஆ)'
  AND after_form = 'வேண்டா'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'டு று | உயிர்',
  rule_steps = '[{"condition": "டு று | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "உண்டு + ஆம்"}, {"condition": "விளைவு", "rule": "உண்டு + ஆம் → உண்டாம்", "result": "உண்டாம்"}]'::jsonb
WHERE before_form = 'உண்டு + ஆம்'
  AND after_form = 'உண்டாம்'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "திருந்து + அ"}, {"condition": "விளைவு", "rule": "திருந்து + அ → திருந்த", "result": "திருந்த"}]'::jsonb
WHERE before_form = 'திருந்து + அ'
  AND after_form = 'திருந்த'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "யார்க்கு + உள"}, {"condition": "விளைவு", "rule": "யார்க்கு + உள → யார்க்குள", "result": "யார்க்குள"}]'::jsonb
WHERE before_form = 'யார்க்கு + உள'
  AND after_form = 'யார்க்குள'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'கு சு து பு | உயிர்',
  rule_steps = '[{"condition": "கு சு து பு | உயிர்", "rule": "உயிர்வரின் உக்குறள் மெய்விட்டு ஓடும்", "result": "உழுது + உழுது"}, {"condition": "விளைவு", "rule": "உழுது + உழுது → உழுதுழுது", "result": "உழுதுழுது"}]'::jsonb
WHERE before_form = 'உழுது + உழுது'
  AND after_form = 'உழுதுழுது'
  AND mnemonic_tag = 'உ | உயிர்';

UPDATE sandhi_rules SET
  mnemonic_tag = 'நெடில்/உயிர்த் தொடர் | உயிர்',
  rule_steps = '[{"condition": "நெடில்/உயிர்த் தொடர் | உயிர்", "rule": "நெடிலோடு உயிர்த்தொடர்க் குற்றுகரங்களுள் டறஒற்று இரட்டும் வேற்றுமை மிகவே", "result": "சேறு + ஆய்"}, {"condition": "விளைவு", "rule": "சேறு + ஆய் → சேறாய்", "result": "சேறாய்"}]'::jsonb
WHERE before_form = 'சேறு + ஆய்'
  AND after_form = 'சேறாய்'
  AND mnemonic_tag = 'உ | உயிர்';

-- ── PART 2: இதம் + உற — restore as Active Junction ("மெ | உ") ───────────
DO $$
DECLARE
  v_group_id uuid;
  v_line_id uuid;
BEGIN
  SELECT wg.id, wg.poem_line_id INTO v_group_id, v_line_id
  FROM word_groups wg
  JOIN poem_lines pl ON pl.id = wg.poem_line_id
  JOIN pages p ON p.id = pl.page_id
  JOIN topics t ON t.id = p.topic_id
  WHERE t.title = 'மனோன்மணீயம்' AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 11 AND wg.position = 1;

  IF v_group_id IS NULL THEN
    RAISE NOTICE 'இதமுறத்தேன்துளி word_group not found (line 11, position 1) — skipping Part 2.';
  ELSE
    UPDATE sandhi_rules SET
      mnemonic_tag = 'மெ | உ',
      rule_steps = '[
        {"condition": "மெ | உ", "rule": "தனிக்குறில் முன் ஒற்று உயிர்வரின் இரட்டும்; உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே", "result": "இதம் + உற"},
        {"condition": "விளைவு", "rule": "இதம் + உற → இதமுற", "result": "இதமுற"}
      ]'::jsonb
    WHERE word_group_id = v_group_id AND connector_index = 0;

    UPDATE morphemes SET is_sandhi_junction = true
    WHERE poem_line_id = v_line_id AND word_group_id = v_group_id AND position = (
      SELECT MIN(position) FROM morphemes WHERE word_group_id = v_group_id
    );

    RAISE NOTICE '✓ இதம் + உற restored as Active Junction (மெ | உ).';
  END IF;
END $$;


-- ── PART 3: changed_letter — add missing புள்ளி on bare consonant letters ──
UPDATE sandhi_rules
SET changed_letter = changed_letter || '்'
WHERE changed_letter IN ('க','ங','ச','ஞ','ட','ண','த','ந','ப','ம','ய','ர','ல','வ','ழ','ள','ற','ன');


-- ── PART 4: duplicate morpheme தேடல் + சரிசெய்தல் (whole-poem scan) ──────
-- IMPORTANT SAFETY NOTE: this does NOT use a blanket "any two adjacent
-- identical morphemes" rule. This poem has legitimate intentional
-- repetitions (அடுக்குத் தொடர்) — உழுது + உழுது -> உழுதுழுது,
-- பார்த்து + பார்த்து, நில் + நில் and similar — which already carry a real
-- "அடுக்குத் தொடர்" rule in sandhi_rules and must NOT be touched. The bug
-- you flagged is specific to meaningless repeated GRAMMATICAL PARTICLES
-- (இன், உம் — a case/tense marker only ever makes sense once), not
-- repeated content words. So this only ever deletes a duplicate when the
-- repeated text is in the fixed allow-list below — content-word
-- repetitions are never touched, however this scan is run.
DO $$
DECLARE
  dup RECORD;
BEGIN
  LOOP
    SELECT m2.id AS dup_id, m2.position AS dup_position,
           m2.poem_line_id AS line_id, m1.display_form
    INTO dup
    FROM morphemes m1
    JOIN morphemes m2
      ON m2.word_group_id = m1.word_group_id
     AND m2.position = m1.position + 1
    WHERE m1.is_separator = false AND m2.is_separator = false
      AND m1.word_group_id IS NOT NULL
      AND m1.display_form = m2.display_form
      AND m1.display_form IN ('இன்', 'உம்', 'இல்', 'ஐ', 'ஆல்', 'உள')
    LIMIT 1;

    IF dup.dup_id IS NULL THEN
      EXIT;
    END IF;

    RAISE NOTICE 'Removing duplicate grammatical-particle morpheme "%" (id=%) at position % on poem_line %',
      dup.display_form, dup.dup_id, dup.dup_position, dup.line_id;

    DELETE FROM morphemes WHERE id = dup.dup_id;

    UPDATE morphemes SET position = position - 1
    WHERE poem_line_id = dup.line_id AND position > dup.dup_position;

    UPDATE word_groups SET position = position - 1
    WHERE poem_line_id = dup.line_id AND position > dup.dup_position;
  END LOOP;

  RAISE NOTICE '✓ Duplicate-particle scan complete.';
END $$;

-- ── Diagnostic only (does NOT delete anything) — lists every adjacent pair
-- of identical multi-character morphemes still in the poem after Part 4,
-- so you can eyeball whether any of them are a bug outside the allow-list
-- above (vs. a legitimate அடுக்குத் தொடர் repetition, which is expected
-- to show up here and should be left alone).
SELECT m1.display_form, m1.poem_line_id, m1.position
FROM morphemes m1
JOIN morphemes m2 ON m2.word_group_id = m1.word_group_id AND m2.position = m1.position + 1
WHERE m1.is_separator = false AND m2.is_separator = false
  AND m1.word_group_id IS NOT NULL AND m1.display_form = m2.display_form
  AND length(m1.display_form) > 1;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT mnemonic_tag, count(*) FROM sandhi_rules
WHERE mnemonic_tag LIKE '%உயிர்%' GROUP BY mnemonic_tag ORDER BY 2 DESC;

SELECT count(*) FILTER (WHERE changed_letter ~ '^[க-ன]$') AS still_missing_pulli
FROM sandhi_rules;

-- ── PART 5: இயல்புப் புணர்ச்சி — word+word combos with no phonetic change
-- must stay Active (with a "no rule" popup), not become silent dots.
-- Only TRUE verb-root பகுபதம் breakdowns (the "before" morpheme is itself
-- a verb root, is_verb = true — e.g. கட + ந் + த் + உ) should remain Base
-- Merges. Everything else currently marked Base Merge gets reactivated
-- with an explicit "இயல்புப் புணர்ச்சி" rule step instead of being blank.
DO $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT sr.id AS rule_id, sr.before_form, sr.after_form, m.id AS morpheme_id
    FROM sandhi_rules sr
    JOIN word_groups wg ON wg.id = sr.word_group_id
    JOIN LATERAL (
      SELECT mm.id, mm.is_verb FROM morphemes mm
      WHERE mm.word_group_id = wg.id
      ORDER BY mm.position
      OFFSET sr.connector_index LIMIT 1
    ) m ON true
    WHERE sr.rule_steps -> 0 ->> 'condition' = 'அடிப்படை இணைப்பு'
      AND COALESCE(m.is_verb, false) = false
  LOOP
    UPDATE sandhi_rules SET
      mnemonic_tag = NULL,
      rule_steps = jsonb_build_array(
        jsonb_build_object('condition', 'இயல்புப் புணர்ச்சி', 'rule', 'எந்த விதிகளும் இல்லை', 'result', rec.before_form),
        jsonb_build_object('condition', 'விளைவு', 'rule', rec.before_form || ' → ' || rec.after_form, 'result', rec.after_form)
      )
    WHERE id = rec.rule_id;

    UPDATE morphemes SET is_sandhi_junction = true WHERE id = rec.morpheme_id;
  END LOOP;

  RAISE NOTICE '✓ இயல்புப் புணர்ச்சி reactivation complete.';
END $$;

-- ── Verify Part 5 ────────────────────────────────────────────────────────
SELECT count(*) FILTER (WHERE rule_steps -> 0 ->> 'condition' = 'இயல்புப் புணர்ச்சி') AS reactivated_natural_merges,
       count(*) FILTER (WHERE rule_steps -> 0 ->> 'condition' = 'அடிப்படை இணைப்பு') AS remaining_verb_base_merges
FROM sandhi_rules;
