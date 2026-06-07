-- ============================================================
-- 11ஆம் தமிழ்ப் பாடம் — Demo Seed Data
-- Run AFTER schema.sql
-- Poem: யுகத்தின் பாடல் | Line: விரல் முனையைத் தீயிலே தோய்த்து
-- ============================================================

-- Use a DO block so we can capture generated IDs across inserts
do $$
declare
  v_sec_id       uuid;
  v_sec2_id      uuid;
  v_sec3_id      uuid;
  v_topic_id     uuid;
  v_topic2_id    uuid;
  v_page_poem_id uuid;
  v_page_nuz_id  uuid;
  v_line_id      uuid;
  v_morph_id     uuid;
begin

  -- ==========================================
  -- SECTIONS
  -- ==========================================
  insert into sections (name, order_index) values ('செய்யுள்',    1) returning id into v_sec_id;
  insert into sections (name, order_index) values ('உரை நடை',     2) returning id into v_sec2_id;
  insert into sections (name, order_index) values ('துணைப்பாடம்', 3) returning id into v_sec3_id;

  -- ==========================================
  -- TOPICS
  -- ==========================================
  insert into topics (section_id, title, order_index)
    values (v_sec_id, 'யுகத்தின் பாடல்', 1) returning id into v_topic_id;

  insert into topics (section_id, title, order_index)
    values (v_sec_id, 'ஒவ்வொரு புல்லையும்', 2) returning id into v_topic2_id;

  -- ==========================================
  -- PAGES for யுகத்தின் பாடல்
  -- ==========================================
  insert into pages (topic_id, page_type) values (v_topic_id, 'நுழையும் முன்')    returning id into v_page_nuz_id;
  insert into pages (topic_id, page_type) values (v_topic_id, 'செய்யுள் பகுதி')   returning id into v_page_poem_id;
  insert into pages (topic_id, page_type) values (v_topic_id, 'இலக்கணப் பகுதி')  ;
  insert into pages (topic_id, page_type) values (v_topic_id, 'துணைக் குறிப்புகள்');
  insert into pages (topic_id, page_type) values (v_topic_id, 'நூல் வெளி')        ;

  -- ==========================================
  -- PROSE CONTENT — நுழையும் முன்
  -- ==========================================
  insert into prose_content (page_id, content_text, order_index) values
    (v_page_nuz_id,
     'யுகத்தின் பாடல் என்னும் இக்கவிதை, தமிழகத்தின் புகழ்பெற்ற கவிஞர் பிரமிள் அவர்களால் இயற்றப்பட்டது. இக்கவிதை மனிதனின் துன்பங்களையும் போராட்டங்களையும் உணர்வுபூர்வமாக வெளிப்படுத்துகிறது.',
     1),
    (v_page_nuz_id,
     'இக்கவிதையை படிக்கும் முன், மனித வாழ்வின் கஷ்டங்களையும் அவற்றை வெல்லும் உறுதியையும் குறித்து சிந்திக்க வேண்டும். அதன்பின் இக்கவிதையின் வரிகள் இன்னும் ஆழமாக மனதில் பதியும்.',
     2);

  -- ==========================================
  -- LITERARY NOTES — இலக்கிய நயம்
  -- ==========================================
  insert into literary_notes (page_id, content_text, order_index) values
    (v_page_poem_id,
     'இக்கவிதையில் "விரல் முனையைத் தீயிலே தோய்த்து" என்ற வரியில் தீ என்பது துன்பத்தின் உருவகமாக கையாளப்படுகிறது. இது உருவக அணி (Metaphor) ஆகும்.',
     1),
    (v_page_poem_id,
     '"விரல் முனை" என்பது மனித உணர்வின் நுண்மையான தொடுதலை குறிக்கிறது. இங்கு ஒலிநயம் (Alliteration) சிறப்பாக அமைந்துள்ளது — "த்" ஒலி மீண்டும் மீண்டும் வருவதை கவனிக்கலாம்.',
     2);

  -- ==========================================
  -- POEM LINE 1: விரல் முனையைத் தீயிலே தோய்த்து
  -- ==========================================
  insert into poem_lines (page_id, line_number, raw_text) values
    (v_page_poem_id, 1, 'விரல் முனையைத் தீயிலே தோய்த்து')
    returning id into v_line_id;

  -- POEM LINE 2 (placeholder)
  insert into poem_lines (page_id, line_number, raw_text) values
    (v_page_poem_id, 2, 'வலியை உணர்ந்து நடந்தோம்');

  -- POEM LINE 3 (placeholder)
  insert into poem_lines (page_id, line_number, raw_text) values
    (v_page_poem_id, 3, 'உலகின் இரகசியம் தெரியும்');

  -- ==========================================
  -- MORPHEMES for Line 1
  -- Position ordering: விரல்(1) முனை(2) ஐ(3) த்(4) தீ(5) +(sep) ய்(6) +(sep) இல்(7) +(sep) ஏ(8) தோய்(9) +(sep) த்(10) +(sep) த்(11) +(sep) உ(12)
  -- ==========================================

  -- விரல் — பெயர்ச்சொல்
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 1, 'விரல்', 'கை விரல் (finger)', 'பெயர்ச்சொல்', false, false);

  -- முனை — பெயர்ச்சொல்
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 2, 'முனை', 'நுனி, கூர்மையான பகுதி (tip, point)', 'பெயர்ச்சொல்', false, false);

  -- ஐ — இடைச்சொல் (வேற்றுமை உருபு — second case marker)
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 3, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு (accusative case marker)', 'இடைச்சொல்', false, false);

  -- த் — இடைச்சொல் (linking consonant / புணர்ச்சி)
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 4, 'த்', 'புணர்ச்சி மெய் — இரண்டு சொற்களை இணைக்கும் (sandhi consonant)', 'இடைச்சொல்', false, false);

  -- தீ — பெயர்ச்சொல்
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 5, 'தீ', 'நெருப்பு; இங்கு துன்பத்தின் உருவகம் (fire; metaphor for suffering)', 'பெயர்ச்சொல்', false, false);

  -- separator +
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 6, '+', null, null, false, true);

  -- (ய்) — இடைச்சொல் (glide consonant, shown in brackets)
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 7, '(ய்)', 'உடம்படுமெய் — தொடர் ஒலி இணைப்பு (glide consonant for vowel junction)', 'இடைச்சொல்', false, false);

  -- separator +
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 8, '+', null, null, false, true);

  -- இல் — இடைச்சொல் (locative case)
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 9, 'இல்', 'ஏழாம் வேற்றுமை உருபு — இடம் குறிக்கும் (locative case: in/at)', 'இடைச்சொல்', false, false);

  -- separator +
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 10, '+', null, null, false, true);

  -- ஏ — இடைச்சொல் (emphasis particle)
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 11, 'ஏ', 'வலியுறுத்தும் இடைச்சொல் (emphatic particle)', 'இடைச்சொல்', false, false);

  -- தோய் — வினைச்சொல் verb root (is_verb=true)
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 12, 'தோய்', 'முக்குதல், தொடுதல் (to dip, to touch)', 'வினைச்சொல்', true, false)
    returning id into v_morph_id;

  -- VERB ANALYSIS for தோய் (பகுபத உறுப்பிலக்கணம்)
  insert into verb_analysis (morpheme_id, analysis)
    values (v_morph_id, '[
      {"part": "தோய்", "label": "பகுதி (verb root)"},
      {"part": "த்",   "label": "சந்தி (euphonic consonant)"},
      {"part": "த்",   "label": "இறந்த கால இடை நிலை (past tense marker)"},
      {"part": "உ",    "label": "வினையெச்ச விகுதி (verbal participle suffix)"}
    ]'::jsonb);

  -- separator +
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 13, '+', null, null, false, true);

  -- த் — suffix
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 14, 'த்', 'சந்தி — பகுதிக்கும் கால இடைநிலைக்கும் இடையேயான இணைப்பு மெய் (sandhi consonant)', 'இடைச்சொல்', false, false);

  -- separator +
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 15, '+', null, null, false, true);

  -- த் — past tense marker
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 16, 'த்', 'இறந்த கால இடை நிலை (past tense marker)', 'இடைச்சொல்', false, false);

  -- separator +
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 17, '+', null, null, false, true);

  -- உ — verbal participle suffix
  insert into morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb, is_separator)
    values (v_line_id, 18, 'உ', 'வினையெச்ச விகுதி — வினையை பெயரெச்சமாக்கும் (verbal participle suffix)', 'இடைச்சொல்', false, false);

end $$;
