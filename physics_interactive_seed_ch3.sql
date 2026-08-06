-- ============================================================
-- Interactive Physics — Content for Chapter 3 (Laws of Motion)
--
-- Run this AFTER physics_interactive_schema.sql.
--
-- 7 lessons (one per real textbook section 3.1-3.7), each a
-- Motivation -> Explanation -> Worked Example -> Practice
-- Questions sequence. Every worked example and most practice
-- questions are adapted from the ACTUAL numbered examples in
-- the Samacheer Kalvi 11th Physics textbook (Examples 3.2, 3.6,
-- 3.10-3.14, 3.18-3.22, 3.25, 3.26), rewritten in plain, lucid
-- language rather than copied verbatim, per your instruction to
-- use the textbook as source material (சாரம்) and not reproduce
-- its denser phrasing.
--
-- Idempotent: fixed UUIDs + "on conflict (id) do nothing".
-- ============================================================

-- ============================================================
-- LESSON 1 — "Why Do Things Move?"  (maps to 3.1 Introduction)
-- ============================================================
insert into physics_ip_lessons (id, chapter_id, title, hook_summary, order_index) values
('77777777-7777-7777-7777-000000000001', '22222222-2222-2222-2222-222222220003',
 'Why Do Things Move?',
 'Aristotle said forces keep things moving. Galileo proved him wrong.',
 1)
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, data, explanation_text, common_mistake) values
('88888888-8888-8888-8888-000000000001', 'mcq',
 'About 2500 years ago, which idea did Aristotle propose about motion?',
 $${"options": ["A force is needed only to start motion, never to maintain it.", "A force is needed continuously to keep an object moving.", "Objects move forever unless a force acts on them.", "Motion and force are completely unrelated."], "correct_index": 1}$$::jsonb,
 $$Aristotle believed continuous force was necessary for continuous motion. It matched everyday, friction-filled experience, but turned out to be incomplete.$$,
 $$Don't confuse this with Newton's later, correct idea. Aristotle's version doesn't account for friction being the hidden force that actually stops things.$$
),
('88888888-8888-8888-8888-000000000002', 'fill_blank',
 'In Galileo''s two-ramp experiment, as the second ramp is made flatter and flatter, the ball must travel a greater or shorter distance to climb back to its original height? And when the ramp becomes perfectly flat (angle = 0 degrees), what does the ball do?',
 $${"blanks": [{"label": "Distance needed to regain height", "type": "dropdown", "choices": ["greater", "shorter"], "correct": "greater"}, {"label": "On a perfectly flat surface, the ball", "type": "dropdown", "choices": ["rolls forever, at constant speed", "travels a fixed short distance then stops"], "correct": "rolls forever, at constant speed"}]}$$::jsonb,
 $$Since no energy is lost to friction, the ball always regains its starting height. A flatter ramp means "up" is farther away, so the distance grows -- and at zero incline, height is never regained, so the ball rolls on indefinitely.$$,
 null
),
('88888888-8888-8888-8888-000000000003', 'match',
 'Match each scientist to the idea they are known for regarding motion.',
 $${"left": ["Aristotle", "Galileo", "Newton"], "right": ["Formalized three precise laws of motion", "Force is required to maintain motion", "Showed force is only needed to CHANGE motion, not maintain it"], "correct_pairs": [[0,1],[1,2],[2,0]]}$$::jsonb,
 null, null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, body_text, question_id, order_index) values
('99999999-9999-9999-9999-000000000001', '77777777-7777-7777-7777-000000000001', 'motivation',
 'The Ball That Wouldn''t Stop',
 $$Imagine rolling a ball down a smooth ramp and letting it climb an identical ramp on the other side. It rises almost to the same height it started from -- every time, no matter how far apart the ramps are. Now flatten the second ramp completely. What happens to the ball? Does it ever stop on its own?$$,
 null, 1),
('99999999-9999-9999-9999-000000000002', '77777777-7777-7777-7777-000000000001', 'explanation',
 'Aristotle vs. Galileo',
 $$About 2500 years ago, Aristotle claimed that a force is needed to keep anything moving -- stop pushing, and motion stops. It matched everyday experience: carts stop when you stop pulling them.

But in the 1600s, Galileo ran a clever experiment with two smooth inclined ramps facing each other. He noticed the ball always climbed back to nearly its starting height, regardless of the second ramp's angle. As he flattened that ramp, the ball had to travel farther and farther to reach the same height -- and when the ramp became perfectly flat, the ball would have to travel forever, moving in a straight line without ever slowing down.

Galileo's conclusion: motion doesn't need a force to continue. It only needs a force to change.$$,
 null, 2),
