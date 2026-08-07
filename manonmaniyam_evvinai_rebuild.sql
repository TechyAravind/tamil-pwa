-- ============================================================================
-- மனோன்மணீயம் — full sandhi (புணர்ச்சி) rebuild from எவ்வினை.docx
--
-- This does two things:
--  PART A: restructures 19 lines' word_groups/morphemes where the docx asked
--    for a different root split, a corrected token, or "different boxes"
--    (splitting one merged box into two). Each such line is fully rebuilt
--    (old word_groups/morphemes for that line deleted, then re-inserted with
--    fresh positions) so the box layout matches exactly.
--  PART B: adds a sandhi_rules row for every "A + B = C" combine step in the
--    document — both for the newly restructured boxes and for all the
--    existing boxes that didn't need restructuring — so tapping "+" shows
--    the textbook-correct combined form at every step, not just the final
--    word.
--
-- A few spots where the docx had an apparent typo (ஒகோ vs ஓகோ, பார்த்துபார்த்து
-- vs பார்த்துப்பார்த்து, விழும்+இய=விழும்+இய) were corrected to match the
-- poem's own raw_text spelling — flagged inline below.
--
-- Run this AFTER manonmaniyam_full_setup.sql, manonmaniyam_other_content.sql,
-- manonmaniyam_sandhi_from_doc2.sql and manonmaniyam_sandhi_similar_patterns.sql.
-- Safe to re-run.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_poem_page_id uuid;
  v_group_id uuid;

  g_10_1 uuid;
  g_10_2 uuid;
  g_10_3 uuid;
  g_10_4 uuid;
  g_11_1 uuid;
  g_11_2 uuid;
  g_11_3 uuid;
  g_12_1 uuid;
  g_12_2 uuid;
  g_12_3 uuid;
  g_12_4 uuid;
  g_14_1 uuid;
  g_14_2 uuid;
  g_14_3 uuid;
  g_14_4 uuid;
  g_15_1 uuid;
  g_15_2 uuid;
  g_15_3 uuid;
  g_16_1 uuid;
  g_16_2 uuid;
  g_16_3 uuid;
  g_16_4 uuid;
  g_17_1 uuid;
  g_17_2 uuid;
  g_17_3 uuid;
  g_17_4 uuid;
  g_17_5 uuid;
  g_19_1 uuid;
  g_19_2 uuid;
  g_19_3 uuid;
  g_19_4 uuid;
  g_19_5 uuid;
  g_22_1 uuid;
  g_22_2 uuid;
  g_22_3 uuid;
  g_23_1 uuid;
  g_23_2 uuid;
  g_23_3 uuid;
  g_23_4 uuid;
  g_24_1 uuid;
  g_24_2 uuid;
  g_24_3 uuid;
  g_24_4 uuid;
  g_31_1 uuid;
  g_31_2 uuid;
  g_31_3 uuid;
  g_33_1 uuid;
  g_33_2 uuid;
  g_33_3 uuid;
  g_33_4 uuid;
  g_33_5 uuid;
  g_35_1 uuid;
  g_35_2 uuid;
  g_35_3 uuid;
  g_35_4 uuid;
  g_37_1 uuid;
  g_37_2 uuid;
  g_37_3 uuid;
  g_37_4 uuid;
  g_43_1 uuid;
  g_43_2 uuid;
  g_43_3 uuid;
  g_43_4 uuid;
  g_44_1 uuid;
  g_44_2 uuid;
  g_44_3 uuid;
  g_44_4 uuid;
  g_44_5 uuid;
  g_45_1 uuid;
  g_45_2 uuid;
  g_45_3 uuid;
  g_45_4 uuid;
  g_47_1 uuid;
  g_47_2 uuid;
  g_47_3 uuid;
  g_47_4 uuid;
  v_l uuid;  -- scratch poem_line id
