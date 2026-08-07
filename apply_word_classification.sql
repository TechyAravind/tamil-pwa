-- ============================================================================
-- Run this SECOND, after 01_add_pos_enum_values.sql has been run and
-- committed on its own.
--
-- Fills word classification (சொல் வகை) for every individual morpheme box
-- and every combined word_group box in யுகத்தின் பாடல் (formerly என் அம்மை),
-- for the new "சொல் வகை" tab.
--
-- grammatical_label / combined_grammatical_label are a strict enum
-- (pos_label), so labels are limited to exactly 7 category names —
-- பெயர்ச்சொல், வினைச்சொல், இடைச்சொல், உரிச்சொல், வினையெச்சம், பெயரெச்சம்,
-- வினையாலணையும் பெயர் — no parenthetical sub-notes. This is my own
-- grammatical reading of the poem, same convention as your examples
-- (ஒற்றி -> வினையெச்சம், எடுத்த -> பெயரெச்சம், வியர்த்தவர் -> வினையாலணையும்
-- பெயர், கு/எல்லாம் -> இடைச்சொல்). Review and correct anything your
-- textbook classifies differently.
--
-- Deliberately NOT touched: intermediate merged forms (like வியர்த்தவர்க்கு,
-- the partway-combined display shown mid-tap) never get a classification —
-- handled entirely client-side (GrammarGroupBox.jsx clears the label on the
-- merged display while combining is in progress); there's no DB row for it.
--
-- Safe to re-run.
-- ============================================================================

DO $$
DECLARE
  v_page_id uuid;