('99999999-9999-9999-9999-000000000003', '77777777-7777-7777-7777-000000000001', 'example',
 'Reading Galileo''s Experiment',
 $$Setup: a ball rolls down ramp 1 and up ramp 2, both frictionless.

Question: as ramp 2's angle decreases toward zero, what happens to the distance the ball travels before reaching its original height?

Reasoning: the ball always climbs back to the same height, since energy is conserved and there's no friction to remove any. As the ramp flattens, "reaching the same height" requires traveling further and further sideways. At an angle of exactly zero, the ball never regains that height, because the ramp is now flat ground stretching onward -- so the ball just keeps rolling.

Conclusion: on a frictionless flat surface, a moving object continues moving forever unless something acts on it. This built-in resistance to changing motion is called inertia -- the seed of Newton's First Law, which we'll meet in the next lesson.$$,
 null, 3),
('99999999-9999-9999-9999-000000000004', '77777777-7777-7777-7777-000000000001', 'question', null, null, '88888888-8888-8888-8888-000000000001', 4),
('99999999-9999-9999-9999-000000000005', '77777777-7777-7777-7777-000000000001', 'question', null, null, '88888888-8888-8888-8888-000000000002', 5),
('99999999-9999-9999-9999-000000000006', '77777777-7777-7777-7777-000000000001', 'question', null, null, '88888888-8888-8888-8888-000000000003', 6)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 2 — "The Three Rules That Run the Universe" (3.2 Newton's Laws)
-- ============================================================
insert into physics_ip_lessons (id, chapter_id, title, hook_summary, order_index) values
('77777777-7777-7777-7777-000000000002', '22222222-2222-2222-2222-222222220003',
 'The Three Rules That Run the Universe',
 'A horse pulls a cart forward. The cart pulls back just as hard. So why does anything move?',
 2)
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, data, explanation_text, common_mistake) values
('88888888-8888-8888-8888-000000000004', 'fill_blank',
 'A 4 kg block and a 20 kg block each feel the same 8 N force. Find the acceleration of each block.',
 $${"blanks": [{"label": "Acceleration of 4 kg block (m/s^2)", "type": "number", "correct": 2}, {"label": "Acceleration of 20 kg block (m/s^2)", "type": "number", "correct": 0.4}]}$$::jsonb,
 $$a = F/m. For 4 kg: 8/4 = 2 m/s^2. For 20 kg: 8/20 = 0.4 m/s^2. The heavier block accelerates five times slower for the same force -- acceleration is inversely proportional to mass.$$,
 null
),
('88888888-8888-8888-8888-000000000005', 'mcq',
 'A pendulum bob swings on a string. Ignoring air resistance, which two forces act on it at any point in its swing?',
 $${"options": ["Gravity and the string tension only", "Gravity, tension, and air pushing it forward", "Only the string tension", "Gravity and a forward 'swinging' force"], "correct_index": 0}$$::jsonb,
 $$Exactly two real forces act on the bob: its weight (mg, always straight down) and the tension in the string (always along the string, toward the support). There is no separate "motion force" -- the bob's curved path comes entirely from how these two forces combine.$$,
 $$It's tempting to invent a force "in the direction of motion" to explain why the bob keeps swinging -- but motion doesn't need its own force. Only CHANGES in motion do.$$
),
('88888888-8888-8888-8888-000000000006', 'fill_blank',
 'Solve the horse-and-cart puzzle. The horse pulls the cart forward with force F_h. By Newton''s Third Law, the cart pulls the horse backward with force F_c. How does F_c compare to F_h, do the two forces act on the same object or two different objects, and what actually pushes the horse forward?',
 $${"blanks": [{"label": "F_c compared to F_h", "type": "dropdown", "choices": ["greater than", "less than", "equal to"], "correct": "equal to"}, {"label": "F_h and F_c act on", "type": "dropdown", "choices": ["the same object", "two different objects"], "correct": "two different objects"}, {"label": "The horse is pushed forward by", "type": "dropdown", "choices": ["the ground, through friction on its hooves", "the cart", "the air"], "correct": "the ground, through friction on its hooves"}]}$$::jsonb,
 $$F_h acts ON the cart; F_c acts ON the horse -- two different objects, so they never cancel in the same free-body diagram. What actually moves the system forward is the ground pushing the horse's hooves forward (friction), which is bigger than the backward pull of the cart.$$,
 $$The classic trap is comparing F_h and F_c as if they act on the same body. They're an action-reaction pair on two SEPARATE bodies, so "equal and opposite" does not mean "the system can't accelerate."$$
),
('88888888-8888-8888-8888-000000000007', 'match',
 'Match each law to its one-line statement.',
 $${"left": ["Newton's First Law", "Newton's Second Law", "Newton's Third Law"], "right": ["Net force equals mass times acceleration (F = ma)", "Every action has an equal and opposite reaction", "An object keeps its state of motion unless a net force acts on it"], "correct_pairs": [[0,2],[1,0],[2,1]]}$$::jsonb,
 null, null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, body_text, question_id, order_index) values
