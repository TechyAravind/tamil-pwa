-- ============================================================
-- Physics (Classical Physics · 11th Standard) — Seed Data
-- Run this SECOND, after physics_schema.sql.
-- Fixed UUIDs are used throughout + "on conflict (id) do nothing"
-- so this file is safe to run more than once.
--
-- Contents:
--   • 3 broad groups (Content page)
--   • all 11 chapters of the Samacheer Kalvi 11th Physics TOC,
--     correctly grouped
--   • full pilot content (Theory outline + Text + Presentation
--     slides + Videos) for Chapter 1, subtopics
--       1. Science – Introduction / 1.1 Scientific Method
--       2. Physics – Introduction / 2.1 Branches of Physics
--   • every other chapter exists (so the TOC is fully populated)
--     but has no subtopics yet — add those later from
--     /admin/physics-subtopics
-- ============================================================

-- -------------------------
-- 1. GROUPS
-- -------------------------
insert into physics_groups (id, name, order_index) values
  ('11111111-1111-1111-1111-111111111101', 'Mechanics',                          1),
  ('11111111-1111-1111-1111-111111111102', 'Bulk Matter & Thermal Physics',       2),
  ('11111111-1111-1111-1111-111111111103', 'Oscillations & Waves',                3)
on conflict (id) do nothing;

-- -------------------------
-- 2. CHAPTERS (real Samacheer Kalvi 11th Physics TOC)
-- -------------------------
insert into physics_chapters (id, group_id, title, order_index) values
  ('22222222-2222-2222-2222-222222220001', '11111111-1111-1111-1111-111111111101', 'Nature of Physical World and Measurement',      1),
  ('22222222-2222-2222-2222-222222220002', '11111111-1111-1111-1111-111111111101', 'Kinematics',                                     2),
  ('22222222-2222-2222-2222-222222220003', '11111111-1111-1111-1111-111111111101', 'Laws of Motion',                                 3),
  ('22222222-2222-2222-2222-222222220004', '11111111-1111-1111-1111-111111111101', 'Work, Energy and Power',                         4),
  ('22222222-2222-2222-2222-222222220005', '11111111-1111-1111-1111-111111111101', 'Motion of System of Particles and Rigid Bodies', 5),
  ('22222222-2222-2222-2222-222222220006', '11111111-1111-1111-1111-111111111101', 'Gravitation',                                    6),
  ('22222222-2222-2222-2222-222222220007', '11111111-1111-1111-1111-111111111102', 'Properties of Matter',                           1),
  ('22222222-2222-2222-2222-222222220008', '11111111-1111-1111-1111-111111111102', 'Heat and Thermodynamics',                        2),
  ('22222222-2222-2222-2222-222222220009', '11111111-1111-1111-1111-111111111102', 'Kinetic Theory of Gases',                        3),
  ('22222222-2222-2222-2222-222222220010', '11111111-1111-1111-1111-111111111103', 'Oscillations',                                   1),
  ('22222222-2222-2222-2222-222222220011', '11111111-1111-1111-1111-111111111103', 'Waves',                                          2)
on conflict (id) do nothing;

-- -------------------------
-- 3. PILOT SUBTOPICS (Chapter 1 — Nature of Physical World and Measurement)
-- -------------------------
insert into physics_subtopics (id, chapter_id, parent_id, title, order_index) values
  ('33333333-3333-3333-3333-333333330001', '22222222-2222-2222-2222-222222220001', null, 'Science – Introduction',    1),
  ('33333333-3333-3333-3333-333333330002', '22222222-2222-2222-2222-222222220001', '33333333-3333-3333-3333-333333330001', 'Scientific Method', 1),
  ('33333333-3333-3333-3333-333333330003', '22222222-2222-2222-2222-222222220001', null, 'Physics – Introduction',    2),
  ('33333333-3333-3333-3333-333333330004', '22222222-2222-2222-2222-222222220001', '33333333-3333-3333-3333-333333330003', 'Branches of Physics', 1)
on conflict (id) do nothing;

