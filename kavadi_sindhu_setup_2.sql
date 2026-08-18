-- ============================================================================
-- காவடிச் சிந்து — stanzas 2-3 (lines 6-15) morpheme/word_group breakdown.
-- Run this AFTER kavadi_sindhu_setup_1.sql (which already created lines
-- 6-15's poem_lines rows and cleared their morphemes/word_groups — this
-- script just fills those back in).
--
-- Same line-break convention as stanza 1: a word split across the printed
-- "-" line-break is stored as two separate line-scoped items (e.g. "குற"
-- ending line 6, "வள்ளி" starting line 7, together meaning "குறவள்ளி").
-- ============================================================================

DO $$
DECLARE
  v_topic_id  uuid;
  v_poem_page_id uuid;
  v_group_id  uuid;

  v_l6 uuid; v_l7 uuid; v_l8 uuid; v_l9 uuid; v_l10 uuid;
  v_l11 uuid; v_l12 uuid; v_l13 uuid; v_l14 uuid; v_l15 uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'காவடிச் சிந்து' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'காவடிச் சிந்து topic not found — run kavadi_sindhu_setup_1.sql first.';
  END IF;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  SELECT id INTO v_l6  FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 6;
  SELECT id INTO v_l7  FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 7;
  SELECT id INTO v_l8  FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 8;
  SELECT id INTO v_l9  FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 9;
  SELECT id INTO v_l10 FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 10;
  SELECT id INTO v_l11 FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 11;
  SELECT id INTO v_l12 FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 12;
  SELECT id INTO v_l13 FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 13;
  SELECT id INTO v_l14 FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 14;
  SELECT id INTO v_l15 FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 15;

  IF v_l6 IS NULL OR v_l15 IS NULL THEN
    RAISE EXCEPTION 'Lines 6-15 not found — run kavadi_sindhu_setup_1.sql first.';
  END IF;

  -- Clean slate (safe to re-run)
  DELETE FROM morphemes   WHERE poem_line_id IN (v_l6,v_l7,v_l8,v_l9,v_l10,v_l11,v_l12,v_l13,v_l14,v_l15);
  DELETE FROM word_groups WHERE poem_line_id IN (v_l6,v_l7,v_l8,v_l9,v_l10,v_l11,v_l12,v_l13,v_l14,v_l15);

  ----------------------------------------------------------------
  -- LINE 6: வன்ன மயில்முரு கேசன் - குற
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l6, 1, 'வன்னமயில்', 'வன்னமயில் = அழகிய மயில்; beautiful peacock (Murugan''s vehicle)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l6, 1, 'வன்னம்', 'அழகு; beauty', false, v_group_id),
    (v_l6, 2, 'மயில்', 'மயில்; peacock', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l6, 3, 'முருகேசன்', 'முருகேசன் = முருகன் என்னும் ஈசன்; Lord Murugan') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l6, 3, 'முரு', 'முருகன் என்னும் பெயரின் பகுதி; part of ''Muruga''', false, v_group_id),
    (v_l6, 4, 'கேசன்', 'ஈசன் (திரிபு); lord (name-ending)', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l6, 5, 'குற', 'குறத்தி இனத்தைச் சேர்ந்த (குறவள்ளி); of the Kurava tribe — continues into line 7''s வள்ளி → குறவள்ளி', false, NULL);

  ----------------------------------------------------------------
  -- LINE 7: வள்ளி பதம்பணி நேசன் - உரை
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l7, 1, 'வள்ளி', 'வள்ளி (முருகனின் மனைவி) — தொடர்கிறது line 6''s குற → குறவள்ளி; Valli, Murugan''s consort', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l7, 2, 'பதம்பணிநேசன்', 'பதம் பணி நேசன் = (வள்ளியின்) பாதங்களைப் பணியும் அன்பன்; the devoted one who serves/worships (Valli''s) feet') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l7, 2, 'பதம்', 'பாதம்; feet', false, v_group_id),
    (v_l7, 3, 'பணி', 'பணிதல்; to serve, worship', false, v_group_id),
    (v_l7, 4, 'நேசன்', 'அன்பன்; devoted one, lover', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l7, 5, 'உரை', 'சொல்/பேச்சு (தொடர்கிறது line 8''s வரமேதரு உடன்); word, speech — continues into line 8', false, NULL);

  ----------------------------------------------------------------
  -- LINE 8: வரமேதரு கழுகாசல
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l8, 1, 'வரமேதரு', 'உரை வரமே தரு = பேசும் ஆற்றல் என்னும் வரத்தையே தருகின்ற; that grants the very boon of speech') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 1, 'வரம்', 'வரம்; boon', false, v_group_id),
    (v_l8, 2, 'ஏ', 'சிறப்பு இடைச்சொல் (அழுத்தம்); emphatic ''indeed/only''', false, v_group_id),
    (v_l8, 3, 'தரு', 'தருகின்ற; that gives/grants', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l8, 4, 'கழுகாசலம்', 'கழுகாசலம் = கழுகுமலை (ஊர்ப்பெயர்) — தொடர்கிறது line 9''s பதி உடன் → கழுகாசலபதி; Kazhugumalai (place name), continues into line 9') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 4, 'கழுகு', 'கழுகு; vulture/eagle', false, v_group_id),
    (v_l8, 5, 'ஆசலம்', 'மலை; mountain', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 9: பதிகோயிலின் வளம்நான்மற
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 1, 'பதி', 'தலைவன் (கழுகாசலபதி = கழுகுமலைத் தலைவன்) — தொடர்கிறது line 8''s கழுகாசலம் உடன்; lord (of Kazhugumalai), completes line 8''s word', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l9, 2, 'கோயிலின்', 'கோயிலின் = கோயிலுடைய; of the temple') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 2, 'கோயில்', 'கோயில்; temple', false, v_group_id),
    (v_l9, 3, 'இன்', 'ஆறாம் வேற்றுமை உருபு; genitive ''of''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 4, 'வளம்', 'செழிப்பு, சிறப்பு; prosperity, grandeur', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 5, 'நான்', 'நான் (பேசுபவர்); I (the poet)', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 6, 'மற', 'மறவாது (தொடர்கிறது line 10''s வாதே உடன் → மறவாதே); without forgetting — continues into line 10', false, NULL);

  ----------------------------------------------------------------
  -- LINE 10: வாதே சொல்வன் மாதே!
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 1, 'வாதே', 'வாது + ஏ (எதிர்மறை + அழுத்தம்) — தொடர்கிறது line 9''s மற உடன் → மறவாதே; ''without ever forgetting'', completes line 9''s word', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l10, 2, 'சொல்வன்', 'சொல்வன் = சொல்லுவேன்; I shall say/tell') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 2, 'சொல்', 'சொல்லுதல் பகுதி; to say, tell', false, v_group_id),
    (v_l10, 3, 'வன்', 'தன்மை ஒருமை எதிர்கால வினைமுற்று விகுதி; 1st person future ''I will''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 4, 'மாதே', 'பெண்ணே! (விளி); O woman! (vocative address)', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 5, '!', 'வியப்புக் குறியீடு', true, NULL);

  ----------------------------------------------------------------
  -- LINE 11: கோபுரத் துத்தங்கத் தூவி - தேவர்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l11, 1, 'கோபுரத்து', 'கோபுரத்து = கோபுரத்தினுடைய; of the temple tower') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l11, 1, 'கோபுரம்', 'கோபுரம்; temple tower', false, v_group_id),
    (v_l11, 2, 'து', 'ஆறாம் வேற்றுமை உருபு; genitive ''of''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l11, 3, 'தங்கத்தூவி', 'தங்கத் தூவி = தங்கத்தாலான உச்சி/கலசம்; the golden crest/pinnacle (of the tower)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l11, 3, 'தங்கம்', 'பொன்; gold', false, v_group_id),
    (v_l11, 4, 'தூவி', 'உச்சி, கலசம் (பறவையின் இறகுச் சூடு போன்றது); crest, pinnacle', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l11, 5, 'தேவர்', 'தேவர்கள் (உலகு) — தொடர்கிறது line 12 உடன்; the celestial world of the devas — continues into line 12', false, NULL);

  ----------------------------------------------------------------
  -- LINE 12: கோபுரத் துக்கப்பால் மேவி - கண்கள்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l12, 1, 'கோபுரத்துக்கப்பால்', 'தேவர் கோபுரத்துக்கு அப்பால் = தேவருலகக் கோபுரத்தையும் தாண்டி; beyond even the deva-world''s tower — completes line 11''s தேவர்') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l12, 1, 'கோபுரத்து', 'கோபுரத்தின்; of the tower', false, v_group_id),
    (v_l12, 2, 'க்கு', 'நான்காம் வேற்றுமை உருபு; dative ''to''', false, v_group_id),
    (v_l12, 3, 'அப்பால்', 'அப்பாற்பட்டு; beyond', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l12, 4, 'மேவி', 'எட்டி/பரவி (உயர்ந்து); reaching, pervading, spreading', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l12, 5, 'கண்கள்', 'கண்கள் — தொடர்கிறது line 13''s கூச உடன்; eyes — continues into line 13', false, NULL);

  ----------------------------------------------------------------
  -- LINE 13: கூசப்பிர காசத்தொளி
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l13, 1, 'கூச', 'கூசும்படி (கண்கள் கூச) — தொடர்கிறது line 12''s கண்கள் உடன்; so as to dazzle (the eyes) — completes line 12''s phrase', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l13, 2, 'பிரகாசத்தொளி', 'பிரகாசத்து ஒளி = ஒளிமிக்க பிரகாசம்; the radiant brilliance/light') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l13, 2, 'பிரகாசம்', 'ஒளி, பிரகாசம்; brilliance, radiance', false, v_group_id),
    (v_l13, 3, 'அத்து', 'ஆறாம் வேற்றுமை உருபு; genitive ''of''', false, v_group_id),
    (v_l13, 4, 'ஒளி', 'ஒளி; light', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 14: மாசற்று விலாசத்தொடு
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l14, 1, 'மாசற்று', 'மாசு அற்று = குற்றமின்றி, தூய்மையாக; without blemish, purely') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l14, 1, 'மாசு', 'குற்றம், அழுக்கு; blemish, dirt', false, v_group_id),
    (v_l14, 2, 'அற்று', 'இன்றி; without', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l14, 3, 'விலாசத்தொடு', 'விலாசத்தொடு = அழகுடன்; with splendor/beauty') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l14, 3, 'விலாசம்', 'அழகு; splendor, beauty', false, v_group_id),
    (v_l14, 4, 'ஒடு', 'உடன் வேற்றுமை உருபு; comitative ''with''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 15: குலவும் புவி பலவும்.
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 1, 'குலவும்', 'பரவும், விளங்கும்; spreads, shines forth', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 2, 'புவி', 'உலகம்; world, earth', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l15, 3, 'பலவும்', 'பலவும் = பலவற்றிலும்; in many (worlds)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 3, 'பல', 'பல; many', false, v_group_id),
    (v_l15, 4, 'உம்', 'சிறப்பும்மை; ''even/also''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 5, '.', 'முற்றுப்புள்ளி', true, NULL);

  RAISE NOTICE '✓ Stanzas 2-3 (lines 6-15) done.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, pl.raw_text, count(wg.id) AS word_groups
FROM poem_lines pl
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
LEFT JOIN word_groups wg ON wg.poem_line_id = pl.id
WHERE t.title = 'காவடிச் சிந்து' AND p.page_type = 'செய்யுள் பகுதி' AND pl.line_number BETWEEN 6 AND 15
GROUP BY pl.line_number, pl.raw_text
ORDER BY pl.line_number;
