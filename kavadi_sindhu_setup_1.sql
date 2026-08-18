-- ============================================================================
-- காவடிச் சிந்து (சென்னிகுளம் அண்ணாமலையார்) — topic setup + shared pages
-- + stanzas 1-3 (lines 1-15) of "கோயில் வளம்" full treatment.
--
-- SOURCE: uploaded "Pages from 11-1.pdf" (XI Std Tamil, இயல் 3, pages
-- 62-63) for line text, சொல்லும் பொருளும் glossary, பாடலின் பொருள்,
-- இலக்கணக்குறிப்பு, பகுபத உறுப்பிலக்கணம், புணர்ச்சி விதி, நூல்வெளி —
-- and "Pages from Tamil Workbook..." for the word-grouping guide (its
-- பிரித்து எழுதுக table groups compound words the same way I've grouped
-- word_groups below).
--
-- STRUCTURAL NOTE: இந்தச் சிந்துப் பாடல் ஒவ்வோர் அடியிலும் "-" குறியிட்டு
-- அடுத்த அடிக்குச் சொல் தொடர்வதுபோல் அச்சிடப்பட்டுள்ளது (எதுகை/சந்த
-- நடையின் ஒரு பகுதி). Since word_groups/morphemes are scoped to ONE
-- poem_line each (matching the existing schema — same constraint the
-- மனோன்மணீயம் script works within), a word split across a line-break
-- (e.g. "தமிழ்" ending line 1, "தேறும்" starting line 2) is stored as TWO
-- separate items, one per line, with the meaning noting the continuation.
-- This mirrors exactly how மனோன்மணீயம்.sql handles line-final fragments.
--
-- INTERPRETIVE CHOICES I made (flagging for your review, same as always):
--   1. "சென்னி + குள(ம்) + நகர்" — I split சென்னிகுளம் (the poet's home
--      town, per நூல்வெளி) into சென்னி/குள/நகர், rather than treating
--      "சென்னிகுளம்" as one indivisible proper noun. Tell me if you'd
--      rather keep it unsplit.
--   2. Line 4 "அதனைப்புய வரையில்புனை" — read as அதனை (accusative "அது")
--      + புயம்+வரை+இல் ("on the mountain-like shoulder") + புனை (verb,
--      continues to "தீரன்" on line 5). This is my own parsing of the
--      சிந்து meter, not lifted from an explicit textbook breakdown.
--   3. Proper nouns (குறவள்ளி, கழுகாசலம், etc.) are kept as single
--      morphemes, not further split.
--
-- Safe to re-run: reuses topic/pages if they exist, refreshes lines
-- 1-15's word_groups/morphemes each time.
-- ============================================================================

DO $$
DECLARE
  v_section_id uuid;
  v_topic_id   uuid;
  v_intro_page_id uuid;
  v_poem_page_id  uuid;
  v_gram_page_id  uuid;
  v_notes_page_id uuid;
  v_bookinfo_page_id uuid;
  v_group_id   uuid;

  v_l1 uuid; v_l2 uuid; v_l3 uuid; v_l4 uuid; v_l5 uuid;
  v_l6 uuid; v_l7 uuid; v_l8 uuid; v_l9 uuid; v_l10 uuid;
  v_l11 uuid; v_l12 uuid; v_l13 uuid; v_l14 uuid; v_l15 uuid;