('99999999-9999-9999-9999-000000000007', '77777777-7777-7777-7777-000000000002', 'motivation',
 'The Horse-and-Cart Puzzle',
 $$A horse pulls a cart with some forward force. By Newton's Third Law, the cart pulls back on the horse with an exactly equal and opposite force. If the two forces are always equal and opposite, why doesn't everything just cancel out and stay still forever? Yet horses pull carts forward every day. Something's missing from this picture -- let's find out what.$$,
 null, 1),
('99999999-9999-9999-9999-000000000008', '77777777-7777-7777-7777-000000000002', 'explanation',
 'Newton''s Three Laws, in Plain Language',
 $$First Law (Inertia): an object keeps doing what it's already doing -- staying still or moving at constant velocity -- unless a net force acts on it. This resistance to changing motion is called inertia; heavier objects have more of it.

Second Law (F = ma): a net force causes an object to accelerate. More force means more acceleration; more mass means less acceleration for the same force. This single equation lets us calculate motion whenever we know the forces involved.

Third Law (Action-Reaction): whenever one object pushes or pulls on a second object, the second object pushes or pulls back on the first with equal strength, in the opposite direction. These two forces always act on two DIFFERENT objects -- never the same one -- which is the key to solving the horse-and-cart puzzle above.$$,
 null, 2),
('99999999-9999-9999-9999-000000000009', '77777777-7777-7777-7777-000000000002', 'example',
 'Same Force, Different Acceleration',
 $$Two objects -- one of mass 2.5 kg, one of mass 100 kg -- each feel the exact same 5 N push. What acceleration does each one experience?

Using Newton's Second Law, a = F / m.

For the 2.5 kg object: a = 5 / 2.5 = 2 m/s^2.
For the 100 kg object: a = 5 / 100 = 0.05 m/s^2.

Same force, wildly different results -- the heavier object barely notices the push. This is why a gentle shove moves a bicycle easily but does almost nothing to a parked car: mass resists acceleration.$$,
 null, 3),
