-- ============================================================================
-- மனோன்மணீயம் — proper dictionary meanings for the restructured-line boxes
--
-- The evvinai_rebuild script gave a real combined_display_form only to
-- boxes that had an explicit sandhi_rules chain, and used a generic
-- placeholder ("X = A + B + C இணைந்த சொல்") for combined_meaning on every
-- box in the 19 restructured lines regardless. This fixes BOTH fields —
-- combined_display_form (in case it was still wrong/unsandhied) and
-- combined_meaning (a real dictionary-style gloss, matching the style used
-- everywhere else in the poem, e.g. line 4) — for every affected box,
-- looked up by its stable (line_number, position) rather than by text.
--
-- Safe to re-run.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  n_updated int := 0;
  n_missing int := 0;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'மனோன்மணீயம் topic not found.';
  END IF;


  UPDATE word_groups wg SET
    combined_display_form = 'அதன்',
    combined_meaning = 'அதன் = அதனுடைய; its'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 10 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 10 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'சிறுபூக்குலை',
    combined_meaning = 'சிறுபூக்குலை = சிறிய பூக்களின் கொத்து; the small flower-cluster'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 10 AND wg.position = 3;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 10 position 3';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'அடியொன்று',
    combined_meaning = 'அடியொன்று = ஒரு தண்டு/அடிப்பாகம்; one stalk, one base'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 10 AND wg.position = 6;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 10 position 6';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'உயர்த்தி',
    combined_meaning = 'உயர்த்தி = உயர்த்திக்கொண்டு; having raised'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 10 AND wg.position = 8;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 10 position 8';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'இதமுறத்தேன்துளி',
    combined_meaning = 'இதமுறத்தேன்துளி = இன்பம் தரும் தேன் துளி; a pleasant drop of honey'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 11 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 11 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'தாங்கி',
    combined_meaning = 'தாங்கி = தாங்கிக்கொண்டு; having borne, having held'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 11 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 11 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'ஈக்களை',
    combined_meaning = 'ஈக்களை = ஈக்களை (இரண்டாம் வேற்றுமை); the flies (accusative)'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 11 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 11 position 7';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'நலமுற',
    combined_meaning = 'நலமுற = நன்மை அடையும்படி; kindly, for their welfare'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 12 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 12 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'அழைத்து',
    combined_meaning = 'அழைத்து = அழைத்துக்கொண்டு; having called, having invited'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 12 AND wg.position = 3;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 12 position 3';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'நல்லூண்',
    combined_meaning = 'நல்லூண் = நல்ல உணவு; good food, a feast'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 12 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 12 position 7';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'அருத்தி',
    combined_meaning = 'அருத்தி = ஊட்டி; having fed'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 12 AND wg.position = 9;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 12 position 9';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'ஆசுஇலாச்சிறுகாய்',
    combined_meaning = 'ஆசுஇலாச்சிறுகாய் = குற்றமற்ற சிறிய காய்; the blemishless small fruit'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 14 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 14 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'ஆக்கி',
    combined_meaning = 'ஆக்கி = உண்டாக்கிக்கொண்டு; having made, having produced'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 14 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 14 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'இதோ',
    combined_meaning = 'இதோ = இதோ!; here!'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 14 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 14 position 7';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'தூசிடைச்சிக்கும்',
    combined_meaning = 'தூசிடைச்சிக்கும் = புழுதிக்கு நடுவே சிக்கும்; that gets caught amid the dust'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 15 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 15 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'தோட்டியும்',
    combined_meaning = 'தோட்டியும் = துறட்டியும்; the hook/goad too'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 15 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 15 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'கொடுத்தே',
    combined_meaning = 'கொடுத்தே = கொடுத்தே; having given indeed'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 15 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 15 position 7';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'இவ்வயின்',
    combined_meaning = 'இவ்வயின் = இந்த இடத்தில்; in this place'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 16 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 16 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'யாமெலாம்',
    combined_meaning = 'யாமெலாம் = நாங்கள் அனைவரும்; all of us'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 16 AND wg.position = 3;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 16 position 3';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'செவ்விதில்',
    combined_meaning = 'செவ்விதில் = ஏற்ற தருணத்தில்; at the opportune time'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 16 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 16 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'துன்னில்',
    combined_meaning = 'துன்னில் = நெருங்கினால்; if we draw near'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 16 AND wg.position = 8;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 16 position 8';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'தழைப்பதற்கு',
    combined_meaning = 'தழைப்பதற்கு = தழைத்து வளர்வதற்கு; in order to flourish'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 17 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 17 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'இடமிலை',
    combined_meaning = 'இடமிலை = இடம் இல்லை; there is no room'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 17 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 17 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'சிறார்',
    combined_meaning = 'சிறார் = சிறுவர்கள்; the young ones, children'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 17 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 17 position 7';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'பிழைப்பதற்கு',
    combined_meaning = 'பிழைப்பதற்கு = பிழைத்து வாழ்வதற்கு; in order to survive'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 17 AND wg.position = 10;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 17 position 10';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'சிக்கி',
    combined_meaning = 'சிக்கி = சிக்கிக்கொண்டு; having got entangled'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 19 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 19 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'சென்மின்',
    combined_meaning = 'சென்மின் = செல்லுங்கள்; go!'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 19 AND wg.position = 4;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 19 position 4';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'எனத்தன்',
    combined_meaning = 'எனத்தன் = என்று தன்னுடைய; saying so, his own'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 19 AND wg.position = 6;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 19 position 6';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'சிறுவரைப்',
    combined_meaning = 'சிறுவரைப் = சிறுவர்களை; the little ones (acc.)'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 19 AND wg.position = 8;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 19 position 8';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'சிறுமையாச்சிந்தனை',
    combined_meaning = 'சிறுமையாச்சிந்தனை = சிறுமையான எண்ணம்; a trivial, petty thought'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 22 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 22 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'செயாது',
    combined_meaning = 'செயாது = செய்யாமல் (இடைக்குறை வடிவு); without doing'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 22 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 22 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'ஆங்காங்கு',
    combined_meaning = 'ஆங்காங்கு = எங்கும் அவ்வாறு; here and there'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 22 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 22 position 7';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'பேரழகும்',
    combined_meaning = 'பேரழகும் = பெரிய அழகும்; the great beauty too'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 23 AND wg.position = 2;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 23 position 2';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'ஆற்றல்சால்',
    combined_meaning = 'ஆற்றல்சால் = வலிமை நிறைந்த; abounding in strength'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 23 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 23 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'அன்பும்',
    combined_meaning = 'அன்பும் = அன்பும் (கொண்ட); love too'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 23 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 23 position 7';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'போற்றுதம்',
    combined_meaning = 'போற்றுதம் = தம்முடைய போற்றத்தக்க; their own cherished'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 24 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 24 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'குறிப்பிற்கு',
    combined_meaning = 'குறிப்பிற்கு = நோக்கத்திற்கு; for the purpose'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 24 AND wg.position = 3;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 24 position 3';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'ஏற்றதோர்',
    combined_meaning = 'ஏற்றதோர் = ஏற்ற ஒரு; a suitable'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 24 AND wg.position = 6;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 24 position 6';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'முயற்சியும்',
    combined_meaning = 'முயற்சியும் = முயற்சியும் (கொண்ட); and an effort'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 24 AND wg.position = 11;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 24 position 11';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'உழுவோர்க்கெல்லாம்',
    combined_meaning = 'உழுவோர்க்கெல்லாம் = உழுபவர்கள் அனைவருக்கும்; to all who plough'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 31 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 31 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'விழுமிய',
    combined_meaning = 'விழுமிய = சிறந்த, மேன்மையான; excellent, noble'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 31 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 31 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'வேந்துநீ',
    combined_meaning = 'வேந்துநீ = நீயே அரசன்; you are the king'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 31 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 31 position 7';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'விடுத்தனை',
    combined_meaning = 'விடுத்தனை = நீ விட்டுவிட்டாய்; you gave up, you released'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 33 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 33 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'இதற்கா',
    combined_meaning = 'இதற்கா = இதற்காக; for this reason'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 33 AND wg.position = 6;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 33 position 6';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'எடுத்த',
    combined_meaning = 'எடுத்த = எடுத்துக்கொண்ட; taken, formed'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 33 AND wg.position = 10;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 33 position 10';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'விழுமிய',
    combined_meaning = 'விழுமிய = சிறந்த, மேன்மையான; excellent, worthy'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 35 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 35 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'சேறாய்',
    combined_meaning = 'சேறாய் = சேறு போல; as mud, as clay'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 35 AND wg.position = 3;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 35 position 3';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'வேதித்து',
    combined_meaning = 'வேதித்து = மாற்றி; having transformed'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 35 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 35 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'உருட்டி',
    combined_meaning = 'உருட்டி = உருட்டிக்கொண்டு; having rolled'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 35 AND wg.position = 9;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 35 position 9';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'ஒளிக்குவை',
    combined_meaning = 'ஒளிக்குவை = நீ மறைக்கிறாய்; you hide, you conceal'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 37 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 37 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'உன்குழி',
    combined_meaning = 'உன்குழி = உனது குழியின்; your pit''s'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 37 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 37 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'வாயுமோர்',
    combined_meaning = 'வாயுமோர் = வாயையும் ஒரு; the mouth too, a'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 37 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 37 position 7';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'உருண்டையால்',
    combined_meaning = 'உருண்டையால் = ஒரு உருண்டையால்; with a round lump'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 37 AND wg.position = 10;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 37 position 10';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'விழுப்புகழ்',
    combined_meaning = 'விழுப்புகழ் = சிறந்த புகழ்; worthy, excellent fame'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 43 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 43 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'வேண்டலை',
    combined_meaning = 'வேண்டலை = நீ விரும்பவில்லை; you do not desire'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 43 AND wg.position = 3;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 43 position 3';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'அறிவோம்',
    combined_meaning = 'அறிவோம் = நாங்கள் அறிவோம்; we know [it]'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 43 AND wg.position = 6;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 43 position 6';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'ஏனிது',
    combined_meaning = 'ஏனிது = ஏன் இது; why is this?'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 43 AND wg.position = 9;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 43 position 9';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'துதிக்கலம்',
    combined_meaning = 'துதிக்கலம் = நாங்கள் புகழ விரும்பவில்லை; we do not seek praise'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 44 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 44 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'உன்தொழில்',
    combined_meaning = 'உன்தொழில் = உனது தொழிலை; your task'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 44 AND wg.position = 6;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 44 position 6';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'நடத்துதி',
    combined_meaning = 'நடத்துதி = நீ நடத்துகிறாய்; you carry out'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 44 AND wg.position = 8;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 44 position 8';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'எங்கும்',
    combined_meaning = 'எங்கும் = எல்லா இடங்களிலும்; everywhere'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 45 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 45 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'இங்ஙனே',
    combined_meaning = 'இங்ஙனே = இந்த வகையிலேயே; in this very manner'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 45 AND wg.position = 3;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 45 position 3';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'இணையிலா',
    combined_meaning = 'இணையிலா = ஒப்பற்ற; matchless'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 45 AND wg.position = 6;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 45 position 6';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'இன்பும்',
    combined_meaning = 'இன்பும் = இன்பமும்; joy too'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 45 AND wg.position = 8;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 45 position 8';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'காணார்',
    combined_meaning = 'காணார் = அவர்கள் காண்பதில்லை; they do not see [it]'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 47 AND wg.position = 1;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 47 position 1';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'பேணும்',
    combined_meaning = 'பேணும் = போற்றும்; that cherishes'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 47 AND wg.position = 3;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 47 position 3';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'வாணாள்',
    combined_meaning = 'வாணாள் = வாழ்நாள்; the life, the lifetime'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 47 AND wg.position = 5;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 47 position 5';
  END IF;

  UPDATE word_groups wg SET
    combined_display_form = 'என்னே',
    combined_meaning = 'என்னே = அந்தோ, என்ன பரிதாபம்!; alas!'
  FROM poem_lines pl, pages p
  WHERE wg.poem_line_id = pl.id AND pl.page_id = p.id
    AND p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி'
    AND pl.line_number = 47 AND wg.position = 7;
  GET DIAGNOSTICS n_updated = ROW_COUNT;
  IF n_updated = 0 THEN
    n_missing := n_missing + 1;
    RAISE NOTICE 'NOT FOUND: line 47 position 7';
  END IF;

  RAISE NOTICE '✓ Done. % boxes not found (check RAISE NOTICE lines above).', n_missing;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, wg.position, wg.combined_display_form, wg.combined_meaning
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்' AND pl.line_number IN (10,11,12,14,15,16,17,19,22,23,24,31,33,35,37,43,44,45,47)
ORDER BY pl.line_number, wg.position;
