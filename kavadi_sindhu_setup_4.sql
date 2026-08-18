-- ============================================================================
-- காவடிச் சிந்து — stanzas 7-8 (lines 31-40) + poem_lines rows for them.
-- Run AFTER kavadi_sindhu_setup_1.sql, _2.sql, and _3.sql.
--
-- Only சொல் பொருள் (word_groups/morphemes) breakdown is added here — no
-- verb_analysis/sandhi_rules rows, since (unlike வருகின்ற/உயர்ந்தோங்கும் in
-- stanzas 4-6) none of the words in these two stanzas are separately
-- documented in the இலக்கணப் பகுதி content from setup_1.sql.
--
-- INTERPRETIVE FLAGS for your review (consonant-doubling / continuation
-- splits in dense சிந்து meter):
--   1. "அந்தத்" (line 32) — split as அந்த + த், reading the doubled 'த்' as
--      the standard வல்லினம் மிகும் euphony after a சுட்டுப்பெயரடை
--      (அந்த/இந்த + வல்லின முதல் சொல்).
--   2. "முருகனைப்", "போற்றித்", "ஏற்றிக்", "தங்கக்" (lines 36-37) — all read
--      as [word] + doubled consonant under the same வல்லினம் மிகும் pattern
--      (accusative ஐ-ஈறு, and வினையெச்ச ஈறுகளுக்குப் பின்). Flagging in case
--      you'd rather show these as a single fused display form instead of a
--      2-part word_group.
--   3. "கொழும்" (line 37) + "கனல்" (line 38) — read as one semantic compound
--      (கொழுங்கனல் = "blazing fire") split across the line break, matching
--      how this project already handles line-final continuations elsewhere.
--   4. "மெழுகாய்வரு" (line 38) + "பவர்" (line 39) — read as மெழுகு + ஆய் +
--      வரு...பவர் = "வருபவர்" (''one who comes''), split across the line
--      break; the "வரு" is treated as a bare verb stem continuing into
--      "பவர்" rather than as its own word_group.
--   5. "இகமேகதி" (line 39) + "காண்பார்" (line 40) — read as இகம் + ஏ + கதி,
--      continuing into "காண்பார்" as "கதி காண்பார்" (''will attain the good
--      end''). This is my best parse of a fairly compressed phrase — tell me
--      if the intended split differs.
--   6. "ஏவரும்" (line 39) — read as a metrically-lengthened எவரும்
--      (''whoever, everyone''), a common சந்த விகாரம் in this meter.
-- ============================================================================