('99999999-9999-9999-9999-000000000010', '77777777-7777-7777-7777-000000000002', 'question', null, null, '88888888-8888-8888-8888-000000000004', 4),
('99999999-9999-9999-9999-000000000011', '77777777-7777-7777-7777-000000000002', 'question', null, null, '88888888-8888-8888-8888-000000000005', 5),
('99999999-9999-9999-9999-000000000012', '77777777-7777-7777-7777-000000000002', 'question', null, null, '88888888-8888-8888-8888-000000000006', 6),
('99999999-9999-9999-9999-000000000013', '77777777-7777-7777-7777-000000000002', 'question', null, null, '88888888-8888-8888-8888-000000000007', 7)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 3 — "Reading a Force Diagram" (3.3 Application of Newton's Laws)
-- ============================================================
insert into physics_ip_lessons (id, chapter_id, title, hook_summary, order_index) values
('77777777-7777-7777-7777-000000000003', '22222222-2222-2222-2222-222222220003',
 'Reading a Force Diagram',
 'One diagram, one arrow per force, makes almost any physics problem solvable.',
 3)
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, data, explanation_text, common_mistake) values
('88888888-8888-8888-8888-000000000008', 'fill_blank',
 'A 5 kg object rests on flat, horizontal ground (g = 9.8 m/s^2). Since it isn''t accelerating, find the normal force N.',
 $${"blanks": [{"label": "N (Newtons)", "type": "number", "correct": 49}]}$$::jsonb,
 $$On flat ground, N = mg = 5 x 9.8 = 49 N. Weight and normal force are the only two forces, and they must balance exactly since there's no vertical acceleration.$$,
 null
),
('88888888-8888-8888-8888-000000000009', 'fill_blank',
 'A 4 kg block rests on a frictionless incline tilted at 30 degrees. Find the normal force acting on it. (cos 30 degrees is about 0.87, g = 9.8 m/s^2)',
 $${"blanks": [{"label": "N (Newtons, 2 decimal places)", "type": "number", "correct": 34.10}]}$$::jsonb,
 $$N = mg cos(theta) = 4 x 9.8 x 0.87 = 34.10 N -- noticeably less than the full weight of 39.2 N, because part of the weight now acts down the slope instead of into it.$$,
 null
),
('88888888-8888-8888-8888-000000000010', 'mcq',
 'Block B sits directly on top of block A, which sits on the ground. Which forces act on block A?',
 $${"options": ["Only its own weight", "Its own weight and the downward push from block B resting on it, balanced by the upward normal force from the ground", "Only the normal force from the ground", "Its own weight and an upward push from block B"], "correct_index": 1}$$::jsonb,
 $$Block A carries its own weight plus the weight of block B pressing down on it (Newton's Third Law: A pushes up on B, so B pushes down on A). The ground's normal force on A balances both.$$,
 null
),
('88888888-8888-8888-8888-000000000011', 'rank',
 'For the same mass, rank these three inclines by the normal force they produce -- from greatest to smallest.',
 $${"items": ["10 degree incline", "40 degree incline", "70 degree incline"], "correct_order": [0,1,2]}$$::jsonb,
 $$N = mg cos(theta), and cos(theta) shrinks as theta grows. So the gentlest slope (10 degrees) has the largest normal force, and the steepest (70 degrees) has the smallest -- most of the weight has "tipped over" into pulling the object down the slope instead of into it.$$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, body_text, question_id, order_index) values
('99999999-9999-9999-9999-000000000014', '77777777-7777-7777-7777-000000000003', 'motivation',
 'The Ramp That Feels Heavier',
 $$You push a loaded cart up a smooth ramp, and it feels completely different from pushing it across flat ground -- even though the cart weighs exactly the same. Straight-down weight doesn't seem to explain the extra resistance you feel going uphill. What's really happening to that weight on a slope?$$,
 null, 1),
('99999999-9999-9999-9999-000000000015', '77777777-7777-7777-7777-000000000003', 'explanation',
 'Drawing a Free Body Diagram (FBD)',
 $$A free body diagram is a simple sketch of a single object with an arrow for every force acting on it -- nothing else. The four forces you'll draw again and again are: weight (mg, always straight down), the normal force (N, always perpendicular to the surface, pushing the object away from it), tension (T, along a string or rope, pulling), and friction (f, along the surface, opposing sliding or attempted sliding).

On a flat, horizontal surface, weight and normal force point in exactly opposite directions, so they cancel and N = mg. But tilt the surface into a ramp, and weight still points straight down while the normal force stays perpendicular to the ramp -- they're no longer simple opposites of each other anymore.$$,
 null, 2),
('99999999-9999-9999-9999-000000000016', '77777777-7777-7777-7777-000000000003', 'example',
 'Weight on an Incline',
 $$An object rests on a frictionless surface tilted at angle theta. Since the object doesn't accelerate perpendicular to the ramp, the forces in that direction must balance: the normal force N exactly cancels the perpendicular component of weight.

The perpendicular component of weight is mg cos(theta), so: N = mg cos(theta).

Notice this is smaller than the full weight mg, since cos(theta) is less than 1 for any tilt -- some of the weight is "used up" pulling the object down the slope instead of into the surface. That's the extra pull you feel pushing a cart uphill: part of its weight now acts along the direction you're pushing.$$,
 null, 3),
('99999999-9999-9999-9999-000000000017', '77777777-7777-7777-7777-000000000003', 'question', null, null, '88888888-8888-8888-8888-000000000008', 4),
('99999999-9999-9999-9999-000000000018', '77777777-7777-7777-7777-000000000003', 'question', null, null, '88888888-8888-8888-8888-000000000009', 5),
('99999999-9999-9999-9999-000000000019', '77777777-7777-7777-7777-000000000003', 'question', null, null, '88888888-8888-8888-8888-000000000010', 6),
('99999999-9999-9999-9999-000000000020', '77777777-7777-7777-7777-000000000003', 'question', null, null, '88888888-8888-8888-8888-000000000011', 7)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 4 — "Three Forces in Balance" (3.4 Lami's Theorem)
-- ============================================================
insert into physics_ip_lessons (id, chapter_id, title, hook_summary, order_index) values
('77777777-7777-7777-7777-000000000004', '22222222-2222-2222-2222-222222220003',
 'Three Forces in Balance',
 'When exactly three forces hold something still, one elegant rule connects them all.',
 4)
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, data, explanation_text, common_mistake) values
('88888888-8888-8888-8888-000000000012', 'fill_blank',
 'A 12 kg baby hangs from two identical chains, each at 20 degrees from the vertical (cos 20 degrees is about 0.94, g = 9.8 m/s^2). Find the tension in each chain.',
 $${"blanks": [{"label": "T (Newtons, 1 decimal place)", "type": "number", "correct": 62.6}]}$$::jsonb,
 $$T = mg / (2 cos(theta)) = (12 x 9.8) / (2 x 0.94) = 117.6 / 1.88 = 62.6 N per chain.$$,
 null
),
('88888888-8888-8888-8888-000000000013', 'mcq',
 'For Lami''s theorem to apply to three forces, what must be true about them?',
 $${"options": ["They must all have equal magnitude", "They must be coplanar and concurrent (act at the same point), and the object must be in equilibrium", "They must all point in the same direction", "They must be exactly perpendicular to each other"], "correct_index": 1}$$::jsonb,
 $$Lami's theorem specifically requires three coplanar, concurrent forces on an object with zero net force. There's no requirement that the forces be equal or at right angles -- the theorem relates whatever angles happen to exist between them.$$,
 null
),
('88888888-8888-8888-8888-000000000014', 'match',
 'In the swing example, match each item to its correct description.',
 $${"left": ["mg", "T (each chain)", "theta = 0 degrees"], "right": ["Special case where each chain simply carries half the weight", "The baby's weight, acting straight down", "The tension in each identical chain, acting along the chain"], "correct_pairs": [[0,1],[1,2],[2,0]]}$$::jsonb,
 null, null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, body_text, question_id, order_index) values
('99999999-9999-9999-9999-000000000021', '77777777-7777-7777-7777-000000000004', 'motivation',
 'A Baby on a Swing',
 $$A baby swing hangs at rest from two identical chains, angled outward. Gravity pulls the baby straight down, and each chain pulls up and inward along its own angle. Three forces, one motionless baby -- how do we find the tension in each chain without breaking the problem into a dozen steps?$$,
 null, 1),
('99999999-9999-9999-9999-000000000022', '77777777-7777-7777-7777-000000000004', 'explanation',
 'Lami''s Theorem',
 $$When exactly three forces act at a single point and keep it in equilibrium (no net force), Lami's theorem says: each force, divided by the sine of the angle between the OTHER two forces, gives the same value for all three.

In symbols: F1 / sin(angle opposite F1) = F2 / sin(angle opposite F2) = F3 / sin(angle opposite F3).

It's a shortcut -- instead of separately resolving every force into x and y components, you can often read the answer straight off a force triangle.$$,
 null, 2),
('99999999-9999-9999-9999-000000000023', '77777777-7777-7777-7777-000000000004', 'example',
 'Tension in the Swing Chains',
 $$A baby of weight mg hangs from two identical chains, each making angle theta with the vertical. By symmetry, both chains carry the same tension T.

Balancing the vertical forces (both chains contribute equally): 2T cos(theta) = mg, so T = mg / (2 cos(theta)).

Check: when theta = 0 degrees (chains hang straight down), T = mg/2 -- each chain simply carries half the weight, exactly as expected.$$,
 null, 3),
('99999999-9999-9999-9999-000000000024', '77777777-7777-7777-7777-000000000004', 'question', null, null, '88888888-8888-8888-8888-000000000012', 4),
('99999999-9999-9999-9999-000000000025', '77777777-7777-7777-7777-000000000004', 'question', null, null, '88888888-8888-8888-8888-000000000013', 5),
('99999999-9999-9999-9999-000000000026', '77777777-7777-7777-7777-000000000004', 'question', null, null, '88888888-8888-8888-8888-000000000014', 6)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 5 — "What Never Changes in a Collision" (3.5 Conservation of Momentum)
-- ============================================================
insert into physics_ip_lessons (id, chapter_id, title, hook_summary, order_index) values
('77777777-7777-7777-7777-000000000005', '22222222-2222-2222-2222-222222220003',
 'What Never Changes in a Collision',
 'Fire a bullet forward, and the gun kicks back. Nothing outside the system made that happen.',
 5)
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, data, explanation_text, common_mistake) values
('88888888-8888-8888-8888-000000000015', 'fill_blank',
 'A 3 kg rifle fires a 0.02 kg bullet at 300 m/s. Find the recoil speed of the rifle.',
 $${"blanks": [{"label": "Recoil speed (m/s)", "type": "number", "correct": 2}]}$$::jsonb,
 $$m_bullet x v_bullet = m_gun x v_gun, so 0.02 x 300 = 3 x v_gun, giving v_gun = 6/3 = 2 m/s.$$,
 null
),
('88888888-8888-8888-8888-000000000016', 'mcq',
 'Conservation of linear momentum applies to which kind of system?',
 $${"options": ["Any system, regardless of external forces", "Only a system with no net external force acting on it", "Only systems with exactly two objects", "Only systems where objects are moving at the same speed"], "correct_index": 1}$$::jsonb,
 $$The law only guarantees a constant total momentum when the system is isolated from outside forces. Internal forces (like an explosion inside a gun, or two particles colliding) never change the total -- only forces from outside the system can.$$,
 null
),
('88888888-8888-8888-8888-000000000017', 'rank',
 'Three identical guns (same mass) fire different bullets, all initially at rest. Rank the resulting recoil speed of each gun from greatest to smallest. Gun A fires a 0.01 kg bullet at 500 m/s. Gun B fires a 0.02 kg bullet at 300 m/s. Gun C fires a 0.01 kg bullet at 200 m/s.',
 $${"items": ["Gun A (0.01 kg at 500 m/s)", "Gun B (0.02 kg at 300 m/s)", "Gun C (0.01 kg at 200 m/s)"], "correct_order": [1,0,2]}$$::jsonb,
 $$Compare bullet momentum (mass x speed), since recoil speed is proportional to it for equal gun masses: A = 0.01x500 = 5, B = 0.02x300 = 6, C = 0.01x200 = 2. So the order from greatest to smallest recoil is B, A, C.$$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, body_text, question_id, order_index) values
