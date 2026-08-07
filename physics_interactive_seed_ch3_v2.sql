-- ============================================================
-- Interactive Physics — Content Update (v2)
--
-- Run this AFTER physics_interactive_schema.sql,
-- physics_interactive_seed_ch3.sql, AND physics_interactive_schema_v2.sql.
--
-- What this does:
--   1. Deepens LESSON 1 ("Why Do Things Move?") in place -- same
--      lesson id/slot in the Interactive Physics tab, but replaces its
--      3-question content with a fuller 5-question treatment (dropdown
--      conceptual questions, a numeric worked example + follow-up,
--      the new drag-line match, and a mark-choices question), fully
--      bilingual, with a diagram on the hook + explanation steps.
--   2. Inserts a brand NEW lesson, "Who's Really Moving? Reference
--      Frames", covering the textbook's inertial/non-inertial frame
--      material that wasn't covered by any existing lesson. It's
--      inserted right after Lesson 1 (order_index 2), so the old
--      Lessons 2-7 are shifted down to order_index 3-8.
--
-- Idempotent: re-running is safe (deletes-then-inserts by fixed id,
-- "on conflict do nothing" on inserts).
-- ============================================================

-- ------------------------------------------------------------
-- 1a. Clear out Lesson 1's old (shallow) questions + steps.
--     Deleting the lesson row would cascade the steps, but we want
--     to KEEP the same lesson id (so it stays in the same TOC slot
--     and any existing "completed" localStorage marker still points
--     at a real lesson) -- so delete steps/questions directly instead.
-- ------------------------------------------------------------
delete from physics_ip_steps where lesson_id = '77777777-7777-7777-7777-000000000001';
delete from physics_ip_questions where id in (
  '88888888-8888-8888-8888-000000000001',
  '88888888-8888-8888-8888-000000000002',
  '88888888-8888-8888-8888-000000000003'
);

-- ------------------------------------------------------------
-- 1b. Re-write Lesson 1's title/hook (bilingual).
-- ------------------------------------------------------------
update physics_ip_lessons set
  title = 'Why Do Things Move? Aristotle vs. Galileo',
  title_ta = $$பொருட்கள் ஏன் நகர்கின்றன? அரிஸ்டாட்டில் Vs கலீலியோ$$,
  hook_summary = 'Aristotle said forces keep things moving. Galileo proved him wrong -- with a ramp.',
  hook_summary_ta = $$விசைதான் இயக்கத்தைத் தொடர வைக்கிறது என அரிஸ்டாட்டில் கூறினார். ஒரு சரிவுத் தளத்தால் கலீலியோ அதைத் தவறு எனக் காட்டினார்.$$
where id = '77777777-7777-7777-7777-000000000001';

-- ------------------------------------------------------------
-- 1c. Lesson 1 questions (new ids, range ...000000000101+).
-- ------------------------------------------------------------
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta) values

