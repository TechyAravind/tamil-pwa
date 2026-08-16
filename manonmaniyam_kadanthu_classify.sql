DO $$
DECLARE
  v_topic_id uuid;
  v_l uuid;
  v_group_id uuid;
BEGIN
  SELECT id INTO v_topic_id FROM topics WHERE title = 'மனோன்மணீயம்' LIMIT 1;
  SELECT pl.id INTO v_l FROM poem_lines pl JOIN pages p ON p.id = pl.page_id
  WHERE p.topic_id = v_topic_id AND p.page_type = 'செய்யுள் பகுதி' AND pl.line_number = 1;
  SELECT id INTO v_group_id FROM word_groups WHERE poem_line_id = v_l AND position = 5;

  -- whole-word classification (shown when you tap the finished கடந்து box)
  UPDATE word_groups SET
    combined_grammatical_label = 'வினைச்சொல்',
    combined_is_verb = true
  WHERE id = v_group_id;

  -- பகுபத உறுப்பிலக்கணம் breakdown for that same whole word
  INSERT INTO verb_analysis (word_group_id, analysis) VALUES
    (v_group_id, '[
      {"part":"கட","label":"பகுதி"},
      {"part":"ந்","label":"சந்தி மெய்"},
      {"part":"த்","label":"இறந்தகால இடைநிலை"},
      {"part":"உ","label":"வினையெச்ச விகுதி"}
    ]'::jsonb)
  ON CONFLICT (word_group_id) WHERE word_group_id IS NOT NULL DO UPDATE SET
    analysis = EXCLUDED.analysis;
END $$;