('99999999-9999-9999-9999-000000000027', '77777777-7777-7777-7777-000000000005', 'motivation',
 'Why Does a Gun Recoil?',
 $$Before firing, a gun and its bullet are both at rest -- total momentum zero. The instant the trigger is pulled, the bullet shoots forward at huge speed. Yet no external force pushed on the gun-plus-bullet system from outside. So where does the gun's sudden backward "kick" come from?$$,
 null, 1),
('99999999-9999-9999-9999-000000000028', '77777777-7777-7777-7777-000000000005', 'explanation',
 'Conservation of Linear Momentum',
 $$For an isolated system (no external force acting on it), total momentum before an event always equals total momentum after it -- this is the law of conservation of linear momentum. It doesn't matter how complicated the internal forces are (an explosion, a collision, a spring releasing); if nothing from outside pushes or pulls on the system, its total momentum cannot change.

Before firing, gun and bullet are both at rest, so total momentum = 0. After firing, the bullet carries forward momentum -- so the gun MUST carry exactly equal backward momentum to keep the total at zero. That backward momentum is what we feel as recoil.$$,
 null, 2),
('99999999-9999-9999-9999-000000000029', '77777777-7777-7777-7777-000000000005', 'example',
 'Calculating Recoil Speed',
 $$A 2 kg gun fires a 0.01 kg bullet at 400 m/s. Find the gun's recoil speed.

Total momentum starts at zero, so it must stay at zero: (momentum of bullet) + (momentum of gun) = 0.

m_bullet x v_bullet = m_gun x v_gun
0.01 x 400 = 2 x v_gun
v_gun = 4 / 2 = 2 m/s.

The much heavier gun recoils at a much smaller speed than the bullet's -- same momentum, shared very unequally because of the huge mass difference.$$,
 null, 3),