-- -------------------------
-- 4. TEXT (Text tab)
-- -------------------------
insert into physics_subtopic_text (subtopic_id, content_text, order_index) values
  ('33333333-3333-3333-3333-333333330001',
   'Science is a systematic and organised way of gathering knowledge about the natural world through observation, experimentation, and logical reasoning. It began with early humans'' curiosity about natural phenomena such as the rising and setting of the Sun, the changing seasons, and the movement of the stars.',
   1),
  ('33333333-3333-3333-3333-333333330001',
   'Modern science rests on the idea that nature can be understood and explained in terms of a small number of concepts and laws, and that these laws can be verified and tested by experiment. This is what distinguishes science from superstition and blind belief.',
   2),

  ('33333333-3333-3333-3333-333333330002',
   'The scientific method is a systematic procedure scientists follow to investigate natural phenomena. It broadly involves four steps: (1) careful observation of a natural event, (2) formulation of a hypothesis to explain the observation, (3) designing and performing experiments to test the hypothesis, and (4) analysing the results to accept, reject, or modify the hypothesis.',
   1),
  ('33333333-3333-3333-3333-333333330002',
   'A hypothesis that survives repeated experimental testing and can explain a wide range of phenomena becomes a scientific theory or law. Laws such as Newton''s laws of motion are the outcome of this rigorous process of observation, hypothesis, and verification.',
   2),

  ('33333333-3333-3333-3333-333333330003',
   'Physics is the branch of science that deals with the study of the basic laws of nature and their manifestation in different phenomena. The word "physics" comes from a Greek word meaning "nature". Physics tries to explain the behaviour of matter and energy at scales ranging from the sub-atomic to the astronomical.',
   1),
  ('33333333-3333-3333-3333-333333330003',
   'The scope of physics is extremely wide — it covers length scales from less than 10⁻¹⁴ m (the size of a nucleus) to more than 10²⁶ m (the size of the observable universe), making it one of the most fundamental and unifying of all the sciences.',
   2),

  ('33333333-3333-3333-3333-333333330004',
   'Physics is broadly classified into Classical Physics and Modern Physics. Classical Physics deals with macroscopic phenomena understood before the twentieth century, and includes Mechanics (motion of bodies under forces), Thermodynamics (heat and temperature), Optics (behaviour of light), Electricity and Magnetism, and the study of Waves and Oscillations.',
   1),
  ('33333333-3333-3333-3333-333333330004',
   'Modern Physics developed in the twentieth century to explain phenomena classical physics could not, such as the behaviour of atoms and sub-atomic particles. It includes the Theory of Relativity, Quantum Mechanics, Atomic and Nuclear Physics, and Condensed Matter Physics.',
   2);

-- -------------------------
-- 5. SLIDES (Presentation tab — image_url left null;
--    the UI renders a styled placeholder card from the caption
--    until real slide images/diagrams are uploaded)
-- -------------------------
insert into physics_slides (subtopic_id, image_url, caption, order_index) values
  ('33333333-3333-3333-3333-333333330001', null, 'What is Science? — A systematic way of understanding nature through observation and reasoning.', 1),
  ('33333333-3333-3333-3333-333333330001', null, 'From Curiosity to Knowledge — early humans observed the Sun, Moon, and seasons to form the earliest scientific ideas.', 2),
  ('33333333-3333-3333-3333-333333330001', null, 'Core Idea — nature follows a small number of universal laws that can be tested by experiment.', 3),

  ('33333333-3333-3333-3333-333333330002', null, 'Step 1: Observation — carefully watch and record a natural phenomenon.', 1),
  ('33333333-3333-3333-3333-333333330002', null, 'Step 2: Hypothesis — propose a possible explanation for what was observed.', 2),
  ('33333333-3333-3333-3333-333333330002', null, 'Step 3: Experiment — test the hypothesis under controlled conditions.', 3),
  ('33333333-3333-3333-3333-333333330002', null, 'Step 4: Theory / Law — a hypothesis verified repeatedly becomes an accepted theory or law.', 4),

  ('33333333-3333-3333-3333-333333330003', null, 'What is Physics? — the study of the fundamental laws governing matter and energy.', 1),
  ('33333333-3333-3333-3333-333333330003', null, 'Scale of Physics — from the atomic nucleus (10⁻¹⁴ m) to the observable universe (10²⁶ m).', 2),
  ('33333333-3333-3333-3333-333333330003', null, 'Physics Unifies — the same basic laws explain a falling apple and an orbiting planet.', 3),

  ('33333333-3333-3333-3333-333333330004', null, 'Classical Physics — Mechanics, Thermodynamics, Optics, Electricity & Magnetism, Waves.', 1),
  ('33333333-3333-3333-3333-333333330004', null, 'Modern Physics — Relativity, Quantum Mechanics, Atomic & Nuclear Physics.', 2),
  ('33333333-3333-3333-3333-333333330004', null, 'Why the split? — modern physics explains what classical physics could not, at atomic scales and near light speed.', 3);

-- -------------------------
-- 6. VIDEOS (Videos tab — real, publicly embeddable YouTube clips;
--    re-verify embeddability if a channel later restricts it)
-- -------------------------
insert into physics_videos (subtopic_id, video_url, caption, order_index) values
  ('33333333-3333-3333-3333-333333330002',
   'https://www.youtube.com/watch?v=xOLcZMw0hd4',
   'Crash Course Biology #2 — The Scientific Method: how scientists observe, hypothesise, and test ideas.',
   1),
  ('33333333-3333-3333-3333-333333330004',
   'https://www.youtube.com/watch?v=XacSiOX7SwY',
   'Branches of Physics — Classical, Modern & Beyond: a beginner-friendly overview.',
   1);
