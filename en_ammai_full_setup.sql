-- ============================================================================
-- என் அம்மை — COMPLETE setup: topic + page + 21 poem lines + word_groups
-- + morpheme splits, all in one script. Run this once in Supabase and there
-- is nothing left to do by hand in Admin — no need to type the 21 lines
-- yourself.
--
-- HOW TO RUN:
--   Supabase dashboard → SQL Editor → New query → paste this whole file →
--   Run. It's safe to re-run: it reuses the topic/page/lines if they
--   already exist instead of duplicating them, and always refreshes the
--   word_groups/morphemes to match this script.
-- ============================================================================

DO $$
DECLARE
  v_section_id uuid;
  v_topic_id   uuid;
  v_page_id    uuid;

  v_l1 uuid; v_l2 uuid; v_l3 uuid; v_l4 uuid; v_l5 uuid; v_l6 uuid; v_l7 uuid;
  v_l8 uuid; v_l9 uuid; v_l10 uuid; v_l11 uuid; v_l12 uuid; v_l13 uuid;
  v_l14 uuid; v_l15 uuid; v_l16 uuid; v_l17 uuid; v_l18 uuid; v_l19 uuid;
  v_l20 uuid; v_l21 uuid;

  v_group_id uuid;
BEGIN

  ----------------------------------------------------------------
  -- 1. Section — reuse the existing செய்யுள் (poetry) section
  ----------------------------------------------------------------
  SELECT id INTO v_section_id FROM sections WHERE name = 'செய்யுள்' LIMIT 1;
  IF v_section_id IS NULL THEN
    RAISE EXCEPTION 'No section named செய்யுள் found — check your sections table / tell me the correct section name.';
  END IF;

  ----------------------------------------------------------------
  -- 2. Topic — reuse if it already exists, else create
  ----------------------------------------------------------------
  SELECT id INTO v_topic_id FROM topics WHERE title = 'என் அம்மை' LIMIT 1;
  IF v_topic_id IS NULL THEN
    INSERT INTO topics (section_id, title, order_index)
    VALUES (v_section_id, 'என் அம்மை', 30)
    RETURNING id INTO v_topic_id;
    RAISE NOTICE 'Created topic என் அம்மை (id=%)', v_topic_id;
  ELSE
    RAISE NOTICE 'Reusing existing topic என் அம்மை (id=%)', v_topic_id;
  END IF;

  ----------------------------------------------------------------
  -- 3. Page (செய்யுள் பகுதி) — reuse if it already exists, else create
  ----------------------------------------------------------------
  SELECT id INTO v_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி' LIMIT 1;
  IF v_page_id IS NULL THEN
    INSERT INTO pages (topic_id, page_type)
    VALUES (v_topic_id, 'செய்யுள் பகுதி')
    RETURNING id INTO v_page_id;
    RAISE NOTICE 'Created செய்யுள் பகுதி page (id=%)', v_page_id;
  ELSE
    RAISE NOTICE 'Reusing existing செய்யுள் பகுதி page (id=%)', v_page_id;
  END IF;

  ----------------------------------------------------------------
  -- 4. The 21 poem lines — reuse by line_number if already present,
  --    else insert. Either way we end up with the id in v_l1..v_l21.
  ----------------------------------------------------------------
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 1, 'என் அம்மை,')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l1;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 2, 'ஒற்றியெடுத்த')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l2;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 3, 'நெற்றிமண் அழகே')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l3;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 4, 'வழிவழி நினதடி தொழுதவர்,')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l4;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 5, 'உழுதவர், விதைத்தவர்,')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l5;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 6, 'வியர்த்தவர்க்கெல்லாம்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l6;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 7, 'நிறைமணி தந்தவளே,')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l7;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 8, 'உனக்குப் பல்லாண்டு பல்லாண்டு;')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l8;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 9, 'பல்லாயிரத்தாண்டு.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l9;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 10, 'பாடத்தான் வேண்டும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l10;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 11, 'காற்றிலேறி, கனைகடலை, நெருப்பாற்றை,')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l11;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 12, 'மலை முகடுகளைக் கடந்து')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l12;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 13, 'செல் எனச் செல்லுமோர் பாடலை.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l13;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 14, 'கபாட புரங்களைக் காவு கொண்டபின்னும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l14;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 15, 'காலத்தால் சாகாத தொல் கனிமங்களின்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l15;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 16, 'உரமெலாம் சேரப் பாடத்தான் வேண்டும்.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l16;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 17, 'ஏடு தொடக்கிவைத்து என்னம்மை')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l17;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 18, 'மண்ணிலே தீட்டித் தீட்டி எழுதுவித்த')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l18;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 19, 'விரல் முனையைத் தீயிலே தோய்த்து')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l19;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 20, 'திசைகளின்சுவரெலாம் எழுதத்தான்வேண்டும்')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l20;
  INSERT INTO poem_lines (page_id, line_number, raw_text) VALUES (v_page_id, 21, 'எழுகின்ற யுகத்தினோர் பாடலை.')
    ON CONFLICT (page_id, line_number) DO UPDATE SET raw_text = EXCLUDED.raw_text RETURNING id INTO v_l21;

  RAISE NOTICE 'All 21 poem_lines ready.';

  ----------------------------------------------------------------
  -- 5. Clean slate for morphemes/word_groups on these 21 lines
  --    (safe to re-run this whole script any time)
  ----------------------------------------------------------------
  DELETE FROM morphemes   WHERE poem_line_id IN (v_l1,v_l2,v_l3,v_l4,v_l5,v_l6,v_l7,v_l8,v_l9,v_l10,v_l11,v_l12,v_l13,v_l14,v_l15,v_l16,v_l17,v_l18,v_l19,v_l20,v_l21);
  DELETE FROM word_groups WHERE poem_line_id IN (v_l1,v_l2,v_l3,v_l4,v_l5,v_l6,v_l7,v_l8,v_l9,v_l10,v_l11,v_l12,v_l13,v_l14,v_l15,v_l16,v_l17,v_l18,v_l19,v_l20,v_l21);

  ----------------------------------------------------------------
  -- LINE 1: என் அம்மை,
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l1, 1, 'என் அம்மை', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l1, 1, 'என்',   '[பொருள்]', false, v_group_id),
    (v_l1, 2, 'அம்மை', '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 2: ஒற்றியெடுத்த
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l2, 1, 'ஒற்றியெடுத்த', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l2, 1, 'ஒற்றி',  '[பொருள்]', false, v_group_id),
    (v_l2, 2, 'எடுத்த', '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 3: நெற்றிமண் அழகே
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l3, 1, 'நெற்றிமண்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l3, 1, 'நெற்றி', '[பொருள்]', false, v_group_id),
    (v_l3, 2, 'மண்',    '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l3, 2, 'அழகே', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l3, 3, 'அழகு', '[பொருள்]', false, v_group_id),
    (v_l3, 4, 'ஏ',    '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 4: வழிவழி நினதடி தொழுதவர்,
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l4, 1, 'வழிவழி', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l4, 1, 'வழி', '[பொருள்]', false, v_group_id),
    (v_l4, 2, 'வழி', '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l4, 2, 'நினதடி', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l4, 3, 'நின்', '[பொருள்]', false, v_group_id),
    (v_l4, 4, 'அது', '[பொருள்]', false, v_group_id),
    (v_l4, 5, 'அடி', '[பொருள்]', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l4, 6, 'தொழுதவர்', '[பொருள்]', false, NULL);

  ----------------------------------------------------------------
  -- LINE 5: உழுதவர், விதைத்தவர்,
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l5, 1, 'உழுதவர்',    '[பொருள்]', false, NULL),
    (v_l5, 2, 'விதைத்தவர்', '[பொருள்]', false, NULL);

  ----------------------------------------------------------------
  -- LINE 6: வியர்த்தவர்க்கெல்லாம்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l6, 1, 'வியர்த்தவர்க்கெல்லாம்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l6, 1, 'வியர்த்தவர்', '[பொருள்]', false, v_group_id),
    (v_l6, 2, 'கு',          '[பொருள்]', false, v_group_id),
    (v_l6, 3, 'எல்லாம்',     '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 7: நிறைமணி தந்தவளே,
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l7, 1, 'நிறைமணி', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l7, 1, 'நிறை', '[பொருள்]', false, v_group_id),
    (v_l7, 2, 'மணி',  '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l7, 2, 'தந்தவளே', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l7, 3, 'தந்தவள்', '[பொருள்]', false, v_group_id),
    (v_l7, 4, 'ஏ',       '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 8: உனக்குப் பல்லாண்டு பல்லாண்டு;
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l8, 1, 'உனக்குப்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 1, 'உன்', '[பொருள்]', false, v_group_id),
    (v_l8, 2, 'அ',   '[பொருள்]', false, v_group_id),
    (v_l8, 3, 'கு',  '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l8, 2, 'பல்லாண்டு', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 4, 'பல்',   '[பொருள்]', false, v_group_id),
    (v_l8, 5, 'ஆண்டு', '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l8, 3, 'பல்லாண்டு', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l8, 6, 'பல்',   '[பொருள்]', false, v_group_id),
    (v_l8, 7, 'ஆண்டு', '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 9: பல்லாயிரத்தாண்டு.
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l9, 1, 'பல்லாயிரத்தாண்டு', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l9, 1, 'பல்',    '[பொருள்]', false, v_group_id),
    (v_l9, 2, 'ஆயிரம்', '[பொருள்]', false, v_group_id),
    (v_l9, 3, 'அத்து',  '[பொருள்]', false, v_group_id),
    (v_l9, 4, 'ஆண்டு',  '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 10: பாடத்தான் வேண்டும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l10, 1, 'பாடத்தான்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 1, 'பாட', '[பொருள்]', false, v_group_id),
    (v_l10, 2, 'தான்', '[பொருள்]', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l10, 3, 'வேண்டும்', '[பொருள்]', false, NULL);

  ----------------------------------------------------------------
  -- LINE 11: காற்றிலேறி, கனைகடலை, நெருப்பாற்றை,
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l11, 1, 'காற்றிலேறி', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l11, 1, 'காற்று', '[பொருள்]', false, v_group_id),
    (v_l11, 2, 'இல்',    '[பொருள்]', false, v_group_id),
    (v_l11, 3, 'ஏறி',    '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l11, 2, 'கனைகடலை', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l11, 4, 'கனை',  '[பொருள்]', false, v_group_id),
    (v_l11, 5, 'கடல்', '[பொருள்]', false, v_group_id),
    (v_l11, 6, 'ஐ',    '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l11, 3, 'நெருப்பாற்றை', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l11, 7, 'நெருப்பு', '[பொருள்]', false, v_group_id),
    (v_l11, 8, 'ஆறு',     '[பொருள்]', false, v_group_id),
    (v_l11, 9, 'ஐ',       '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 12: மலை முகடுகளைக் கடந்து
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l12, 1, 'மலை', '[பொருள்]', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l12, 2, 'முகடுகளைக் கடந்து', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l12, 2, 'முகடு',  '[பொருள்]', false, v_group_id),
    (v_l12, 3, 'கள்',    '[பொருள்]', false, v_group_id),
    (v_l12, 4, 'ஐ',      '[பொருள்]', false, v_group_id),
    (v_l12, 5, 'கடந்து', '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 13: செல் எனச் செல்லுமோர் பாடலை.
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l13, 1, 'செல்', '[பொருள்]', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l13, 2, 'எனச்செல்லுமோர்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l13, 2, 'என்',  '[பொருள்]', false, v_group_id),
    (v_l13, 3, 'செல்', '[பொருள்]', false, v_group_id),
    (v_l13, 4, 'உம்',  '[பொருள்]', false, v_group_id),
    (v_l13, 5, 'ஓர்',  '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l13, 3, 'பாடலை', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l13, 6, 'பாடல்', '[பொருள்]', false, v_group_id),
    (v_l13, 7, 'ஐ',     '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 14: கபாட புரங்களைக் காவு கொண்டபின்னும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l14, 1, 'கபாடபுரங்கள்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l14, 1, 'கபாடபுரம்', '[பொருள்]', false, v_group_id),
    (v_l14, 2, 'கள்',       '[பொருள்]', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l14, 3, 'காவு', '[பொருள்]', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l14, 2, 'கொண்டபின்னும்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l14, 4, 'கொண்ட', '[பொருள்]', false, v_group_id),
    (v_l14, 5, 'பின்',  '[பொருள்]', false, v_group_id),
    (v_l14, 6, 'உம்',   '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 15: காலத்தால் சாகாத தொல் கனிமங்களின்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l15, 1, 'காலத்தால்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 1, 'காலம்', '[பொருள்]', false, v_group_id),
    (v_l15, 2, 'அத்து', '[பொருள்]', false, v_group_id),
    (v_l15, 3, 'ஆல்',   '[பொருள்]', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 4, 'சாகாத', '[பொருள்]', false, NULL),
    (v_l15, 5, 'தொல்',   '[பொருள்]', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l15, 2, 'கனிமங்களின்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l15, 6, 'கனிமம்', '[பொருள்]', false, v_group_id),
    (v_l15, 7, 'கள்',    '[பொருள்]', false, v_group_id),
    (v_l15, 8, 'இன்',    '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 16: உரமெலாம் சேரப் பாடத்தான் வேண்டும்.
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l16, 1, 'உரமெலாம்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 1, 'உரம்',  '[பொருள்]', false, v_group_id),
    (v_l16, 2, 'எலாம்', '[பொருள்]', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 3, 'சேர', '[பொருள்]', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l16, 2, 'பாடத்தான்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 4, 'பாட', '[பொருள்]', false, v_group_id),
    (v_l16, 5, 'தான்', '[பொருள்]', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l16, 6, 'வேண்டும்', '[பொருள்]', false, NULL);

  ----------------------------------------------------------------
  -- LINE 17: ஏடு தொடக்கிவைத்து என்னம்மை
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 1, 'ஏடு', '[பொருள்]', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l17, 2, 'தொடக்கிவைத்து', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 2, 'தொடக்கி', '[பொருள்]', false, v_group_id),
    (v_l17, 3, 'வைத்து',  '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l17, 3, 'என்னம்மை', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l17, 4, 'என்',   '[பொருள்]', false, v_group_id),
    (v_l17, 5, 'அம்மை', '[பொருள்]', false, v_group_id);

  ----------------------------------------------------------------
  -- LINE 18: மண்ணிலே தீட்டித் தீட்டி எழுதுவித்த
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l18, 1, 'மண்ணிலே', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 1, 'மண்', '[பொருள்]', false, v_group_id),
    (v_l18, 2, 'இல்', '[பொருள்]', false, v_group_id),
    (v_l18, 3, 'ஏ',   '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l18, 2, 'தீட்டித்தீட்டி', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 4, 'தீட்டி', '[பொருள்]', false, v_group_id),
    (v_l18, 5, 'தீட்டி', '[பொருள்]', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l18, 6, 'எழுதுவித்த', '[பொருள்]', false, NULL);

  ----------------------------------------------------------------
  -- LINE 19: விரல் முனையைத் தீயிலே தோய்த்து
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l19, 1, 'விரல்முனையைத்தீயிலே', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l19, 1, 'விரல்', '[பொருள்]', false, v_group_id),
    (v_l19, 2, 'முனை',  '[பொருள்]', false, v_group_id),
    (v_l19, 3, 'ஐ',     '[பொருள்]', false, v_group_id),
    (v_l19, 4, 'தீ',    '[பொருள்]', false, v_group_id),
    (v_l19, 5, 'இல்',   '[பொருள்]', false, v_group_id),
    (v_l19, 6, 'ஏ',     '[பொருள்]', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l19, 7, 'தோய்த்து', '[பொருள்]', false, NULL);

  ----------------------------------------------------------------
  -- LINE 20: திசைகளின்சுவரெலாம் எழுதத்தான்வேண்டும்
  ----------------------------------------------------------------
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l20, 1, 'திசைகளின்சுவரெலாம்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l20, 1, 'திசை',  '[பொருள்]', false, v_group_id),
    (v_l20, 2, 'கள்',   '[பொருள்]', false, v_group_id),
    (v_l20, 3, 'இன்',   '[பொருள்]', false, v_group_id),
    (v_l20, 4, 'சுவர்', '[பொருள்]', false, v_group_id),
    (v_l20, 5, 'எலாம்', '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l20, 2, 'எழுதத்தான்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l20, 6, 'எழுத', '[பொருள்]', false, v_group_id),
    (v_l20, 7, 'தான்',  '[பொருள்]', false, v_group_id);
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l20, 8, 'வேண்டும்', '[பொருள்]', false, NULL);

  ----------------------------------------------------------------
  -- LINE 21: எழுகின்ற யுகத்தினோர் பாடலை.
  ----------------------------------------------------------------
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 1, 'எழுகின்ற', '[பொருள்]', false, NULL);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l21, 2, 'யுகத்தினோர்', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 2, 'யுகம்', '[பொருள்]', false, v_group_id),
    (v_l21, 3, 'அத்து', '[பொருள்]', false, v_group_id),
    (v_l21, 4, 'இன்',   '[பொருள்]', false, v_group_id),
    (v_l21, 5, 'ஓர்',   '[பொருள்]', false, v_group_id);
  INSERT INTO word_groups (poem_line_id, position, combined_display_form, combined_meaning)
  VALUES (v_l21, 3, 'பாடலை', '[பொருள் சேர்க்கவும்]') RETURNING id INTO v_group_id;
  INSERT INTO morphemes (poem_line_id, position, display_form, word_meaning, is_separator, word_group_id) VALUES
    (v_l21, 6, 'பாடல்', '[பொருள்]', false, v_group_id),
    (v_l21, 7, 'ஐ',     '[பொருள்]', false, v_group_id);

  RAISE NOTICE '✓ என் அம்மை — topic, page, 21 lines, word_groups and morphemes all set up.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, pl.raw_text, wg.position, wg.combined_display_form
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'என் அம்மை'
ORDER BY pl.line_number, wg.position;