('99999999-9999-9999-9999-000000000030', '77777777-7777-7777-7777-000000000005', 'question', null, null, '88888888-8888-8888-8888-000000000015', 4),
('99999999-9999-9999-9999-000000000031', '77777777-7777-7777-7777-000000000005', 'question', null, null, '88888888-8888-8888-8888-000000000016', 5),
('99999999-9999-9999-9999-000000000032', '77777777-7777-7777-7777-000000000005', 'question', null, null, '88888888-8888-8888-8888-000000000017', 6)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 6 — "The Force That Almost Stops Everything" (3.6 Friction)
-- ============================================================
insert into physics_ip_lessons (id, chapter_id, title, hook_summary, order_index) values
('77777777-7777-7777-7777-000000000006', '22222222-2222-2222-2222-222222220003',
 'The Force That Almost Stops Everything',
 'Push a heavy box and it doesn''t budge -- because friction quietly pushed back exactly as hard as you did.',
 6)
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, data, explanation_text, common_mistake) values
('88888888-8888-8888-8888-000000000018', 'fill_blank',
 'A 30 kg crate sits at rest on the floor. You push with 12 N and it still doesn''t move. What is the static friction force acting on the crate at that moment?',
 $${"blanks": [{"label": "Static friction (N)", "type": "number", "correct": 12}]}$$::jsonb,
 $$As long as the object stays at rest, static friction always exactly matches the applied force (up to its maximum) -- here, 12 N.$$,
 null
),
('88888888-8888-8888-8888-000000000019', 'fill_blank',
 'A 10 kg block on a table (static friction coefficient 0.5) is connected over a pulley to a hanging mass m2. Find the maximum static friction available, and the largest m2 can be before the block starts to slide. (g = 9.8 m/s^2)',
 $${"blanks": [{"label": "Maximum static friction (N)", "type": "number", "correct": 49}, {"label": "Largest m2 before sliding (kg)", "type": "number", "correct": 5}]}$$::jsonb,
 $$Maximum static friction = 0.5 x 10 x 9.8 = 49 N. The block slides once the hanging weight (m2 x g) exceeds this, i.e. m2 > 49/9.8 = 5 kg.$$,
 null
),
('88888888-8888-8888-8888-000000000020', 'mcq',
 'An object moves across a rough floor at constant velocity while you push it with a steady force. What is the net force acting on it?',
 $${"options": ["Equal to your push, in the direction of motion", "Zero -- your push is exactly balanced by kinetic friction", "Equal to kinetic friction alone", "It has no forces acting on it at all"], "correct_index": 1}$$::jsonb,
 $$Constant velocity means zero acceleration, so by Newton's Second Law the net force is zero. Two real forces still act -- your push forward and kinetic friction backward -- they just cancel exactly.$$,
 $$"Net force is zero" does not mean "no forces are acting." Two forces of equal size still act on the object; they simply add to zero.$$
),
('88888888-8888-8888-8888-000000000021', 'rank',
 'Using these real coefficients of static friction -- glass on glass: 1.0, ice on ice: 0.10, steel on steel: 0.75, wood on wood: 0.35 -- rank the four surface pairs from MOST to LEAST friction.',
 $${"items": ["Glass on glass", "Steel on steel", "Wood on wood", "Ice on ice"], "correct_order": [0,1,2,3]}$$::jsonb,
 $$Ranking the real coefficients from highest to lowest: glass-glass (1.0) > steel-steel (0.75) > wood-wood (0.35) > ice-ice (0.10). A higher coefficient means the surfaces grip each other more strongly before slipping.$$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, body_text, question_id, order_index) values
