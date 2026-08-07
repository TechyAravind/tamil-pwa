-- ============================================================================
-- மனோன்மணீயம் — நுழையும் முன் / இலக்கணப் பகுதி / துணைக் குறிப்புகள் /
--   நூல் வெளி (prose_content), plus verb_analysis (பகுபத உறுப்பிலக்கணம்)
--   and sandhi_rules (புணர்ச்சி விதி) for the two word_groups the PDF
--   documents a breakdown for.
--
-- SOURCE: manonmanium.pdf — XI Std Tamil, இயல் 2, மனோன்மணீயம் (pages 28-30)
--   Text transcribed directly from the textbook scan (the PDF's own text
--   layer is garbled/mis-encoded, so I read it from the page images).
--
-- Run this AFTER manonmaniyam_full_setup.sql.
-- Safe to re-run (clears and re-inserts each page's rows).
-- ============================================================================

DO $$
DECLARE
  v_topic_id      uuid;
  v_intro_page_id uuid;
  v_gram_page_id  uuid;
  v_notes_page_id uuid;
  v_bookinfo_page_id uuid;
  v_poem_page_id  uuid;

  v_group_id      uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN
    RAISE EXCEPTION 'மனோன்மணீயம் topic not found — run manonmaniyam_full_setup.sql first.';
  END IF;

  SELECT id INTO v_intro_page_id     FROM pages WHERE topic_id = v_topic_id AND page_type = 'நுழையும் முன்';
  SELECT id INTO v_gram_page_id      FROM pages WHERE topic_id = v_topic_id AND page_type = 'இலக்கணப் பகுதி';
  SELECT id INTO v_notes_page_id     FROM pages WHERE topic_id = v_topic_id AND page_type = 'துணைக் குறிப்புகள்';
  SELECT id INTO v_bookinfo_page_id  FROM pages WHERE topic_id = v_topic_id AND page_type = 'நூல் வெளி';
  SELECT id INTO v_poem_page_id      FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  DELETE FROM prose_content WHERE page_id IN (v_intro_page_id, v_gram_page_id, v_notes_page_id, v_bookinfo_page_id);

  ------------------------------------------------------------------
  -- நுழையும் முன்
  ------------------------------------------------------------------
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
  (v_intro_page_id,
   '19ஆம் நூற்றாண்டின் பிற்பகுதியில் தோன்றிய ‘மனோன்மணீயம்’ தமிழன்னை பெற்ற நல் அணிகலனாகும். நாடகத்துறைக்குத் தமிழில் நூல்கள் இல்லையே என்ற குறையினைத் தீர்க்க வந்த மனோன்மணீயம் என்னும் இந்நாடக நூல், காப்பிய இலக்கணம் முழுதும் நிரம்பிய நூலாக விளங்குகிறது. இயற்கையில் ஈடுபாடுகொண்டு, அதனில் தோய்ந்து இணையில்லாத ஊக்கமும் அமைதியும் பெற்றவர்கள் தமிழர்கள் என்பதைக் கூறுவதாக உள்ளது இந்நூலின் பகுதி.',
   10),
  (v_intro_page_id,
   'சுந்தர முனிவர் தனது அறையிலிருந்து ஆசிரமம் வரை யாரும் அறியாவண்ணம் சுரங்கம் அமைக்கும் பணியை நடராசனுக்கு அளித்திருந்தார். நடராசனும் அப்பணியை ஓரளவு முடித்துவிட்டான். ‘இன்னும் சிறுபகுதி வேலை ஆசிரமத்தில் செய்ய வேண்டியுள்ளது; அதுவும் இன்றிரவு முடிந்துவிடும்’ என்று எண்ணிக்கொண்டு காலை வேளையில் ஊரின் புறமாக நடராசன் தனித்திருந்தான். அப்போது தனக்குத்தானே பேசிக்கொள்கிறான்.',
   20),
  (v_intro_page_id,
   'மூன்றாம் அங்கம், இரண்டாம் களம். இடம்: ஊர்ப்புறம் ஒரு சார். காலம்: எற்பாடு (பிற்பகல்). பேசுபவர்: நடராசன் (தனிமொழி). கீழ்வரும் அடிகள் மனோன்மணீயத்தின் மூன்று காட்சிகளிலிருந்து எடுக்கப்பட்டவை — “இலக்கு வேண்டும்” (அடிகள் 1-3, 9-12), “புல்லின் பரிவு” (அடிகள் 13-32), “நாங்கூழ்ப்புழுவின் பொதுநலம்” (அடிகள் 66-85).',
   30);

  ------------------------------------------------------------------
  -- இலக்கணப் பகுதி  (இலக்கணக்குறிப்பு + பகுபத உறுப்பிலக்கணம் + புணர்ச்சி விதி)
  ------------------------------------------------------------------
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
  (v_gram_page_id,
   'இலக்கணக்குறிப்பு',
   10),
  (v_gram_page_id,
   'கடி நகர், சாலத்தகும் – உரிச்சொற்றொடர்கள்; உருட்டி – வினையெச்சம்; பின்னிய, முளைத்த – பெயரெச்சங்கள்; இளமுகம், நல்லூண், சிறுபுல், பேரழகு, முந்நீர், நன்மண் – பண்புத்தொகைகள்; பூக்குலை – இரண்டாம் வேற்றுமை உருபும் பயனும் உடன்தொக்கத் தொகை; ஆசிலா, ஓவா – ஈறுகெட்ட எதிர்மறைப் பெயரெச்சங்கள்; ஏகுமின் – ஏவல் பன்மை வினைமுற்று; பார்த்துப் பார்த்து, நில் நில், உழுதுழுது – அடுக்குத் தொடர்கள்; புழுக்களும் பூச்சியும் – எண்ணும்மை; தங்குதல் – தொழிற்பெயர்.',
   20),
  (v_gram_page_id,
   'பகுபத உறுப்பிலக்கணம்',
   30),
  (v_gram_page_id,
   'முளைத்த = முளை + த் + த் + அ. முளை – பகுதி, த் – சந்தி, த் – இறந்தகால இடைநிலை, அ – பெயரெச்ச விகுதி.',
   40),
  (v_gram_page_id,
   'ஏகுமின் = ஏகு + மின். ஏகு – பகுதி, மின் – ஏவல் வினைமுற்று விகுதி.',
   50),
  (v_gram_page_id,
   'விடுத்தனை = விடு + த் + த் + அன் + ஐ. விடு – பகுதி, த் – சந்தி, த் – இறந்தகால இடைநிலை, அன் – சாரியை, ஐ – முன்னிலை ஒருமை வினைமுற்று விகுதி.',
   60),
  (v_gram_page_id,
   'புணர்ச்சி விதி',
   70),
  (v_gram_page_id,
   'உழுதுழுது = உழுது + உழுது. விதி: ‘உயிர் வரின் உக்குறள் மெய் விட்டோடும்’ → உழுத் + உழுது. விதி: ‘உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே’ → உழுதுழுது.',
   80),
  (v_gram_page_id,
   'பேரழகு = பெருமை + அழகு. விதி: ‘ஈறு போதல்’ → பெரு + அழகு. விதி: ‘ஆதி நீடல்’ → பேரு + அழகு. விதி: ‘இணையவும்’ (உகரம் கெட்டது) → பேர் + அழகு. விதி: ‘உடல்மேல் உயிர் வந்து ஒன்றுவது இயல்பே’ → பேரழகு.',
   90);

  ------------------------------------------------------------------
  -- துணைக் குறிப்புகள்  (சொல்லும் பொருளும் + தமிழ் நாடக இலக்கண நூல்கள் சில)
  ------------------------------------------------------------------
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
  (v_notes_page_id,
   'சொல்லும் பொருளும்',
   10),
  (v_notes_page_id,
   'கடிநகர் – காவல் உடைய நகரம்; காண்டி – காண்க; பூம்பராகம் – பூவில் உள்ள மகரந்தம்; ஆசு இலா – குற்றம் இலாத; தோட்டி – துறட்டி; அயம் – ஆடு, குதிரை; புக்க விட்டு – போகவிட்டு; நாங்கூழ்ப்புழு – மண்புழு; ஓவா – ஓயாத; பாடு – உழைப்பு; வேதித்து – மாற்றி.',
   20),
  (v_notes_page_id,
   'தமிழ் நாடக இலக்கண நூல்கள் சில',
   30),
  (v_notes_page_id,
   '1. அகத்தியம் 2. குணநூல் 3. கூத்தநூல் 4. சந்தம் 5. சயந்தம் 6. செயன்முறை 7. செயிற்றியம் 8. முறுவல் 9. மதிவாணனார் நாடகத் தமிழ் நூல் 10. நாடகவியல்.',
   40);

  ------------------------------------------------------------------
  -- நூல் வெளி
  ------------------------------------------------------------------
  INSERT INTO prose_content (page_id, content_text, order_index) VALUES
  (v_bookinfo_page_id,
   'மனோன்மணீயம் தமிழின் முதல் பா வடிவ நாடக நூல். லிட்டன் பிரபு எழுதிய ‘இரகசிய வழி’ (The Secret Way) என்ற நூலைத் தழுவி 1891இல் பேராசிரியர் சுந்தரனார் இதைத் தமிழில் எழுதியுள்ளார். இஃது எளிய நடையில், ஆசிரியப்பாவால் அமைந்தது. இந்நூல் ஐந்து அங்கங்களையும் இருபது களங்களையும் கொண்டது. நூலின் தொடக்கத்தில் கடவுள் வாழ்த்துடன் தமிழ்த்தாய் வாழ்த்தும் இடம் பெற்றுள்ளது. இந்நூலின் தமிழ்த்தாய் வாழ்த்தே தமிழ்நாடு அரசின் மொழி வாழ்த்துப் பாடலாக ஏற்கப்பட்டுள்ளது.',
   10),
  (v_bookinfo_page_id,
   'பேராசிரியர் சுந்தரனார் திருவிதாங்கூரில் உள்ள ஆலப்புழையில் 1855இல் பிறந்தார். திருவனந்தபுரம் அரசுக் கல்லூரியில் தத்துவப் பேராசிரியராகப் பணியாற்றி உள்ளார். சென்னை மாகாண அரசு இவருக்கு ராவ்பகதூர் என்னும் பட்டம் வழங்கிச் சிறப்பித்துள்ளது. இவருக்குப் பெருமை சேர்க்கும் வகையில் தமிழ்நாடு அரசு, இவர் பெயரால் திருநெல்வேலியில் பல்கலைக்கழகம் ஒன்றை நிறுவியுள்ளது.',
   20);

  ------------------------------------------------------------------
  -- verb_analysis (பகுபத உறுப்பிலக்கணம் popup) for the 3 words the PDF
  -- gives a breakdown for. Each is stored as a word_group (its morphemes
  -- already exist from manonmaniyam_full_setup.sql), so we flip
  -- combined_is_verb = true on the group and attach the analysis there.
  ------------------------------------------------------------------

  -- முளைத்த (line 8) — note: stored as split morphemes முளை/த்/த்/அ inside
  -- a word_group, not as a single 'முளைத்த' token, so instead we attach
  -- the breakdown to the WORD GROUP itself.
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 8 AND wg.combined_display_form = 'முளைத்த்அ';
  IF v_group_id IS NOT NULL THEN
    UPDATE word_groups SET combined_is_verb = true, combined_grammatical_label = 'வினைச்சொல்' WHERE id = v_group_id;
    INSERT INTO verb_analysis (word_group_id, analysis) VALUES
      (v_group_id, '[{"part":"முளை","label":"பகுதி"},{"part":"த்","label":"சந்தி"},{"part":"த்","label":"இறந்தகால இடைநிலை"},{"part":"அ","label":"பெயரெச்ச விகுதி"}]')
    ON CONFLICT (word_group_id) WHERE word_group_id IS NOT NULL DO UPDATE SET analysis = EXCLUDED.analysis;
  END IF;

  -- ஏகுமின் (line 18) — solo group of 2 morphemes ஏகு/மின்
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 18 AND wg.combined_display_form = 'ஏகுமின்';
  IF v_group_id IS NOT NULL THEN
    UPDATE word_groups SET combined_is_verb = true, combined_grammatical_label = 'வினைச்சொல்' WHERE id = v_group_id;
    INSERT INTO verb_analysis (word_group_id, analysis) VALUES
      (v_group_id, '[{"part":"ஏகு","label":"பகுதி"},{"part":"மின்","label":"ஏவல் வினைமுற்று விகுதி"}]')
    ON CONFLICT (word_group_id) WHERE word_group_id IS NOT NULL DO UPDATE SET analysis = EXCLUDED.analysis;
  END IF;

  -- விடுத்தனை (line 33)
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 33 AND wg.combined_display_form = 'விடுத்த்அன்ஐ';
  IF v_group_id IS NOT NULL THEN
    UPDATE word_groups SET combined_is_verb = true, combined_grammatical_label = 'வினைச்சொல்' WHERE id = v_group_id;
    INSERT INTO verb_analysis (word_group_id, analysis) VALUES
      (v_group_id, '[{"part":"விடு","label":"பகுதி"},{"part":"த்","label":"சந்தி"},{"part":"த்","label":"இறந்தகால இடைநிலை"},{"part":"அன்","label":"சாரியை"},{"part":"ஐ","label":"முன்னிலை ஒருமை வினைமுற்று விகுதி"}]')
    ON CONFLICT (word_group_id) WHERE word_group_id IS NOT NULL DO UPDATE SET analysis = EXCLUDED.analysis;
  END IF;

  ------------------------------------------------------------------
  -- sandhi_rules (புணர்ச்சி விதி) for the 2 word_groups the PDF documents
  ------------------------------------------------------------------
  -- உழுதுழுது (line 34)
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 34 AND wg.combined_display_form = 'உழுதுஉழுது';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 0, 'உயிர் வரின் உக்குறள் மெய் விட்டோடும்; உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே', 'உழுது + உழுது', 'உழுதுழுது', 'து')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;

  -- பெருமை + அழகு = பேரழகு (line 23, first group தோற்றுபேரழகும்-> பெருமை/அழகு part)
  SELECT wg.id INTO v_group_id
  FROM word_groups wg JOIN poem_lines pl ON pl.id = wg.poem_line_id
  WHERE pl.page_id = v_poem_page_id AND pl.line_number = 23 AND wg.combined_display_form = 'தோற்றுபெருமைஅழகுஉம்';
  IF v_group_id IS NOT NULL THEN
    INSERT INTO sandhi_rules (word_group_id, connector_index, rule_text, before_form, after_form, changed_letter) VALUES
      (v_group_id, 1, 'ஈறு போதல்; ஆதி நீடல்; இணையவும் (உகரம் கெட்டது); உடல்மேல் உயிர் வந்து ஒன்றுவது இயல்பே', 'பெருமை + அழகு', 'பேரழகு', 'பேர்')
    ON CONFLICT (word_group_id, connector_index) DO UPDATE SET
      rule_text = EXCLUDED.rule_text, before_form = EXCLUDED.before_form, after_form = EXCLUDED.after_form, changed_letter = EXCLUDED.changed_letter;
  END IF;

  RAISE NOTICE '✓ மனோன்மணீயம் — other 4 pages, verb_analysis, sandhi_rules done.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT p.page_type, count(pc.*) AS paragraphs
FROM pages p
JOIN topics t ON t.id = p.topic_id
LEFT JOIN prose_content pc ON pc.page_id = p.id
WHERE t.title = 'மனோன்மணீயம்'
GROUP BY p.page_type
ORDER BY p.page_type;
