-- ============================================================================
-- மனோன்மணீயம் (பெ.சுந்தரனார்) — COMPLETE செய்யுள் பகுதி setup
--   Topic + 5 pages + 47 poem lines + word_groups + morphemes, all in one
--   script, matching the boxed-container split format from
--   "இதோ ஓ இக்கரை.docx" (each "/" -> one word_group container, each "+"
--   inside it -> one morpheme box, following the same pattern already used
--   for என் அம்மை / யுகத்தின் பாடல்).
--
-- SOURCE: "இதோ ஓ இக்கரை.docx" (morpheme split) + "manonmanium.pdf"
--   (XI Std Tamil, இயல் 2 — மனோன்மணீயம், pages 28-30) for line text,
--   அடிகள் references and the சொல்லும் பொருளும் glossary.
--
-- CORRECTIONS I MADE TO THE DOCX SPLIT (flagging for your review):
--   1. Line 1 "காலையில் கடிநகர் கடந்து நமது" had NO split given in the
--      docx — I supplied a reasonable one myself: காலை+இல் / கடி+நகர் /
--      கடந்து / நமது. Tell me if you intended something different.
--   2. Line 21 "பொறுமையும் புலனுங் காண்போர், ஒன்றையும்" had zero "/"
--      separators in the docx (all 9 morphemes chained with only "+"),
--      unlike every other line. I split it into 4 groups matching the 4
--      raw words. Please check this is what you meant.
--   3. Line 41 "புழுக்களும் பூச்சியும் பிழைக்குமா றென்னை?" only had one
--      "/" in the docx, merging 3 raw words into one box. I split it into
--      3 groups (பூச்சியும் / பிழைக்குமாறு / என்னை). Please check.
--   All other lines are used exactly as split in your docx.
--
-- MEANINGS: word_meaning / combined_meaning values are my own reading of
-- this poem (a well-known Manonmaniyam excerpt — நடராசன் தனிமொழி,
-- புல்லின் பரிவு, நாங்கூழ்ப்புழுவின் பொதுநலம்), cross-checked against the
-- "சொல்லும் பொருளும்" glossary in your textbook PDF where it gives a
-- specific word (கடிநகர், காண்டி, பூம்பராகம், ஆசு இலா, தோட்டி, அயம்,
-- புக்க விட்டு, நாங்கூழ்ப்புழு, ஓவா, பாடு, வேதித்து). Not an external
-- dictionary API — please review, especially for lines I had to interpret
-- (e.g. புணர்ச்சி-heavy lines). Tell me any correction and I'll fix that
-- specific row.
--
-- Safe to re-run: reuses topic/pages/lines if they already exist, and
-- always refreshes word_groups/morphemes to match this script.
-- ============================================================================

DO $$
DECLARE
  v_section_id uuid;
  v_topic_id   uuid;
  v_page_id    uuid;
  v_group_id   uuid;

  v_l1 uuid;
  v_l2 uuid;
  v_l3 uuid;
  v_l4 uuid;
  v_l5 uuid;
  v_l6 uuid;
  v_l7 uuid;
  v_l8 uuid;
  v_l9 uuid;
  v_l10 uuid;
  v_l11 uuid;
  v_l12 uuid;
  v_l13 uuid;
  v_l14 uuid;
  v_l15 uuid;
  v_l16 uuid;
  v_l17 uuid;
  v_l18 uuid;
  v_l19 uuid;
  v_l20 uuid;
  v_l21 uuid;
  v_l22 uuid;
  v_l23 uuid;
  v_l24 uuid;
  v_l25 uuid;
  v_l26 uuid;
  v_l27 uuid;
  v_l28 uuid;
  v_l29 uuid;
  v_l30 uuid;
  v_l31 uuid;
  v_l32 uuid;
  v_l33 uuid;
  v_l34 uuid;
  v_l35 uuid;
  v_l36 uuid;
  v_l37 uuid;
  v_l38 uuid;
  v_l39 uuid;
  v_l40 uuid;
  v_l41 uuid;
  v_l42 uuid;
  v_l43 uuid;
  v_l44 uuid;
  v_l45 uuid;
  v_l46 uuid;
  v_l47 uuid;