('99999999-9999-9999-9999-000000000033', '77777777-7777-7777-7777-000000000006', 'motivation',
 'The Push That Went Nowhere',
 $$A 50 kg crate sits on the floor. You push it with 5 N of force. It doesn't move at all. Where did your 5 N go? It didn't vanish -- something pushed back on the crate with exactly 5 N in the opposite direction, keeping it perfectly balanced.$$,
 null, 1),
('99999999-9999-9999-9999-000000000034', '77777777-7777-7777-7777-000000000006', 'explanation',
 'Static vs. Kinetic Friction',
 $$Static friction resists the START of sliding. It's not a fixed value -- it automatically adjusts to match whatever force you apply, up to a maximum: maximum static friction = (coefficient of static friction) x (normal force). As long as your push stays below this maximum, static friction matches it exactly and nothing moves.

Once your push exceeds that maximum, the object breaks free and starts sliding. Now kinetic friction takes over -- usually a bit weaker than the maximum static friction, and roughly constant while sliding continues.$$,
 null, 2),
('99999999-9999-9999-9999-000000000035', '77777777-7777-7777-7777-000000000006', 'example',
 'Will It Slide? Two Blocks and a Pulley',
 $$A 7 kg block sits on a table (static friction coefficient 0.9 between block and table), connected by a string over a pulley to a hanging 5 kg mass. Will the 7 kg block move?

Step 1 -- Maximum static friction available: 0.9 x 7 x 9.8 = 61.74 N.

Step 2 -- Force actually trying to pull the block: the string tension equals the hanging weight, 5 x 9.8 = 49 N.

Step 3 -- Compare: 49 N is less than 61.74 N, so static friction can easily match the pull. The block stays put.

To make it slide, the hanging mass would need to exceed 0.9 x 7 = 6.3 kg.$$,
 null, 3),