BEGIN

  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'மனோன்மணீயம் topic not found.';
  END IF;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  ------------------------------------------------------------------
  -- PART A: restructure the 19 lines
  ------------------------------------------------------------------


  -- ---- Line 10 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 10;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'அதுஅன்', 'அதுஅன் = அது + அன் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_10_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'அது', 'அது; that', false, v_group_id),
    (v_l, 2, 'அன்', 'சாரியை; possessive/genitive glide ''of''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 3, 'சிறுபூக்குலை', 'சிறுபூக்குலை = சிறுமை + பூ + குலை இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_10_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 3, 'சிறுமை', 'சிறிய தன்மை; smallness (adjectival root, drops ''மை'' on combining)', false, v_group_id),
    (v_l, 4, 'பூ', 'பூக்கள்; flower', false, v_group_id),
    (v_l, 5, 'குலை', 'கொத்து; cluster, bunch', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 6, 'அடியொன்று', 'அடியொன்று = அடி + ஒன்று இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_10_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 6, 'அடி', 'அடிப்பாகம், தண்டு; base, stalk', false, v_group_id),
    (v_l, 7, 'ஒன்று', 'ஒரு; one', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 8, 'உயர்த்தி', 'உயர்த்தி = உயர் + த் + த் + இ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_10_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 8, 'உயர்', 'உயர்தல் பகுதி; to rise, raise', false, v_group_id),
    (v_l, 9, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 10, 'த்', 'இறந்தகால இடைநிலை; past tense marker', false, v_group_id),
    (v_l, 11, 'இ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);

  -- ---- Line 11 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 11;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'இதமுறத்தேன்துளி', 'இதமுறத்தேன்துளி = இதம் + உற + தேன் + துளி இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_11_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'இதம்', 'இன்பம், நலம்; pleasantness', false, v_group_id),
    (v_l, 2, 'உற', 'அடையும்படி; so as to attain (adverbial)', false, v_group_id),
    (v_l, 3, 'தேன்', 'தேன்; honey', false, v_group_id),
    (v_l, 4, 'துளி', 'துளி; drop', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'தாங்கி', 'தாங்கி = தாங்கு + இ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_11_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'தாங்கு', 'தாங்குதல் பகுதி; to bear, hold', false, v_group_id),
    (v_l, 6, 'இ', 'வினையெச்ச விகுதி; ''-ing''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'ஈக்களை', 'ஈக்களை = ஈ + கள் + ஐ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_11_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'ஈ', 'ஈ; fly', false, v_group_id),
    (v_l, 8, 'கள்', 'பன்மை விகுதி; plural marker', false, v_group_id),
    (v_l, 9, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id);

  -- ---- Line 12 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 12;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'நலமுற', 'நலமுற = நலம் + உற இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_12_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'நலம்', 'நன்மை; welfare, goodness', false, v_group_id),
    (v_l, 2, 'உற', 'அடையும்படி; so as to attain (adverbial)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 3, 'அழைத்து', 'அழைத்து = அழை + த் + த் + உ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_12_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 3, 'அழை', 'அழைத்தல் பகுதி; to call, invite', false, v_group_id),
    (v_l, 4, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 5, 'த்', 'இறந்தகால இடைநிலை; past tense marker', false, v_group_id),
    (v_l, 6, 'உ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'நல்லூண்', 'நல்லூண் = நல் + ஊண் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_12_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'நல்', 'நல்ல; good', false, v_group_id),
    (v_l, 8, 'ஊண்', 'உணவு; food, feast', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 9, 'அருத்தி', 'அருத்தி = அருத்து + இ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_12_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 9, 'அருத்து', 'ஊட்டுதல் பகுதி; to feed', false, v_group_id),
    (v_l, 10, 'இ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);

  -- ---- Line 14 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 14;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'ஆசுஇலாச்சிறுகாய்', 'ஆசுஇலாச்சிறுகாய் = ஆசு + இலா + சிறுமை + காய் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_14_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'ஆசு', 'குற்றம்; blemish, fault', false, v_group_id),
    (v_l, 2, 'இலா', 'இல்லாத; without', false, v_group_id),
    (v_l, 3, 'சிறுமை', 'சிறிய தன்மை; smallness (adjectival root, drops ''மை'' on combining)', false, v_group_id),
    (v_l, 4, 'காய்', 'காய்; fruit', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'ஆக்கி', 'ஆக்கி = ஆக்கு + இ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_14_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'ஆக்கு', 'உண்டாக்குதல் பகுதி; to make, produce', false, v_group_id),
    (v_l, 6, 'இ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'இதோ', 'இதோ = இது + ஓ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_14_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'இது', 'இது; this', false, v_group_id),
    (v_l, 8, 'ஓ', 'வியப்புக்குறிப்பு இடைச்சொல்; exclamatory ''oh''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 9, 'என்', 'எனது; my', false, NULL);

  -- ---- Line 15 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 15;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'தூசிடைச்சிக்கும்', 'தூசிடைச்சிக்கும் = தூசு + இடை + சிக்கு + உம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_15_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'தூசு', 'புழுதி; dust', false, v_group_id),
    (v_l, 2, 'இடை', 'இடையில், நடுவில்; amid, between', false, v_group_id),
    (v_l, 3, 'சிக்கு', 'சிக்கிக்கொள்ளுதல் பகுதி; to get caught, entangled', false, v_group_id),
    (v_l, 4, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'தோட்டியும்', 'தோட்டியும் = தோட்டி + உம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_15_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'தோட்டி', 'துறட்டி/முள்கோல்; hook, goad', false, v_group_id),
    (v_l, 6, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'கொடுத்தே', 'கொடுத்தே = கொடு + த் + த் + ஏ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_15_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'கொடு', 'கொடுத்தல் பகுதி; to give', false, v_group_id),
    (v_l, 8, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 9, 'த்', 'இறந்தகால இடைநிலை; past tense marker', false, v_group_id),
    (v_l, 10, 'ஏ', 'வினையெச்ச விகுதி (அழுத்தம்); ''-having done, indeed''', false, v_group_id);

  -- ---- Line 16 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 16;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'இவ்வயின்', 'இவ்வயின் = இ + வயின் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_16_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'இ', 'சுட்டு இடைச்சொல்; demonstrative ''this''', false, v_group_id),
    (v_l, 2, 'வயின்', 'இடம்; place, spot', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 3, 'யாமெலாம்', 'யாமெலாம் = யாம் + எலாம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_16_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 3, 'யாம்', 'நாங்கள்; we', false, v_group_id),
    (v_l, 4, 'எலாம்', 'எல்லாம்; all', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'செவ்விதில்', 'செவ்விதில் = செவ்வி + து + இல் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_16_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'செவ்வி', 'ஏற்ற தருணம்; the right, opportune time', false, v_group_id),
    (v_l, 6, 'து', 'அஃறிணைப் பெயரெச்ச விகுதி (இது என்பதன் குறுகிய வடிவு)', false, v_group_id),
    (v_l, 7, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''in''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 8, 'துன்னில்', 'துன்னில் = துன் + இல் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_16_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 8, 'துன்', 'நெருங்குதல் பகுதி; to approach, draw near', false, v_group_id),
    (v_l, 9, 'இல்', 'நிபந்தனை இடைநிலை; conditional ''if''', false, v_group_id);

  -- ---- Line 17 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 17;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'தழைப்பதற்கு', 'தழைப்பதற்கு = தழைப்ப் + அது + அல் + கு இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_17_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'தழைப்ப்', 'தழைத்தல் பகுதி + சந்தி மெய் (தழை+ப்+ப் இணைந்த வடிவு); to flourish', false, v_group_id),
    (v_l, 2, 'அது', 'தொழிற்பெயர் விகுதி; verbal-noun ''-ing''', false, v_group_id),
    (v_l, 3, 'அல்', 'எதிர்மறை/உருபு இடைநிலை; glide', false, v_group_id),
    (v_l, 4, 'கு', 'நான்காம் வேற்றுமை உருபு; dative infinitive ''in order to''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'இடமிலை', 'இடமிலை = இடம் + இலை இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_17_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'இடம்', 'இடம், வெளி; space, place', false, v_group_id),
    (v_l, 6, 'இலை', 'இல்லை; not present, absent', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'சிறார்', 'சிறார் = சிறுமை + ஆர் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_17_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'சிறுமை', 'சிறிய தன்மை; smallness (root for ''young ones'')', false, v_group_id),
    (v_l, 8, 'ஆர்', 'பலர்பால் விகுதி; plural person suffix', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 9, 'நீர்', 'நீங்கள் (முன்னிலைப் பன்மை பழந்தமிழ் வடிவம்); you (archaic plural/respectful)', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 10, 'பிழைப்பதற்கு', 'பிழைப்பதற்கு = பிழைப்ப் + அது + அல் + கு இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_17_5 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 10, 'பிழைப்ப்', 'பிழைத்தல் பகுதி + சந்தி மெய் (பிழை+ப்+ப் இணைந்த வடிவு); to survive, escape', false, v_group_id),
    (v_l, 11, 'அது', 'தொழிற்பெயர் விகுதி; verbal-noun ''-ing''', false, v_group_id),
    (v_l, 12, 'அல்', 'எதிர்மறை/உருபு இடைநிலை; glide', false, v_group_id),
    (v_l, 13, 'கு', 'நான்காம் வேற்றுமை உருபு; dative infinitive ''in order to''', false, v_group_id);

  -- ---- Line 19 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 19;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'சிக்கி', 'சிக்கி = சிக்கு + இ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_19_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'சிக்கு', 'சிக்கிக்கொள்ளுதல் பகுதி; to get entangled', false, v_group_id),
    (v_l, 2, 'இ', 'வினையெச்ச விகுதி; ''-ing''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 3, 'நீர்', 'நீங்கள்; you (plural, archaic)', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 4, 'சென்மின்', 'சென்மின் = செல் + மின் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_19_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 4, 'செல்', 'செல்தல் பகுதி; to go', false, v_group_id),
    (v_l, 5, 'மின்', 'ஏவல் பன்மை விகுதி; imperative plural', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 6, 'எனத்தன்', 'எனத்தன் = என + தன் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_19_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 6, 'என', 'எனக்கூறி; saying', false, v_group_id),
    (v_l, 7, 'தன்', 'தன்னுடைய; his own', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 8, 'சிறுவரைப்', 'சிறுவரைப் = சிறுமை + அர் + ஐ + ப் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_19_5 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 8, 'சிறுமை', 'சிறிய தன்மை; smallness (root for ''young ones'')', false, v_group_id),
    (v_l, 9, 'அர்', 'பலர்பால் விகுதி; plural suffix', false, v_group_id),
    (v_l, 10, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id),
    (v_l, 11, 'ப்', 'சந்தி எழுத்து; glide', false, v_group_id);

  -- ---- Line 22 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 22;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'சிறுமையாச்சிந்தனை', 'சிறுமையாச்சிந்தனை = சிறுமை + ஆ + ச் + சிந்தனை இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_22_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'சிறுமை', 'சிறுமை, சிறியது; smallness, pettiness', false, v_group_id),
    (v_l, 2, 'ஆ', 'ஆக; as, in the manner of', false, v_group_id),
    (v_l, 3, 'ச்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 4, 'சிந்தனை', 'எண்ணம்; thought', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'செயாது', 'செயாது = செய் + ஆது இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_22_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'செய்', 'செய்தல் பகுதி; to do', false, v_group_id),
    (v_l, 6, 'ஆது', 'எதிர்மறை வினையெச்ச விகுதி; ''without doing'' (negative)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'ஆங்காங்கு', 'ஆங்காங்கு = ஆங்கு + ஆங்கு இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_22_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'ஆங்கு', 'அங்கு; there', false, v_group_id),
    (v_l, 8, 'ஆங்கு', '''அங்கு'' மீண்டும் (அடுக்குத் தொடர்); there (repeated = ''here and there'')', false, v_group_id);

  -- ---- Line 23 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 23;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'தோற்று', 'தோன்றி, வெளிப்படுத்தி; displaying, appearing', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 2, 'பேரழகும்', 'பேரழகும் = பெருமை + அழகு + உம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_23_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 2, 'பெருமை', 'பெருமை; greatness', false, v_group_id),
    (v_l, 3, 'அழகு', 'அழகு; beauty', false, v_group_id),
    (v_l, 4, 'உம்', 'உம்மைத் தொகை; ''and, too''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'ஆற்றல்சால்', 'ஆற்றல்சால் = ஆற்றல் + சால் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_23_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'ஆற்றல்', 'வலிமை, திறன்; strength, capability', false, v_group_id),
    (v_l, 6, 'சால்', 'நிறைந்த; abounding in, full of', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'அன்புஉம்', 'அன்புஉம் = அன்பு + உம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_23_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'அன்பு', 'அன்பு; love', false, v_group_id),
    (v_l, 8, 'உம்', 'உம்மைத் தொகை; ''and, too''', false, v_group_id);

  -- ---- Line 24 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 24;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'போற்றுதம்', 'போற்றுதம் = போற்று + தம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_24_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'போற்று', 'போற்றுதல் பகுதி; to cherish, nurture', false, v_group_id),
    (v_l, 2, 'தம்', 'தம்முடைய; their own', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 3, 'குறிப்பிற்கு', 'குறிப்பிற்கு = குறிப்பு + இல் + கு இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_24_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 3, 'குறிப்பு', 'நோக்கம்; purpose, intention', false, v_group_id),
    (v_l, 4, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative glide', false, v_group_id),
    (v_l, 5, 'கு', 'நான்காம் வேற்றுமை உருபு; dative ''for''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 6, 'ஏற்றதோர்', 'ஏற்றதோர் = ஏல் + து + அ + து + ஓர் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_24_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 6, 'ஏல்', 'ஏலுதல் பகுதி; to befit, be fitting', false, v_group_id),
    (v_l, 7, 'து', 'தொழிற்பெயர் இடைநிலை', false, v_group_id),
    (v_l, 8, 'அ', 'பெயரெச்ச விகுதி', false, v_group_id),
    (v_l, 9, 'து', 'சாரியை/இடைநிலை', false, v_group_id),
    (v_l, 10, 'ஓர்', 'ஒரு; a, one', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 11, 'முயற்சியும்', 'முயற்சியும் = முயற்சி + உம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_24_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 11, 'முயற்சி', 'முயற்சி; effort, endeavour', false, v_group_id),
    (v_l, 12, 'உம்', 'உம்மைத் தொகை; ''and, too''', false, v_group_id);

  -- ---- Line 31 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 31;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'உழுவோர்க்கெல்லாம்', 'உழுவோர்க்கெல்லாம் = உழு + ஓர் + கு + எல்லாம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_31_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'உழு', 'உழுதல் பகுதி; to plough', false, v_group_id),
    (v_l, 2, 'ஓர்', 'செய்வோர் பெயர்ச்சொல் விகுதி; agentive ''those who''', false, v_group_id),
    (v_l, 3, 'கு', 'நான்காம் வேற்றுமை உருபு; dative ''to''', false, v_group_id),
    (v_l, 4, 'எல்லாம்', 'எல்லாம்; all', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'விழுமிய', 'விழுமிய = விழும் + இய இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_31_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'விழும்', 'மேன்மை, சிறப்பு; excellence (adjectival root of விழுமிய)', false, v_group_id),
    (v_l, 6, 'இய', 'பண்புப் பெயரெச்ச விகுதி; adjectival ''-ous''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'வேந்துநீ', 'வேந்துநீ = வேந்து + நீ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_31_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'வேந்து', 'அரசன்; king', false, v_group_id),
    (v_l, 8, 'நீ', 'நீ; you', false, v_group_id);

  -- ---- Line 33 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 33;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'விடுத்தனை', 'விடுத்தனை = விடு + த் + த் + அன் + ஐ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_33_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'விடு', 'விடுதல் பகுதி; to release, let go', false, v_group_id),
    (v_l, 2, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 3, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l, 4, 'அன்', 'சாரியை; euphonic glide', false, v_group_id),
    (v_l, 5, 'ஐ', 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person singular ending', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 6, 'இதற்கா', 'இதற்கா = இது + அன் + கு + ஆ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_33_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 6, 'இது', 'இது; this', false, v_group_id),
    (v_l, 7, 'அன்', 'சாரியை; possessive/euphonic glide', false, v_group_id),
    (v_l, 8, 'கு', 'நான்காம் வேற்றுமை உருபு; dative ''to''', false, v_group_id),
    (v_l, 9, 'ஆ', 'காரணமாக; because, for the sake of', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 10, 'எடுத்த', 'எடுத்த = எடு + த் + த் + அ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_33_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 10, 'எடு', 'எடுத்தல் பகுதி; to take, lift', false, v_group_id),
    (v_l, 11, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 12, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l, 13, 'அ', 'பெயரெச்ச விகுதி; adjectival ending', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 14, 'உன்', 'உனது; your', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 15, 'யாக்கை', 'உடல்; body', false, NULL);

  -- ---- Line 35 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 35;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'விழுமிய', 'விழுமிய = விழும் + இய இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_35_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'விழும்', 'மேன்மை, சிறப்பு; excellence (adjectival root of விழுமிய)', false, v_group_id),
    (v_l, 2, 'இய', 'பண்புப் பெயரெச்ச விகுதி; adjectival ''-ous''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 3, 'சேறுஆய்', 'சேறுஆய் = சேறு + ஆய் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_35_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 3, 'சேறு', 'சேறு, களிமண்; mud, clay', false, v_group_id),
    (v_l, 4, 'ஆய்', 'ஒப்புமை வினையெச்ச விகுதி; adverbial ''as''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'வேதித்த்உ', 'வேதித்த்உ = வேதி + த் + த் + உ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_35_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'வேதி', 'மாற்றுதல் பகுதி; to transform, change', false, v_group_id),
    (v_l, 6, 'த்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 7, 'த்', 'இறந்தகால இடைநிலை; past marker', false, v_group_id),
    (v_l, 8, 'உ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 9, 'உருட்டுஇ', 'உருட்டுஇ = உருட்டு + இ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_35_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 9, 'உருட்டு', 'உருட்டுதல் பகுதி; to roll', false, v_group_id),
    (v_l, 10, 'இ', 'வினையெச்ச விகுதி; ''-having done''', false, v_group_id);

  -- ---- Line 37 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 37;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'ஒளிக்குவை', 'ஒளிக்குவை = ஒளி + க் + கு + வை இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_37_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'ஒளி', 'ஒளித்தல் பகுதி; to hide, conceal', false, v_group_id),
    (v_l, 2, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 3, 'கு', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 4, 'வை', 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person ''you [do]''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'உன்குழி', 'உன்குழி = உன் + குழி இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_37_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'உன்', 'உன்னுடைய; your', false, v_group_id),
    (v_l, 6, 'குழி', 'குழி; pit, hole', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'வாயுமோர்', 'வாயுமோர் = வாய் + உம் + ஓர் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_37_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'வாய்', 'வாய், துவாரம்; mouth, opening', false, v_group_id),
    (v_l, 8, 'உம்', 'சிறப்பும்மை; ''also, too''', false, v_group_id),
    (v_l, 9, 'ஓர்', 'ஒரு; a', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 10, 'உருண்டையால்', 'உருண்டையால் = உருண்டை + ஆல் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_37_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 10, 'உருண்டை', 'உருண்டை; ball, round lump', false, v_group_id),
    (v_l, 11, 'ஆல்', 'மூன்றாம் வேற்றுமை உருபு; instrumental ''with''', false, v_group_id);

  -- ---- Line 43 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 43;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'விழுப்புகழ்', 'விழுப்புகழ் = விழும் + புகழ் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_43_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'விழும்', 'மேன்மை, சிறப்பு; excellence (adjectival root of விழுப்புகழ்)', false, v_group_id),
    (v_l, 2, 'புகழ்', 'புகழ்; fame', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 3, 'வேண்டலை', 'வேண்டலை = வேண்டு + அல் + ஐ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_43_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 3, 'வேண்டு', 'வேண்டுதல் பகுதி; to desire, want', false, v_group_id),
    (v_l, 4, 'அல்', 'எதிர்மறை இடைநிலை; negative glide', false, v_group_id),
    (v_l, 5, 'ஐ', 'முன்னிலை ஒருமை எதிர்மறை வினைமுற்று விகுதி; 2nd person negative ending', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 6, 'அறிவோம்', 'அறிவோம் = அறி + வ் + ஓம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_43_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 6, 'அறி', 'அறிதல் பகுதி; to know', false, v_group_id),
    (v_l, 7, 'வ்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 8, 'ஓம்', 'தன்மைப் பன்மை வினைமுற்று விகுதி; 1st person plural ''we''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 9, 'ஏனிது', 'ஏனிது = ஏன் + இது இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_43_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 9, 'ஏன்', 'ஏன்; why', false, v_group_id),
    (v_l, 10, 'இது', 'இது; this', false, v_group_id);

  -- ---- Line 44 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 44;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'துதிக்கலம்', 'துதிக்கலம் = துதி + க் + க் + அல் + அம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_44_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'துதி', 'துதித்தல் பகுதி; to praise', false, v_group_id),
    (v_l, 2, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 3, 'க்', 'சந்தி எழுத்து; glide', false, v_group_id),
    (v_l, 4, 'அல்', 'எதிர்மறை இடைநிலை; negative glide', false, v_group_id),
    (v_l, 5, 'அம்', 'தன்மைப் பன்மை எதிர்மறை வினைமுற்று விகுதி; 1st person plural negative', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 6, 'உன்தொழில்', 'உன்தொழில் = உன் + தொழில் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_44_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 6, 'உன்', 'உன்னுடைய; your', false, v_group_id),
    (v_l, 7, 'தொழில்', 'தொழில், வேலை; task, occupation', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 8, 'நடத்துதி', 'நடத்துதி = நடத்து + தி இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_44_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 8, 'நடத்து', 'நடத்துதல் பகுதி; to conduct, carry out', false, v_group_id),
    (v_l, 9, 'தி', 'முன்னிலை ஒருமை வினைமுற்று விகுதி; 2nd person ''you [do]''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 10, 'ஆ', 'வியப்புக்குறிப்பு இடைச்சொல்; exclamation ''Ah!''', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 11, 'ஆ', 'வியப்புக்குறிப்பு இடைச்சொல் (மீண்டும்); exclamation ''Ah!'' (repeated)', false, NULL);

  -- ---- Line 45 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 45;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'எங்கும்', 'எங்கும் = எங்கு + உம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_45_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'எங்கு', 'எங்கு; where, everywhere', false, v_group_id),
    (v_l, 2, 'உம்', 'சிறப்பும்மை; ''also, even''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 3, 'இங்ஙனே', 'இங்ஙனே = இ + ஙனம் + ஏ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_45_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 3, 'இ', 'சுட்டு இடைச்சொல்; demonstrative ''this''', false, v_group_id),
    (v_l, 4, 'ஙனம்', 'விதம், முறை; manner, way', false, v_group_id),
    (v_l, 5, 'ஏ', 'அழுத்தச் சொல்; emphatic particle', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 6, 'இணைஇலா', 'இணைஇலா = இணை + இலா இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_45_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 6, 'இணை', 'இணை, ஒப்பு; equal, match', false, v_group_id),
    (v_l, 7, 'இலா', 'இல்லாத; without', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 8, 'இன்பும்', 'இன்பும் = இன்பு + உம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_45_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 8, 'இன்பு', 'இன்பம்; joy, happiness', false, v_group_id),
    (v_l, 9, 'உம்', 'சிறப்பும்மை; ''also, even''', false, v_group_id);

  -- ---- Line 47 ----
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 47;
  DELETE FROM morphemes WHERE poem_line_id = v_l;
  DELETE FROM word_groups WHERE poem_line_id = v_l;
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 1, 'வாணாள்', 'வாணாள் = காண் + ஆர் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_47_1 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 1, 'காண்', 'காணுதல் பகுதி; to see', false, v_group_id),
    (v_l, 2, 'ஆர்', 'எதிர்மறைப் பலர்பால் வினைமுற்று விகுதி; negative 3rd person plural ''they do not''', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 3, 'என்னே', 'என்னே = பேண் + உம் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_47_2 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 3, 'பேண்', 'போற்றுதல் பகுதி; to cherish, nurture', false, v_group_id),
    (v_l, 4, 'உம்', 'எதிர்கால இடைநிலை; future marker', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 5, 'வாழ்நாள்', 'வாழ்நாள் = வாழ் + நாள் இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_47_3 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 5, 'வாழ்', 'வாழ்தல் பகுதி; to live', false, v_group_id),
    (v_l, 6, 'நாள்', 'நாள்; day (வாழ்நாள் = lifetime)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l, 7, 'என்ஏ', 'என்ஏ = என் + ஏ இணைந்த சொல்') RETURNING id INTO v_group_id;
  g_47_4 := v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l, 7, 'என்', 'என்; what', false, v_group_id),
    (v_l, 8, 'ஏ', 'ஏகார அழுத்தம்; exclamatory ''alas!''', false, v_group_id);

  ------------------------------------------------------------------
  -- PART B: sandhi_rules for restructured boxes
  ------------------------------------------------------------------

  IF g_10_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_10_2, 0, 'ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்', 'சிறுமை + பூ', 'சிறுபூ', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_10_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_10_2, 1, 'ஒற்று மிகும்', 'சிறுபூ + குலை', 'சிறுபூக்குலை', 'க்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_10_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_10_3, 0, 'இகர ஈறு யகரமாகத் திரியும்', 'அடி + ஒன்று', 'அடியொன்று', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_10_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_10_4, 0, 'இணைந்த சொல் வடிவம்', 'உயர் + த்', 'உயர்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_10_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_10_4, 1, 'இணைந்த சொல் வடிவம்', 'உயர்த் + த்', 'உயர்த்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_10_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_10_4, 2, 'இணைந்த சொல் வடிவம்', 'உயர்த்த் + இ', 'உயர்த்தி', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_11_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_11_1, 0, 'இணைந்த சொல் வடிவம்', 'இதம் + உற', 'இதமுற', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_11_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_11_1, 1, 'ஒற்று மிகும்', 'இதமுற + தேன்', 'இதமுறத்தேன்', 'த்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_11_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_11_1, 2, 'இணைந்த சொல் வடிவம்', 'இதமுறத்தேன் + துளி', 'இதமுறத்தேன்துளி', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_11_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_11_2, 0, 'இணைந்த சொல் வடிவம்', 'தாங்கு + இ', 'தாங்கி', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_11_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_11_3, 0, 'ஒற்று மிகும்', 'ஈ + கள்', 'ஈக்கள்', 'க்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_11_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_11_3, 1, 'இணைந்த சொல் வடிவம்', 'ஈக்கள் + ஐ', 'ஈக்களை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_12_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_12_1, 0, 'இணைந்த சொல் வடிவம்', 'நலம் + உற', 'நலமுற', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_12_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_12_2, 0, 'இணைந்த சொல் வடிவம்', 'அழை + த்', 'அழைத்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_12_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_12_2, 1, 'இணைந்த சொல் வடிவம்', 'அழைத் + த்', 'அழைத்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_12_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_12_2, 2, 'இணைந்த சொல் வடிவம்', 'அழைத்த் + உ', 'அழைத்து', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_12_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_12_3, 0, 'ஒற்று மிகும்', 'நல் + ஊண்', 'நல்லூண்', 'ல்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_12_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_12_4, 0, 'உகரம் கெட்டு இகரம் ஏற்கும்', 'அருத்து + இ', 'அருத்தி', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_14_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_14_1, 0, 'இணைந்த சொல் வடிவம்', 'ஆசு + இலா', 'ஆசுஇலா', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_14_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_14_1, 1, 'ஒற்று மிகும்', 'ஆசுஇலா + சிறுமை', 'ஆசுஇலாச்சிறுமை', 'ச்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_14_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_14_1, 2, 'ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்', 'ஆசுஇலாச்சிறுமை + காய்', 'ஆசுஇலாச்சிறுகாய்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_14_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_14_2, 0, 'உகரம் கெட்டு இகரம் ஏற்கும்', 'ஆக்கு + இ', 'ஆக்கி', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_14_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_14_3, 0, 'உகரம் கெட்டு ஓகாரம் ஏற்கும்', 'இது + ஓ', 'இதோ', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_15_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_15_1, 0, 'இணைந்த சொல் வடிவம்', 'தூசு + இடை', 'தூசிடை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_15_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_15_1, 1, 'ஒற்று மிகும்', 'தூசிடை + சிக்கு', 'தூசிடைச்சிக்கு', 'ச்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_15_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_15_1, 2, 'இணைந்த சொல் வடிவம்', 'தூசிடைச்சிக்கு + உம்', 'தூசிடைச்சிக்கும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_15_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_15_2, 0, 'இகர ஈறு யகரமாகத் திரியும்', 'தோட்டி + உம்', 'தோட்டியும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_15_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_15_3, 0, 'இணைந்த சொல் வடிவம்', 'கொடு + த்', 'கொடுத்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_15_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_15_3, 1, 'இணைந்த சொல் வடிவம்', 'கொடுத் + த்', 'கொடுத்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_15_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_15_3, 2, 'இணைந்த சொல் வடிவம்', 'கொடுத்த் + ஏ', 'கொடுத்தே', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_16_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_16_1, 0, 'ஒற்று மிகும்', 'இ + வயின்', 'இவ்வயின்', 'வ்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_16_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_16_2, 0, 'இணைந்த சொல் வடிவம்', 'யாம் + எலாம்', 'யாமெலாம்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_16_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_16_3, 0, 'இணைந்த சொல் வடிவம்', 'செவ்வி + து', 'செவ்விது', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_16_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_16_3, 1, 'இணைந்த சொல் வடிவம்', 'செவ்விது + இல்', 'செவ்விதில்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_16_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_16_4, 0, 'ஒற்று மிகும்', 'துன் + இல்', 'துன்னில்', 'ன்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_17_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_17_1, 0, 'இணைந்த சொல் வடிவம்', 'தழைப்ப் + அது', 'தழைப்பது', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_17_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_17_1, 1, 'இணைந்த சொல் வடிவம்', 'தழைப்பது + அல்', 'தழைப்பதல்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_17_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_17_1, 2, 'லகரம் றகரமாகத் திரியும்', 'தழைப்பதல் + கு', 'தழைப்பதற்கு', 'ற்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_17_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_17_2, 0, 'இணைந்த சொல் வடிவம்', 'இடம் + இலை', 'இடமிலை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_17_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_17_3, 0, 'பாடலில் காணப்படும் இணைந்த சொல் வடிவம் (சிறுமை -> சிறு, ஆர் இணைப்பு)', 'சிறுமை + ஆர்', 'சிறார்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_17_5 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_17_5, 0, 'இணைந்த சொல் வடிவம்', 'பிழைப்ப் + அது', 'பிழைப்பது', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_17_5 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_17_5, 1, 'இணைந்த சொல் வடிவம்', 'பிழைப்பது + அல்', 'பிழைப்பதல்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_17_5 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_17_5, 2, 'லகரம் றகரமாகத் திரியும்', 'பிழைப்பதல் + கு', 'பிழைப்பதற்கு', 'ற்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_19_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_19_1, 0, 'உகரம் கெட்டு இகரம் ஏற்கும்', 'சிக்கு + இ', 'சிக்கி', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_19_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_19_3, 0, 'லகரம் னகரமாகத் திரியும்', 'செல் + மின்', 'சென்மின்', 'ன்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_19_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_19_4, 0, 'ஒற்று மிகும்', 'என + தன்', 'எனத்தன்', 'த்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_19_5 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_19_5, 1, 'இணைந்த சொல் வடிவம்', 'சிறுவர் + ஐ', 'சிறுவரை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_19_5 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_19_5, 2, 'இணைந்த சொல் வடிவம்', 'சிறுவரை + ப்', 'சிறுவரைப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_22_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_22_1, 0, 'இணைந்த சொல் வடிவம்', 'சிறுமை + ஆ', 'சிறுமையா', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_22_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_22_1, 1, 'இணைந்த சொல் வடிவம்', 'சிறுமையா + ச்', 'சிறுமையாச்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_22_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_22_1, 2, 'இணைந்த சொல் வடிவம்', 'சிறுமையாச் + சிந்தனை', 'சிறுமையாச்சிந்தனை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_22_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_22_2, 0, 'பாடலில் ''இடைக்குறை'' என்னும் விகார விதிப்படி முழு வடிவம் செய்யாது என்பதன் குறுகிய வடிவே செயாது', 'செய் + ஆது', 'செயாது', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_22_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_22_3, 0, 'அடுக்குத் தொடர்', 'ஆங்கு + ஆங்கு', 'ஆங்காங்கு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_23_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_23_2, 0, 'பாடலில் காணப்பட்ட புணர்ச்சி விதி (பேரழகு)', 'பெருமை + அழகு', 'பேரழகு', 'பேர்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_23_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_23_2, 1, 'இணைந்த சொல் வடிவம்', 'பேரழகு + உம்', 'பேரழகும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_24_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_24_2, 0, 'உகரம் கெட்டு இகரம் ஏற்கும்', 'குறிப்பு + இல்', 'குறிப்பில்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_24_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_24_2, 1, 'லகரம் றகரமாகத் திரியும்', 'குறிப்பில் + கு', 'குறிப்பிற்கு', 'ற்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_24_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_24_3, 0, 'இணைந்த சொல் வடிவம்', 'ஏல் + து', 'ஏற்று', 'ற்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_24_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_24_3, 1, 'உகரம் கெட்டு அகரம் ஏற்கும்', 'ஏற்று + அ', 'ஏற்ற', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_24_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_24_3, 2, 'இணைந்த சொல் வடிவம்', 'ஏற்ற + து', 'ஏற்றது', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_24_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_24_3, 3, 'உகரம் கெட்டு ஓகாரம் ஏற்கும்', 'ஏற்றது + ஓர்', 'ஏற்றதோர்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_24_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_24_4, 0, 'இகர ஈறு யகரமாகத் திரியும்', 'முயற்சி + உம்', 'முயற்சியும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_31_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_31_1, 0, 'ஒற்று மிகும்', 'உழு + ஓர்', 'உழுவோர்', 'வ்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_31_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_31_1, 1, 'இணைந்த சொல் வடிவம்', 'உழுவோர் + கு', 'உழுவோர்க்கு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_31_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_31_1, 2, 'இணைந்த சொல் வடிவம்', 'உழுவோர்க்கு + எல்லாம்', 'உழுவோர்க்கெல்லாம்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_31_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_31_2, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'விழும் + இய', 'விழுமிய', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_1, 0, 'இணைந்த சொல் வடிவம்', 'விடு + த்', 'விடுத்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_1, 1, 'இணைந்த சொல் வடிவம்', 'விடுத் + த்', 'விடுத்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_1, 2, 'இணைந்த சொல் வடிவம்', 'விடுத்த் + அன்', 'விடுத்தன்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_1, 3, 'இணைந்த சொல் வடிவம்', 'விடுத்தன் + ஐ', 'விடுத்தனை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_2, 0, 'உகரம் கெட்டு அகரம் ஏற்கும்', 'இது + அன்', 'இதன்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_2, 1, 'னகரம் றகரமாகத் திரியும்', 'இதன் + கு', 'இதற்கு', 'ற்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_2, 2, 'இணைந்த சொல் வடிவம்', 'இதற்கு + ஆ', 'இதற்கா', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_3, 0, 'இணைந்த சொல் வடிவம்', 'எடு + த்', 'எடுத்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_3, 1, 'இணைந்த சொல் வடிவம்', 'எடுத் + த்', 'எடுத்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_33_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_33_3, 2, 'இணைந்த சொல் வடிவம்', 'எடுத்த் + அ', 'எடுத்த', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_35_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_35_1, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'விழும் + இய', 'விழுமிய', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_37_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_37_1, 0, 'இணைந்த சொல் வடிவம்', 'ஒளி + க்', 'ஒளிக்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_37_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_37_1, 1, 'இணைந்த சொல் வடிவம்', 'ஒளிக் + கு', 'ஒளிக்கு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_37_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_37_1, 2, 'இணைந்த சொல் வடிவம்', 'ஒளிக்கு + வை', 'ஒளிக்குவை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_37_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_37_2, 0, 'இணைந்த சொல் வடிவம்', 'உன் + குழி', 'உன்குழி', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_37_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_37_3, 0, 'இணைந்த சொல் வடிவம்', 'வாய் + உம்', 'வாயும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_37_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_37_3, 1, 'இணைந்த சொல் வடிவம்', 'வாயும் + ஓர்', 'வாயுமோர்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_37_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_37_4, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'உருண்டை + ஆல்', 'உருண்டையால்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_43_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_43_1, 0, 'ககரம் பகரமாகத் திரியும் (ஒற்று மிகும்)', 'விழும் + புகழ்', 'விழுப்புகழ்', 'ப்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_43_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_43_2, 0, 'உகரம் கெட்டு அகரம் ஏற்கும்', 'வேண்டு + அல்', 'வேண்டல்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_43_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_43_2, 1, 'இணைந்த சொல் வடிவம்', 'வேண்டல் + ஐ', 'வேண்டலை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_43_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_43_3, 0, 'இணைந்த சொல் வடிவம்', 'அறி + வ்', 'அறிவ்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_43_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_43_3, 1, 'இணைந்த சொல் வடிவம்', 'அறிவ் + ஓம்', 'அறிவோம்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_43_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_43_4, 0, 'இணைந்த சொல் வடிவம்', 'ஏன் + இது', 'ஏனிது', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_44_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_44_1, 0, 'இணைந்த சொல் வடிவம்', 'துதி + க்', 'துதிக்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_44_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_44_1, 1, 'இணைந்த சொல் வடிவம்', 'துதிக் + க்', 'துதிக்க்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_44_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_44_1, 2, 'இணைந்த சொல் வடிவம்', 'துதிக்க் + அல்', 'துதிக்கல்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_44_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_44_1, 3, 'இணைந்த சொல் வடிவம்', 'துதிக்கல் + அம்', 'துதிக்கலம்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_44_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_44_2, 0, 'இணைந்த சொல் வடிவம்', 'உன் + தொழில்', 'உன்தொழில்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_44_3 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_44_3, 0, 'இணைந்த சொல் வடிவம்', 'நடத்து + தி', 'நடத்துதி', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_45_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_45_1, 0, 'இணைந்த சொல் வடிவம்', 'எங்கு + உம்', 'எங்கும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_45_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_45_2, 0, 'ஒற்று மிகும்', 'இ + ஙனம்', 'இங்ஙனம்', 'ங்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_45_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_45_2, 1, 'இணைந்த சொல் வடிவம்', 'இங்ஙனம் + ஏ', 'இங்ஙனே', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_45_4 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_45_4, 0, 'இணைந்த சொல் வடிவம்', 'இன்பு + உம்', 'இன்பும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_47_1 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_47_1, 0, 'ழகரம் ணகரமாகத் திரியும்', 'வாழ் + நாள்', 'வாணாள்', 'ண்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;
  IF g_47_2 IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (g_47_2, 0, 'ஒற்று மிகும்', 'என் + ஏ', 'என்னே', 'ன்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;

  ------------------------------------------------------------------
  -- PART C: sandhi_rules for the existing (unrestructured) boxes
  ------------------------------------------------------------------

  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 1 AND wg.combined_display_form = 'காலைஇல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'காலை + இல்', 'காலையில்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 1 group %', 'காலைஇல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 2 AND wg.combined_display_form = 'வேண்டுஇன்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு இன் இணையும்', 'வேண்டு + இன்', 'வேண்டின்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 2 group %', 'வேண்டுஇன்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 2 AND wg.combined_display_form = 'விரைவுஆய்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு ஆய் இணையும்', 'விரைவு + ஆய்', 'விரைவாய்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 2 group %', 'விரைவுஆய்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 3 AND wg.combined_display_form = 'முடுக்குஇன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு இன் இணையும்', 'முடுக்கு + இன்', 'முடுக்கின்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 3 group %', 'முடுக்குஇன்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 3 AND wg.combined_display_form = 'முடுக்குஇன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'முடுக்கின் + உம்', 'முடுக்கினும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 3 group %', 'முடுக்குஇன்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 3 AND wg.combined_display_form = 'முடிஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இகர ஈறு யகரமாகத் திரியும்', 'முடி + உம்', 'முடியும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 3 group %', 'முடிஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 4 AND wg.combined_display_form = 'எவினைஓர்குஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'எ + வினை', 'எவ்வினை', 'வ்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 4 group %', 'எவினைஓர்குஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 4 AND wg.combined_display_form = 'எவினைஓர்குஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'எவ்வினை + ஓர்', 'எவ்வினையோர்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 4 group %', 'எவினைஓர்குஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 4 AND wg.combined_display_form = 'எவினைஓர்குஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'எவ்வினையோர் + கு', 'எவ்வினையோர்க்கு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 4 group %', 'எவினைஓர்குஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 4 AND wg.combined_display_form = 'எவினைஓர்குஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'இணைந்த சொல் வடிவம்', 'எவ்வினையோர்க்கு + உம்', 'எவ்வினையோர்க்கும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 4 group %', 'எவினைஓர்குஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 4 AND wg.combined_display_form = 'இம்மைஇல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'இம்மை + இல்', 'இம்மையில்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 4 group %', 'இம்மைஇல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 4 AND wg.combined_display_form = 'தம்ஐ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'தம் + ஐ', 'தம்மை', 'ம்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 4 group %', 'தம்ஐ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 5 AND wg.combined_display_form = 'இயக்குதல்கு';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'இயக்கு + தல்', 'இயக்குதல்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 5 group %', 'இயக்குதல்கு';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 5 AND wg.combined_display_form = 'இயக்குதல்கு';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'லகரம் றகரமாகத் திரியும்', 'இயக்குதல் + கு', 'இயக்குதற்கு', 'ற்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 5 group %', 'இயக்குதல்கு';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 5 AND wg.combined_display_form = 'பயக்குஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'பயக்கு + உம்', 'பயக்கும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 5 group %', 'பயக்குஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 6 AND wg.combined_display_form = 'வேண்டுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'வேண்டு + உம்', 'வேண்டும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 6 group %', 'வேண்டுஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 6 AND wg.combined_display_form = 'போல்ஆம்.';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'போல் + ஆம்.', 'போலாம்.', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 6 group %', 'போல்ஆம்.';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 7 AND wg.combined_display_form = 'எபொருள்தான்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'எ + பொருள்', 'எப்பொருள்', 'ப்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 7 group %', 'எபொருள்தான்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 7 AND wg.combined_display_form = 'எபொருள்தான்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'எப்பொருள் + தான்', 'எப்பொருள்தான்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 7 group %', 'எபொருள்தான்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 7 AND wg.combined_display_form = 'இலக்குஅற்று';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு அகரம் ஏற்கும்', 'இலக்கு + அற்று', 'இலக்கற்று', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 7 group %', 'இலக்குஅற்று';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 7 AND wg.combined_display_form = 'இருப்ப்அது';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'இரு + ப்', 'இருப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 7 group %', 'இருப்ப்அது';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 7 AND wg.combined_display_form = 'இருப்ப்அது';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'இருப் + ப்', 'இருப்ப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 7 group %', 'இருப்ப்அது';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 7 AND wg.combined_display_form = 'இருப்ப்அது';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'இருப்ப் + அது', 'இருப்பது', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 7 group %', 'இருப்ப்அது';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 8 AND wg.combined_display_form = 'இதுஓ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு ஓகாரம் ஏற்கும்', 'இது + ஓ', 'இதோ', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 8 group %', 'இதுஓ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 8 AND wg.combined_display_form = 'இகரை';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'இ + கரை', 'இக்கரை', 'க்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 8 group %', 'இகரை';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 9 AND wg.combined_display_form = 'சதா';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு அகரம் ஏற்கும்', 'அது + அன்', 'அதன்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 9 group %', 'சதா';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 9 AND wg.combined_display_form = 'குறிப்புஒடு';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு ஓகாரம் ஏற்கும்', 'குறிப்பு + ஒடு', 'குறிப்பொடு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 9 group %', 'குறிப்புஒடு';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 20 AND wg.combined_display_form = 'புக்குஅவிட்டுஇருக்க்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு அகரம் ஏற்கும்', 'புக்கு + அ', 'புக்க', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 20 group %', 'புக்குஅவிட்டுஇருக்க்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 20 AND wg.combined_display_form = 'புக்குஅவிட்டுஇருக்க்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'புக்க + விட்டு', 'புக்கவிட்டு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 20 group %', 'புக்குஅவிட்டுஇருக்க்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 20 AND wg.combined_display_form = 'புக்குஅவிட்டுஇருக்க்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'உகரம் கெட்டு இகரம் ஏற்கும்', 'புக்கவிட்டு + இரு', 'புக்கவிட்டிரு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 20 group %', 'புக்குஅவிட்டுஇருக்க்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 20 AND wg.combined_display_form = 'புக்குஅவிட்டுஇருக்க்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'இணைந்த சொல் வடிவம்', 'புக்கவிட்டிரு + க்', 'புக்கவிட்டிருக்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 20 group %', 'புக்குஅவிட்டுஇருக்க்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 20 AND wg.combined_display_form = 'புக்குஅவிட்டுஇருக்க்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 4, 'இணைந்த சொல் வடிவம்', 'புக்கவிட்டிருக் + க்', 'புக்கவிட்டிருக்க்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 20 group %', 'புக்குஅவிட்டுஇருக்க்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 20 AND wg.combined_display_form = 'புக்குஅவிட்டுஇருக்க்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 5, 'இணைந்த சொல் வடிவம்', 'புக்கவிட்டிருக்க் + உம்', 'புக்கவிட்டிருக்கும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 20 group %', 'புக்குஅவிட்டுஇருக்க்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 20 AND wg.combined_display_form = 'இபுல்இன்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'இ + புல்', 'இப்புல்', 'ப்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 20 group %', 'இபுல்இன்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 20 AND wg.combined_display_form = 'இபுல்இன்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'ஒற்று மிகும்', 'இப்புல் + இன்', 'இப்புல்லின்', 'ல்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 20 group %', 'இபுல்இன்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 20 AND wg.combined_display_form = 'பரிவுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'பரிவு + உம்', 'பரிவும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 20 group %', 'பரிவுஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 21 AND wg.combined_display_form = 'பொறுமைஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'பொறுமை + உம்', 'பொறுமையும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 21 group %', 'பொறுமைஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 21 AND wg.combined_display_form = 'புலன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'புலன் + உம்', 'புலனும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 21 group %', 'புலன்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 21 AND wg.combined_display_form = 'காண்ப்ஓர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'காண் + ப்', 'காண்ப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 21 group %', 'காண்ப்ஓர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 21 AND wg.combined_display_form = 'காண்ப்ஓர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'காண்ப் + ஓர்', 'காண்போர்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 21 group %', 'காண்ப்ஓர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 21 AND wg.combined_display_form = 'ஒன்றுஐஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு ஐகாரம் ஏற்கும்', 'ஒன்று + ஐ', 'ஒன்றை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 21 group %', 'ஒன்றுஐஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 21 AND wg.combined_display_form = 'ஒன்றுஐஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'ஒன்றை + உம்', 'ஒன்றையும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 21 group %', 'ஒன்றுஐஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'பார் + த்', 'பார்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'பார்த் + த்', 'பார்த்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'பார்த்த் + உ', 'பார்த்து', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'இணைந்த சொல் வடிவம்', 'பார்த்து + ப்', 'பார்த்துப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 4, 'இணைந்த சொல் வடிவம்', 'பார்த்துப் + பார்', 'பார்த்துப்பார்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 5, 'இணைந்த சொல் வடிவம்', 'பார்த்துப்பார் + த்', 'பார்த்துப்பார்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 6, 'இணைந்த சொல் வடிவம்', 'பார்த்துப்பார்த் + த்', 'பார்த்துப்பார்த்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 7, 'இணைந்த சொல் வடிவம்', 'பார்த்துப்பார்த்த் + உ', 'பார்த்துப்பார்த்து', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 8, 'இணைந்த சொல் வடிவம்', 'பார்த்துப்பார்த்து + த்', 'பார்த்துப்பார்த்துத்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பார்த்த்உப்பார்த்த்உத்தம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 9, 'இணைந்த சொல் வடிவம்', 'பார்த்துப்பார்த்துத் + தம்', 'பார்த்துப்பார்த்துத்தம்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பார்த்த்உப்பார்த்த்உத்தம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பனிப்ப்அ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'பனி + ப்', 'பனிப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பனிப்ப்அ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பனிப்ப்அ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'பனிப் + ப்', 'பனிப்ப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பனிப்ப்அ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 25 AND wg.combined_display_form = 'பனிப்ப்அ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'பனிப்ப் + அ', 'பனிப்ப', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 25 group %', 'பனிப்ப்அ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'ஆர்த்த்உஎழுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'ஆர் + த்', 'ஆர்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'ஆர்த்த்உஎழுஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'ஆர்த்த்உஎழுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'ஆர்த் + த்', 'ஆர்த்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'ஆர்த்த்உஎழுஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'ஆர்த்த்உஎழுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'ஆர்த்த் + உ', 'ஆர்த்து', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'ஆர்த்த்உஎழுஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'ஆர்த்த்உஎழுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'உகரம் கெட்டு எகரம் ஏற்கும்', 'ஆர்த்து + எழு', 'ஆர்த்தெழு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'ஆர்த்த்உஎழுஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'ஆர்த்த்உஎழுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 4, 'இணைந்த சொல் வடிவம்', 'ஆர்த்தெழு + உம்', 'ஆர்த்தெழும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'ஆர்த்த்உஎழுஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'அன்புஇன்ஆல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு இன் இணையும்', 'அன்பு + இன்', 'அன்பின்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'அன்புஇன்ஆல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'அன்புஇன்ஆல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'அன்பின் + ஆல்', 'அன்பினால்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'அன்புஇன்ஆல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'அனைத்துஐஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு ஐகாரம் ஏற்கும்', 'அனைத்து + ஐ', 'அனைத்தை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'அனைத்துஐஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'அனைத்துஐஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'அனைத்தை + உம்', 'அனைத்தையும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'அனைத்துஐஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'கலத்(ந்)த்உ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'மெய் நகர மாற்றம்', 'கல + த்(ந்)', 'கலந்', 'ந்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'கலத்(ந்)த்உ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'கலத்(ந்)த்உ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'கலந் + த்', 'கலந்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'கலத்(ந்)த்உ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 26 AND wg.combined_display_form = 'கலத்(ந்)த்உ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'கலந்த் + உ', 'கலந்து', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 26 group %', 'கலத்(ந்)த்உ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 27 AND wg.combined_display_form = 'என்புஎலாம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு எகரம் ஏற்கும்', 'என்பு + எலாம்', 'என்பெலாம்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 27 group %', 'என்புஎலாம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 27 AND wg.combined_display_form = 'கரைக்க்உநல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'கரை + க்', 'கரைக்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 27 group %', 'கரைக்க்உநல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 27 AND wg.combined_display_form = 'கரைக்க்உநல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'கரைக் + க்', 'கரைக்க்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 27 group %', 'கரைக்க்உநல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 27 AND wg.combined_display_form = 'கரைக்க்உநல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'கரைக்க் + உ', 'கரைக்கு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 27 group %', 'கரைக்க்உநல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 27 AND wg.combined_display_form = 'கரைக்க்உநல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'இணைந்த சொல் வடிவம்', 'கரைக்கு + நல்', 'கரைக்குநல்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 27 group %', 'கரைக்க்உநல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 27 AND wg.combined_display_form = 'திளைப்ப்அர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'திளை + ப்', 'திளைப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 27 group %', 'திளைப்ப்அர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 27 AND wg.combined_display_form = 'திளைப்ப்அர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'திளைப் + ப்', 'திளைப்ப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 27 group %', 'திளைப்ப்அர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 27 AND wg.combined_display_form = 'திளைப்ப்அர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'திளைப்ப் + அர்', 'திளைப்பர்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 27 group %', 'திளைப்ப்அர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 28 AND wg.combined_display_form = 'ஓக்ஓ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'ஓ + க்', 'ஓக்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 28 group %', 'ஓக்ஓ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 28 AND wg.combined_display_form = 'ஓக்ஓ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'திரிபு நிலை', 'ஓக் + ஓ', 'ஓகோ', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 28 group %', 'ஓக்ஓ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 28 AND wg.combined_display_form = 'நாங்கூழ்புழுஏ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'நாங்கூழ்ப்புழு + ஏ', 'நாங்கூழ்ப்புழுவே', 'வ்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 28 group %', 'நாங்கூழ்புழுஏ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 29 AND wg.combined_display_form = 'ஓவாபாடுஏ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'ஓவா + பாடு', 'ஓவாப்பாடு', 'ப்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 29 group %', 'ஓவாபாடுஏ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 29 AND wg.combined_display_form = 'ஓவாபாடுஏ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'ஓவாப்பாடு + ஏ', 'ஓவாப்பாடே', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 29 group %', 'ஓவாபாடுஏ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 29 AND wg.combined_display_form = 'உணர்வ்ஏன்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'உணர் + வ்', 'உணர்வ்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 29 group %', 'உணர்வ்ஏன்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 29 AND wg.combined_display_form = 'உணர்வ்ஏன்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'உணர்வ் + ஏன்', 'உணர்வேன்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 29 group %', 'உணர்வ்ஏன்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 29 AND wg.combined_display_form = 'உணர்வ்ஏன்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'உணர் + வ்', 'உணர்வ்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 29 group %', 'உணர்வ்ஏன்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 29 AND wg.combined_display_form = 'உணர்வ்ஏன்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'உணர்வ் + ஏன்', 'உணர்வேன்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 29 group %', 'உணர்வ்ஏன்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 30 AND wg.combined_display_form = 'உழைப்ப்ஓர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'உழை + ப்', 'உழைப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 30 group %', 'உழைப்ப்ஓர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 30 AND wg.combined_display_form = 'உழைப்ப்ஓர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'உழைப் + ப்', 'உழைப்ப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 30 group %', 'உழைப்ப்ஓர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 30 AND wg.combined_display_form = 'உழைப்ப்ஓர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'உகரம் கெட்டு ஓகாரம் ஏற்கும்', 'உழைப்ப் + ஓர்', 'உழைப்போர்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 30 group %', 'உழைப்ப்ஓர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 30 AND wg.combined_display_form = 'உழைப்புஇல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு இகரம் ஏற்கும்', 'உழைப்பு + இல்', 'உழைப்பில்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 30 group %', 'உழைப்புஇல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 30 AND wg.combined_display_form = 'உழுவ்ஓர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'உழு + வ்', 'உழுவ்', 'வ்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 30 group %', 'உழுவ்ஓர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 30 AND wg.combined_display_form = 'உழுவ்ஓர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'உழுவ் + ஓர்', 'உழுவோர்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 30 group %', 'உழுவ்ஓர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 30 AND wg.combined_display_form = 'தொழில்மிகுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'லகரம் னகரமாகத் திரியும்', 'தொழில் + மிகு', 'தொழின்மிகு', 'ன்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 30 group %', 'தொழில்மிகுஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 30 AND wg.combined_display_form = 'தொழில்மிகுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'தொழின்மிகு + உம்', 'தொழின்மிகும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 30 group %', 'தொழில்மிகுஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 32 AND wg.combined_display_form = 'எமண்ஆய்இன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'எ + மண்', 'எம்மண்', 'ம்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 32 group %', 'எமண்ஆய்இன்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 32 AND wg.combined_display_form = 'எமண்ஆய்இன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'ஒற்று மிகும்', 'எம்மண் + ஆய்', 'எம்மண்ணாய்', 'ண்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 32 group %', 'எமண்ஆய்இன்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 32 AND wg.combined_display_form = 'எமண்ஆய்இன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'எம்மண்ணாய் + இன்', 'எம்மண்ணாயின்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 32 group %', 'எமண்ஆய்இன்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 32 AND wg.combined_display_form = 'எமண்ஆய்இன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'இணைந்த சொல் வடிவம்', 'எம்மண்ணாயின் + உம்', 'எம்மண்ணாயினும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 32 group %', 'எமண்ஆய்இன்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 32 AND wg.combined_display_form = 'நன்மைமண்ஆக்குவை';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு ''மை'' கெட்டு அடுத்த சொல் இணையும்', 'நன்மை + மண்', 'நன்மண்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 32 group %', 'நன்மைமண்ஆக்குவை';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 32 AND wg.combined_display_form = 'நன்மைமண்ஆக்குவை';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'ஒற்று மிகும்', 'நன்மண் + ஆக்கு', 'நன்மண்ணாக்கு', 'ண்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 32 group %', 'நன்மைமண்ஆக்குவை';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 32 AND wg.combined_display_form = 'நன்மைமண்ஆக்குவை';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'நன்மண்ணாக்கு + வை', 'நன்மண்ணாக்குவை', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 32 group %', 'நன்மைமண்ஆக்குவை';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 34 AND wg.combined_display_form = 'உழுதுஉழுது';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'அடுக்குத் தொடர் புணர்ச்சி (பாடநூல்)', 'உழுது + உழுது', 'உழுதுழுது', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 34 group %', 'உழுதுஉழுது';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 34 AND wg.combined_display_form = 'மெழுகுஇன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு இன் இணையும்', 'மெழுகு + இன்', 'மெழுகின்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 34 group %', 'மெழுகுஇன்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 34 AND wg.combined_display_form = 'மெழுகுஇன்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'மெழுகின் + உம்', 'மெழுகினும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 34 group %', 'மெழுகுஇன்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 34 AND wg.combined_display_form = 'நேர்மைஇய';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'நேர்மை + இய', 'நேரிய', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 34 group %', 'நேர்மைஇய';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 36 AND wg.combined_display_form = 'வெளிகொணர்த்(ந்)த்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'வெளி + கொணர்', 'வெளிக்கொணர்', 'க்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 36 group %', 'வெளிகொணர்த்(ந்)த்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 36 AND wg.combined_display_form = 'வெளிகொணர்த்(ந்)த்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'மெய் நகர மாற்றம்', 'வெளிக்கொணர் + த்(ந்)', 'வெளிக்கொணர்ந்', 'ந்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 36 group %', 'வெளிகொணர்த்(ந்)த்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 36 AND wg.combined_display_form = 'வெளிகொணர்த்(ந்)த்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'வெளிக்கொணர்ந் + த்', 'வெளிக்கொணர்ந்த்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 36 group %', 'வெளிகொணர்த்(ந்)த்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 36 AND wg.combined_display_form = 'வெளிகொணர்த்(ந்)த்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'இணைந்த சொல் வடிவம்', 'வெளிக்கொணர்ந்த் + உம்', 'வெளிக்கொணர்ந்தும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 36 group %', 'வெளிகொணர்த்(ந்)த்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 36 AND wg.combined_display_form = 'வேண்டு(ஆ)ஆர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு அகரம் ஏற்கும்', 'வேண்டு + (ஆ)', 'வேண்டா', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 36 group %', 'வேண்டு(ஆ)ஆர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 36 AND wg.combined_display_form = 'வேண்டு(ஆ)ஆர்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'வேண்டா + ஆர்', 'வேண்டார்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 36 group %', 'வேண்டு(ஆ)ஆர்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 38 AND wg.combined_display_form = 'இபுல்பயிர்நீ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'இ + புல்', 'இப்புல்', 'ப்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 38 group %', 'இபுல்பயிர்நீ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 38 AND wg.combined_display_form = 'இபுல்பயிர்நீ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'லகரம் றகரமாகத் திரியும்', 'இப்புல் + பயிர்', 'இப்புற்பயிர்', 'ற்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 38 group %', 'இபுல்பயிர்நீ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 38 AND wg.combined_display_form = 'இபுல்பயிர்நீ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'இப்புற்பயிர் + நீ', 'இப்புற்பயிர்நீ', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 38 group %', 'இபுல்பயிர்நீ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 38 AND wg.combined_display_form = 'இஙனம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'இ + ஙனம்', 'இங்ஙனம்', 'ங்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 38 group %', 'இஙனம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 38 AND wg.combined_display_form = 'உழுஆஏல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு ஆகாரம் ஏற்கும்', 'உழு + ஆ', 'உழா', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 38 group %', 'உழுஆஏல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 38 AND wg.combined_display_form = 'உழுஆஏல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'ஒற்று மிகும்', 'உழா + ஏல்', 'உழாயேல்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 38 group %', 'உழுஆஏல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 39 AND wg.combined_display_form = 'எபடி';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'எ + படி', 'எப்படி', 'ப்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 39 group %', 'எபடி';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 39 AND wg.combined_display_form = 'உண்டுஆம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு ஆகாரம் ஏற்கும்', 'உண்டு + ஆம்', 'உண்டாம்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 39 group %', 'உண்டுஆம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 39 AND wg.combined_display_form = 'எண்(ஆ)து';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'எண் + (ஆ)', 'எண்ணா', 'ண்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 39 group %', 'எண்(ஆ)து';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 39 AND wg.combined_display_form = 'எண்(ஆ)து';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'எண்ணா + து', 'எண்ணாது', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 39 group %', 'எண்(ஆ)து';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 39 AND wg.combined_display_form = 'உனக்குஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'உனக்கு + உம்', 'உனக்கும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 39 group %', 'உனக்குஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 40 AND wg.combined_display_form = 'எறும்புஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'எறும்பு + உம்', 'எறும்பும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 40 group %', 'எறும்புஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 40 AND wg.combined_display_form = 'கோடிஆய்அப்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இகர ஈறு யகரமாகத் திரியும்', 'கோடி + ஆய்', 'கோடியாய்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 40 group %', 'கோடிஆய்அப்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 40 AND wg.combined_display_form = 'கோடிஆய்அப்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'கோடியாய் + அ', 'கோடியாய', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 40 group %', 'கோடிஆய்அப்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 40 AND wg.combined_display_form = 'கோடிஆய்அப்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'கோடியாய + ப்', 'கோடியாயப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 40 group %', 'கோடிஆய்அப்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'புழுக்கள்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'புழு + க்', 'புழுக்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'புழுக்கள்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'புழுக்கள்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'புழுக் + கள்', 'புழுக்கள்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'புழுக்கள்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'புழுக்கள்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'புழுக்கள் + உம்', 'புழுக்களும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'புழுக்கள்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'பூச்சிஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இகர ஈறு யகரமாகத் திரியும்', 'பூச்சி + உம்', 'பூச்சியும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'பூச்சிஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'பிழைக்க்உம்ஆறு';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'பிழை + க்', 'பிழைக்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'பிழைக்க்உம்ஆறு';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'பிழைக்க்உம்ஆறு';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'பிழைக் + க்', 'பிழைக்க்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'பிழைக்க்உம்ஆறு';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'பிழைக்க்உம்ஆறு';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'பிழைக்க் + உம்', 'பிழைக்கும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'பிழைக்க்உம்ஆறு';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'பிழைக்க்உம்ஆறு';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 3, 'இணைந்த சொல் வடிவம்', 'பிழைக்கும் + ஆறு', 'பிழைக்குமாறு', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'பிழைக்க்உம்ஆறு';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 41 AND wg.combined_display_form = 'என்ஐ';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'என் + ஐ', 'என்னை', 'ன்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 41 group %', 'என்ஐ';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 42 AND wg.combined_display_form = 'ஒழுக்கம்உம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'ஒழுக்கம் + உம்', 'ஒழுக்கமும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 42 group %', 'ஒழுக்கம்உம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 42 AND wg.combined_display_form = 'பொறைஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஐகர ஈறு + உயிர் தொடங்கும் அசை இணையும்போது யகரம் வரும்', 'பொறை + உம்', 'பொறையும்', 'ய')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 42 group %', 'பொறைஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 42 AND wg.combined_display_form = 'உன்ஐப்போல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'ஒற்று மிகும்', 'உன் + ஐ', 'உன்னை', 'ன்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 42 group %', 'உன்ஐப்போல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 42 AND wg.combined_display_form = 'உன்ஐப்போல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'உன்னை + ப்', 'உன்னைப்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 42 group %', 'உன்ஐப்போல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 42 AND wg.combined_display_form = 'உன்ஐப்போல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 2, 'இணைந்த சொல் வடிவம்', 'உன்னைப் + போல்', 'உன்னைப்போல்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 42 group %', 'உன்ஐப்போல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 46 AND wg.combined_display_form = 'பங்கம்இல்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'பங்கம் + இல்', 'பங்கமில்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 46 group %', 'பங்கம்இல்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 46 AND wg.combined_display_form = 'அன்புஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'இணைந்த சொல் வடிவம்', 'அன்பு + உம்', 'அன்பும்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 46 group %', 'அன்புஉம்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 46 AND wg.combined_display_form = 'திருந்துஅக்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உகரம் கெட்டு அகரம் ஏற்கும்', 'திருந்து + அ', 'திருந்த', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 46 group %', 'திருந்துஅக்';
  END IF;
  SELECT wg.id INTO v_group_id FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 46 AND wg.combined_display_form = 'திருந்துஅக்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'இணைந்த சொல் வடிவம்', 'திருந்த + க்', 'திருந்தக்', NULL)
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  ELSE
    RAISE NOTICE 'NOT FOUND: line 46 group %', 'திருந்துஅக்';
  END IF;

  RAISE NOTICE '✓ Restructure + full sandhi rebuild from எவ்வினை.docx complete.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, wg.combined_display_form, count(sr.*) AS rule_count
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
LEFT JOIN sandhi_rules sr ON sr.word_group_id = wg.id
WHERE t.title = 'மனோன்மணீயம்'
GROUP BY pl.line_number, wg.combined_display_form
ORDER BY pl.line_number;
