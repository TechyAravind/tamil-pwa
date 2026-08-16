-- ============================================================================
-- மனோன்மணீயம் — full சொல்வகை classification pass, lines 2-47
-- (line 1 already done via manonmaniyam_line1_full_classify.sql)
--
-- For every word_group: sets grammatical_label directly on any bound piece
-- that is itself a real word (word-compounds/case-inflected nouns), or
-- structural_role/role_category on pieces that are pure verb-internal
-- morphology (பகுதி/இடைநிலை/விகுதி/சந்தி மெய்). Sets each group's
-- combined_grammatical_label (பெ/வி/இ/உ) and, where the textbook or a clear
-- grammatical construction calls for one, combined_grammar_note
-- (இலக்கணக்குறிப்பு) — most groups intentionally get no note.
--
-- This is a first complete pass across the whole poem — please spot-check
-- a few lines against your textbook and tell me anything to correct.
-- ============================================================================

DO $$
DECLARE
  v_topic_id uuid;
  v_poem_page_id uuid;
  v_l uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  IF v_topic_id IS NULL THEN RAISE EXCEPTION 'topic not found'; END IF;
  SELECT id INTO v_poem_page_id FROM pages WHERE topic_id = v_topic_id AND page_type = 'செய்யுள் பகுதி';

  ------------------------------------------------------------------
  -- Line 2
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 2;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'தன்மைப் பன்மை வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'நிபந்தனை இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'நிபந்தனை வினையெச்சம்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'வினையெச்சம் (உரிச்சொல்லாகச் செயல்படும்)' WHERE poem_line_id = v_l AND position = 8;

  ------------------------------------------------------------------
  -- Line 3
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 3;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 1 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'நிபந்தனை இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'சிறப்பும்மை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'நிபந்தனை வினையெச்சம்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'எதிர்கால வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 6;

  ------------------------------------------------------------------
  -- Line 4
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 4;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'பெயரெச்சப் பகுதி (செய்வோர்)', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'நான்காம் வேற்றுமை உருபு', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'சிறப்பும்மை', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 8;

  ------------------------------------------------------------------
  -- Line 5
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'நான்காம் வேற்றுமை உருபு', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'தொழிற்பெயர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'பெயரெச்சம்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8 AND word_group_id IS NULL;

  ------------------------------------------------------------------
  -- Line 6
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 6;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'பண்புத்தொகை' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 9;

  ------------------------------------------------------------------
  -- Line 7
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 7;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 1 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'ஈறுகெட்ட எதிர்மறைப் பெயரெச்சம்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET structural_role = 'தொழிற்பெயர் விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'தொழிற்பெயர்' WHERE poem_line_id = v_l AND position = 7;

  ------------------------------------------------------------------
  -- Line 8
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 8;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'இடைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 3 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'பெயரெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'பெயரெச்சம்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 12;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'பண்புத்தொகை' WHERE poem_line_id = v_l AND position = 10;

  ------------------------------------------------------------------
  -- Line 9
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 9;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 1 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'தொழிற்பெயர் விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'தொழிற்பெயர்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7 AND word_group_id IS NULL;

  ------------------------------------------------------------------
  -- Line 10
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 10;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'பண்புத்தொகை' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 11;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 8;

  ------------------------------------------------------------------
  -- Line 11
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 11;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 7;

  ------------------------------------------------------------------
  -- Line 12
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 12;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'பண்புத்தொகை' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 9;

  ------------------------------------------------------------------
  -- Line 13
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 13;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 6;

  ------------------------------------------------------------------
  -- Line 14
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 14;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உரிச்சொல் தொடர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'இடைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 9 AND word_group_id IS NULL;

  ------------------------------------------------------------------
  -- Line 15
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 15;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'பெயரெச்ச தொடர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி (அழுத்தம்)', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 7;

  ------------------------------------------------------------------
  -- Line 16
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 16;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'நிபந்தனை இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'நிபந்தனை வினையெச்சம்' WHERE poem_line_id = v_l AND position = 8;

  ------------------------------------------------------------------
  -- Line 17
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 17;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி மெய்', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'ஒற்று மிகுதல்', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'தொழிற்பெயர் விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'எதிர்மறை/உருபு இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'நான்காம் வேற்றுமை உருபு', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'தொழிற்பெயர் + நான்காம் வேற்றுமை (வினையெச்சப் பொருள்)' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 11 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 12;
  UPDATE morphemes SET structural_role = 'சந்தி மெய்', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 13;
  UPDATE morphemes SET structural_role = 'ஒற்று மிகுதல்', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 14;
  UPDATE morphemes SET structural_role = 'தொழிற்பெயர் விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 15;
  UPDATE morphemes SET structural_role = 'எதிர்மறை/உருபு இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 16;
  UPDATE morphemes SET structural_role = 'நான்காம் வேற்றுமை உருபு', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 17;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'தொழிற்பெயர் + நான்காம் வேற்றுமை (வினையெச்சப் பொருள்)' WHERE poem_line_id = v_l AND position = 12;

  ------------------------------------------------------------------
  -- Line 18
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 18;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'ஏவல் பன்மை விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 4 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 8 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 9 AND word_group_id IS NULL;

  ------------------------------------------------------------------
  -- Line 19
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 19;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'ஏவல் பன்மை விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 8;

  ------------------------------------------------------------------
  -- Line 20
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 20;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'பெயரெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'பெயரெச்ச தொடர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 12;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 11;

  ------------------------------------------------------------------
  -- Line 21
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 21;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'பெயரெச்ச இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'செய்வோர் பெயர்ச்சொல் விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 8;

  ------------------------------------------------------------------
  -- Line 22
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 22;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'பண்புத்தொகை' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'எதிர்மறை வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'எதிர்மறை வினையெச்சம்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'அடுக்குத் தொடர்' WHERE poem_line_id = v_l AND position = 7;

  ------------------------------------------------------------------
  -- Line 23
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 23;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'பண்புத்தொகை + உம்மைத் தொகை' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'உரிச்சொல் தொடர்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை' WHERE poem_line_id = v_l AND position = 7;

  ------------------------------------------------------------------
  -- Line 24
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 24;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'தொழிற்பெயர் இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'பெயரெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'சாரியை/இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 12;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை' WHERE poem_line_id = v_l AND position = 11;

  ------------------------------------------------------------------
  -- Line 25
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 25;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'அடுக்குத் தொடர் (வினையெச்சம்)' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 12 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 13;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 14;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 15;
  UPDATE morphemes SET structural_role = 'பெயரெச்ச/வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 16;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 13;

  ------------------------------------------------------------------
  -- Line 26
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 26;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்/வினையெச்சம்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'ஐந்தாம் வேற்றுமை இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 12;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 13;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து (ந்)', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 14;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 15;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 16;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 13;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 17 AND word_group_id IS NULL;

  ------------------------------------------------------------------
  -- Line 27
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 27;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'உரிச்சொல் தொடர்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE morphemes SET structural_role = 'படர்க்கைப் பன்மை வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 12;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 9;

  ------------------------------------------------------------------
  -- Line 28
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 28;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE word_groups SET combined_grammatical_label = 'இடைச்சொல்', combined_grammar_note = 'அடுக்குத் தொடர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'விளி இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'விளி (வேற்றுமை)' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 6;

  ------------------------------------------------------------------
  -- Line 29
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 29;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'அழுத்தச் சொல்', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 3;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'தன்மை ஒருமை எதிர்கால வினைமுற்று', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'தன்மை ஒருமை எதிர்கால வினைமுற்று', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'அடுக்குத் தொடர் (அழுத்தம்)' WHERE poem_line_id = v_l AND position = 7;

  ------------------------------------------------------------------
  -- Line 30
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 30;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'செய்வோர் பெயர்ச்சொல் விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'செய்வோர் பெயர்ச்சொல் விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 12;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 10;

  ------------------------------------------------------------------
  -- Line 31
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 31;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'செய்வோர் பெயர்ச்சொல் விகுதி', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'நான்காம் வேற்றுமை உருபு', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'பண்புப் பெயரெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'பெயரெச்சம்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 7;

  ------------------------------------------------------------------
  -- Line 32
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 32;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'ஒப்புமை வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'நிபந்தனை இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'சிறப்பும்மை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'நிபந்தனை வினையெச்சம்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'முன்னிலை ஒருமை வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'பண்புத்தொகை + வினைமுற்று' WHERE poem_line_id = v_l AND position = 6;

  ------------------------------------------------------------------
  -- Line 33
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 33;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'சாரியை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'முன்னிலை ஒருமை வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'சாரியை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 12;
  UPDATE morphemes SET structural_role = 'பெயரெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 13;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'பெயரெச்சம்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 14 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 15 AND word_group_id IS NULL;

  ------------------------------------------------------------------
  -- Line 34
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 34;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'அடுக்குத் தொடர் (வினையெச்சம்)' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'ஒப்பீட்டு இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'சிறப்பும்மை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'ஒப்பீட்டு நிபந்தனை' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'பண்புப் பெயரெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'பெயரெச்சம்' WHERE poem_line_id = v_l AND position = 8;

  ------------------------------------------------------------------
  -- Line 35
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 35;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'பண்புப் பெயரெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'பெயரெச்சம்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'ஒப்புமை வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'வினையெச்சம் (உரிச்சொல்லாகச் செயல்படும்)' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET structural_role = 'வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 9;

  ------------------------------------------------------------------
  -- Line 36
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 36;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து (ந்)', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'இறந்தகால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'சிறப்பும்மை/எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'வினையெச்சம்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'எதிர்மறை இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'எதிர்மறைப் பலர்பால் வினைமுற்று', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 10 AND word_group_id IS NULL;

  ------------------------------------------------------------------
  -- Line 37
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 37;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி மெய்', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'ஒற்று மிகுதல்', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'முன்னிலை ஒருமை வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 10;

  ------------------------------------------------------------------
  -- Line 38
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 38;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'எதிர்மறை இடைநிலை + சந்தி மெய்', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'நிபந்தனை விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'நிபந்தனை வினையெச்சம் (எதிர்மறை)' WHERE poem_line_id = v_l AND position = 7;

  ------------------------------------------------------------------
  -- Line 39
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 39;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'எதிர்மறை இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'எதிர்மறை வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'எதிர்மறை வினையெச்சம்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 8;

  ------------------------------------------------------------------
  -- Line 40
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 40;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'பெயரெச்சத் தொடர் (பண்புத்தொகை போன்று)' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'ஒப்புமை வினையெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'பெயரெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'வினையெச்சம் (உரிச்சொல்லாகச் செயல்படும்)' WHERE poem_line_id = v_l AND position = 6;

  ------------------------------------------------------------------
  -- Line 41
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 41;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'பன்மை விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'சிறப்பும்மை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை (எண்ணும்மை)' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை (எண்ணும்மை)' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 11;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'வினையாலணையும் பெயர்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 12;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 13;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 12;

  ------------------------------------------------------------------
  -- Line 42
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 42;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE morphemes SET structural_role = 'நான்காம் வேற்றுமை உருபு', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 11;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 12;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 9;

  ------------------------------------------------------------------
  -- Line 43
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 43;
  UPDATE morphemes SET grammatical_label = 'உரிச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உரிச்சொல் தொடர்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'எதிர்மறை இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'முன்னிலை ஒருமை எதிர்மறை வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'எதிர்மறை வினைமுற்று' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'தன்மைப் பன்மை வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 10;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 9;

  ------------------------------------------------------------------
  -- Line 44
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 44;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'எதிர்மறை இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'தன்மைப் பன்மை எதிர்மறை வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'எதிர்மறை வினைமுற்று' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 13 AND word_group_id IS NULL;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 14 AND word_group_id IS NULL;

  ------------------------------------------------------------------
  -- Line 45
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 45;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE morphemes SET structural_role = 'அழுத்தச் சொல்', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 5;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'பண்புத்தொகை (எதிர்மறைத் தொகை)' WHERE poem_line_id = v_l AND position = 6;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை' WHERE poem_line_id = v_l AND position = 8;

  ------------------------------------------------------------------
  -- Line 46
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 46;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'பண்புத்தொகை (எதிர்மறைத் தொகை)' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'உம்மைத் தொகை' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET structural_role = 'தொழிற்பெயர் விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'தொழிற்பெயர்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'பெயரெச்ச விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 8;
  UPDATE morphemes SET structural_role = 'சந்தி எழுத்து', role_category = 'சந்தி மெய்' WHERE poem_line_id = v_l AND position = 9;
  UPDATE word_groups SET combined_grammatical_label = 'உரிச்சொல்', combined_grammar_note = 'பெயரெச்சம்' WHERE poem_line_id = v_l AND position = 7;

  ------------------------------------------------------------------
  -- Line 47
  ------------------------------------------------------------------
  SELECT id INTO v_l FROM poem_lines WHERE page_id = v_poem_page_id AND line_number = 47;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET structural_role = 'எதிர்மறைப் பலர்பால் வினைமுற்று விகுதி', role_category = 'விகுதி' WHERE poem_line_id = v_l AND position = 2;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = 'எதிர்மறை வினைமுற்று' WHERE poem_line_id = v_l AND position = 1;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET structural_role = 'எதிர்கால இடைநிலை', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 4;
  UPDATE word_groups SET combined_grammatical_label = 'வினைச்சொல்', combined_grammar_note = NULL WHERE poem_line_id = v_l AND position = 3;
  UPDATE morphemes SET grammatical_label = 'வினைச்சொல்' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'பெயர்ச்சொல்' WHERE poem_line_id = v_l AND position = 6;
  UPDATE word_groups SET combined_grammatical_label = 'பெயர்ச்சொல்', combined_grammar_note = 'பண்புத்தொகை' WHERE poem_line_id = v_l AND position = 5;
  UPDATE morphemes SET grammatical_label = 'இடைச்சொல்' WHERE poem_line_id = v_l AND position = 7;
  UPDATE morphemes SET structural_role = 'ஏகார அழுத்தம்', role_category = 'இடைநிலை' WHERE poem_line_id = v_l AND position = 8;
  UPDATE word_groups SET combined_grammatical_label = 'இடைச்சொல்', combined_grammar_note = 'வியப்பிடைச்சொல் தொடர்' WHERE poem_line_id = v_l AND position = 7;

  RAISE NOTICE '✓ Lines 2-47 சொல்வகை classification complete.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, wg.position, wg.combined_display_form, wg.combined_grammatical_label, wg.combined_grammar_note
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title = 'மனோன்மணீயம்'
ORDER BY pl.line_number, wg.position;