BEGIN

  ----------------------------------------------------------------
  -- 1. Section — reuse the existing செய்யுள் (poetry) section
  ----------------------------------------------------------------
  SELECT id INTO v_section_id FROM sections WHERE name = 'செய்யுள்' LIMIT 1;
  IF v_section_id IS NULL THEN
    RAISE EXCEPTION 'No section named செய்யுள் found — check your sections table.';
  END IF;

  ----------------------------------------------------------------
  -- 2. Topic — reuse if it already exists, else create
  ----------------------------------------------------------------
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    INSERT INTO topics (section_id, title, order_index)
    VALUES (v_section_id, 'மனோன்மணீயம்', 40)
    RETURNING id INTO v_topic_id;
    RAISE NOTICE 'Created topic மனோன்மணீயம் (id=%)', v_topic_id;
  ELSE
    RAISE NOTICE 'Reusing existing topic மனோன்மணீயம் (id=%)', v_topic_id;
  END IF;

  ----------------------------------------------------------------
  -- 3. All 5 pages — reuse if already there, else create
  ----------------------------------------------------------------
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'நுழையும் முன்')       ON CONFLICT (topic_id, page_type) DO NOTHING;
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'செய்யுள் பகுதி')      ON CONFLICT (topic_id, page_type) DO NOTHING;
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'இலக்கணப் பகுதி')      ON CONFLICT (topic_id, page_type) DO NOTHING;
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'துணைக் குறிப்புகள்')  ON CONFLICT (topic_id, page_type) DO NOTHING;
  INSERT INTO pages (topic_id, page_type) VALUES (v_topic_id, 'நூல் வெளி')           ON CONFLICT (topic_id, page_type) DO NOTHING;

  SELECT id INTO v_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  ----------------------------------------------------------------
  -- 4. The 47 poem lines — reuse by line_number if already present
  ----------------------------------------------------------------

  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 1, 'காலையில் கடிநகர் கடந்து நமது')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l1;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 2, 'வேலை முடிக்குதும், வேண்டின் விரைவாய்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l2;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 3, 'இன்று இரா முடுக்கினும் முடியும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l3;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 4, 'எவ்வினை யோர்க்கும் இம்மையில் தம்மை')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l4;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 5, 'இயக்குதற்கு இன்பம் பயக்கும்ஓர் இலக்கு')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l5;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 6, 'வேண்டும்; உயிர்க்கு அது தூண்டுகோல் போலாம்.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l6;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 7, 'ஈண்டு எப்பொருள்தான் இலக்கற்று இருப்பது')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l7;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 8, 'இதோ ஒ! இக்கரை முளைத்தஇச் சிறுபுல்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l8;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 9, 'சதாதன் குறிப்பொடு சாருதல் காண்டி;')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l9;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 10, 'அதன்சிறு பூக்குலை அடியொன்று உயர்த்தி')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l10;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 11, 'இதமுறத் தேன்துளி தாங்கி ஈக்களை')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l11;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 12, 'நலமுற அழைத்து நல்லூண் அருத்திப்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l12;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 13, 'பலமுறத் தனதுபூம் பராகம் பரப்பித்து')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l13;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 14, 'ஆசுஇலாச் சிறுகாய் ஆக்கி, இதோ! என்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l14;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 15, 'தூசிடைச் சிக்கும் தோட்டியும் கொடுத்தே')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l15;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 16, '"இவ்வயின் யாமெலாம் செவ்விதில் துன்னில்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l16;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 17, 'தழைப்பதற்கு இடமிலை; சிறார்நீர் பிழைப்பதற்கு')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l17;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 18, 'ஏகுமின், புள்ஆ எருதுஅயத்து ஒருசார்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l18;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 19, 'சிக்கிநீர் சென்மின்!" எனத்தன் சிறுவரைப்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l19;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 20, 'புக்கவிட் டிருக்கும் இப் புல்லின் பரிவும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l20;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 21, 'பொறுமையும் புலனுங் காண்போர், ஒன்றையும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l21;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 22, 'சிறுமையாச் சிந்தனை செயாதுஆங் காங்கு')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l22;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 23, 'தோற்றுபேரழகும் ஆற்றல்சால் அன்பும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l23;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 24, 'போற்றுதம் குறிப்பிற்கு ஏற்றதோர் முயற்சியும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l24;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 25, 'பார்த்துப் பார்த்துத் தம்கண் பனிப்ப,')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l25;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 26, 'ஆர்த்தெழும் அன்பினால் அனைத்தையுங் கலந்துதம்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l26;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 27, 'என்பெலாம் கரைக்குநல் இன்பம் திளைப்பர்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l27;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 28, 'ஓகோ! நாங்கூழ்ப் புழுவே! உன்பாடு')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l28;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 29, 'ஓவாப் பாடே. உணர்வேன்! உணர்வேன்!')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l29;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 30, 'உழைப்போர் உழைப்பில் உழுவோர் தொழின்மிகும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l30;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 31, 'உழுவோர்க் கெல்லாம் விழுமிய வேந்துநீ.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l31;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 32, 'எம்மண் ணாயினும் நன்மண் ணாக்குவை')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l32;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 33, 'விடுத்தனை இதற்கா, எடுத்தஉன் யாக்கை.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l33;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 34, 'உழுதுழுது உண்டுமண் மெழுகினும் நேரிய')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l34;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 35, 'விழுமிய சேறாய் வேதித்து உருட்டி')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l35;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 36, 'வெளிக்கொணர்ந் தும், புகழ் வேண்டார் போல')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l36;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 37, 'ஒளிக்குவை உன்குழி வாயுமோர் உருண்டையால்!')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l37;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 38, 'இப்புற் பயிர்நீ இங்ஙனம் உழாயேல்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l38;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 39, 'எப்படி உண்டாம்? எண்ணாது உனக்கும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l39;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 40, 'குறும்புசெய் எறும்பும் கோடி கோடியாயப்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l40;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 41, 'புழுக்களும் பூச்சியும் பிழைக்குமா றென்னை?')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l41;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 42, 'ஒழுக்கமும் பொறையும் உனைப்போல் யார்க்குள?')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l42;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 43, 'விழுப்புகழ் வேண்டலை. அறிவோம். ஏனிது?')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l43;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 44, 'துதிக்கலம். உன்தொழில் நடத்துதி. ஆ! ஆ!')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l44;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 45, 'எங்கும் இங்ஙனே இணையிலா இன்பும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l45;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 46, 'பங்கமில் அன்பும் தங்குதல் திருந்தக்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l46;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 47, 'காணார் பேணும் வாணாள் என்னே?')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l47;

  RAISE NOTICE 'All 47 poem_lines ready.';

  ----------------------------------------------------------------
  -- 5. Clean slate for morphemes/word_groups on these 47 lines
  ----------------------------------------------------------------

  DELETE FROM morphemes   WHERE poem_line_id IN (v_l1,v_l2,v_l3,v_l4,v_l5,v_l6,v_l7,v_l8,v_l9,v_l10,v_l11,v_l12,v_l13,v_l14,v_l15,v_l16,v_l17,v_l18,v_l19,v_l20,v_l21,v_l22,v_l23,v_l24,v_l25,v_l26,v_l27,v_l28,v_l29,v_l30,v_l31,v_l32,v_l33,v_l34,v_l35,v_l36,v_l37,v_l38,v_l39,v_l40,v_l41,v_l42,v_l43,v_l44,v_l45,v_l46,v_l47);
  DELETE FROM word_groups WHERE poem_line_id IN (v_l1,v_l2,v_l3,v_l4,v_l5,v_l6,v_l7,v_l8,v_l9,v_l10,v_l11,v_l12,v_l13,v_l14,v_l15,v_l16,v_l17,v_l18,v_l19,v_l20,v_l21,v_l22,v_l23,v_l24,v_l25,v_l26,v_l27,v_l28,v_l29,v_l30,v_l31,v_l32,v_l33,v_l34,v_l35,v_l36,v_l37,v_l38,v_l39,v_l40,v_l41,v_l42,v_l43,v_l44,v_l45,v_l46,v_l47);

  ----------------------------------------------------------------
  -- LINE 1: காலையில் கடிநகர் கடந்து நமது
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l1, 1, 'காலைஇல்', 'காலையில் = காலைப் பொழுதில்; in the morning') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l1, 1, 'காலை', 'காலைப் பொழுது; morning', false, v_group_id),
    (v_l1, 2, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''in''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l1, 3, 'கடிநகர்', 'கடிநகர் = காவல் உடைய நகரம் (பாடநூல் பொருள்); the guarded/fortified city') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l1, 3, 'கடி', 'காவல்/பாதுகாப்பு; guarded, protected', false, v_group_id),
    (v_l1, 4, 'நகர்', 'நகரம்; city, town', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l1, 5, 'கடந்து', 'கடந்து சென்று; having crossed (வினையெச்சம்)', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l1, 6, 'நமது', 'நம்முடைய; our', false, NULL);

  ----------------------------------------------------------------
  -- LINE 2: வேலை முடிக்குதும், வேண்டின் விரைவாய்
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l2, 1, 'வேலை', 'வேலை; work, task', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l2, 2, 'முடிக்குதும்,', 'முடிக்குதும் = முடித்துவிடுவோம்; we shall finish') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l2, 2, 'முடி', 'முடித்தல் பகுதி; to finish', false, v_group_id),
    (v_l2, 3, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l2, 4, 'கு', 'எதிர்கால இடைநிலை; future marker', false, v_group_id),
    (v_l2, 5, 'தும்,', 'தன்மைப் பன்மை வினைமுற்று விகுதி; ''we'' ending', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l2, 6, 'வேண்டுஇன்', 'வேண்டின் = விரும்பினால்; if desired/wished') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l2, 6, 'வேண்டு', 'வேண்டுதல் பகுதி; to want, wish', false, v_group_id),
    (v_l2, 7, 'இன்', 'நிபந்தனை இடைநிலை; conditional ''if''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l2, 8, 'விரைவுஆய்', 'விரைவாய் = வேகமாக; quickly') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l2, 8, 'விரைவு', 'வேகம்; speed, haste', false, v_group_id),
    (v_l2, 9, 'ஆய்', 'வினையெச்ச விகுதி; adverbial ''-ly''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 3: இன்று இரா முடுக்கினும் முடியும்
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l3, 1, 'இன்று', 'இன்று; today', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l3, 2, 'இரா', 'இரவு; night', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l3, 3, 'முடுக்குஇன்உம்', 'முடுக்கினும் = விரைவுபடுத்தினாலும்; even if hastened') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l3, 3, 'முடுக்கு', 'விரைவுபடுத்துதல் பகுதி; to hasten', false, v_group_id),
    (v_l3, 4, 'இன்', 'நிபந்தனை இடைநிலை; conditional ''if''', false, v_group_id),
    (v_l3, 5, 'உம்', 'சிறப்பும்மை; ''even/also''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l3, 6, 'முடிஉம்', 'முடியும் = முடிவடையும்; will finish/end') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l3, 6, 'முடி', 'முடிதல் பகுதி; to finish, end', false, v_group_id),
    (v_l3, 7, 'உம்', 'எதிர்கால வினைமுற்று விகுதி; future ''will''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 4: எவ்வினை யோர்க்கும் இம்மையில் தம்மை
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l4, 1, 'எவினைஓர்குஉம்', 'எவ்வினையோர்க்கும் = எந்தத் தொழில் செய்வோர்க்கும்; to those of whatever profession/deed') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l4, 1, 'எ', 'வினா இடைச்சொல்; interrogative ''what/which''', false, v_group_id),
    (v_l4, 2, 'வினை', 'தொழில், செயல்; work, deed, action', false, v_group_id),
    (v_l4, 3, 'ஓர்', 'செய்வோர் எனும் பெயரெச்சப் பகுதி; ''one who does'' (agentive)', false, v_group_id),
    (v_l4, 4, 'கு', 'நான்காம் வேற்றுமை உருபு; dative ''to/for''', false, v_group_id),
    (v_l4, 5, 'உம்', 'சிறப்பும்மை; ''even, whoever''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l4, 6, 'இம்மைஇல்', 'இம்மையில் = இப்பிறவியில்; in this present life/birth') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l4, 6, 'இம்மை', 'இப்பிறவி, இந்த வாழ்க்கை; this present life', false, v_group_id),
    (v_l4, 7, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''in''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l4, 8, 'தம்ஐ', 'தம்மை = தம்மைத் தாமே; themselves') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l4, 8, 'தம்', 'தம்முடைய, தாம்; their own self', false, v_group_id),
    (v_l4, 9, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 5: இயக்குதற்கு இன்பம் பயக்கும்ஓர் இலக்கு
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l5, 1, 'இயக்குதல்கு', 'இயக்குதற்கு = (தம்மைத் தாமே) இயக்கிக் கொள்வதற்கு; in order to drive/direct oneself') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 1, 'இயக்கு', 'இயக்குதல் பகுதி; to operate, drive, set in motion', false, v_group_id),
    (v_l5, 2, 'தல்', 'தொழிற்பெயர் விகுதி; verbal-noun ending', false, v_group_id),
    (v_l5, 3, 'கு', 'நான்காம் வேற்றுமை உருபு; dative ''for''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 4, 'இன்பம்', 'மகிழ்ச்சி; joy, happiness', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l5, 5, 'பயக்குஉம்', 'பயக்கும் = விளைவிக்கும்; that yields/produces') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 5, 'பயக்கு', 'பயத்தல் பகுதி; to yield, produce', false, v_group_id),
    (v_l5, 6, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 7, 'ஓர்', 'ஒரு; a, one', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 8, 'இலக்கு', 'குறிக்கோள்; goal, target', false, NULL);

  ----------------------------------------------------------------
  -- LINE 6: வேண்டும்; உயிர்க்கு அது தூண்டுகோல் போலாம்.
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l6, 1, 'வேண்டுஉம்', 'வேண்டும் = தேவை; is needed') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l6, 1, 'வேண்டு', 'வேண்டுதல் பகுதி; to be needed', false, v_group_id),
    (v_l6, 2, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l6, 3, 'உயிர்க்கு', 'உயிர்க்கு = உயிருக்கு, ஆன்மாவுக்கு; for the soul/life') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l6, 3, 'உயிர்', 'ஆன்மா, உயிரி; life, soul, living being', false, v_group_id),
    (v_l6, 4, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l6, 5, 'கு', 'நான்காம் வேற்றுமை உருபு; dative ''for''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l6, 6, 'அது', 'அது; that (thing)', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l6, 7, 'தூண்டுகோல்', 'தூண்டுகோல் = தூண்டுதற்குரிய கோல்; a goading stick/prod') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l6, 7, 'தூண்டு', 'தூண்டுதல் பகுதி; to goad, prod', false, v_group_id),
    (v_l6, 8, 'கோல்', 'கம்பு; stick, rod', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l6, 9, 'போல்ஆம்.', 'போலாம் = போன்றது ஆகும்; is like/similar to') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l6, 9, 'போல்', 'ஒப்புமை இடைச்சொல்; like, similar to', false, v_group_id),
    (v_l6, 10, 'ஆம்.', 'ஆகும்; is, becomes', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 7: ஈண்டு எப்பொருள்தான் இலக்கற்று இருப்பது
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l7, 1, 'ஈண்டு', 'இங்கு, இப்பொழுது; here, in this world', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l7, 2, 'எபொருள்தான்', 'எப்பொருள்தான் = என்ன பயன்தான்; what purpose indeed') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l7, 2, 'எ', 'வினா இடைச்சொல்; interrogative ''what''', false, v_group_id),
    (v_l7, 3, 'பொருள்', 'பயன், நோக்கம்; purpose, meaning', false, v_group_id),
    (v_l7, 4, 'தான்', 'சிறப்பு இடைச்சொல் (அழுத்தம்); emphatic ''indeed''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l7, 5, 'இலக்குஅற்று', 'இலக்கற்று = குறிக்கோள் இன்றி; without a goal') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l7, 5, 'இலக்கு', 'குறிக்கோள்; target, goal', false, v_group_id),
    (v_l7, 6, 'அற்று', 'இன்றி; without', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l7, 7, 'இருப்ப்அது', 'இருப்பது = இருத்தல்; being, existing') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l7, 7, 'இரு', 'இருத்தல் பகுதி; to exist, be', false, v_group_id),
    (v_l7, 8, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l7, 9, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l7, 10, 'அது', 'தொழிற்பெயர் விகுதி; ''-ness/being''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 8: இதோ ஒ! இக்கரை முளைத்தஇச் சிறுபுல்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l8, 1, 'இதுஓ', 'இதோ ஓ = இதோ, ஓ!; here, oh!') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 1, 'இது', 'இது; this', false, v_group_id),
    (v_l8, 2, 'ஓ', 'வியப்புக்குறிப்பு இடைச்சொல்; exclamatory ''oh!''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 3, 'ஓ', 'வியப்புக்குறிப்பு இடைச்சொல் (மீண்டும்); exclamatory ''oh!'' (repeated)', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l8, 4, 'இகரை', 'இக்கரை = இந்தக் கரையோரம்; this bank/edge') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 4, 'இ', 'சுட்டு இடைச்சொல்; demonstrative ''this''', false, v_group_id),
    (v_l8, 5, 'கரை', 'கரையோரம்; bank, edge (of field/pond)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l8, 6, 'முளைத்த்அ', 'முளைத்த = முளைவிட்ட; sprouted') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 6, 'முளை', 'முளைத்தல் பகுதி; to sprout', false, v_group_id),
    (v_l8, 7, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l8, 8, 'த்', 'இறந்தகால இடைநிலை; past tense marker', false, v_group_id),
    (v_l8, 9, 'அ', 'பெயரெச்ச விகுதி; adjectival participle ending', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l8, 10, 'இசிறுமைபுல்', 'இச்சிறுபுல் = இந்தச் சிறிய புல்; this small/tender grass') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 10, 'இ', 'சுட்டு இடைச்சொல்; demonstrative ''this''', false, v_group_id),
    (v_l8, 11, 'சிறுமை', 'சிறிய தன்மை; smallness', false, v_group_id),
    (v_l8, 12, 'புல்', 'புல்; grass', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 9: சதாதன் குறிப்பொடு சாருதல் காண்டி;
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 1, 'சதா', 'எப்பொழுதும், நிலையான; always, constant', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 2, 'தன்', 'தன்னுடைய; its own', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l9, 3, 'குறிப்புஒடு', 'குறிப்பொடு = இயல்போடு; along with its nature/mark') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 3, 'குறிப்பு', 'இயல்பு, அடையாளம்; nature, characteristic, mark', false, v_group_id),
    (v_l9, 4, 'ஒடு', 'உடன் வேற்றுமை உருபு; comitative ''with''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l9, 5, 'சாருதல்', 'சாருதல் = சேர்தல்; joining, drawing near') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 5, 'சாரு', 'சேர்தல் பகுதி; to join, approach', false, v_group_id),
    (v_l9, 6, 'தல்', 'தொழிற்பெயர் விகுதி; verbal-noun ending', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 7, 'காண்டி', 'காண்பாய் எனும் முன்னிலை ஏவல் வினைமுற்று; ''you shall behold'' (imperative)', false, NULL);

  ----------------------------------------------------------------
  -- LINE 10: அதன்சிறு பூக்குலை அடியொன்று உயர்த்தி
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l10, 1, 'அதுஅன்', 'அதன் = அதனுடைய; its') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 1, 'அது', 'அது; that', false, v_group_id),
    (v_l10, 2, 'அன்', 'சாரியை; possessive/genitive glide ''of''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l10, 3, 'சிறுபூகுலை', 'சிறுபூக்குலை = சிறிய பூக்களின் கொத்து; the small flower-cluster') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 3, 'சிறு', 'சிறிய; small', false, v_group_id),
    (v_l10, 4, 'பூ', 'பூக்கள்; flower', false, v_group_id),
    (v_l10, 5, 'குலை', 'கொத்து; cluster, bunch', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l10, 6, 'அடிஒன்று', 'அடியொன்று = ஒரு தண்டு/அடிப்பாகம்; one stalk/base') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 6, 'அடி', 'அடிப்பாகம், தண்டு; base, stalk', false, v_group_id),
    (v_l10, 7, 'ஒன்று', 'ஒரு; one', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l10, 8, 'உயர்த்த்இ', 'உயர்த்தி = உயர்த்திக்கொண்டு; having raised') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 8, 'உயர்', 'உயர்தல் பகுதி; to rise, raise', false, v_group_id),
    (v_l10, 9, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l10, 10, 'த்', 'இறந்தகால இடைநிலை; past tense marker', false, v_group_id),
    (v_l10, 11, 'இ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 11: இதமுறத் தேன்துளி தாங்கி ஈக்களை
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l11, 1, 'இதம்உறதேன்துளி', 'இதமுறத் தேன்துளி = இன்பம் தரும் தேன் துளி; a pleasant drop of honey') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l11, 1, 'இதம்', 'இன்பம், நலம்; pleasantness', false, v_group_id),
    (v_l11, 2, 'உற', 'அடையும்படி; so as to attain (adverbial)', false, v_group_id),
    (v_l11, 3, 'தேன்', 'தேன்; honey', false, v_group_id),
    (v_l11, 4, 'துளி', 'துளி; drop', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l11, 5, 'தாங்குஇஈகள்ஐ', 'தாங்கி ஈக்களை = ஈக்களைத் தாங்கிக்கொண்டு; bearing/holding the flies') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l11, 5, 'தாங்கு', 'தாங்குதல் பகுதி; to bear, hold', false, v_group_id),
    (v_l11, 6, 'இ', 'வினையெச்ச விகுதி; ''-ing''', false, v_group_id),
    (v_l11, 7, 'ஈ', 'ஈ; fly', false, v_group_id),
    (v_l11, 8, 'கள்', 'பன்மை விகுதி; plural marker', false, v_group_id),
    (v_l11, 9, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 12: நலமுற அழைத்து நல்லூண் அருத்திப்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l12, 1, 'நலம்உற', 'நலமுற = நன்மை அடையும்படி; kindly, for their welfare') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l12, 1, 'நலம்', 'நன்மை; welfare, goodness', false, v_group_id),
    (v_l12, 2, 'உற', 'அடையும்படி; so as to attain (adverbial)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l12, 3, 'அழைத்த்உ', 'அழைத்து = அழைத்துக்கொண்டு; having called/invited') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l12, 3, 'அழை', 'அழைத்தல் பகுதி; to call, invite', false, v_group_id),
    (v_l12, 4, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l12, 5, 'த்', 'இறந்தகால இடைநிலை; past tense marker', false, v_group_id),
    (v_l12, 6, 'உ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l12, 7, 'நன்மைஊண்', 'நல்லூண் = நல்ல உணவு; good food, feast') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l12, 7, 'நன்மை', 'நல்ல; good', false, v_group_id),
    (v_l12, 8, 'ஊண்', 'உணவு; food, feast', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l12, 9, 'அருத்துஇ', 'அருத்தி = ஊட்டி; having fed') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l12, 9, 'அருத்து', 'ஊட்டுதல் பகுதி; to feed', false, v_group_id),
    (v_l12, 10, 'இ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 13: பலமுறத் தனதுபூம் பராகம் பரப்பித்து
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l13, 1, 'பலம்உறதன்அது', 'பலமுறத் தனது = பயன் மிகுதியாகத் தன்னுடைய; abundantly, its own') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l13, 1, 'பலம்', 'பயன், வலிமை; benefit, strength', false, v_group_id),
    (v_l13, 2, 'உற', 'அடையும்படி; so as to attain (adverbial)', false, v_group_id),
    (v_l13, 3, 'தன்', 'தன்னுடைய; its own', false, v_group_id),
    (v_l13, 4, 'அது', 'உடைமை இடைநிலை; possessive ''its''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l13, 5, 'பூம்பராகம்', 'பூவிலுள்ள மகரந்தம்; flower''s pollen', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l13, 6, 'பரப்பித்த்உ', 'பரப்பித்து = பரப்பிக்கொண்டு; having spread') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l13, 6, 'பரப்பி', 'பரப்புதல் பகுதி; to spread', false, v_group_id),
    (v_l13, 7, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l13, 8, 'த்', 'இறந்தகால இடைநிலை; past tense marker', false, v_group_id),
    (v_l13, 9, 'உ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 14: ஆசுஇலாச் சிறுகாய் ஆக்கி, இதோ! என்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l14, 1, 'ஆசுஇலாசிறுகாய்', 'ஆசுஇலாச் சிறுகாய் = குற்றம் இல்லாத (பாடநூல்) சிறிய காய்; the blemishless small fruit') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l14, 1, 'ஆசு', 'குற்றம்; blemish, fault', false, v_group_id),
    (v_l14, 2, 'இலா', 'இல்லாத; without', false, v_group_id),
    (v_l14, 3, 'சிறு', 'சிறிய; small', false, v_group_id),
    (v_l14, 4, 'காய்', 'காய்; fruit', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l14, 5, 'ஆக்குஇ', 'ஆக்கி = உண்டாக்கிக்கொண்டு; having made/produced') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l14, 5, 'ஆக்கு', 'உண்டாக்குதல் பகுதி; to make, produce', false, v_group_id),
    (v_l14, 6, 'இ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l14, 7, 'இதுஓ', 'இதோ = இதோ!; here!') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l14, 7, 'இது', 'இது; this', false, v_group_id),
    (v_l14, 8, 'ஓ', 'வியப்புக்குறிப்பு இடைச்சொல்; exclamatory ''oh''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l14, 9, 'என்', 'எனது; my', false, NULL);

  ----------------------------------------------------------------
  -- LINE 15: தூசிடைச் சிக்கும் தோட்டியும் கொடுத்தே
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l15, 1, 'தூசுஉடைசிக்குஉம்', 'தூசிடைச் சிக்கும் = புழுதியில் சிக்கும்; that gets caught amid the dust') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 1, 'தூசு', 'புழுதி; dust', false, v_group_id),
    (v_l15, 2, 'உடை', 'உள்ள; having', false, v_group_id),
    (v_l15, 3, 'சிக்கு', 'சிக்கிக்கொள்ளுதல் பகுதி; to get caught, entangled', false, v_group_id),
    (v_l15, 4, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l15, 5, 'தோட்டிஉம்', 'தோட்டியும் = துறட்டியும் (பாடநூல்: முள்கோல்); the hook/goad too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 5, 'தோட்டி', 'துறட்டி/முள்கோல்; hook, goad', false, v_group_id),
    (v_l15, 6, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l15, 7, 'கொடுத்த்ஏ', 'கொடுத்தே = கொடுத்தே; having given indeed') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 7, 'கொடு', 'கொடுத்தல் பகுதி; to give', false, v_group_id),
    (v_l15, 8, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l15, 9, 'த்', 'இறந்தகால இடைநிலை; past tense marker', false, v_group_id),
    (v_l15, 10, 'ஏ', 'வினையெச்ச விகுதி (அழுத்தம்); ''-having done, indeed''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 16: "இவ்வயின் யாமெலாம் செவ்விதில் துன்னில்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l16, 1, 'இவயின்', 'இவ்வயின் = இந்த இடத்தில்; in this place') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 1, 'இ', 'சுட்டு இடைச்சொல்; demonstrative ''this''', false, v_group_id),
    (v_l16, 2, 'வயின்', 'இடம்; place, spot', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l16, 3, 'யாம்எலாம்', 'யாமெலாம் = நாங்கள் அனைவரும்; all of us') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 3, 'யாம்', 'நாங்கள்; we', false, v_group_id),
    (v_l16, 4, 'எலாம்', 'எல்லாம்; all', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l16, 5, 'செவ்விஇதுஇல்', 'செவ்விதில் = ஏற்ற தருணத்தில்; at the opportune/right time') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 5, 'செவ்வி', 'ஏற்ற தருணம்; the right, opportune time', false, v_group_id),
    (v_l16, 6, 'இது', 'சுட்டு; this', false, v_group_id),
    (v_l16, 7, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''in''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l16, 8, 'துன்இல்', 'துன்னில் = நெருங்கினால்; if we draw near/approach') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 8, 'துன்', 'நெருங்குதல் பகுதி; to approach, draw near', false, v_group_id),
    (v_l16, 9, 'இல்', 'நிபந்தனை இடைநிலை; conditional ''if''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 17: தழைப்பதற்கு இடமிலை; சிறார்நீர் பிழைப்பதற்கு
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l17, 1, 'தழைப்ப்அதுஅல்கு', 'தழைப்பதற்கு = தழைத்து வளர்வதற்கு; in order to flourish/thrive') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 1, 'தழை', 'தழைத்தல் பகுதி; to flourish, thrive', false, v_group_id),
    (v_l17, 2, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l17, 3, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l17, 4, 'அது', 'தொழிற்பெயர் விகுதி; verbal-noun ''-ing''', false, v_group_id),
    (v_l17, 5, 'அல்', 'எதிர்மறை/உருபு இடைநிலை; glide', false, v_group_id),
    (v_l17, 6, 'கு', 'நான்காம் வேற்றுமை உருபு; dative infinitive ''in order to''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l17, 7, 'இடம்இலை', 'இடமிலை = இடம் இல்லை; there is no room/space') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 7, 'இடம்', 'இடம், வெளி; space, place', false, v_group_id),
    (v_l17, 8, 'இலை', 'இல்லை; not present, absent', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l17, 9, 'சிறுமைஆர்', 'சிறார் = சிறுவர்கள்; the young ones, children') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 9, 'சிறுமை', 'சிறிய தன்மை; smallness (root for ''young ones'')', false, v_group_id),
    (v_l17, 10, 'ஆர்', 'பலர்பால் விகுதி; plural person suffix', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 11, 'நீர்', 'நீங்கள் (முன்னிலைப் பன்மை பழந்தமிழ் வடிவம்); you (archaic plural/respectful)', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l17, 12, 'பிழைப்ப்அதற்கு', 'பிழைப்பதற்கு = பிழைத்து வாழ்வதற்கு; in order to survive') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 12, 'பிழை', 'பிழைத்தல் பகுதி; to survive, escape', false, v_group_id),
    (v_l17, 13, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l17, 14, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l17, 15, 'அதற்கு', 'நான்காம் வேற்றுமை உருபு; dative infinitive ''in order to''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 18: ஏகுமின், புள்ஆ எருதுஅயத்து ஒருசார்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l18, 1, 'ஏகுமின்', 'ஏகுமின் = செல்லுங்கள்; go (ye)!') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 1, 'ஏகு', 'செல்லுதல் பகுதி; to go', false, v_group_id),
    (v_l18, 2, 'மின்', 'ஏவல் பன்மை விகுதி; imperative plural ''-go ye''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 3, 'புள்', 'பறவை; bird', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 4, 'ஆ', 'பசு, மாடு; cow, cattle', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 5, 'எருது', 'காளை; bull, ox', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l18, 6, 'அயம்அத்து', 'அயத்து = கால்நடைகள் (ஆடு, குதிரை - பாடநூல் பொருள்) இருக்குமிடத்தில்; where the livestock (goats, horses) are') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 6, 'அயம்', 'ஆடு, குதிரை (கால்நடைகள்) - பாடநூல் பொருள்; goat, horse (livestock)', false, v_group_id),
    (v_l18, 7, 'அத்து', 'ஏழாம் வேற்றுமை இடைநிலை; oblique/locative glide', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 8, 'ஒரு', 'ஒரு; one', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 9, 'சார்', 'பக்கம், திசை; side, direction', false, NULL);

  ----------------------------------------------------------------
  -- LINE 19: சிக்கிநீர் சென்மின்!" எனத்தன் சிறுவரைப்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l19, 1, 'சிக்குஇ', 'சிக்கி = சிக்கிக்கொண்டு; having got entangled') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l19, 1, 'சிக்கு', 'சிக்கிக்கொள்ளுதல் பகுதி; to get entangled', false, v_group_id),
    (v_l19, 2, 'இ', 'வினையெச்ச விகுதி; ''-ing''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l19, 3, 'நீர்', 'நீங்கள்; you (plural, archaic)', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l19, 4, 'செல்மின்', 'சென்மின் = செல்லுங்கள்; go!') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l19, 4, 'செல்', 'செல்தல் பகுதி; to go', false, v_group_id),
    (v_l19, 5, 'மின்', 'ஏவல் பன்மை விகுதி; imperative plural', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l19, 6, 'எனத்தன்', 'எனத்தன் = என்று தன்னுடைய; saying so, his own') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l19, 6, 'என', 'எனக்கூறி; saying', false, v_group_id),
    (v_l19, 7, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l19, 8, 'தன்', 'தன்னுடைய; his own', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l19, 9, 'சிறுமைஅர்ஐப்', 'சிறுவரை = சிறுவர்களை; the little/young ones (acc.)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l19, 9, 'சிறுமை', 'சிறிய தன்மை; smallness (root for ''young ones'')', false, v_group_id),
    (v_l19, 10, 'அர்', 'பலர்பால் விகுதி; plural suffix', false, v_group_id),
    (v_l19, 11, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id),
    (v_l19, 12, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 20: புக்கவிட் டிருக்கும் இப் புல்லின் பரிவும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l20, 1, 'புக்குஅவிட்டுஇருக்க்உம்', 'புக்கவிட்டிருக்கும் = போகவிட்டிருக்கும் (பாடநூல்: புக்க விட்டு - போகவிட்டு); that has been allowed to wander in') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l20, 1, 'புக்கு', 'புகுதல் பகுதி; to enter', false, v_group_id),
    (v_l20, 2, 'அ', 'பெயரெச்ச விகுதி; adjectival ending', false, v_group_id),
    (v_l20, 3, 'விட்டு', 'விட்டு (போகவிட்டு - பாடநூல் பொருள்); let go, allowed to go', false, v_group_id),
    (v_l20, 4, 'இரு', 'இருத்தல் பகுதி; to be, remain', false, v_group_id),
    (v_l20, 5, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l20, 6, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l20, 7, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l20, 8, 'இபுல்இன்', 'இப்புல்லின் = இந்தப் புல்லினுடைய; of this grass') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l20, 8, 'இ', 'சுட்டு இடைச்சொல்; demonstrative ''this''', false, v_group_id),
    (v_l20, 9, 'புல்', 'புல்; grass', false, v_group_id),
    (v_l20, 10, 'இன்', 'ஆறாம் வேற்றுமை உருபு; genitive ''of''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l20, 11, 'பரிவுஉம்', 'பரிவும் = கருணையும்; the tenderness/compassion too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l20, 11, 'பரிவு', 'கருணை, அன்பு; compassion, tenderness', false, v_group_id),
    (v_l20, 12, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 21: பொறுமையும் புலனுங் காண்போர், ஒன்றையும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l21, 1, 'பொறுமைஉம்', 'பொறுமையும் = பொறுமையும் (கொண்டு); patience too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 1, 'பொறுமை', 'பொறுமை; patience', false, v_group_id),
    (v_l21, 2, 'உம்', 'உம்மைத் தொகை; ''and, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l21, 3, 'புலன்உம்', 'புலனும் = அறிவும் (கொண்டு); the faculty/sense too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 3, 'புலன்', 'அறிவு, உணர்வு; sense, faculty of perception', false, v_group_id),
    (v_l21, 4, 'உம்', 'உம்மைத் தொகை; ''and, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l21, 5, 'காண்ப்ஓர்', 'காண்போர் = காண்பவர்கள்; those who see/observe') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 5, 'காண்', 'காணுதல் பகுதி; to see', false, v_group_id),
    (v_l21, 6, 'ப்', 'பெயரெச்ச இடைநிலை; adjectival glide', false, v_group_id),
    (v_l21, 7, 'ஓர்', 'செய்வோர் பெயர்ச்சொல் விகுதி; agentive ''those who''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l21, 8, 'ஒன்றுஐஉம்', 'ஒன்றையும் = ஒரு பொருளையும் கூட; even a single thing') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 8, 'ஒன்று', 'ஒரு பொருள்; a thing, anything', false, v_group_id),
    (v_l21, 9, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id),
    (v_l21, 10, 'உம்', 'சிறப்பும்மை; ''even''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 22: சிறுமையாச் சிந்தனை செயாதுஆங் காங்கு
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l22, 1, 'சிறுமைஆச்சிந்தனை', 'சிறுமையாச் சிந்தனை = சிறுமையான எண்ணம்; a trivial/petty thought') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l22, 1, 'சிறுமை', 'சிறுமை, சிறியது; smallness, pettiness', false, v_group_id),
    (v_l22, 2, 'ஆ', 'ஆக; as, in the manner of', false, v_group_id),
    (v_l22, 3, 'ச்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l22, 4, 'சிந்தனை', 'எண்ணம்; thought', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l22, 5, 'செய்ஆதுஆங்குஆங்கு', 'செயாதுஆங்காங்கு = எங்கும் அவ்வாறு செய்யாமல்; without doing so anywhere') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l22, 5, 'செய்', 'செய்தல் பகுதி; to do', false, v_group_id),
    (v_l22, 6, 'ஆது', 'எதிர்மறை வினையெச்ச விகுதி; ''without doing'' (negative)', false, v_group_id),
    (v_l22, 7, 'ஆங்கு', 'அங்கு; there', false, v_group_id),
    (v_l22, 8, 'ஆங்கு', 'அங்கு (மீண்டும் - ஆங்காங்கு); there (repeated = ''here and there'')', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 23: தோற்றுபேரழகும் ஆற்றல்சால் அன்பும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l23, 1, 'தோற்றுபெருமைஅழகுஉம்', 'தோற்றுபேரழகும் = வெளிப்படும் பேரழகும்; the manifest great beauty too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l23, 1, 'தோற்று', 'தோன்றி, வெளிப்படுத்தி; displaying, appearing', false, v_group_id),
    (v_l23, 2, 'பெருமை', 'பெருமை; greatness', false, v_group_id),
    (v_l23, 3, 'அழகு', 'அழகு; beauty', false, v_group_id),
    (v_l23, 4, 'உம்', 'உம்மைத் தொகை; ''and, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l23, 5, 'ஆற்றல்சால்', 'ஆற்றல்சால் = வலிமை நிறைந்த; abounding in strength') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l23, 5, 'ஆற்றல்', 'வலிமை, திறன்; strength, capability', false, v_group_id),
    (v_l23, 6, 'சால்', 'நிறைந்த; abounding in, full of', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l23, 7, 'அன்புஉம்', 'அன்பும் = அன்பும் (கொண்ட); love too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l23, 7, 'அன்பு', 'அன்பு; love', false, v_group_id),
    (v_l23, 8, 'உம்', 'உம்மைத் தொகை; ''and, too''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 24: போற்றுதம் குறிப்பிற்கு ஏற்றதோர் முயற்சியும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l24, 1, 'போற்றுதம்', 'போற்றுதம் = தமது போற்றத்தக்க; their own cherished') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l24, 1, 'போற்று', 'போற்றுதல் பகுதி; to cherish, nurture', false, v_group_id),
    (v_l24, 2, 'தம்', 'தம்முடைய; their own', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l24, 3, 'குறிப்புஇல்கு', 'குறிப்பிற்கு = நோக்கத்திற்கு; for the purpose/intention') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l24, 3, 'குறிப்பு', 'நோக்கம்; purpose, intention', false, v_group_id),
    (v_l24, 4, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative glide', false, v_group_id),
    (v_l24, 5, 'கு', 'நான்காம் வேற்றுமை உருபு; dative ''for''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l24, 6, 'ஏற்றுஅதுஓர்முயற்சிஉம்', 'ஏற்றதோர் முயற்சியும் = ஏற்ற ஒரு முயற்சியும்; and a suitable effort') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l24, 6, 'ஏற்று', 'ஏற்ற; suitable, fitting', false, v_group_id),
    (v_l24, 7, 'அது', 'அது; that', false, v_group_id),
    (v_l24, 8, 'ஓர்', 'ஒரு; a', false, v_group_id),
    (v_l24, 9, 'முயற்சி', 'முயற்சி; effort, endeavour', false, v_group_id),
    (v_l24, 10, 'உம்', 'உம்மைத் தொகை; ''and, too''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 25: பார்த்துப் பார்த்துத் தம்கண் பனிப்ப,
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l25, 1, 'பார்த்த்உப்பார்த்த்உத்தம்', 'பார்த்துப் பார்த்துத் தம் = திரும்பத் திரும்பப் பார்த்து, தம்முடைய; looking again and again, their own (அடுக்குத் தொடர் - reduplication, per பாடநூல்)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l25, 1, 'பார்', 'பார்த்தல் பகுதி; to look', false, v_group_id),
    (v_l25, 2, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l25, 3, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l25, 4, 'உ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id),
    (v_l25, 5, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l25, 6, 'பார்', 'பார்த்தல் பகுதி (மீண்டும்); to look (repeated)', false, v_group_id),
    (v_l25, 7, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l25, 8, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l25, 9, 'உ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id),
    (v_l25, 10, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l25, 11, 'தம்', 'தம்முடைய; their own', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l25, 12, 'கண்', 'கண்; eye', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l25, 13, 'பனிப்ப்அ', 'பனிப்ப = கண்ணீர் சொரிய; welling up with tears') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l25, 13, 'பனி', 'கண்ணீர் சொரிதல் பகுதி; to well up with tears', false, v_group_id),
    (v_l25, 14, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l25, 15, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l25, 16, 'அ', 'பெயரெச்ச/வினையெச்ச விகுதி; adjectival ending', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 26: ஆர்த்தெழும் அன்பினால் அனைத்தையுங் கலந்துதம்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l26, 1, 'ஆர்த்த்உஎழுஉம்', 'ஆர்த்தெழும் = நிறைந்து எழும்; that wells up and rises') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l26, 1, 'ஆர்', 'நிறைதல் பகுதி; to fill, well up (also: to resound)', false, v_group_id),
    (v_l26, 2, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l26, 3, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l26, 4, 'உ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id),
    (v_l26, 5, 'எழு', 'எழுதல் பகுதி; to rise', false, v_group_id),
    (v_l26, 6, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l26, 7, 'அன்புஇன்ஆல்', 'அன்பினால் = அன்பின் மூலம்; through/by love') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l26, 7, 'அன்பு', 'அன்பு; love', false, v_group_id),
    (v_l26, 8, 'இன்', 'ஐந்தாம் வேற்றுமை இடைநிலை; instrumental glide', false, v_group_id),
    (v_l26, 9, 'ஆல்', 'மூன்றாம் வேற்றுமை உருபு; instrumental ''by''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l26, 10, 'அனைத்துஐஉம்', 'அனைத்தையும் = எல்லாவற்றையும்; everything') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l26, 10, 'அனைத்து', 'எல்லாம்; everything, all', false, v_group_id),
    (v_l26, 11, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id),
    (v_l26, 12, 'உம்', 'சிறப்பும்மை; ''even, also''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l26, 13, 'கலத்(ந்)த்உ', 'கலந்து = கலந்துகொண்டு; having blended/mingled') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l26, 13, 'கல', 'கலத்தல் பகுதி; to mingle, blend', false, v_group_id),
    (v_l26, 14, 'த்(ந்)', 'சந்தி எழுத்து (ந்); glide variant', false, v_group_id),
    (v_l26, 15, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l26, 16, 'உ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l26, 17, 'தம்', 'தம்முடைய; their own', false, NULL);

  ----------------------------------------------------------------
  -- LINE 27: என்பெலாம் கரைக்குநல் இன்பம் திளைப்பர்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l27, 1, 'என்புஎலாம்', 'என்பெலாம் = எலும்பு அனைத்தும்; all their bones') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l27, 1, 'என்பு', 'எலும்பு; bone', false, v_group_id),
    (v_l27, 2, 'எலாம்', 'எல்லாம்; all', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l27, 3, 'கரைக்க்உநல்', 'கரைக்குநல் = கரைந்துபோகும்படியான நல்ல; melting, good') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l27, 3, 'கரை', 'கரைதல் பகுதி; to melt, dissolve', false, v_group_id),
    (v_l27, 4, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l27, 5, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l27, 6, 'உ', 'வினையெச்ச விகுதி; ''-ing''', false, v_group_id),
    (v_l27, 7, 'நல்', 'நல்ல; good', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l27, 8, 'இன்பம்', 'மகிழ்ச்சி; joy', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l27, 9, 'திளைப்ப்அர்', 'திளைப்பர் = திளைத்திடுவர்; they will revel/immerse (in it)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l27, 9, 'திளை', 'திளைத்தல் பகுதி; to revel, immerse oneself', false, v_group_id),
    (v_l27, 10, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l27, 11, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l27, 12, 'அர்', 'படர்க்கைப் பன்மை வினைமுற்று விகுதி; 3rd person plural ending', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 28: ஓகோ! நாங்கூழ்ப் புழுவே! உன்பாடு
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l28, 1, 'ஓக்ஓ', 'ஓகோ = ஓகோ!; Oh ho! (exclamation of wonder)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l28, 1, 'ஓ', 'வியப்புக்குறிப்பு; exclamation ''Oh!''', false, v_group_id),
    (v_l28, 2, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l28, 3, 'ஓ', 'வியப்புக்குறிப்பு (மீண்டும்); exclamation ''Oh!'' (repeated) - together ''ஓகோ''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l28, 4, 'நாங்கூழ்புழுஏ', 'நாங்கூழ்ப்புழுவே = மண்புழுவே (பாடநூல் பொருள்); O caterpillar/earthworm!') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l28, 4, 'நாங்கூழ்புழு', 'மண்புழு (பாடநூல் பொருள்); caterpillar, earthworm', false, v_group_id),
    (v_l28, 5, 'ஏ', 'விளி இடைநிலை; vocative ''O''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l28, 6, 'உன்பாடு', 'உன்பாடு = உனது உழைப்பு (பாடநூல் பொருள்: பாடு-உழைப்பு); your toil') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l28, 6, 'உன்', 'உன்னுடைய; your', false, v_group_id),
    (v_l28, 7, 'பாடு', 'உழைப்பு (பாடநூல் பொருள்); toil, labour', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 29: ஓவாப் பாடே. உணர்வேன்! உணர்வேன்!
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l29, 1, 'ஓவாபாடுஏ', 'ஓவாப்பாடே = ஓயாத உழைப்பே (பாடநூல் பொருள்: ஓவா-ஓயாத); unceasing toil indeed') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l29, 1, 'ஓவா', 'ஓயாத (பாடநூல் பொருள்); never-ceasing, unending', false, v_group_id),
    (v_l29, 2, 'பாடு', 'உழைப்பு; toil', false, v_group_id),
    (v_l29, 3, 'ஏ', 'அழுத்தச் சொல்; emphatic particle', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l29, 4, 'உணர்வ்ஏன்', 'உணர்வேன் = நான் உணர்வேன்; I shall realise/feel (it)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l29, 4, 'உணர்', 'உணர்தல் பகுதி; to realise, perceive', false, v_group_id),
    (v_l29, 5, 'வ்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l29, 6, 'ஏன்', 'தன்மை ஒருமை எதிர்கால வினைமுற்று; 1st person future ''I shall''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l29, 7, 'உணர்வ்ஏன்', 'உணர்வேன் = நான் உணர்வேன் (மீண்டும் - அழுத்தம்); I shall realise (repeated for emphasis)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l29, 7, 'உணர்', 'உணர்தல் பகுதி; to realise, perceive', false, v_group_id),
    (v_l29, 8, 'வ்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l29, 9, 'ஏன்', 'தன்மை ஒருமை எதிர்கால வினைமுற்று; 1st person future ''I shall''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 30: உழைப்போர் உழைப்பில் உழுவோர் தொழின்மிகும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l30, 1, 'உழைப்ப்ஓர்', 'உழைப்போர் = உழைப்பவர்கள்; those who labour') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l30, 1, 'உழை', 'உழைத்தல் பகுதி; to labour, toil', false, v_group_id),
    (v_l30, 2, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l30, 3, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l30, 4, 'ஓர்', 'செய்வோர் பெயர்ச்சொல் விகுதி; agentive ''those who''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l30, 5, 'உழைப்புஇல்', 'உழைப்பில் = உழைப்பினுள்; in [their] labour') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l30, 5, 'உழைப்பு', 'உழைப்பு; labour, toil', false, v_group_id),
    (v_l30, 6, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''in''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l30, 7, 'உழுவ்ஓர்', 'உழுவோர் = உழுபவர்கள்; those who plough') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l30, 7, 'உழு', 'உழுதல் பகுதி; to plough', false, v_group_id),
    (v_l30, 8, 'வ்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l30, 9, 'ஓர்', 'செய்வோர் பெயர்ச்சொல் விகுதி; agentive ''those who''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l30, 10, 'தொழில்மிகுஉம்', 'தொழின்மிகும் = தொழிலில் மிகுவர்; will excel in [their] occupation') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l30, 10, 'தொழில்', 'தொழில், வேலை; occupation, craft', false, v_group_id),
    (v_l30, 11, 'மிகு', 'மிகுதல் பகுதி; to abound, excel', false, v_group_id),
    (v_l30, 12, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 31: உழுவோர்க் கெல்லாம் விழுமிய வேந்துநீ.
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l31, 1, 'உழுவ்ஓர்க்குஎல்லாம்விழுமைஇய', 'உழுவோர்க்கெல்லாம் விழுமிய = உழுபவர்கள் அனைவருக்கும் மேலான; noble/excellent to all who plough') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l31, 1, 'உழு', 'உழுதல் பகுதி; to plough', false, v_group_id),
    (v_l31, 2, 'வ்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l31, 3, 'ஓர்', 'செய்வோர் பெயர்ச்சொல் விகுதி; agentive ''those who''', false, v_group_id),
    (v_l31, 4, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l31, 5, 'கு', 'நான்காம் வேற்றுமை உருபு; dative ''to''', false, v_group_id),
    (v_l31, 6, 'எல்லாம்', 'எல்லாம்; all', false, v_group_id),
    (v_l31, 7, 'விழுமை', 'மேன்மை, உயர்வு; excellence, nobility', false, v_group_id),
    (v_l31, 8, 'இய', 'பண்புப் பெயரெச்ச விகுதி; adjectival ''-ous''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l31, 9, 'வேந்துநீ', 'வேந்துநீ = நீயே அரசன்; you are the king') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l31, 9, 'வேந்து', 'அரசன்; king', false, v_group_id),
    (v_l31, 10, 'நீ', 'நீ; you', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 32: எம்மண் ணாயினும் நன்மண் ணாக்குவை
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l32, 1, 'எமண்ஆய்இன்உம்', 'எம்மணணாயினும் = எம்மண்ணாக இருப்பினும் (எந்த மண்ணானாலும்); whatever the soil may be') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l32, 1, 'எ', 'எ; what, whichever', false, v_group_id),
    (v_l32, 2, 'மண்', 'மண்; soil, earth', false, v_group_id),
    (v_l32, 3, 'ஆய்', 'ஆய்/இன்/உம் இணைந்த நிபந்தனை; ''even if it be'' (adverbial conditional)', false, v_group_id),
    (v_l32, 4, 'இன்', 'நிபந்தனை இடைநிலை; conditional glide', false, v_group_id),
    (v_l32, 5, 'உம்', 'சிறப்பும்மை; ''even''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l32, 6, 'நன்மைமண்ஆக்குவை', 'நன்மணணாக்குவை = நல்ல மண்ணாக ஆக்குவாய்; you make [it] good soil') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l32, 6, 'நன்மை', 'நல்ல; good', false, v_group_id),
    (v_l32, 7, 'மண்', 'மண்; soil', false, v_group_id),
    (v_l32, 8, 'ஆக்கு', 'ஆக்குதல் பகுதி; to make', false, v_group_id),
    (v_l32, 9, 'வை', 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person singular ''you [do]''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 33: விடுத்தனை இதற்கா, எடுத்தஉன் யாக்கை.
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l33, 1, 'விடுத்த்அன்ஐ', 'விடுத்தனை = நீ விட்டுவிட்டாய்; you gave up/released') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l33, 1, 'விடு', 'விடுதல் பகுதி; to release, let go', false, v_group_id),
    (v_l33, 2, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l33, 3, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l33, 4, 'அன்', 'சாரியை; euphonic glide', false, v_group_id),
    (v_l33, 5, 'ஐ', 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person singular ending', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l33, 6, 'இதற்குஆ', 'இதற்கா = இதற்காக; for this reason') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l33, 6, 'இதற்கு', 'இதற்கு; for this', false, v_group_id),
    (v_l33, 7, 'ஆ', 'காரணமாக; because, for the sake of', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l33, 8, 'எடுத்த்அ', 'எடுத்த = எடுத்துக்கொண்ட; taken, formed') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l33, 8, 'எடு', 'எடுத்தல் பகுதி; to take, lift', false, v_group_id),
    (v_l33, 9, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l33, 10, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l33, 11, 'அ', 'பெயரெச்ச விகுதி; adjectival ending', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l33, 12, 'உன்', 'உனது; your', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l33, 13, 'யாக்கை', 'உடல்; body', false, NULL);

  ----------------------------------------------------------------
  -- LINE 34: உழுதுழுது உண்டுமண் மெழுகினும் நேரிய
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l34, 1, 'உழுதுஉழுது', 'உழுதுழுது = திரும்பத் திரும்ப உழுது (அடுக்குத்தொடர்); having ploughed again and again') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l34, 1, 'உழுது', 'உழுதல் இறந்தகால வினையெச்சம்; having ploughed', false, v_group_id),
    (v_l34, 2, 'உழுது', 'உழுதல் இறந்தகால வினையெச்சம் (மீண்டும்); having ploughed (repeated for emphasis)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l34, 3, 'உண்டுமண்', 'உண்டுமண் = மண்ணை உண்டு; having eaten the soil') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l34, 3, 'உண்டு', 'உண்ணுதல் இறந்தகால வினையெச்சம்; having eaten', false, v_group_id),
    (v_l34, 4, 'மண்', 'மண்; soil, earth', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l34, 5, 'மெழுகுஇன்உம்', 'மெழுகினும் = மெழுகைவிடவும் (ஒப்பீடு); even more than wax') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l34, 5, 'மெழுகு', 'மெழுகு; wax (used here as a comparison for smoothness)', false, v_group_id),
    (v_l34, 6, 'இன்', 'ஒப்பீட்டு இடைநிலை; comparative ''than''', false, v_group_id),
    (v_l34, 7, 'உம்', 'சிறப்பும்மை; ''even''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l34, 8, 'நேர்மைஇய', 'நேரிய = நேர்மையான, செம்மையான; straight, refined') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l34, 8, 'நேர்மை', 'நேர்மை, செம்மை; straightness, rightness', false, v_group_id),
    (v_l34, 9, 'இய', 'பண்புப் பெயரெச்ச விகுதி; adjectival ''-like''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 35: விழுமிய சேறாய் வேதித்து உருட்டி
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l35, 1, 'விழுமைஇய', 'விழுமிய = சிறந்த, மேன்மையான; excellent, worthy') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l35, 1, 'விழுமை', 'சிறப்பு, மேன்மை; excellence, worthiness', false, v_group_id),
    (v_l35, 2, 'இய', 'பண்புப் பெயரெச்ச விகுதி; adjectival ''-ous''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l35, 3, 'சேறுஆய்', 'சேறாய் = சேறு போல; as mud/clay') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l35, 3, 'சேறு', 'சேறு, களிமண்; mud, clay', false, v_group_id),
    (v_l35, 4, 'ஆய்', 'ஒப்புமை வினையெச்ச விகுதி; adverbial ''as''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l35, 5, 'வேதித்த்உ', 'வேதித்து = மாற்றி (பாடநூல் பொருள்); having transformed/changed') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l35, 5, 'வேதி', 'மாற்றுதல் பகுதி; to transform, change', false, v_group_id),
    (v_l35, 6, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l35, 7, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l35, 8, 'உ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l35, 9, 'உருட்டுஇ', 'உருட்டி = உருட்டிக்கொண்டு; having rolled') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l35, 9, 'உருட்டு', 'உருட்டுதல் பகுதி; to roll', false, v_group_id),
    (v_l35, 10, 'இ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 36: வெளிக்கொணர்ந் தும், புகழ் வேண்டார் போல
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l36, 1, 'வெளிகொணர்த்(ந்)த்உம்', 'வெளிக்கொணர்ந்தும் = வெளியே கொண்டு வந்தும்; even having brought (it) out') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l36, 1, 'வெளி', 'வெளி; outside, open', false, v_group_id),
    (v_l36, 2, 'கொணர்', 'கொண்டுவருதல் பகுதி; to bring', false, v_group_id),
    (v_l36, 3, 'த்(ந்)', 'சந்தி எழுத்து (ந்); glide variant', false, v_group_id),
    (v_l36, 4, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l36, 5, 'உம்', 'சிறப்பும்மை/எதிர்கால இடைநிலை; ''even, also''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l36, 6, 'புகழ்', 'புகழ்; fame', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l36, 7, 'வேண்டு(ஆ)ஆர்', 'வேண்டார்போல = விரும்பாதவர் போல; as though not wanting/desiring') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l36, 7, 'வேண்டு', 'வேண்டுதல் பகுதி; to want, desire', false, v_group_id),
    (v_l36, 8, '(ஆ)', 'எதிர்மறை இடைநிலை; negative glide', false, v_group_id),
    (v_l36, 9, 'ஆர்', 'எதிர்மறைப் பலர்பால் வினைமுற்று; ''those who do not want''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l36, 10, 'போல', 'போல; like, as though', false, NULL);

  ----------------------------------------------------------------
  -- LINE 37: ஒளிக்குவை உன்குழி வாயுமோர் உருண்டையால்!
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l37, 1, 'ஒளிக்குவை', 'ஒளிக்குவை = நீ மறைக்கிறாய்; you hide/conceal') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l37, 1, 'ஒளி', 'ஒளித்தல் பகுதி; to hide, conceal', false, v_group_id),
    (v_l37, 2, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l37, 3, 'கு', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l37, 4, 'வை', 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person ''you [do]''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l37, 5, 'உன்குழி', 'உன்குழி = உனது குழியின்; your pit''s') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l37, 5, 'உன்', 'உன்னுடைய; your', false, v_group_id),
    (v_l37, 6, 'குழி', 'குழி; pit, hole', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l37, 7, 'வாய்உம்ஓர்உருண்டைஆல்', 'வாயுமோர் உருண்டையால் = வாயையும் ஒரு உருண்டையால்; the mouth too, with a round lump') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l37, 7, 'வாய்', 'வாய், துவாரம்; mouth, opening', false, v_group_id),
    (v_l37, 8, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id),
    (v_l37, 9, 'ஓர்', 'ஒரு; a', false, v_group_id),
    (v_l37, 10, 'உருண்டை', 'உருண்டை; ball, round lump', false, v_group_id),
    (v_l37, 11, 'ஆல்', 'மூன்றாம் வேற்றுமை உருபு; instrumental ''with''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 38: இப்புற் பயிர்நீ இங்ஙனம் உழாயேல்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l38, 1, 'இபுல்பயிர்நீ', 'இப்புற்பயிர்நீ = இந்தப் புல்-பயிராகிய நீ; you, this grass-crop') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l38, 1, 'இ', 'சுட்டு இடைச்சொல்; demonstrative ''this''', false, v_group_id),
    (v_l38, 2, 'புல்', 'புல்; grass', false, v_group_id),
    (v_l38, 3, 'பயிர்', 'பயிர்; crop', false, v_group_id),
    (v_l38, 4, 'நீ', 'நீ; you', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l38, 5, 'இஙனம்', 'இங்ஙனம் = இந்த வகையில்; in this manner') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l38, 5, 'இ', 'சுட்டு இடைச்சொல்; demonstrative ''this''', false, v_group_id),
    (v_l38, 6, 'ஙனம்', 'விதம், முறை; manner, way', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l38, 7, 'உழுஆஏல்', 'உழாயேல் = நீ உழாவிடின்; if you do not plough') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l38, 7, 'உழு', 'உழுதல் பகுதி; to plough', false, v_group_id),
    (v_l38, 8, 'ஆ', 'எதிர்மறை இடைநிலை; negative glide', false, v_group_id),
    (v_l38, 9, 'ஏல்', 'நிபந்தனை விகுதி; conditional ''if...not''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 39: எப்படி உண்டாம்? எண்ணாது உனக்கும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l39, 1, 'எபடி', 'எப்படி = எவ்வாறு; how, in what way') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l39, 1, 'எ', 'வினா இடைச்சொல்; interrogative ''what''', false, v_group_id),
    (v_l39, 2, 'படி', 'விதம், முறை; way, manner', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l39, 3, 'உண்டுஆம்', 'உண்டாம் = உண்டாகும்; will come to exist') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l39, 3, 'உண்டு', 'உண்டு; existing, present', false, v_group_id),
    (v_l39, 4, 'ஆம்', 'ஆகும்; will become', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l39, 5, 'எண்(ஆ)து', 'எண்ணாது = எண்ணாமல்; without thinking/considering') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l39, 5, 'எண்', 'எண்ணுதல் பகுதி; to think, consider', false, v_group_id),
    (v_l39, 6, '(ஆ)', 'எதிர்மறை இடைநிலை; negative glide', false, v_group_id),
    (v_l39, 7, 'து', 'எதிர்மறை வினையெச்ச விகுதி; ''without doing''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l39, 8, 'உனக்குஉம்', 'உனக்கும் = உனக்கும் கூட; for you too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l39, 8, 'உனக்கு', 'உனக்கு; to/for you', false, v_group_id),
    (v_l39, 9, 'உம்', 'சிறப்பும்மை; ''even, too''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 40: குறும்புசெய் எறும்பும் கோடி கோடியாயப்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l40, 1, 'குறும்புசெய்', 'குறும்புசெய் = குறும்பு செய்கின்ற; mischief-making') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l40, 1, 'குறும்பு', 'குறும்பு; mischief', false, v_group_id),
    (v_l40, 2, 'செய்', 'செய்தல் பகுதி; doing (adjectival compound)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l40, 3, 'எறும்புஉம்', 'எறும்பும் = எறும்புகளும்; ants too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l40, 3, 'எறும்பு', 'எறும்பு; ant', false, v_group_id),
    (v_l40, 4, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l40, 5, 'கோடி', 'கோடி; crore, ten million', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l40, 6, 'கோடிஆய்அப்', 'கோடியாய = கோடிக்கணக்காக; by the countless crores') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l40, 6, 'கோடி', 'கோடி; crore, ten million (repeated for emphasis = countless)', false, v_group_id),
    (v_l40, 7, 'ஆய்', 'ஒப்புமை வினையெச்ச விகுதி; adverbial ''as''', false, v_group_id),
    (v_l40, 8, 'அ', 'பெயரெச்ச விகுதி; adjectival glide', false, v_group_id),
    (v_l40, 9, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 41: புழுக்களும் பூச்சியும் பிழைக்குமா றென்னை?
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l41, 1, 'புழுக்கள்உம்', 'புழுக்களும் = புழுக்களும்; worms too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l41, 1, 'புழு', 'புழு; worm', false, v_group_id),
    (v_l41, 2, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l41, 3, 'கள்', 'பன்மை விகுதி; plural marker', false, v_group_id),
    (v_l41, 4, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l41, 5, 'பூச்சிஉம்', '[பொருள் சரிபார்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l41, 5, 'பூச்சி', 'பூச்சி; insect', false, v_group_id),
    (v_l41, 6, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l41, 7, 'பிழைக்க்உம்ஆறு', 'பிழைக்குமாறு = பிழைக்கும் விதம்; the way [they] survive') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l41, 7, 'பிழை', 'பிழைத்தல் பகுதி; to survive', false, v_group_id),
    (v_l41, 8, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l41, 9, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l41, 10, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id),
    (v_l41, 11, 'ஆறு', 'வழி, முறை; way, manner', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l41, 12, 'என்ஐ', 'என்னை = என்ன; what [is it]?') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l41, 12, 'என்', 'வினா இடைச்சொல்; interrogative ''what''', false, v_group_id),
    (v_l41, 13, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 42: ஒழுக்கமும் பொறையும் உனைப்போல் யார்க்குள?
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l42, 1, 'ஒழுக்கம்உம்', '[பொருள் சரிபார்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l42, 1, 'ஒழுக்கம்', 'ஒழுக்கம், நல்லொழுக்கம்; discipline, good conduct', false, v_group_id),
    (v_l42, 2, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l42, 3, 'பொறைஉம்', '[பொருள் சரிபார்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l42, 3, 'பொறை', 'பொறுமை; patience, forbearance', false, v_group_id),
    (v_l42, 4, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l42, 5, 'உன்ஐப்போல்', 'உனைப்போல் = உன்னைப் போல; like you') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l42, 5, 'உன்', 'உன்னை; you', false, v_group_id),
    (v_l42, 6, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id),
    (v_l42, 7, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l42, 8, 'போல்', 'ஒப்புமை இடைச்சொல்; like, similar to', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l42, 9, 'யார்க்குஉள', 'யார்க்குள = யாருக்கு உள்ளது; who possesses [it]?') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l42, 9, 'யார்', 'யார்; who', false, v_group_id),
    (v_l42, 10, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l42, 11, 'கு', 'நான்காம் வேற்றுமை உருபு; dative ''to''', false, v_group_id),
    (v_l42, 12, 'உள', 'உள்ளது; exists, is present', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 43: விழுப்புகழ் வேண்டலை. அறிவோம். ஏனிது?
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l43, 1, 'விழுமைபுகழ்', 'விழுப்புகழ் = சிறந்த புகழ்; worthy/excellent fame') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l43, 1, 'விழுமை', 'சிறப்பு, மேன்மை; excellence, worthiness', false, v_group_id),
    (v_l43, 2, 'புகழ்', 'புகழ்; fame', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l43, 3, 'வேண்டிஅல்ஐ', 'வேண்டலை = நீ விரும்பவில்லை; you do not desire') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l43, 3, 'வேண்டி', 'வேண்டுதல் பகுதி; to desire, want', false, v_group_id),
    (v_l43, 4, 'அல்', 'எதிர்மறை இடைநிலை; negative glide', false, v_group_id),
    (v_l43, 5, 'ஐ', 'முன்னிலை ஒருமை எதிர்மறை வினைமுற்று விகுதி; 2nd person negative ending', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l43, 6, 'அறிவ்ஓம்', 'அறிவோம் = நாங்கள் அறிவோம்; we know [it]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l43, 6, 'அறி', 'அறிதல் பகுதி; to know', false, v_group_id),
    (v_l43, 7, 'வ்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l43, 8, 'ஓம்', 'தன்மைப் பன்மை வினைமுற்று விகுதி; 1st person plural ''we''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l43, 9, 'ஏன்இது', 'ஏனிது = ஏன் இது; why is this?') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l43, 9, 'ஏன்', 'ஏன்; why', false, v_group_id),
    (v_l43, 10, 'இது', 'இது; this', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 44: துதிக்கலம். உன்தொழில் நடத்துதி. ஆ! ஆ!
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l44, 1, 'துதிக்க்அல்அம்', 'துதிக்கலம் = நாங்கள் புகழ விரும்பவில்லை; we do not seek praise') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l44, 1, 'துதி', 'துதித்தல் பகுதி; to praise', false, v_group_id),
    (v_l44, 2, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l44, 3, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l44, 4, 'அல்', 'எதிர்மறை இடைநிலை; negative glide', false, v_group_id),
    (v_l44, 5, 'அம்', 'தன்மைப் பன்மை எதிர்மறை வினைமுற்று விகுதி; 1st person plural negative', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l44, 6, 'உன்தொழில்நடத்துதி', 'உன்தொழில் நடத்துதி = உனது தொழிலை நீ நடத்துகிறாய்; you carry out your own task') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l44, 6, 'உன்', 'உன்னுடைய; your', false, v_group_id),
    (v_l44, 7, 'தொழில்', 'தொழில், வேலை; task, occupation', false, v_group_id),
    (v_l44, 8, 'நடத்து', 'நடத்துதல் பகுதி; to conduct, carry out', false, v_group_id),
    (v_l44, 9, 'தி', 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person ''you [do]''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l44, 10, 'ஆ', 'வியப்புக்குறிப்பு இடைச்சொல்; exclamation ''Ah!''', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l44, 11, 'ஆ', 'வியப்புக்குறிப்பு இடைச்சொல் (மீண்டும்); exclamation ''Ah!'' (repeated)', false, NULL);

  ----------------------------------------------------------------
  -- LINE 45: எங்கும் இங்ஙனே இணையிலா இன்பும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l45, 1, 'எங்குஉம்', 'எங்கும் = எல்லா இடங்களிலும்; everywhere') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l45, 1, 'எங்கு', 'எங்கு; where, everywhere', false, v_group_id),
    (v_l45, 2, 'உம்', 'சிறப்பும்மை; ''also, even''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l45, 3, 'இஙனம்ஏ', 'இங்ஙனேஏ = இந்த வகையிலேயே; in this very manner') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l45, 3, 'இ', 'சுட்டு இடைச்சொல்; demonstrative ''this''', false, v_group_id),
    (v_l45, 4, 'ஙனம்', 'விதம், முறை; manner, way', false, v_group_id),
    (v_l45, 5, 'ஏ', 'அழுத்தச் சொல்; emphatic particle', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l45, 6, 'இணைஇலாஇன்புஉம்', 'இணையிலா இன்பும் = ஒப்பற்ற இன்பமும்; matchless joy too') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l45, 6, 'இணை', 'இணை, ஒப்பு; equal, match', false, v_group_id),
    (v_l45, 7, 'இலா', 'இல்லாத; without', false, v_group_id),
    (v_l45, 8, 'இன்பு', 'இன்பம்; joy, happiness', false, v_group_id),
    (v_l45, 9, 'உம்', 'சிறப்பும்மை; ''and, too''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 46: பங்கமில் அன்பும் தங்குதல் திருந்தக்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l46, 1, 'பங்கம்இல்', 'பங்கமில் = குறை இல்லாத; blemishless, flawless') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l46, 1, 'பங்கம்', 'குறை, கேடு; blemish, harm', false, v_group_id),
    (v_l46, 2, 'இல்', 'இல்லாத; without', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l46, 3, 'அன்புஉம்', '[பொருள் சரிபார்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l46, 3, 'அன்பு', 'அன்பு; love', false, v_group_id),
    (v_l46, 4, 'உம்', 'சிறப்பும்மை; ''and, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l46, 5, 'தங்குதல்', 'தங்குதல் = தங்கியிருத்தல்; the dwelling, abiding') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l46, 5, 'தங்கு', 'தங்குதல் பகுதி; to dwell, abide', false, v_group_id),
    (v_l46, 6, 'தல்', 'தொழிற்பெயர் விகுதி; verbal-noun ending', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l46, 7, 'திருந்துஅக்', 'திருந்தக் = திருந்திய முறையில், நிறைவாக; in a refined/perfect manner') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l46, 7, 'திருந்து', 'திருந்துதல் பகுதி; to become refined, perfected', false, v_group_id),
    (v_l46, 8, 'அ', 'பெயரெச்ச விகுதி; adjectival ending', false, v_group_id),
    (v_l46, 9, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 47: காணார் பேணும் வாணாள் என்னே?
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l47, 1, 'காண்ஆர்', 'காணார் = அவர்கள் காண்பதில்லை; they do not see [it]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l47, 1, 'காண்', 'காணுதல் பகுதி; to see', false, v_group_id),
    (v_l47, 2, 'ஆர்', 'எதிர்மறைப் பலர்பால் வினைமுற்று விகுதி; negative 3rd person plural ''they do not''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l47, 3, 'பேண்உம்', 'பேணும் = போற்றும்; that cherishes/nurtures') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l47, 3, 'பேண்', 'போற்றுதல் பகுதி; to cherish, nurture', false, v_group_id),
    (v_l47, 4, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l47, 5, 'வாழ்நாள்என்ஏ', 'வாணாள் என்னே = வாழ்நாள் தான் என்னே!; alas, what [a pity about] the life [they live]!') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l47, 5, 'வாழ்', 'வாழ்தல் பகுதி; to live', false, v_group_id),
    (v_l47, 6, 'நாள்', 'நாள்; day (வாழ்நாள் = lifetime)', false, v_group_id),
    (v_l47, 7, 'என்', 'என்; what', false, v_group_id),
    (v_l47, 8, 'ஏ', 'ஏகார அழுத்தம்; exclamatory ''alas!''', false, v_group_id);

  RAISE NOTICE '✓ மனோன்மணீயம் — topic, 5 pages, 47 lines, word_groups and morphemes all set up.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, pl.raw_text, wg.position, wg.combined_display_form
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்'
ORDER BY pl.line_number, wg.position;
