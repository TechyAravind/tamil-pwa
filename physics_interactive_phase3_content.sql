-- ============================================================
-- Interactive Physics — Phase 3 Content
-- Run AFTER physics_interactive_schema_v3.sql and
-- physics_interactive_phase1_content.sql.
--
-- Adds two new lessons to the Laws of Motion chapter, rendered by
-- the existing EXTRA_SECTIONS logic in PhysicsChapterInteractivePage.jsx
-- (which already looks for group_key = 'one_mark' / 'book_back'):
--
--   1. "One Mark Questions" -- 10 rapid-fire MCQs spanning all 7
--      Main Sub Topics, for quick exam-style revision.
--   2. "Book Back Problems" -- 6 full numerical problems (one per
--      major topic area) with complete worked solutions, styled like
--      end-of-chapter textbook exercises.
--
-- Both use fixed UUIDs and "on conflict do nothing" -- safe to re-run.
-- ============================================================

-- ------------------------------------------------------------
-- Lesson: One Mark Questions
-- ------------------------------------------------------------
insert into physics_ip_lessons (id, chapter_id, title, title_ta, hook_summary, hook_summary_ta, order_index, group_key) values
('77777777-7777-7777-7777-000000000009', '22222222-2222-2222-2222-222222220003',
 'One Mark Questions',
 $$ஒரு மதிப்பெண் வினாக்கள்$$,
 'Ten quick-fire questions across the whole chapter -- how many can you get right?',
 $$முழு அத்தியாயத்திலும் இருந்து பத்து விரைவான வினாக்கள் — எத்தனை சரியாக பதிலளிக்க முடியும்?$$,
 9, 'one_mark')
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta) values

('88888888-8888-8888-8888-000000000201', 'mcq',
 $$About 2500 years ago, which philosopher claimed that "force is required to maintain motion"?$$,
 $$சுமார் 2500 ஆண்டுகளுக்கு முன், "இயக்கத்தைத் தொடர விசை தேவை" என்று கூறிய தத்துவவாதி யார்?$$,
 $${"options": ["Newton", "Aristotle", "Galileo", "Kepler"], "correct_index": 1}$$::jsonb,
 $${"options": ["நியூட்டன்", "அரிஸ்டாட்டில்", "கலீலியோ", "கெப்ளர்"]}$$::jsonb,
 $$Aristotle proposed this based on everyday observation; Galileo later disproved it with his ramp experiment.$$,
 $$அன்றாட அவதானிப்பின் அடிப்படையில் அரிஸ்டாட்டில் இதை முன்மொழிந்தார்; கலீலியோ பின்னர் தனது சரிவுத் தள சோதனையின் மூலம் இதைத் தவறு எனக் காட்டினார்.$$,
 null, null,
 'Aristotle: force maintains motion (wrong). Galileo/Newton: force only changes motion.',
 $$அரிஸ்டாட்டில்: விசை இயக்கத்தைத் தொடர்கிறது (தவறு). கலீலியோ/நியூட்டன்: விசை இயக்கத்தை மாற்றுகிறது மட்டுமே.$$
),

('88888888-8888-8888-8888-000000000202', 'mcq',
 $$Newton's First Law is also known as the law of ___.$$,
 $$நியூட்டனின் முதல் விதி ___ விதி என்றும் அழைக்கப்படுகிறது.$$,
 $${"options": ["momentum", "inertia", "gravitation", "friction"], "correct_index": 1}$$::jsonb,
 $${"options": ["உந்தம்", "மந்தம் (சடத்தன்மை)", "ஈர்ப்பு", "உராய்வு"]}$$::jsonb,
 $$An object resists any change to its state of rest or motion -- that resistance is inertia, and Newton's First Law is built entirely around it.$$,
 $$ஒரு பொருள் தனது ஓய்வு அல்லது இயக்க நிலையில் ஏற்படும் எந்த மாற்றத்தையும் எதிர்க்கிறது — அந்த எதிர்ப்பே மந்தம், நியூட்டனின் முதல் விதி முழுவதுமே இதன் அடிப்படையில் அமைந்துள்ளது.$$,
 null, null,
 'Newton’s First Law = the Law of Inertia.',
 $$நியூட்டனின் முதல் விதி = மந்த விதி.$$
),

