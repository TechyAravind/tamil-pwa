-- ============================================================================
-- காவடிச் சிந்து — stanzas 4-6 (lines 16-30) + poem_lines rows for them.
-- Run AFTER kavadi_sindhu_setup_1.sql and kavadi_sindhu_setup_2.sql.
--
-- Also attaches verb_analysis to "வருகின்ற" (line 22) and sandhi_rules to
-- "உயர்ந்தோங்கும்" (line 25) — both already documented explicitly in the
-- இலக்கணப் பகுதி content from setup_1.sql, so their word_groups get the
-- matching structured data, same as மனோன்மணீயம்'s pattern.
--
-- INTERPRETIVE FLAGS for your review (archaic/dense vocabulary):
--   1. "கொடிடிய" (line 24) — read as கொடி + தொடிய (''banner-strung/
--      adorned''); this compound isn't in the given சொல்லும் பொருளும்
--      glossary, so this is my best guess at the sandhi. Tell me the
--      intended split if different.
--   2. "நுழைவாரிடு" (line 18) — read as நுழைவார் (''those entering'') +
--      இடு (''produce/make''), i.e. ''the drum-sound the entering crowd
--      makes''. Also not in the glossary — flagging for your check.
--   3. "திசைமாசுணம்" (line 19) — கூறப்படும் இடிபோன்ற முழக்கத்தைக்
--      குறிக்கும் உருவகம் (''serpent of the directions'', a poetic image
--      for a deep rumbling sound); interpreted, not glossary-sourced.
-- ============================================================================

