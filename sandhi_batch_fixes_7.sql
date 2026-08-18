-- ============================================================================
-- Four மெ | உ (norm rule, உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே) fixes,
-- all confirmed already existing rows now — matched directly by
-- before_form/after_form text this time (bypassing morpheme-adjacency
-- matching, since ஈக்கள் + ஐ apparently didn't get picked up by that path
-- last round). None of these are தனிக்குறில் (all polysyllabic stems
-- before the final dead consonant), so all get the single-step norm rule,
-- not doubling.
-- ============================================================================

DO $$
DECLARE
  spec RECORD;
  n int := 0;
BEGIN
  FOR spec IN
    SELECT * FROM (VALUES
      ('ஈக்கள் + ஐ',   'ஈக்களை'),
      ('நலம் + உற',    'நலமுற'),
      ('அழைத்த் + உ',  'அழைத்து'),
      ('பலம் + உற',    'பலமுற')
    ) AS t(bform, aform)
  LOOP
    UPDATE sandhi_rules SET
      mnemonic_tag = 'மெ | உ',
      mnemonic_hierarchy = '["மெ | உ"]'::jsonb,
      changed_letter = NULL,
      rule_steps = jsonb_build_array(
        jsonb_build_object('condition','விதி','rule','உடல்மேல் உயிர்வந்து ஒன்றுவது இயல்பே','result',spec.bform),
        jsonb_build_object('condition','விளைவு','rule',spec.bform || ' → ' || spec.aform,'result',spec.aform)
      )
    WHERE before_form = spec.bform AND after_form = spec.aform;

    IF FOUND THEN
      n := n + 1;
    ELSE
      RAISE NOTICE '✗ No row matched before_form=% after_form=% — check exact spelling/spacing on your live DB.', spec.bform, spec.aform;
    END IF;
  END LOOP;

  RAISE NOTICE '✓ Fixed % of 4 rows.', n;
END $$;

-- ── Verify ─────────────────────────────────────────────────────────────────
SELECT before_form, after_form, mnemonic_tag, rule_steps
FROM sandhi_rules
WHERE before_form IN ('ஈக்கள் + ஐ', 'நலம் + உற', 'அழைத்த் + உ', 'பலம் + உற');
