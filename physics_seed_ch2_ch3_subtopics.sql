-- ============================================================
-- Physics — Theory outline (subtopics) for
--   Chapter 2: Kinematics
--   Chapter 3: Laws of Motion
--
-- Run this AFTER physics_schema.sql and physics_seed.sql.
-- Titles only (no Text/Presentation/Videos content yet) — add
-- that later from /admin/physics-content once you're ready.
-- Fixed UUIDs + "on conflict (id) do nothing" → safe to re-run.
-- ============================================================

-- -------------------------
-- Chapter 2 — Kinematics  (chapter id ...0002)
-- -------------------------
insert into physics_subtopics (id, chapter_id, parent_id, title, order_index) values
  ('44444444-4444-4444-4444-444444440001', '22222222-2222-2222-2222-222222220002', null, 'Introduction to Motion',        1),
  ('44444444-4444-4444-4444-444444440011', '22222222-2222-2222-2222-222222220002', '44444444-4444-4444-4444-444444440001', 'Rest and Motion — Frame of Reference', 1),

  ('44444444-4444-4444-4444-444444440002', '22222222-2222-2222-2222-222222220002', null, 'Vectors and Scalars',           2),
  ('44444444-4444-4444-4444-444444440012', '22222222-2222-2222-2222-222222220002', '44444444-4444-4444-4444-444444440002', 'Types of Vectors and Vector Addition', 1),

  ('44444444-4444-4444-4444-444444440003', '22222222-2222-2222-2222-222222220002', null, 'Motion in a Straight Line',     3),
  ('44444444-4444-4444-4444-444444440013', '22222222-2222-2222-2222-222222220002', '44444444-4444-4444-4444-444444440003', 'Equations of Motion for Uniform Acceleration', 1),

  ('44444444-4444-4444-4444-444444440004', '22222222-2222-2222-2222-222222220002', null, 'Projectile Motion',             4),
  ('44444444-4444-4444-4444-444444440014', '22222222-2222-2222-2222-222222220002', '44444444-4444-4444-4444-444444440004', 'Horizontal and Oblique Projectile', 1)
on conflict (id) do nothing;

-- -------------------------
-- Chapter 3 — Laws of Motion  (chapter id ...0003)
-- -------------------------
insert into physics_subtopics (id, chapter_id, parent_id, title, order_index) values
  ('55555555-5555-5555-5555-555555550001', '22222222-2222-2222-2222-222222220003', null, 'Newton''s First Law of Motion', 1),
  ('55555555-5555-5555-5555-555555550011', '22222222-2222-2222-2222-222222220003', '55555555-5555-5555-5555-555555550001', 'Inertia and Types of Inertia', 1),

  ('55555555-5555-5555-5555-555555550002', '22222222-2222-2222-2222-222222220003', null, 'Newton''s Second Law of Motion', 2),
  ('55555555-5555-5555-5555-555555550012', '22222222-2222-2222-2222-222222220003', '55555555-5555-5555-5555-555555550002', 'Linear Momentum and Impulse', 1),

  ('55555555-5555-5555-5555-555555550003', '22222222-2222-2222-2222-222222220003', null, 'Newton''s Third Law of Motion', 3),
  ('55555555-5555-5555-5555-555555550013', '22222222-2222-2222-2222-222222220003', '55555555-5555-5555-5555-555555550003', 'Conservation of Linear Momentum', 1),

  ('55555555-5555-5555-5555-555555550004', '22222222-2222-2222-2222-222222220003', null, 'Friction',                      4),
  ('55555555-5555-5555-5555-555555550014', '22222222-2222-2222-2222-222222220003', '55555555-5555-5555-5555-555555550004', 'Static, Kinetic and Rolling Friction', 1)
on conflict (id) do nothing;
