-- ============================================================================
-- Applies the remaining (DB-side) items from Changes.docx to whichever topic
-- currently holds this poem — works whether it's still titled 'என் அம்மை'
-- or already renamed to 'யுகத்தின் பாடல்'.
--
-- 1) Renames the topic to 'யுகத்தின் பாடல்' (no-op if already renamed).
-- 2) Fills Tamil+English meanings for every individual morpheme box and
--    every combined word_group box (content carried over from the existing
--    en_ammai_fill_meanings_and_rename.sql draft in this repo — these are my
--    own reading of the poem, not sourced from an external dictionary;
--    review and correct anything your textbook states differently).
-- 3) Adds sandhi_rules for the 3-unit வியர்த்தவர்க்கெல்லாம் word group so the
--    new staged-combine UI shows the correct intermediate word
--    (வியர்த்தவர் + கு -> வியர்த்தவர்க்கு) before it merges with எல்லாம்,
--    instead of jumping straight from raw morphemes to the final word.
--
-- Safe to re-run.
-- ============================================================================

DO $$
DECLARE
  v_page_id uuid;
  v_group_id uuid;
BEGIN
  SELECT p.id INTO v_page_id
  FROM pages p
  JOIN topics t ON t.id = p.topic_id
  WHERE t.title IN ('என் அம்மை', 'யுகத்தின் பாடல்') AND p.page_type = 'செய்யுள் பகுதி'
  LIMIT 1;

  IF v_page_id IS NULL THEN
    RAISE EXCEPTION 'செய்யுள் பகுதி page not found for என் அம்மை / யுகத்தின் பாடல் — run en_ammai_full_setup.sql first.';
  END IF;

  ----------------------------------------------------------------
  -- Individual morpheme meanings (line_number, position, meaning)
  ----------------------------------------------------------------
  UPDATE morphemes m
  SET word_meaning = v.meaning
  FROM (VALUES
    (1,1,'எனது; my'),
    (1,2,'தாய்; mother'),
    (2,1,'அழுத்திப் பதித்த; pressed/stamped'),
    (2,2,'எடுத்துக்கொண்ட; took/lifted'),
    (3,1,'நெற்றி; forehead'),
    (3,2,'நெற்றியில் இடும் புனித மண்/சாந்து; sacred clay mark'),
    (3,3,'அழகு; beauty'),
    (3,4,'விளியிடைச்சொல் (ஓ!); vocative particle "Oh"'),
    (4,1,'வழி (தலைமுறை); generation/way'),
    (4,2,'வழி (தலைமுறை, திரும்பக் கூறல்); generation/way (repeated)'),
    (4,3,'நீ; you'),
    (4,4,'உடைமை இடைநிலை (சாரியை); possessive glide'),
    (4,5,'பாதம்; foot/feet'),
    (4,6,'வணங்கியவர்கள் (வினையாலணையும் பெயர்); those who worshipped'),
    (5,1,'உழவு செய்தவர்கள்; those who ploughed'),
    (5,2,'விதை விதைத்தவர்கள்; those who sowed'),
    (6,1,'வியர்வை சிந்தியவர்கள்; those who sweated'),
    (6,2,'வேற்றுமை இடைநிலை (கொடைப் பொருள்); dative marker "to/for"'),
    (6,3,'அனைத்தும்; all'),
    (7,1,'நிறைந்த; full/abundant'),
    (7,2,'தானியம்/மணி; grain/gem'),
    (7,3,'கொடுத்தவள்; she who gave'),
    (7,4,'விளியிடைச்சொல் (ஓ!); vocative particle "Oh"'),
    (8,1,'நீ; you'),
    (8,2,'இடைநிலை ஒலி (சாரியை, தனிப் பொருளில்லை); euphonic glide, no independent meaning'),
    (8,3,'வேற்றுமை இடைநிலை; dative marker "to"'),
    (8,4,'பல; many'),
    (8,5,'வருடம்; year'),
    (8,6,'பல; many'),
    (8,7,'வருடம்; year'),
    (9,1,'பல; many'),
    (9,2,'1000; thousand'),
    (9,3,'இடைநிலை (சாரியை, பொருளில்லை); euphonic glide'),
    (9,4,'வருடம்; year'),
    (10,1,'பாடுதல் (வினைச்சொல் வேர்); to sing (verb root)'),
    (10,2,'உறுதிப்படுத்தும் இடைச்சொல்; emphatic particle "indeed"'),
    (10,3,'வேண்டும் (துணை வினை, கட்டாயம்); must/should (auxiliary)'),
    (11,1,'காற்று; wind'),
    (11,2,'இடப்பொருள் இடைநிலை; locative marker "in"'),
    (11,3,'ஏறிக்கொண்டு; having climbed/risen'),
    (11,4,'முழங்கும்/கனைக்கும்; roaring'),
    (11,5,'கடல்; sea'),
    (11,6,'செயப்படுபொருள் இடைநிலை; accusative marker'),
    (11,7,'தீ; fire'),
    (11,8,'ஆறு; river'),
    (11,9,'செயப்படுபொருள் இடைநிலை; accusative marker'),
    (12,1,'மலை; mountain'),
    (12,2,'மலை உச்சி/முகடு; peak/summit'),
    (12,3,'பன்மை இடைநிலை; plural marker'),
    (12,4,'செயப்படுபொருள் இடைநிலை; accusative marker'),
    (12,5,'கடந்துசென்று; having crossed'),
    (13,1,'செல்; go (imperative root)'),
    (13,2,'என்று (சொல்லி); saying/thus'),
    (13,3,'செல்லும் (வினை வேர்); go/travel'),
    (13,4,'எதிர்கால/பொது இடைநிலை; generic tense marker'),
    (13,5,'ஒரு (திரிபு வடிவம்); a/one'),
    (13,6,'பாட்டு; song'),
    (13,7,'செயப்படுபொருள் இடைநிலை; accusative marker'),
    (14,1,'கதவுகளையுடைய அரண் நகரம்; fortified/gated city'),
    (14,2,'பன்மை இடைநிலை; plural marker'),
    (14,3,'காவல்/பாதுகாப்பு; guard/protection'),
    (14,4,'எடுத்துக்கொண்ட; having taken/held'),
    (14,5,'பிறகு; after'),
    (14,6,'உம்மைத் தொகை (கூட); also/even'),
    (15,1,'காலம்; time'),
    (15,2,'இடைநிலை (சாரியை, பொருளில்லை); euphonic glide'),
    (15,3,'கருவிப் பொருள் இடைநிலை; instrumental marker "by"'),
    (15,4,'இறவாத (எதிர்மறைப் பெயரெச்சம்); that which does not die'),
    (15,5,'பழமையான; ancient/age-old'),
    (15,6,'தாது/கனிமப்பொருள்; mineral/ore'),
    (15,7,'பன்மை இடைநிலை; plural marker'),
    (15,8,'உடைமை இடைநிலை; genitive marker "of"'),
    (16,1,'வலிமை/சக்தி; strength/vigor'),
    (16,2,'எல்லாம் (தொகைச்சொல்); all'),
    (16,3,'சேரும்படி/சேர்ந்து; to join/gather'),
    (16,4,'பாடுதல்; to sing'),
    (16,5,'உறுதிப்படுத்தும் இடைச்சொல்; emphatic particle'),
    (16,6,'வேண்டும்; must'),
    (17,1,'ஓலைச் சுவடி/பக்கம்; palm-leaf manuscript/page'),
    (17,2,'தொடங்கி; having begun'),
    (17,3,'வைத்து; having placed/kept'),
    (17,4,'எனது; my'),
    (17,5,'தாய்; mother'),
    (18,1,'மண்/நிலம்; earth/ground'),
    (18,2,'இடப்பொருள் இடைநிலை; locative marker'),
    (18,3,'உறுதிப்படுத்தும் இடைச்சொல்; emphatic particle'),
    (18,4,'எழுதி/வரைந்து; having traced/drawn'),
    (18,5,'எழுதி/வரைந்து (திரும்பக் கூறல்); having traced/drawn (repeated)'),
    (18,6,'எழுதச் செய்த (பிறவினை); caused to write'),
    (19,1,'விரல்; finger'),
    (19,2,'நுனி/முனை; tip'),
    (19,3,'செயப்படுபொருள் இடைநிலை; accusative marker'),
    (19,4,'நெருப்பு; fire'),
    (19,5,'இடப்பொருள் இடைநிலை; locative marker'),
    (19,6,'உறுதிப்படுத்தும் இடைச்சொல்; emphatic particle'),
    (19,7,'நனைத்து/முக்கி; having dipped/soaked'),
    (20,1,'திசை; direction'),
    (20,2,'பன்மை இடைநிலை; plural marker'),
    (20,3,'உடைமை இடைநிலை; genitive marker "of"'),
    (20,4,'சுவர்; wall'),
    (20,5,'எல்லாம்; all'),
    (20,6,'எழுதுதல்; to write'),
    (20,7,'உறுதிப்படுத்தும் இடைச்சொல்; emphatic particle'),
    (20,8,'வேண்டும்; must'),
    (21,1,'தோன்றுகின்ற/எழுகின்ற (பெயரெச்சம்); rising/emerging'),
    (21,2,'யுகம்/காலகட்டம்; age/epoch'),
    (21,3,'இடைநிலை (சாரியை); euphonic glide'),
    (21,4,'உடைமை இடைநிலை; genitive marker "of"'),
    (21,5,'ஒரு (திரிபு வடிவம்); a/one'),
    (21,6,'பாட்டு; song'),
    (21,7,'செயப்படுபொருள் இடைநிலை; accusative marker')
  ) AS v(line_number, position, meaning)
  JOIN poem_lines pl ON pl.line_number = v.line_number AND pl.page_id = v_page_id
  WHERE m.poem_line_id = pl.id AND m.position = v.position;

  ----------------------------------------------------------------
  -- Combined word meanings (line_number, group position, meaning)
  ----------------------------------------------------------------
  UPDATE word_groups wg
  SET combined_meaning = v.meaning
  FROM (VALUES
    (1,1,'என் அம்மை — எனது தாய்; my mother'),
    (2,1,'ஒற்றியெடுத்த — அழுத்திப் பதித்து எடுத்த அடையாளம்; a stamped/pressed impression'),
    (3,1,'நெற்றிமண் — நெற்றியில் இடப்படும் புனித மண் அடையாளம்; the sacred mark on the forehead'),
    (3,2,'அழகே — ஓ அழகியே!; Oh beautiful one!'),
    (4,1,'வழிவழி — தலைமுறை தலைமுறையாக; generation after generation'),
    (4,2,'நினதடி — உனது பாதங்கள்; your feet'),
    (6,1,'வியர்த்தவர்க்கெல்லாம் — வியர்வை சிந்திய அனைவருக்கும்; to all those who sweated'),
    (7,1,'நிறைமணி — நிறைந்த தானியம்; abundant grain'),
    (7,2,'தந்தவளே — ஓ கொடுத்தவளே!; Oh she who gave!'),
    (8,1,'உனக்குப் — உனக்கு; to you'),
    (8,2,'பல்லாண்டு — பல ஆண்டுகள்; many years'),
    (8,3,'பல்லாண்டு — பல ஆண்டுகள் (திரும்பக் கூறி வாழ்த்து); many years (repeated as a blessing)'),
    (9,1,'பல்லாயிரத்தாண்டு — பல ஆயிரம் ஆண்டுகள்; many thousands of years'),
    (10,1,'பாடத்தான் — பாடத் தான்; (must) indeed sing'),
    (11,1,'காற்றிலேறி — காற்றின் மேல் ஏறி; rising upon the wind'),
    (11,2,'கனைகடலை — முழங்கும் கடலை; the roaring sea'),
    (11,3,'நெருப்பாற்றை — நெருப்பு ஆற்றை; the river of fire'),
    (12,2,'முகடுகளைக் கடந்து — மலை முகடுகளைக் கடந்துசென்று; crossing the mountain peaks'),
    (13,2,'எனச்செல்லுமோர் — "செல்" என்று சொல்லிச் செல்லும் ஒரு (பாடல்); a song that travels, as if saying "go"'),
    (13,3,'பாடலை — பாட்டை; the song'),
    (14,1,'கபாடபுரங்கள் — அரண் சூழ்ந்த நகரங்கள்; the fortress-cities'),
    (14,2,'கொண்டபின்னும் — எடுத்துக்கொண்ட பிறகும்; even after having taken (it)'),
    (15,1,'காலத்தால் — காலத்தினால்; by time'),
    (15,2,'கனிமங்களின் — கனிமப்பொருள்களின்; of the minerals'),
    (16,1,'உரமெலாம் — வலிமை அனைத்தும்; all (its) strength'),
    (16,2,'பாடத்தான் — பாடத் தான்; (must) indeed sing'),
    (17,2,'தொடக்கிவைத்து — தொடங்கி வைத்து; having begun and set down'),
    (17,3,'என்னம்மை — என் அம்மை (மொழிக் குழைவு); my mother (sandhi form)'),
    (18,1,'மண்ணிலே — மண்ணின் மேலேயே; on the very ground'),
    (18,2,'தீட்டித்தீட்டி — மீண்டும் மீண்டும் தீட்டி; tracing (it) again and again'),
    (19,1,'விரல்முனையைத்தீயிலே — விரல் நுனியை நெருப்பிலேயே; the fingertip in the very fire'),
    (20,1,'திசைகளின்சுவரெலாம் — திசைகளின் சுவர்கள் அனைத்தும்; all the walls of every direction'),
    (20,2,'எழுதத்தான் — எழுதத் தான்; (must) indeed write'),
    (21,2,'யுகத்தினோர் — ஒரு யுகத்தினுடைய; of an/the age'),
    (21,3,'பாடலை — பாட்டை; the song')
  ) AS v(line_number, position, meaning)
  JOIN poem_lines pl ON pl.line_number = v.line_number AND pl.page_id = v_page_id
  WHERE wg.poem_line_id = pl.id AND wg.position = v.position;

  ----------------------------------------------------------------
  -- Sandhi rules for the 3-unit வியர்த்தவர்க்கெல்லாம் group, so the app's
  -- staged-combine UI can show the real intermediate word
  -- (வியர்த்தவர் + கு -> வியர்த்தவர்க்கு) instead of jumping straight to
  -- the fully combined form.
  ----------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg
  JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_page_id AND wg.combined_display_form = 'வியர்த்தவர்க்கெல்லாம்'
  LIMIT 1;

  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter)
    VALUES
      (v_group_id, 0, 'வேற்றுமை இடைநிலை "கு" முன் வல்லின மெய் மிகும்', 'வியர்த்தவர் + கு', 'வியர்த்தவர்க்கு', 'க்க'),
      (v_group_id, 1, 'உம்மைத் தொகைச்சொல் "எல்லாம்" இணைந்து முழுச் சொல் உருவாகும்', 'வியர்த்தவர்க்கு + எல்லாம்', 'வியர்த்தவர்க்கெல்லாம்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE
      SET rule_text = EXCLUDED.rule_text,
          before_form = EXCLUDED.before_form,
          after_form = EXCLUDED.after_form,
          changed_letter = EXCLUDED.changed_letter;
    RAISE NOTICE '✓ sandhi_rules added for வியர்த்தவர்க்கெல்லாம்.';
  ELSE
    RAISE NOTICE 'SKIP — வியர்த்தவர்க்கெல்லாம் word_group not found.';
  END IF;

  RAISE NOTICE '✓ Meanings filled for all morphemes and word_groups.';
END $$;

-- ============================================================================
-- Rename topic to யுகத்தின் பாடல் (no-op if already renamed)
-- ============================================================================
UPDATE topics
SET title = 'யுகத்தின் பாடல்'
WHERE title = 'என் அம்மை';

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT title FROM topics WHERE title IN ('என் அம்மை', 'யுகத்தின் பாடல்');

SELECT pl.line_number, pl.raw_text, wg.position, wg.combined_display_form, wg.combined_meaning
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'யுகத்தின் பாடல்'
ORDER BY pl.line_number, wg.position;

SELECT * FROM sandhi_rules sr
JOIN word_groups wg ON wg.id = sr.word_group_id
WHERE wg.combined_display_form = 'வியர்த்தவர்க்கெல்லாம்'
ORDER BY sr.connector_index;
