-- ============================================================
-- ஒவ்வொரு புல்லையும் — Complete Content SQL
-- கவிஞர்: இன்குலாப் (Inquilab / சாகுல் அமீது)
-- இயல் 1 — கவிதைப்பேழை
-- ============================================================
-- HOW TO RUN:
--   Supabase → SQL Editor → paste this entire file → Run
-- ============================================================

DO $$
DECLARE
  v_section_id  uuid;
  v_topic_id    uuid;
  v_page_nuzhai uuid;   -- நுழையும் முன்
  v_page_poem   uuid;   -- செய்யுள் பகுதி
  v_page_ilak   uuid;   -- இலக்கணப் பகுதி
  v_page_thunai uuid;   -- துணைக் குறிப்புகள்
  v_page_nool   uuid;   -- நூல் வெளி

  -- poem line ids
  v_l1  uuid; v_l2  uuid; v_l3  uuid; v_l4  uuid; v_l5  uuid;
  v_l6  uuid; v_l7  uuid; v_l8  uuid; v_l9  uuid; v_l10 uuid;
  v_l11 uuid; v_l12 uuid; v_l13 uuid; v_l14 uuid; v_l15 uuid;
  v_l16 uuid; v_l17 uuid; v_l18 uuid; v_l19 uuid; v_l20 uuid;

  v_m uuid;  -- temp morpheme id (for verb_analysis inserts)