('88888888-8888-8888-8888-000000000203', 'mcq',
 $$Newton's Second Law states that force equals the rate of change of ___.$$,
 $$நியூட்டனின் இரண்டாம் விதியின்படி, விசை என்பது ___ இன் மாற்ற வீதத்திற்குச் சமம்.$$,
 $${"options": ["momentum", "velocity", "displacement", "energy"], "correct_index": 0}$$::jsonb,
 $${"options": ["உந்தம்", "திசைவேகம்", "இடப்பெயர்ச்சி", "ஆற்றல்"]}$$::jsonb,
 $$$F = dp/dt$. For constant mass this simplifies to the familiar $F = ma$, but the momentum form is the more general statement.$$,
 $$$F = dp/dt$. மாறாத நிறைக்கு இது நமக்குப் பழக்கமான $F = ma$ ஆக எளிமையாகிறது, ஆனால் உந்த வடிவமே பொதுவான கூற்று.$$,
 null, null,
 'F = dp/dt is the general form; F = ma only holds when mass is constant.',
 $$F = dp/dt என்பது பொதுவான வடிவம்; நிறை மாறாதிருந்தால் மட்டுமே F = ma பொருந்தும்.$$
),

('88888888-8888-8888-8888-000000000204', 'mcq',
 $$A block of mass $m$ rests on a flat, horizontal floor with nothing else pushing on it. The normal force $N$ from the floor equals ___.$$,
 $$$m$ நிறையுள்ள ஒரு தொகுதி, வேறு எந்த விசையும் இல்லாமல் தட்டையான கிடைமட்டத் தரையில் ஓய்வில் உள்ளது. தரையிலிருந்து வரும் இயல்நிலை விசை $N$ ___ க்குச் சமம்.$$,
 $${"options": ["zero", "mg", "2mg", "mg/2"], "correct_index": 1}$$::jsonb,
 $${"options": ["பூஜ்ஜியம்", "mg", "2mg", "mg/2"]}$$::jsonb,
 $$The block isn't accelerating vertically, so the net vertical force is zero: $N - mg = 0 \Rightarrow N = mg$.$$,
 $$தொகுதி செங்குத்தாக முடுக்கமடையவில்லை, எனவே நிகர செங்குத்து விசை பூஜ்ஜியம்: $N - mg = 0 \Rightarrow N = mg$.$$,
 null, null,
 'On flat ground with no other vertical force, N = mg -- always check this balance first in a free body diagram.',
 $$தட்டையான தரையில் வேறு செங்குத்து விசை இல்லாதபோது, N = mg — இயல்நிலை உரு வரைபடத்தில் எப்போதும் இந்த சமநிலையை முதலில் சரிபார்க்கவும்.$$
),

('88888888-8888-8888-8888-000000000205', 'mcq',
 $$Lami's theorem applies to a particle in equilibrium under exactly ___ concurrent, coplanar forces.$$,
 $$லாமியின் தேற்றம் சரியாக ___ ஒருங்கமை, ஒரு தளத்தில் அமையும் விசைகளின் கீழ் சமநிலையில் உள்ள ஒரு துகளுக்குப் பொருந்தும்.$$,
 $${"options": ["two", "three", "four", "any number of"], "correct_index": 1}$$::jsonb,
 $${"options": ["இரண்டு", "மூன்று", "நான்கு", "எத்தனை வேண்டுமானாலும்"]}$$::jsonb,
 $$Lami's theorem relates three concurrent forces to the sines of their opposite angles: $\dfrac{F_1}{\sin\alpha} = \dfrac{F_2}{\sin\beta} = \dfrac{F_3}{\sin\gamma}$.$$,
 $$லாமியின் தேற்றம் மூன்று ஒருங்கமை விசைகளை அவற்றின் எதிர் கோணங்களின் சைன் மதிப்புகளுடன் தொடர்புபடுத்துகிறது: $\dfrac{F_1}{\sin\alpha} = \dfrac{F_2}{\sin\beta} = \dfrac{F_3}{\sin\gamma}$.$$,
 null, null,
 'Lami’s theorem needs exactly three concurrent forces in equilibrium.',
 $$லாமியின் தேற்றத்திற்கு சமநிலையில் சரியாக மூன்று ஒருங்கமை விசைகள் தேவை.$$
),