('99999999-9999-9999-9999-000000000036', '77777777-7777-7777-7777-000000000006', 'question', null, null, '88888888-8888-8888-8888-000000000018', 4),
('99999999-9999-9999-9999-000000000037', '77777777-7777-7777-7777-000000000006', 'question', null, null, '88888888-8888-8888-8888-000000000019', 5),
('99999999-9999-9999-9999-000000000038', '77777777-7777-7777-7777-000000000006', 'question', null, null, '88888888-8888-8888-8888-000000000020', 6),
('99999999-9999-9999-9999-000000000039', '77777777-7777-7777-7777-000000000006', 'question', null, null, '88888888-8888-8888-8888-000000000021', 7)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 7 — "Why You Feel Pushed Outward on a Turn" (3.7 Dynamics of Circular Motion)
-- ============================================================
insert into physics_ip_lessons (id, chapter_id, title, hook_summary, order_index) values
('77777777-7777-7777-7777-000000000007', '22222222-2222-2222-2222-222222220003',
 'Why You Feel Pushed Outward on a Turn',
 'There''s no such thing as a real "outward force" in circular motion -- yet you can absolutely feel one.',
 7)
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, data, explanation_text, common_mistake) values
('88888888-8888-8888-8888-000000000022', 'fill_blank',
 'A 0.5 kg ball on a string moves in a circle of radius 2 m at 4 m/s. Find the tension in the string.',
 $${"blanks": [{"label": "Tension (N)", "type": "number", "correct": 4}]}$$::jsonb,
 $$Centripetal force = m v^2 / r = 0.5 x 16 / 2 = 4 N.$$,
 null
),
('88888888-8888-8888-8888-000000000023', 'fill_blank',
 'A circular road of radius 20 m is banked at 15 degrees (tan 15 degrees is about 0.27, g = 9.8 m/s^2). Find the safe turning speed for a car on this banked road, assuming no friction is needed. (speed = square root of r times g times tan(theta))',
 $${"blanks": [{"label": "Safe speed (m/s, 1 decimal place)", "type": "number", "correct": 7.3}]}$$::jsonb,
 $$speed = sqrt(r x g x tan(theta)) = sqrt(20 x 9.8 x 0.27) = sqrt(52.92) = 7.3 m/s.$$,
 null
),
('88888888-8888-8888-8888-000000000024', 'mcq',
 'Which statement correctly distinguishes centripetal and centrifugal force?',
 $${"options": ["They are the same force, just different names", "Centripetal force is real and points inward; centrifugal force is a pseudo-force that only appears in a rotating frame, pointing outward", "Centrifugal force is real and centripetal force is not", "Both are pseudo-forces that disappear in every reference frame"], "correct_index": 1}$$::jsonb,
 $$Centripetal force is a genuine force (tension, gravity, friction, etc.) required for any circular motion. Centrifugal force has no physical source -- it's an apparent force that only needs to be included if you choose to work in the rotating (non-inertial) frame.$$,
 null
),
('88888888-8888-8888-8888-000000000025', 'match',
 'Match each circular-motion scenario to the force that is primarily responsible for the centripetal force.',
 $${"left": ["A car turning on a flat road", "A satellite orbiting Earth", "A stone whirled on a string"], "right": ["Gravity", "Tension in the string", "Friction between tires and road"], "correct_pairs": [[0,2],[1,0],[2,1]]}$$::jsonb,
 null, null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, body_text, question_id, order_index) values
('99999999-9999-9999-9999-000000000040', '77777777-7777-7777-7777-000000000007', 'motivation',
 'The Force That Isn''t Really There',
 $$When a car takes a sharp turn, your body seems to get thrown toward the outside of the curve. It feels exactly like a real push. But if you were watching from above the road (an inertial frame), you'd see something different: there's no outward force at all -- just your body trying to keep going in a straight line while the car curves away underneath you.$$,
 null, 1),
('99999999-9999-9999-9999-000000000041', '77777777-7777-7777-7777-000000000007', 'explanation',
 'Centripetal Force vs. Centrifugal Force',
 $$Any object moving in a circle needs a net force pointing toward the center, called the centripetal force: F = m v^2 / r. Without it, the object would simply travel in a straight line (Newton's First Law). This is a real force -- supplied by tension in a string, gravity for orbiting planets, or friction for a car on a curve.

Centrifugal force is different: it only shows up if you insist on analyzing the motion from inside the rotating frame (like sitting in the turning car). From that viewpoint, an object at rest needs an outward pseudo-force to explain why it isn't accelerating inward with everything else. It's not a force from any physical source -- it's what inertia looks like when you're the one turning.$$,
 null, 2),
('99999999-9999-9999-9999-000000000042', '77777777-7777-7777-7777-000000000007', 'example',
 'Tension in a Whirling String',
 $$A 0.25 kg stone tied to a string moves in a circle of radius 3 m at a constant speed of 2 m/s. Find the tension in the string.

The string supplies the centripetal force, so T = m v^2 / r.

T = 0.25 x (2)^2 / 3 = 0.25 x 4 / 3 = 1/3 = 0.333 N.

That's the entire tension in the string -- not because the stone is "flying outward," but because it takes exactly this much inward pull to keep bending the stone's path into a circle instead of letting it fly off in a straight line.$$,
 null, 3),
('99999999-9999-9999-9999-000000000043', '77777777-7777-7777-7777-000000000007', 'question', null, null, '88888888-8888-8888-8888-000000000022', 4),
('99999999-9999-9999-9999-000000000044', '77777777-7777-7777-7777-000000000007', 'question', null, null, '88888888-8888-8888-8888-000000000023', 5),
('99999999-9999-9999-9999-000000000045', '77777777-7777-7777-7777-000000000007', 'question', null, null, '88888888-8888-8888-8888-000000000024', 6),
('99999999-9999-9999-9999-000000000046', '77777777-7777-7777-7777-000000000007', 'question', null, null, '88888888-8888-8888-8888-000000000025', 7)
on conflict (id) do nothing;
