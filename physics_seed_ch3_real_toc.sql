-- ============================================================
-- Physics — Chapter 3 (Laws of Motion): replace the placeholder
-- Theory outline with the REAL section list from the textbook
-- (extracted from the "LOM.pdf" — Samacheer Kalvi 11th Physics,
-- Volume 1, Unit 3 "Laws of Motion").
--
-- Run this AFTER physics_schema.sql + physics_seed.sql +
-- physics_seed_ch2_ch3_subtopics.sql.
--
-- Step 1 deletes the 8 placeholder rows added earlier for
-- Chapter 3 (Newton's 1st/2nd/3rd Law, Friction — the short
-- made-up outline). Safe: no Text/Slides/Videos content had
-- been added under them yet, so nothing is lost. If you HAVE
-- since added content under any of those old rows and want to
-- keep it, stop here and tell me instead of running this file.
--
-- Step 2 inserts the real 7 top-level sections (3.1–3.7) and
-- their real sub-sections (3.x.y) as titles only — you'll add
-- Text/Presentation/Videos later from /admin/physics-content.
-- ============================================================

-- -------------------------
-- STEP 1 — remove the old placeholder Chapter 3 outline
-- -------------------------
delete from physics_subtopics
where chapter_id = '22222222-2222-2222-2222-222222220003';

-- -------------------------
-- STEP 2 — real textbook outline for Chapter 3
-- -------------------------

-- Top-level sections (3.1 – 3.7)
insert into physics_subtopics (id, chapter_id, parent_id, title, order_index) values
  ('66666666-6666-6666-6666-666666660001', '22222222-2222-2222-2222-222222220003', null, 'Introduction',                                1),
  ('66666666-6666-6666-6666-666666660002', '22222222-2222-2222-2222-222222220003', null, 'Newton''s Laws',                              2),
  ('66666666-6666-6666-6666-666666660003', '22222222-2222-2222-2222-222222220003', null, 'Application of Newton''s Laws',               3),
  ('66666666-6666-6666-6666-666666660004', '22222222-2222-2222-2222-222222220003', null, 'Lami''s Theorem',                             4),
  ('66666666-6666-6666-6666-666666660005', '22222222-2222-2222-2222-222222220003', null, 'Law of Conservation of Total Linear Momentum', 5),
  ('66666666-6666-6666-6666-666666660006', '22222222-2222-2222-2222-222222220003', null, 'Friction',                                    6),
  ('66666666-6666-6666-6666-666666660007', '22222222-2222-2222-2222-222222220003', null, 'Dynamics of Circular Motion',                 7)
on conflict (id) do nothing;

-- 3.2.x — Newton's Laws
insert into physics_subtopics (id, chapter_id, parent_id, title, order_index) values
  ('66666666-6666-6666-6666-666666660021', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660002', 'Newton''s First Law',              1),
  ('66666666-6666-6666-6666-666666660022', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660002', 'Newton''s Second Law',             2),
  ('66666666-6666-6666-6666-666666660023', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660002', 'Newton''s Third Law',              3),
  ('66666666-6666-6666-6666-666666660024', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660002', 'Discussion on Newton''s Laws',     4)
on conflict (id) do nothing;

-- 3.3.x — Application of Newton's Laws
insert into physics_subtopics (id, chapter_id, parent_id, title, order_index) values
  ('66666666-6666-6666-6666-666666660031', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660003', 'Free Body Diagram',                    1),
  ('66666666-6666-6666-6666-666666660032', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660003', 'Particle Moving in an Inclined Plane', 2),
  ('66666666-6666-6666-6666-666666660033', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660003', 'Two Bodies in Contact',                3),
  ('66666666-6666-6666-6666-666666660034', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660003', 'Motion of Connected Bodies',           4),
  ('66666666-6666-6666-6666-666666660035', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660003', 'Concurrent Forces and Lami''s Theorem', 5)
on conflict (id) do nothing;

-- 3.5.x — Law of Conservation of Total Linear Momentum
insert into physics_subtopics (id, chapter_id, parent_id, title, order_index) values
  ('66666666-6666-6666-6666-666666660051', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660005', 'Impulse', 1)
on conflict (id) do nothing;

-- 3.6.x — Friction
insert into physics_subtopics (id, chapter_id, parent_id, title, order_index) values
  ('66666666-6666-6666-6666-666666660061', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660006', 'Introduction',                    1),
  ('66666666-6666-6666-6666-666666660062', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660006', 'Static Friction',                 2),
  ('66666666-6666-6666-6666-666666660063', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660006', 'Kinetic Friction',                3),
  ('66666666-6666-6666-6666-666666660064', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660006', 'To Move an Object: Push or Pull?', 4),
  ('66666666-6666-6666-6666-666666660065', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660006', 'Angle of Friction',               5),
  ('66666666-6666-6666-6666-666666660066', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660006', 'Angle of Repose',                 6),
  ('66666666-6666-6666-6666-666666660067', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660006', 'Application of Angle of Repose',  7),
  ('66666666-6666-6666-6666-666666660068', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660006', 'Rolling Friction',                8),
  ('66666666-6666-6666-6666-666666660069', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660006', 'Methods to Reduce Friction',      9)
on conflict (id) do nothing;

-- 3.7.x — Dynamics of Circular Motion
insert into physics_subtopics (id, chapter_id, parent_id, title, order_index) values
  ('66666666-6666-6666-6666-666666660071', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660007', 'Centripetal Force',                              1),
  ('66666666-6666-6666-6666-666666660072', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660007', 'Vehicle on a Leveled Circular Road',             2),
  ('66666666-6666-6666-6666-666666660073', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660007', 'Banking of Tracks',                              3),
  ('66666666-6666-6666-6666-666666660074', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660007', 'Centrifugal Force',                              4),
  ('66666666-6666-6666-6666-666666660075', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660007', 'Effects of Centrifugal Force',                   5),
  ('66666666-6666-6666-6666-666666660076', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660007', 'Centrifugal Force due to Rotation of the Earth', 6),
  ('66666666-6666-6666-6666-666666660077', '22222222-2222-2222-2222-222222220003', '66666666-6666-6666-6666-666666660007', 'Centripetal Force Versus Centrifugal Force',     7)
on conflict (id) do nothing;