BEGIN
  ----------------------------------------------------------------
  -- 1. Section + Topic
  ----------------------------------------------------------------
  SELECT id INTO v_section_id FROM sections WHERE name = 'செய்யுள்' LIMIT 1;
  IF v_section_id IS NULL THEN
    RAISE EXCEPTION 'No section named செய்யுள் found — check your sections table.';
  END IF;

  SELECT id INTO v_topic_id FROM topics WHERE title = 'காவடிச் சிந்து' LIMIT 1;
  IF v_topic_id IS NULL THEN
    INSERT INTO topics (section_id, title, order_index)
    VALUES (v_section_id, 'காவடிச் சிந்து', 50)
    RETURNING id INTO v_topic_id;
    RAISE NOTICE 'Created topic காவடிச் சிந்து (id=%)', v_topic_id;
  ELSE
    RAISE NOTICE 'Reusing existing topic காவடிச் சிந்து (id=%)', v_topic_id;
  END IF;

  ----------------------------------------------------------------
  -- 2. Pages
  ----------------------------------------------------------------
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'நுழையும் முன்')       ON CONFLICT (topic_id, page_type) DO NOTHING;
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'செய்யுள் பகுதி')      ON CONFLICT (topic_id, page_type) DO NOTHING;
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'இலக்கணப் பகுதி')      ON CONFLICT (topic_id, page_type) DO NOTHING;
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'துணைக் குறிப்புகள்')  ON CONFLICT (topic_id, page_type) DO NOTHING;
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'நூல் வெளி')           ON CONFLICT (topic_id, page_type) DO NOTHING;

  SELECT id INTO v_intro_page_id    FROM pages WHERE topic_id = v_topic_id AND page_type = 'நுழையும் முன்';
  SELECT id INTO v_poem_page_id     FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';
  SELECT id INTO v_gram_page_id     FROM pages WHERE topic_id = v_topic_id AND page_type = 'இலக்கணப் பகுதி';
  SELECT id INTO v_notes_page_id    FROM pages WHERE topic_id = v_topic_id AND page_type = 'துணைக் குறிப்புகள்';
  SELECT id INTO v_bookinfo_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'நூல் வெளி';

  ----------------------------------------------------------------
  -- 3. நுழையும் முன்
  ----------------------------------------------------------------
  DELETE FROM prose_content WHERE page_id = v_intro_page_id;
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
  (v_intro_page_id,
   'காவடி எடுத்தல் தமிழ்ப் பண்பாட்டுக் கூறுகளுள் ஒன்று. உலகெங்கும் வாழும் தமிழர்கள் குன்றுதோறும் வீற்றிருக்கும் முருகன் கோவில்களில் காவடி எடுத்து ஆடுவது வழக்கமாக உள்ளது. காவடி தூக்கிச் செல்வோர், அதைச் சுமையாக உணராமல் இருக்கப் பாடியவாறே செல்வதற்குப் புலவர்கள் வழிநடைப் பாடல்களை இயற்றியுள்ளனர்.',
   10),
  (v_intro_page_id,
   'தமிழ்நாட்டில் நீண்ட காலமாக நாட்டார் வழக்கில் இருக்கும் இசைமரபே காவடிச் சிந்து எனலாம். முருகப் பெருமானின் வழிபாட்டிற்காகப் பால் முதலான வழிபாட்டுப் பொருள்களைக் கொண்டு செல்வோர், ஆடல் பாடல்களுடன் ஆலயங்களை நோக்கிச் செல்வர். அவர்களின் வழிநடைப்பாடல் வகைகளிலிருந்து காவடிச் சிந்து எனும் பாவடிவம் தோன்றியது.',
   20);

  ----------------------------------------------------------------
  -- 4. இலக்கணப் பகுதி
  ----------------------------------------------------------------
  DELETE FROM prose_content WHERE page_id = v_gram_page_id;
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
  (v_gram_page_id, 'இலக்கணக்குறிப்பு', 10),
  (v_gram_page_id, 'தாவி – வினையெச்சம்; மாதே – விளி.', 20),
  (v_gram_page_id, 'பகுபத உறுப்பிலக்கணம்', 30),
  (v_gram_page_id, 'வருகின்ற = வா(வரு) + கின்று + அ. வா – பகுதி (வரு எனத் திரிந்தது விகாரம்), கின்று – நிகழ்கால இடைநிலை, அ – பெயரெச்ச விகுதி.', 40),
  (v_gram_page_id, 'புணர்ச்சி விதி', 50),
  (v_gram_page_id, 'திருப்புகழ் = திரு + புகழ். விதி: ‘இயல்பினும் விதியினும் நின்ற உயிர் முன் கசதப மிகும்’ → திருப்புகழ்.', 60),
  (v_gram_page_id, 'உயர்ந்தோங்கும் = உயர்ந்து + ஓங்கும். விதி: ‘உயிர்வரின் உக்குறள் மெய் விட்டோடும்’ → உயர்ந்த் + ஓங்கும். விதி: ‘உடல்மேல் உயிர் வந்து ஒன்றுவது இயல்பே’ → உயர்ந்தோங்கும்.', 70);

  ----------------------------------------------------------------
  -- 5. துணைக் குறிப்புகள் — சொல்லும் பொருளும்
  ----------------------------------------------------------------
  DELETE FROM prose_content WHERE page_id = v_notes_page_id;
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
  (v_notes_page_id, 'சொல்லும் பொருளும்', 10),
  (v_notes_page_id, 'புயம் – தோள்; வரை – மலை; வன்னம் – அழகு; கழுகாசலம் – கழுகு மலை; துஜஸ் தம்பம் – கொடி மரம்; சலராசி – கடலில் வாழும் மீன் முதலிய உயிர்கள்; விலாசம் – அழகு; நூபுரம் – சிலம்பு; மாசுணம் – பாம்பு; இஞ்சி – மதில்; புயல் – மேகம்; கறங்கும் – சுழலும்.', 20),
  (v_notes_page_id, 'பாடலின் பொருள்', 30),
  (v_notes_page_id, 'சென்னிகுளம் என்னும் நகரில் வாழ்கின்ற அண்ணாமலைதாசன் ஆகிய நான் பாடிய உலகம் போற்றும் காவடிச்சிந்து என்னும் மதுரமான கவிமாலையைத் தன் மலைபோன்ற அகன்ற தோளில் சார்த்திக்கொள்கிறான் முருகன். அந்தக் கழுகுமலைத் தலைவன் முருகனின் கோவில் வளத்தை நான் சொல்கிறேன். கோவில் கோபுரத்தின் தங்கக் கலசம் தேவர் உலகை விட உயர்ந்து ஒளி வீசுகிறது. அவ்வொளி உலகங்கள் பலவற்றிலும் கண்கள் கூசும்படி பரவுகிறது.', 40);

  ----------------------------------------------------------------
  -- 6. நூல் வெளி
  ----------------------------------------------------------------
  DELETE FROM prose_content WHERE page_id = v_bookinfo_page_id;
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
  (v_bookinfo_page_id,
   '19ஆம் நூற்றாண்டைச் சேர்ந்த சென்னிகுளம் அண்ணாமலையார் பாடிய காவடிச்சிந்து அருணகிரியாரின் திருப்புகழ்த் தாக்கத்தால் விளைந்த சிறந்த சந்த இலக்கியமாகும். இப்பாடலின் மெட்டு அண்ணாமலையாரால் அமைக்கப்பட்டதாகும். தமிழில் முதன்முதலில் வண்ணச்சிந்து பாடியதால், காவடிச் சிந்தின் தந்தை என அழைக்கப்பட்டார்; 18 வயதிலேயே ஊற்றுமலைக்குச் சென்று அங்குக் குறுநிலத்தலைவராக இருந்த இருதயாலய மருதப்பத் தேவரின் அரசவைப் புலவராகவும் இருந்தார்.',
   10),
  (v_bookinfo_page_id,
   'இவர், இந்நூல் தவிர வீரைத் தலபுராணம், வீரை நவநீத கிருஷ்ணசாமி பதிகம், சங்கரன்கோவில் திரிபந்தாதி, கருவை மும்மணிக்கோவை, கோமதி அந்தாதி ஆகிய நூல்களையும் இயற்றியுள்ளார்.',
   20);

  ----------------------------------------------------------------
  -- 7. Poem lines 1-15 (stanzas 1-3, கோயில் வளம்)
  ----------------------------------------------------------------
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 1, 'சென்னி குளநகர் வாசன் - தமிழ்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l1;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 2, 'தேறும் அண்ணாமலை தாசன் - செப்பும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l2;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 3, 'செகமெச்சிய மதுரக்கவி')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l3;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 4, 'அதனைப்புய வரையில்புனை')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l4;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 5, 'தீரன்; அயில் வீரன்.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l5;

  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 6, 'வன்ன மயில்முரு கேசன் - குற')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l6;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 7, 'வள்ளி பதம்பணி நேசன் - உரை')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l7;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 8, 'வரமேதரு கழுகாசல')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l8;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 9, 'பதிகோயிலின் வளம்நான்மற')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l9;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 10, 'வாதே சொல்வன் மாதே!')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l10;

  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 11, 'கோபுரத் துத்தங்கத் தூவி - தேவர்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l11;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 12, 'கோபுரத் துக்கப்பால் மேவி - கண்கள்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l12;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 13, 'கூசப்பிர காசத்தொளி')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l13;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 14, 'மாசற்று விலாசத்தொடு')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l14;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 15, 'குலவும் புவி பலவும்.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l15;

  RAISE NOTICE 'Lines 1-15 ready.';

  ----------------------------------------------------------------
  -- 8. Clean slate for lines 1-15's morphemes/word_groups
  ----------------------------------------------------------------
  DELETE FROM morphemes WHERE poem_line_id IN (v_l1,v_l2,v_l3,v_l4,v_l5,v_l6,v_l7,v_l8,v_l9,v_l10,v_l11,v_l12,v_l13,v_l14,v_l15);
  DELETE FROM word_groups WHERE poem_line_id IN (v_l1,v_l2,v_l3,v_l4,v_l5,v_l6,v_l7,v_l8,v_l9,v_l10,v_l11,v_l12,v_l13,v_l14,v_l15);

  ----------------------------------------------------------------
  -- LINE 1: சென்னி குளநகர் வாசன் - தமிழ்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l1, 1, 'சென்னிகுளநகர்வாசன்', 'சென்னிகுளநகர் வாசன் = சென்னிகுளம் என்னும் ஊரில் வாழ்பவன் (பாடியவர் தன்னைக் குறிப்பிடுவது)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l1, 1, 'சென்னி', 'ஊர்ப்பெயரின் முதற்பகுதி (சென்னிகுளம்); place-name part', false, v_group_id),
    (v_l1, 2, 'குள', 'குளம் — ஊர்ப்பெயரின் இரண்டாம் பகுதி; pond (place-name part)', false, v_group_id),
    (v_l1, 3, 'நகர்', 'ஊர், நகரம்; town', false, v_group_id),
    (v_l1, 4, 'வாசன்', 'வாழ்பவன்; resident, dweller', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l1, 5, 'தமிழ்', 'தமிழ் (அடுத்த அடியில் உள்ள ''தேறும்'' உடன் இணைந்து ''தமிழ் தேறும்'' — தமிழில் வல்லவனாகிய); Tamil (continues into line 2''s தேறும்)', false, NULL);

  ----------------------------------------------------------------
  -- LINE 2: தேறும் அண்ணாமலை தாசன் - செப்பும்
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l2, 1, 'தேறும்', 'தெளிந்த, வல்லவனாகிய (தமிழ் தேறும் = தமிழில் வல்ல); proficient, skilled — continues line 1''s தமிழ்', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l2, 2, 'அண்ணாமலைதாசன்', 'அண்ணாமலைதாசன் = பாடியவரின் பெயர்; the poet''s name (Annamalai Dasan)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l2, 2, 'அண்ணாமலை', 'பெயர்ச்சொல் பகுதி (இறைவன் பெயர்/ஊர்ப்பெயர்); name part', false, v_group_id),
    (v_l2, 3, 'தாசன்', 'தொண்டன்; servant/devotee (name-ending)', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l2, 4, 'செப்பும்', 'சொல்லும்; utters, says (continues into line 3''s object)', false, NULL);

  ----------------------------------------------------------------
  -- LINE 3: செகமெச்சிய மதுரக்கவி
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l3, 1, 'செகமெச்சிய', 'செகமெச்சிய = உலகம் மெச்சிய; praised/admired by the world') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l3, 1, 'செகம்', 'உலகம் (ஜகம் என்னும் வடசொல்); the world', false, v_group_id),
    (v_l3, 2, 'எச்சிய', 'மெச்சிய; praised, admired', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l3, 3, 'மதுரக்கவி', 'மதுரக்கவி = இனிமையான கவிதை; sweet poem') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l3, 3, 'மதுர', 'இனிமையான; sweet', false, v_group_id),
    (v_l3, 4, 'கவி', 'கவிதை; poem', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 4: அதனைப்புய வரையில்புனை
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l4, 1, 'அதனை', 'அதை (அது + ஐ); that (poem) — accusative object', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l4, 2, 'புயவரையில்', 'புய வரையில் = மலை போன்ற தோளில்; on the mountain-like shoulder') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l4, 2, 'புய', 'தோள்; shoulder', false, v_group_id),
    (v_l4, 3, 'வரை', 'மலை; mountain', false, v_group_id),
    (v_l4, 4, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''on/in''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l4, 5, 'புனை', 'சூடிக்கொள்/அணிந்துகொள் (தொடர்கிறது line 5''s தீரன் உடன்); wears/composes/adorns — continues into line 5''s தீரன்', false, NULL);

  ----------------------------------------------------------------
  -- LINE 5: தீரன்; அயில் வீரன்.
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 1, 'தீரன்', 'திறமையுடையவன் (முருகன்) — புனை...தீரன் = அணிந்துகொள்ளும் திறமிக்கோன்; the able one (Murugan), completes line 4''s புனை', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 2, ';', 'பிரிப்புக் குறியீடு', true, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l5, 3, 'அயில்வீரன்', 'அயில் வீரன் = வேல் ஏந்திய வீரன் (முருகன்); the spear-bearing warrior (Murugan)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 4, 'அயில்', 'வேல்; spear', false, v_group_id),
    (v_l5, 5, 'வீரன்', 'வீரன்; warrior, hero', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 6, '.', 'முற்றுப்புள்ளி', true, NULL);

  RAISE NOTICE '✓ Stanza 1 (lines 1-5) done.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, pl.raw_text, count(wg.id) AS word_groups
FROM poem_lines pl
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
LEFT JOIN word_groups wg ON wg.poem_line_id = pl.id
WHERE t.title = 'காவடிச் சிந்து' AND p.page_type = 'செய்யுள் பகுதி' AND pl.line_number <= 15
GROUP BY pl.line_number, pl.raw_text
ORDER BY pl.line_number;