DO $$
DECLARE
  v_topic_id  uuid;
  v_poem_page_id uuid;
  v_group_id  uuid;

  v_l31 uuid; v_l32 uuid; v_l33 uuid; v_l34 uuid; v_l35 uuid;
  v_l36 uuid; v_l37 uuid; v_l38 uuid; v_l39 uuid; v_l40 uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'காவடிச் சிந்து' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'காவடிச் சிந்து topic not found — run kavadi_sindhu_setup_1.sql first.';
  END IF;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  ----------------------------------------------------------------
  -- Poem lines 31-40
  ----------------------------------------------------------------
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 31, 'அருணகிரி நாவில் பழக்கம் - தரும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l31;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 32, 'அந்தத் திருப்புகழ் முழக்கம் -பல')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l32;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 33, 'அடியார்கணம் மொழிபோதினில்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l33;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 34, 'அமராவதி இமையோர்செவி')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l34;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 35, 'அடைக்கும்; அண்டம் உடைக்கும்.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l35;

  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 36, 'கருணை முருகனைப் போற்றித்-தங்கக்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l36;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 37, 'காவடி தோளின்மேல் ஏற்றிக் - கொழும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l37;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 38, 'கனல்ஏறிய மெழுகாய்வரு')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l38;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 39, 'பவர்ஏவரும் இகமேகதி')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l39;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_poem_page_id, 40, 'காண்பார்; இன்பம் பூண்பார்.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l40;

  RAISE NOTICE 'Lines 31-40 ready.';

  DELETE FROM morphemes   WHERE poem_line_id IN (v_l31,v_l32,v_l33,v_l34,v_l35,v_l36,v_l37,v_l38,v_l39,v_l40);
  DELETE FROM word_groups WHERE poem_line_id IN (v_l31,v_l32,v_l33,v_l34,v_l35,v_l36,v_l37,v_l38,v_l39,v_l40);

  ----------------------------------------------------------------
  -- LINE 31: அருணகிரி நாவில் பழக்கம் - தரும்
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l31, 1, 'அருணகிரி', 'அருணகிரியார் என்னும் புலவர் (திருப்புகழ் ஆசிரியர்); the poet Arunagirinathar, author of the Thiruppugazh', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l31, 2, 'நாவில்', 'நாவில் = நாக்கின்மேல்; on the tongue') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l31, 2, 'நா', 'நாக்கு; tongue', false, v_group_id),
    (v_l31, 3, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''on/in''', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l31, 4, 'பழக்கம்', 'பழகிய தன்மை, வழக்கம்; habituated practice', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l31, 5, '-', 'பிரிப்புக் குறியீடு', true, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l31, 6, 'தரும்', 'கொடுக்கும், பயில்விக்கும் (தொடர்கிறது line 32''s திருப்புகழ் முழக்கம் உடன்); that gives/grants — continues into line 32''s ''thirupugazh-chant''', false, NULL);

  ----------------------------------------------------------------
  -- LINE 32: அந்தத் திருப்புகழ் முழக்கம் -பல
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l32, 1, 'அந்தத்', 'அந்த + த் (சுட்டுப்பெயரடைக்குப் பின் வல்லினம் மிகும் விதிப்படி); that (demonstrative, consonant doubled for euphony)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l32, 1, 'அந்த', 'சுட்டுப்பெயரடை; demonstrative ''that''', false, v_group_id),
    (v_l32, 2, 'த்', 'வல்லின மிகுதி (சாரியை); doubled consonant (euphonic formative)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l32, 3, 'திருப்புகழ்', 'திரு + புகழ் = அருணகிரியார் இயற்றிய பாமாலை (இலக்கணப் பகுதி புணர்ச்சி விதியில் ஏற்கெனவே கொடுக்கப்பட்டது); the sacred hymn of praise') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l32, 3, 'திரு', 'சிறப்பு, மேன்மை; sacredness, glory', false, v_group_id),
    (v_l32, 4, 'புகழ்', 'புகழ்மொழி; praise', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l32, 5, 'முழக்கம்', 'ஒலி, முழங்கல்; resounding chant', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l32, 6, '-', 'பிரிப்புக் குறியீடு', true, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l32, 7, 'பல', 'பல அடியார்கள் (தொடர்கிறது line 33''s அடியார்கணம் உடன்); many — continues into line 33''s ''crowd of devotees''', false, NULL);

  ----------------------------------------------------------------
  -- LINE 33: அடியார்கணம் மொழிபோதினில்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l33, 1, 'அடியார்கணம்', 'அடியார் கணம் = (line 32''s பல உடன் இணைந்து) பல அடியார் கூட்டம்; the assembly/crowd of devotees — completes line 32''s பல') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l33, 1, 'அடியார்', 'பக்தர்கள்; devotees', false, v_group_id),
    (v_l33, 2, 'கணம்', 'கூட்டம்; assembly, group', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l33, 3, 'மொழிபோதினில்', 'மொழி போதின் இல் = பாடல் பாடும்/பேசும் நேரத்தில்; at the time of chanting/uttering') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l33, 3, 'மொழி', 'சொல், பாட்டு; word, chant', false, v_group_id),
    (v_l33, 4, 'போது', 'நேரம்; time', false, v_group_id),
    (v_l33, 5, 'இன்', 'சாரியை; formative connective', false, v_group_id),
    (v_l33, 6, 'இல்', 'ஏழாம் வேற்றுமை உருபு; locative ''at/in''', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 34: அமராவதி இமையோர்செவி
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l34, 1, 'அமராவதி', 'இந்திரலோக நகரம் (வடசொல்); Amaravati, the celestial capital of Indra', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l34, 2, 'இமையோர்செவி', 'இமையோர் செவி = தேவர்களின் காது; the ears of the celestials (the unblinking ones)') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l34, 2, 'இமையோர்', 'இமைக்காதோர் — தேவர்; celestials (''those who do not blink'')', false, v_group_id),
    (v_l34, 3, 'செவி', 'காது; ear', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 35: அடைக்கும்; அண்டம் உடைக்கும்.
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l35, 1, 'அடைக்கும்', 'நிறையும், அடைக்கும்; fills up, reaches and fills', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l35, 2, ';', 'பிரிப்புக் குறியீடு', true, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l35, 3, 'அண்டம்', 'பிரபஞ்சம்; the universe, cosmos', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l35, 4, 'உடைக்கும்', 'பிளக்கும்; splits, breaks open', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l35, 5, '.', 'முற்றுப்புள்ளி', true, NULL);

  ----------------------------------------------------------------
  -- LINE 36: கருணை முருகனைப் போற்றித்-தங்கக்
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l36, 1, 'கருணை', 'இரக்கம், அருள்; mercy, compassion (முருகனுக்கு அடைமொழி)', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l36, 2, 'முருகனைப்', 'முருகனை + ப் (ஐகார ஈற்றுச் சொல்லுக்குப் பின் வல்லினம் மிகும் விதிப்படி); Murugan — accusative, consonant doubled') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l36, 2, 'முருகன்', 'முருகப்பெருமான்; Lord Murugan', false, v_group_id),
    (v_l36, 3, 'ஐ', 'இரண்டாம் வேற்றுமை உருபு; accusative marker', false, v_group_id),
    (v_l36, 4, 'ப்', 'வல்லின மிகுதி; doubled consonant (euphonic)', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l36, 5, 'போற்றித்', 'போற்றி + த் (வினையெச்சத்திற்குப் பின் வல்லினம் மிகும் விதிப்படி); having praised — consonant doubled') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l36, 5, 'போற்றி', 'வணங்கி, புகழ்ந்து; having praised, having worshipped', false, v_group_id),
    (v_l36, 6, 'த்', 'வல்லின மிகுதி; doubled consonant (euphonic)', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l36, 7, '-', 'பிரிப்புக் குறியீடு', true, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l36, 8, 'தங்கக்', 'தங்கம் + க் (தொடர்கிறது line 37''s காவடி உடன்); golden — consonant doubled, continues into line 37''s ''kavadi''', false, NULL);

  ----------------------------------------------------------------
  -- LINE 37: காவடி தோளின்மேல் ஏற்றிக் - கொழும்
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l37, 1, 'காவடி', 'தங்கக்காவடி = பொன்னாலான காவடி (தொடர்கிறது line 36''s தங்கக் உடன்); the golden kavadi — completes line 36''s word', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l37, 2, 'தோளின்மேல்', 'தோளின் மேலே; upon the shoulder') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l37, 2, 'தோள்', 'புயம்; shoulder', false, v_group_id),
    (v_l37, 3, 'இன்', 'ஆறாம் வேற்றுமை உருபு; genitive ''of''', false, v_group_id),
    (v_l37, 4, 'மேல்', 'மேலே; upon, above', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l37, 5, 'ஏற்றிக்', 'ஏற்றி + க் (வினையெச்சத்திற்குப் பின் வல்லினம் மிகும் விதிப்படி); having hoisted/loaded — consonant doubled') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l37, 5, 'ஏற்றி', 'சுமத்தி, தூக்கி வைத்து; having hoisted, having loaded', false, v_group_id),
    (v_l37, 6, 'க்', 'வல்லின மிகுதி; doubled consonant (euphonic)', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l37, 7, '-', 'பிரிப்புக் குறியீடு', true, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l37, 8, 'கொழும்', 'கொழுமையான (தொடர்கிறது line 38''s கனல் உடன்) → கொழுங்கனல்; blazing, intense — continues into line 38''s ''fire''', false, NULL);

  ----------------------------------------------------------------
  -- LINE 38: கனல்ஏறிய மெழுகாய்வரு
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l38, 1, 'கனல்', 'நெருப்பு (தொடர்கிறது line 37''s கொழும் உடன்) → கொழுங்கனல்; fire — completes line 37''s word, ''blazing fire''', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l38, 2, 'ஏறிய', 'மேலெழுந்த, தகித்த; that has risen into, blazed up in', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l38, 3, 'மெழுகாய்', 'மெழுகு ஆய் = மெழுகு போல ஆகி; becoming like wax') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l38, 3, 'மெழுகு', 'மெழுகு; wax', false, v_group_id),
    (v_l38, 4, 'ஆய்', 'ஆகி; becoming, having become', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l38, 5, 'வரு', 'வருதல் (தொடர்கிறது line 39''s பவர் உடன்) → வருபவர்; coming — continues into line 39''s ''one who comes''', false, NULL);

  ----------------------------------------------------------------
  -- LINE 39: பவர்ஏவரும் இகமேகதி
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l39, 1, 'பவர்', 'வருபவர் = வருகின்றவர் (தொடர்கிறது line 38''s வரு உடன்); one who comes — completes line 38''s word', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l39, 2, 'ஏவரும்', 'எவரும் (சந்த நீட்டல்); whoever, everyone — metrically lengthened form of எவரும்', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l39, 3, 'இகமேகதி', 'இகமே கதி = இம்மையே (நல்ல) கதியாக (தொடர்கிறது line 40''s காண்பார் உடன்); this very world/life as the (good) destiny — continues into line 40''s ''will attain''') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l39, 3, 'இகம்', 'இம்மை, இவ்வுலகம்; this world, this life', false, v_group_id),
    (v_l39, 4, 'ஏ', 'சிறப்பு இடைச்சொல் (அழுத்தம்); emphatic particle', false, v_group_id),
    (v_l39, 5, 'கதி', 'நல்வழி, முடிவு நிலை; destiny, the good end/state', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 40: காண்பார்; இன்பம் பூண்பார்.
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l40, 1, 'காண்பார்', 'கதி காண்பார் = நல்வழி காண்பர் (தொடர்கிறது line 39''s கதி உடன்); will see/attain the (good) destiny — completes line 39''s word', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l40, 2, ';', 'பிரிப்புக் குறியீடு', true, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l40, 3, 'இன்பம்', 'மகிழ்ச்சி, ஆனந்தம்; joy, bliss', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l40, 4, 'பூண்பார்', 'அணிவர், அடைவர்; will wear/attain', false, NULL);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l40, 5, '.', 'முற்றுப்புள்ளி', true, NULL);

  RAISE NOTICE '✓ Stanzas 7-8 (lines 31-40) done.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, pl.raw_text, count(wg.id) AS word_groups
FROM poem_lines pl
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
LEFT JOIN word_groups wg ON wg.poem_line_id = pl.id
WHERE t.title = 'காவடிச் சிந்து' AND p.page_type = 'செய்யுள் பகுதி' AND pl.line_number BETWEEN 31 AND 40
GROUP BY pl.line_number, pl.raw_text
ORDER BY pl.line_number;