DO $$
DECLARE
  v_topic_id  uuid;
  v_poem_page_id uuid;
  v_group_id  uuid;

  v_l16 uuid; v_l17 uuid; v_l18 uuid; v_l19 uuid; v_l20 uuid;
  v_l21 uuid; v_l22 uuid; v_l23 uuid; v_l24 uuid; v_l25 uuid;
  v_l26 uuid; v_l27 uuid; v_l28 uuid; v_l29 uuid; v_l30 uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'காவடிச் சிந்து' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'காவடிச் சிந்து topic not found — run kavadi_sindhu_setup_1.sql first.';
  END IF;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  ----------------------------------------------------------------
  -- Poem lines 16-30
  ----------------------------------------------------------------
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 16, 'நூபுரத் துத்தொனி வெடிக்கும் - பத')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l16;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 17, 'நுண்ணிடை மாதர்கள் நடிக்கும் - அங்கே')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l17;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 18, 'நுழைவாரிடு முழவோசைகள்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l18;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 19, 'திசைமாசுணம் இடியோ என')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l19;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 20, 'நோக்கும் படி தாக்கும்.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l20;

  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 21, 'சந்நிதி யில்துஜஸ் தம்பம் - விண்ணில்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l21;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 22, 'தாவி வருகின்ற கும்பம் - எனும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l22;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 23, 'சலராசியை வடிவார்பல')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l23;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 24, 'கொடிடிய முடிமீதிலே')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l24;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 25, 'தாங்கும்; உயர்ந் தோங்கும்.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l25;

  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 26, 'உன்னத மாகிய இஞ்சி-பொன்னாட்டு')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l26;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 27, 'உம்பர் நகருக்கு மிஞ்சி - மிக')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l27;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 28, 'உயர்வானது பெறலால் அதில்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l28;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 29, 'அதிசீதள புயல்சாலவும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l29;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 30, 'உறங்கும்; மின்னிக் கறங்கும்.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l30;

  RAISE NOTICE 'Lines 16-30 ready.';

  DELETE FROM morphemes   WHERE poem_line_id IN (v_l16,v_l17,v_l18,v_l19,v_l20,v_l21,v_l22,v_l23,v_l24,v_l25,v_l26,v_l27,v_l28,v_l29,v_l30);
  DELETE FROM word_groups WHERE poem_line_id IN (v_l16,v_l17,v_l18,v_l19,v_l20,v_l21,v_l22,v_l23,v_l24,v_l25,v_l26,v_l27,v_l28,v_l29,v_l30);

  ----------------------------------------------------------------
  -- LINE 16: நூபுரத் துத்தொனி வெடிக்கும் - பத
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l16, 1, 'நூபுரத்துத்தொனி', 'நூபுரத்து தொனி = சிலம்பின் ஓசை; the sound of anklets') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 1, 'நூபுரம்', 'சிலம்பு; anklet', false, v_group_id),
    (v_l16, 2, 'து', 'ஆறாம் வேற்றுமை உருபு; genitive ''of''', false, v_group_id),
    (v_l16, 3, 'தொனி', 'ஓசை; sound', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 4, 'வெடிக்கும்', 'முழங்கும்; bursts forth, resounds', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 5, 'பத', 'பதம் (மென்மையான) — தொடர்கிறது line 17''s நுண்ணிடை உடன் → பத நுண்ணிடை; delicate/soft (continues into line 17)', false, NULL);

  ----------------------------------------------------------------
  -- LINE 17: நுண்ணிடை மாதர்கள் நடிக்கும் - அங்கே
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l17, 1, 'நுண்ணிடை', 'நுண்ணிடை = (line 16''s பத உடன் இணைந்து) மெல்லிய இடையுடைய; slender-waisted — completes line 16''s பத') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 1, 'நுண்', 'மெல்லிய, சிறிய; fine, delicate', false, v_group_id),
    (v_l17, 2, 'இடை', 'இடுப்பு; waist', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 3, 'மாதர்கள்', 'பெண்கள்; women', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 4, 'நடிக்கும்', 'ஆடும்; dance, perform', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 5, 'அங்கே', 'அவ்விடத்தில்; there', false, NULL);

  ----------------------------------------------------------------
  -- LINE 18: நுழைவாரிடு முழவோசைகள்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l18, 1, 'நுழைவாரிடு', 'நுழைவார் இடு = உள்நுழைவோர் எழுப்பும்; that which those entering (the temple) raise/make') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 1, 'நுழைவார்', 'உள்நுழைவோர்; those who enter', false, v_group_id),
    (v_l18, 2, 'இடு', 'எழுப்பும், உண்டாக்கும்; produce, make', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l18, 3, 'முழவோசைகள்', 'முழவு ஓசைகள் = மத்தள ஓசைகள்; the sounds of drums') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 3, 'முழவு', 'மத்தளம்; a kind of drum', false, v_group_id),
    (v_l18, 4, 'ஓசைகள்', 'ஓசைகள்; sounds', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 19: திசைமாசுணம் இடியோ என
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l19, 1, 'திசைமாசுணம்', 'திசை மாசுணம் = திசைகளைக் காக்கும் (பாம்பு போன்ற) முழக்கம் (உருவகம்); ''the serpent of the directions'' — a poetic image for a deep rumbling sound') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l19, 1, 'திசை', 'திசை; direction', false, v_group_id),
    (v_l19, 2, 'மாசுணம்', 'பாம்பு; serpent', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l19, 3, 'இடியோஎன', 'இடியோ என = இடி முழக்கமோ என்று (எண்ணும்படி); as if wondering ''is it thunder?''') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l19, 3, 'இடி', 'இடிமுழக்கம்; thunder', false, v_group_id),
    (v_l19, 4, 'ஓ', 'ஐயப்பாட்டு இடைச்சொல்; doubt/questioning particle', false, v_group_id),
    (v_l19, 5, 'என', 'என்று (எண்ணும்படி); so as to think/wonder', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 20: நோக்கும் படி தாக்கும்.
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l20, 1, 'நோக்கும்படி', 'நோக்கும்படி = (மக்கள்) நோக்கும்படியாக; so as to make (people) look/wonder') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l20, 1, 'நோக்கும்', 'பார்க்கும்; that looks, observes', false, v_group_id),
    (v_l20, 2, 'படி', 'விதமாக; in such a way, so as to', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l20, 3, 'தாக்கும்', 'மோதும்/வந்தெட்டும் (செவியை); strikes, reaches (the ear)', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l20, 4, '.', 'முற்றுப்புள்ளி', true, NULL);

  ----------------------------------------------------------------
  -- LINE 21: சந்நிதி யில்துஜஸ் தம்பம் - விண்ணில்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l21, 1, 'சந்நிதியில்', 'சந்நிதியில் = கோவில் முன்பாகத்தில்; in front of the shrine/sanctum') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 1, 'சந்நிதி', 'கோவில் முன்பாகம்; shrine-front, sanctum', false, v_group_id),
    (v_l21, 2, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''in''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l21, 3, 'துஜஸ்தம்பம்', 'துஜஸ் தம்பம் = கொடிமரம் (சொல்லும் பொருளும்); the flag-pole') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 3, 'துஜஸ்', 'கொடி (வடசொல்); flag', false, v_group_id),
    (v_l21, 4, 'தம்பம்', 'தூண், மரம்; pillar, pole', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l21, 5, 'விண்ணில்', 'விண்ணில் = வானத்தில்; in the sky') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 5, 'விண்', 'வானம்; sky', false, v_group_id),
    (v_l21, 6, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''in''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 22: தாவி வருகின்ற கும்பம் - எனும்
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l22, 1, 'தாவி', 'பாய்ந்து; leaping, bounding (வினையெச்சம் — இலக்கணக்குறிப்பில் கொடுக்கப்பட்டது)', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l22, 2, 'வருகின்ற', 'வருகின்ற = வருகிற (பகுபத உறுப்பிலக்கணத்தில் கொடுக்கப்பட்டது); that comes/is coming') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l22, 2, 'வா', 'பகுதி (வரு எனத் திரிந்தது விகாரம்); root ''to come''', false, v_group_id),
    (v_l22, 3, 'கின்று', 'நிகழ்கால இடைநிலை; present tense marker', false, v_group_id),
    (v_l22, 4, 'அ', 'பெயரெச்ச விகுதி; adjectival-participle ending', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l22, 5, 'கும்பம்', 'குடம் வடிவம்; pot-shape (of the flag/kalasam)', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l22, 6, 'எனும்', 'என்னும் (தொடர்கிறது line 23''s சலராசியை உடன்); that is called — continues into line 23', false, NULL);

  ----------------------------------------------------------------
  -- LINE 23: சலராசியை வடிவார்பல
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l23, 1, 'சலராசியை', 'சலராசியை = கடலில் வாழும் மீன் முதலிய உயிர்களை (சொல்லும் பொருளும்); sea-creatures (fish, shark shapes on flags) — accusative') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l23, 1, 'சலராசி', 'கடலில் வாழும் மீன் முதலிய உயிர்கள்; sea creatures (fish, shark)', false, v_group_id),
    (v_l23, 2, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l23, 3, 'வடிவார்பல', 'வடிவு ஆர் பல = அவ்வுருவம் நிறைந்த பல (கொடிகள்); many (flags) full of that shape') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l23, 3, 'வடிவு', 'உருவம்; shape, form', false, v_group_id),
    (v_l23, 4, 'ஆர்', 'நிறைந்த; full of, abundant', false, v_group_id),
    (v_l23, 5, 'பல', 'பல; many', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 24: கொடிடிய முடிமீதிலே
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l24, 1, 'கொடிதொடிய', 'கொடி தொடிய = கொடிகள் கோக்கப்பட்ட/அணிசெய்யப்பட்ட; strung/adorned with flags (எனது ஊகம் — நேரடிச் சொற்பொருள் அகராதியில் இல்லை)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l24, 1, 'கொடி', 'கொடி; flag, banner', false, v_group_id),
    (v_l24, 2, 'தொடிய', 'கோக்கப்பட்ட, அணிசெய்யப்பட்ட; strung, adorned (interpreted)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l24, 3, 'முடிமீதிலே', 'முடி மீதிலே = உச்சியின் மேலே; atop the very summit/crown') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l24, 3, 'முடி', 'உச்சி, கிரீடம்; summit, crown', false, v_group_id),
    (v_l24, 4, 'மீது', 'மேலே; above, atop', false, v_group_id),
    (v_l24, 5, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''in/at''', false, v_group_id),
    (v_l24, 6, 'ஏ', 'சிறப்பு இடைச்சொல் (அழுத்தம்); emphatic particle', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 25: தாங்கும்; உயர்ந் தோங்கும்.
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l25, 1, 'தாங்கும்', 'சுமக்கும், தரிக்கும்; bears, holds', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l25, 2, ';', 'பிரிப்புக் குறியீடு', true, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l25, 3, 'உயர்ந்தோங்கும்', 'உயர்ந்தோங்கும் = உயர்ந்து ஓங்கும் (புணர்ச்சி விதி இலக்கணப் பகுதியில் கொடுக்கப்பட்டது); rises and towers high') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l25, 3, 'உயர்ந்து', 'உயர்ந்து; having risen', false, v_group_id),
    (v_l25, 4, 'ஓங்கும்', 'ஓங்கும்; towers, soars', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l25, 5, '.', 'முற்றுப்புள்ளி', true, NULL);

  ----------------------------------------------------------------
  -- LINE 26: உன்னத மாகிய இஞ்சி-பொன்னாட்டு
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l26, 1, 'உன்னதமாகிய', 'உன்னதமாகிய = உயர்ந்த, மேலான; that is exalted, lofty') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l26, 1, 'உன்னதம்', 'உயர்வு, மேன்மை; loftiness, exaltedness', false, v_group_id),
    (v_l26, 2, 'ஆகிய', 'ஆன, ஆகிய; that is, that has become', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l26, 3, 'இஞ்சி', 'மதில் (சொல்லும் பொருளும்); fort wall, rampart', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l26, 4, 'பொன்நாட்டு', 'பொன்நாட்டு = பொன்னாட்டினுடைய (தொடர்கிறது line 27''s உம்பர்நகர் உடன்); of the golden land — continues into line 27''s ''heavenly city''') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l26, 4, 'பொன்', 'தங்கம்; gold', false, v_group_id),
    (v_l26, 5, 'நாடு', 'நாடு; land, country', false, v_group_id),
    (v_l26, 6, 'து', 'ஆறாம் வேற்றுமை உருபு; genitive ''of''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 27: உம்பர் நகருக்கு மிஞ்சி - மிக
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l27, 1, 'உம்பர்நகருக்கு', 'உம்பர் நகருக்கு = (line 26''s பொன்நாட்டு உடன் இணைந்து) பொன்னாட்டு தேவலோக நகரத்தை விட; than the golden-land heavenly city — completes line 26''s word') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l27, 1, 'உம்பர்', 'தேவர், விண்ணுலகு; celestials, the heavens', false, v_group_id),
    (v_l27, 2, 'நகர்', 'நகரம்; city', false, v_group_id),
    (v_l27, 3, 'உக்கு', 'நான்காம் வேற்றுமை உருபு (ஒப்பீடு); dative ''to/than'' (comparison)', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l27, 4, 'மிஞ்சி', 'மிகுந்து, தாண்டி; exceeding, surpassing', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l27, 5, 'மிக', 'மிகவும் (தொடர்கிறது line 28''s உயர்வானது உடன்); very (continues into line 28)', false, NULL);

  ----------------------------------------------------------------
  -- LINE 28: உயர்வானது பெறலால் அதில்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l28, 1, 'உயர்வானது', 'உயர்வானது = (line 27''s மிக உடன் இணைந்து) மிக உயர்ந்தது; that is very lofty — completes line 27''s மிக') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l28, 1, 'உயர்வு', 'உயரம்; height, loftiness', false, v_group_id),
    (v_l28, 2, 'ஆனது', 'ஆனது; that which is', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l28, 3, 'பெறலால்', 'பெறலால் = பெற்றிருப்பதால்; because of possessing/having gained') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l28, 3, 'பெறல்', 'பெறுதல்; gaining, possessing', false, v_group_id),
    (v_l28, 4, 'ஆல்', 'மூன்றாம் வேற்றுமை உருபு (காரணம்); instrumental ''because of''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l28, 5, 'அதில்', 'அதனிடத்தில்; in it', false, NULL);

  ----------------------------------------------------------------
  -- LINE 29: அதிசீதள புயல்சாலவும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l29, 1, 'அதிசீதளம்', 'அதிசீதளம் = மிகுந்த குளிர்ச்சி உடைய; extremely cool/cold') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l29, 1, 'அதி', 'மிகுந்த; extreme, very', false, v_group_id),
    (v_l29, 2, 'சீதளம்', 'குளிர்ச்சி; coolness', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l29, 3, 'புயல்சாலவும்', 'புயல் சாலவும் = மேகங்கள் மிகுதியாகவும்; clouds too, abundantly (சொல்லும் பொருளும்: புயல் – மேகம்)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l29, 3, 'புயல்', 'மேகம்; cloud', false, v_group_id),
    (v_l29, 4, 'சால', 'மிகுதியாக; abundantly', false, v_group_id),
    (v_l29, 5, 'உம்', 'சிறப்பும்மை; ''also/too''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 30: உறங்கும்; மின்னிக் கறங்கும்.
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l30, 1, 'உறங்கும்', 'தங்கும், படியும் (மேகம் உறங்கும் = மேகம் தங்கும்); settles, rests (of clouds settling on the fort)', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l30, 2, ';', 'பிரிப்புக் குறியீடு', true, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l30, 3, 'மின்னிக்கறங்கும்', 'மின்னிக் கறங்கும் = மின்னலிட்டுச் சுழலும்; flashes (with lightning) and swirls (சொல்லும் பொருளும்: கறங்கும் – சுழலும்)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l30, 3, 'மின்னி', 'மின்னலிட்டு; having flashed (lightning)', false, v_group_id),
    (v_l30, 4, 'கறங்கும்', 'சுழலும்; whirls, swirls', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l30, 5, '.', 'முற்றுப்புள்ளி', true, NULL);

  RAISE NOTICE '✓ Stanzas 4-6 (lines 16-30) done.';

  ----------------------------------------------------------------
  -- verb_analysis: வருகின்ற (line 22) — already documented in இலக்கணப் பகுதி
  ----------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 22 AND wg.combined_display_form = 'வருகின்ற';
  IF v_group_id IS NOT NULL THEN
    UPDATE word_groups SET combined_is_verb = true, combined_grammatical_label = 'வினைச்சொல்' WHERE id = v_group_id;
    INSERT INTO verb_analysis (word_group_id, analysis) VALUES
      (v_group_id, '[{"part":"வா","label":"பகுதி (வரு எனத் திரிந்தது விகாரம்)"},{"part":"கின்று","label":"நிகழ்கால இடைநிலை"},{"part":"அ","label":"பெயரெச்ச விகுதி"}]')
    ON CONFLICT (word_group_id) WHERE word_group_id IS NOT NULL DO UPDATE SET analysis = EXCLUDED.analysis;
  ELSE
    RAISE NOTICE '✗ Could not find வருகின்ற word_group for verb_analysis.';
  END IF;

  ----------------------------------------------------------------
  -- sandhi_rules: உயர்ந்தோங்கும் (line 25) — already documented in இலக்கணப் பகுதி
  ----------------------------------------------------------------
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'உயர்ந்தோங்கும்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, before_form, after_form, changed_letter, mnemonic_tag, mnemonic_hierarchy, rule_steps)
    VALUES (v_group_id, 0, 'உயர்ந்து + ஓங்கும்', 'உயர்ந்தோங்கும்', NULL,
      'கு சு து பு | உயிர்', '["உ | உ", "உ | உயிர்", "கு | உயிர்", "கு சு து பு | உயிர்"]'::jsonb,
      '[
        {"condition": "விதி 1", "rule": "உயிர்வரின் உக்குறள் மெய் விட்டோடும்", "result": "உயர்ந்த் + «உ» + ஓங்கும் → உயர்ந்த் + ஓங்கும்"},
        {"condition": "விதி 2", "rule": "உடல்மேல் உயிர் வந்து ஒன்றுவது இயல்பே", "result": "உயர்ந்த் + ஓங்கும் = உயர்ந்தோங்கும்"}
      ]'::jsonb)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form,
      mnemonic_tag = EXCLUDED.mnemonic_tag, mnemonic_hierarchy = EXCLUDED.mnemonic_hierarchy,
      rule_steps = EXCLUDED.rule_steps;
  ELSE
    RAISE NOTICE '✗ Could not find உயர்ந்தோங்கும் word_group for sandhi_rules.';
  END IF;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, pl.raw_text, count(wg.id) AS word_groups
FROM poem_lines pl
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
LEFT JOIN word_groups wg ON wg.poem_line_id = pl.id
WHERE t.title = 'காவடிச் சிந்து' AND p.page_type = 'செய்யுள் பகுதி' AND pl.line_number BETWEEN 16 AND 30
GROUP BY pl.line_number, pl.raw_text
ORDER BY pl.line_number;