('88888888-8888-8888-8888-000000000101', 'fill_blank',
 $$A hockey puck slides on perfectly smooth, frictionless ice at $v = 5$ m/s to the right. No horizontal forces act on it.

According to Aristotle's view, the puck ___. According to Newton's First Law (Galileo's insight), the puck ___.$$,
 $$ஒரு ஹாக்கி பக் முற்றிலும் மென்மையான, உராய்வற்ற பனியில் $v = 5$ மீ/வி வேகத்தில் வலப்புறமாக நகர்கிறது. அதன் மீது கிடைமட்ட விசைகள் எதுவும் செயல்படவில்லை.

அரிஸ்டாட்டிலின் கருத்துப்படி, பக் ___. நியூட்டனின் முதல் விதியின்படி (கலீலியோவின் கண்டுபிடிப்பு), பக் ___.$$,
 $${"blanks": [
   {"label": "Aristotle predicts", "type": "dropdown", "choices": ["slows down and eventually stops, because no force pushes it anymore", "speeds up forever", "continues at 5 m/s forever"], "correct": "slows down and eventually stops, because no force pushes it anymore"},
   {"label": "Newton/Galileo predicts", "type": "dropdown", "choices": ["slows down and eventually stops", "continues at 5 m/s forever, since the net force is zero", "reverses direction"], "correct": "continues at 5 m/s forever, since the net force is zero"}
 ]}$$::jsonb,
 $${"blanks": [
   {"label": "அரிஸ்டாட்டிலின் கணிப்பு", "choices": ["இனி விசை தள்ளாததால், மெதுவாகி இறுதியில் நிற்கும்", "என்றென்றும் வேகமெடுக்கும்", "5 மீ/வி வேகத்தில் என்றென்றும் தொடரும்"]},
   {"label": "நியூட்டன்/கலீலியோவின் கணிப்பு", "choices": ["மெதுவாகி இறுதியில் நிற்கும்", "நிகர விசை பூஜ்ஜியமாக இருப்பதால், 5 மீ/வி வேகத்தில் என்றென்றும் தொடரும்", "திசையை மாற்றிக்கொள்ளும்"]}
 ]}$$::jsonb,
 $$Aristotle's view ties motion to a continuously applied force -- remove the force, expect the motion to fade. Newton's First Law (built on Galileo's ramp result) says the opposite: with zero net force, velocity simply stays constant. On frictionless ice, that's exactly the situation, so the puck glides on forever at 5 m/s.$$,
 $$அரிஸ்டாட்டிலின் கருத்து இயக்கத்தை தொடர்ச்சியான விசையுடன் இணைக்கிறது — விசையை நீக்கினால், இயக்கம் மறையும் என எதிர்பார்க்கப்படுகிறது. நியூட்டனின் முதல் விதி (கலீலியோவின் சரிவுத்தள முடிவை அடிப்படையாகக் கொண்டது) இதற்கு நேர்மாறாகக் கூறுகிறது: நிகர விசை பூஜ்ஜியமாக இருந்தால், திசைவேகம் மாறாமல் இருக்கும். உராய்வற்ற பனியில் இதுவே நிலைமை, எனவே பக் 5 மீ/வி வேகத்தில் என்றென்றும் சறுக்கிச் செல்லும்.$$,
 $$Don't assume "nothing is pushing it" means "it must slow down." That intuition comes from friction-filled daily life, not from an ideal frictionless surface.$$,
 $$"எதுவும் தள்ளவில்லை" என்றால் "அது மெதுவாக வேண்டும்" என்று நினைக்க வேண்டாம். இந்த உள்ளுணர்வு உராய்வு நிறைந்த அன்றாட வாழ்விலிருந்து வருகிறது, இலட்சிய உராய்வற்ற மேற்பரப்பிலிருந்து அல்ல.$$
),

('88888888-8888-8888-8888-000000000102', 'fill_blank',
 $$In Galileo's two-ramp experiment, as the second ramp is made flatter and flatter, does the ball need to travel a greater or shorter distance to climb back to its original height? And when the ramp becomes perfectly flat, what does the ball do?$$,
 $$கலீலியோவின் இரு-சரிவுத் தள சோதனையில், இரண்டாவது தளம் மேலும் மேலும் தட்டையாக்கப்படும்போது, பந்து அதன் அசல் உயரத்திற்குத் திரும்ப ஏற அதிக தூரமா அல்லது குறைந்த தூரமா செல்ல வேண்டும்? தளம் முற்றிலும் தட்டையாகும்போது பந்து என்ன செய்யும்?$$,
 $${"blanks": [
   {"label": "Distance needed to regain height", "type": "dropdown", "choices": ["greater", "shorter"], "correct": "greater"},
   {"label": "On a perfectly flat surface, the ball", "type": "dropdown", "choices": ["rolls forever, at constant speed", "travels a fixed short distance then stops"], "correct": "rolls forever, at constant speed"}
 ]}$$::jsonb,
 $${"blanks": [
   {"label": "உயரத்தை மீண்டும் அடைய தேவையான தூரம்", "choices": ["அதிகம்", "குறைவு"]},
   {"label": "முற்றிலும் தட்டையான மேற்பரப்பில், பந்து", "choices": ["மாறாத வேகத்தில் என்றென்றும் உருளும்", "ஒரு குறுகிய நிலையான தூரம் சென்று நிற்கும்"]}
 ]}$$::jsonb,
 $$Since no energy is lost to friction, the ball always regains its starting height. A flatter ramp means "up" is farther away, so the distance grows -- and at zero incline, height is never regained, so the ball rolls on indefinitely.$$,
 $$உராய்வால் எந்த ஆற்றலும் இழக்கப்படாததால், பந்து எப்போதும் தொடக்க உயரத்தை மீண்டும் அடைகிறது. தட்டையான தளம் என்றால் "மேலே" தொலைவில் இருக்கிறது என்பதால், தூரம் அதிகரிக்கிறது — பூஜ்ஜியக் கோணத்தில், உயரம் ஒருபோதும் அடையப்படாது, எனவே பந்து காலவரையின்றி உருண்டு கொண்டே இருக்கும்.$$,
 null, null
),

('88888888-8888-8888-8888-000000000103', 'match',
 $$Match each scientist to the idea they are known for regarding motion.$$,
 $$ஒவ்வொரு விஞ்ஞானியையும் இயக்கம் தொடர்பான அவரது கருத்துடன் பொருத்துங்கள்.$$,
 $${"left": ["Aristotle", "Galileo", "Newton"], "right": ["Formalized three precise laws of motion", "Force is required to maintain motion", "Showed force is only needed to CHANGE motion, not maintain it"], "correct_pairs": [[0,1],[1,2],[2,0]]}$$::jsonb,
 $${"left": ["அரிஸ்டாட்டில்", "கலீலியோ", "நியூட்டன்"], "right": ["இயக்கத்திற்கான மூன்று துல்லியமான விதிகளை வகுத்தார்", "இயக்கத்தைத் தொடர விசை தேவை என்றார்", "இயக்கத்தை மாற்றவே விசை தேவை, தொடர அல்ல என்று காட்டினார்"]}$$::jsonb,
 null, null, null, null
),

('88888888-8888-8888-8888-000000000104', 'mark_choices',
 $$Which of the following are consistent with Galileo's conclusion about motion? Select all that apply.$$,
 $$இயக்கம் குறித்த கலீலியோவின் முடிவுடன் பொருந்துவது எது? பொருந்துவன அனைத்தையும் தேர்ந்தெடு.$$,
 $${"options": ["A puck on frictionless ice keeps sliding forever once pushed.", "A ball needs a continuous push to keep rolling on any surface.", "On a perfectly flat, frictionless ramp, a rolling ball never stops on its own.", "Force is required to change an object's velocity, not to maintain it."], "correct_indices": [0,2,3]}$$::jsonb,
 $${"options": ["உராய்வற்ற பனியில் ஒருமுறை தள்ளப்பட்ட பக் என்றென்றும் சறுக்கிக்கொண்டே இருக்கும்.", "எந்தவொரு மேற்பரப்பிலும் பந்து உருள தொடர்ச்சியான தள்ளுதல் தேவை.", "முற்றிலும் தட்டையான, உராய்வற்ற தளத்தில், உருளும் பந்து தானாக நிற்காது.", "ஒரு பொருளின் திசைவேகத்தை மாற்ற விசை தேவை, அதைத் தொடர அல்ல."]}$$::jsonb,
 $$Statements 1, 3, and 4 all restate Galileo's core insight: force changes motion, it doesn't sustain it. Statement 2 is the Aristotelian view Galileo overturned.$$,
 $$1, 3, 4 ஆகிய கூற்றுகள் அனைத்தும் கலீலியோவின் முக்கிய கண்டுபிடிப்பை மறு-கூறுகின்றன: விசை இயக்கத்தை மாற்றுகிறது, அதைத் தக்க வைக்கவில்லை. கூற்று 2 கலீலியோ தவறு என நிரூபித்த அரிஸ்டாட்டிலிய கருத்தாகும்.$$,
 null, null
),

('88888888-8888-8888-8888-000000000105', 'fill_blank',
 $$Using the same relation $d = h / \sin\theta$ from the worked example, if $h = 0.20$ m and the second ramp is inclined at $\theta = 5°$ ($\sin 5° \approx 0.087$), how far must the ball travel horizontally to regain its starting height?$$,
 $$விடையளிக்கப்பட்ட உதாரணத்தில் உள்ள $d = h / \sin\theta$ சூத்திரத்தைப் பயன்படுத்தி, $h = 0.20$ மீ மற்றும் இரண்டாவது தளம் $\theta = 5°$ கோணத்தில் சாய்ந்திருந்தால் ($\sin 5° \approx 0.087$), பந்து தொடக்க உயரத்தை மீண்டும் அடைய கிடைமட்டமாக எவ்வளவு தூரம் செல்ல வேண்டும்?$$,
 $${"blanks": [{"label": "Horizontal distance (m, 1 decimal place)", "type": "number", "correct": 2.3}]}$$::jsonb,
 $${"blanks": [{"label": "கிடைமட்டத் தூரம் (மீ, 1 தசம இடம்)"}]}$$::jsonb,
 $$d = h / sin(theta) = 0.20 / 0.087 ≈ 2.3 m. Even a small 5° angle already forces the ball to travel over five times farther than the original 30° case (0.40 m) -- a preview of how, at 0°, that distance blows up to infinity.$$,
 $$d = h / sin(theta) = 0.20 / 0.087 ≈ 2.3 மீ. 5° போன்ற சிறிய கோணம் கூட, முதலில் இருந்த 30° நிலையை (0.40 மீ) விட பந்தை ஐந்து மடங்குக்கும் மேலாக பயணிக்க வைக்கிறது — 0° இல் அந்த தூரம் எல்லையின்றி பெருகும் என்பதற்கான முன்னோட்டம் இது.$$,
 null, null
)
on conflict (id) do nothing;

-- ------------------------------------------------------------
-- 1d. Lesson 1 steps (new ids, range ...000000000101+).
-- ------------------------------------------------------------
insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('99999999-9999-9999-9999-000000000101', '77777777-7777-7777-7777-000000000001', 'motivation',
 'The Ball That Wouldn''t Stop',
 $$நிற்காத பந்து$$,
 $$Imagine rolling a ball down a smooth ramp and letting it climb an identical ramp on the other side. It rises almost to the same height it started from -- every time, no matter how far apart the ramps are.

Now flatten the second ramp completely. What happens to the ball? Does it ever stop on its own?$$,
 $$ஒரு மென்மையான சரிவுத் தளத்தில் இருந்து பந்தை உருட்டி, மறுபக்கம் உள்ள அதே சரிவில் அதை ஏற வைப்பதாக நினைத்துப் பாருங்கள். இரு தளங்களுக்கு இடையே தூரம் எவ்வளவு இருந்தாலும், பந்து தொடங்கிய உயரத்தையே மீண்டும் அடைகிறது.

இப்போது இரண்டாவது தளத்தை முற்றிலும் தட்டையாக்குங்கள். பந்துக்கு என்ன நடக்கும்? அது தானாக நிற்குமா?$$,
 'ramp_angles', null, 1),

('99999999-9999-9999-9999-000000000102', '77777777-7777-7777-7777-000000000001', 'explanation',
 'Aristotle vs. Galileo',
 $$அரிஸ்டாட்டில் Vs கலீலியோ$$,
 $$About 2500 years ago, Aristotle claimed that a force is needed to keep anything moving -- stop pushing, and motion stops. It matched everyday experience: carts stop when you stop pulling them.

In the 1600s, Galileo challenged this with a clever experiment using two smooth, facing ramps. He noticed the ball always climbed back to nearly its starting height, no matter the second ramp's angle. As he flattened that ramp, the ball had to travel farther and farther to reach the same height -- and at a perfectly flat angle, the ball would have to travel forever to reach that height, so it just kept rolling.

Galileo's conclusion: motion doesn't need a force to continue. It only needs a force to change. In essence: Aristotle coupled motion with force, while Galileo decoupled them.$$,
 $$சுமார் 2500 ஆண்டுகளுக்கு முன், இயக்கத்தைத் தொடர்வதற்கு விசை தேவை என அரிஸ்டாட்டில் கூறினார் — தள்ளுவதை நிறுத்தினால் இயக்கமும் நிற்கும் என்பது அன்றாட அனுபவத்திற்குப் பொருந்துவதாகத் தோன்றியது.

1600களில், இரண்டு மென்மையான, எதிரெதிர் சரிவுத் தளங்களைப் பயன்படுத்திய ஒரு சோதனை மூலம் கலீலியோ இதை மறுத்தார். இரண்டாவது தளத்தின் கோணம் எதுவாக இருந்தாலும், பந்து எப்போதும் தொடக்க உயரத்திற்கு அருகில் மீண்டும் ஏறுவதைக் கண்டார். அந்தத் தளத்தைத் தட்டையாக்க, அதே உயரத்தை அடைய பந்து மேலும் மேலும் தூரம் செல்ல வேண்டியிருந்தது — முற்றிலும் தட்டையான கோணத்தில், அந்த உயரத்தை அடைய பந்து எப்போதும் பயணிக்க வேண்டியிருக்கும், எனவே அது தொடர்ந்து உருண்டது.

கலீலியோவின் முடிவு: இயக்கத்தைத் தொடர விசை தேவையில்லை. அதை மாற்றவே விசை தேவை. சுருக்கமாக: அரிஸ்டாட்டில் இயக்கத்தையும் விசையையும் இணைத்தார்; கலீலியோ அவற்றைப் பிரித்தார்.$$,
 'force_vs_noforce', null, 2),

('99999999-9999-9999-9999-000000000103', '77777777-7777-7777-7777-000000000001', 'explanation',
 'The Seed of an Idea: Inertia',
 $$ஒரு கருத்தின் விதை: மந்தம் (Inertia)$$,
 $$Galileo's insight -- that an object left alone keeps doing whatever it was already doing -- is called inertia. It's not a force. It's a property every object has: a built-in resistance to changing its state of motion.

This single idea became the seed for Newton's First Law, which we'll build on in a later lesson. For now, remember the key shift: "no force needed to keep moving" replaced "force needed to keep moving."$$,
 $$ஒரு பொருள் தனியாக விடப்பட்டால், அது ஏற்கெனவே செய்து கொண்டிருந்ததையே தொடரும் என்ற கலீலியோவின் கண்டுபிடிப்புக்கு மந்தம் (Inertia) என்று பெயர். இது ஒரு விசை அல்ல. இது ஒவ்வொரு பொருளுக்கும் இருக்கும் ஒரு பண்பு: அதன் இயக்க நிலையை மாற்றுவதற்கு இயல்பாகவே இருக்கும் எதிர்ப்பு.

இந்த ஒரு கருத்தே பின்னால் வரும் பாடத்தில் நாம் கட்டியெழுப்பும் நியூட்டனின் முதல் விதிக்கு அடிப்படையாக அமைந்தது. இப்போதைக்கு, முக்கிய மாற்றத்தை நினைவில் கொள்ளுங்கள்: "இயக்கத்தைத் தொடர விசை தேவையில்லை" என்பது "இயக்கத்தைத் தொடர விசை தேவை" என்பதை மாற்றியது.$$,
 null, null, 3),

('99999999-9999-9999-9999-000000000104', '77777777-7777-7777-7777-000000000001', 'example',
 'Reading Galileo''s Experiment -- With Numbers',
 $$கலீலியோவின் சோதனை — எண்களுடன்$$,
 $$Setup: a ball rolls down a smooth ramp from height $h = 0.20$ m and up a second smooth ramp inclined at angle $\theta$. Since there's no friction, it always regains height $h$ before momentarily stopping.

The horizontal distance it needs to travel to regain that height is $d = h / \sin\theta$.

At $\theta = 30°$: $d = 0.20 / \sin 30° = 0.20 / 0.5 = 0.40$ m.

At $\theta = 10°$: $d = 0.20 / \sin 10° \approx 0.20 / 0.174 \approx 1.15$ m.

As the angle drops, the ball must travel much farther to regain the same height. Push $\theta$ all the way to $0°$ and $\sin\theta \to 0$, so $d \to \infty$ -- the ball never gets there. It just keeps rolling, forever, in a straight line. That's inertia in action.$$,
 $$அமைப்பு: ஒரு பந்து $h = 0.20$ மீ உயரத்தில் இருந்து ஒரு மென்மையான சரிவில் இறங்கி, $\theta$ கோணத்தில் சாய்ந்த இரண்டாவது மென்மையான தளத்தில் ஏறுகிறது. உராய்வு இல்லாததால், அது தற்காலிகமாக நிற்பதற்கு முன் எப்போதும் $h$ உயரத்தை மீண்டும் அடைகிறது.

அந்த உயரத்தை மீண்டும் அடைய தேவையான கிடைமட்டத் தூரம் $d = h / \sin\theta$.

$\theta = 30°$ இல்: $d = 0.20 / \sin 30° = 0.20 / 0.5 = 0.40$ மீ.

$\theta = 10°$ இல்: $d = 0.20 / \sin 10° \approx 1.15$ மீ.

கோணம் குறையக் குறைய, அதே உயரத்தை அடைய பந்து மிக அதிக தூரம் செல்ல வேண்டும். $\theta$ ஐ $0°$ ஆக்கினால் $\sin\theta \to 0$, எனவே $d \to \infty$ — பந்து ஒருபோதும் அங்கு சேராது. அது நேர்கோட்டில் என்றென்றும் உருண்டு கொண்டே இருக்கும். இதுவே மந்தத்தின் வெளிப்பாடு.$$,
 null, null, 4),

('99999999-9999-9999-9999-000000000105', '77777777-7777-7777-7777-000000000001', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000101', 5),
('99999999-9999-9999-9999-000000000106', '77777777-7777-7777-7777-000000000001', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000102', 6),
('99999999-9999-9999-9999-000000000107', '77777777-7777-7777-7777-000000000001', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000103', 7),
('99999999-9999-9999-9999-000000000108', '77777777-7777-7777-7777-000000000001', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000104', 8),
('99999999-9999-9999-9999-000000000109', '77777777-7777-7777-7777-000000000001', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000105', 9)
on conflict (id) do nothing;


-- ============================================================
-- 2. Shift existing Lessons 2-7 down one slot (order_index +1)
--    to make room for the new Reference Frames lesson at slot 2.
-- ============================================================
update physics_ip_lessons set order_index = order_index + 1
where id in (
  '77777777-7777-7777-7777-000000000002',
  '77777777-7777-7777-7777-000000000003',
  '77777777-7777-7777-7777-000000000004',
  '77777777-7777-7777-7777-000000000005',
  '77777777-7777-7777-7777-000000000006',
  '77777777-7777-7777-7777-000000000007'
);

-- ============================================================
-- 3. NEW LESSON -- "Who's Really Moving? Reference Frames"
--    (textbook material on reference frames + inertial frames,
--    which sits right after Newton's First Law in the syllabus)
-- ============================================================
insert into physics_ip_lessons (id, chapter_id, title, title_ta, hook_summary, hook_summary_ta, order_index) values
('77777777-7777-7777-7777-000000000008', '22222222-2222-2222-2222-222222220003',
 'Who''s Really Moving? Reference Frames',
 $$உண்மையில் யார் நகர்கிறார்கள்? சார்பு சட்டகங்கள்$$,
 'Every description of motion starts with a choice: what do you treat as fixed?',
 $$இயக்கத்தைப் பற்றிய ஒவ்வொரு விளக்கமும் ஒரு தேர்வுடன் தொடங்குகிறது: எதை நிலையானதாகக் கருதுவது?$$,
 2)
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta) values

('88888888-8888-8888-8888-000000000106', 'fill_blank',
 $$A car (Car 1) drives at a constant 20 m/s on a straight highway. A second car (Car 2) is speeding up to overtake it.

A passenger inside Car 1 is ___ an inertial frame. A passenger inside Car 2, while it's accelerating, is ___ an inertial frame.$$,
 $$ஒரு கார் (கார் 1) நேர்கோட்டு நெடுஞ்சாலையில் மாறாத 20 மீ/வி வேகத்தில் செல்கிறது. இரண்டாவது கார் (கார் 2) அதை முந்திக்கொள்ள வேகமெடுக்கிறது.

கார் 1 உள்ளிருக்கும் பயணி ___ ஒரு நிலைமம் சட்டகத்தில். கார் 2 முடுக்கமடையும்போது அதனுள் இருக்கும் பயணி ___ ஒரு நிலைமம் சட்டகத்தில்.$$,
 $${"blanks": [
   {"label": "Passenger in Car 1", "type": "dropdown", "choices": ["in", "not in"], "correct": "in"},
   {"label": "Passenger in Car 2 (while accelerating)", "type": "dropdown", "choices": ["in", "not in"], "correct": "not in"}
 ]}$$::jsonb,
 $${"blanks": [
   {"label": "கார் 1 இல் உள்ள பயணி", "choices": ["இருக்கிறார்", "இல்லை"]},
   {"label": "கார் 2 இல் உள்ள பயணி (முடுக்கமடையும்போது)", "choices": ["இருக்கிறார்", "இல்லை"]}
 ]}$$::jsonb,
 $$Car 1 moves at constant velocity, so any frame attached to it is inertial -- Newton's First Law holds normally inside it. Car 2 is accelerating, so a passenger inside it is in a non-inertial frame: loose objects would appear to slide backward with no real force causing it, exactly like the textbook's accelerating-train example.$$,
 $$கார் 1 மாறா வேகத்தில் நகர்கிறது, எனவே அதனுடன் இணைக்கப்பட்ட எந்தச் சட்டகமும் நிலைமமானது — அதனுள் நியூட்டனின் முதல் விதி இயல்பாகப் பொருந்தும். கார் 2 முடுக்கமடைகிறது, எனவே அதற்குள் இருக்கும் பயணி ஒரு நிலைமமற்ற சட்டகத்தில் இருக்கிறார்: தளர்வான பொருட்கள், உண்மையான விசை எதுவும் இல்லாமலேயே பின்னோக்கி சறுக்குவது போல் தோன்றும், பாடப்புத்தகத்தின் முடுக்கமடையும் ரயில் உதாரணத்தைப் போலவே.$$,
 null, null
),

('88888888-8888-8888-8888-000000000107', 'fill_blank',
 $$Train A moves east at $30$ m/s relative to the ground. Train B moves east at $22$ m/s relative to the ground, on a parallel track. What is the velocity of Train A as seen by a passenger on Train B (i.e., relative to Train B's reference frame)?$$,
 $$ரயில் A தரையை பொறுத்து கிழக்கு நோக்கி $30$ மீ/வி வேகத்தில் செல்கிறது. ரயில் B, இணை தண்டவாளத்தில், தரையை பொறுத்து கிழக்கு நோக்கி $22$ மீ/வி வேகத்தில் செல்கிறது. ரயில் B இல் உள்ள பயணி பார்வையில் ரயில் A இன் வேகம் என்ன?$$,
 $${"blanks": [{"label": "Velocity of A relative to B (m/s, east positive)", "type": "number", "correct": 8}]}$$::jsonb,
 $${"blanks": [{"label": "B ஐப் பொறுத்து A இன் வேகம் (மீ/வி, கிழக்கு நேர்குறி)"}]}$$::jsonb,
 $$Relative velocity = velocity of A (relative to ground) minus velocity of B (relative to ground) = 30 - 22 = 8 m/s east. To a passenger on Train B, Train A appears to creep forward at just 8 m/s, even though both are moving fast relative to the ground -- this is exactly the reference-frame shift at the heart of this lesson.$$,
 $$சார்பு வேகம் = A இன் வேகம் (தரையைப் பொறுத்து) கழித்தல் B இன் வேகம் (தரையைப் பொறுத்து) = 30 - 22 = 8 மீ/வி கிழக்கு. ரயில் B இல் உள்ள பயணிக்கு, இரண்டு ரயில்களும் தரையைப் பொறுத்து வேகமாக நகர்ந்தாலும், ரயில் A வெறும் 8 மீ/வி வேகத்தில் மெதுவாக முன்னேறுவது போல் தெரியும் — இதுவே இந்தப் பாடத்தின் மையக் கருத்தான சார்பு சட்டக மாற்றம்.$$,
 $$Don't add the two velocities. Since both trains move in the same direction, you subtract; you'd only add if they moved toward each other.$$,
 $$இரண்டு வேகங்களையும் கூட்டிவிட வேண்டாம். இரு ரயில்களும் ஒரே திசையில் செல்வதால், கழிக்க வேண்டும்; அவை ஒன்றுக்கொன்று எதிராக வந்தால் மட்டுமே கூட்ட வேண்டும்.$$
),

('88888888-8888-8888-8888-000000000108', 'match',
 $$Match each scenario to the description that best fits its reference frame.$$,
 $$ஒவ்வொரு சூழ்நிலையையும் அதன் சார்பு சட்டகத்தை சிறப்பாகப் பொருத்தும் விளக்கத்துடன் இணைக்கவும்.$$,
 $${"left": ["A lab table at rest on Earth's surface", "A train moving at constant velocity", "A car braking suddenly", "A space station drifting at constant velocity, far from any planet"], "right": ["Non-inertial -- objects seem to accelerate with no real force", "Inertial -- Newton's First Law holds normally", "Inertial, only approximately (Earth slowly rotates)", "Inertial -- no acceleration, no force needed to explain the motion"], "correct_pairs": [[0,2],[1,1],[2,0],[3,3]]}$$::jsonb,
 $${"left": ["பூமியின் மேற்பரப்பில் நிலையாக உள்ள ஆய்வக மேசை", "மாறா வேகத்தில் நகரும் ரயில்", "திடீரென பிரேக் போடும் கார்", "எந்தக் கிரகத்திற்கும் அருகில் இல்லாமல், மாறா வேகத்தில் மிதக்கும் விண்வெளி நிலையம்"], "right": ["நிலைமமற்றது — உண்மையான விசை இல்லாமலேயே பொருட்கள் முடுக்கம் அடைவது போல் தோன்றும்", "நிலைமம் — நியூட்டனின் முதல் விதி இயல்பாகப் பொருந்தும்", "நிலைமம், தோராயமாக மட்டுமே (பூமி மெதுவாகச் சுழல்கிறது)", "நிலைமம் — முடுக்கம் இல்லை, இயக்கத்தை விளக்க விசை தேவையில்லை"]}$$::jsonb,
 null, null, null, null
),

('88888888-8888-8888-8888-000000000109', 'mark_choices',
 $$Select all statements about reference frames that are TRUE.$$,
 $$சார்பு சட்டகங்கள் குறித்த சரியான கூற்றுகள் அனைத்தையும் தேர்ந்தெடு.$$,
 $${"options": ["Two inertial frames can move at constant velocity relative to each other.", "If an object is at rest in one inertial frame, it must be at rest in every inertial frame.", "A rotating frame is a non-inertial frame, since rotation requires acceleration.", "Earth's surface is only approximately inertial, because of its rotation and orbital motion."], "correct_indices": [0,2,3]}$$::jsonb,
 $${"options": ["இரண்டு நிலைமம் சட்டகங்கள் ஒன்றையொன்று பொறுத்து மாறா வேகத்தில் நகரலாம்.", "ஒரு பொருள் ஒரு நிலைமம் சட்டகத்தில் நிலையாக இருந்தால், அது ஒவ்வொரு நிலைமம் சட்டகத்திலும் நிலையாக இருக்க வேண்டும்.", "சுழலும் சட்டகம் ஒரு நிலைமமற்ற சட்டகம் ஆகும், ஏனெனில் சுழற்சிக்கு முடுக்கம் தேவை.", "பூமியின் மேற்பரப்பு அதன் சுழற்சி மற்றும் சுற்றுப்பாதை இயக்கத்தால் தோராயமாக மட்டுமே நிலைமமானது."]}$$::jsonb,
 $$Statement 2 is false -- an object at rest in one inertial frame appears to move at constant velocity (not necessarily zero) in a different inertial frame, since inertial frames can move relative to each other. Statements 1, 3, and 4 are all directly from the textbook's treatment of inertial frames.$$,
 $$கூற்று 2 தவறானது — ஒரு பொருள் ஒரு நிலைமம் சட்டகத்தில் நிலையாக இருந்தாலும், வேறொரு நிலைமம் சட்டகத்தில் அது மாறா வேகத்தில் (பூஜ்ஜியமாக இருக்க வேண்டிய அவசியமில்லை) நகர்வது போல் தோன்றும், ஏனெனில் நிலைமம் சட்டகங்கள் ஒன்றையொன்று பொறுத்து நகரலாம். 1, 3, 4 ஆகிய கூற்றுகள் பாடப்புத்தகத்தின் நிலைமம் சட்டக விளக்கத்திலிருந்தே நேரடியாக வந்தவை.$$,
 null, null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('99999999-9999-9999-9999-000000000110', '77777777-7777-7777-7777-000000000008', 'motivation',
 'Who''s Moving, Alice or Bob?',
 $$யார் நகர்கிறார்கள், ஆலிஸ் அல்லது பாப்?$$,
 $$Alice stands on a train platform. Bob sits on a train pulling away at constant speed. Alice says: "Bob is moving away from me." Bob, watching Alice through the window, says: "Alice is moving away from me, and I'm sitting still."

Who's right?$$,
 $$ஆலிஸ் ரயில் நிலையத்தில் நிற்கிறார். பாப் மாறாத வேகத்தில் புறப்படும் ரயிலில் அமர்ந்திருக்கிறார். ஆலிஸ் கூறுகிறார்: "பாப் என்னிடமிருந்து விலகிச் செல்கிறார்." ஜன்னல் வழியாக ஆலிஸைப் பார்க்கும் பாப் கூறுகிறார்: "ஆலிஸ் என்னிடமிருந்து விலகிச் செல்கிறார், நான் அசையாமல் இருக்கிறேன்."

இதில் யார் சொல்வது சரி?$$,
 'reference_frame', null, 1),

('99999999-9999-9999-9999-000000000111', '77777777-7777-7777-7777-000000000008', 'explanation',
 'What a Reference Frame Is',
 $$சார்பு சட்டகம் என்றால் என்ன$$,
 $$Every description of motion starts with a choice: what do you treat as fixed? That choice is your reference frame -- a coordinate system anchored to a particular observer.

Both Alice and Bob are correct, in their own frames. In Alice's frame, she is fixed and Bob moves away. In Bob's frame, he is fixed and Alice moves away. Neither frame is "more true" than the other -- what's real and frame-independent is only the relative velocity between them.

This matches the textbook's own starting point: an object being "at rest" or "moving with constant velocity" only has meaning with respect to some reference frame.$$,
 $$இயக்கத்தைப் பற்றிய ஒவ்வொரு விளக்கமும் ஒரு தேர்வுடன் தொடங்குகிறது: எதை நிலையானதாகக் கருதுவது? அந்தத் தேர்வே உங்கள் சார்பு சட்டகம் (reference frame) — ஒரு குறிப்பிட்ட பார்வையாளரிடம் நங்கூரமிடப்பட்ட ஆயத்தொலைவு அமைப்பு.

ஆலிஸும் பாபும் தங்கள் சொந்த சட்டகங்களில் இருவரும் சரிதான். ஆலிஸின் சட்டகத்தில், அவர் நிலையாக இருக்கிறார், பாப் விலகிச் செல்கிறார். பாபின் சட்டகத்தில், அவர் நிலையாக இருக்கிறார், ஆலிஸ் விலகிச் செல்கிறார். எந்தச் சட்டகமும் மற்றொன்றை விட "அதிக உண்மையானது" அல்ல — சட்டகத்தைப் பொருட்படுத்தாமல் உண்மையானது அவர்களுக்கிடையேயான சார்பு வேகம் மட்டுமே.

இது பாடப்புத்தகத்தின் தொடக்கப் புள்ளியுடன் பொருந்துகிறது: ஒரு பொருள் "நிலையாக" உள்ளது அல்லது "மாறா திசைவேகத்தில் நகர்கிறது" என்று சொல்வதற்கு, அது ஒரு சார்பு சட்டகத்தைப் பொறுத்தே பொருள் கொள்ளும்.$$,
 null, null, 2),

('99999999-9999-9999-9999-000000000112', '77777777-7777-7777-7777-000000000008', 'explanation',
 'Inertial Frames -- Where Newton''s First Law Actually Works',
 $$நிலைமம் சட்டகங்கள் — நியூட்டனின் முதல் விதி உண்மையில் செயல்படும் இடம்$$,
 $$Newton's First Law says a force-free object keeps constant velocity. But that's only true in certain special frames, called inertial frames -- in fact, Newton's First Law is what DEFINES an inertial frame.

The textbook's own example: suppose a train moves at constant velocity. An object resting on a smooth table inside the train stays at rest relative to the train -- both the ground and the train are inertial frames here, since they move at constant velocity relative to each other.

Now suppose the train suddenly accelerates. The object on the table appears to slide backward, even though no real horizontal force acts on it. That's a direct violation of Newton's First Law -- so the accelerating train is a non-inertial frame. The same idea, played out with a car instead of a train, is shown below: a ball hanging from a string stays vertical at constant velocity, but swings forward the instant the car brakes.

For practical purposes, Earth's surface is treated as an (approximately) inertial frame -- even though, strictly, its rotation makes it slightly non-inertial.$$,
 $$நியூட்டனின் முதல் விதி கூறுகிறது: விசையற்ற ஒரு பொருள் மாறா திசைவேகத்தில் தொடரும். ஆனால் இது நிலைமம் சட்டகங்கள் (inertial frames) எனப்படும் சில சிறப்புச் சட்டகங்களில் மட்டுமே உண்மை — உண்மையில், நியூட்டனின் முதல் விதியே ஒரு நிலைமம் சட்டகத்தை வரையறுக்கிறது.

பாடப்புத்தகத்தின் உதாரணம்: ஒரு ரயில் மாறா வேகத்தில் நகர்கிறது என வைத்துக்கொள்வோம். ரயிலுக்குள் ஒரு மென்மையான மேசையில் இருக்கும் பொருள் ரயிலைப் பொறுத்து நிலையாகவே இருக்கும் — தரையும் ரயிலும் இங்கு இரண்டும் நிலைமம் சட்டகங்களே, ஏனெனில் அவை ஒன்றையொன்று பொறுத்து மாறா வேகத்தில் நகர்கின்றன.

இப்போது ரயில் திடீரென முடுக்கமடைகிறது என வைத்துக்கொள்வோம். மேசையில் உள்ள பொருள் மீது உண்மையான கிடைமட்ட விசை எதுவும் செயல்படாவிட்டாலும், அது பின்னோக்கி சறுக்குவது போல் தோன்றும். இது நியூட்டனின் முதல் விதியை நேரடியாக மீறுகிறது — எனவே முடுக்கமடையும் ரயில் ஒரு நிலைமமற்ற சட்டகம். அதே கருத்து, ரயிலுக்குப் பதிலாக ஒரு காரில், கீழே காட்டப்பட்டுள்ளது: ஒரு நூலில் தொங்கும் பந்து மாறா வேகத்தில் செங்குத்தாக இருக்கும், ஆனால் கார் திடீரென பிரேக் போடும்போது முன்னோக்கி ஆடும்.

நடைமுறை நோக்கங்களுக்காக, பூமியின் மேற்பரப்பு (தோராயமாக) ஒரு நிலைமம் சட்டகமாகக் கருதப்படுகிறது — கண்டிப்பாகச் சொன்னால், அதன் சுழற்சி அதை சற்று நிலைமமற்றதாக ஆக்கினாலும்.$$,
 'inertial_vs_noninertial', null, 3),

('99999999-9999-9999-9999-000000000113', '77777777-7777-7777-7777-000000000008', 'example',
 'Choosing the Right Reference Frame',
 $$சரியான சார்பு சட்டகத்தைத் தேர்ந்தெடுத்தல்$$,
 $$A cyclist rides north at a constant $v = 5.0$ m/s, tracking a jogger running just ahead of her on the same road, also heading north. She wants to know whether the 10 m gap between them is staying the same, growing, or shrinking.

Which reference frame makes this easiest? Fix the frame to the cyclist herself: origin at her position, positive x-axis pointing north, moving along with her.

In this frame, the cyclist is always at $x' = 0$, and the only motion left to track is the jogger's. If the jogger's position in this frame stays fixed at $x' = +10$ m, the gap is constant. If $x'$ increases, the jogger is pulling away; if it decreases, the cyclist is catching up.

Notice what this bought us: instead of tracking two moving objects against the ground, we only need to track one -- the jogger -- against a frame that already moves with the cyclist. That's the whole point of choosing your reference frame wisely.$$,
 $$ஒரு சைக்கிள் ஓட்டுநர் மாறா வேகமான $v = 5.0$ மீ/வி இல் வடக்கு நோக்கி செல்கிறார், அதே சாலையில் வடக்கு நோக்கி ஓடும் ஒரு ஜாகர் (jogger) ஐ தனக்கு முன்னால் கண்காணிக்கிறார். அவர்களுக்கு இடையேயான 10 மீ இடைவெளி மாறாமல் இருக்கிறதா, அதிகரிக்கிறதா அல்லது குறைகிறதா என்று அவர் அறிய விரும்புகிறார்.

இதற்கு எந்த சார்பு சட்டகம் எளிதாக இருக்கும்? சட்டகத்தை சைக்கிள் ஓட்டுநர் மீதே நிலைநிறுத்துங்கள்: தோற்றப்புள்ளி அவரது இடத்தில், நேர்குறி x-அச்சு வடக்கு நோக்கி, அவருடன் சேர்ந்து நகரும்.

இந்தச் சட்டகத்தில், சைக்கிள் ஓட்டுநர் எப்போதும் $x' = 0$ இல் இருப்பார், கண்காணிக்க வேண்டியது ஜாகரின் இயக்கம் மட்டுமே. ஜாகரின் நிலை இந்தச் சட்டகத்தில் $x' = +10$ மீ இல் நிலையாக இருந்தால், இடைவெளி மாறவில்லை. $x'$ அதிகரித்தால், ஜாகர் விலகிச் செல்கிறார்; குறைந்தால், சைக்கிள் ஓட்டுநர் நெருங்குகிறார்.

இது நமக்கு என்ன தந்தது என்று கவனியுங்கள்: தரையை பொறுத்து இரு நகரும் பொருட்களைக் கண்காணிப்பதற்குப் பதிலாக, ஒன்றை மட்டுமே — ஜாகரை — ஏற்கெனவே சைக்கிள் ஓட்டுநருடன் நகரும் சட்டகத்திற்கு எதிராகக் கண்காணித்தால் போதும். இதுவே சார்பு சட்டகத்தைப் புத்திசாலித்தனமாகத் தேர்ந்தெடுப்பதன் முழுப் பொருள்.$$,
 null, null, 4),

('99999999-9999-9999-9999-000000000114', '77777777-7777-7777-7777-000000000008', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000106', 5),
('99999999-9999-9999-9999-000000000115', '77777777-7777-7777-7777-000000000008', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000107', 6),
('99999999-9999-9999-9999-000000000116', '77777777-7777-7777-7777-000000000008', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000108', 7),
('99999999-9999-9999-9999-000000000117', '77777777-7777-7777-7777-000000000008', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000109', 8)
on conflict (id) do nothing;