('88888888-8888-8888-8888-000000000206', 'mcq',
 $$What is the SI unit of linear momentum?$$,
 $$நேர்கோட்டு உந்தத்தின் SI அலகு என்ன?$$,
 $${"options": ["N", "kg m/s", "kg m/s²", "J"], "correct_index": 1}$$::jsonb,
 $${"options": ["N", "kg m/s", "kg m/s²", "J"]}$$::jsonb,
 $$Momentum $p = mv$, so its unit is mass (kg) times velocity (m/s) = kg m/s.$$,
 $$உந்தம் $p = mv$, எனவே அதன் அலகு நிறை (kg) பெருக்கல் திசைவேகம் (m/s) = kg m/s.$$,
 null, null,
 'Momentum = mass x velocity, unit kg m/s -- not to be confused with force (N = kg m/s²).',
 $$உந்தம் = நிறை x திசைவேகம், அலகு kg m/s — விசையுடன் (N = kg m/s²) குழப்பிக்கொள்ள வேண்டாம்.$$
),

('88888888-8888-8888-8888-000000000207', 'mcq',
 $$The law of conservation of linear momentum applies to a system of particles when ___.$$,
 $$நேர்கோட்டு உந்தத்தின் அழிவின்மை விதி ஒரு துகள் தொகுப்புக்குப் பொருந்துவது ___.$$,
 $${"options": ["all particles have equal mass", "no net external force acts on the system", "the particles never collide", "the system is at rest"], "correct_index": 1}$$::jsonb,
 $${"options": ["அனைத்து துகள்களும் சமமான நிறை கொண்டவை", "தொகுப்பில் நிகர வெளிப்புற விசை செயல்படவில்லை", "துகள்கள் ஒருபோதும் மோதுவதில்லை", "தொகுப்பு ஓய்வில் உள்ளது"]}$$::jsonb,
 $$Internal forces (like collision forces between particles) always come in action-reaction pairs and cancel out -- only a net EXTERNAL force can change the total momentum of the system.$$,
 $$உள் விசைகள் (துகள்களுக்கிடையேயான மோதல் விசைகள் போன்றவை) எப்போதும் செயல்-எதிர்செயல் ஜோடிகளாக வந்து ரத்தாகின்றன — நிகர வெளிப்புற விசை மட்டுமே தொகுப்பின் மொத்த உந்தத்தை மாற்ற முடியும்.$$,
 null, null,
 'Total momentum of a system is conserved whenever the net external force on it is zero.',
 $$ஒரு தொகுப்பின் மீதான நிகர வெளிப்புற விசை பூஜ்ஜியமாக இருக்கும்போது, அதன் மொத்த உந்தம் அழிவின்றி இருக்கும்.$$
),

('88888888-8888-8888-8888-000000000208', 'mcq',
 $$Static friction can take any value from zero up to a maximum of ___.$$,
 $$நிலை உராய்வு பூஜ்ஜியத்தில் இருந்து அதிகபட்சமாக ___ வரை எந்த மதிப்பையும் எடுக்கலாம்.$$,
 $${"options": ["\\mu_k N", "\\mu_s N", "mg", "N"], "correct_index": 1}$$::jsonb,
 $${"options": ["\\mu_k N", "\\mu_s N", "mg", "N"]}$$::jsonb,
 $$Static friction adjusts itself to exactly match the applied force (to keep the object still), up to the limiting value $\mu_s N$. Beyond that, the object starts to slide.$$,
 $$நிலை உராய்வு, பொருள் அசையாமல் இருக்க, செலுத்தப்படும் விசைக்கு சரியாகப் பொருந்துமாறு தானாக மாறுகிறது, வரம்பு மதிப்பான $\mu_s N$ வரை. அதற்கு மேல், பொருள் சறுக்கத் தொடங்கும்.$$,
 null, null,
 'Static friction is self-adjusting up to μsN; kinetic friction (μkN) takes over once sliding starts, and is usually smaller.',
 $$நிலை உராய்வு μsN வரை தானாக மாறுகிறது; சறுக்கத் தொடங்கியதும் இயக்க உராய்வு (μkN) பொறுப்பேற்கும், அது பொதுவாக சிறியது.$$
),