BEGIN
  SELECT p.id INTO v_page_id
  FROM pages p
  JOIN topics t ON t.id = p.topic_id
  WHERE t.title IN ('என் அம்மை', 'யுகத்தின் பாடல்') AND p.page_type = 'செய்யுள் பகுதி'
  LIMIT 1;

  IF v_page_id IS NULL THEN
    RAISE EXCEPTION 'செய்யுள் பகுதி page not found for என் அம்மை / யுகத்தின் பாடல்.';
  END IF;

  ----------------------------------------------------------------
  -- Individual morpheme classifications (line_number, position, label)
  ----------------------------------------------------------------
  UPDATE morphemes m
  SET grammatical_label = v.label::pos_label
  FROM (VALUES
    (1,1,'பெயர்ச்சொல்'), (1,2,'பெயர்ச்சொல்'),
    (2,1,'வினையெச்சம்'), (2,2,'பெயரெச்சம்'),
    (3,1,'பெயர்ச்சொல்'), (3,2,'பெயர்ச்சொல்'), (3,3,'பெயர்ச்சொல்'), (3,4,'இடைச்சொல்'),
    (4,1,'பெயர்ச்சொல்'), (4,2,'பெயர்ச்சொல்'), (4,3,'பெயர்ச்சொல்'),
    (4,4,'இடைச்சொல்'), (4,5,'பெயர்ச்சொல்'), (4,6,'வினையாலணையும் பெயர்'),
    (5,1,'வினையாலணையும் பெயர்'), (5,2,'வினையாலணையும் பெயர்'),
    (6,1,'வினையாலணையும் பெயர்'), (6,2,'இடைச்சொல்'), (6,3,'இடைச்சொல்'),
    (7,1,'உரிச்சொல்'), (7,2,'பெயர்ச்சொல்'), (7,3,'வினையாலணையும் பெயர்'), (7,4,'இடைச்சொல்'),
    (8,1,'பெயர்ச்சொல்'), (8,2,'இடைச்சொல்'), (8,3,'இடைச்சொல்'),
    (8,4,'உரிச்சொல்'), (8,5,'பெயர்ச்சொல்'), (8,6,'உரிச்சொல்'), (8,7,'பெயர்ச்சொல்'),
    (9,1,'உரிச்சொல்'), (9,2,'பெயர்ச்சொல்'), (9,3,'இடைச்சொல்'), (9,4,'பெயர்ச்சொல்'),
    (10,1,'வினைச்சொல்'), (10,2,'இடைச்சொல்'), (10,3,'வினைச்சொல்'),
    (11,1,'பெயர்ச்சொல்'), (11,2,'இடைச்சொல்'), (11,3,'வினையெச்சம்'),
    (11,4,'பெயரெச்சம்'), (11,5,'பெயர்ச்சொல்'), (11,6,'இடைச்சொல்'),
    (11,7,'பெயர்ச்சொல்'), (11,8,'பெயர்ச்சொல்'), (11,9,'இடைச்சொல்'),
    (12,1,'பெயர்ச்சொல்'), (12,2,'பெயர்ச்சொல்'), (12,3,'இடைச்சொல்'),
    (12,4,'இடைச்சொல்'), (12,5,'வினையெச்சம்'),
    (13,1,'வினைச்சொல்'), (13,2,'வினையெச்சம்'), (13,3,'பெயரெச்சம்'),
    (13,4,'இடைச்சொல்'), (13,5,'உரிச்சொல்'), (13,6,'பெயர்ச்சொல்'), (13,7,'இடைச்சொல்'),
    (14,1,'பெயர்ச்சொல்'), (14,2,'இடைச்சொல்'), (14,3,'பெயர்ச்சொல்'),
    (14,4,'பெயரெச்சம்'), (14,5,'பெயர்ச்சொல்'), (14,6,'இடைச்சொல்'),
    (15,1,'பெயர்ச்சொல்'), (15,2,'இடைச்சொல்'), (15,3,'இடைச்சொல்'),
    (15,4,'பெயரெச்சம்'), (15,5,'உரிச்சொல்'), (15,6,'பெயர்ச்சொல்'),
    (15,7,'இடைச்சொல்'), (15,8,'இடைச்சொல்'),
    (16,1,'பெயர்ச்சொல்'), (16,2,'இடைச்சொல்'), (16,3,'வினையெச்சம்'),
    (16,4,'வினைச்சொல்'), (16,5,'இடைச்சொல்'), (16,6,'வினைச்சொல்'),
    (17,1,'பெயர்ச்சொல்'), (17,2,'வினையெச்சம்'), (17,3,'வினையெச்சம்'), (17,4,'பெயர்ச்சொல்'), (17,5,'பெயர்ச்சொல்'),
    (18,1,'பெயர்ச்சொல்'), (18,2,'இடைச்சொல்'), (18,3,'இடைச்சொல்'),
    (18,4,'வினையெச்சம்'), (18,5,'வினையெச்சம்'), (18,6,'பெயரெச்சம்'),
    (19,1,'பெயர்ச்சொல்'), (19,2,'பெயர்ச்சொல்'), (19,3,'இடைச்சொல்'),
    (19,4,'பெயர்ச்சொல்'), (19,5,'இடைச்சொல்'), (19,6,'இடைச்சொல்'), (19,7,'வினையெச்சம்'),
    (20,1,'பெயர்ச்சொல்'), (20,2,'இடைச்சொல்'), (20,3,'இடைச்சொல்'),
    (20,4,'பெயர்ச்சொல்'), (20,5,'இடைச்சொல்'), (20,6,'வினைச்சொல்'), (20,7,'இடைச்சொல்'), (20,8,'வினைச்சொல்'),
    (21,1,'பெயரெச்சம்'), (21,2,'பெயர்ச்சொல்'), (21,3,'இடைச்சொல்'),
    (21,4,'இடைச்சொல்'), (21,5,'உரிச்சொல்'), (21,6,'பெயர்ச்சொல்'), (21,7,'இடைச்சொல்')
  ) AS v(line_number, position, label)
  JOIN poem_lines pl ON pl.line_number = v.line_number AND pl.page_id = v_page_id
  WHERE m.poem_line_id = pl.id AND m.position = v.position;

  ----------------------------------------------------------------
  -- Combined word classifications (line_number, group position, label)
  ----------------------------------------------------------------
  UPDATE word_groups wg
  SET combined_grammatical_label = v.label::pos_label
  FROM (VALUES
    (1,1,'பெயர்ச்சொல்'),
    (2,1,'பெயரெச்சம்'),
    (3,1,'பெயர்ச்சொல்'),
    (3,2,'பெயர்ச்சொல்'),
    (4,1,'உரிச்சொல்'),
    (4,2,'பெயர்ச்சொல்'),
    (6,1,'பெயர்ச்சொல்'),
    (7,1,'பெயர்ச்சொல்'),
    (7,2,'வினையாலணையும் பெயர்'),
    (8,1,'பெயர்ச்சொல்'),
    (8,2,'பெயர்ச்சொல்'),
    (8,3,'பெயர்ச்சொல்'),
    (9,1,'பெயர்ச்சொல்'),
    (10,1,'வினையெச்சம்'),
    (11,1,'வினையெச்சம்'),
    (11,2,'பெயர்ச்சொல்'),
    (11,3,'பெயர்ச்சொல்'),
    (12,2,'வினையெச்சம்'),
    (13,2,'பெயரெச்சம்'),
    (13,3,'பெயர்ச்சொல்'),
    (14,1,'பெயர்ச்சொல்'),
    (14,2,'வினையெச்சம்'),
    (15,1,'பெயர்ச்சொல்'),
    (15,2,'பெயர்ச்சொல்'),
    (16,1,'பெயர்ச்சொல்'),
    (16,2,'வினையெச்சம்'),
    (17,2,'வினையெச்சம்'),
    (17,3,'பெயர்ச்சொல்'),
    (18,1,'பெயர்ச்சொல்'),
    (18,2,'வினையெச்சம்'),
    (19,1,'பெயர்ச்சொல்'),
    (20,1,'பெயர்ச்சொல்'),
    (20,2,'வினையெச்சம்'),
    (21,2,'பெயர்ச்சொல்'),
    (21,3,'பெயர்ச்சொல்')
  ) AS v(line_number, position, label)
  JOIN poem_lines pl ON pl.line_number = v.line_number AND pl.page_id = v_page_id
  WHERE wg.poem_line_id = pl.id AND wg.position = v.position;

  RAISE NOTICE '✓ Word classifications filled for all morphemes and word_groups.';
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT pl.line_number, m.position, m.display_form, m.grammatical_label
FROM morphemes m
JOIN poem_lines pl ON pl.id = m.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title IN ('என் அம்மை', 'யுகத்தின் பாடல்')
ORDER BY pl.line_number, m.position;

SELECT pl.line_number, wg.position, wg.combined_display_form, wg.combined_grammatical_label
FROM word_groups wg
JOIN poem_lines pl ON pl.id = wg.poem_line_id
JOIN pages p ON p.id = pl.page_id
JOIN topics t ON t.id = p.topic_id
WHERE t.title IN ('என் அம்மை', 'யுகத்தின் பாடல்')
ORDER BY pl.line_number, wg.position;