BEGIN

  -- ── 1. Get செய்யுள் section ──────────────────────────────────────────────────
  SELECT id INTO v_section_id FROM sections WHERE name = 'செய்யுள்';
  IF v_section_id IS NULL THEN
    RAISE EXCEPTION 'செய்யுள் section not found. Ensure sections table has this row.';
  END IF;

  -- ── 2. Ensure topic_type column exists (safe to run even if already present) ─
  ALTER TABLE topics ADD COLUMN IF NOT EXISTS topic_type text NOT NULL DEFAULT 'poem';

  -- ── 3. Create topic ──────────────────────────────────────────────────────────
  INSERT INTO topics (section_id, title, order_index, topic_type)
  VALUES (v_section_id, 'ஒவ்வொரு புல்லையும்', 20, 'poem')
  RETURNING id INTO v_topic_id;

  RAISE NOTICE 'Topic created: ஒவ்வொரு புல்லையும் (id=%)', v_topic_id;

  -- ── 4. Create all 5 pages ────────────────────────────────────────────────────
  INSERT INTO pages (topic_id, page_type)
  VALUES (v_topic_id, 'நுழையும் முன்') RETURNING id INTO v_page_nuzhai;

  INSERT INTO pages (topic_id, page_type)
  VALUES (v_topic_id, 'செய்யுள் பகுதி') RETURNING id INTO v_page_poem;

  INSERT INTO pages (topic_id, page_type)
  VALUES (v_topic_id, 'இலக்கணப் பகுதி') RETURNING id INTO v_page_ilak;

  INSERT INTO pages (topic_id, page_type)
  VALUES (v_topic_id, 'துணைக் குறிப்புகள்') RETURNING id INTO v_page_thunai;

  INSERT INTO pages (topic_id, page_type)
  VALUES (v_topic_id, 'நூல் வெளி') RETURNING id INTO v_page_nool;

  RAISE NOTICE 'Pages created (நுழையும் முன்=%, செய்யுள்=%, நூல் வெளி=%)',
    v_page_nuzhai, v_page_poem, v_page_nool;

  -- ── 4. Prose content — நுழையும் முன் ────────────────────────────────────────
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
    (v_page_nuzhai,
     '''காக்கை குருவி எங்கள் ஜாதி'' என்னும் மகாகவி பாரதி கூற்றின் நீட்சியே, ''கூவும் குயிலும் கரையும் காகமும் விரியும் எனது கிளைகளில் அடையும்'' என்னும் இன்குலாப்பின் குரலாகவும் ஒலிக்கிறது.',
     10),
    (v_page_nuzhai,
     'தம் எழுத்துகள் எளிய மக்களுக்கானவை என்னும் உறுதியுடன் எண்ணம், சொல், செயல் என்ற மூவகையிலும் நின்று வாழ்ந்தவர். அவர், மொழியைக் கலைநயத்துடன் கையாண்டு படைத்த இக்கவிதையே அதற்குச் சான்று.',
     20);

  -- ── 5. Prose content — நூல் வெளி ────────────────────────────────────────────
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
    (v_page_nool,
     '''இன்குலாப்'' என்பது புனைப்பெயர். இவரின் இயற்பெயர் சாகுல் அமீது.',
     10),
    (v_page_nool,
     'இவர் கவிதை, சிறுகதை, கட்டுரை, நாடகம், மொழிபெயர்ப்பு ஆகிய இலக்கிய வடிவங்களில் எழுதியவர்.',
     20),
    (v_page_nool,
     'இவருடைய கவிதைகள் ''ஒவ்வொரு புல்லையும் பெயர் சொல்லி அழைப்பேன்'' என்ற பெயரில் முழுமையாகத் தொகுக்கப்பட்டுள்ளன.',
     30);

  -- ── 6. Poem lines ────────────────────────────────────────────────────────────

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 1, 'ஒவ்வொரு புல்லையும் பெயர் சொல்லி அழைப்பேன்')
  RETURNING id INTO v_l1;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 2, 'பறவைகளோடு எல்லை கடப்பேன்')
  RETURNING id INTO v_l2;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 3, 'பெயர் தெரியாத கல்லையும் மண்ணையும்')
  RETURNING id INTO v_l3;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 4, 'எனக்குத் தெரிந்த சொல்லால் விளிப்பேன்')
  RETURNING id INTO v_l4;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 5, 'நீளும் கைகளில் தோழமை தொடரும்')
  RETURNING id INTO v_l5;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 6, 'நீளாத கையிலும் நெஞ்சம் படரும்')
  RETURNING id INTO v_l6;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 7, 'எனக்கு வேண்டும் உலகம் ஓர் கடலாய்')
  RETURNING id INTO v_l7;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 8, 'உலகுக்கு வேண்டும் நானும் ஓர் துளியாய்')
  RETURNING id INTO v_l8;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 9, 'கூவும் குயிலும் கரையும் காகமும்')
  RETURNING id INTO v_l9;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 10, 'விரியும் எனது கிளைகளில் அடையும்.')
  RETURNING id INTO v_l10;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 11, 'போதியின் நிழலும் சிலுவையும் பிறையும்')
  RETURNING id INTO v_l11;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 12, 'பொங்கும் சமத்துவப்புனலில் கரையும்!')
  RETURNING id INTO v_l12;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 13, 'எந்த மூலையில் விசும்பல் என்றாலும்')
  RETURNING id INTO v_l13;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 14, 'என் செவிகளிலே எதிரொலி கேட்கும்.')
  RETURNING id INTO v_l14;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 15, 'கூண்டில் மோதும் சிறகுகளோடு')
  RETURNING id INTO v_l15;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 16, 'எனது சிறகிலும் குருதியின் கோடு!')
  RETURNING id INTO v_l16;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 17, 'சமயம் கடந்து மானுடம் கூடும்')
  RETURNING id INTO v_l17;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 18, 'சுவர் இல்லாத சமவெளி தோறும்')
  RETURNING id INTO v_l18;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 19, 'குறிகள் இல்லாத முகங்களில் விழிப்பேன்')
  RETURNING id INTO v_l19;

  INSERT INTO poem_lines (page_id, line_number, raw_text)
  VALUES (v_page_poem, 20, 'மனிதம் என்றொரு பாடலை இசைப்பேன்!')
  RETURNING id INTO v_l20;

  RAISE NOTICE '20 poem lines inserted';

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 7. MORPHEMES
  -- Rules:
  --   • Verbs stored as WHOLE WORD (is_verb=true); breakdown in verb_analysis
  --   • Sandhi consonants (த்) are NOT stored as separate chips
  --   • Positions: 10, 20, 30, … per line
  -- ═══════════════════════════════════════════════════════════════════════════

  -- ── Line 1: ஒவ்வொரு புல்லையும் பெயர் சொல்லி அழைப்பேன் ─────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l1, 10, 'ஒவ்வொரு',
    'ஒவ்வொன்றும் — each and every single one (emphatic distributive)',
    'உரிச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l1, 20, 'புல்லையும்',
    'புல் + ஐ + உம் — even the blade of grass (accusative + inclusive particle)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l1, 30, 'பெயர்',
    'பெயர் — name, proper noun, identity',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l1, 40, 'சொல்லி',
    'சொல்லி — having said, calling out by name (வினையெச்சம் — adverbial participle)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"சொல்","label":"பகுதி (root)"},{"part":"இ","label":"வினையெச்ச விகுதி (adverbial participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l1, 50, 'அழைப்பேன்',
    'அழைப்பேன் — I will call, I will summon (எதிர்காலம், தன்மை ஒருமை — future tense, 1st person singular)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"அழை","label":"பகுதி (root)"},{"part":"ப்","label":"சந்தி (euphonic consonant)"},{"part":"ப்","label":"இடைநிலை — எதிர்காலம் (future tense marker)"},{"part":"ஏன்","label":"விகுதி — தன்மை ஒருமை (1st person singular suffix)"}]');

  -- ── Line 2: பறவைகளோடு எல்லை கடப்பேன் ───────────────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l2, 10, 'பறவைகளோடு',
    'பறவை + கள் + ஓடு — with birds (sociative case, plural — உடனிகழ்ச்சி வேற்றுமை)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l2, 20, 'எல்லை',
    'எல்லை — boundary, border, frontier, limit',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l2, 30, 'கடப்பேன்',
    'கடப்பேன் — I will cross, I will transcend (எதிர்காலம், தன்மை ஒருமை)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"கட","label":"பகுதி (root: கடக்கு)"},{"part":"ப்","label":"சந்தி (euphonic consonant)"},{"part":"ப்","label":"இடைநிலை — எதிர்காலம் (future tense marker)"},{"part":"ஏன்","label":"விகுதி — தன்மை ஒருமை (1st person singular suffix)"}]');

  -- ── Line 3: பெயர் தெரியாத கல்லையும் மண்ணையும் ──────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l3, 10, 'பெயர்',
    'பெயர் — name, identity (here: whose name is unknown)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l3, 20, 'தெரியாத',
    'தெரியாத — unknown, unfamiliar, not known (எதிர்மறை பெயரெச்சம் — negative adjectival participle)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"தெரி","label":"பகுதி (root: to know, to be known)"},{"part":"ஆ","label":"எதிர்மறை இடைநிலை (negative marker)"},{"part":"த்","label":"சந்தி (euphonic consonant)"},{"part":"அ","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l3, 30, 'கல்லையும்',
    'கல் + ஐ + உம் — even the stone, even the rock (accusative + inclusive)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l3, 40, 'மண்ணையும்',
    'மண் + ஐ + உம் — even the soil, even the earth (accusative + inclusive)',
    'பெயர்ச்சொல்', false);

  -- ── Line 4: எனக்குத் தெரிந்த சொல்லால் விளிப்பேன் ───────────────────────
  -- Note: எனக்குத் = எனக்கு + த் (sandhi); displayed as எனக்கு
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l4, 10, 'எனக்கு',
    'எனக்கு — to me, for me (dative case of யான் → என்)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l4, 20, 'தெரிந்த',
    'தெரிந்த — known, familiar (இறந்தகால பெயரெச்சம் — past adjectival participle)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"தெரி","label":"பகுதி (root)"},{"part":"ந்த்","label":"இறந்தகால இடைநிலை (past tense marker)"},{"part":"அ","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l4, 30, 'சொல்லால்',
    'சொல் + ஆல் — by word, with words (instrumental case — கருவி வேற்றுமை)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l4, 40, 'விளிப்பேன்',
    'விளிப்பேன் — I will call out, I will address, I will name (எதிர்காலம், தன்மை ஒருமை)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"விளி","label":"பகுதி (root: to call, to address)"},{"part":"ப்","label":"சந்தி (euphonic consonant)"},{"part":"ப்","label":"இடைநிலை — எதிர்காலம் (future tense marker)"},{"part":"ஏன்","label":"விகுதி — தன்மை ஒருமை (1st person singular suffix)"}]');

  -- ── Line 5: நீளும் கைகளில் தோழமை தொடரும் ──────────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l5, 10, 'நீளும்',
    'நீளும் — extending, reaching out, stretching (பெயரெச்சம் — adjectival participle)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"நீள்","label":"பகுதி (root: to extend, to stretch)"},{"part":"உம்","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l5, 20, 'கைகளில்',
    'கை + கள் + இல் — in hands (locative case plural — இடவேற்றுமை)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l5, 30, 'தோழமை',
    'தோழமை — friendship, comradeship, brotherly bond (தோழன் → தோழமை)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l5, 40, 'தொடரும்',
    'தொடரும் — will continue, will carry on, will persist (எதிர்காலம்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"தொடர்","label":"பகுதி (root: to continue, to follow)"},{"part":"உம்","label":"எதிர்கால விகுதி (future tense suffix)"}]');

  -- ── Line 6: நீளாத கையிலும் நெஞ்சம் படரும் ──────────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l6, 10, 'நீளாத',
    'நீளாத — not extending, not reaching (எதிர்மறை பெயரெச்சம்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"நீள்","label":"பகுதி (root)"},{"part":"ஆ","label":"எதிர்மறை இடைநிலை (negative marker)"},{"part":"த்","label":"சந்தி (euphonic consonant)"},{"part":"அ","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l6, 20, 'கையிலும்',
    'கை + இல் + உம் — even in the hand (locative + inclusive: even those hands that do not reach)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l6, 30, 'நெஞ்சம்',
    'நெஞ்சம் — heart, mind, inner self, the seat of emotions',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l6, 40, 'படரும்',
    'படரும் — will spread, will reach, will climb, will extend (எதிர்காலம்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"படர்","label":"பகுதி (root: to spread, to creep, to reach)"},{"part":"உம்","label":"எதிர்கால விகுதி (future tense suffix)"}]');

  -- ── Line 7: எனக்கு வேண்டும் உலகம் ஓர் கடலாய் ───────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l7, 10, 'எனக்கு',
    'எனக்கு — to me, for me (dative case)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l7, 20, 'வேண்டும்',
    'வேண்டும் — I need, I desire, I want (எதிர்காலம் — dative-subject construction)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"வேண்டு","label":"பகுதி (root: to need, to want)"},{"part":"உம்","label":"எதிர்கால விகுதி (future tense suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l7, 30, 'உலகம்',
    'உலகம் — world, the earth, the entire world',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l7, 40, 'ஓர்',
    'ஓர் — one, a/an (indefinite article / numeral adjective)',
    'உரிச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l7, 50, 'கடலாய்',
    'கடல் + ஆய் — like a sea, as vast as an ocean (உவமை உருபு — simile suffix -ஆய்)',
    'பெயர்ச்சொல்', false);

  -- ── Line 8: உலகுக்கு வேண்டும் நானும் ஓர் துளியாய் ──────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l8, 10, 'உலகுக்கு',
    'உலகு + கு — to the world, for the world (dative case)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l8, 20, 'வேண்டும்',
    'வேண்டும் — need, is needed by, necessary (எதிர்காலம்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"வேண்டு","label":"பகுதி (root)"},{"part":"உம்","label":"எதிர்கால விகுதி (future tense suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l8, 30, 'நானும்',
    'நான் + உம் — I also, I too (1st person pronoun + inclusive particle)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l8, 40, 'ஓர்',
    'ஓர் — one, a/an (numeral adjective)',
    'உரிச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l8, 50, 'துளியாய்',
    'துளி + ஆய் — like a drop, as a single drop (உவமை உருபு — simile suffix -ஆய்)',
    'பெயர்ச்சொல்', false);

  -- ── Line 9: கூவும் குயிலும் கரையும் காகமும் ─────────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l9, 10, 'கூவும்',
    'கூவும் — cooing, calling sweetly (பெயரெச்சம் — adjectival participle modifying குயில்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"கூவு","label":"பகுதி (root: to coo, to call)"},{"part":"உம்","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l9, 20, 'குயிலும்',
    'குயில் + உம் — the cuckoo too, even the cuckoo (inclusive particle)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l9, 30, 'கரையும்',
    'கரையும் — cawing, crying loudly (பெயரெச்சம் — adjectival participle modifying காகம்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"கரை","label":"பகுதி (root: to cry out, to caw, to clamour)"},{"part":"யும்","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l9, 40, 'காகமும்',
    'காகம் + உம் — the crow too, even the crow (inclusive particle)',
    'பெயர்ச்சொல்', false);

  -- ── Line 10: விரியும் எனது கிளைகளில் அடையும். ──────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l10, 10, 'விரியும்',
    'விரியும் — spreading wide, open (பெயரெச்சம் — adjectival participle, modifying கிளைகள்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"விரி","label":"பகுதி (root: to spread, to open wide)"},{"part":"யும்","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l10, 20, 'எனது',
    'எனது — my, mine (genitive form of யான் — 1st person possessive)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l10, 30, 'கிளைகளில்',
    'கிளை + கள் + இல் — in branches, on branches (locative plural — இடவேற்றுமை)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l10, 40, 'அடையும்',
    'அடையும் — will settle, will roost, will nest (எதிர்காலம் — birds settling in branches)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"அடை","label":"பகுதி (root: to settle, to reach, to arrive)"},{"part":"யும்","label":"எதிர்கால விகுதி (future tense suffix)"}]');

  -- ── Line 11: போதியின் நிழலும் சிலுவையும் பிறையும் ──────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l11, 10, 'போதியின்',
    'போதி + இன் — of the Bodhi tree (genitive). பௌத்தத்தின் புனிதப் பேரால மரம் — sacred tree of Buddhism where the Buddha attained enlightenment',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l11, 20, 'நிழலும்',
    'நிழல் + உம் — the shade too, even the shadow (inclusive particle)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l11, 30, 'சிலுவையும்',
    'சிலுவை + உம் — the cross too (inclusive). கிறித்தவத்தின் புனிதக் குறி — sacred symbol of Christianity',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l11, 40, 'பிறையும்',
    'பிறை + உம் — the crescent too (inclusive). இஸ்லாமின் புனிதக் குறி — sacred symbol of Islam',
    'பெயர்ச்சொல்', false);

  -- ── Line 12: பொங்கும் சமத்துவப்புனலில் கரையும்! ────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l12, 10, 'பொங்கும்',
    'பொங்கும் — surging, overflowing, welling up with force (பெயரெச்சம் — modifies புனல்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"பொங்கு","label":"பகுதி (root: to surge, to well up, to overflow)"},{"part":"உம்","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l12, 20, 'சமத்துவப்புனலில்',
    'சமத்துவம் + புனல் + இல் — in the river of equality, in the flood of justice (locative case). சமத்துவம் = equality; புனல் = river, flood',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l12, 30, 'கரையும்',
    'கரையும் — will dissolve, will melt, will merge (எதிர்காலம் — all religious differences dissolving in equality)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"கரை","label":"பகுதி (root: to dissolve, to melt, to merge)"},{"part":"யும்","label":"எதிர்கால விகுதி (future tense suffix)"}]');

  -- ── Line 13: எந்த மூலையில் விசும்பல் என்றாலும் ───────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l13, 10, 'எந்த',
    'எந்த — whichever, whatever, in any (interrogative adjective used as generalizer)',
    'உரிச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l13, 20, 'மூலையில்',
    'மூலை + இல் — in the corner, in the nook (locative) — any remote corner of the world',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l13, 30, 'விசும்பல்',
    'விசும்பல் — weeping, sobbing, lamentation, a cry of sorrow',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l13, 40, 'என்றாலும்',
    'என்று + ஆலும் — even if there is, however it may be (concessive conjunction — இளிவரல் சொல்)',
    'இடைச்சொல்', false);

  -- ── Line 14: என் செவிகளிலே எதிரொலி கேட்கும். ──────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l14, 10, 'என்',
    'என் — my (short genitive form of யான்)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l14, 20, 'செவிகளிலே',
    'செவி + கள் + இலே — in my ears (locative plural with emphatic -லே suffix)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l14, 30, 'எதிரொலி',
    'எதிர் + ஒலி — echo, resonance, reverberation (the sound bouncing back)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l14, 40, 'கேட்கும்',
    'கேட்கும் — will be heard, will resound, will reach (எதிர்காலம்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"கேட்கு","label":"பகுதி (root: கேட்கு — to hear)"},{"part":"உம்","label":"எதிர்கால விகுதி (future tense suffix)"}]');

  -- ── Line 15: கூண்டில் மோதும் சிறகுகளோடு ──────────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l15, 10, 'கூண்டில்',
    'கூண்டு + இல் — in the cage (locative). Symbol of imprisonment and oppression',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l15, 20, 'மோதும்',
    'மோதும் — beating against, striking, clashing (பெயரெச்சம் — modifies சிறகுகள்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"மோது","label":"பகுதி (root: to strike, to beat against, to clash)"},{"part":"உம்","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l15, 30, 'சிறகுகளோடு',
    'சிறகு + கள் + ஓடு — with wings (sociative case plural). Wings that beat against their cage — yearning for freedom',
    'பெயர்ச்சொல்', false);

  -- ── Line 16: எனது சிறகிலும் குருதியின் கோடு! ──────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l16, 10, 'எனது',
    'எனது — my (1st person possessive genitive)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l16, 20, 'சிறகிலும்',
    'சிறகு + இல் + உம் — even in my wing, on my own wing too (locative + inclusive)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l16, 30, 'குருதியின்',
    'குருதி + இன் — of blood (genitive). The blood of solidarity and shared pain',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l16, 40, 'கோடு',
    'கோடு — line, streak, mark, stain. The bloodstain of shared suffering',
    'பெயர்ச்சொல்', false);

  -- ── Line 17: சமயம் கடந்து மானுடம் கூடும் ───────────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l17, 10, 'சமயம்',
    'சமயம் — religion, faith, creed, spiritual belief',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l17, 20, 'கடந்து',
    'கடந்து — having crossed, having transcended, going beyond (வினையெச்சம் — adverbial participle)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"கட","label":"பகுதி (root: கடக்கு — to cross, to transcend)"},{"part":"அந்து","label":"வினையெச்ச விகுதி (adverbial participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l17, 30, 'மானுடம்',
    'மா + நுடம் — humanity, humankind (மா = great, exalted; நுடம் = fineness, subtlety)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l17, 40, 'கூடும்',
    'கூடும் — will gather, will unite, will come together (எதிர்காலம்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"கூடு","label":"பகுதி (root: to gather, to unite, to meet)"},{"part":"உம்","label":"எதிர்கால விகுதி (future tense suffix)"}]');

  -- ── Line 18: சுவர் இல்லாத சமவெளி தோறும் ───────────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l18, 10, 'சுவர்',
    'சுவர் — wall, partition, barrier (symbolic: walls of religion, caste, race)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l18, 20, 'இல்லாத',
    'இல்லாத — without, lacking, not having (எதிர்மறை பெயரெச்சம் — negative adjectival participle)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"இல்","label":"பகுதி — எதிர்மறை (negative root)"},{"part":"ஆ","label":"எதிர்மறை இடைநிலை (negative marker)"},{"part":"த்","label":"சந்தி (euphonic consonant)"},{"part":"அ","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l18, 30, 'சமவெளி',
    'சம + வெளி — open plain, equal expanse, free open space (no walls, no divisions)',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l18, 40, 'தோறும்',
    'தோறும் — throughout, in every, in each and every (distributive postposition)',
    'இடைச்சொல்', false);

  -- ── Line 19: குறிகள் இல்லாத முகங்களில் விழிப்பேன் ──────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l19, 10, 'குறிகள்',
    'குறி + கள் — marks, signs (plural). Religious/caste marks worn on the forehead — symbols of sectarian division',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l19, 20, 'இல்லாத',
    'இல்லாத — without, unmarked, free of marks (எதிர்மறை பெயரெச்சம்)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"இல்","label":"பகுதி — எதிர்மறை (negative root)"},{"part":"ஆ","label":"எதிர்மறை இடைநிலை (negative marker)"},{"part":"த்","label":"சந்தி (euphonic consonant)"},{"part":"அ","label":"பெயரெச்ச விகுதி (adjectival participle suffix)"}]');

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l19, 30, 'முகங்களில்',
    'முகம் + கள் + இல் — in faces, on faces (locative plural). Faces of human beings, unmarked by division',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l19, 40, 'விழிப்பேன்',
    'விழிப்பேன் — I will gaze, I will look, I will see only the human (எதிர்காலம், தன்மை ஒருமை)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"விழி","label":"பகுதி (root: to gaze, to look intently)"},{"part":"ப்","label":"சந்தி (euphonic consonant)"},{"part":"ப்","label":"இடைநிலை — எதிர்காலம் (future tense marker)"},{"part":"ஏன்","label":"விகுதி — தன்மை ஒருமை (1st person singular suffix)"}]');

  -- ── Line 20: மனிதம் என்றொரு பாடலை இசைப்பேன்! ──────────────────────────
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l20, 10, 'மனிதம்',
    'மனிதம் — humanity, human kindness, the quality of being truly human',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l20, 20, 'என்றொரு',
    'என்று + ஓர் — called one, named as, which is called (relative particle + numeral)',
    'இடைச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l20, 30, 'பாடலை',
    'பாடல் + ஐ — the song (accusative case). The song of humanity is what he will sing',
    'பெயர்ச்சொல்', false);

  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, grammatical_label, is_verb)
  VALUES (v_l20, 40, 'இசைப்பேன்',
    'இசைப்பேன் — I will sing, I will play, I will compose music (எதிர்காலம், தன்மை ஒருமை)',
    'வினைச்சொல்', true)
  RETURNING id INTO v_m;
  INSERT INTO verb_analysis (morpheme_id, analysis) VALUES
    (v_m, '[{"part":"இசை","label":"பகுதி (root: to sing, to play music, to harmonize)"},{"part":"ப்","label":"சந்தி (euphonic consonant)"},{"part":"ப்","label":"இடைநிலை — எதிர்காலம் (future tense marker)"},{"part":"ஏன்","label":"விகுதி — தன்மை ஒருமை (1st person singular suffix)"}]');

  RAISE NOTICE 'All morphemes and verb analyses inserted';

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 8. இலக்கிய நயம் — LITERARY NOTES
  -- Linked to the செய்யுள் பகுதி page
  -- ═══════════════════════════════════════════════════════════════════════════

  INSERT INTO literary_notes (page_id, content_text, order_index) VALUES

    (v_page_poem,
     'இயற்கையோடு ஒன்றித்த மனித நேயம்: "ஒவ்வொரு புல்லையும் பெயர் சொல்லி அழைப்பேன்" என்று தொடங்கும் இக்கவிதை, புல், கல், மண் என எல்லா இயற்கை உயிர்களையும் உறவினராகக் கருதும் கவிஞரின் அளவிலா மனிதநேய உணர்வை வெளிப்படுத்துகிறது.',
     10),

    (v_page_poem,
     'தொடையமைதி (Rhyme): "அழைப்பேன் — கடப்பேன் — விளிப்பேன்" என்ற ஈற்றொலி ஒத்திசைவும், "தொடரும் — படரும்", "கடலாய் — துளியாய்" என்ற இணைத்தொடைகளும் கவிதைக்கு இசை நயத்தை அளிக்கின்றன.',
     20),

    (v_page_poem,
     'மாறுகோண இணை (Contrast): "நீளும் கைகளில் தோழமை தொடரும் / நீளாத கையிலும் நெஞ்சம் படரும்" என்னும் இரு வரிகளில் உடல் அளவில் கை நீளாவிட்டாலும் நெஞ்சம் நீளும் என்று கவிஞர் மனித நேயத்தை நுட்பமாக வெளிப்படுத்துகிறார்.',
     30),

    (v_page_poem,
     'கடல்-துளி உவமை: "எனக்கு வேண்டும் உலகம் ஓர் கடலாய் / உலகுக்கு வேண்டும் நானும் ஓர் துளியாய்" என்னும் வரிகளில் கவிஞர் தம்மை ஒரு சிறு துளியாகவும் உலகை ஒரு கடலாகவும் கண்டு, துளி கடலில் கரைவது போல் உலக மனிதர் யாவருடனும் கலந்திட விரும்புகிறார். இது அகம்-பொருள் உவமை அணி (ஒப்புமை).',
     40),

    (v_page_poem,
     'மதச் சமரசம் — மூன்று மதங்களின் குறியீடுகள்: "போதியின் நிழல்" (பௌத்தம்), "சிலுவை" (கிறித்தவம்), "பிறை" (இஸ்லாம்) ஆகிய மூன்றும் "பொங்கும் சமத்துவப்புனலில் கரையும்" என்று கவிஞர் கூறுவது மத வேற்றுமைகளை மீறிய உலக ஒருமையின் கவித்துவ வெளிப்பாடாகும்.',
     50),

    (v_page_poem,
     'எதிரொலி குறியீடு: "எந்த மூலையில் விசும்பல் என்றாலும் / என் செவிகளிலே எதிரொலி கேட்கும்" என்னும் வரிகளில் உலகின் எந்த மூலையிலும் மனித வேதனை இருந்தாலும் அதை உணர்வேன் என்று கவிஞர் கூறுகிறார். இது ஒரு உலகப் பொதுமை (universal empathy) உணர்வாகும்.',
     60),

    (v_page_poem,
     'கூண்டு-சிறகு உருவகம்: "கூண்டில் மோதும் சிறகுகளோடு / எனது சிறகிலும் குருதியின் கோடு" என்னும் வரிகளில் விடுதலையை விரும்பும் சிறகடிக்கும் பறவை விடுதலை வேட்கையின் குறியீடு. சிறகில் குருதியின் கோடு — அடக்குமுறையில் சிக்கிய அனைத்து உயிர்களின் வலியும் கவிஞரின் வலியே என்ற ஒருங்கிணைவு.',
     70),

    (v_page_poem,
     'இறுதி நோக்கம் — மனிதம்: "குறிகள் இல்லாத முகங்களில் விழிப்பேன் / மனிதம் என்றொரு பாடலை இசைப்பேன்" என்னும் இறுதி வரிகளில் சாதி, மதம், இன, பொருளாதார வேறுபாட்டின் குறிகள் இல்லாமல் மனிதர்களை மட்டுமே காண்பேன் என்கிறார் கவிஞர். ''மனிதம்'' என்றொரு பாடல் — இதுவே கவிஞரின் வாழ்க்கை லட்சியம்.',
     80);

  RAISE NOTICE 'Literary notes inserted (8 entries)';
  RAISE NOTICE 'ஒவ்வொரு புல்லையும் — ALL content inserted successfully!';

END $$;

-- ── Verify ───────────────────────────────────────────────────────────────────
SELECT
  t.title                AS topic,
  p.page_type,
  (SELECT COUNT(*) FROM poem_lines   WHERE page_id = p.id) AS poem_lines,
  (SELECT COUNT(*) FROM prose_content WHERE page_id = p.id) AS prose_rows,
  (SELECT COUNT(*) FROM literary_notes WHERE page_id = p.id) AS literary_notes
FROM topics t
JOIN pages p ON p.topic_id = t.id
WHERE t.title = 'ஒவ்வொரு புல்லையும்'
ORDER BY p.page_type;

SELECT
  pl.line_number,
  pl.raw_text,
  COUNT(m.id) AS morpheme_count
FROM poem_lines pl
LEFT JOIN morphemes m ON m.poem_line_id = pl.id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'ஒவ்வொரு புல்லையும்'
GROUP BY pl.line_number, pl.raw_text
ORDER BY pl.line_number;