('88888888-8888-8888-8888-000000000209', 'mcq',
 $$Which type of friction is generally the smallest for a given surface pair?$$,
 $$கொடுக்கப்பட்ட மேற்பரப்பு ஜோடிக்கு பொதுவாக மிகச் சிறிய உராய்வு எது?$$,
 $${"options": ["Static friction", "Kinetic friction", "Rolling friction", "All are equal"], "correct_index": 2}$$::jsonb,
 $${"options": ["நிலை உராய்வு", "இயக்க உராய்வு", "உருளல் உராய்வு", "அனைத்தும் சமம்"]}$$::jsonb,
 $$Rolling friction is much smaller than static or kinetic friction -- which is why wheels and rolling suitcases are so much easier to move than dragging the same object.$$,
 $$உருளல் உராய்வு நிலை அல்லது இயக்க உராய்வை விட மிகவும் சிறியது — அதனால்தான் சக்கரங்களும் உருளும் பயணப் பெட்டிகளும் அதே பொருளை இழுப்பதை விட நகர்த்த மிக எளிதாக இருக்கும்.$$,
 null, null,
 'Order of friction magnitude (same surfaces): static ≥ kinetic > rolling.',
 $$உராய்வு அளவின் வரிசை (ஒரே மேற்பரப்புகளில்): நிலை ≥ இயக்கம் > உருளல்.$$
),

('88888888-8888-8888-8888-000000000210', 'mcq',
 $$An object of mass $m$ moves in a circle of radius $r$ at constant speed $v$. The centripetal force needed is ___.$$,
 $$$m$ நிறையுள்ள ஒரு பொருள் $r$ ஆரமுள்ள வட்டத்தில் மாறாத வேகம் $v$ இல் நகர்கிறது. தேவையான நோக்குமைய விசை ___.$$,
 $${"options": ["mv/r", "mv^2/r", "mv^2 r", "mvr"], "correct_index": 1}$$::jsonb,
 $${"options": ["mv/r", "mv^2/r", "mv^2 r", "mvr"]}$$::jsonb,
 $$Centripetal force $F_{cp} = \dfrac{mv^2}{r} = m\omega^2 r$, always directed toward the centre of the circle. It isn't a new kind of force -- gravity, tension, or friction can all play this role.$$,
 $$நோக்குமைய விசை $F_{cp} = \dfrac{mv^2}{r} = m\omega^2 r$, எப்போதும் வட்டத்தின் மையத்தை நோக்கி இயங்கும். இது ஒரு புதிய வகை விசை அல்ல — ஈர்ப்பு, இழுவிசை அல்லது உராய்வு இதன் பங்கை வகிக்கலாம்.$$,
 null, null,
 'Centripetal force = mv²/r, always pointing toward the centre -- provided by whatever real force is available (gravity, tension, friction, etc.).',
 $$நோக்குமைய விசை = mv²/r, எப்போதும் மையத்தை நோக்கி — கிடைக்கும் உண்மையான விசையால் (ஈர்ப்பு, இழுவிசை, உராய்வு போன்றவை) வழங்கப்படுகிறது.$$
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('99999999-9999-9999-9999-000000000201', '77777777-7777-7777-7777-000000000009', 'motivation',
 'Ten Questions, Whole Chapter',
 $$பத்து வினாக்கள், முழு அத்தியாயம்$$,
 $$No lengthy setup this time -- just ten quick one-mark-style questions pulled from across the whole chapter. Good for a fast self-check before an exam.$$,
 $$இந்த முறை நீண்ட முன்னுரை இல்லை — முழு அத்தியாயத்திலிருந்தும் தேர்ந்தெடுக்கப்பட்ட பத்து விரைவான ஒரு-மதிப்பெண் வினாக்கள் மட்டுமே. தேர்வுக்கு முன் விரைவாக சுய பரிசோதனை செய்ய ஏற்றது.$$,
 null, null, 1),

('99999999-9999-9999-9999-000000000202', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000201', 2),
('99999999-9999-9999-9999-000000000203', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000202', 3),
('99999999-9999-9999-9999-000000000204', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000203', 4),
('99999999-9999-9999-9999-000000000205', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000204', 5),
('99999999-9999-9999-9999-000000000206', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000205', 6),
('99999999-9999-9999-9999-000000000207', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000206', 7),
('99999999-9999-9999-9999-000000000208', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000207', 8),
('99999999-9999-9999-9999-000000000209', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000208', 9),
('99999999-9999-9999-9999-000000000210', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000209', 10),
('99999999-9999-9999-9999-000000000211', '77777777-7777-7777-7777-000000000009', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000210', 11)
on conflict (id) do nothing;


-- ------------------------------------------------------------
-- Lesson: Book Back Problems
-- ------------------------------------------------------------
insert into physics_ip_lessons (id, chapter_id, title, title_ta, hook_summary, hook_summary_ta, order_index, group_key) values
('77777777-7777-7777-7777-000000000010', '22222222-2222-2222-2222-222222220003',
 'Book Back Problems',
 $$பாட புத்தக கடைசி பயிற்சிகள்$$,
 'Six full numerical problems, one from each major topic, worked out step by step.',
 $$ஒவ்வொரு முக்கிய தலைப்பிலிருந்தும் ஒன்று வீதம், ஆறு முழு எண்ணியல் பிரச்சினைகள், படிப்படியாக தீர்க்கப்பட்டவை.$$,
 10, 'book_back')
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta) values

('88888888-8888-8888-8888-000000000211', 'fill_blank',
 $$A net force of $15$ N acts on a $3$ kg object that starts at rest on a frictionless surface. Find its acceleration.$$,
 $$உராய்வற்ற மேற்பரப்பில் ஓய்வில் இருந்து தொடங்கும் $3$ kg நிறையுள்ள பொருள் மீது $15$ N நிகர விசை செயல்படுகிறது. அதன் முடுக்கத்தைக் காணவும்.$$,
 $${"blanks": [{"label": "Acceleration a (m/s²)", "type": "number", "correct": 5}]}$$::jsonb,
 $${"blanks": [{"label": "முடுக்கம் a (m/s²)"}]}$$::jsonb,
 $$From Newton's Second Law: $a = F/m = 15 / 3 = 5$ m/s². Since the surface is frictionless, the entire 15 N goes into accelerating the block -- nothing is lost to friction.$$,
 $$நியூட்டனின் இரண்டாம் விதியிலிருந்து: $a = F/m = 15 / 3 = 5$ m/s². மேற்பரப்பு உராய்வற்றது என்பதால், 15 N முழுவதும் தொகுதியை முடுக்குவதற்குச் செல்கிறது — உராய்வுக்கு எதுவும் இழக்கப்படவில்லை.$$,
 $$Don't confuse net force with weight -- here the 15 N is already the net (unbalanced) force, so you divide directly by mass; you don't need to subtract anything else first.$$,
 $$நிகர விசையை எடையுடன் குழப்பிக்கொள்ள வேண்டாம் — இங்கு 15 N ஏற்கெனவே நிகர (சமநிலையற்ற) விசை, எனவே நேரடியாக நிறையால் வகுக்கவும்; வேறு எதையும் முதலில் கழிக்க வேண்டியதில்லை.$$,
 'a = F/m -- the most direct application of Newton’s Second Law.',
 $$a = F/m — நியூட்டனின் இரண்டாம் விதியின் மிக நேரடியான பயன்பாடு.$$
),

('88888888-8888-8888-8888-000000000212', 'fill_blank',
 $$A $2$ kg block slides down a frictionless incline tilted at $\theta = 30°$. Taking $g = 9.8$ m/s², find its acceleration down the slope.$$,
 $$$2$ kg தொகுதி ஒன்று $\theta = 30°$ கோணத்தில் சாய்ந்த உராய்வற்ற தளத்தில் இறங்குகிறது. $g = 9.8$ m/s² எனக் கொண்டு, சரிவில் அதன் முடுக்கத்தைக் காணவும்.$$,
 $${"blanks": [{"label": "Acceleration down the slope a (m/s²)", "type": "number", "correct": 4.9}]}$$::jsonb,
 $${"blanks": [{"label": "சரிவில் முடுக்கம் a (m/s²)"}]}$$::jsonb,
 $$Resolving weight along the incline: the component pulling the block down the slope is $mg\sin\theta$, and since the surface is frictionless that's the only force along the slope. So $a = g\sin\theta = 9.8 \times \sin 30° = 9.8 \times 0.5 = 4.9$ m/s². Notice the mass cancels out -- every object slides down a frictionless incline at the same rate, regardless of mass.$$,
 $$எடையை சரிவுக்கு இணையாகவும் செங்குத்தாகவும் பிரிக்கும்போது: தொகுதியை சரிவில் இழுக்கும் பகுதி $mg\sin\theta$, மேற்பரப்பு உராய்வற்றது என்பதால் இதுவே சரிவில் உள்ள ஒரே விசை. எனவே $a = g\sin\theta = 9.8 \times 0.5 = 4.9$ m/s². நிறை ரத்தாகிவிடுவதைக் கவனியுங்கள் — நிறையைப் பொருட்படுத்தாமல், ஒவ்வொரு பொருளும் உராய்வற்ற சரிவில் ஒரே வீதத்தில் இறங்கும்.$$,
 $$A common mistake is using $mg\cos\theta$ (the component that determines the Normal force) instead of $mg\sin\theta$ (the component that actually accelerates the block down the slope).$$,
 $$$mg\sin\theta$ (தொகுதியை உண்மையில் சரிவில் முடுக்கும் பகுதி) க்குப் பதிலாக $mg\cos\theta$ (இயல்நிலை விசையை தீர்மானிக்கும் பகுதி) பயன்படுத்துவது ஒரு பொதுவான தவறு.$$,
 'On a frictionless incline, a = g sinθ -- independent of mass.',
 $$உராய்வற்ற சரிவில், a = g sinθ — நிறையைச் சாராதது.$$
),

('88888888-8888-8888-8888-000000000213', 'fill_blank',
 $$A lamp of weight $100$ N hangs in equilibrium, held by two strings making angles of $30°$ and $60°$ with the horizontal ceiling. Using Lami's theorem, find the tension $T_1$ in the string that makes the $30°$ angle.$$,
 $$$100$ N எடையுள்ள ஒரு விளக்கு, கூரையுடன் $30°$ மற்றும் $60°$ கோணங்களில் அமைந்த இரு நூல்களால் சமநிலையில் தொங்குகிறது. லாமியின் தேற்றத்தைப் பயன்படுத்தி, $30°$ கோணத்தில் அமைந்த நூலின் இழுவிசை $T_1$ ஐக் காணவும்.$$,
 $${"blanks": [{"label": "Tension T₁ (N)", "type": "number", "correct": 50}]}$$::jsonb,
 $${"blanks": [{"label": "இழுவிசை T₁ (N)"}]}$$::jsonb,
 $$Three concurrent forces act at the lamp: $T_1$, $T_2$, and $W$. Since the strings make $30°$ and $60°$ with the horizontal, the angle opposite $T_1$ (between $T_2$ and $W$) works out to $150°$. By Lami's theorem, $\dfrac{T_1}{\sin150°} = \dfrac{W}{\sin90°}$, so $T_1 = W \sin150° = 100 \times 0.5 = 50$ N.$$,
 $$விளக்கின் மீது மூன்று ஒருங்கமை விசைகள் செயல்படுகின்றன: $T_1$, $T_2$, $W$. நூல்கள் கிடைமட்டத்துடன் $30°$ மற்றும் $60°$ கோணங்களில் இருப்பதால், $T_1$ க்கு எதிரான கோணம் ($T_2$ க்கும் $W$ க்கும் இடையே) $150°$ ஆக அமையும். லாமியின் தேற்றத்தின்படி, $\dfrac{T_1}{\sin150°} = \dfrac{W}{\sin90°}$, எனவே $T_1 = 100 \times 0.5 = 50$ N.$$,
 $$The angle you plug in for each tension is the angle OPPOSITE that force (between the other two forces) -- not the angle the string itself makes with the ceiling.$$,
 $$ஒவ்வொரு இழுவிசைக்கும் பயன்படுத்தும் கோணம், அந்த விசைக்கு எதிரான கோணமே (மற்ற இரண்டு விசைகளுக்கு இடையேயது) — நூல் கூரையுடன் அமைக்கும் கோணம் அல்ல.$$,
 'Lami’s theorem: each force divided by the sine of the angle opposite it gives the same ratio.',
 $$லாமியின் தேற்றம்: ஒவ்வொரு விசையையும் அதற்கு எதிரான கோணத்தின் சைன் மதிப்பால் வகுத்தால், ஒரே விகிதம் கிடைக்கும்.$$
),

('88888888-8888-8888-8888-000000000214', 'fill_blank',
 $$Ball A ($2$ kg) moves at $6$ m/s and collides head-on with stationary ball B ($4$ kg). They stick together on impact. Find their common velocity right after the collision.$$,
 $$பந்து A ($2$ kg) $6$ m/s வேகத்தில் நகர்ந்து, ஓய்வில் உள்ள பந்து B ($4$ kg) உடன் நேர் மோதுகிறது. மோதலின்போது அவை ஒன்றாக ஒட்டிக்கொள்கின்றன. மோதலுக்குப் பிறகு அவற்றின் பொதுவான வேகத்தைக் காணவும்.$$,
 $${"blanks": [{"label": "Common velocity v (m/s)", "type": "number", "correct": 2}]}$$::jsonb,
 $${"blanks": [{"label": "பொதுவான வேகம் v (m/s)"}]}$$::jsonb,
 $$No external horizontal force acts during the collision, so total momentum is conserved: $m_Av_A + m_Bv_B = (m_A+m_B)v$. Substituting: $2(6) + 4(0) = (2+4)v \Rightarrow 12 = 6v \Rightarrow v = 2$ m/s.$$,
 $$மோதலின்போது வெளிப்புற கிடைமட்ட விசை எதுவும் செயல்படாததால், மொத்த உந்தம் அழிவின்றி இருக்கும்: $m_Av_A + m_Bv_B = (m_A+m_B)v$. மதிப்பிட: $2(6) + 4(0) = (2+4)v \Rightarrow 12 = 6v \Rightarrow v = 2$ m/s.$$,
 $$Since the collision is perfectly inelastic (they stick together), use a SINGLE combined mass $(m_A+m_B)$ on the right side -- don't keep two separate final velocities.$$,
 $$மோதல் முழுமையாக உறை மோதல் (perfectly inelastic) என்பதால் (அவை ஒட்டிக்கொள்கின்றன), வலப்புறத்தில் ஒரே இணைந்த நிறையை $(m_A+m_B)$ பயன்படுத்தவும் — இரு தனித்தனி இறுதி வேகங்களை வைத்திருக்க வேண்டாம்.$$,
 'Total momentum before = total momentum after, whenever no net external force acts.',
 $$வெளிப்புற நிகர விசை செயல்படாதபோது, மோதலுக்கு முன் மொத்த உந்தம் = மோதலுக்குப் பின் மொத்த உந்தம்.$$
),

('88888888-8888-8888-8888-000000000215', 'fill_blank',
 $$A $10$ kg box rests on a horizontal floor. The coefficient of static friction between box and floor is $\mu_s = 0.4$. Taking $g = 9.8$ m/s², find the maximum static friction force before the box starts to slide.$$,
 $$$10$ kg பெட்டி ஒன்று கிடைமட்ட தரையில் உள்ளது. பெட்டிக்கும் தரைக்கும் இடையேயான நிலை உராய்வு குணகம் $\mu_s = 0.4$. $g = 9.8$ m/s² எனக் கொண்டு, பெட்டி சறுக்கத் தொடங்கும் முன் அதிகபட்ச நிலை உராய்வு விசையைக் காணவும்.$$,
 $${"blanks": [{"label": "Maximum static friction (N)", "type": "number", "correct": 39.2}]}$$::jsonb,
 $${"blanks": [{"label": "அதிகபட்ச நிலை உராய்வு (N)"}]}$$::jsonb,
 $$On flat ground, $N = mg = 10 \times 9.8 = 98$ N. Maximum static friction $= \mu_s N = 0.4 \times 98 = 39.2$ N. Any applied force below this, the box stays put; above it, the box starts to slide and kinetic friction takes over.$$,
 $$தட்டையான தரையில், $N = mg = 10 \times 9.8 = 98$ N. அதிகபட்ச நிலை உராய்வு $= \mu_s N = 0.4 \times 98 = 39.2$ N. இதற்குக் குறைவான எந்த விசையும் பெட்டியை அசைக்காது; இதற்கு மேல் பெட்டி சறுக்கத் தொடங்கும், இயக்க உராய்வு பொறுப்பேற்கும்.$$,
 $$Remember to find $N$ first (here it's just $mg$ since the floor is horizontal and there's no other vertical force) before multiplying by $\mu_s$.$$,
 $$$\mu_s$ ஆல் பெருக்கும் முன், முதலில் $N$ ஐக் கண்டறியவும் (தரை கிடைமட்டமாகவும் வேறு செங்குத்து விசை இல்லாததாலும் இங்கு அது வெறும் $mg$ மட்டுமே).$$,
 'Maximum static friction = μsN, computed from whatever the Normal force actually is in that setup.',
 $$அதிகபட்ச நிலை உராய்வு = μsN, அந்த அமைப்பில் இயல்நிலை விசை உண்மையில் என்னவோ அதிலிருந்து கணக்கிடப்படுகிறது.$$
),

('88888888-8888-8888-8888-000000000216', 'fill_blank',
 $$A car of mass $1000$ kg goes around a curve of radius $50$ m at a constant speed of $10$ m/s. Find the centripetal force needed to keep it on the curve.$$,
 $$$1000$ kg நிறையுள்ள ஒரு கார், $50$ m ஆரமுள்ள வளைவில் $10$ m/s மாறா வேகத்தில் செல்கிறது. அது வளைவில் தொடர தேவையான நோக்குமைய விசையைக் காணவும்.$$,
 $${"blanks": [{"label": "Centripetal force (N)", "type": "number", "correct": 2000}]}$$::jsonb,
 $${"blanks": [{"label": "நோக்குமைய விசை (N)"}]}$$::jsonb,
 $$$F_{cp} = \dfrac{mv^2}{r} = \dfrac{1000 \times 10^2}{50} = \dfrac{100000}{50} = 2000$ N. In practice, this force is supplied by friction between the tyres and the road -- if the required force exceeds what friction can provide, the car skids outward.$$,
 $$$F_{cp} = \dfrac{mv^2}{r} = \dfrac{1000 \times 10^2}{50} = 2000$ N. நடைமுறையில், இந்த விசை டயர்களுக்கும் சாலைக்கும் இடையேயான உராய்வால் வழங்கப்படுகிறது — தேவையான விசை உராய்வால் வழங்கக்கூடியதை மீறினால், கார் வெளிப்புறமாக சறுக்கும்.$$,
 $$Don't forget to square the speed ($v^2$, not $v$) -- this is the single most common slip in centripetal force problems.$$,
 $$வேகத்தை வர்க்கமாக்க (($v^2$, $v$ அல்ல)) மறக்க வேண்டாம் — நோக்குமைய விசை பிரச்சினைகளில் இதுவே மிகவும் பொதுவான தவறு.$$,
 'Centripetal force grows with the SQUARE of speed -- doubling speed quadruples the force needed.',
 $$நோக்குமைய விசை வேகத்தின் வர்க்கத்திற்கு ஏற்ப அதிகரிக்கிறது — வேகத்தை இரட்டிப்பாக்கினால், தேவையான விசை நான்கு மடங்காகிறது.$$
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('99999999-9999-9999-9999-000000000212', '77777777-7777-7777-7777-000000000010', 'motivation',
 'Six Problems, Fully Worked',
 $$ஆறு பிரச்சினைகள், முழுமையாக தீர்க்கப்பட்டவை$$,
 $$These mirror the numerical exercises at the end of a textbook chapter -- one problem from each major topic area, each with a complete step-by-step solution once you submit an answer.$$,
 $$இவை பாட புத்தக அத்தியாயத்தின் இறுதியில் உள்ள எண்ணியல் பயிற்சிகளைப் போன்றவை — ஒவ்வொரு முக்கிய தலைப்பிலிருந்தும் ஒரு பிரச்சினை, பதில் அளித்த பிறகு முழுமையான படிப்படியான தீர்வுடன்.$$,
 null, null, 1),

('99999999-9999-9999-9999-000000000213', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000211', 2),
('99999999-9999-9999-9999-000000000214', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000212', 3),
('99999999-9999-9999-9999-000000000215', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000213', 4),
('99999999-9999-9999-9999-000000000216', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000214', 5),
('99999999-9999-9999-9999-000000000217', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000215', 6),
('99999999-9999-9999-9999-000000000218', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000216', 7)
on conflict (id) do nothing;
