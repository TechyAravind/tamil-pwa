-- ============================================================
-- Interactive Physics — Chapter 4 (Work, Energy and Power)
-- Run AFTER physics_interactive_schema_v4.sql (needs group_key,
-- takeaway_fact, diagram_key, physics_formulas -- all already in
-- place from the Chapter 3 migrations).
--
-- Mirrors the Chapter 3 (Laws of Motion) treatment exactly:
--   - 7 "Main Sub Topic" lessons (hook -> explanation -> worked
--     example with real textbook numbers -> practice questions),
--     each bilingual, each question with an explicit correct-answer
--     display + takeaway fact.
--   - "Book Back One Mark Questions" -- all 15 real MCQs from the
--     textbook's evaluation section, book's own answer key.
--   - "Book Back Problems" -- all 5 real numerical problems from the
--     textbook's evaluation section, fully worked.
--   - "Extra One Mark Questions" -- 10 supplementary MCQs spanning
--     the whole chapter, for extra revision (kept last, same as Ch3).
--   - physics_formulas rows for the new "Formulas" tab.
--
-- video_url is deliberately left null throughout -- every step
-- already supports it (VideoEmbed renders automatically once set),
-- so dropping in Manim animation links later needs zero code changes:
--   update physics_ip_steps set video_url = '...' where id = '<id>';
--
-- Uses a fresh UUID prefix family (c/d/e/f) so nothing collides with
-- Chapter 3's ids. Fixed UUIDs + "on conflict do nothing" throughout
-- -- safe to re-run. Uses $Q$...$Q$ dollar-quoting (not bare $$) so
-- that inline single-$ math inside the text can never collide with
-- the field's own string delimiter.
-- ============================================================

-- ------------------------------------------------------------
-- Lessons (7 main + 3 trailing sections)
-- ------------------------------------------------------------
insert into physics_ip_lessons (id, chapter_id, title, title_ta, hook_summary, hook_summary_ta, order_index, group_key) values
('cccccccc-cccc-cccc-cccc-000000000001', '22222222-2222-2222-2222-222222220004',
 'What Is Work, Really?',
 $Q$வேலை என்றால் உண்மையில் என்ன?$Q$,
 'You push a wall all day and get nothing done -- physics agrees with you, and has a precise reason why.',
 $Q$நாள் முழுவதும் ஒரு சுவரைத் தள்ளினாலும் எதுவும் நடக்காது — இயற்பியலும் உங்களுடன் உடன்படுகிறது, அதற்கு துல்லியமான காரணமும் உண்டு.$Q$,
 1, 'wep_introduction'),

('cccccccc-cccc-cccc-cccc-000000000002', '22222222-2222-2222-2222-222222220004',
 'Kinetic Energy, Potential Energy, and the Work-Energy Theorem',
 $Q$இயக்க ஆற்றல், நிலை ஆற்றல், மற்றும் வேலை-ஆற்றல் தேற்றம்$Q$,
 'Every joule of work you do on something has to go somewhere -- this is the bookkeeping system.',
 $Q$நீங்கள் ஒரு பொருளின் மீது செய்யும் ஒவ்வொரு ஜூல் வேலையும் எங்காவது செல்ல வேண்டும் — இது அதற்கான கணக்கு முறை.$Q$,
 2, 'wep_energy'),

('cccccccc-cccc-cccc-cccc-000000000003', '22222222-2222-2222-2222-222222220004',
 'Conservative Forces & the Law of Conservation of Energy',
 $Q$பாதுகாப்பு விசைகள் & ஆற்றல் அழிவின்மை விதி$Q$,
 'Take any path you like -- gravity doesn''t care. Some forces play fair like that. Friction doesn''t.',
 $Q$எந்தப் பாதையை வேண்டுமானாலும் எடுத்துக் கொள்ளுங்கள் — ஈர்ப்புக்கு அக்கறையில்லை. சில விசைகள் இப்படி நேர்மையாக இருக்கும். உராய்வு அப்படி இல்லை.$Q$,
 3, 'wep_conservative'),

('cccccccc-cccc-cccc-cccc-000000000004', '22222222-2222-2222-2222-222222220004',
 'Motion in a Vertical Circle',
 $Q$செங்குத்து வட்டத்தில் இயக்கம்$Q$,
 'Why does a bucket of water whirled overhead not spill on you -- and why must you whirl it fast enough?',
 $Q$தலைக்கு மேல் சுழற்றப்படும் நீர் வாளி ஏன் உங்கள் மீது கொட்டாது — அதை ஏன் போதுமான வேகத்தில் சுழற்ற வேண்டும்?$Q$,
 4, 'wep_vertical_circle'),

('cccccccc-cccc-cccc-cccc-000000000005', '22222222-2222-2222-2222-222222220004',
 'Power: The Rate of Doing Work',
 $Q$திறன்: வேலை செய்யப்படும் வீதம்$Q$,
 'Two people can lift the exact same weight to the exact same height -- and do very different amounts of "power."',
 $Q$இரண்டு பேர் ஒரே எடையை ஒரே உயரத்திற்கு தூக்கலாம் — ஆனால் "திறன்" முற்றிலும் வேறுபடலாம்.$Q$,
 5, 'wep_power'),

('cccccccc-cccc-cccc-cccc-000000000006', '22222222-2222-2222-2222-222222220004',
 'Elastic & Inelastic Collisions',
 $Q$நெகிழ்ச்சி & நெகிழ்ச்சியற்ற மோதல்கள்$Q$,
 'Two balls collide. Sometimes they bounce apart clean. Sometimes they stick. Momentum never lies either way.',
 $Q$இரண்டு பந்துகள் மோதுகின்றன. சில நேரம் தெளிவாக பிரிந்து செல்கின்றன. சில நேரம் ஒட்டிக்கொள்கின்றன. உந்தம் இரண்டு நிலைகளிலும் பொய் சொல்லாது.$Q$,
 6, 'wep_collisions'),

('cccccccc-cccc-cccc-cccc-000000000007', '22222222-2222-2222-2222-222222220004',
 'Loss of Kinetic Energy & Coefficient of Restitution',
 $Q$இயக்க ஆற்றல் இழப்பு & மீள்தன்மைக் குணகம்$Q$,
 'A rubber ball and a lump of clay both hit the floor. One bounces back. One doesn''t. There''s a number for that.',
 $Q$ஒரு ரப்பர் பந்தும் ஒரு களிமண் உருண்டையும் தரையில் மோதுகின்றன. ஒன்று மீண்டும் குதிக்கும். மற்றொன்று குதிக்காது. அதற்கு ஒரு எண் உண்டு.$Q$,
 7, 'wep_restitution'),

('cccccccc-cccc-cccc-cccc-000000000008', '22222222-2222-2222-2222-222222220004',
 'Book Back One Mark Questions',
 $Q$பாட புத்தக ஒரு மதிப்பெண் வினாக்கள்$Q$,
 'The real 15 MCQs from the textbook''s evaluation section -- exact questions, exact answer key.',
 $Q$பாடப்புத்தகத்தின் மதிப்பீட்டுப் பகுதியிலிருந்து உண்மையான 15 MCQ வினாக்கள் — சரியான வினாக்கள், சரியான விடைத்திறவுகோல்.$Q$,
 8, 'book_back_mcq'),

('cccccccc-cccc-cccc-cccc-000000000009', '22222222-2222-2222-2222-222222220004',
 'Book Back Problems',
 $Q$பாட புத்தக கடைசி பயிற்சிகள்$Q$,
 'All 5 real numerical problems from the textbook''s evaluation section, fully worked out.',
 $Q$பாடப்புத்தகத்தின் மதிப்பீட்டுப் பகுதியிலிருந்து அனைத்து 5 எண்ணியல் பிரச்சினைகளும், முழுமையாகத் தீர்க்கப்பட்டவை.$Q$,
 9, 'book_back'),

('cccccccc-cccc-cccc-cccc-000000000010', '22222222-2222-2222-2222-222222220004',
 'Extra One Mark Questions',
 $Q$கூடுதல் ஒரு மதிப்பெண் வினாக்கள்$Q$,
 'Ten more quick questions, spanning the whole chapter -- good for extra practice.',
 $Q$முழு அத்தியாயத்திலிருந்தும் மேலும் பத்து விரைவான வினாக்கள் — கூடுதல் பயிற்சிக்கு ஏற்றது.$Q$,
 10, 'extra_one_mark')
on conflict (id) do nothing;


-- ============================================================
-- LESSON 1 -- What Is Work, Really?
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000001', 'mcq',
 $Q$A weightlifter holds a $250$ kg barbell steady over their head for $10$ seconds without moving it up or down. How much work does the weightlifter do on the barbell during those $10$ seconds?$Q$,
 $Q$ஒரு எடை தூக்குபவர் $250$ kg பார்பெல்லை $10$ வினாடிகளுக்கு தலைக்கு மேல் மேலே கீழே நகர்த்தாமல் நிலையாக பிடித்திருக்கிறார். அந்த $10$ வினாடிகளில் எடை தூக்குபவர் பார்பெல் மீது எவ்வளவு வேலை செய்கிறார்?$Q$,
 $Q${"options": ["Zero -- the barbell doesn't move, so there's no displacement", "A large positive amount, since holding something heavy is hard work", "A negative amount, since gravity is pulling down", "It depends on how tired the weightlifter is"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["பூஜ்ஜியம் — பார்பெல் நகரவில்லை, எனவே இடப்பெயர்ச்சி இல்லை", "ஒரு பெரிய நேர்குறி மதிப்பு, ஏனெனில் கனமான ஒன்றை பிடித்திருப்பது கடினமான வேலை", "ஒரு எதிர்குறி மதிப்பு, ஏனெனில் ஈர்ப்பு கீழே இழுக்கிறது", "எடை தூக்குபவர் எவ்வளவு சோர்வாக இருக்கிறார் என்பதைப் பொறுத்தது"]}$Q$::jsonb,
 $Q$Work in physics requires DISPLACEMENT: $W = F \cdot dr$. If the barbell isn't moving, $dr = 0$, so the work done ON THE BARBELL is exactly zero -- no matter how much muscular effort it costs the weightlifter. This is the classic gap between the everyday meaning of "work" and the precise physics definition.$Q$,
 $Q$இயற்பியலில் வேலைக்கு இடப்பெயர்ச்சி தேவை: $W = F \cdot dr$. பார்பெல் நகரவில்லை என்றால், $dr = 0$, எனவே பார்பெல் மீது செய்யப்படும் வேலை சரியாக பூஜ்ஜியம் — எடை தூக்குபவருக்கு எவ்வளவு தசை முயற்சி தேவைப்பட்டாலும் சரி. இதுவே "வேலை" என்பதன் அன்றாட அர்த்தத்திற்கும் துல்லியமான இயற்பியல் வரையறைக்கும் இடையேயான பிரபலமான வேறுபாடு.$Q$,
 $Q$Physiologically, muscles DO use energy to stay contracted even when nothing moves -- but that energy is consumed internally as heat, not delivered as mechanical work on the barbell.$Q$,
 $Q$உடலியல் ரீதியாக, எதுவும் நகராவிட்டாலும், தசைகள் சுருங்கியிருக்க ஆற்றலைப் பயன்படுத்துகின்றன — ஆனால் அந்த ஆற்றல் உள்ளுக்குள் வெப்பமாக நுகரப்படுகிறது, பார்பெல் மீது இயந்திர வேலையாக வழங்கப்படவில்லை.$Q$,
 'Zero displacement always means zero work, regardless of how much force is applied or how tiring it feels.',
 $Q$எவ்வளவு விசை பயன்படுத்தப்பட்டாலும், எவ்வளவு சோர்வாக இருந்தாலும், பூஜ்ஜிய இடப்பெயர்ச்சி எப்போதும் பூஜ்ஜிய வேலையைக் குறிக்கும்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000002', 'fill_blank',
 $Q$A box is pulled with a force of $40$ N to produce a displacement of $20$ m. If the angle between the force and the displacement is $60°$, find the work done by the force.$Q$,
 $Q$ஒரு பெட்டி $40$ N விசையால் இழுக்கப்பட்டு $20$ m இடப்பெயர்ச்சியை உருவாக்குகிறது. விசைக்கும் இடப்பெயர்ச்சிக்கும் இடையேயான கோணம் $60°$ எனில், விசையால் செய்யப்படும் வேலையைக் காணவும்.$Q$,
 $Q${"blanks": [{"label": "Work done W (J)", "type": "number", "correct": 400}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "செய்யப்பட்ட வேலை W (J)"}]}$Q$::jsonb,
 $Q$Using $W = Fd\cos\theta$: $W = 40 \times 20 \times \cos60° = 40 \times 20 \times 0.5 = 400$ J. This mirrors the textbook's own worked example (a $25$ N force over $15$ m at $30°$), just with different numbers.$Q$,
 $Q$$W = Fd\cos\theta$ ஐப் பயன்படுத்தி: $W = 40 \times 20 \times \cos60° = 40 \times 20 \times 0.5 = 400$ J. இது பாடப்புத்தகத்தின் சொந்த உதாரணத்தை (30° இல் 15 m தூரத்திற்கு 25 N விசை) ஒத்திருக்கிறது, வெவ்வேறு எண்களுடன்.$Q$,
 $Q$Don't forget the $\cos\theta$ factor -- multiplying just $F \times d$ (ignoring the angle) gives the work done only when the force and displacement are perfectly aligned ($\theta = 0°$).$Q$,
 $Q$$\cos\theta$ காரணியை மறக்க வேண்டாம் — வெறும் $F \times d$ ஐ (கோணத்தைப் புறக்கணித்து) பெருக்குவது, விசையும் இடப்பெயர்ச்சியும் முழுமையாக இணைந்திருக்கும்போது ($\theta = 0°$) மட்டுமே சரியான வேலையைத் தரும்.$Q$,
 'W = Fd cosθ -- always resolve the angle between force and displacement before multiplying, never skip the cosine.',
 $Q$W = Fd cosθ — பெருக்கும் முன் எப்போதும் விசைக்கும் இடப்பெயர்ச்சிக்கும் இடையேயான கோணத்தைத் தீர்க்கவும், கொசைனை ஒருபோதும் தவிர்க்க வேண்டாம்.$Q$,
 'force_components'
),

('dddddddd-dddd-dddd-dddd-000000000003', 'mark_choices',
 $Q$Which of the following are genuine examples of ZERO work being done? Select all that apply.$Q$,
 $Q$பின்வருவனவற்றுள் எது உண்மையான பூஜ்ஜிய வேலையின் உதாரணம்? பொருந்துவன அனைத்தையும் தேர்ந்தெடு.$Q$,
 $Q${"options": ["A satellite in circular orbit, where gravity is always perpendicular to its velocity", "A book sliding to a stop on a rough table due to friction", "Pushing against a rigid wall that does not move at all", "A ball rolling at constant velocity on a frictionless horizontal floor, with no horizontal force acting on it"], "correct_indices": [0,2,3]}$Q$::jsonb,
 $Q${"options": ["வட்ட சுற்றுப்பாதையில் உள்ள ஒரு செயற்கைக்கோள், அங்கு ஈர்ப்பு எப்போதும் அதன் திசைவேகத்திற்குச் செங்குத்தாக இருக்கும்", "உராய்வு காரணமாக கரடுமுரடான மேசையில் நின்றுவிடும் ஒரு புத்தகம்", "சிறிதும் நகராத ஒரு உறுதியான சுவரைத் தள்ளுதல்", "உராய்வற்ற கிடைமட்டத் தரையில் மாறா வேகத்தில் உருளும் ஒரு பந்து, அதன் மீது கிடைமட்ட விசை எதுவும் இல்லை"]}$Q$::jsonb,
 $Q$Options 1, 3, and 4 are the textbook's three official zero-work cases: (1) force perpendicular to displacement ($\theta=90°$, centripetal force on an orbit), (3) zero displacement (the wall doesn't move), and (4) zero force (nothing acts on the ball, so trivially $W=Fd\cos\theta=0$). Option 2 is NOT zero work -- friction actively does negative work on the book as it slides, which is exactly why it slows down and stops.$Q$,
 $Q$விருப்பங்கள் 1, 3, 4 ஆகியவை பாடப்புத்தகத்தின் மூன்று உத்தியோகபூர்வ பூஜ்ஜிய-வேலை நிகழ்வுகள்: (1) இடப்பெயர்ச்சிக்குச் செங்குத்தான விசை ($\theta=90°$, சுற்றுப்பாதையில் நோக்குமைய விசை), (3) பூஜ்ஜிய இடப்பெயர்ச்சி (சுவர் நகராது), (4) பூஜ்ஜிய விசை (பந்தின் மீது எதுவும் செயல்படவில்லை, எனவே $W=Fd\cos\theta=0$ தானாகவே). விருப்பம் 2 பூஜ்ஜிய வேலை அல்ல — உராய்வு புத்தகம் சறுக்கும்போது அதன் மீது தீவிரமாக எதிர்குறி வேலையைச் செய்கிறது, அதனால்தான் அது மந்தமாகி நிற்கிறது.$Q$,
 $Q$"The object isn't moving forward anymore" doesn't mean "no work was done" -- friction did plenty of (negative) work to bring it to that stop.$Q$,
 $Q$"பொருள் இனி முன்னோக்கி நகரவில்லை" என்பது "எந்த வேலையும் செய்யப்படவில்லை" என்று அர்த்தமல்ல — அதை நிறுத்த உராய்வு நிறைய (எதிர்குறி) வேலையைச் செய்தது.$Q$,
 'The three real zero-work cases are: zero force, zero displacement, or a 90° angle between them -- friction slowing something down is negative work, not zero work.',
 $Q$மூன்று உண்மையான பூஜ்ஜிய-வேலை நிகழ்வுகள்: பூஜ்ஜிய விசை, பூஜ்ஜிய இடப்பெயர்ச்சி, அல்லது அவற்றுக்கிடையே 90° கோணம் — ஏதையாவது மந்தப்படுத்தும் உராய்வு எதிர்குறி வேலை, பூஜ்ஜிய வேலை அல்ல.$Q$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('eeeeeeee-eeee-eeee-eeee-000000000001', 'cccccccc-cccc-cccc-cccc-000000000001', 'motivation',
 'The Wall That Refuses to Cooperate',
 $Q$ஒத்துழைக்க மறுக்கும் சுவர்$Q$,
 $Q$You lean into a parked car with all your strength, trying to push it up a hill. It doesn't budge. Ten minutes later, exhausted, you stop.

Did you do any work on the car?

In everyday language -- absolutely, that felt like hard work. In physics, the answer is a flat no. Physics doesn't care how tired you feel. It only cares about one thing: did the object actually move?$Q$,
 $Q$நீங்கள் ஒரு நிறுத்தப்பட்ட காரை முழு பலத்துடன் ஒரு மலைமீது தள்ள முயற்சிக்கிறீர்கள். அது சிறிதும் நகராது. பத்து நிமிடங்களுக்குப் பிறகு, சோர்வுடன், நிறுத்துகிறீர்கள்.

நீங்கள் காரின் மீது ஏதேனும் வேலை செய்தீர்களா?

அன்றாட மொழியில் — நிச்சயமாக, அது கடினமான வேலை போல் உணரப்பட்டது. இயற்பியலில், பதில் தெளிவாக இல்லை. நீங்கள் எவ்வளவு சோர்வாக உணர்கிறீர்கள் என்பதைப் பற்றி இயற்பியல் அக்கறை கொள்ளாது. அது ஒரே ஒரு விஷயத்தைப் பற்றி மட்டுமே அக்கறை கொள்கிறது: பொருள் உண்மையில் நகர்ந்ததா?$Q$,
 null, null, 1),

('eeeeeeee-eeee-eeee-eeee-000000000002', 'cccccccc-cccc-cccc-cccc-000000000001', 'explanation',
 'The Precise Definition of Work',
 $Q$வேலையின் துல்லியமான வரையறை$Q$,
 $Q$In physics, work is done by a force only when that force displaces the object it acts on. If a force $F$ acts on a body and moves it through a displacement $dr$, the work done is:

- $W = F \cdot dr = Fd\cos\theta$

where $\theta$ is the angle between the force and the displacement.

Work is a SCALAR -- it has only magnitude, no direction, even though both force and displacement are vectors. Its SI unit is the newton-metre (N m), which we call the joule (J).$Q$,
 $Q$இயற்பியலில், ஒரு விசை அது செயல்படும் பொருளை இடம்பெயர்த்தும்போது மட்டுமே அது வேலையைச் செய்கிறது. ஒரு விசை $F$ ஒரு பொருளின் மீது செயல்பட்டு அதை $dr$ இடப்பெயர்ச்சி வழியாக நகர்த்தினால், செய்யப்படும் வேலை:

- $W = F \cdot dr = Fd\cos\theta$

இங்கு $\theta$ என்பது விசைக்கும் இடப்பெயர்ச்சிக்கும் இடையேயான கோணம்.

வேலை ஒரு அளவெண் (scalar) — விசையும் இடப்பெயர்ச்சியும் திசையன்களாக இருந்தாலும், வேலைக்கு அளவு மட்டுமே உண்டு, திசை இல்லை. அதன் SI அலகு நியூட்டன்-மீட்டர் (N m), இதை நாம் ஜூல் (J) என்று அழைக்கிறோம்.$Q$,
 null, null, 2),

('eeeeeeee-eeee-eeee-eeee-000000000003', 'cccccccc-cccc-cccc-cccc-000000000001', 'explanation',
 'When Is Work Zero, Positive, or Negative?',
 $Q$வேலை எப்போது பூஜ்ஜியம், நேர்குறி, அல்லது எதிர்குறியாக இருக்கும்?$Q$,
 $Q$The angle $\theta$ between force and displacement decides everything:

- $\theta = 0°$: work is positive and maximum ($\cos0°=1$) -- force and motion point the same way.
- $0° < \theta < 90°$: work is positive.
- $\theta = 90°$: work is exactly zero -- force and motion are perpendicular. This is why gravity does no work on something moving horizontally, and why centripetal force never does work on an object in circular motion.
- $90° < \theta < 180°$: work is negative.
- $\theta = 180°$: work is negative and maximum -- force directly opposes motion, like friction slowing a sliding box, or a goalkeeper catching a ball.

Work is also zero whenever the force itself is zero, or whenever the displacement itself is zero (like pushing an immovable wall).$Q$,
 $Q$விசைக்கும் இடப்பெயர்ச்சிக்கும் இடையேயான கோணம் $\theta$ அனைத்தையும் தீர்மானிக்கிறது:

- $\theta = 0°$: வேலை நேர்குறியும் அதிகபட்சமும் ($\cos0°=1$) — விசையும் இயக்கமும் ஒரே திசையில் செல்கின்றன.
- $0° < \theta < 90°$: வேலை நேர்குறி.
- $\theta = 90°$: வேலை சரியாக பூஜ்ஜியம் — விசையும் இயக்கமும் செங்குத்தாக உள்ளன. கிடைமட்டமாக நகரும் ஒன்றின் மீது ஈர்ப்பு எந்த வேலையும் செய்யாதது, வட்ட இயக்கத்தில் நோக்குமைய விசை ஒருபோதும் வேலை செய்யாதது ஆகியவற்றுக்கு இதுவே காரணம்.
- $90° < \theta < 180°$: வேலை எதிர்குறி.
- $\theta = 180°$: வேலை எதிர்குறியும் அதிகபட்சமும் — விசை இயக்கத்தை நேரடியாக எதிர்க்கிறது, சறுக்கும் பெட்டியை மந்தப்படுத்தும் உராய்வு, அல்லது பந்தைப் பிடிக்கும் கோல்கீப்பர் போன்றவை.

விசையே பூஜ்ஜியமாக இருந்தாலும், அல்லது இடப்பெயர்ச்சியே பூஜ்ஜியமாக இருந்தாலும் (நகராத சுவரைத் தள்ளுவது போன்றவை) வேலை பூஜ்ஜியமாகும்.$Q$,
 null, null, 3),

('eeeeeeee-eeee-eeee-eeee-000000000004', 'cccccccc-cccc-cccc-cccc-000000000001', 'example',
 'Reading the Formula With Real Numbers',
 $Q$உண்மையான எண்களுடன் சூத்திரத்தைப் படித்தல்$Q$,
 $Q$A box is pulled with a force of $25$ N to produce a displacement of $15$ m. The angle between the force and the displacement is $30°$. Find the work done.

Using $W = Fd\cos\theta$:

- $W = 25 \times 15 \times \cos30° = 375 \times 0.866 \approx 324.8$ J

Now a second case -- an object of mass $2$ kg falls from a height of $5$ m to the ground ($g=10$ m/s², neglecting air resistance). What is the work done by gravity?

Here the force (weight, $mg$) and the displacement (downward, $5$ m) point in the exact same direction, so $\theta=0°$ and $\cos\theta=1$:

- $W = mgh\cos0° = 2 \times 10 \times 5 \times 1 = 100$ J

Same formula, two very different situations -- a pulled box at an angle, and a falling object where the force and motion line up perfectly.$Q$,
 $Q$ஒரு பெட்டி $25$ N விசையால் இழுக்கப்பட்டு $15$ m இடப்பெயர்ச்சியை உருவாக்குகிறது. விசைக்கும் இடப்பெயர்ச்சிக்கும் இடையேயான கோணம் $30°$. செய்யப்பட்ட வேலையைக் காணவும்.

$W = Fd\cos\theta$ ஐப் பயன்படுத்தி:

- $W = 25 \times 15 \times \cos30° = 375 \times 0.866 \approx 324.8$ J

இப்போது இரண்டாவது நிலை — $2$ kg நிறையுள்ள ஒரு பொருள் $5$ m உயரத்திலிருந்து தரையில் விழுகிறது ($g=10$ m/s², காற்று எதிர்ப்பைப் புறக்கணிக்கவும்). ஈர்ப்பால் செய்யப்படும் வேலை என்ன?

இங்கு விசையும் (எடை, $mg$) இடப்பெயர்ச்சியும் (கீழ்நோக்கி, $5$ m) சரியாக ஒரே திசையில் உள்ளன, எனவே $\theta=0°$, $\cos\theta=1$:

- $W = mgh\cos0° = 2 \times 10 \times 5 \times 1 = 100$ J

ஒரே சூத்திரம், இரண்டு மிகவும் வேறுபட்ட சூழ்நிலைகள் — ஒரு கோணத்தில் இழுக்கப்படும் பெட்டி, மற்றும் விசையும் இயக்கமும் சரியாக இணைந்த வீழும் பொருள்.$Q$,
 null, null, 5),

('eeeeeeee-eeee-eeee-eeee-000000000005', 'cccccccc-cccc-cccc-cccc-000000000001', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000001', 6),
('eeeeeeee-eeee-eeee-eeee-000000000006', 'cccccccc-cccc-cccc-cccc-000000000001', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000002', 7),
('eeeeeeee-eeee-eeee-eeee-000000000007', 'cccccccc-cccc-cccc-cccc-000000000001', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000003', 8)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 2 -- Kinetic Energy, Potential Energy, Work-Energy Theorem
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000004', 'fill_blank',
 $Q$A $2$ kg object, initially at rest, has $50$ J of work done on it by a net force. Find its final speed.$Q$,
 $Q$ஓய்வில் இருந்த $2$ kg நிறையுள்ள ஒரு பொருளின் மீது ஒரு நிகர விசையால் $50$ J வேலை செய்யப்படுகிறது. அதன் இறுதி வேகத்தைக் காணவும்.$Q$,
 $Q${"blanks": [{"label": "Final speed v (m/s)", "type": "number", "correct": 7.07}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "இறுதி வேகம் v (m/s)"}]}$Q$::jsonb,
 $Q$By the work-energy theorem, $W = \Delta KE = \tfrac{1}{2}mv^2 - \tfrac{1}{2}mu^2$. Since it starts at rest ($u=0$): $50 = \tfrac{1}{2}(2)v^2 \Rightarrow v^2 = 50 \Rightarrow v = \sqrt{50} \approx 7.07$ m/s.$Q$,
 $Q$வேலை-ஆற்றல் தேற்றத்தின்படி, $W = \Delta KE = \tfrac{1}{2}mv^2 - \tfrac{1}{2}mu^2$. ஓய்வில் தொடங்குவதால் ($u=0$): $50 = \tfrac{1}{2}(2)v^2 \Rightarrow v^2 = 50 \Rightarrow v \approx 7.07$ m/s.$Q$,
 $Q$Work done EQUALS the change in kinetic energy, not the final kinetic energy directly -- if the object had started with some initial speed, you'd need to add that starting KE first.$Q$,
 $Q$செய்யப்பட்ட வேலை இயக்க ஆற்றலின் மாற்றத்திற்குச் சமம், நேரடியாக இறுதி இயக்க ஆற்றலுக்கு அல்ல — பொருள் ஏதேனும் தொடக்க வேகத்துடன் தொடங்கியிருந்தால், அந்த தொடக்க KE ஐ முதலில் சேர்க்க வேண்டும்.$Q$,
 'Work-energy theorem: W = ΔKE. It''s the single most useful shortcut in this whole chapter -- work done always shows up as a change in kinetic energy.',
 $Q$வேலை-ஆற்றல் தேற்றம்: W = ΔKE. இது இந்த முழு அத்தியாயத்திலும் மிகவும் பயனுள்ள குறுக்குவழி — செய்யப்படும் வேலை எப்போதும் இயக்க ஆற்றலின் மாற்றமாகத் தெரியும்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000005', 'mcq',
 $Q$Two objects have exactly the same momentum, but object A has a smaller mass than object B. Which object has more kinetic energy?$Q$,
 $Q$இரு பொருட்களும் சரியாக ஒரே உந்தத்தைக் கொண்டுள்ளன, ஆனால் பொருள் A இன் நிறை பொருள் B ஐ விட குறைவு. எந்த பொருளுக்கு அதிக இயக்க ஆற்றல் உள்ளது?$Q$,
 $Q${"options": ["Object A (the lighter one)", "Object B (the heavier one)", "Both have exactly the same kinetic energy", "Cannot be determined without knowing the actual speeds"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["பொருள் A (இலகுவானது)", "பொருள் B (கனமானது)", "இரண்டிற்கும் சரியாக ஒரே இயக்க ஆற்றல்", "உண்மையான வேகங்களை அறியாமல் தீர்மானிக்க முடியாது"]}$Q$::jsonb,
 $Q$Kinetic energy in terms of momentum is $KE = p^2/2m$. For a FIXED momentum $p$, $KE$ is inversely proportional to mass -- so the lighter object (A) has the larger kinetic energy. This exactly matches the textbook's own example: a $2$ kg and a $4$ kg object sharing the same $20$ kg m/s momentum have kinetic energies of $100$ J and $50$ J respectively -- the lighter one has double the KE.$Q$,
 $Q$உந்தத்தின் அடிப்படையில் இயக்க ஆற்றல் $KE = p^2/2m$. நிலையான உந்தம் $p$ க்கு, $KE$ நிறைக்கு நேர்மாறு விகிதத்தில் இருக்கும் — எனவே இலகுவான பொருள் (A) அதிக இயக்க ஆற்றலைக் கொண்டிருக்கும். இது பாடப்புத்தகத்தின் சொந்த உதாரணத்துடன் சரியாகப் பொருந்துகிறது: $2$ kg மற்றும் $4$ kg பொருட்கள் இரண்டும் $20$ kg m/s உந்தத்தைப் பகிர்ந்துகொள்ளும்போது, முறையே $100$ J மற்றும் $50$ J இயக்க ஆற்றலைக் கொண்டுள்ளன — இலகுவானதற்கு இரட்டிப்பு KE உள்ளது.$Q$,
 $Q$It's tempting to assume "same momentum" means "same everything" -- but mass and velocity can trade off in different ways while momentum stays fixed, and KE cares about that trade-off differently than momentum does.$Q$,
 $Q$"ஒரே உந்தம்" என்றால் "எல்லாமே ஒன்றுதான்" என்று நினைக்கத் தோன்றும் — ஆனால் உந்தம் நிலையாக இருக்கும்போது நிறையும் திசைவேகமும் வெவ்வேறு வழிகளில் மாறலாம், KE அந்த மாற்றத்தை உந்தத்தை விட வித்தியாசமாகக் கருதுகிறது.$Q$,
 'KE = p²/2m -- for the same momentum, the lighter object always has more kinetic energy.',
 $Q$KE = p²/2m — ஒரே உந்தத்திற்கு, இலகுவான பொருளுக்கு எப்போதும் அதிக இயக்க ஆற்றல் இருக்கும்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000006', 'fill_blank',
 $Q$An object of mass $3$ kg is taken to a height of $8$ m from the ground. Take $g = 9.8$ m/s². Calculate the gravitational potential energy stored in the object.$Q$,
 $Q$$3$ kg நிறையுள்ள ஒரு பொருள் தரையிலிருந்து $8$ m உயரத்திற்கு எடுத்துச் செல்லப்படுகிறது. $g = 9.8$ m/s² எனக் கொள்ளவும். பொருளில் சேமிக்கப்பட்ட ஈர்ப்பு நிலை ஆற்றலைக் கணக்கிடவும்.$Q$,
 $Q${"blanks": [{"label": "Potential energy U (J)", "type": "number", "correct": 235.2}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "நிலை ஆற்றல் U (J)"}]}$Q$::jsonb,
 $Q$Gravitational potential energy near Earth's surface: $U = mgh = 3 \times 9.8 \times 8 = 235.2$ J. This is the work an external force did to lift the object there at constant velocity -- energy transferred from the lifting agency, now stored in the object's position.$Q$,
 $Q$பூமியின் மேற்பரப்புக்கு அருகில் ஈர்ப்பு நிலை ஆற்றல்: $U = mgh = 3 \times 9.8 \times 8 = 235.2$ J. இது பொருளை மாறா வேகத்தில் அங்கு தூக்குவதற்கு ஒரு வெளிப்புற விசை செய்த வேலை — தூக்கும் முகவரிடமிருந்து மாற்றப்பட்ட ஆற்றல், இப்போது பொருளின் நிலையில் சேமிக்கப்பட்டுள்ளது.$Q$,
 null, null,
 'U = mgh -- potential energy is measured relative to a chosen reference (ground) level, and grows linearly with height.',
 $Q$U = mgh — நிலை ஆற்றல் தேர்ந்தெடுக்கப்பட்ட ஒரு குறிப்பு (தரை) மட்டத்தைப் பொறுத்து அளக்கப்படுகிறது, உயரத்துடன் நேரியல் விகிதத்தில் வளரும்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000007', 'fill_blank',
 $Q$A spring with force constant $k = 200$ N/m is compressed by $x = 0.05$ m from its equilibrium position. Calculate the elastic potential energy stored in the spring.$Q$,
 $Q$$k = 200$ N/m விசை மாறிலி கொண்ட ஒரு சுருள்வில், அதன் சமநிலை நிலையிலிருந்து $x = 0.05$ m சுருக்கப்படுகிறது. சுருள்வில்லில் சேமிக்கப்பட்ட மீள் நிலை ஆற்றலைக் கணக்கிடவும்.$Q$,
 $Q${"blanks": [{"label": "Elastic potential energy U (J)", "type": "number", "correct": 0.25}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "மீள் நிலை ஆற்றல் U (J)"}]}$Q$::jsonb,
 $Q$Elastic potential energy: $U = \tfrac{1}{2}kx^2 = \tfrac{1}{2} \times 200 \times (0.05)^2 = \tfrac{1}{2} \times 200 \times 0.0025 = 0.25$ J. Note this formula gives the same energy whether the spring is stretched OR compressed by $x$ -- only the magnitude of displacement from equilibrium matters, per the textbook's own remark that the stored energy doesn't depend on the mass attached to the spring.$Q$,
 $Q$மீள் நிலை ஆற்றல்: $U = \tfrac{1}{2}kx^2 = \tfrac{1}{2} \times 200 \times (0.05)^2 = 0.25$ J. இந்த சூத்திரம், சுருள்வில் $x$ ஆல் நீட்டப்பட்டாலும் சுருக்கப்பட்டாலும் ஒரே ஆற்றலைத் தரும் என்பதைக் கவனிக்கவும் — சமநிலையிலிருந்து இடப்பெயர்ச்சியின் அளவு மட்டுமே முக்கியம், சுருள்வில்லுடன் இணைக்கப்பட்ட நிறையைச் சார்ந்தது அல்ல என்ற பாடப்புத்தகத்தின் குறிப்பையொட்டி.$Q$,
 $Q$Squaring $x$ before multiplying by $k/2$ is essential -- and don't forget to convert cm to metres first if the displacement is given in cm.$Q$,
 $Q$$k/2$ ஆல் பெருக்கும் முன் $x$ ஐ வர்க்கமாக்குவது அவசியம் — இடப்பெயர்ச்சி cm இல் கொடுக்கப்பட்டிருந்தால், முதலில் m ஆக மாற்ற மறக்க வேண்டாம்.$Q$,
 'U = ½kx² for a spring -- energy grows with the SQUARE of displacement, so doubling the stretch quadruples the stored energy.',
 $Q$சுருள்வில்லுக்கு U = ½kx² — ஆற்றல் இடப்பெயர்ச்சியின் வர்க்கத்திற்கு ஏற்ப வளரும், எனவே நீட்டலை இரட்டிப்பாக்கினால், சேமிக்கப்பட்ட ஆற்றல் நான்கு மடங்காகும்.$Q$,
 'spring_pe'
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('eeeeeeee-eeee-eeee-eeee-000000000008', 'cccccccc-cccc-cccc-cccc-000000000002', 'motivation',
 'Where Does the Energy Go?',
 $Q$ஆற்றல் எங்கே செல்கிறது?$Q$,
 $Q$A hammer at rest on a nail does nothing. The same hammer, swung and moving, drives the nail deep into wood.

What changed? Not the hammer's mass. Only its motion. Somehow, motion itself is a form of stored capacity to do work -- and that capacity has a name and a precise formula.$Q$,
 $Q$ஒரு ஆணியின் மீது ஓய்வில் இருக்கும் சுத்தியல் எதுவும் செய்யாது. அதே சுத்தியல், ஆட்டப்பட்டு நகரும்போது, ஆணியை மரத்திற்குள் ஆழமாகச் செலுத்துகிறது.

என்ன மாறியது? சுத்தியலின் நிறை அல்ல. அதன் இயக்கம் மட்டுமே. எப்படியோ, இயக்கமே வேலை செய்யும் திறனின் ஒரு சேமிக்கப்பட்ட வடிவம் — அந்த திறனுக்கு ஒரு பெயரும் துல்லியமான சூத்திரமும் உண்டு.$Q$,
 null, null, 1),

('eeeeeeee-eeee-eeee-eeee-000000000009', 'cccccccc-cccc-cccc-cccc-000000000002', 'explanation',
 'Kinetic Energy and the Work-Energy Theorem',
 $Q$இயக்க ஆற்றல் மற்றும் வேலை-ஆற்றல் தேற்றம்$Q$,
 $Q$Kinetic energy is the energy a body possesses because of its motion:

- $KE = \tfrac{1}{2}mv^2$

Kinetic energy is always positive (or zero) -- mass and $v^2$ are both never negative.

By combining Newton's second law with the equations of motion, one can show that the work done by a net force on a body equals the CHANGE in its kinetic energy:

- $W = \Delta KE = \tfrac{1}{2}mv^2 - \tfrac{1}{2}mu^2$

This is the work-energy theorem. It means: positive work increases KE, negative work decreases KE, and zero net work leaves KE (and therefore speed) unchanged.$Q$,
 $Q$இயக்க ஆற்றல் என்பது ஒரு பொருள் அதன் இயக்கத்தால் கொண்டிருக்கும் ஆற்றல்:

- $KE = \tfrac{1}{2}mv^2$

இயக்க ஆற்றல் எப்போதும் நேர்குறி (அல்லது பூஜ்ஜியம்) — நிறையும் $v^2$ ஆவும் ஒருபோதும் எதிர்குறியாக இருக்காது.

நியூட்டனின் இரண்டாம் விதியை இயக்கவியல் சமன்பாடுகளுடன் இணைப்பதன் மூலம், ஒரு பொருளின் மீது நிகர விசையால் செய்யப்படும் வேலை அதன் இயக்க ஆற்றலின் மாற்றத்திற்குச் சமம் என்பதைக் காட்டலாம்:

- $W = \Delta KE = \tfrac{1}{2}mv^2 - \tfrac{1}{2}mu^2$

இதுவே வேலை-ஆற்றல் தேற்றம். இதன் பொருள்: நேர்குறி வேலை KE ஐ அதிகரிக்கிறது, எதிர்குறி வேலை KE ஐ குறைக்கிறது, பூஜ்ஜிய நிகர வேலை KE ஐ (எனவே வேகத்தையும்) மாற்றாமல் விடும்.$Q$,
 null, null, 2),

('eeeeeeee-eeee-eeee-eeee-000000000010', 'cccccccc-cccc-cccc-cccc-000000000002', 'explanation',
 'Potential Energy: Stored by Position',
 $Q$நிலை ஆற்றல்: நிலையால் சேமிக்கப்படுவது$Q$,
 $Q$While kinetic energy comes from motion, potential energy comes from POSITION or CONFIGURATION relative to some force.

Near Earth's surface, gravitational potential energy at height $h$ is:

- $U = mgh$

For a stretched or compressed spring with force constant $k$ and displacement $x$ from equilibrium:

- $U = \tfrac{1}{2}kx^2$

Both are defined as the work an external agent does to move the object to that position at constant velocity (so no extra kinetic energy is imparted along the way) -- the energy is transferred from the external agent and stored as potential energy, ready to be released back as kinetic energy later.$Q$,
 $Q$இயக்க ஆற்றல் இயக்கத்திலிருந்து வருகிறது, நிலை ஆற்றல் ஒரு விசையைப் பொறுத்த நிலை அல்லது அமைப்பிலிருந்து வருகிறது.

பூமியின் மேற்பரப்புக்கு அருகில், $h$ உயரத்தில் ஈர்ப்பு நிலை ஆற்றல்:

- $U = mgh$

$k$ விசை மாறிலியும் சமநிலையிலிருந்து $x$ இடப்பெயர்ச்சியும் கொண்ட நீட்டப்பட்ட அல்லது சுருக்கப்பட்ட சுருள்வில்லுக்கு:

- $U = \tfrac{1}{2}kx^2$

இரண்டும், பொருளை மாறா வேகத்தில் அந்த நிலைக்கு நகர்த்த ஒரு வெளிப்புற முகவர் செய்யும் வேலையாக வரையறுக்கப்படுகின்றன (எனவே வழியில் கூடுதல் இயக்க ஆற்றல் எதுவும் வழங்கப்படாது) — ஆற்றல் வெளிப்புற முகவரிடமிருந்து மாற்றப்பட்டு நிலை ஆற்றலாக சேமிக்கப்படுகிறது, பின்னர் மீண்டும் இயக்க ஆற்றலாக வெளியிடத் தயாராக உள்ளது.$Q$,
 null, null, 3),

('eeeeeeee-eeee-eeee-eeee-000000000011', 'cccccccc-cccc-cccc-cccc-000000000002', 'example',
 'Same Momentum, Different Kinetic Energy',
 $Q$ஒரே உந்தம், வேறுபட்ட இயக்க ஆற்றல்$Q$,
 $Q$Two objects of masses $2$ kg and $4$ kg are both moving with the same momentum, $p = 20$ kg m/s. Do they have the same kinetic energy?

Using $KE = \dfrac{p^2}{2m}$:

- For the $2$ kg object: $KE = \dfrac{20^2}{2\times2} = \dfrac{400}{4} = 100$ J
- For the $4$ kg object: $KE = \dfrac{20^2}{2\times4} = \dfrac{400}{8} = 50$ J

Even though both share exactly the same momentum, the lighter object has DOUBLE the kinetic energy of the heavier one. This is because kinetic energy, at fixed momentum, is inversely proportional to mass. The two objects also do NOT have the same speed -- since $p=mv$, the lighter object must be moving faster to carry the same momentum.$Q$,
 $Q$$2$ kg மற்றும் $4$ kg நிறையுள்ள இரு பொருட்களும் ஒரே உந்தம் $p = 20$ kg m/s உடன் நகர்கின்றன. அவற்றுக்கு ஒரே இயக்க ஆற்றல் உள்ளதா?

$KE = \dfrac{p^2}{2m}$ ஐப் பயன்படுத்தி:

- $2$ kg பொருளுக்கு: $KE = \dfrac{400}{4} = 100$ J
- $4$ kg பொருளுக்கு: $KE = \dfrac{400}{8} = 50$ J

இரண்டும் சரியாக ஒரே உந்தத்தைப் பகிர்ந்துகொண்டாலும், இலகுவான பொருளுக்கு கனமானதை விட இரட்டிப்பு இயக்க ஆற்றல் உள்ளது. ஏனெனில், நிலையான உந்தத்தில், இயக்க ஆற்றல் நிறைக்கு நேர்மாறு விகிதத்தில் இருக்கும். இரு பொருட்களுக்கும் ஒரே வேகமும் இல்லை — $p=mv$ என்பதால், அதே உந்தத்தைச் சுமக்க இலகுவான பொருள் வேகமாக நகர வேண்டும்.$Q$,
 null, null, 4),

('eeeeeeee-eeee-eeee-eeee-000000000012', 'cccccccc-cccc-cccc-cccc-000000000002', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000004', 5),
('eeeeeeee-eeee-eeee-eeee-000000000013', 'cccccccc-cccc-cccc-cccc-000000000002', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000005', 6),
('eeeeeeee-eeee-eeee-eeee-000000000014', 'cccccccc-cccc-cccc-cccc-000000000002', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000006', 7),
('eeeeeeee-eeee-eeee-eeee-000000000015', 'cccccccc-cccc-cccc-cccc-000000000002', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000007', 8)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 3 -- Conservative Forces & the Law of Conservation of Energy
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000008', 'mcq',
 $Q$Which of the following is a CONSERVATIVE force?$Q$,
 $Q$பின்வருவனவற்றுள் எது ஒரு பாதுகாப்பு விசை (conservative force)?$Q$,
 $Q${"options": ["Gravitational force", "Friction", "Air resistance", "Viscous force"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["ஈர்ப்பு விசை", "உராய்வு", "காற்று எதிர்ப்பு", "பாகுநிலை விசை"]}$Q$::jsonb,
 $Q$Gravitational force, spring force, and electrostatic (Coulomb) force are all conservative -- the work they do depends only on the start and end positions, never on the path taken. Friction, air resistance, and viscous force are all non-conservative -- the work done against them depends on the actual length of the path travelled, since they continuously drain mechanical energy into heat.$Q$,
 $Q$ஈர்ப்பு விசை, சுருள்வில் விசை, மற்றும் நிலைமின்னியல் (கூலூம்) விசை அனைத்தும் பாதுகாப்பானவை — அவை செய்யும் வேலை தொடக்க மற்றும் இறுதி நிலைகளை மட்டுமே சார்ந்தது, எடுக்கப்படும் பாதையை ஒருபோதும் சாராது. உராய்வு, காற்று எதிர்ப்பு, பாகுநிலை விசை அனைத்தும் பாதுகாப்பற்றவை — அவற்றுக்கு எதிராகச் செய்யப்படும் வேலை பயணிக்கப்பட்ட பாதையின் உண்மையான நீளத்தைச் சார்ந்தது, ஏனெனில் அவை தொடர்ந்து இயந்திர ஆற்றலை வெப்பமாக வடிகட்டுகின்றன.$Q$,
 null, null,
 'Conservative forces (gravity, spring, Coulomb) don''t care about the path; non-conservative forces (friction, drag) drain energy in proportion to path length.',
 $Q$பாதுகாப்பு விசைகள் (ஈர்ப்பு, சுருள்வில், கூலூம்) பாதையைப் பொருட்படுத்தாது; பாதுகாப்பற்ற விசைகள் (உராய்வு, இழுவிசை) பாதையின் நீளத்திற்கு விகிதாசாரமாக ஆற்றலை வடிகட்டும்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000009', 'fill_blank',
 $Q$An object of mass $2$ kg is falling from height $h = 20$ m ($g=10$ m/s²). Using the law of conservation of energy, calculate its potential energy and kinetic energy when it is at a height of $5$ m.$Q$,
 $Q$$2$ kg நிறையுள்ள ஒரு பொருள் $h = 20$ m உயரத்திலிருந்து விழுகிறது ($g=10$ m/s²). ஆற்றல் அழிவின்மை விதியைப் பயன்படுத்தி, அது $5$ m உயரத்தில் இருக்கும்போது அதன் நிலை ஆற்றல் மற்றும் இயக்க ஆற்றலைக் கணக்கிடவும்.$Q$,
 $Q${"blanks": [{"label": "Potential energy at h=5m (J)", "type": "number", "correct": 100}, {"label": "Kinetic energy at h=5m (J)", "type": "number", "correct": 300}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "h=5m இல் நிலை ஆற்றல் (J)"}, {"label": "h=5m இல் இயக்க ஆற்றல் (J)"}]}$Q$::jsonb,
 $Q$Total energy at the start (height $20$ m, at rest) is purely potential: $E = mgh = 2 \times 10 \times 20 = 400$ J. Since gravity is conservative, this total stays $400$ J throughout the fall. At $h=5$ m: $U = mgh = 2 \times 10 \times 5 = 100$ J, and since $E = U + KE$: $KE = 400 - 100 = 300$ J.$Q$,
 $Q$தொடக்கத்தில் (உயரம் $20$ m, ஓய்வில்) மொத்த ஆற்றல் முற்றிலும் நிலை ஆற்றல்: $E = mgh = 2 \times 10 \times 20 = 400$ J. ஈர்ப்பு பாதுகாப்பானது என்பதால், இந்த மொத்தம் வீழ்ச்சி முழுவதும் $400$ J ஆகவே இருக்கும். $h=5$ m இல்: $U = mgh = 100$ J, $E = U + KE$ என்பதால்: $KE = 400 - 100 = 300$ J.$Q$,
 $Q$Don't recompute the total energy at every height -- it's CONSTANT throughout the fall (that's the whole point of conservation). Just find U at the new height and subtract from the same fixed total.$Q$,
 $Q$ஒவ்வொரு உயரத்திலும் மொத்த ஆற்றலை மீண்டும் கணக்கிட வேண்டாம் — அது வீழ்ச்சி முழுவதும் மாறாமல் இருக்கும் (அதுவே அழிவின்மையின் முழுப் பொருள்). புதிய உயரத்தில் U ஐக் கண்டறிந்து, அதே நிலையான மொத்தத்திலிருந்து கழிக்கவும்.$Q$,
 'Total mechanical energy (KE + PE) stays fixed throughout the fall -- only how it''s SPLIT between kinetic and potential changes.',
 $Q$வீழ்ச்சி முழுவதும் மொத்த இயந்திர ஆற்றல் (KE + PE) நிலையாக இருக்கும் — இயக்க மற்றும் நிலை ஆற்றலுக்கு இடையே அது எவ்வாறு பிரிக்கப்படுகிறது என்பது மட்டுமே மாறும்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000010', 'mcq',
 $Q$A $100$ kg object is lifted to a height of $10$ m from the ground in two different ways: (1) straight up, or (2) along a $30°$ ramp. Since gravity is a conservative force, how does the work done BY GRAVITY on the object compare between the two paths?$Q$,
 $Q$$100$ kg பொருள் ஒன்று தரையிலிருந்து $10$ m உயரத்திற்கு இரு வெவ்வேறு வழிகளில் தூக்கப்படுகிறது: (1) நேராக மேலே, அல்லது (2) $30°$ சரிவின் வழியாக. ஈர்ப்பு ஒரு பாதுகாப்பு விசை என்பதால், பொருளின் மீது ஈர்ப்பால் செய்யப்படும் வேலை இரு பாதைகளுக்கும் இடையே எவ்வாறு ஒப்பிடப்படுகிறது?$Q$,
 $Q${"options": ["Exactly the same in both paths, since gravity is conservative and only the height matters", "Greater along the straight path, since it's more direct", "Greater along the ramp, since the distance travelled is longer", "Cannot be compared without knowing the applied force"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["இரு பாதைகளிலும் சரியாக ஒரே அளவு, ஈர்ப்பு பாதுகாப்பானது என்பதாலும் உயரம் மட்டுமே முக்கியம் என்பதாலும்", "நேர்பாதையில் அதிகம், ஏனெனில் அது அதிக நேரடியானது", "சரிவில் அதிகம், ஏனெனில் பயணிக்கப்படும் தூரம் அதிகம்", "செலுத்தப்படும் விசையை அறியாமல் ஒப்பிட முடியாது"]}$Q$::jsonb,
 $Q$Because gravity is conservative, the work it does depends only on the change in height, not on the path -- in both cases here it's $mgh = 100 \times 10 \times 10 = 10{,}000$ J. What DOES differ between the paths is how much APPLIED force is needed: straight up needs the full $mg=1000$ N over a short $10$ m; the ramp needs only $mg\sin30°=500$ N, but over a longer $20$ m path -- less force, more distance, same total work. That's exactly why ramps make heavy lifting feel easier.$Q$,
 $Q$ஈர்ப்பு பாதுகாப்பானது என்பதால், அது செய்யும் வேலை உயரத்தின் மாற்றத்தை மட்டுமே சார்ந்தது, பாதையை அல்ல — இரு நிலைகளிலும் இது $mgh = 100 \times 10 \times 10 = 10{,}000$ J. பாதைகளுக்கு இடையே உண்மையில் வேறுபடுவது எவ்வளவு செலுத்தும் விசை தேவை என்பதே: நேராக மேலே செல்ல முழு $mg=1000$ N தேவை $10$ m குறுகிய தூரத்தில்; சரிவுக்கு $mg\sin30°=500$ N மட்டுமே தேவை, ஆனால் நீண்ட $20$ m பாதையில் — குறைந்த விசை, அதிக தூரம், ஒரே மொத்த வேலை. கனமான பொருட்களைத் தூக்குவதை சரிவு எளிதாக்குவதற்கு இதுவே காரணம்.$Q$,
 $Q$"Longer path" doesn't mean "more work by gravity" -- that intuition applies to non-conservative forces like friction, not to gravity.$Q$,
 $Q$"நீண்ட பாதை" என்றால் "ஈர்ப்பால் அதிக வேலை" என்று அர்த்தமல்ல — அந்த உள்ளுணர்வு உராய்வு போன்ற பாதுகாப்பற்ற விசைகளுக்குப் பொருந்தும், ஈர்ப்புக்கு அல்ல.$Q$,
 'For a conservative force, work done depends only on start/end position -- the same height change always costs the same work by gravity, no matter the route.',
 $Q$ஒரு பாதுகாப்பு விசைக்கு, செய்யப்படும் வேலை தொடக்க/இறுதி நிலையை மட்டுமே சார்ந்தது — அதே உயர மாற்றத்திற்கு, பாதை எதுவாக இருந்தாலும், ஈர்ப்பால் எப்போதும் ஒரே வேலை செலவாகும்.$Q$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('eeeeeeee-eeee-eeee-eeee-000000000016', 'cccccccc-cccc-cccc-cccc-000000000003', 'motivation',
 'Gravity Doesn''t Care Which Way You Go',
 $Q$எந்த வழியில் சென்றாலும் ஈர்ப்புக்கு அக்கறையில்லை$Q$,
 $Q$Carry a bag straight up a hill, or carry it along a long winding path to the same top -- gravity does the exact same amount of work on it either way, as long as the start and end heights match.

Now imagine dragging that same bag through mud instead. The longer, winding path costs you a lot more effort than the straight one. Same bag, same height gained -- but a completely different rule applies.

What's the difference?$Q$,
 $Q$ஒரு பையை மலைமீது நேராகச் சுமந்து செல்லுங்கள், அல்லது அதே உச்சிக்கு நீண்ட வளைந்த பாதை வழியாகச் சுமந்து செல்லுங்கள் — தொடக்க மற்றும் இறுதி உயரங்கள் பொருந்தும் வரை, ஈர்ப்பு அதன் மீது இரு வழிகளிலும் சரியாக ஒரே அளவு வேலையைச் செய்யும்.

இப்போது அதே பையை சேற்றின் வழியாக இழுப்பதாக நினைத்துப் பாருங்கள். நீண்ட, வளைந்த பாதை நேர்பாதையை விட மிக அதிக முயற்சியை உங்களிடமிருந்து எடுக்கும். அதே பை, அதே உயர ஆதாயம் — ஆனால் முற்றிலும் வேறுபட்ட விதி பொருந்துகிறது.

வேறுபாடு என்ன?$Q$,
 null, null, 1),

('eeeeeeee-eeee-eeee-eeee-000000000017', 'cccccccc-cccc-cccc-cccc-000000000003', 'explanation',
 'Conservative vs. Non-Conservative Forces',
 $Q$பாதுகாப்பு விசைகள் Vs பாதுகாப்பற்ற விசைகள்$Q$,
 $Q$A force is CONSERVATIVE if the work it does moving a body depends only on the initial and final positions -- never on the path taken. Equivalently: the work done by a conservative force around any closed round-trip path is always zero.

Gravitational force, spring force, and electrostatic (Coulomb) force are all conservative.

A force is NON-CONSERVATIVE if the work done depends on the actual path -- friction is the classic example, since the work done against it depends on the total distance travelled, not just the start and end points. Air resistance and viscous force behave the same way.

A conservative force is also equal to the negative gradient of a potential energy function -- this is precisely why we can even define a "potential energy" for gravity and springs, but not for friction.$Q$,
 $Q$ஒரு விசை பாதுகாப்பானது (conservative), அது ஒரு பொருளை நகர்த்தும்போது செய்யும் வேலை தொடக்க மற்றும் இறுதி நிலைகளை மட்டுமே சார்ந்திருந்தால் — எடுக்கப்படும் பாதையை ஒருபோதும் சாராது. இணையாக: ஒரு பாதுகாப்பு விசை எந்தவொரு மூடிய சுற்றுப் பயணப் பாதையிலும் செய்யும் வேலை எப்போதும் பூஜ்ஜியம்.

ஈர்ப்பு விசை, சுருள்வில் விசை, நிலைமின்னியல் (கூலூம்) விசை அனைத்தும் பாதுகாப்பானவை.

ஒரு விசை பாதுகாப்பற்றது, செய்யப்படும் வேலை உண்மையான பாதையைச் சார்ந்திருந்தால் — உராய்வு இதற்கு சிறந்த உதாரணம், ஏனெனில் அதற்கு எதிராகச் செய்யப்படும் வேலை மொத்தம் பயணிக்கப்பட்ட தூரத்தைச் சார்ந்தது, தொடக்க மற்றும் இறுதி புள்ளிகளை மட்டும் அல்ல. காற்று எதிர்ப்பும் பாகுநிலை விசையும் இதே போல் நடந்துகொள்கின்றன.

ஒரு பாதுகாப்பு விசை, ஒரு நிலை ஆற்றல் சார்பின் எதிர்மறை சாய்வுக்கும் சமம் — ஈர்ப்பு மற்றும் சுருள்வில்களுக்கு "நிலை ஆற்றலை" வரையறுக்க முடிவதற்கு இதுவே சரியான காரணம், உராய்வுக்கு அல்ல.$Q$,
 null, null, 2),

('eeeeeeee-eeee-eeee-eeee-000000000018', 'cccccccc-cccc-cccc-cccc-000000000003', 'explanation',
 'The Law of Conservation of Energy',
 $Q$ஆற்றல் அழிவின்மை விதி$Q$,
 $Q$The law of conservation of energy states that energy can neither be created nor destroyed -- it may transform from one form to another, but the TOTAL energy of an isolated system stays constant.

Watch an object thrown straight up and falling back down: at the very top, all its energy is potential ($KE=0$). As it falls, potential energy steadily converts to kinetic energy. Just before it hits the ground, all its energy is kinetic ($U=0$). At every point in between, the energy is split between the two forms -- but the SUM, the total mechanical energy, never changes (as long as only conservative forces like gravity are acting, with no air resistance).$Q$,
 $Q$ஆற்றல் அழிவின்மை விதியின்படி, ஆற்றலை உருவாக்கவும் முடியாது அழிக்கவும் முடியாது — அது ஒரு வடிவத்திலிருந்து இன்னொரு வடிவமாக மாறலாம், ஆனால் ஒரு தனிமைப்படுத்தப்பட்ட அமைப்பின் மொத்த ஆற்றல் மாறாமல் இருக்கும்.

நேராக மேலே எறியப்பட்டு மீண்டும் கீழே விழும் ஒரு பொருளைப் பாருங்கள்: மிக உயரத்தில், அதன் அனைத்து ஆற்றலும் நிலை ஆற்றல் ($KE=0$). அது விழும்போது, நிலை ஆற்றல் நிலையாக இயக்க ஆற்றலாக மாறுகிறது. தரையில் மோதுவதற்கு சற்று முன், அதன் அனைத்து ஆற்றலும் இயக்க ஆற்றல் ($U=0$). இடையேயுள்ள ஒவ்வொரு புள்ளியிலும், ஆற்றல் இரு வடிவங்களுக்கு இடையே பிரிக்கப்படுகிறது — ஆனால் கூட்டுத்தொகை, மொத்த இயந்திர ஆற்றல், ஒருபோதும் மாறாது (ஈர்ப்பு போன்ற பாதுகாப்பு விசைகள் மட்டுமே செயல்படும் வரை, காற்று எதிர்ப்பு இல்லாமல்).$Q$,
 null, null, 3),

('eeeeeeee-eeee-eeee-eeee-000000000019', 'cccccccc-cccc-cccc-cccc-000000000003', 'example',
 'Tracking Energy Through a Fall',
 $Q$வீழ்ச்சி முழுவதும் ஆற்றலைக் கண்காணித்தல்$Q$,
 $Q$An object of mass $1$ kg is falling from a height $h=10$ m ($g=10$ m/s²). Find the total energy, and the potential and kinetic energy when it's at $h=4$ m.

Total energy at the start (purely potential, since it begins at rest): $E = U = mgh = 1\times10\times10 = 100$ J.

Since gravity is conservative, this total ($100$ J) stays fixed throughout the fall.

At $h=4$ m: $U = mgh = 1\times10\times4 = 40$ J. Since $E=U+KE$: $KE = 100-40 = 60$ J.

As a check, the object has fallen $10-4=6$ m by this point. Using $v=\sqrt{2gh_{fallen}}=\sqrt{2\times10\times6}=\sqrt{120}$, the kinetic energy is $\tfrac{1}{2}(1)(120)=60$ J -- exactly matching the energy-conservation answer, confirming both methods agree.$Q$,
 $Q$$1$ kg நிறையுள்ள ஒரு பொருள் $h=10$ m உயரத்திலிருந்து விழுகிறது ($g=10$ m/s²). மொத்த ஆற்றலையும், அது $h=4$ m இல் இருக்கும்போது நிலை மற்றும் இயக்க ஆற்றலையும் காணவும்.

தொடக்கத்தில் மொத்த ஆற்றல் (முற்றிலும் நிலை ஆற்றல், ஓய்வில் தொடங்குவதால்): $E = U = mgh = 1\times10\times10 = 100$ J.

ஈர்ப்பு பாதுகாப்பானது என்பதால், இந்த மொத்தம் ($100$ J) வீழ்ச்சி முழுவதும் நிலையாக இருக்கும்.

$h=4$ m இல்: $U = mgh = 40$ J. $E=U+KE$ என்பதால்: $KE = 100-40 = 60$ J.

சரிபார்ப்பாக, இந்தப் புள்ளியில் பொருள் $10-4=6$ m விழுந்துள்ளது. $v=\sqrt{2gh_{fallen}}=\sqrt{2\times10\times6}=\sqrt{120}$ ஐப் பயன்படுத்தி, இயக்க ஆற்றல் $\tfrac{1}{2}(1)(120)=60$ J — ஆற்றல்-அழிவின்மை பதிலுடன் சரியாகப் பொருந்துகிறது, இரு முறைகளும் ஒத்துப்போவதை உறுதிப்படுத்துகிறது.$Q$,
 null, null, 4),

('eeeeeeee-eeee-eeee-eeee-000000000020', 'cccccccc-cccc-cccc-cccc-000000000003', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000008', 5),
('eeeeeeee-eeee-eeee-eeee-000000000021', 'cccccccc-cccc-cccc-cccc-000000000003', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000009', 6),
('eeeeeeee-eeee-eeee-eeee-000000000022', 'cccccccc-cccc-cccc-cccc-000000000003', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000010', 7)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 4 -- Motion in a Vertical Circle
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000011', 'fill_blank',
 $Q$A mass of $0.5$ kg is whirled in a vertical circle on a string ($g=10$ m/s²). Calculate the difference between the string tension at the lowest point and the tension at the highest point, $T_1 - T_2$.$Q$,
 $Q$$0.5$ kg நிறை ஒன்று ஒரு நூலில் செங்குத்து வட்டத்தில் சுழற்றப்படுகிறது ($g=10$ m/s²). மிகக் குறைந்த புள்ளியில் உள்ள நூல் இழுவிசைக்கும் உச்ச புள்ளியில் உள்ள இழுவிசைக்கும் இடையேயான வேறுபாடு $T_1 - T_2$ ஐக் கணக்கிடவும்.$Q$,
 $Q${"blanks": [{"label": "T1 - T2 (N)", "type": "number", "correct": 30}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "T1 - T2 (N)"}]}$Q$::jsonb,
 $Q$Regardless of the actual speed or radius, the tension difference between the lowest and highest points of a vertical circle always works out to $T_1 - T_2 = 6mg$. Here: $T_1 - T_2 = 6 \times 0.5 \times 10 = 30$ N.$Q$,
 $Q$உண்மையான வேகம் அல்லது ஆரம் எதுவாக இருந்தாலும், செங்குத்து வட்டத்தின் மிகக் குறைந்த மற்றும் உச்ச புள்ளிகளுக்கு இடையேயான இழுவிசை வேறுபாடு எப்போதும் $T_1 - T_2 = 6mg$ ஆக அமையும். இங்கு: $T_1 - T_2 = 6 \times 0.5 \times 10 = 30$ N.$Q$,
 null, null,
 'T1 - T2 = 6mg is a clean, radius-independent result -- it comes straight out of combining Newton''s second law with energy conservation at the two points.',
 $Q$T1 - T2 = 6mg என்பது ஆரத்தைச் சாராத ஒரு சுத்தமான முடிவு — இது நியூட்டனின் இரண்டாம் விதியையும் ஆற்றல் அழிவின்மையையும் இரு புள்ளிகளிலும் இணைப்பதன் மூலம் நேரடியாக வருகிறது.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000012', 'mcq',
 $Q$At the TOP of a vertical circular path (mass on a string), which forces point toward the centre of the circle (i.e., both act as part of the centripetal force)?$Q$,
 $Q$ஒரு செங்குத்து வட்டப் பாதையின் உச்சியில் (நூலில் உள்ள நிறை), எந்த விசைகள் வட்டத்தின் மையத்தை நோக்கிச் செல்கின்றன (அதாவது, இரண்டும் நோக்குமைய விசையின் ஒரு பகுதியாக செயல்படுகின்றன)?$Q$,
 $Q${"options": ["Both the weight (mg) and the tension (T)", "Only the weight", "Only the tension", "Neither -- both point away from the centre"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["எடையும் (mg) இழுவிசையும் (T) இரண்டும்", "எடை மட்டும்", "இழுவிசை மட்டும்", "எதுவும் இல்லை — இரண்டும் மையத்திலிருந்து விலகிச் செல்கின்றன"]}$Q$::jsonb,
 $Q$At the very top of the loop, the centre of the circle is BELOW the mass. Both the weight $mg$ (always downward) and the string tension $T$ (always pulling toward the centre, i.e. downward here) point toward the centre. That's why the equation at the top is $T + mg = \dfrac{mv^2}{r}$ -- both forces add up to supply the centripetal force. This is also why the tension can safely drop to zero at the top (gravity alone can supply the minimum required centripetal force), but never at the bottom.$Q$,
 $Q$வளையத்தின் உச்சியில், வட்டத்தின் மையம் நிறைக்குக் கீழே உள்ளது. எடை $mg$ (எப்போதும் கீழ்நோக்கி) மற்றும் நூல் இழுவிசை $T$ (எப்போதும் மையத்தை நோக்கி இழுக்கும், அதாவது இங்கு கீழ்நோக்கி) இரண்டும் மையத்தை நோக்கிச் செல்கின்றன. அதனால்தான் உச்சியில் உள்ள சமன்பாடு $T + mg = \dfrac{mv^2}{r}$ — இரு விசைகளும் சேர்ந்து நோக்குமைய விசையை வழங்குகின்றன. உச்சியில் இழுவிசை பாதுகாப்பாக பூஜ்ஜியமாகக் குறையக்கூடியதற்கும் (ஈர்ப்பு மட்டும் தேவையான குறைந்தபட்ச நோக்குமைய விசையை வழங்கும்), அடிப்பகுதியில் ஒருபோதும் அப்படி நடக்காததற்கும் இதுவே காரணம்.$Q$,
 $Q$At the BOTTOM, the two forces oppose each other instead ($T - mg = mv^2/r$), because the centre is now ABOVE the mass -- tension points up toward it, but gravity still points down, away from it.$Q$,
 $Q$அடிப்பகுதியில், இரு விசைகளும் ஒன்றையொன்று எதிர்க்கின்றன ($T - mg = mv^2/r$), ஏனெனில் இப்போது மையம் நிறைக்கு மேலே உள்ளது — இழுவிசை அதை நோக்கி மேலே செல்கிறது, ஆனால் ஈர்ப்பு இன்னும் கீழ்நோக்கி, அதிலிருந்து விலகிச் செல்கிறது.$Q$,
 'Whether gravity helps or opposes the centripetal requirement flips between the top and bottom of the loop -- that''s the whole reason tension is never constant in vertical circular motion.',
 $Q$ஈர்ப்பு நோக்குமைய தேவைக்கு உதவுகிறதா அல்லது எதிர்க்கிறதா என்பது வளையத்தின் உச்சிக்கும் அடிப்பகுதிக்கும் இடையே மாறுகிறது — செங்குத்து வட்ட இயக்கத்தில் இழுவிசை ஒருபோதும் மாறாமல் இல்லாததற்கு இதுவே முழுக் காரணம்.$Q$,
 'vertical_circle'
),

('dddddddd-dddd-dddd-dddd-000000000013', 'fill_blank',
 $Q$A bucket of water tied to a rope is whirled in a vertical circle of radius $0.8$ m ($g=10$ m/s²). Calculate the minimum velocity at the lowest point so that the water does not spill during the motion.$Q$,
 $Q$நூலில் கட்டப்பட்ட ஒரு நீர் வாளி $0.8$ m ஆரமுள்ள செங்குத்து வட்டத்தில் சுழற்றப்படுகிறது ($g=10$ m/s²). இயக்கத்தின்போது நீர் கொட்டாமல் இருக்க மிகக் குறைந்த புள்ளியில் தேவையான குறைந்தபட்ச வேகத்தைக் கணக்கிடவும்.$Q$,
 $Q${"blanks": [{"label": "Minimum speed at lowest point v1 (m/s)", "type": "number", "correct": 6.32}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "மிகக் குறைந்த புள்ளியில் குறைந்தபட்ச வேகம் v1 (m/s)"}]}$Q$::jsonb,
 $Q$"Water doesn't spill" is exactly the same physical condition as "string doesn't go slack" -- the minimum speed at the lowest point is $v_1 = \sqrt{5gr} = \sqrt{5 \times 10 \times 0.8} = \sqrt{40} \approx 6.32$ m/s. (This guarantees the minimum speed at the top, $v_2=\sqrt{gr}=\sqrt{8}\approx2.83$ m/s, is also met.)$Q$,
 $Q$"நீர் கொட்டாது" என்பது "நூல் தளர்வடையாது" என்ற அதே இயற்பியல் நிபந்தனை — மிகக் குறைந்த புள்ளியில் குறைந்தபட்ச வேகம் $v_1 = \sqrt{5gr} = \sqrt{5 \times 10 \times 0.8} = \sqrt{40} \approx 6.32$ m/s. (இது உச்சியில் தேவையான குறைந்தபட்ச வேகம் $v_2=\sqrt{gr}\approx2.83$ m/s ஐயும் உறுதி செய்கிறது.)$Q$,
 $Q$Don't use $v=\sqrt{gr}$ here -- that's the condition at the TOP of the loop, not the bottom. The bottom needs the larger $\sqrt{5gr}$, exactly 5 times the top's minimum speed squared.$Q$,
 $Q$இங்கு $v=\sqrt{gr}$ ஐப் பயன்படுத்த வேண்டாம் — அது வளையத்தின் உச்சியில் உள்ள நிபந்தனை, அடிப்பகுதியில் அல்ல. அடிப்பகுதிக்கு பெரிய $\sqrt{5gr}$ தேவை, உச்சியின் குறைந்தபட்ச வேகத்தின் வர்க்கத்தை விட சரியாக 5 மடங்கு.$Q$,
 'Minimum speed at the bottom (√5gr) is always 5x the square of the minimum speed at the top (√gr) -- the bottom always needs to be moving much faster.',
 $Q$அடிப்பகுதியில் குறைந்தபட்ச வேகம் (√5gr) எப்போதும் உச்சியின் குறைந்தபட்ச வேகத்தின் (√gr) வர்க்கத்தை விட 5 மடங்கு — அடிப்பகுதி எப்போதும் மிக வேகமாக நகர வேண்டும்.$Q$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('eeeeeeee-eeee-eeee-eeee-000000000023', 'cccccccc-cccc-cccc-cccc-000000000004', 'motivation',
 'The Bucket That Shouldn''t Work',
 $Q$வேலை செய்யக் கூடாத வாளி$Q$,
 $Q$Fill a bucket with water, whirl it fast overhead in a vertical circle. At the very top of the loop, the bucket is completely upside down -- and yet the water stays in.

Slow the whirl down enough, though, and at that same upside-down point, the water pours straight out onto your head.

There's a precise speed below which this trick fails. What decides it?$Q$,
 $Q$ஒரு வாளியில் தண்ணீரை நிரப்பி, அதை தலைக்கு மேல் செங்குத்து வட்டத்தில் வேகமாக சுழற்றுங்கள். வளையத்தின் மிக உச்சியில், வாளி முற்றிலும் தலைகீழாக உள்ளது — இருப்பினும் தண்ணீர் உள்ளேயே இருக்கும்.

போதுமான அளவு மெதுவாக சுழற்றினால், அதே தலைகீழ் புள்ளியில், தண்ணீர் நேராக உங்கள் தலையில் கொட்டும்.

இந்த தந்திரம் தோல்வியடையும் ஒரு துல்லியமான வேகம் உள்ளது. அதை எது தீர்மானிக்கிறது?$Q$,
 null, null, 1),

('eeeeeeee-eeee-eeee-eeee-000000000024', 'cccccccc-cccc-cccc-cccc-000000000004', 'explanation',
 'Forces in a Vertical Circle',
 $Q$செங்குத்து வட்டத்தில் விசைகள்$Q$,
 $Q$A mass tied to a string moves in a vertical circle of radius $r$. At a general point where the string makes angle $\theta$ with the vertically downward direction, two forces act: gravity ($mg$, always straight down) and tension ($T$, always along the string toward the centre).

Splitting into tangential and radial directions:

- Tangential: $mg\sin\theta = ma_t$ -- this means the speed is NOT constant around the loop; the motion is not uniform circular motion.
- Radial: $T - mg\cos\theta = \dfrac{mv^2}{r}$ -- this means the tension is also NOT constant; it depends on both speed and position.

At the lowest point (θ=0°, both gravity and the centripetal requirement point opposite ways): $T_1 = mg + \dfrac{mv_1^2}{r}$.

At the highest point (θ=180°, gravity now helps supply the centripetal force): $T_2 = \dfrac{mv_2^2}{r} - mg$.

Since $v_1 > v_2$ always (the object is faster at the bottom), $T_1$ is always greater than $T_2$ -- tension is maximum at the bottom and minimum at the top.$Q$,
 $Q$நூலில் கட்டப்பட்ட ஒரு நிறை $r$ ஆரமுள்ள செங்குத்து வட்டத்தில் நகர்கிறது. நூல் செங்குத்து கீழ்நோக்கிய திசையுடன் $\theta$ கோணத்தை அமைக்கும் ஒரு பொது புள்ளியில், இரு விசைகள் செயல்படுகின்றன: ஈர்ப்பு ($mg$, எப்போதும் நேராகக் கீழே) மற்றும் இழுவிசை ($T$, எப்போதும் நூல் வழியாக மையத்தை நோக்கி).

தொடுகோடு மற்றும் ஆரை வழி திசைகளாகப் பிரித்தால்:

- தொடுகோடு: $mg\sin\theta = ma_t$ — வேகம் வளையம் முழுவதும் மாறாமல் இல்லை என்பதே இதன் பொருள்; இயக்கம் சீரான வட்ட இயக்கம் அல்ல.
- ஆரை வழி: $T - mg\cos\theta = \dfrac{mv^2}{r}$ — இழுவிசையும் மாறாமல் இல்லை என்பதே இதன் பொருள்; அது வேகத்தையும் நிலையையும் சார்ந்தது.

மிகக் குறைந்த புள்ளியில் (θ=0°, ஈர்ப்பும் நோக்குமைய தேவையும் எதிரெதிர் திசைகளில் செல்கின்றன): $T_1 = mg + \dfrac{mv_1^2}{r}$.

உச்ச புள்ளியில் (θ=180°, ஈர்ப்பு இப்போது நோக்குமைய விசையை வழங்க உதவுகிறது): $T_2 = \dfrac{mv_2^2}{r} - mg$.

$v_1 > v_2$ எப்போதும் (பொருள் அடிப்பகுதியில் வேகமாக இருக்கும்) என்பதால், $T_1$ எப்போதும் $T_2$ ஐ விட அதிகம் — இழுவிசை அடிப்பகுதியில் அதிகபட்சமும் உச்சியில் குறைந்தபட்சமும்.$Q$,
 'vertical_circle', null, 2),

('eeeeeeee-eeee-eeee-eeee-000000000025', 'cccccccc-cccc-cccc-cccc-000000000004', 'explanation',
 'The Minimum Speed to Complete the Loop',
 $Q$வளையத்தை நிறைவு செய்ய தேவையான குறைந்தபட்ச வேகம்$Q$,
 $Q$For a string (which can only pull, never push), the loop fails the instant tension would need to go negative -- the string just goes slack instead. The critical case is at the TOP, where tension is smallest.

Setting $T_2=0$ in the equation at the top: $\dfrac{mv_2^2}{r} = mg \Rightarrow v_2 = \sqrt{gr}$. This is the minimum speed required at the top.

Combining this with energy conservation between the top and bottom points gives the minimum speed required at the BOTTOM: $v_1 = \sqrt{5gr}$ -- five times larger when squared, since it also has to supply enough energy to still be moving at $\sqrt{gr}$ once it's climbed a height of $2r$ to reach the top.

A rigid ROD, unlike a string, can push as well as pull -- so a mass on a rod only needs to just barely reach the top ($v_2=0$ is fine), making its minimum bottom speed a smaller $v_1=\sqrt{4gr}$.$Q$,
 $Q$ஒரு நூலுக்கு (இழுக்க மட்டுமே முடியும், தள்ள முடியாது), இழுவிசை எதிர்குறியாக மாற வேண்டிய தருணமே வளையம் தோல்வியடையும் — நூல் வெறுமனே தளர்வடையும். சிக்கலான நிலை உச்சியில் உள்ளது, அங்கு இழுவிசை மிகச் சிறியது.

உச்சியில் உள்ள சமன்பாட்டில் $T_2=0$ எனவைத்தால்: $\dfrac{mv_2^2}{r} = mg \Rightarrow v_2 = \sqrt{gr}$. இது உச்சியில் தேவையான குறைந்தபட்ச வேகம்.

இதை உச்சி மற்றும் அடிப்பகுதி புள்ளிகளுக்கு இடையேயான ஆற்றல் அழிவின்மையுடன் இணைத்தால், அடிப்பகுதியில் தேவையான குறைந்தபட்ச வேகம் கிடைக்கிறது: $v_1 = \sqrt{5gr}$ — வர்க்கமாக்கும்போது ஐந்து மடங்கு பெரியது, ஏனெனில் அது உச்சியை அடைய $2r$ உயரத்தை ஏறியபின்னும் $\sqrt{gr}$ இல் நகர்ந்துகொண்டிருக்க போதுமான ஆற்றலையும் வழங்க வேண்டும்.

ஒரு நூலைப் போலல்லாமல், ஒரு உறுதியான தண்டு இழுக்கவும் தள்ளவும் முடியும் — எனவே தண்டில் உள்ள ஒரு நிறை உச்சியை சரியாக அடைந்தால் போதும் ($v_2=0$ சரி), அதன் குறைந்தபட்ச அடிப்பகுதி வேகத்தை சிறிய $v_1=\sqrt{4gr}$ ஆக ஆக்குகிறது.$Q$,
 null, null, 3),

('eeeeeeee-eeee-eeee-eeee-000000000026', 'cccccccc-cccc-cccc-cccc-000000000004', 'example',
 'The Whirling Bucket, With Numbers',
 $Q$சுழலும் வாளி, எண்களுடன்$Q$,
 $Q$Water in a bucket tied to a rope is whirled in a vertical circle of radius $0.5$ m. Calculate the minimum velocity at the lowest point so the water does not spill ($g=10$ m/s²).

Minimum speed at the top: $v_2 = \sqrt{gr} = \sqrt{10 \times 0.5} = \sqrt{5} \approx 2.24$ m/s.

Minimum speed at the bottom: $v_1 = \sqrt{5gr} = \sqrt{5 \times 10 \times 0.5} = \sqrt{25} = 5$ m/s.

So the bucket must be whirled with at least $5$ m/s at the bottom of the swing -- any slower, and the string goes slack before reaching the top, and the water (and the bucket) would leave the circular path.$Q$,
 $Q$நூலில் கட்டப்பட்ட ஒரு வாளியில் உள்ள தண்ணீர் $0.5$ m ஆரமுள்ள செங்குத்து வட்டத்தில் சுழற்றப்படுகிறது. நீர் கொட்டாமல் இருக்க மிகக் குறைந்த புள்ளியில் தேவையான குறைந்தபட்ச வேகத்தைக் கணக்கிடவும் ($g=10$ m/s²).

உச்சியில் குறைந்தபட்ச வேகம்: $v_2 = \sqrt{gr} = \sqrt{5} \approx 2.24$ m/s.

அடிப்பகுதியில் குறைந்தபட்ச வேகம்: $v_1 = \sqrt{5gr} = \sqrt{25} = 5$ m/s.

எனவே வாளி ஊசலின் அடிப்பகுதியில் குறைந்தபட்சம் $5$ m/s இல் சுழற்றப்பட வேண்டும் — இதை விட மெதுவாக இருந்தால், உச்சியை அடைவதற்கு முன் நூல் தளர்வடையும், தண்ணீரும் (வாளியும்) வட்டப் பாதையை விட்டு வெளியேறும்.$Q$,
 null, null, 4),

('eeeeeeee-eeee-eeee-eeee-000000000027', 'cccccccc-cccc-cccc-cccc-000000000004', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000011', 5),
('eeeeeeee-eeee-eeee-eeee-000000000028', 'cccccccc-cccc-cccc-cccc-000000000004', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000012', 6),
('eeeeeeee-eeee-eeee-eeee-000000000029', 'cccccccc-cccc-cccc-cccc-000000000004', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000013', 7)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 5 -- Power: The Rate of Doing Work
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000014', 'fill_blank',
 $Q$Calculate the energy consumed in electrical units (kWh) when a $100$ W bulb is used for $6$ hours daily for $25$ days.$Q$,
 $Q$$100$ W விளக்கு தினமும் $6$ மணிநேரம் $25$ நாட்களுக்குப் பயன்படுத்தப்பட்டால், மின்சார அலகுகளில் (kWh) நுகரப்படும் ஆற்றலைக் கணக்கிடவும்.$Q$,
 $Q${"blanks": [{"label": "Electrical energy consumed (kWh / units)", "type": "number", "correct": 15}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "நுகரப்பட்ட மின்சார ஆற்றல் (kWh / அலகுகள்)"}]}$Q$::jsonb,
 $Q$Total time of usage: $t = 6 \times 25 = 150$ hours. Electrical energy $= P \times t = 100\text{ W} \times 150\text{ h} = 15{,}000$ watt-hour $= 15$ kilowatt-hour. Since $1$ kWh $=$ $1$ electrical unit, the bulb consumes $15$ units.$Q$,
 $Q$மொத்த பயன்பாட்டு நேரம்: $t = 6 \times 25 = 150$ மணிநேரம். மின்சார ஆற்றல் $= P \times t = 100 \times 150 = 15{,}000$ வாட்-மணிநேரம் $= 15$ கிலோவாட்-மணிநேரம். $1$ kWh $=$ $1$ மின்சார அலகு என்பதால், விளக்கு $15$ அலகுகளை நுகருகிறது.$Q$,
 $Q$Watt-hours need to be divided by $1000$ to become kilowatt-hours -- a very common slip is reporting $15{,}000$ as the final "units" answer instead of $15$.$Q$,
 $Q$வாட்-மணிநேரத்தை கிலோவாட்-மணிநேரமாக்க $1000$ ஆல் வகுக்க வேண்டும் — இறுதி "அலகுகள்" பதிலாக $15$ க்குப் பதிலாக $15{,}000$ ஐ தெரிவிப்பது ஒரு மிகப் பொதுவான தவறு.$Q$,
 'Electrical energy = power × time; electricity bills are always in kWh (a unit of ENERGY), not watts (a unit of power).',
 $Q$மின்சார ஆற்றல் = திறன் × நேரம்; மின்சாரக் கட்டணங்கள் எப்போதும் kWh இல் (ஆற்றலின் அலகு) இருக்கும், வாட் இல் (திறனின் அலகு) அல்ல.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000015', 'fill_blank',
 $Q$A vehicle of mass $1000$ kg is driven with an acceleration $0.5$ m/s² along a straight level road against an external resistive force of $400$ N. Calculate the power delivered by the vehicle's engine when its velocity is $20$ m/s.$Q$,
 $Q$$1000$ kg நிறையுள்ள ஒரு வாகனம், $400$ N வெளிப்புற எதிர்ப்பு விசைக்கு எதிராக, நேர்கோட்டு சமதள சாலையில் $0.5$ m/s² முடுக்கத்துடன் ஓட்டப்படுகிறது. அதன் வேகம் $20$ m/s ஆக இருக்கும்போது வாகனத்தின் இயந்திரத்தால் வழங்கப்படும் திறனைக் கணக்கிடவும்.$Q$,
 $Q${"blanks": [{"label": "Power delivered (W)", "type": "number", "correct": 18000}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "வழங்கப்பட்ட திறன் (W)"}]}$Q$::jsonb,
 $Q$The engine must overcome the resistive force AND supply the force needed for the acceleration: $F_{total} = F_{resistive} + ma = 400 + (1000 \times 0.5) = 900$ N. Power delivered: $P = F_{total} \times v = 900 \times 20 = 18{,}000$ W $= 18$ kW.$Q$,
 $Q$இயந்திரம் எதிர்ப்பு விசையை சமாளிக்க வேண்டும், மேலும் முடுக்கத்திற்குத் தேவையான விசையையும் வழங்க வேண்டும்: $F_{total} = F_{resistive} + ma = 400 + 500 = 900$ N. வழங்கப்படும் திறன்: $P = F_{total} \times v = 900 \times 20 = 18{,}000$ W $= 18$ kW.$Q$,
 $Q$Don't forget the resistive force -- computing power using only $ma$ (ignoring the $400$ N the engine must also overcome) gives a smaller, wrong answer.$Q$,
 $Q$எதிர்ப்பு விசையை மறக்க வேண்டாம் — இயந்திரம் சமாளிக்க வேண்டிய $400$ N ஐப் புறக்கணித்து, $ma$ ஐ மட்டும் பயன்படுத்தி திறனைக் கணக்கிடுவது ஒரு சிறிய, தவறான பதிலைத் தரும்.$Q$,
 'P = F·v -- power is force times velocity, and the relevant force is the TOTAL force the engine supplies, not just the part causing acceleration.',
 $Q$P = F·v — திறன் என்பது விசை பெருக்கல் திசைவேகம், தொடர்புடைய விசை இயந்திரம் வழங்கும் மொத்த விசையே, முடுக்கத்தை ஏற்படுத்தும் பகுதி மட்டும் அல்ல.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000016', 'mcq',
 $Q$The kilowatt-hour (kWh), which appears on every electricity bill, is a unit of ___.$Q$,
 $Q$ஒவ்வொரு மின்சாரக் கட்டணத்திலும் தோன்றும் கிலோவாட்-மணிநேரம் (kWh), ___ இன் அலகு.$Q$,
 $Q${"options": ["energy", "power", "force", "momentum"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["ஆற்றல்", "திறன்", "விசை", "உந்தம்"]}$Q$::jsonb,
 $Q$Despite having "watt" (a power unit) in its name, kWh measures ENERGY: $1$ kWh $=$ ($1000$ W)$\times$($3600$ s) $= 3.6\times10^6$ J. It exists because measuring household electrical energy in plain joules or watt-seconds would produce inconveniently huge numbers.$Q$,
 $Q$அதன் பெயரில் "வாட்" (ஒரு திறன் அலகு) இருந்தாலும், kWh ஆற்றலை அளக்கிறது: $1$ kWh $=$ ($1000$ W)$\times$($3600$ s) $= 3.6\times10^6$ J. வீட்டு மின்சார ஆற்றலை வெறும் ஜூல் அல்லது வாட்-வினாடிகளில் அளந்தால் மிக பெரிய எண்கள் வரும் என்பதால் இது உருவாக்கப்பட்டது.$Q$,
 $Q$This is the single most common unit-confusion in this chapter -- "watt" appearing in the name makes kWh SOUND like a power unit, but the "hour" makes it a power-times-time = energy unit.$Q$,
 $Q$இது இந்த அத்தியாயத்தில் மிகவும் பொதுவான அலகு-குழப்பம் — பெயரில் "வாட்" இருப்பது kWh ஐ ஒரு திறன் அலகு போல "கேட்க" வைக்கிறது, ஆனால் "மணிநேரம்" அதை திறன்-பெருக்கல்-நேரம் = ஆற்றல் அலகாக ஆக்குகிறது.$Q$,
 'kWh = power × time = ENERGY, not power -- watt alone (or kW, MW) is the actual unit of power.',
 $Q$kWh = திறன் × நேரம் = ஆற்றல், திறன் அல்ல — வாட் மட்டும் (அல்லது kW, MW) தான் திறனின் உண்மையான அலகு.$Q$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('eeeeeeee-eeee-eeee-eeee-000000000030', 'cccccccc-cccc-cccc-cccc-000000000005', 'motivation',
 'Same Weight, Same Height, Very Different Effort',
 $Q$ஒரே எடை, ஒரே உயரம், மிகவும் வேறுபட்ட முயற்சி$Q$,
 $Q$A weightlifter hoists a $100$ kg barbell overhead in $1$ second. A slow crane lifts the same $100$ kg to the same height, but takes a full minute.

Both did exactly the same amount of WORK -- the same force, the same displacement. But one clearly did something faster, more intensely, more "powerfully" than the other.

Physics needs a word for that difference. It's called power.$Q$,
 $Q$ஒரு எடை தூக்குபவர் $100$ kg பார்பெல்லை $1$ வினாடியில் தலைக்கு மேல் தூக்குகிறார். ஒரு மெதுவான குரேன் அதே $100$ kg ஐ அதே உயரத்திற்கு தூக்குகிறது, ஆனால் ஒரு முழு நிமிடம் ஆகிறது.

இருவரும் சரியாக ஒரே அளவு வேலையைச் செய்தனர் — ஒரே விசை, ஒரே இடப்பெயர்ச்சி. ஆனால் ஒருவர் தெளிவாக வேகமாக, தீவிரமாக, மற்றவரை விட "சக்தி வாய்ந்ததாக" ஏதோ செய்தார்.

இயற்பியலுக்கு அந்த வேறுபாட்டிற்கு ஒரு வார்த்தை தேவை. அதற்கு திறன் என்று பெயர்.$Q$,
 null, null, 1),

('eeeeeeee-eeee-eeee-eeee-000000000031', 'cccccccc-cccc-cccc-cccc-000000000005', 'explanation',
 'Defining Power',
 $Q$திறனை வரையறுத்தல்$Q$,
 $Q$Power is defined as the rate of doing work, or equivalently, the rate of delivering energy:

- $P = \dfrac{W}{t}$

The average power over a time interval is the total work divided by the total time taken. The instantaneous power is the power delivered at a specific instant, as the time interval shrinks toward zero: $P_{inst} = \dfrac{dW}{dt}$.

Power is a SCALAR quantity, with SI unit the watt (W): $1$ W $= 1$ J/s. Larger units are the kilowatt ($10^3$ W), megawatt ($10^6$ W), and gigawatt ($10^9$ W). An older unit still used for engines and motors is horsepower: $1$ hp $= 746$ W.$Q$,
 $Q$திறன் என்பது வேலை செய்யப்படும் வீதம், அல்லது ஆற்றல் வழங்கப்படும் வீதம் என வரையறுக்கப்படுகிறது:

- $P = \dfrac{W}{t}$

ஒரு கால இடைவெளியில் சராசரி திறன் என்பது மொத்த வேலையை மொத்த நேரத்தால் வகுத்தது. உடனடி திறன் என்பது ஒரு குறிப்பிட்ட தருணத்தில் வழங்கப்படும் திறன், கால இடைவெளி பூஜ்ஜியத்தை நோக்கிக் குறையும்போது: $P_{inst} = \dfrac{dW}{dt}$.

திறன் ஒரு அளவெண் அளவு, SI அலகு வாட் (W): $1$ W $= 1$ J/s. பெரிய அலகுகள் கிலோவாட் ($10^3$ W), மெகாவாட் ($10^6$ W), கிகாவாட் ($10^9$ W). இயந்திரங்கள் மற்றும் மோட்டார்களுக்கு இன்னும் பயன்படுத்தப்படும் ஒரு பழைய அலகு ஹார்ஸ்பவர்: $1$ hp $= 746$ W.$Q$,
 null, null, 2),

('eeeeeeee-eeee-eeee-eeee-000000000032', 'cccccccc-cccc-cccc-cccc-000000000005', 'explanation',
 'Power, Force, and Velocity',
 $Q$திறன், விசை, திசைவேகம்$Q$,
 $Q$Starting from $W = F\cdot dr$ and dividing both sides by $dt$, power can also be written directly in terms of force and velocity:

- $P = F \cdot v$

This is enormously useful: instead of separately tracking work and time, you can compute the power an engine or motor must deliver at any instant just from the force it exerts and how fast it's currently moving.

A quick but important warning: kWh (kilowatt-hour) is a unit of ENERGY, not power, even though "watt" is in its name -- it's literally power multiplied by time ($1$ kWh $= 3.6\times10^6$ J). Electricity bills are metered in kWh precisely because raw joules would be inconveniently large numbers for household consumption.$Q$,
 $Q$$W = F\cdot dr$ இலிருந்து தொடங்கி, இரு பக்கங்களையும் $dt$ ஆல் வகுத்தால், திறனை நேரடியாக விசை மற்றும் திசைவேகத்தின் அடிப்படையிலும் எழுதலாம்:

- $P = F \cdot v$

இது மிகவும் பயனுள்ளது: வேலை மற்றும் நேரத்தை தனித்தனியாகக் கண்காணிப்பதற்குப் பதிலாக, ஒரு இயந்திரம் அல்லது மோட்டார் எந்த தருணத்திலும் வழங்க வேண்டிய திறனை, அது செலுத்தும் விசை மற்றும் அது தற்போது நகரும் வேகத்திலிருந்தே கணக்கிடலாம்.

ஒரு விரைவான ஆனால் முக்கியமான எச்சரிக்கை: kWh (கிலோவாட்-மணிநேரம்) என்பது ஆற்றலின் அலகு, திறனின் அலகு அல்ல, பெயரில் "வாட்" இருந்தாலும் — இது உண்மையில் திறன் பெருக்கல் நேரம் ($1$ kWh $= 3.6\times10^6$ J). வீட்டு நுகர்வுக்கு வெறும் ஜூல்கள் மிக பெரிய எண்களாக இருக்கும் என்பதால்தான் மின்சாரக் கட்டணங்கள் kWh இல் அளக்கப்படுகின்றன.$Q$,
 null, null, 3),

('eeeeeeee-eeee-eeee-eeee-000000000033', 'cccccccc-cccc-cccc-cccc-000000000005', 'example',
 'Two Kinds of Power Problems',
 $Q$இரு வகையான திறன் பிரச்சினைகள்$Q$,
 $Q$Case 1 -- Energy billing: a $75$ W fan is used for $8$ hours daily for one month ($30$ days). Time of usage: $t=8\times30=240$ hours. Electrical energy $=P\times t=75\times240=18{,}000$ watt-hour $=18$ kWh $=18$ electrical units.

Case 2 -- Engine power via $P=F\cdot v$: a vehicle of mass $1250$ kg accelerates at $0.2$ m/s² against a resistive force of $500$ N, moving at $30$ m/s. Total force from the engine: $F_{total}=F_{resistive}+ma=500+(1250\times0.2)=500+250=750$ N. Power delivered: $P=F_{total}\times v=750\times30=22{,}500$ W $=22.5$ kW.

Same underlying idea (rate of energy/work), but two completely different calculation styles depending on what's given.$Q$,
 $Q$நிலை 1 — ஆற்றல் கட்டணம்: $75$ W மின்விசிறி தினமும் $8$ மணிநேரம், ஒரு மாதத்திற்கு ($30$ நாட்கள்) பயன்படுத்தப்படுகிறது. பயன்பாட்டு நேரம்: $t=8\times30=240$ மணிநேரம். மின்சார ஆற்றல் $=P\times t=75\times240=18{,}000$ வாட்-மணிநேரம் $=18$ kWh $=18$ மின்சார அலகுகள்.

நிலை 2 — $P=F\cdot v$ வழியாக இயந்திர திறன்: $1250$ kg நிறையுள்ள ஒரு வாகனம் $500$ N எதிர்ப்பு விசைக்கு எதிராக $0.2$ m/s² இல் முடுக்கமடைகிறது, $30$ m/s இல் நகர்கிறது. இயந்திரத்திலிருந்து மொத்த விசை: $F_{total}=500+(1250\times0.2)=750$ N. வழங்கப்படும் திறன்: $P=750\times30=22{,}500$ W $=22.5$ kW.

ஒரே அடிப்படைக் கருத்து (ஆற்றல்/வேலையின் வீதம்), ஆனால் என்ன கொடுக்கப்பட்டுள்ளது என்பதைப் பொறுத்து முற்றிலும் வேறுபட்ட இரு கணக்கீட்டு பாணிகள்.$Q$,
 null, null, 4),

('eeeeeeee-eeee-eeee-eeee-000000000034', 'cccccccc-cccc-cccc-cccc-000000000005', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000014', 5),
('eeeeeeee-eeee-eeee-eeee-000000000035', 'cccccccc-cccc-cccc-cccc-000000000005', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000015', 6),
('eeeeeeee-eeee-eeee-eeee-000000000036', 'cccccccc-cccc-cccc-cccc-000000000005', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000016', 7)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 6 -- Elastic & Inelastic Collisions
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000017', 'fill_blank',
 $Q$A lighter particle of mass $m$ moving at $15$ m/s collides elastically with an object of mass $2m$ moving in the same direction at $7.5$ m/s (half its speed). Find the final velocities $v_1$ (lighter body) and $v_2$ (heavier body).$Q$,
 $Q$$m$ நிறையுள்ள ஒரு இலேசான துகள் $15$ m/s வேகத்தில், அதே திசையில் $7.5$ m/s வேகத்தில் (பாதி வேகத்தில்) நகரும் $2m$ நிறையுள்ள ஒரு பொருளுடன் மீள் மோதலில் மோதுகிறது. இறுதி வேகங்கள் $v_1$ (இலேசான உடல்) மற்றும் $v_2$ (கனமான உடல்) ஐக் கண்டறியவும்.$Q$,
 $Q${"blanks": [{"label": "v1, final velocity of lighter body (m/s)", "type": "number", "correct": 5}, {"label": "v2, final velocity of heavier body (m/s)", "type": "number", "correct": 12.5}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "v1, இலேசான உடலின் இறுதி வேகம் (m/s)"}, {"label": "v2, கனமான உடலின் இறுதி வேகம் (m/s)"}]}$Q$::jsonb,
 $Q$Using the elastic collision formulas with $m_1=m$, $m_2=2m$, $u_1=15$, $u_2=7.5$: $v_1=\left(\dfrac{m_1-m_2}{m_1+m_2}\right)u_1+\left(\dfrac{2m_2}{m_1+m_2}\right)u_2=\left(\dfrac{-1}{3}\right)(15)+\left(\dfrac{4}{3}\right)(7.5)=-5+10=5$ m/s. $v_2=\left(\dfrac{2m_1}{m_1+m_2}\right)u_1+\left(\dfrac{m_2-m_1}{m_1+m_2}\right)u_2=\left(\dfrac{2}{3}\right)(15)+\left(\dfrac{1}{3}\right)(7.5)=10+2.5=12.5$ m/s. Check: momentum before $=m(15)+2m(7.5)=30m$, after $=m(5)+2m(12.5)=30m$ -- conserved.$Q$,
 $Q$$m_1=m$, $m_2=2m$, $u_1=15$, $u_2=7.5$ மதிப்புகளுடன் மீள் மோதல் சூத்திரங்களைப் பயன்படுத்தி: $v_1=\left(\dfrac{m_1-m_2}{m_1+m_2}\right)u_1+\left(\dfrac{2m_2}{m_1+m_2}\right)u_2=-5+10=5$ m/s. $v_2=\left(\dfrac{2m_1}{m_1+m_2}\right)u_1+\left(\dfrac{m_2-m_1}{m_1+m_2}\right)u_2=10+2.5=12.5$ m/s. சரிபார்ப்பு: மோதலுக்கு முன் உந்தம் $=30m$, மோதலுக்குப் பின் $=30m$ — பாதுகாக்கப்படுகிறது.$Q$,
 $Q$Substituting the WRONG mass or the wrong sign into the formula is the most common slip -- always double check which body is $m_1$ (the one whose velocity you're solving for first) before plugging in.$Q$,
 $Q$சூத்திரத்தில் தவறான நிறை அல்லது தவறான குறியீட்டை பதிலீடு செய்வது மிகவும் பொதுவான தவறு — முதலில் பதிலீடு செய்வதற்கு முன், எந்த உடல் $m_1$ என்பதை எப்போதும் இருமுறை சரிபார்க்கவும்.$Q$,
 'In an elastic collision both momentum AND kinetic energy are conserved -- that gives exactly two equations for exactly two unknown final velocities.',
 $Q$ஒரு மீள் மோதலில் உந்தம் மற்றும் இயக்க ஆற்றல் இரண்டும் பாதுகாக்கப்படுகின்றன — இது சரியாக இரண்டு அறியப்படாத இறுதி வேகங்களுக்கு சரியாக இரண்டு சமன்பாடுகளைத் தருகிறது.$Q$,
 'elastic_collision'
),

('dddddddd-dddd-dddd-dddd-000000000018', 'fill_blank',
 $Q$A bullet of mass $40$ g is fired into a suspended block of mass $360$ g. The block (with the bullet embedded) rises through a height of $0.45$ m. Taking $g=10$ m/s², find the speed of the bullet just before impact.$Q$,
 $Q$$40$ g நிறையுள்ள ஒரு தோட்டா, தொங்கவிடப்பட்ட $360$ g நிறையுள்ள ஒரு தொகுதிக்குள் சுடப்படுகிறது. தொகுதி (தோட்டாவுடன்) $0.45$ m உயரம் வரை உயர்கிறது. $g=10$ m/s² எனக் கொண்டு, மோதலுக்கு முன் தோட்டாவின் வேகத்தைக் கண்டறியவும்.$Q$,
 $Q${"blanks": [{"label": "Bullet's initial speed u1 (m/s)", "type": "number", "correct": 30}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "தோட்டாவின் தொடக்க வேகம் u1 (m/s)"}]}$Q$::jsonb,
 $Q$Step 1 -- find the common velocity right after impact from the rise height, using $v=\sqrt{2gh}=\sqrt{2\times10\times0.45}=\sqrt{9}=3$ m/s. Step 2 -- use momentum conservation for the perfectly inelastic collision: $m_1u_1=(m_1+m_2)v$, so $u_1=\dfrac{(m_1+m_2)v}{m_1}=\dfrac{(0.04+0.36)\times3}{0.04}=\dfrac{0.40\times3}{0.04}=30$ m/s.$Q$,
 $Q$படி 1 — உயரத்திலிருந்து மோதலுக்குப் பின் பொதுவான வேகத்தைக் கண்டறியவும்: $v=\sqrt{2gh}=\sqrt{2\times10\times0.45}=\sqrt{9}=3$ m/s. படி 2 — முழுமையான தனிச்சுருக்க மோதலுக்கு உந்தப் பாதுகாப்பைப் பயன்படுத்தவும்: $m_1u_1=(m_1+m_2)v$, எனவே $u_1=\dfrac{(m_1+m_2)v}{m_1}=\dfrac{0.40\times3}{0.04}=30$ m/s.$Q$,
 $Q$This is a two-stage problem -- first use projectile/energy motion ($v=\sqrt{2gh}$) to find the common velocity, THEN use momentum conservation to work backward to the bullet's original speed. Skipping straight to momentum conservation without finding $v$ first is the usual mistake.$Q$,
 $Q$இது இரண்டு-நிலை சிக்கல் — முதலில் திட்டு/ஆற்றல் இயக்கத்தைப் பயன்படுத்தி ($v=\sqrt{2gh}$) பொதுவான வேகத்தைக் கண்டறியவும், பின்னர் உந்தப் பாதுகாப்பைப் பயன்படுத்தி தோட்டாவின் அசல் வேகத்திற்குப் பின்நோக்கிச் செல்லவும். $v$ ஐ முதலில் கண்டறியாமல் நேரடியாக உந்தப் பாதுகாப்பிற்குச் செல்வது வழக்கமான தவறு.$Q$,
 'In a perfectly inelastic collision, momentum is conserved but kinetic energy is NOT -- most of the bullet''s original KE is lost as heat, sound, and deformation.',
 $Q$முழுமையான தனிச்சுருக்க மோதலில், உந்தம் பாதுகாக்கப்படுகிறது ஆனால் இயக்க ஆற்றல் அல்ல — தோட்டாவின் அசல் இயக்க ஆற்றலில் பெரும்பகுதி வெப்பம், ஒலி, உருமாற்றம் ஆகியவற்றால் இழக்கப்படுகிறது.$Q$,
 'inelastic_collision'
),

('dddddddd-dddd-dddd-dddd-000000000019', 'mcq',
 $Q$In a perfectly inelastic collision between two bodies, which quantity is conserved even though kinetic energy is NOT?$Q$,
 $Q$இரு உடல்களுக்கு இடையேயான முழுமையான தனிச்சுருக்க மோதலில், இயக்க ஆற்றல் பாதுகாக்கப்படாவிட்டாலும் எந்த அளவு பாதுகாக்கப்படுகிறது?$Q$,
 $Q${"options": ["linear momentum", "speed of each body", "total mechanical energy", "coefficient of restitution"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["நேர்கோட்டு உந்தம்", "ஒவ்வொரு உடலின் வேகமும்", "மொத்த இயந்திர ஆற்றல்", "மீள்தன்மைக் குணகம்"]}$Q$::jsonb,
 $Q$Momentum conservation holds for ANY collision (elastic or inelastic) as long as no external force acts -- it comes from Newton's third law alone. Kinetic energy conservation is the EXTRA condition that only elastic collisions satisfy.$Q$,
 $Q$வெளிப்புற விசை செயல்படாத வரை, எந்தவொரு மோதலுக்கும் (மீள் அல்லது தனிச்சுருக்கம்) உந்தப் பாதுகாப்பு பொருந்தும் — இது நியூட்டனின் மூன்றாம் விதியிலிருந்து மட்டுமே வருகிறது. இயக்க ஆற்றல் பாதுகாப்பு என்பது மீள் மோதல்கள் மட்டுமே பூர்த்தி செய்யும் கூடுதல் நிபந்தனையாகும்.$Q$,
 $Q$It's tempting to think "nothing is conserved" once you hear kinetic energy is lost -- but momentum conservation is completely separate and always holds (mass and momentum don't vanish, only some KE converts to other energy forms).$Q$,
 $Q$இயக்க ஆற்றல் இழக்கப்படுகிறது என்று கேட்டதும் "எதுவும் பாதுகாக்கப்படவில்லை" என்று நினைப்பது எளிது — ஆனால் உந்தப் பாதுகாப்பு முற்றிலும் தனியானது, எப்போதும் பொருந்தும் (நிறை மற்றும் உந்தம் மறைந்துவிடாது, சில இயக்க ஆற்றல் மட்டும் மற்ற ஆற்றல் வடிவங்களாக மாறுகிறது).$Q$,
 'Momentum conservation is universal for all collisions; kinetic energy conservation is the special extra property of ONLY elastic collisions.',
 $Q$உந்தப் பாதுகாப்பு அனைத்து மோதல்களுக்கும் உலகளாவியது; இயக்க ஆற்றல் பாதுகாப்பு மீள் மோதல்களுக்கு மட்டுமே சிறப்பு கூடுதல் பண்பு.$Q$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('eeeeeeee-eeee-eeee-eeee-000000000037', 'cccccccc-cccc-cccc-cccc-000000000006', 'motivation',
 'Two Cars Crash -- Two Very Different Outcomes',
 $Q$இரு கார்கள் மோதுகின்றன — இரு மிகவும் வேறுபட்ட விளைவுகள்$Q$,
 $Q$Imagine two identical billiard balls colliding -- they bounce apart cleanly, each carrying away exactly the kinetic energy you'd expect from a perfect elastic exchange.

Now imagine two cars crashing head-on and crumpling into a single tangled mass, screeching to a stop together.

Both events conserve momentum. But only one of them conserves kinetic energy. The difference between these two collision "families" is one of the most useful classification tools in mechanics.$Q$,
 $Q$இரண்டு ஒரே மாதிரியான பில்லியர்ட் பந்துகள் மோதுவதை கற்பனை செய்யுங்கள் — அவை தூய்மையாக பிரிந்து செல்கின்றன, ஒவ்வொன்றும் ஒரு சரியான மீள் பரிமாற்றத்திலிருந்து எதிர்பார்க்கும் இயக்க ஆற்றலை சரியாக எடுத்துச் செல்கின்றன.

இப்போது இரண்டு கார்கள் நேருக்கு நேர் மோதி ஒரு சிக்கலான நிறைவாக சுருங்கி, ஒன்றாக நின்று விடுவதை கற்பனை செய்யுங்கள்.

இரண்டு நிகழ்வுகளும் உந்தத்தைப் பாதுகாக்கின்றன. ஆனால் அவற்றில் ஒன்று மட்டுமே இயக்க ஆற்றலைப் பாதுகாக்கிறது. இந்த இரு மோதல் "குடும்பங்களுக்கும்" இடையேயான வேறுபாடு இயந்திரவியலில் மிகவும் பயனுள்ள வகைப்பாட்டு கருவிகளில் ஒன்றாகும்.$Q$,
 null, null, 1),

('eeeeeeee-eeee-eeee-eeee-000000000038', 'cccccccc-cccc-cccc-cccc-000000000006', 'explanation',
 'Elastic Collisions: Both Momentum and KE Survive',
 $Q$மீள் மோதல்கள்: உந்தமும் இயக்க ஆற்றலும் தப்பிக்கின்றன$Q$,
 $Q$A collision is elastic when BOTH linear momentum and total kinetic energy are conserved. Solving the two conservation equations simultaneously for two bodies (masses $m_1,m_2$, initial velocities $u_1,u_2$, final velocities $v_1,v_2$) gives:

- $v_1=\left(\dfrac{m_1-m_2}{m_1+m_2}\right)u_1+\left(\dfrac{2m_2}{m_1+m_2}\right)u_2$
- $v_2=\left(\dfrac{2m_1}{m_1+m_2}\right)u_1+\left(\dfrac{m_2-m_1}{m_1+m_2}\right)u_2$

Two useful special cases: if the masses are EQUAL ($m_1=m_2$), the velocities simply swap -- $v_1=u_2$, $v_2=u_1$. If a light body hits a much heavier STATIONARY body ($m_2\gg m_1$, $u_2=0$), the heavy body barely moves and the light body bounces straight back.$Q$,
 $Q$உந்தமும் மொத்த இயக்க ஆற்றலும் இரண்டும் பாதுகாக்கப்படும்போது ஒரு மோதல் மீள் மோதலாகும். இரு உடல்களுக்கான (நிறைகள் $m_1,m_2$, தொடக்க வேகங்கள் $u_1,u_2$, இறுதி வேகங்கள் $v_1,v_2$) இரு பாதுகாப்பு சமன்பாடுகளையும் ஒரே நேரத்தில் தீர்த்தால் கிடைப்பது:

- $v_1=\left(\dfrac{m_1-m_2}{m_1+m_2}\right)u_1+\left(\dfrac{2m_2}{m_1+m_2}\right)u_2$
- $v_2=\left(\dfrac{2m_1}{m_1+m_2}\right)u_1+\left(\dfrac{m_2-m_1}{m_1+m_2}\right)u_2$

இரண்டு பயனுள்ள சிறப்பு நிலைகள்: நிறைகள் சமமாக இருந்தால் ($m_1=m_2$), வேகங்கள் வெறுமனே மாறிக்கொள்கின்றன — $v_1=u_2$, $v_2=u_1$. ஒரு இலேசான உடல் மிகவும் கனமான நிலையான உடலை மோதினால் ($m_2\gg m_1$, $u_2=0$), கனமான உடல் அரிதாகவே நகர்கிறது, இலேசான உடல் நேராக திரும்பி வருகிறது.$Q$,
 'elastic_collision', null, 2),

('eeeeeeee-eeee-eeee-eeee-000000000039', 'cccccccc-cccc-cccc-cccc-000000000006', 'explanation',
 'Perfectly Inelastic Collisions: Stuck Together',
 $Q$முழுமையான தனிச்சுருக்க மோதல்கள்: ஒன்றாக ஒட்டிக்கொள்கின்றன$Q$,
 $Q$A perfectly (completely) inelastic collision is one where the two bodies stick together permanently and move off with a single common velocity $v$. Momentum is still conserved (it always is, for any collision with no external force), but kinetic energy is NOT.

- Common velocity: $v=\dfrac{m_1u_1+m_2u_2}{m_1+m_2}$
- Loss of kinetic energy: $\Delta Q = \dfrac{1}{2}\left(\dfrac{m_1m_2}{m_1+m_2}\right)(u_1-u_2)^2$

That lost kinetic energy doesn't vanish -- conservation of ENERGY (not just mechanical energy) still holds overall; the "lost" KE is converted into heat, sound, and permanent deformation of the colliding bodies.$Q$,
 $Q$முழுமையான தனிச்சுருக்க மோதல் என்பது இரு உடல்களும் நிரந்தரமாக ஒட்டிக்கொண்டு ஒரே பொதுவான வேகம் $v$ இல் நகரும் மோதலாகும். உந்தம் இன்னும் பாதுகாக்கப்படுகிறது (வெளிப்புற விசை இல்லாத எந்த மோதலுக்கும் இது எப்போதும் உண்மை), ஆனால் இயக்க ஆற்றல் அல்ல.

- பொதுவான வேகம்: $v=\dfrac{m_1u_1+m_2u_2}{m_1+m_2}$
- இயக்க ஆற்றல் இழப்பு: $\Delta Q = \dfrac{1}{2}\left(\dfrac{m_1m_2}{m_1+m_2}\right)(u_1-u_2)^2$

அந்த இழந்த இயக்க ஆற்றல் மறைந்துவிடாது — ஆற்றல் பாதுகாப்பு (மொத்த இயந்திர ஆற்றல் மட்டுமல்ல) இன்னும் ஒட்டுமொத்தமாக பொருந்துகிறது; "இழந்த" இயக்க ஆற்றல் வெப்பம், ஒலி, மோதும் உடல்களின் நிரந்தர உருமாற்றம் ஆகியவற்றாக மாற்றப்படுகிறது.$Q$,
 'inelastic_collision', null, 3),

('eeeeeeee-eeee-eeee-eeee-000000000040', 'cccccccc-cccc-cccc-cccc-000000000006', 'example',
 'One Elastic, One Inelastic -- Textbook Examples 4.20 & 4.21',
 $Q$பாடநூல் உதாரணங்கள் 4.20 மற்றும் 4.21$Q$,
 $Q$Elastic (Example 4.20): a lighter particle of mass $m$ moving at $10$ m/s collides elastically with an object of mass $2m$ moving in the same direction at half its speed ($5$ m/s). Using the formulas above: $v_1=\dfrac{10}{3}\approx3.33$ m/s, $v_2=\dfrac{25}{3}\approx8.33$ m/s. Both move forward, the heavier body now faster than the lighter one.

Inelastic (Example 4.21): a $50$ g bullet fires into a suspended $450$ g block, which (with the bullet embedded) rises $h=1.8$ m. Common velocity right after impact: $v=\sqrt{2gh}=\sqrt{2\times10\times1.8}=\sqrt{36}=6$ m/s. Working backward via momentum conservation: $u_1=\dfrac{(0.05+0.45)}{0.05}\times6=60$ m/s -- the bullet's original speed.$Q$,
 $Q$மீள் (உதாரணம் 4.20): $m$ நிறையுள்ள ஒரு இலேசான துகள் $10$ m/s இல் நகர்ந்து, அதே திசையில் பாதி வேகத்தில் ($5$ m/s) நகரும் $2m$ நிறையுள்ள ஒரு பொருளுடன் மீள் மோதலில் மோதுகிறது. மேலே உள்ள சூத்திரங்களைப் பயன்படுத்தி: $v_1=\dfrac{10}{3}\approx3.33$ m/s, $v_2=\dfrac{25}{3}\approx8.33$ m/s. இரண்டும் முன்னோக்கி நகர்கின்றன, கனமான உடல் இப்போது இலேசான உடலை விட வேகமாக உள்ளது.

தனிச்சுருக்கம் (உதாரணம் 4.21): $50$ g தோட்டா ஒரு தொங்கவிடப்பட்ட $450$ g தொகுதிக்குள் சுடப்படுகிறது, இது (தோட்டாவுடன்) $h=1.8$ m உயருகிறது. மோதலுக்குப் பின் உடனடியாக பொதுவான வேகம்: $v=\sqrt{2gh}=\sqrt{36}=6$ m/s. உந்தப் பாதுகாப்பு வழியாக பின்நோக்கி வேலை செய்தால்: $u_1=\dfrac{0.50}{0.05}\times6=60$ m/s — தோட்டாவின் அசல் வேகம்.$Q$,
 null, null, 4),

('eeeeeeee-eeee-eeee-eeee-000000000041', 'cccccccc-cccc-cccc-cccc-000000000006', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000017', 5),
('eeeeeeee-eeee-eeee-eeee-000000000042', 'cccccccc-cccc-cccc-cccc-000000000006', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000018', 6),
('eeeeeeee-eeee-eeee-eeee-000000000043', 'cccccccc-cccc-cccc-cccc-000000000006', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000019', 7)
on conflict (id) do nothing;


-- ============================================================
-- LESSON 7 -- Loss of Kinetic Energy & Coefficient of Restitution
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000020', 'fill_blank',
 $Q$Two bodies of mass $2$ kg each collide perfectly inelastically. One is moving at $6$ m/s, the other is at rest. Find the loss of kinetic energy $\Delta Q$ during the collision.$Q$,
 $Q$$2$ kg நிறை கொண்ட இரண்டு உடல்கள் முழுமையான தனிச்சுருக்க மோதலில் மோதுகின்றன. ஒன்று $6$ m/s இல் நகர்கிறது, மற்றொன்று ஓய்வில் உள்ளது. மோதலின்போது இயக்க ஆற்றல் இழப்பு $\Delta Q$ ஐக் கண்டறியவும்.$Q$,
 $Q${"blanks": [{"label": "Loss of kinetic energy (J)", "type": "number", "correct": 18}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "இயக்க ஆற்றல் இழப்பு (J)"}]}$Q$::jsonb,
 $Q$$\Delta Q=\dfrac{1}{2}\left(\dfrac{m_1m_2}{m_1+m_2}\right)(u_1-u_2)^2=\dfrac{1}{2}\left(\dfrac{2\times2}{4}\right)(6-0)^2=\dfrac{1}{2}(1)(36)=18$ J. Cross-check: $v=\dfrac{m_1u_1}{m_1+m_2}=\dfrac{12}{4}=3$ m/s; $KE_i=\dfrac{1}{2}(2)(36)=36$ J, $KE_f=\dfrac{1}{2}(4)(9)=18$ J, so $\Delta Q=36-18=18$ J -- matches.$Q$,
 $Q$$\Delta Q=\dfrac{1}{2}\left(\dfrac{m_1m_2}{m_1+m_2}\right)(u_1-u_2)^2=\dfrac{1}{2}(1)(36)=18$ J. சரிபார்ப்பு: $v=\dfrac{12}{4}=3$ m/s; $KE_i=36$ J, $KE_f=18$ J, $\Delta Q=36-18=18$ J — பொருந்துகிறது.$Q$,
 $Q$Using $u_1-u_2$ directly is correct here since $u_2=0$, but when BOTH bodies are moving, forgetting to take the relative velocity (not just $u_1$ alone) is a common slip.$Q$,
 $Q$$u_2=0$ ஆக இருப்பதால் இங்கு $u_1-u_2$ ஐ நேரடியாகப் பயன்படுத்துவது சரி, ஆனால் இரு உடல்களும் நகரும்போது, தொடர்புடைய வேகத்தை (வெறும் $u_1$ மட்டும் அல்ல) எடுக்க மறப்பது ஒரு பொதுவான தவறு.$Q$,
 'The loss of KE formula gives the SAME answer as computing KE before minus KE after directly -- it''s just a shortcut derived algebraically from the momentum equation.',
 $Q$இயக்க ஆற்றல் இழப்பு சூத்திரம், மோதலுக்கு முன் இயக்க ஆற்றல் கழித்தல் மோதலுக்குப் பின் இயக்க ஆற்றலை நேரடியாகக் கணக்கிடுவதற்கு அதே பதிலைத் தருகிறது — இது உந்த சமன்பாட்டிலிருந்து இயற்கணிதமாகப் பெறப்பட்ட ஒரு குறுக்குவழி மட்டுமே.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000021', 'mcq',
 $Q$A ball dropped on the floor rebounds to exactly the same height from which it was dropped. What is the coefficient of restitution for this bounce?$Q$,
 $Q$தரையில் விடப்பட்ட ஒரு பந்து அது விடப்பட்ட அதே உயரத்திற்கு துள்ளுகிறது. இந்த துள்ளலுக்கான மீள்தன்மைக் குணகம் என்ன?$Q$,
 $Q${"options": ["e = 1", "e = 0", "e = 0.5", "cannot be determined"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["e = 1", "e = 0", "e = 0.5", "தீர்மானிக்க முடியாது"]}$Q$::jsonb,
 $Q$Rebounding to the SAME height means the speed of separation (rebound) equals the speed of approach (impact) -- by $e=\dfrac{\text{speed of separation}}{\text{speed of approach}}$, that ratio is exactly $1$, meaning no kinetic energy was lost. This is the defining property of $e=1$ (perfectly elastic).$Q$,
 $Q$அதே உயரத்திற்குத் திரும்புவது என்பது பிரிதலின் வேகம் (துள்ளல்) நெருங்குதலின் வேகத்திற்கு (தாக்குதல்) சமம் என்று பொருள் — $e=\dfrac{\text{பிரிதலின் வேகம்}}{\text{நெருங்குதலின் வேகம்}}$ படி, அந்த விகிதம் சரியாக $1$, அதாவது இயக்க ஆற்றல் எதுவும் இழக்கப்படவில்லை. இது $e=1$ (முழுமையான மீள்தன்மை) இன் வரையறுக்கும் பண்பு.$Q$,
 $Q$A REAL ball never quite reaches $e=1$ (some energy always lost to sound/heat/deformation) -- this question describes an idealized case to test the definition, not a physically achievable rubber ball.$Q$,
 $Q$ஒரு உண்மையான பந்து ஒருபோதும் $e=1$ ஐ முழுமையாக அடையாது (ஒலி/வெப்பம்/உருமாற்றத்திற்கு எப்போதும் சில ஆற்றல் இழக்கப்படும்) — இந்தக் கேள்வி வரையறையைச் சோதிக்க ஒரு இலட்சியப்படுத்தப்பட்ட நிலையை விவரிக்கிறது, இயற்பியல் ரீதியாக அடையக்கூடிய ஒரு ரப்பர் பந்தை அல்ல.$Q$,
 'e = 1 means perfectly elastic (no KE lost); e = 0 means perfectly plastic/inelastic (bodies stick, maximum KE lost); real collisions fall between, 0 < e < 1.',
 $Q$e = 1 என்பது முழுமையான மீள்தன்மை (இயக்க ஆற்றல் இழப்பு இல்லை); e = 0 என்பது முழுமையான பிளாஸ்டிக்/தனிச்சுருக்கம் (உடல்கள் ஒட்டிக்கொள்கின்றன, அதிகபட்ச இயக்க ஆற்றல் இழப்பு); உண்மையான மோதல்கள் இடையில் விழுகின்றன, 0 < e < 1.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000022', 'fill_blank',
 $Q$Two bodies of EQUAL mass collide perfectly inelastically -- one moving at $u_1$, the other initially at rest. Show that the ratio $v_1/v_2$ (of the equal-mass bodies' individual final velocities, as derived from momentum conservation and the restitution equation) works out to $\dfrac{1-e}{1+e}$. If $e=0.2$ for this collision, what is $v_1/v_2$ (as a decimal)?$Q$,
 $Q$சம நிறை கொண்ட இரண்டு உடல்கள் முழுமையான தனிச்சுருக்க மோதலில் மோதுகின்றன — ஒன்று $u_1$ இல் நகர்கிறது, மற்றொன்று தொடக்கத்தில் ஓய்வில் உள்ளது. $e=0.2$ எனில், $v_1/v_2$ என்ன (தசம எண்ணாக)?$Q$,
 $Q${"blanks": [{"label": "v1 / v2 (decimal)", "type": "number", "correct": 0.667}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "v1 / v2 (தசம எண்)"}]}$Q$::jsonb,
 $Q$From momentum conservation with equal masses: $u_1=v_1+v_2$. From the restitution definition: $v_2-v_1=e\,u_1$. Solving simultaneously: $v_1=\dfrac{u_1(1-e)}{2}$, $v_2=\dfrac{u_1(1+e)}{2}$, so $\dfrac{v_1}{v_2}=\dfrac{1-e}{1+e}$. With $e=0.2$: $\dfrac{1-0.2}{1+0.2}=\dfrac{0.8}{1.2}\approx0.667$.$Q$,
 $Q$உந்தப் பாதுகாப்பிலிருந்து சம நிறைகளுடன்: $u_1=v_1+v_2$. மீள்தன்மை வரையறையிலிருந்து: $v_2-v_1=e\,u_1$. ஒரே நேரத்தில் தீர்த்தால்: $v_1=\dfrac{u_1(1-e)}{2}$, $v_2=\dfrac{u_1(1+e)}{2}$, எனவே $\dfrac{v_1}{v_2}=\dfrac{1-e}{1+e}$. $e=0.2$ உடன்: $\approx0.667$.$Q$,
 $Q$Notice the answer doesn't depend on $u_1$ at all -- it's a pure ratio determined entirely by $e$. Plugging in a specific $u_1$ value unnecessarily is a common wasted step.$Q$,
 $Q$பதில் $u_1$ ஐ சார்ந்தே இல்லை என்பதைக் கவனிக்கவும் — இது முழுமையாக $e$ ஆல் தீர்மானிக்கப்படும் ஒரு தூய விகிதம். ஒரு குறிப்பிட்ட $u_1$ மதிப்பை தேவையின்றி பதிலீடு செய்வது ஒரு பொதுவான வீணான படி.$Q$,
 'For equal masses with one initially at rest, the post-collision velocity ratio v1/v2 = (1-e)/(1+e) depends ONLY on the coefficient of restitution.',
 $Q$சம நிறைகளுக்கு ஒன்று தொடக்கத்தில் ஓய்வில் இருக்கும்போது, மோதலுக்குப் பிந்தைய வேக விகிதம் v1/v2 = (1-e)/(1+e) மீள்தன்மைக் குணகத்தை மட்டுமே சார்ந்துள்ளது.$Q$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('eeeeeeee-eeee-eeee-eeee-000000000044', 'cccccccc-cccc-cccc-cccc-000000000007', 'motivation',
 'Where Does a Bouncing Ball''s Energy Actually Go?',
 $Q$துள்ளும் பந்தின் ஆற்றல் உண்மையில் எங்கே செல்கிறது?$Q$,
 $Q$Drop a rubber ball and it bounces most of the way back up. Drop a lump of clay and it just... stops, flat on the floor.

Neither ball violated any conservation law. Momentum before hitting the floor plus the floor's (effectively infinite) momentum change still balances out. But clearly SOMETHING different happened to the energy.

Physics has a single number that captures exactly how "bouncy" any collision is -- from a superball (nearly all energy kept) to wet clay (all of it lost). That number is the coefficient of restitution.$Q$,
 $Q$ஒரு ரப்பர் பந்தை விடுங்கள், அது மீண்டும் பெரும்பாலான தூரம் துள்ளும். ஒரு களிமண் துண்டை விடுங்கள், அது வெறும்... நிற்கிறது, தரையில் தட்டையாக.

இரண்டு பந்துகளும் எந்த பாதுகாப்பு விதியையும் மீறவில்லை. தரையைத் தாக்குவதற்கு முன் உந்தம் மற்றும் தரையின் (திறம்பட எல்லையற்ற) உந்த மாற்றம் இன்னும் சமநிலையில் உள்ளன. ஆனால் ஆற்றலுக்கு ஏதோ வித்தியாசமானது நடந்தது என்பது தெளிவாகத் தெரிகிறது.

இயற்பியலில் எந்தவொரு மோதலும் எவ்வளவு "துள்ளக்கூடியது" என்பதை சரியாகக் குறிக்கும் ஒரு எண் உள்ளது — ஒரு சூப்பர்பால் (கிட்டத்தட்ட அனைத்து ஆற்றலும் பாதுகாக்கப்படுகிறது) முதல் ஈரமான களிமண் (அனைத்தும் இழக்கப்படுகிறது) வரை. அந்த எண் மீள்தன்மைக் குணகம்.$Q$,
 null, null, 1),

('eeeeeeee-eeee-eeee-eeee-000000000045', 'cccccccc-cccc-cccc-cccc-000000000007', 'explanation',
 'The Coefficient of Restitution',
 $Q$மீள்தன்மைக் குணகம்$Q$,
 $Q$The coefficient of restitution (e) is the ratio of the velocity of separation (after collision) to the velocity of approach (before collision):

- $e=\dfrac{\text{velocity of separation}}{\text{velocity of approach}}=\dfrac{v_2-v_1}{u_1-u_2}$

Three key values: $e=1$ for a perfectly elastic collision (no KE lost -- the body "bounces back with the same kinetic energy"). $e=0$ for a perfectly plastic/inelastic collision (bodies stick together, separation velocity is zero). Real collisions always fall in between: $0<e<1$. $e$ is dimensionless and depends on the materials involved, not on the masses or speeds.$Q$,
 $Q$மீள்தன்மைக் குணகம் (e) என்பது பிரிதலின் வேகத்தின் (மோதலுக்குப் பின்) நெருங்குதலின் வேகத்திற்கான (மோதலுக்கு முன்) விகிதமாகும்:

- $e=\dfrac{\text{பிரிதலின் வேகம்}}{\text{நெருங்குதலின் வேகம்}}=\dfrac{v_2-v_1}{u_1-u_2}$

மூன்று முக்கிய மதிப்புகள்: $e=1$ முழுமையான மீள் மோதலுக்கு (இயக்க ஆற்றல் இழப்பு இல்லை). $e=0$ முழுமையான பிளாஸ்டிக்/தனிச்சுருக்க மோதலுக்கு (உடல்கள் ஒட்டிக்கொள்கின்றன, பிரிதல் வேகம் பூஜ்ஜியம்). உண்மையான மோதல்கள் எப்போதும் இடையில் விழுகின்றன: $0<e<1$. $e$ அளவெண் அற்றது, மேலும் இது நிறைகள் அல்லது வேகங்களை அல்ல, சம்பந்தப்பட்ட பொருட்களைப் பொறுத்தது.$Q$,
 null, null, 2),

('eeeeeeee-eeee-eeee-eeee-000000000046', 'cccccccc-cccc-cccc-cccc-000000000007', 'explanation',
 'How Much KE Is Actually Lost?',
 $Q$உண்மையில் எவ்வளவு இயக்க ஆற்றல் இழக்கப்படுகிறது?$Q$,
 $Q$For a perfectly inelastic collision specifically, the loss of kinetic energy can be written directly in terms of the masses and the relative (approach) velocity:

- $\Delta Q = \dfrac{1}{2}\left(\dfrac{m_1m_2}{m_1+m_2}\right)(u_1-u_2)^2$

Notice this is ALWAYS positive (a square times positive masses) -- kinetic energy is always lost in a perfectly inelastic collision, never gained. The quantity $\dfrac{m_1m_2}{m_1+m_2}$ is called the "reduced mass" and shows up throughout mechanics wherever two-body relative motion is involved.$Q$,
 $Q$குறிப்பாக ஒரு முழுமையான தனிச்சுருக்க மோதலுக்கு, இயக்க ஆற்றல் இழப்பை நிறைகள் மற்றும் தொடர்புடைய (நெருங்குதல்) வேகத்தின் அடிப்படையில் நேரடியாக எழுதலாம்:

- $\Delta Q = \dfrac{1}{2}\left(\dfrac{m_1m_2}{m_1+m_2}\right)(u_1-u_2)^2$

இது எப்போதும் நேர்மறையானது (ஒரு வர்க்கம் நேர்மறை நிறைகளால் பெருக்கப்படுகிறது) என்பதைக் கவனிக்கவும் — ஒரு முழுமையான தனிச்சுருக்க மோதலில் இயக்க ஆற்றல் எப்போதும் இழக்கப்படுகிறது, ஒருபோதும் பெறப்படாது. $\dfrac{m_1m_2}{m_1+m_2}$ என்ற அளவு "குறைக்கப்பட்ட நிறை" எனப்படும், இரு-உடல் தொடர்பு இயக்கம் சம்பந்தப்பட்ட இயந்திரவியல் முழுவதும் தோன்றுகிறது.$Q$,
 null, null, 3),

('eeeeeeee-eeee-eeee-eeee-000000000047', 'cccccccc-cccc-cccc-cccc-000000000007', 'example',
 'Textbook Example 4.22 -- The Equal-Mass Velocity Ratio',
 $Q$பாடநூல் உதாரணம் 4.22 — சம நிறை வேக விகிதம்$Q$,
 $Q$Show that for two EQUAL masses colliding perfectly inelastically -- wait, more precisely, for a general coefficient of restitution $e$ -- with one initially at rest, the ratio of their final velocities is $\dfrac{v_1}{v_2}=\dfrac{1-e}{1+e}$.

From restitution: $v_2-v_1=e\,u_1$ (since $u_2=0$). From momentum conservation with equal masses $m$: $mu_1=mv_1+mv_2 \Rightarrow u_1=v_1+v_2$. Substituting $u_1=v_1+v_2$ into the restitution equation and solving the pair of linear equations gives $v_1=\dfrac{u_1(1-e)}{2}$ and $v_2=\dfrac{u_1(1+e)}{2}$, so their ratio is exactly $\dfrac{1-e}{1+e}$ -- independent of $u_1$ itself.$Q$,
 $Q$இரு சம நிறைகள் முழுமையான தனிச்சுருக்க மோதலில் மோதுவதற்கு -- இன்னும் துல்லியமாக, ஒரு பொதுவான மீள்தன்மைக் குணகம் $e$ க்கு -- ஒன்று தொடக்கத்தில் ஓய்வில் இருக்கும்போது, அவற்றின் இறுதி வேகங்களின் விகிதம் $\dfrac{v_1}{v_2}=\dfrac{1-e}{1+e}$ என்பதைக் காட்டுங்கள்.

மீள்தன்மையிலிருந்து: $v_2-v_1=e\,u_1$ ($u_2=0$ என்பதால்). சம நிறைகள் $m$ உடன் உந்தப் பாதுகாப்பிலிருந்து: $u_1=v_1+v_2$. இவற்றை ஒன்றாகத் தீர்த்தால்: $v_1=\dfrac{u_1(1-e)}{2}$, $v_2=\dfrac{u_1(1+e)}{2}$, எனவே அவற்றின் விகிதம் சரியாக $\dfrac{1-e}{1+e}$ — $u_1$ ஐ சாராமல்.$Q$,
 null, null, 4),

('eeeeeeee-eeee-eeee-eeee-000000000048', 'cccccccc-cccc-cccc-cccc-000000000007', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000020', 5),
('eeeeeeee-eeee-eeee-eeee-000000000049', 'cccccccc-cccc-cccc-cccc-000000000007', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000021', 6),
('eeeeeeee-eeee-eeee-eeee-000000000050', 'cccccccc-cccc-cccc-cccc-000000000007', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000022', 7)
on conflict (id) do nothing;


-- ============================================================
-- BOOK BACK ONE MARK QUESTIONS -- all 15 real textbook MCQs
-- (Unit 4 Evaluation, Section I), verified against the official
-- answer key: 1c 2d 3a 4a 5b 6a 7c 8b 9b 10b 11c 12c 13c 14d 15b
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000301', 'mcq',
 $Q$A uniform force of $(2\hat i+\hat j)$ N acts on a particle of mass $1$ kg. The particle displaces from position $(3\hat j+\hat k)$ m to $(5\hat i+3\hat j)$ m. The work done by the force on the particle is:$Q$,
 $Q$$(2\hat i+\hat j)$ N என்ற சீரான விசை $1$ kg நிறையுள்ள ஒரு துகள் மீது செயல்படுகிறது. துகள் $(3\hat j+\hat k)$ m இலிருந்து $(5\hat i+3\hat j)$ m க்கு இடம்பெயர்கிறது. துகள் மீது விசையால் செய்யப்படும் வேலை:$Q$,
 $Q${"options": ["9 J", "6 J", "10 J", "12 J"], "correct_index": 2}$Q$::jsonb,
 $Q${"options": ["9 J", "6 J", "10 J", "12 J"]}$Q$::jsonb,
 $Q$Displacement vector: $\vec d=(5\hat i+3\hat j)-(3\hat j+\hat k)=5\hat i+0\hat j-\hat k$. Work $=\vec F\cdot\vec d=(2)(5)+(1)(0)+(0)(-1)=10$ J.$Q$,
 $Q$இடப்பெயர்ச்சி திசையன்: $\vec d=(5\hat i+3\hat j)-(3\hat j+\hat k)=5\hat i+0\hat j-\hat k$. வேலை $=\vec F\cdot\vec d=(2)(5)+(1)(0)+(0)(-1)=10$ J.$Q$,
 $Q$The $\hat k$ component of force is $0$, so it contributes nothing to the dot product regardless of the $\hat k$ displacement -- don't accidentally multiply mismatched components.$Q$,
 $Q$விசையின் $\hat k$ கூறு $0$, எனவே $\hat k$ இடப்பெயர்ச்சி இருந்தாலும் அது புள்ளிப் பெருக்கத்திற்கு எதுவும் பங்களிக்காது — பொருந்தாத கூறுகளை தற்செயலாக பெருக்காதீர்கள்.$Q$,
 'Work done by a constant vector force is the dot product of force and DISPLACEMENT (final minus initial position), not distance travelled.',
 $Q$ஒரு மாறாத திசையன் விசையால் செய்யப்படும் வேலை என்பது விசை மற்றும் இடப்பெயர்ச்சியின் (இறுதி கழித்தல் தொடக்க நிலை) புள்ளிப் பெருக்கல் ஆகும், பயணித்த தூரம் அல்ல.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000302', 'mcq',
 $Q$A ball of mass $1$ kg and another of mass $2$ kg are dropped from a tall building of height $80$ m. After a fall of $40$ m each towards Earth, their respective kinetic energies will be in the ratio of:$Q$,
 $Q$$1$ kg நிறையுள்ள ஒரு பந்தும் $2$ kg நிறையுள்ள மற்றொரு பந்தும் $80$ m உயரமுள்ள கட்டிடத்திலிருந்து விடப்படுகின்றன. ஒவ்வொன்றும் பூமியை நோக்கி $40$ m விழுந்த பிறகு, அவற்றின் இயக்க ஆற்றல்கள் எந்த விகிதத்தில் இருக்கும்?$Q$,
 $Q${"options": ["\\sqrt{2}:1", "1:\\sqrt{2}", "2:1", "1:2"], "correct_index": 3}$Q$::jsonb,
 $Q${"options": ["\\sqrt{2}:1", "1:\\sqrt{2}", "2:1", "1:2"]}$Q$::jsonb,
 $Q$By the work-energy theorem, $KE$ gained after falling the SAME height $h=40$ m equals the loss in PE: $KE=mgh$. Since $g$ and $h$ are identical for both balls, $KE\propto m$. Ratio $=m_1:m_2=1:2$.$Q$,
 $Q$வேலை-இயக்க ஆற்றல் தேற்றத்தின்படி, ஒரே உயரம் $h=40$ m விழுந்த பிறகு பெறப்படும் $KE$ இழந்த $PE$ க்குச் சமம்: $KE=mgh$. $g$, $h$ இரண்டும் இரு பந்துகளுக்கும் ஒரே மாதிரி என்பதால், $KE\propto m$. விகிதம் $=m_1:m_2=1:2$.$Q$,
 $Q$It's tempting to think the heavier ball falls faster and so has disproportionately more KE -- but in free fall (no air resistance) BOTH balls have the exact same speed at any given height, so KE is simply proportional to mass.$Q$,
 $Q$கனமான பந்து வேகமாக விழுகிறது, எனவே விகிதாசாரமற்ற அதிக $KE$ கொண்டிருக்கும் என்று நினைப்பது எளிது — ஆனால் சுதந்திர வீழ்ச்சியில் (காற்று எதிர்ப்பு இல்லாமல்) இரு பந்துகளும் எந்த உயரத்திலும் சரியாக ஒரே வேகத்தைக் கொண்டிருக்கும், எனவே $KE$ வெறுமனே நிறைக்கு விகிதாசாரமாகும்.$Q$,
 'In free fall, all objects (regardless of mass) have identical speed at a given height -- so KE ratio after an equal fall equals the mass ratio.',
 $Q$சுதந்திர வீழ்ச்சியில், அனைத்து பொருட்களும் (நிறையைப் பொருட்படுத்தாமல்) ஒரு குறிப்பிட்ட உயரத்தில் ஒரே வேகத்தைக் கொண்டிருக்கும் — எனவே சம வீழ்ச்சிக்குப் பின் $KE$ விகிதம் நிறை விகிதத்திற்குச் சமம்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000303', 'mcq',
 $Q$A body of mass $1$ kg is thrown upwards with a velocity $20$ m/s. It momentarily comes to rest after attaining a height of $18$ m. How much energy is lost due to air friction? (Take $g=10$ m/s²)$Q$,
 $Q$$1$ kg நிறையுள்ள ஒரு உடல் $20$ m/s வேகத்தில் மேலே எறியப்படுகிறது. அது $18$ m உயரத்தை அடைந்த பிறகு தற்காலிகமாக ஓய்வு நிலைக்கு வருகிறது. காற்று உராய்வால் எவ்வளவு ஆற்றல் இழக்கப்படுகிறது? ($g=10$ m/s² எனக் கொள்க)$Q$,
 $Q${"options": ["20 J", "30 J", "40 J", "10 J"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["20 J", "30 J", "40 J", "10 J"]}$Q$::jsonb,
 $Q$Initial KE $=\dfrac{1}{2}(1)(20)^2=200$ J. Without friction it should reach $h=\dfrac{u^2}{2g}=\dfrac{400}{20}=20$ m, so all $200$ J would convert to PE at $20$ m. Instead it only reaches $18$ m, meaning final PE at the actual stopping point $=mgh=1\times10\times18=180$ J. Energy lost to friction $=200-180=20$ J.$Q$,
 $Q$தொடக்க $KE=\dfrac{1}{2}(1)(20)^2=200$ J. உராய்வு இல்லாமல் $h=\dfrac{u^2}{2g}=20$ m அடைய வேண்டும், எனவே $200$ J முழுவதும் $20$ m இல் $PE$ ஆக மாற வேண்டும். மாறாக அது $18$ m மட்டுமே அடைகிறது, அதாவது உண்மையான நிறுத்தப் புள்ளியில் இறுதி $PE=mgh=1\times10\times18=180$ J. உராய்வால் இழக்கப்பட்ட ஆற்றல் $=200-180=20$ J.$Q$,
 $Q$Don't compute the "ideal" height first and then get confused -- the energy lost is simply (initial KE) minus (actual final PE at the height it DID reach), not some comparison of heights.$Q$,
 $Q$முதலில் "இலட்சிய" உயரத்தைக் கணக்கிட்டு குழப்பமடைய வேண்டாம் — இழந்த ஆற்றல் என்பது வெறுமனே (தொடக்க $KE$) கழித்தல் (அது உண்மையில் அடைந்த உயரத்தில் இறுதி $PE$), உயரங்களின் ஒப்பீடு அல்ல.$Q$,
 'When air resistance (a non-conservative force) acts, mechanical energy is not conserved -- the "missing" energy equals initial KE minus actual final PE.',
 $Q$காற்று எதிர்ப்பு (ஒரு பாதுகாப்பற்ற விசை) செயல்படும்போது, இயந்திர ஆற்றல் பாதுகாக்கப்படாது — "காணாமல் போன" ஆற்றல் தொடக்க $KE$ கழித்தல் உண்மையான இறுதி $PE$ க்குச் சமம்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000304', 'mcq',
 $Q$An engine pumps water continuously through a hose. Water leaves the hose with a velocity $v$, and $m$ is the mass per unit length of the water jet. What is the rate at which kinetic energy is imparted to the water?$Q$,
 $Q$ஒரு இயந்திரம் ஒரு குழாய் வழியாக தொடர்ந்து நீரை இறைக்கிறது. நீர் $v$ வேகத்தில் குழாயை விட்டு வெளியேறுகிறது, $m$ என்பது நீர் நீரோட்டத்தின் ஒரு அலகு நீளத்திற்கான நிறை. நீருக்கு இயக்க ஆற்றல் வழங்கப்படும் வீதம் என்ன?$Q$,
 $Q${"options": ["\\frac{1}{2}mv^3", "mv^3", "\\frac{3}{2}mv^2", "\\frac{5}{2}mv^2"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["\\frac{1}{2}mv^3", "mv^3", "\\frac{3}{2}mv^2", "\\frac{5}{2}mv^2"]}$Q$::jsonb,
 $Q$Mass flow rate (mass leaving per second) $=\dfrac{dM}{dt}=mv$ (mass per unit length times length leaving per second). Rate of KE imparted $=\dfrac{d}{dt}\left(\dfrac{1}{2}\left(\dfrac{dM}{dt}\right)v^2\right)$, treating it per-second: $=\dfrac{1}{2}(mv)v^2=\dfrac{1}{2}mv^3$.$Q$,
 $Q$நிறை பாய்ச்சல் வீதம் (வினாடிக்கு வெளியேறும் நிறை) $=\dfrac{dM}{dt}=mv$ (அலகு நீளத்திற்கான நிறை பெருக்கல் வினாடிக்கு வெளியேறும் நீளம்). $KE$ வழங்கப்படும் வீதம் $=\dfrac{1}{2}(mv)v^2=\dfrac{1}{2}mv^3$.$Q$,
 $Q$It's easy to forget that "$m$" here is mass PER UNIT LENGTH, not the total mass -- you must first convert it to a mass flow rate ($mv$) before applying the KE formula.$Q$,
 $Q$இங்கு "$m$" என்பது ஒரு அலகு நீளத்திற்கான நிறை, மொத்த நிறை அல்ல என்பதை மறப்பது எளிது — $KE$ சூத்திரத்தைப் பயன்படுத்துவதற்கு முன் அதை முதலில் நிறை பாய்ச்சல் வீதமாக ($mv$) மாற்ற வேண்டும்.$Q$,
 'For a continuous mass flow, rate of KE delivered = (1/2) × (mass flow rate) × v² -- one extra power of v compared to a single object''s KE.',
 $Q$தொடர்ச்சியான நிறை ஓட்டத்திற்கு, வழங்கப்படும் $KE$ வீதம் = (1/2) × (நிறை ஓட்ட வீதம்) × v² — ஒற்றை பொருளின் $KE$ உடன் ஒப்பிடும்போது ஒரு கூடுதல் $v$ அடுக்கு.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000305', 'mcq',
 $Q$A body of mass $4m$ is lying in the xy-plane at rest. It suddenly explodes into three pieces. Two pieces, each of mass $m$, move perpendicular to each other with equal speed $v$. The total kinetic energy generated due to the explosion is:$Q$,
 $Q$$4m$ நிறையுள்ள ஒரு உடல் xy-தளத்தில் ஓய்வில் உள்ளது. அது திடீரென மூன்று துண்டுகளாக வெடிக்கிறது. ஒவ்வொன்றும் $m$ நிறையுள்ள இரு துண்டுகள், சம வேகம் $v$ இல் ஒன்றுக்கொன்று செங்குத்தாக நகர்கின்றன. வெடிப்பால் உருவாகும் மொத்த இயக்க ஆற்றல்:$Q$,
 $Q${"options": ["mv^2", "\\frac{3}{2}mv^2", "2mv^2", "4mv^2"], "correct_index": 1}$Q$::jsonb,
 $Q${"options": ["mv^2", "\\frac{3}{2}mv^2", "2mv^2", "4mv^2"]}$Q$::jsonb,
 $Q$Momentum conservation (initially zero): the third piece (mass $2m$) must carry momentum $-(\,m\vec v_x+m\vec v_y\,)$, magnitude $mv\sqrt2$, so its speed is $\dfrac{mv\sqrt2}{2m}=\dfrac{v}{\sqrt2}$. $KE_3=\dfrac{1}{2}(2m)\left(\dfrac{v}{\sqrt2}\right)^2=\dfrac{1}{2}mv^2$. Total $KE=\dfrac{1}{2}mv^2+\dfrac{1}{2}mv^2+\dfrac{1}{2}mv^2=\dfrac{3}{2}mv^2$.$Q$,
 $Q$உந்தப் பாதுகாப்பு (தொடக்கத்தில் பூஜ்ஜியம்): மூன்றாவது துண்டு (நிறை $2m$) $-(\,m\vec v_x+m\vec v_y\,)$ உந்தத்தை சுமக்க வேண்டும், அளவு $mv\sqrt2$, எனவே அதன் வேகம் $\dfrac{v}{\sqrt2}$. $KE_3=\dfrac{1}{2}mv^2$. மொத்த $KE=\dfrac{3}{2}mv^2$.$Q$,
 $Q$Forgetting the third (unnamed) piece entirely, or assuming it's at rest, is the most common error -- momentum conservation FORCES it to move, and its KE must be included in the total.$Q$,
 $Q$மூன்றாவது (பெயரிடப்படாத) துண்டை முற்றிலும் மறப்பது, அல்லது அது ஓய்வில் உள்ளது என்று கருதுவது மிகவும் பொதுவான தவறு — உந்தப் பாதுகாப்பு அதை நகர வைக்கிறது, அதன் $KE$ ஐ மொத்தத்தில் சேர்க்க வேண்டும்.$Q$,
 'Momentum conservation applies component-wise (x and y separately) even during an explosion -- the initial momentum (zero here) must equal the vector sum of all resulting pieces'' momenta.',
 $Q$உந்தப் பாதுகாப்பு ஒரு வெடிப்பின்போதும் கூறு வாரியாக (x மற்றும் y தனித்தனியாக) பொருந்தும் — தொடக்க உந்தம் (இங்கு பூஜ்ஜியம்) அனைத்து விளைவு துண்டுகளின் உந்தங்களின் திசையன் கூட்டுத்தொகைக்குச் சமமாக இருக்க வேண்டும்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000306', 'mcq',
 $Q$The potential energy of a system increases if work is done:$Q$,
 $Q$ஒரு அமைப்பின் நிலை ஆற்றல் அதிகரிக்கிறது, வேலை செய்யப்பட்டால்:$Q$,
 $Q${"options": ["by the system against a conservative force", "by the system against a non-conservative force", "upon the system by a conservative force", "upon the system by a non-conservative force"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["பாதுகாப்பு விசைக்கு எதிராக அமைப்பால்", "பாதுகாப்பற்ற விசைக்கு எதிராக அமைப்பால்", "பாதுகாப்பு விசையால் அமைப்பின் மீது", "பாதுகாப்பற்ற விசையால் அமைப்பின் மீது"]}$Q$::jsonb,
 $Q$Potential energy is only defined for CONSERVATIVE forces. When the system does work AGAINST a conservative force (e.g. lifting a mass against gravity), that work is "stored" and PE increases. Work against a non-conservative force (like friction) is simply dissipated as heat, not stored as PE.$Q$,
 $Q$நிலை ஆற்றல் பாதுகாப்பு விசைகளுக்கு மட்டுமே வரையறுக்கப்படுகிறது. அமைப்பு ஒரு பாதுகாப்பு விசைக்கு எதிராக வேலை செய்யும்போது (எ.கா. ஈர்ப்புக்கு எதிராக நிறையைத் தூக்குதல்), அந்த வேலை "சேமிக்கப்படுகிறது", $PE$ அதிகரிக்கிறது. பாதுகாப்பற்ற விசைக்கு எதிரான வேலை (உராய்வு போன்றவை) வெறுமனே வெப்பமாக சிதறடிக்கப்படுகிறது, $PE$ ஆக சேமிக்கப்படாது.$Q$,
 $Q$"Work done upon the system" (options c/d) changes the system's KINETIC energy, not potential energy -- PE specifically tracks work the system itself does against a restoring conservative force.$Q$,
 $Q$"அமைப்பின் மீது செய்யப்பட்ட வேலை" (விருப்பங்கள் c/d) அமைப்பின் இயக்க ஆற்றலை மாற்றுகிறது, நிலை ஆற்றலை அல்ல — $PE$ குறிப்பாக அமைப்பே ஒரு மீட்சி பாதுகாப்பு விசைக்கு எதிராகச் செய்யும் வேலையைக் கண்காணிக்கிறது.$Q$,
 'PE exists only for conservative forces; it increases specifically when the system does work AGAINST that conservative force.',
 $Q$$PE$ பாதுகாப்பு விசைகளுக்கு மட்டுமே உள்ளது; அமைப்பு அந்த பாதுகாப்பு விசைக்கு எதிராக வேலை செய்யும்போது இது குறிப்பாக அதிகரிக்கிறது.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000307', 'mcq',
 $Q$What is the minimum velocity with which a body of mass $m$ must enter a vertical loop of radius $R$ (moving on the inside of a track, held by normal force -- equivalent to the string case) so that it can complete the loop?$Q$,
 $Q$$m$ நிறையுள்ள ஒரு உடல், $R$ ஆரமுள்ள ஒரு செங்குத்து வளையத்தை (சரடு நிலைக்குச் சமமான, ஒரு தடத்தின் உள்பக்கத்தில் இயங்கும்) நுழைந்து அதை முழுமையாகச் சுற்ற வேண்டுமெனில், குறைந்தபட்ச வேகம் என்ன?$Q$,
 $Q${"options": ["\\sqrt{2gR}", "\\sqrt{3gR}", "\\sqrt{5gR}", "\\sqrt{gR}"], "correct_index": 2}$Q$::jsonb,
 $Q${"options": ["\\sqrt{2gR}", "\\sqrt{3gR}", "\\sqrt{5gR}", "\\sqrt{gR}"]}$Q$::jsonb,
 $Q$This is exactly the "minimum speed at the bottom" result from Lesson 4 (Motion in a Vertical Circle): the condition at the top ($T_{top}=0 \Rightarrow v_{top}=\sqrt{gR}$) combined with energy conservation between bottom and top gives $v_{bottom}=\sqrt{5gR}$.$Q$,
 $Q$இது பாடம் 4 (செங்குத்து வட்டத்தில் இயக்கம்) இலிருந்து "அடிப்பகுதியில் குறைந்தபட்ச வேகம்" முடிவு சரியாகும்: மேற்பகுதியில் நிபந்தனை ($T_{top}=0 \Rightarrow v_{top}=\sqrt{gR}$) கீழ்ப்பகுதிக்கும் மேற்பகுதிக்கும் இடையேயான ஆற்றல் பாதுகாப்புடன் இணைந்து $v_{bottom}=\sqrt{5gR}$ ஐத் தருகிறது.$Q$,
 $Q$Answer choice (d), $\sqrt{gR}$, is the minimum speed AT THE TOP, not at the point of entering the loop (the bottom) -- read carefully which point the question asks about.$Q$,
 $Q$விடை (d), $\sqrt{gR}$, என்பது மேற்பகுதியில் குறைந்தபட்ச வேகம், வளையத்தில் நுழையும் புள்ளியில் (அடிப்பகுதி) அல்ல — கேள்வி எந்த புள்ளியைப் பற்றி கேட்கிறது என்பதை கவனமாகப் படிக்கவும்.$Q$,
 'The two key vertical-circle speeds are v_top(min) = sqrt(gR) and v_bottom(min) = sqrt(5gR) -- always identify which point a question is asking about.',
 $Q$இரண்டு முக்கிய செங்குத்து-வட்ட வேகங்கள் v_top(min) = sqrt(gR), v_bottom(min) = sqrt(5gR) — ஒரு கேள்வி எந்த புள்ளியைப் பற்றி கேட்கிறது என்பதை எப்போதும் அடையாளம் காணவும்.$Q$,
 'vertical_circle'
),

('dddddddd-dddd-dddd-dddd-000000000308', 'mcq',
 $Q$The work done by a conservative force for a closed path is:$Q$,
 $Q$ஒரு மூடிய பாதைக்கு பாதுகாப்பு விசையால் செய்யப்படும் வேலை:$Q$,
 $Q${"options": ["always negative", "zero", "always positive", "not defined"], "correct_index": 1}$Q$::jsonb,
 $Q${"options": ["எப்போதும் எதிர்மறை", "பூஜ்ஜியம்", "எப்போதும் நேர்மறை", "வரையறுக்கப்படவில்லை"]}$Q$::jsonb,
 $Q$This is the defining property of a conservative force: the work done in going around any closed loop and returning to the starting point is exactly zero, because the force depends only on position (path-independent).$Q$,
 $Q$இது ஒரு பாதுகாப்பு விசையின் வரையறுக்கும் பண்பு: எந்தவொரு மூடிய வளையத்தையும் சுற்றி தொடக்கப் புள்ளிக்குத் திரும்புவதில் செய்யப்படும் வேலை சரியாக பூஜ்ஜியம், ஏனெனில் விசை நிலையை மட்டுமே சார்ந்துள்ளது (பாதையை சாராதது).$Q$,
 null, null,
 'Zero work over any closed path is THE defining test for whether a force is conservative -- this is the same fact used to identify gravity/spring/Coulomb as conservative and friction as not.',
 $Q$எந்தவொரு மூடிய பாதையிலும் பூஜ்ஜிய வேலை என்பது ஒரு விசை பாதுகாப்பானதா என்பதை சோதிக்கும் வரையறுக்கும் சோதனை — ஈர்ப்பு/சுருள்/கூலூம் விசைகளை பாதுகாப்பானதாகவும், உராய்வை பாதுகாப்பற்றதாகவும் அடையாளம் காண இதே உண்மை பயன்படுத்தப்படுகிறது.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000309', 'mcq',
 $Q$If the linear momentum of an object is increased by $0.1\%$ (keeping mass constant), the kinetic energy is increased by approximately:$Q$,
 $Q$ஒரு பொருளின் நேர்கோட்டு உந்தம் $0.1\%$ அதிகரிக்கப்பட்டால் (நிறை மாறாமல்), இயக்க ஆற்றல் தோராயமாக எவ்வளவு அதிகரிக்கிறது?$Q$,
 $Q${"options": ["0.1%", "0.2%", "0.4%", "0.01%"], "correct_index": 1}$Q$::jsonb,
 $Q${"options": ["0.1%", "0.2%", "0.4%", "0.01%"]}$Q$::jsonb,
 $Q$$KE=\dfrac{p^2}{2m}$, so $KE\propto p^2$. For small fractional changes, $\dfrac{\Delta KE}{KE}\approx2\dfrac{\Delta p}{p}$. With $\dfrac{\Delta p}{p}=0.1\%$, $\dfrac{\Delta KE}{KE}\approx0.2\%$.$Q$,
 $Q$$KE=\dfrac{p^2}{2m}$, எனவே $KE\propto p^2$. சிறிய பின்ன மாற்றங்களுக்கு, $\dfrac{\Delta KE}{KE}\approx2\dfrac{\Delta p}{p}$. $\dfrac{\Delta p}{p}=0.1\%$ உடன், $\dfrac{\Delta KE}{KE}\approx0.2\%$.$Q$,
 $Q$Since $KE\propto p^2$ (a SQUARE relationship), the percentage change in KE is roughly DOUBLE the percentage change in momentum, not equal to it.$Q$,
 $Q$$KE\propto p^2$ (ஒரு வர்க்க உறவு) என்பதால், $KE$ இல் சதவீத மாற்றம் உந்தத்தின் சதவீத மாற்றத்தை விட தோராயமாக இரு மடங்கு, அதற்குச் சமமாக அல்ல.$Q$,
 'KE = p²/2m -- because of the square, a small % change in momentum roughly DOUBLES as a % change in kinetic energy.',
 $Q$KE = p²/2m — வர்க்கத்தால், உந்தத்தில் ஒரு சிறிய % மாற்றம் இயக்க ஆற்றலில் % மாற்றமாக தோராயமாக இரு மடங்காகிறது.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000310', 'mcq',
 $Q$If the potential energy of a particle is $U(x)=\dfrac{x^2}{2}$, then the force experienced by the particle is:$Q$,
 $Q$ஒரு துகளின் நிலை ஆற்றல் $U(x)=\dfrac{x^2}{2}$ எனில், துகள் அனுபவிக்கும் விசை:$Q$,
 $Q${"options": ["F = x^2/2", "F = -x", "F = x", "F = -2/x"], "correct_index": 1}$Q$::jsonb,
 $Q${"options": ["F = x^2/2", "F = -x", "F = x", "F = -2/x"]}$Q$::jsonb,
 $Q$Force is the negative gradient of potential energy: $F=-\dfrac{dU}{dx}=-\dfrac{d}{dx}\left(\dfrac{x^2}{2}\right)=-x$. (This describes a simple restoring force, like an ideal spring with $k=1$.)$Q$,
 $Q$விசை நிலை ஆற்றலின் எதிர்மறை சாய்வு: $F=-\dfrac{dU}{dx}=-\dfrac{d}{dx}\left(\dfrac{x^2}{2}\right)=-x$. (இது $k=1$ கொண்ட ஒரு இலட்சிய சுருள் போன்ற ஒரு எளிய மீட்சி விசையை விவரிக்கிறது.)$Q$,
 $Q$Forgetting the MINUS sign in $F=-\dfrac{dU}{dx}$ is the single most common error when converting between potential energy and force.$Q$,
 $Q$நிலை ஆற்றலுக்கும் விசைக்கும் இடையே மாறும்போது $F=-\dfrac{dU}{dx}$ இல் உள்ள கழித்தல் குறியீட்டை மறப்பது மிகவும் பொதுவான தவறு.$Q$,
 'Force = -dU/dx always -- the negative sign means force points in the direction that DECREASES potential energy.',
 $Q$விசை = -dU/dx எப்போதும் — எதிர்மறை குறி என்பது விசை நிலை ஆற்றலைக் குறைக்கும் திசையில் சுட்டிக்காட்டுகிறது.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000311', 'mcq',
 $Q$A wind-powered generator converts wind energy into electric energy. Assume the generator converts a fixed fraction of the wind energy intercepted by its blades into electrical energy. For wind speed $v$, the electrical power output will be proportional to:$Q$,
 $Q$ஒரு காற்று-இயங்கும் மின்னாக்கி காற்று ஆற்றலை மின் ஆற்றலாக மாற்றுகிறது. அதன் இறக்கைகளால் தடுக்கப்படும் காற்று ஆற்றலின் நிலையான பகுதியை மின் ஆற்றலாக மாற்றுகிறது எனக் கொள்க. காற்று வேகம் $v$ க்கு, மின் திறன் வெளியீடு எதற்கு விகிதாசாரமாக இருக்கும்?$Q$,
 $Q${"options": ["v", "v^2", "v^3", "v^4"], "correct_index": 2}$Q$::jsonb,
 $Q${"options": ["v", "v^2", "v^3", "v^4"]}$Q$::jsonb,
 $Q$Mass of air intercepted per second $\propto v$ (more air rushes through the blades per second at higher speed). Kinetic energy per unit mass $\propto v^2$. Power $=\dfrac{\text{energy}}{\text{time}}\propto(\text{mass rate})\times v^2\propto v\times v^2=v^3$.$Q$,
 $Q$வினாடிக்கு தடுக்கப்படும் காற்றின் நிறை $\propto v$ (அதிக வேகத்தில் அதிக காற்று வினாடிக்கு இறக்கைகள் வழியாக செல்கிறது). ஒரு அலகு நிறைக்கான இயக்க ஆற்றல் $\propto v^2$. திறன் $\propto(\text{நிறை வீதம்})\times v^2\propto v\times v^2=v^3$.$Q$,
 $Q$This is the same "continuous mass flow" idea as the hose/jet question -- don't forget the EXTRA factor of $v$ from the increasing mass flow rate, on top of the $v^2$ from kinetic energy per unit mass.$Q$,
 $Q$இது குழாய்/நீரோட்ட கேள்வியின் அதே "தொடர்ச்சியான நிறை ஓட்டம்" கருத்து — ஒரு அலகு நிறைக்கான இயக்க ஆற்றலிலிருந்து வரும் $v^2$ க்கு மேலாக, அதிகரிக்கும் நிறை ஓட்ட வீதத்திலிருந்து வரும் கூடுதல் $v$ காரணியை மறக்க வேண்டாம்.$Q$,
 'Wind/hydro power scales as v³ -- this is why even small increases in wind or water speed give a large boost in generator power output.',
 $Q$காற்று/நீர் திறன் v³ ஆக அளவிடப்படுகிறது — இதனால்தான் காற்று அல்லது நீர் வேகத்தில் சிறிய அதிகரிப்புகள் கூட மின்னாக்கி திறன் வெளியீட்டில் பெரிய அதிகரிப்பைத் தருகின்றன.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000312', 'mcq',
 $Q$Two equal masses $m_1$ and $m_2$ are moving along the same straight line with velocities $5$ m/s and $-9$ m/s respectively. If the collision is elastic, the velocities after collision of $m_1$ and $m_2$ respectively are:$Q$,
 $Q$சம நிறைகள் $m_1$, $m_2$ ஆகியவை ஒரே நேர்கோட்டில் முறையே $5$ m/s, $-9$ m/s வேகங்களில் நகர்கின்றன. மோதல் மீள் மோதலெனில், மோதலுக்குப் பின் $m_1$, $m_2$ இன் வேகங்கள் முறையே:$Q$,
 $Q${"options": ["-4 m/s and 10 m/s", "10 m/s and 0 m/s", "-9 m/s and 5 m/s", "5 m/s and 1 m/s"], "correct_index": 2}$Q$::jsonb,
 $Q${"options": ["-4 m/s மற்றும் 10 m/s", "10 m/s மற்றும் 0 m/s", "-9 m/s மற்றும் 5 m/s", "5 m/s மற்றும் 1 m/s"]}$Q$::jsonb,
 $Q$For an elastic collision between EQUAL masses, the velocities simply swap: $v_1=u_2=-9$ m/s, $v_2=u_1=5$ m/s -- this is the special case from Lesson 6 (equal-mass swap rule).$Q$,
 $Q$சம நிறைகளுக்கு இடையேயான மீள் மோதலுக்கு, வேகங்கள் வெறுமனே மாறிக்கொள்கின்றன: $v_1=u_2=-9$ m/s, $v_2=u_1=5$ m/s — இது பாடம் 6 இலிருந்து (சம நிறை மாற்று விதி) சிறப்பு நிலை.$Q$,
 $Q$Don't try to redo the full elastic-collision algebra here -- recognizing "equal masses" instantly tells you the answer via the swap rule, much faster than plugging into the general formula.$Q$,
 $Q$இங்கு முழு மீள்-மோதல் இயற்கணிதத்தை மீண்டும் செய்ய வேண்டாம் — "சம நிறைகள்" என்பதை அடையாளம் காண்பது மாற்று விதி வழியாக உடனடியாக பதிலைத் தருகிறது, பொதுவான சூத்திரத்தில் பதிலீடு செய்வதை விட மிக வேகமாக.$Q$,
 'Equal-mass elastic collision = velocities simply exchange between the two bodies. Memorize this shortcut.',
 $Q$சம-நிறை மீள் மோதல் = இரு உடல்களுக்கும் இடையே வேகங்கள் வெறுமனே பரிமாறிக்கொள்கின்றன. இந்த குறுக்குவழியை மனப்பாடம் செய்யவும்.$Q$,
 'elastic_collision'
),

('dddddddd-dddd-dddd-dddd-000000000313', 'mcq',
 $Q$A particle is placed at the origin and a force $F=kx$ acts on it (where $k$ is a positive constant). If $U(0)=0$, which best describes the graph of $U(x)$ versus $x$?$Q$,
 $Q$ஒரு துகள் தோற்றத்தில் வைக்கப்பட்டு, $F=kx$ என்ற விசை அதன் மீது செயல்படுகிறது ($k$ ஒரு நேர்மறை மாறிலி). $U(0)=0$ எனில், $U(x)$ க்கு எதிராக $x$ இன் வரைபடத்தை எது சிறப்பாக விவரிக்கிறது?$Q$,
 $Q${"options": ["an upward-opening parabola, symmetric about the origin", "a straight line sloping through the origin", "a downward-opening (inverted) parabola, symmetric about the origin, maximum at x=0", "a horizontal line (U constant everywhere)"], "correct_index": 2}$Q$::jsonb,
 $Q${"options": ["தோற்றத்தைப் பொறுத்து சமச்சீரான, மேல்நோக்கி திறக்கும் பரவளையம்", "தோற்றத்தின் வழியாக சாய்வான நேர்கோடு", "தோற்றத்தைப் பொறுத்து சமச்சீரான, கீழ்நோக்கி திறக்கும் (தலைகீழான) பரவளையம், x=0 இல் அதிகபட்சம்", "கிடைமட்டக் கோடு ($U$ எல்லா இடங்களிலும் மாறாதது)"]}$Q$::jsonb,
 $Q$$U(x)=-\displaystyle\int_0^x F\,dx'=-\displaystyle\int_0^x kx'\,dx'=-\dfrac{kx^2}{2}$. This is a downward-opening (inverted) parabola with its maximum ($U=0$) at the origin -- since $F=+kx$ pushes the particle further from the origin (unlike a restoring spring force $F=-kx$), the origin is an UNSTABLE equilibrium sitting atop a potential "hill".$Q$,
 $Q$$U(x)=-\dfrac{kx^2}{2}$. இது தோற்றத்தில் அதிகபட்சத்தை ($U=0$) கொண்ட கீழ்நோக்கி திறக்கும் (தலைகீழான) பரவளையம் — $F=+kx$ துகளை தோற்றத்திலிருந்து மேலும் தள்ளுவதால் (மீட்சி சுருள் விசை $F=-kx$ போலல்லாமல்), தோற்றம் ஒரு நிலை ஆற்றல் "மலை"யின் மேல் அமர்ந்திருக்கும் ஒரு நிலையற்ற சமநிலையாகும்.$Q$,
 $Q$Notice the sign of $F$ here is $+kx$ (not the usual restoring $-kx$) -- this flips the usual "upward bowl" spring-PE picture into an inverted "hill" shape. Reading the sign of $F$ carefully is essential before sketching $U(x)$.$Q$,
 $Q$இங்கு $F$ இன் குறி $+kx$ (வழக்கமான மீட்சி $-kx$ அல்ல) என்பதைக் கவனிக்கவும் — இது வழக்கமான "மேல்நோக்கி பாத்திரம்" சுருள்-$PE$ படத்தை தலைகீழான "மலை" வடிவமாக மாற்றுகிறது. $U(x)$ ஐ வரைவதற்கு முன் $F$ இன் குறியை கவனமாகப் படிப்பது அவசியம்.$Q$,
 'U(x) = -∫F dx -- the sign of the force directly determines whether the potential energy curve is a "bowl" (stable) or a "hill" (unstable).',
 $Q$U(x) = -∫F dx — விசையின் குறி நிலை ஆற்றல் வளைவு ஒரு "பாத்திரமா" (நிலையான) அல்லது "மலையா" (நிலையற்ற) என்பதை நேரடியாக தீர்மானிக்கிறது.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000314', 'mcq',
 $Q$A particle constrained to move along the x-axis is subjected to a force in the same direction which varies as $F(x)=kx-ax^3$, where $k,a$ are positive constants. For $x\geq0$, which best describes the functional form of the potential energy $U(x)$?$Q$,
 $Q$x-அச்சில் நகர கட்டுப்படுத்தப்பட்ட ஒரு துகள் $F(x)=kx-ax^3$ ($k,a$ நேர்மறை மாறிலிகள்) என மாறும் அதே திசையில் ஒரு விசைக்கு உட்படுத்தப்படுகிறது. $x\geq0$ க்கு, நிலை ஆற்றல் $U(x)$ இன் செயல்பாட்டு வடிவத்தை எது சிறப்பாக விவரிக்கிறது?$Q$,
 $Q${"options": ["an upward-opening parabola, symmetric about the origin", "U decreases monotonically without bound as x increases", "U increases monotonically from the origin", "U dips down to a minimum below zero, then rises steeply for larger x (an asymmetric well)"], "correct_index": 3}$Q$::jsonb,
 $Q${"options": ["தோற்றத்தைப் பொறுத்து சமச்சீரான, மேல்நோக்கி திறக்கும் பரவளையம்", "x அதிகரிக்கும்போது U எல்லையின்றி ஒரே சீராகக் குறைகிறது", "U தோற்றத்திலிருந்து ஒரே சீராக அதிகரிக்கிறது", "U பூஜ்ஜியத்திற்குக் கீழே ஒரு குறைந்தபட்சத்திற்குக் குறைந்து, பின்னர் பெரிய x க்கு கூர்மையாக உயர்கிறது (சமச்சீரற்ற குழி)"]}$Q$::jsonb,
 $Q$$U(x)=-\displaystyle\int_0^x F\,dx'=-\dfrac{kx^2}{2}+\dfrac{ax^4}{4}$. For small $x$, the $-\dfrac{kx^2}{2}$ term dominates (U decreases). For large $x$, the $+\dfrac{ax^4}{4}$ term dominates (U rises steeply). So $U$ starts at $0$, dips to a minimum, then climbs -- an asymmetric potential well, which is exactly the shape needed for a STABLE equilibrium point away from the origin.$Q$,
 $Q$$U(x)=-\dfrac{kx^2}{2}+\dfrac{ax^4}{4}$. சிறிய $x$ க்கு, $-\dfrac{kx^2}{2}$ சொல் ஆதிக்கம் செலுத்துகிறது (U குறைகிறது). பெரிய $x$ க்கு, $+\dfrac{ax^4}{4}$ சொல் ஆதிக்கம் செலுத்துகிறது (U கூர்மையாக உயர்கிறது). எனவே $U$ $0$ இல் தொடங்கி, ஒரு குறைந்தபட்சத்திற்குக் குறைந்து, பின்னர் ஏறுகிறது — தோற்றத்திலிருந்து விலகி ஒரு நிலையான சமநிலைப் புள்ளிக்குத் தேவையான சமச்சீரற்ற நிலை ஆற்றல் குழி.$Q$,
 $Q$Integrate term-by-term and keep both terms' signs straight -- a very common slip is dropping the minus sign that comes from $F=-dU/dx$ on only ONE of the two terms.$Q$,
 $Q$ஒவ்வொரு சொல்லாக ஒருங்கிணைத்து, இரு சொற்களின் குறிகளையும் சரியாக வைத்திருக்கவும் — $F=-dU/dx$ இலிருந்து வரும் கழித்தல் குறியை இரண்டு சொற்களில் ஒன்றில் மட்டும் விட்டுவிடுவது மிகவும் பொதுவான தவறு.$Q$,
 'A force with both a linear restoring term and a higher-order term (kx - ax³) produces an asymmetric potential well -- a common shape in real molecular/atomic potentials.',
 $Q$ஒரு நேரியல் மீட்சிச் சொல் மற்றும் உயர்-வரிசை சொல் (kx - ax³) இரண்டையும் கொண்ட விசை ஒரு சமச்சீரற்ற நிலை ஆற்றல் குழியை உருவாக்குகிறது — உண்மையான மூலக்கூறு/அணு நிலை ஆற்றல்களில் பொதுவான வடிவம்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000315', 'mcq',
 $Q$A spring of force constant $k$ is cut into two pieces such that one piece is double the length of the other. The LONGER piece will have a force constant of:$Q$,
 $Q$$k$ விசை மாறிலி கொண்ட ஒரு சுருள், ஒரு துண்டு மற்றொன்றை விட இரு மடங்கு நீளமாக இருக்கும் வகையில் இரு துண்டுகளாக வெட்டப்படுகிறது. நீளமான துண்டின் விசை மாறிலி:$Q$,
 $Q${"options": ["2k/3", "3k/2", "3k", "6k"], "correct_index": 1}$Q$::jsonb,
 $Q${"options": ["2k/3", "3k/2", "3k", "6k"]}$Q$::jsonb,
 $Q$For a spring, force constant is inversely proportional to natural length: $k_{piece}=\dfrac{kL}{l_{piece}}$. Original length $L$ splits into $\dfrac{L}{3}$ (short) and $\dfrac{2L}{3}$ (long). Long piece: $k_{long}=\dfrac{kL}{2L/3}=\dfrac{3k}{2}$.$Q$,
 $Q$ஒரு சுருளுக்கு, விசை மாறிலி இயல்பான நீளத்திற்கு எதிர்விகிதத்தில் உள்ளது: $k_{piece}=\dfrac{kL}{l_{piece}}$. அசல் நீளம் $L$, $\dfrac{L}{3}$ (குறுகியது) மற்றும் $\dfrac{2L}{3}$ (நீளமானது) ஆக பிரிகிறது. நீளமான துண்டு: $k_{long}=\dfrac{kL}{2L/3}=\dfrac{3k}{2}$.$Q$,
 $Q$It's counterintuitive but true: the LONGER piece of a cut spring has the SMALLER force constant increase (it's "softer" relative to the shorter piece) -- $k_{short}=3k$ is stiffer than $k_{long}=1.5k$.$Q$,
 $Q$இது எதிர்மறையாகத் தோன்றினாலும் உண்மை: வெட்டப்பட்ட சுருளின் நீளமான துண்டு சிறிய விசை மாறிலி அதிகரிப்பைக் கொண்டுள்ளது (குறுகிய துண்டைவிட "மென்மையானது") — $k_{short}=3k$ என்பது $k_{long}=1.5k$ ஐ விட கடினமானது.$Q$,
 'Cutting a spring shorter makes it STIFFER (higher k) -- force constant is inversely proportional to length, opposite to how you might intuitively expect.',
 $Q$ஒரு சுருளை குறைவாக வெட்டுவது அதை கடினமாக்குகிறது (அதிக k) — விசை மாறிலி நீளத்திற்கு எதிர்விகிதத்தில் உள்ளது, நீங்கள் உள்ளுணர்வாக எதிர்பார்க்கக்கூடியதற்கு நேர்மாறாக.$Q$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values
('eeeeeeee-eeee-eeee-eeee-000000000301', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000301', 1),
('eeeeeeee-eeee-eeee-eeee-000000000302', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000302', 2),
('eeeeeeee-eeee-eeee-eeee-000000000303', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000303', 3),
('eeeeeeee-eeee-eeee-eeee-000000000304', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000304', 4),
('eeeeeeee-eeee-eeee-eeee-000000000305', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000305', 5),
('eeeeeeee-eeee-eeee-eeee-000000000306', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000306', 6),
('eeeeeeee-eeee-eeee-eeee-000000000307', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000307', 7),
('eeeeeeee-eeee-eeee-eeee-000000000308', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000308', 8),
('eeeeeeee-eeee-eeee-eeee-000000000309', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000309', 9),
('eeeeeeee-eeee-eeee-eeee-000000000310', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000310', 10),
('eeeeeeee-eeee-eeee-eeee-000000000311', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000311', 11),
('eeeeeeee-eeee-eeee-eeee-000000000312', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000312', 12),
('eeeeeeee-eeee-eeee-eeee-000000000313', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000313', 13),
('eeeeeeee-eeee-eeee-eeee-000000000314', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000314', 14),
('eeeeeeee-eeee-eeee-eeee-000000000315', 'cccccccc-cccc-cccc-cccc-000000000008', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000315', 15)
on conflict (id) do nothing;


-- ============================================================
-- BOOK BACK PROBLEMS -- all 5 real textbook numerical problems
-- (Unit 4 Evaluation, Section IV), each verified by derivation
-- against the official given answers.
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000401', 'fill_blank',
 $Q$Calculate the work done by a force of $30$ N in lifting a load of $2$ kg to a height of $10$ m. (Take $g=10$ m/s².)$Q$,
 $Q$$2$ kg நிறையுள்ள ஒரு சுமையை $10$ m உயரத்திற்கு தூக்க $30$ N விசையால் செய்யப்படும் வேலையைக் கணக்கிடவும். ($g=10$ m/s² எனக் கொள்க.)$Q$,
 $Q${"blanks": [{"label": "Work done (J)", "type": "number", "correct": 300}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "செய்யப்பட்ட வேலை (J)"}]}$Q$::jsonb,
 $Q$Work done by a force is simply $W=F\times d$ (force and displacement are in the same direction here): $W=30\times10=300$ J. The mass ($2$ kg) is not needed at all -- the question gives you the applied FORCE directly, not the weight, so you never need to compute $mg$.$Q$,
 $Q$ஒரு விசையால் செய்யப்படும் வேலை வெறுமனே $W=F\times d$ (விசையும் இடப்பெயர்ச்சியும் இங்கு ஒரே திசையில்): $W=30\times10=300$ J. நிறை ($2$ kg) தேவையே இல்லை — கேள்வி செலுத்தப்படும் விசையை நேரடியாகத் தருகிறது, எடையை அல்ல, எனவே $mg$ ஐ கணக்கிட வேண்டியதே இல்லை.$Q$,
 $Q$The classic trap: seeing a mass and height together and reflexively computing $mgh$ instead of just using the GIVEN force. Here $mg=2\times10=20$ N, which is LESS than the $30$ N actually applied -- if you used $mgh$ you'd get $200$ J, the wrong answer.$Q$,
 $Q$வழக்கமான பொறி: நிறை மற்றும் உயரத்தை ஒன்றாகக் கண்டு தன்னியல்பாக $mgh$ ஐ கணக்கிடுவது, கொடுக்கப்பட்ட விசையைப் பயன்படுத்துவதற்குப் பதிலாக. இங்கு $mg=2\times10=20$ N, இது உண்மையில் செலுத்தப்பட்ட $30$ N ஐ விடக் குறைவு — $mgh$ ஐப் பயன்படுத்தினால் $200$ J கிடைக்கும், தவறான பதில்.$Q$,
 'Always use the force actually stated in the problem for W = Fd -- don''t substitute mg unless the problem explicitly says the force IS gravity.',
 $Q$W = Fd க்கு பிரச்சினையில் உண்மையில் கூறப்பட்ட விசையை எப்போதும் பயன்படுத்தவும் — விசை ஈர்ப்புதான் என்று பிரச்சினை வெளிப்படையாகக் கூறாவிட்டால் mg ஐ பதிலீடு செய்ய வேண்டாம்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000402', 'fill_blank',
 $Q$A ball with a velocity of $5$ m/s strikes at an angle of $60°$ with the vertical on a smooth horizontal plane. If the coefficient of restitution is $0.5$, find the speed of the ball just after impact.$Q$,
 $Q$$5$ m/s வேகம் கொண்ட ஒரு பந்து, ஒரு சமதள கிடைமட்டத் தளத்தில் செங்குத்துடன் $60°$ கோணத்தில் மோதுகிறது. மீள்தன்மைக் குணகம் $0.5$ எனில், தாக்குதலுக்குப் பின் பந்தின் வேகத்தைக் கண்டறியவும்.$Q$,
 $Q${"blanks": [{"label": "Speed after impact (m/s)", "type": "number", "correct": 4.51}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "தாக்குதலுக்குப் பின் வேகம் (m/s)"}]}$Q$::jsonb,
 $Q$Split the velocity relative to the plane: the component PERPENDICULAR to the smooth plane (i.e. vertical, since the plane is horizontal) is $v\cos60°=5\times0.5=2.5$ m/s -- this is the one affected by restitution, becoming $e\times2.5=0.5\times2.5=1.25$ m/s (reversed, bouncing away from the plane). The component PARALLEL to the smooth plane (horizontal, $v\sin60°=5\times0.866=4.33$ m/s) is unaffected since the plane is frictionless. Resultant speed after impact: $\sqrt{4.33^2+1.25^2}=\sqrt{18.75+1.5625}\approx\sqrt{20.31}\approx4.51$ m/s.$Q$,
 $Q$தளத்தைப் பொறுத்து வேகத்தைப் பிரிக்கவும்: சமதளத்திற்கு செங்குத்தான கூறு (செங்குத்து, தளம் கிடைமட்டமாக இருப்பதால்) $v\cos60°=2.5$ m/s — இது மீள்தன்மையால் பாதிக்கப்படுகிறது, $e\times2.5=1.25$ m/s ஆகிறது (தலைகீழாகி, தளத்திலிருந்து விலகி துள்ளுகிறது). தளத்திற்கு இணையான கூறு (கிடைமட்டம், $v\sin60°=4.33$ m/s) பாதிக்கப்படாது, தளம் உராய்வற்றது என்பதால். தாக்குதலுக்குப் பின் விளை வேகம்: $\approx4.51$ m/s.$Q$,
 $Q$A very common mistake is applying the coefficient of restitution to the WHOLE velocity vector, or to the wrong component -- $e$ only scales the component perpendicular to the contact surface; the tangential (parallel) component on a smooth surface is untouched.$Q$,
 $Q$முழு வேக திசையனுக்கும், அல்லது தவறான கூறுக்கும் மீள்தன்மைக் குணகத்தைப் பயன்படுத்துவது மிகவும் பொதுவான தவறு — $e$ தொடர்பு மேற்பரப்புக்கு செங்குத்தான கூறை மட்டுமே அளவிடுகிறது; ஒரு சமதளத்தில் தொடுகோட்டு (இணையான) கூறு தொடப்படாமல் இருக்கும்.$Q$,
 'On a smooth surface, split velocity into normal (affected by e) and tangential (unaffected) components -- treat them completely separately, then recombine at the end.',
 $Q$ஒரு சமதளத்தில், வேகத்தை செங்குத்து (e ஆல் பாதிக்கப்படும்) மற்றும் தொடுகோட்டு (பாதிக்கப்படாத) கூறுகளாகப் பிரிக்கவும் — அவற்றை முற்றிலும் தனித்தனியாகக் கருதி, இறுதியில் மீண்டும் இணைக்கவும்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000403', 'fill_blank',
 $Q$A bob of mass $m$ is attached to one end of a rigid ROD of negligible mass and length $r$; the other end is pivoted freely at a fixed centre O. What initial speed must be given to the bob at the bottom so it can just reach the top of the vertical circle? (Hint: since a rod -- unlike a string -- can also push, the bob only needs $v_{top}=0$, not $v_{top}=\sqrt{gr}$.) Give your answer as a multiple of $\sqrt{gr}$.$Q$,
 $Q$$m$ நிறையுள்ள ஒரு பந்து, புறக்கணிக்கத்தக்க நிறை மற்றும் $r$ நீளமுள்ள ஒரு திடமான தண்டின் ஒரு முனையில் இணைக்கப்பட்டுள்ளது; மறு முனை நிலையான மையம் O இல் சுதந்திரமாக முடுக்கப்பட்டுள்ளது. செங்குத்து வட்டத்தின் மேற்பகுதியை பந்து சரியாக அடைய, அடிப்பகுதியில் என்ன தொடக்க வேகம் கொடுக்கப்பட வேண்டும்? உங்கள் பதிலை $\sqrt{gr}$ இன் பெருக்கமாகக் கொடுக்கவும்.$Q$,
 $Q${"blanks": [{"label": "v_bottom (as a multiple of sqrt(gr))", "type": "number", "correct": 2}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "v_bottom (sqrt(gr) இன் பெருக்கமாக)"}]}$Q$::jsonb,
 $Q$With a rigid rod, the MINIMUM condition at the top is simply $v_{top}=0$ (the rod can push the bob along, unlike a string which would go slack). Energy conservation from bottom to top (height gained $=2r$): $\dfrac{1}{2}mv_{bottom}^2=mg(2r)+\dfrac{1}{2}m(0)^2$, so $v_{bottom}^2=4gr$, giving $v_{bottom}=\sqrt{4gr}=2\sqrt{gr}$. This is LESS than the string case from Lesson 4 ($v_{bottom}=\sqrt{5gr}$), because a rod doesn't need any extra "safety margin" of speed to keep the bob taut at the top.$Q$,
 $Q$திடமான தண்டுடன், மேற்பகுதியில் குறைந்தபட்ச நிபந்தனை வெறுமனே $v_{top}=0$ (தண்டு பந்தை தள்ளிச் செல்ல முடியும், தளர்வடையக்கூடிய சரட்டைப் போலல்லாமல்). அடிப்பகுதியிலிருந்து மேற்பகுதிக்கு ஆற்றல் பாதுகாப்பு (உயர்ந்த உயரம் $=2r$): $\dfrac{1}{2}mv_{bottom}^2=mg(2r)$, எனவே $v_{bottom}=\sqrt{4gr}=2\sqrt{gr}$. இது பாடம் 4 இலிருந்து சரட்டு நிலையை விட ($v_{bottom}=\sqrt{5gr}$) குறைவு, ஏனெனில் ஒரு தண்டுக்கு மேற்பகுதியில் பந்தை இறுக்கமாக வைத்திருக்க கூடுதல் வேக "பாதுகாப்பு விளிம்பு" தேவையில்லை.$Q$,
 $Q$Using the STRING formula ($\sqrt{5gr}$) here instead of the rod formula ($\sqrt{4gr}$) is the single most common mistake -- always check whether the problem says "string"/"cord" (needs tension $\geq0$, so $v_{top}\geq\sqrt{gr}$) or "rod"/"rigid rod" (can push, so only $v_{top}\geq0$).$Q$,
 $Q$இங்கு தண்டு சூத்திரத்திற்கு ($\sqrt{4gr}$) பதிலாக சரட்டு சூத்திரத்தை ($\sqrt{5gr}$) பயன்படுத்துவது மிகவும் பொதுவான தவறு — பிரச்சினை "சரடு/கயிறு" (இழுவிசை $\geq0$ தேவை, எனவே $v_{top}\geq\sqrt{gr}$) அல்லது "தண்டு/திடமான தண்டு" (தள்ள முடியும், எனவே $v_{top}\geq0$ மட்டும்) என்று கூறுகிறதா எனச் சரிபார்க்கவும்.$Q$,
 'Rod vs string changes the minimum-speed answer: rod needs v_bottom = sqrt(4gr); string needs v_bottom = sqrt(5gr). The rod requirement is always the smaller of the two.',
 $Q$தண்டு vs சரடு குறைந்தபட்ச-வேக பதிலை மாற்றுகிறது: தண்டுக்கு v_bottom = sqrt(4gr) தேவை; சரட்டிற்கு v_bottom = sqrt(5gr) தேவை. தண்டு தேவை எப்போதும் இரண்டில் சிறியது.$Q$,
 'vertical_circle'
),

('dddddddd-dddd-dddd-dddd-000000000404', 'fill_blank',
 $Q$Two different unknown masses A and B collide. A is initially at rest, while B has speed $v$. After the collision, B has speed $v/2$ and moves at right angles to its original direction of motion. Find the angle (in degrees) between A's direction of motion after the collision and B's original direction.$Q$,
 $Q$இரு வெவ்வேறு அறியப்படாத நிறைகள் A மற்றும் B மோதுகின்றன. A தொடக்கத்தில் ஓய்வில் உள்ளது, B $v$ வேகத்தில் உள்ளது. மோதலுக்குப் பின், B $v/2$ வேகத்தில், அதன் அசல் திசைக்கு செங்குத்தாக நகர்கிறது. மோதலுக்குப் பின் A இன் இயக்கத் திசைக்கும் B இன் அசல் திசைக்கும் இடையேயான கோணத்தை (பாகைகளில்) கண்டறியவும்.$Q$,
 $Q${"blanks": [{"label": "Angle of A's deflection from B's original direction (degrees)", "type": "number", "correct": 26.5}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "B இன் அசல் திசையிலிருந்து A இன் விலகல் கோணம் (பாகைகள்)"}]}$Q$::jsonb,
 $Q$Set B's original direction as the x-axis. Since B ends up moving entirely along y (perpendicular), its FINAL x-momentum is zero, and its final y-momentum is $m_B(v/2)$. Momentum conservation: x-direction: $m_Bv=m_Av_A\cos\theta$. y-direction: $0=m_Av_A\sin\theta-m_B(v/2)\Rightarrow m_Av_A\sin\theta=m_B(v/2)$. Dividing the y-equation by the x-equation: $\tan\theta=\dfrac{m_B(v/2)}{m_Bv}=\dfrac{1}{2}$ -- notice both masses cancel out completely. So $\theta=\arctan(0.5)\approx26.57°\approx26°33'$.$Q$,
 $Q$B இன் அசல் திசையை x-அச்சாக எடுக்கவும். B முழுவதுமாக y வழியாக (செங்குத்தாக) நகர்வதால், அதன் இறுதி x-உந்தம் பூஜ்ஜியம், இறுதி y-உந்தம் $m_B(v/2)$. உந்தப் பாதுகாப்பு: x: $m_Bv=m_Av_A\cos\theta$. y: $m_Av_A\sin\theta=m_B(v/2)$. y ஐ x ஆல் வகுத்தால்: $\tan\theta=\dfrac{1}{2}$ — இரு நிறைகளும் முழுமையாக ரத்தாகின்றன. எனவே $\theta\approx26.57°\approx26°33'$.$Q$,
 $Q$You don't need to know either mass -- setting up momentum conservation separately in x and y, then DIVIDING the two equations, makes the unknown masses cancel automatically. Trying to solve for $m_A$ or $m_B$ individually is unnecessary extra work.$Q$,
 $Q$இரு நிறைகளையும் தெரிந்துகொள்ள வேண்டியதில்லை — x, y இல் தனித்தனியாக உந்தப் பாதுகாப்பை அமைத்து, இரு சமன்பாடுகளையும் வகுத்தால், அறியப்படாத நிறைகள் தானாகவே ரத்தாகும். $m_A$ அல்லது $m_B$ ஐ தனித்தனியாகத் தீர்ப்பது தேவையற்ற கூடுதல் வேலை.$Q$,
 'When masses are unknown in a 2D collision, set up momentum conservation component-wise and DIVIDE the equations -- the masses often cancel, leaving a pure angle relation.',
 $Q$ஒரு 2D மோதலில் நிறைகள் அறியப்படாதபோது, கூறு வாரியாக உந்தப் பாதுகாப்பை அமைத்து சமன்பாடுகளை வகுக்கவும் — நிறைகள் பெரும்பாலும் ரத்தாகி, ஒரு தூய கோண உறவை மட்டும் விட்டுவிடுகின்றன.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000405', 'fill_blank',
 $Q$A bullet of mass $20$ g strikes a pendulum of mass $5$ kg. The bullet gets embedded into the pendulum, and the combined system's centre of mass rises through a vertical distance of $10$ cm. Taking $g=9.8$ m/s², calculate the bullet's initial speed.$Q$,
 $Q$$20$ g நிறையுள்ள ஒரு தோட்டா $5$ kg நிறையுள்ள ஒரு ஊசலைத் தாக்குகிறது. தோட்டா ஊசலுக்குள் புதைந்துவிடுகிறது, ஒருங்கிணைந்த அமைப்பின் நிறை மையம் $10$ cm செங்குத்து தூரம் உயர்கிறது. $g=9.8$ m/s² எனக் கொண்டு, தோட்டாவின் தொடக்க வேகத்தைக் கணக்கிடவும்.$Q$,
 $Q${"blanks": [{"label": "Bullet's initial speed (m/s)", "type": "number", "correct": 351.4}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "தோட்டாவின் தொடக்க வேகம் (m/s)"}]}$Q$::jsonb,
 $Q$Step 1 -- common velocity right after the bullet embeds, from the rise height: $v=\sqrt{2gh}=\sqrt{2\times9.8\times0.10}=\sqrt{1.96}=1.4$ m/s. Step 2 -- momentum conservation for the perfectly inelastic collision: $m_1u_1=(m_1+m_2)v$, so $u_1=\dfrac{(0.02+5)\times1.4}{0.02}=\dfrac{5.02\times1.4}{0.02}=\dfrac{7.028}{0.02}=351.4$ m/s.$Q$,
 $Q$படி 1 — தோட்டா புதைந்த உடனேயே பொதுவான வேகம், உயரத்திலிருந்து: $v=\sqrt{2gh}=\sqrt{2\times9.8\times0.10}=1.4$ m/s. படி 2 — முழுமையான தனிச்சுருக்க மோதலுக்கு உந்தப் பாதுகாப்பு: $u_1=\dfrac{(0.02+5)\times1.4}{0.02}=351.4$ m/s.$Q$,
 $Q$This problem specifically uses $g=9.8$ m/s² (not the rounded $10$ used elsewhere in this chapter) to match the book's exact published answer -- always check which value of $g$ a specific problem calls for.$Q$,
 $Q$இந்த பிரச்சினை குறிப்பாக $g=9.8$ m/s² ஐப் பயன்படுத்துகிறது (இந்த அத்தியாயத்தில் மற்ற இடங்களில் பயன்படுத்தப்படும் வட்டமான $10$ அல்ல) புத்தகத்தின் சரியான வெளியிடப்பட்ட பதிலுடன் பொருந்த — ஒரு குறிப்பிட்ட பிரச்சினைக்கு எந்த $g$ மதிப்பு தேவை என்பதை எப்போதும் சரிபார்க்கவும்.$Q$,
 'Same two-stage pattern as Example 4.21: use the rise height to find the common velocity, THEN use momentum conservation to work backward to the bullet''s original speed.',
 $Q$உதாரணம் 4.21 இன் அதே இரு-நிலை வடிவம்: பொதுவான வேகத்தைக் கண்டறிய உயர்வு உயரத்தைப் பயன்படுத்தவும், பின்னர் தோட்டாவின் அசல் வேகத்திற்குப் பின்நோக்கிச் செல்ல உந்தப் பாதுகாப்பைப் பயன்படுத்தவும்.$Q$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values
('eeeeeeee-eeee-eeee-eeee-000000000401', 'cccccccc-cccc-cccc-cccc-000000000009', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000401', 1),
('eeeeeeee-eeee-eeee-eeee-000000000402', 'cccccccc-cccc-cccc-cccc-000000000009', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000402', 2),
('eeeeeeee-eeee-eeee-eeee-000000000403', 'cccccccc-cccc-cccc-cccc-000000000009', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000403', 3),
('eeeeeeee-eeee-eeee-eeee-000000000404', 'cccccccc-cccc-cccc-cccc-000000000009', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000404', 4),
('eeeeeeee-eeee-eeee-eeee-000000000405', 'cccccccc-cccc-cccc-cccc-000000000009', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000405', 5)
on conflict (id) do nothing;


-- ============================================================
-- EXTRA ONE MARK QUESTIONS -- supplementary practice, spanning
-- all 7 sub-topics (these are NOT the real book-back questions;
-- shown last, per the site's existing "supplementary" framing).
-- ============================================================
insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('dddddddd-dddd-dddd-dddd-000000000501', 'mcq',
 $Q$A person stands still while holding a heavy bag at arm's length for several minutes. In the physics sense of the word, how much work does the person do on the bag?$Q$,
 $Q$ஒரு நபர் பல நிமிடங்கள் ஒரு கனமான பையை கை நீட்டி வைத்திருக்கும்போது நிலையாக நிற்கிறார். இயற்பியல் அர்த்தத்தில், அந்த நபர் பையின் மீது எவ்வளவு வேலை செய்கிறார்?$Q$,
 $Q${"options": ["Zero", "A large positive amount", "A large negative amount", "It depends on how tired they get"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["பூஜ்ஜியம்", "ஒரு பெரிய நேர்மறை அளவு", "ஒரு பெரிய எதிர்மறை அளவு", "அவர்கள் எவ்வளவு சோர்வடைகிறார்கள் என்பதைப் பொறுத்தது"]}$Q$::jsonb,
 $Q$Work requires DISPLACEMENT: $W=Fd\cos\theta$. Since the bag doesn't move ($d=0$), the work done is exactly zero, no matter how much muscular effort or fatigue is involved. This is the classic gap between the everyday meaning of "work" and the physics definition.$Q$,
 $Q$வேலைக்கு இடப்பெயர்ச்சி தேவை: $W=Fd\cos\theta$. பை நகராது என்பதால் ($d=0$), எவ்வளவு தசை முயற்சி அல்லது சோர்வு இருந்தாலும், செய்யப்படும் வேலை சரியாக பூஜ்ஜியம். இது "வேலை" என்ற அன்றாட அர்த்தத்திற்கும் இயற்பியல் வரையறைக்கும் இடையேயான உன்னதமான இடைவெளி.$Q$,
 null, null,
 'Everyday "work" (effort, tiredness) and physics "work" (force × displacement) are different concepts -- physics work is zero whenever displacement is zero.',
 $Q$அன்றாட "வேலை" (முயற்சி, சோர்வு) மற்றும் இயற்பியல் "வேலை" (விசை × இடப்பெயர்ச்சி) வெவ்வேறு கருத்துகள் — இடப்பெயர்ச்சி பூஜ்ஜியமாக இருக்கும்போதெல்லாம் இயற்பியல் வேலை பூஜ்ஜியம்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000502', 'fill_blank',
 $Q$An object has linear momentum $p=12$ kg·m/s and mass $m=3$ kg. Find its kinetic energy.$Q$,
 $Q$ஒரு பொருளின் நேர்கோட்டு உந்தம் $p=12$ kg·m/s, நிறை $m=3$ kg. அதன் இயக்க ஆற்றலைக் கண்டறியவும்.$Q$,
 $Q${"blanks": [{"label": "Kinetic energy (J)", "type": "number", "correct": 24}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "இயக்க ஆற்றல் (J)"}]}$Q$::jsonb,
 $Q$Using the momentum form of kinetic energy: $KE=\dfrac{p^2}{2m}=\dfrac{12^2}{2\times3}=\dfrac{144}{6}=24$ J. This is useful whenever momentum (not velocity) is given directly.$Q$,
 $Q$இயக்க ஆற்றலின் உந்த வடிவத்தைப் பயன்படுத்தி: $KE=\dfrac{p^2}{2m}=\dfrac{144}{6}=24$ J. உந்தம் (வேகம் அல்ல) நேரடியாகக் கொடுக்கப்படும்போது இது பயனுள்ளது.$Q$,
 null, null,
 'KE = p²/2m is exactly equivalent to (1/2)mv² -- pick whichever form matches what''s given (momentum vs velocity) to skip an extra conversion step.',
 $Q$KE = p²/2m என்பது (1/2)mv² க்கு சமமானது — கொடுக்கப்பட்டதற்குப் பொருந்தும் வடிவத்தைத் தேர்ந்தெடுக்கவும் (உந்தம் vs வேகம்) கூடுதல் மாற்று படியைத் தவிர்க்க.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000503', 'mcq',
 $Q$A spring is stretched by $x$, storing potential energy $U$. If the stretch is doubled to $2x$, what happens to the stored potential energy?$Q$,
 $Q$ஒரு சுருள் $x$ அளவிற்கு நீட்டப்பட்டு, $U$ நிலை ஆற்றலை சேமிக்கிறது. நீட்சி $2x$ ஆக இரட்டிப்பாக்கப்பட்டால், சேமிக்கப்பட்ட நிலை ஆற்றலுக்கு என்ன நடக்கும்?$Q$,
 $Q${"options": ["It doubles (2U)", "It stays the same (U)", "It quadruples (4U)", "It halves (U/2)"], "correct_index": 2}$Q$::jsonb,
 $Q${"options": ["இரட்டிப்பாகிறது (2U)", "அப்படியே இருக்கிறது (U)", "நான்கு மடங்காகிறது (4U)", "பாதியாகிறது (U/2)"]}$Q$::jsonb,
 $Q$Spring PE is $U=\dfrac{1}{2}kx^2$ -- it depends on $x^2$, not $x$. Doubling $x$ means $U_{new}=\dfrac{1}{2}k(2x)^2=\dfrac{1}{2}k(4x^2)=4\times\left(\dfrac{1}{2}kx^2\right)=4U$.$Q$,
 $Q$சுருள் $PE$ $U=\dfrac{1}{2}kx^2$ — இது $x^2$ ஐ சார்ந்துள்ளது, $x$ ஐ அல்ல. $x$ ஐ இரட்டிப்பாக்குவது $U_{new}=4U$ ஐத் தருகிறது.$Q$,
 $Q$Because spring PE depends on the SQUARE of displacement, doubling the stretch quadruples the energy -- assuming a simple doubling (not quadrupling) is the most common mistake here.$Q$,
 $Q$சுருள் $PE$ இடப்பெயர்ச்சியின் வர்க்கத்தைச் சார்ந்திருப்பதால், நீட்சியை இரட்டிப்பாக்குவது ஆற்றலை நான்கு மடங்காக்குகிறது — எளிய இரட்டிப்பை (நான்கு மடங்கு அல்ல) கருதுவது இங்கு மிகவும் பொதுவான தவறு.$Q$,
 'Spring PE scales with x² -- doubling displacement quadruples the stored energy, tripling it multiplies energy by 9, and so on.',
 $Q$சுருள் $PE$ x² உடன் அளவிடப்படுகிறது — இடப்பெயர்ச்சியை இரட்டிப்பாக்குவது சேமிக்கப்பட்ட ஆற்றலை நான்கு மடங்காக்குகிறது, மும்மடங்காக்குவது ஆற்றலை 9 மடங்கு பெருக்குகிறது.$Q$,
 'spring_pe'
),

('dddddddd-dddd-dddd-dddd-000000000504', 'fill_blank',
 $Q$A $5$ kg object is held $3$ m above the ground. Taking the ground as the reference point (zero PE) and $g=10$ m/s², find its gravitational potential energy.$Q$,
 $Q$$5$ kg நிறையுள்ள ஒரு பொருள் தரையிலிருந்து $3$ m உயரத்தில் வைக்கப்பட்டுள்ளது. தரையை குறிப்புப் புள்ளியாக (பூஜ்ஜிய $PE$) எடுத்து, $g=10$ m/s² எனக் கொண்டு, அதன் ஈர்ப்பு நிலை ஆற்றலைக் கண்டறியவும்.$Q$,
 $Q${"blanks": [{"label": "Gravitational PE (J)", "type": "number", "correct": 150}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "ஈர்ப்பு நிலை ஆற்றல் (J)"}]}$Q$::jsonb,
 $Q$$U=mgh=5\times10\times3=150$ J, measured relative to the chosen reference point (the ground).$Q$,
 $Q$$U=mgh=5\times10\times3=150$ J, தேர்ந்தெடுக்கப்பட்ட குறிப்புப் புள்ளியை (தரை) பொறுத்து அளவிடப்படுகிறது.$Q$,
 null, null,
 'Gravitational PE is always measured relative to a chosen reference point -- change the reference and the PE value changes, even though physically nothing about the object has changed.',
 $Q$ஈர்ப்பு $PE$ எப்போதும் தேர்ந்தெடுக்கப்பட்ட குறிப்புப் புள்ளியை பொறுத்து அளவிடப்படுகிறது — குறிப்பை மாற்றினால் $PE$ மதிப்பு மாறும், பொருளைப் பற்றி இயற்பியல் ரீதியாக எதுவும் மாறாவிட்டாலும்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000505', 'mcq',
 $Q$A ball falls freely under gravity (no air resistance). Which force does POSITIVE work on the ball during the fall?$Q$,
 $Q$ஒரு பந்து ஈர்ப்பு விசையின் கீழ் சுதந்திரமாக விழுகிறது (காற்று எதிர்ப்பு இல்லை). வீழ்ச்சியின்போது எந்த விசை பந்தின் மீது நேர்மறை வேலை செய்கிறது?$Q$,
 $Q${"options": ["Gravity", "Air resistance", "Normal force", "None -- free fall does zero work"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["ஈர்ப்பு விசை", "காற்று எதிர்ப்பு", "இயல் விசை", "எதுவுமில்லை — சுதந்திர வீழ்ச்சி பூஜ்ஜிய வேலை செய்கிறது"]}$Q$::jsonb,
 $Q$Gravity acts downward, and the ball's displacement is also downward -- force and displacement point the same way, so $\cos\theta=\cos0°=1$ and the work is positive. This is exactly why the ball speeds up (gains KE) as it falls.$Q$,
 $Q$ஈர்ப்பு விசை கீழ்நோக்கி செயல்படுகிறது, பந்தின் இடப்பெயர்ச்சியும் கீழ்நோக்கி உள்ளது — விசையும் இடப்பெயர்ச்சியும் ஒரே திசையில் உள்ளன, எனவே $\cos\theta=1$, வேலை நேர்மறை. வீழும்போது பந்து வேகமாகிறது (KE பெறுகிறது) என்பதற்கு இதுவே காரணம்.$Q$,
 null, null,
 'Positive work by gravity during a fall = the mechanism by which gravitational PE converts into kinetic energy.',
 $Q$வீழ்ச்சியின்போது ஈர்ப்பு விசையால் நேர்மறை வேலை = ஈர்ப்பு $PE$ இயக்க ஆற்றலாக மாறும் வழிமுறை.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000506', 'fill_blank',
 $Q$A motor does $500$ J of work in $20$ seconds. Find its power output.$Q$,
 $Q$ஒரு மோட்டார் $20$ வினாடிகளில் $500$ J வேலையைச் செய்கிறது. அதன் திறன் வெளியீட்டைக் கண்டறியவும்.$Q$,
 $Q${"blanks": [{"label": "Power (W)", "type": "number", "correct": 25}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "திறன் (W)"}]}$Q$::jsonb,
 $Q$$P=\dfrac{W}{t}=\dfrac{500}{20}=25$ W.$Q$,
 $Q$$P=\dfrac{W}{t}=\dfrac{500}{20}=25$ W.$Q$,
 null, null,
 'The simplest power calculation is always P = W/t when total work and total time are directly given.',
 $Q$மொத்த வேலை மற்றும் மொத்த நேரம் நேரடியாகக் கொடுக்கப்படும்போது எளிமையான திறன் கணக்கீடு எப்போதும் P = W/t.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000507', 'mcq',
 $Q$A very light ball moving fast strikes a much heavier, stationary ball in a one-dimensional elastic collision. What happens right after the collision?$Q$,
 $Q$வேகமாக நகரும் ஒரு மிக இலேசான பந்து, ஒரு பரிமாணத்தில் மீள் மோதலில் மிகவும் கனமான, நிலையான பந்தை மோதுகிறது. மோதலுக்குப் பின் என்ன நடக்கும்?$Q$,
 $Q${"options": ["The light ball bounces almost straight back at nearly its original speed; the heavy ball barely moves", "Both balls move forward together at half the original speed", "The light ball stops completely; the heavy ball moves off at the original speed", "Both balls move forward at the original speed"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["இலேசான பந்து கிட்டத்தட்ட நேராகத் திரும்பி அசல் வேகத்தில் துள்ளுகிறது; கனமான பந்து அரிதாகவே நகர்கிறது", "இரு பந்துகளும் அசல் வேகத்தில் பாதியில் ஒன்றாக முன்னோக்கி நகர்கின்றன", "இலேசான பந்து முழுமையாக நிற்கிறது; கனமான பந்து அசல் வேகத்தில் நகர்கிறது", "இரு பந்துகளும் அசல் வேகத்தில் முன்னோக்கி நகர்கின்றன"]}$Q$::jsonb,
 $Q$This is the $m_2\gg m_1$ limiting case from Lesson 6: $v_1\approx-u_1$ (light ball rebounds at nearly its original speed, reversed) and $v_2\approx0$ (heavy ball barely moves). It's exactly like a ping-pong ball bouncing off a bowling ball.$Q$,
 $Q$இது பாடம் 6 இலிருந்து $m_2\gg m_1$ எல்லை நிலை: $v_1\approx-u_1$ (இலேசான பந்து அசல் வேகத்தில் தலைகீழாகி துள்ளுகிறது), $v_2\approx0$ (கனமான பந்து அரிதாகவே நகர்கிறது). இது ஒரு பந்தாட்டப் பந்து ஒரு போலிங் பந்தில் மோதுவது போன்றது.$Q$,
 $Q$Don't confuse this with the EQUAL-mass swap rule from the earlier lesson question -- the outcome is completely different when the masses are very unequal.$Q$,
 $Q$முந்தைய பாட கேள்வியிலிருந்து சம-நிறை மாற்று விதியுடன் இதைக் குழப்ப வேண்டாம் — நிறைகள் மிகவும் சமமற்றதாக இருக்கும்போது விளைவு முற்றிலும் வேறுபட்டது.$Q$,
 'Very light body hits very heavy stationary body elastically -> light body rebounds nearly reversed, heavy body barely moves. Equal masses -> velocities simply swap. These are two different limiting cases worth memorizing separately.',
 $Q$மிகவும் இலேசான உடல் மிகவும் கனமான நிலையான உடலை மீள் மோதலில் மோதுகிறது -> இலேசான உடல் கிட்டத்தட்ட தலைகீழாகி துள்ளுகிறது, கனமான உடல் அரிதாகவே நகர்கிறது. சம நிறைகள் -> வேகங்கள் வெறுமனே மாறிக்கொள்கின்றன. இவை தனித்தனியாக மனப்பாடம் செய்யத்தக்க இரு வெவ்வேறு எல்லை நிலைகள்.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000508', 'mark_choices',
 $Q$Which of the following statements about the coefficient of restitution $e$ are TRUE? (Select all that apply.)$Q$,
 $Q$மீள்தன்மைக் குணகம் $e$ பற்றிய பின்வரும் கூற்றுகளில் எவை உண்மை? (பொருந்தும் அனைத்தையும் தேர்ந்தெடுக்கவும்.)$Q$,
 $Q${"options": ["e = 1 for a perfectly elastic collision", "e is a dimensionless quantity", "e depends on the masses of the two colliding bodies", "e = 0 means the bodies stick together after collision"], "correct_indices": [0,1,3]}$Q$::jsonb,
 $Q${"options": ["முழுமையான மீள் மோதலுக்கு e = 1", "e ஒரு அளவெண் அற்ற அளவு", "e மோதும் இரு உடல்களின் நிறைகளைச் சார்ந்துள்ளது", "e = 0 என்றால் மோதலுக்குப் பின் உடல்கள் ஒட்டிக்கொள்கின்றன"]}$Q$::jsonb,
 $Q$$e$ depends on the MATERIAL properties of the colliding surfaces (how "bouncy" they are), not on the masses of the bodies -- two balls of any mass made of the same rubber will have the same $e$ against the same floor. The other three statements are all correct definitions/properties.$Q$,
 $Q$$e$ மோதும் மேற்பரப்புகளின் பொருள் பண்புகளைச் சார்ந்துள்ளது (அவை எவ்வளவு "துள்ளக்கூடியவை"), உடல்களின் நிறைகளை அல்ல — எந்த நிறை கொண்ட இரு பந்துகள் ஒரே ரப்பரால் ஆனவையாக இருந்தாலும் ஒரே தரையில் ஒரே $e$ ஐக் கொண்டிருக்கும். மற்ற மூன்று கூற்றுகளும் சரியான வரையறைகள்/பண்புகள்.$Q$,
 $Q$It's a very natural (but incorrect) assumption that a heavier object "hits harder" and so must have a different restitution -- but $e$ is purely a property of what the objects are MADE OF, at the point of contact.$Q$,
 $Q$கனமான பொருள் "கடினமாக மோதுகிறது" எனவே வேறுபட்ட மீள்தன்மையைக் கொண்டிருக்க வேண்டும் என்பது மிகவும் இயல்பான (ஆனால் தவறான) அனுமானம் — ஆனால் $e$ தொடும் புள்ளியில் பொருட்கள் எதனால் ஆனவை என்பதின் தூய பண்பு.$Q$,
 'Coefficient of restitution is a material/surface property, independent of the masses or sizes of the colliding bodies.',
 $Q$மீள்தன்மைக் குணகம் ஒரு பொருள்/மேற்பரப்பு பண்பு, மோதும் உடல்களின் நிறைகள் அல்லது அளவுகளை சாராதது.$Q$,
 null
),

('dddddddd-dddd-dddd-dddd-000000000509', 'fill_blank',
 $Q$A stone tied to a string of length $r=2$ m is whirled in a vertical circle. Taking $g=10$ m/s², find the minimum speed required at the BOTTOM of the circle so the string never goes slack.$Q$,
 $Q$$r=2$ m நீளமுள்ள ஒரு சரட்டில் கட்டப்பட்ட ஒரு கல் ஒரு செங்குத்து வட்டத்தில் சுழற்றப்படுகிறது. $g=10$ m/s² எனக் கொண்டு, சரடு ஒருபோதும் தளர்வடையாமல் இருக்க வட்டத்தின் அடிப்பகுதியில் தேவையான குறைந்தபட்ச வேகத்தைக் கண்டறியவும்.$Q$,
 $Q${"blanks": [{"label": "Minimum speed at bottom (m/s)", "type": "number", "correct": 10}]}$Q$::jsonb,
 $Q${"blanks": [{"label": "அடிப்பகுதியில் குறைந்தபட்ச வேகம் (m/s)"}]}$Q$::jsonb,
 $Q$For a STRING, $v_{bottom,min}=\sqrt{5gr}=\sqrt{5\times10\times2}=\sqrt{100}=10$ m/s.$Q$,
 $Q$சரட்டிற்கு, $v_{bottom,min}=\sqrt{5gr}=\sqrt{5\times10\times2}=\sqrt{100}=10$ m/s.$Q$,
 $Q$Remember this is the STRING formula ($\sqrt{5gr}$), not the rod formula ($\sqrt{4gr}$) -- re-read the problem to confirm it says string/cord before applying this.$Q$,
 $Q$இது சரடு சூத்திரம் ($\sqrt{5gr}$), தண்டு சூத்திரம் ($\sqrt{4gr}$) அல்ல என்பதை நினைவில் கொள்ளுங்கள் — இதைப் பயன்படுத்துவதற்கு முன் அது சரடு/கயிறு என்று கூறுகிறதா என்பதை மீண்டும் படித்து உறுதிப்படுத்தவும்.$Q$,
 'v_bottom(min) = sqrt(5gr) for a string in vertical circular motion -- one of the most frequently tested numerical results in this chapter.',
 $Q$செங்குத்து வட்ட இயக்கத்தில் சரட்டிற்கு v_bottom(min) = sqrt(5gr) — இந்த அத்தியாயத்தில் அடிக்கடி சோதிக்கப்படும் எண் முடிவுகளில் ஒன்று.$Q$,
 'vertical_circle'
),

('dddddddd-dddd-dddd-dddd-000000000510', 'mcq',
 $Q$A simple pendulum swings back and forth. At the extreme (highest) point of its swing, which statement is TRUE?$Q$,
 $Q$ஒரு எளிய ஊசல் முன்னும் பின்னும் ஆடுகிறது. அதன் ஆட்டத்தின் தீவிர (உயர்ந்த) புள்ளியில், எந்த கூற்று உண்மை?$Q$,
 $Q${"options": ["KE = 0 and PE is maximum", "KE is maximum and PE = 0", "Both KE and PE are zero", "Both KE and PE are maximum"], "correct_index": 0}$Q$::jsonb,
 $Q${"options": ["KE = 0, PE அதிகபட்சம்", "KE அதிகபட்சம், PE = 0", "KE மற்றும் PE இரண்டும் பூஜ்ஜியம்", "KE மற்றும் PE இரண்டும் அதிகபட்சம்"]}$Q$::jsonb,
 $Q$At the extreme point, the bob momentarily stops before swinging back (like at the top of a vertical throw), so $KE=0$. Since it's also at its highest point in the swing, $PE=mgh$ is at its maximum there. Total mechanical energy stays constant throughout -- it's just continuously exchanged between KE and PE.$Q$,
 $Q$தீவிர புள்ளியில், பந்து திரும்பி ஆடுவதற்கு முன் தற்காலிகமாக நிற்கிறது (ஒரு செங்குத்து வீச்சின் உச்சியில் போல), எனவே $KE=0$. இது ஆட்டத்தில் அதன் உயர்ந்த புள்ளியிலும் இருப்பதால், $PE=mgh$ அங்கு அதிகபட்சமாக இருக்கும். மொத்த இயந்திர ஆற்றல் முழுவதும் மாறாமல் இருக்கும் — இது தொடர்ந்து KE, PE இடையே பரிமாற்றம் செய்யப்படுகிறது.$Q$,
 null, null,
 'A swinging pendulum is a clean everyday example of conservation of mechanical energy -- KE and PE continuously trade off while their sum stays constant (ignoring air resistance).',
 $Q$ஆடும் ஊசல் இயந்திர ஆற்றல் பாதுகாப்பிற்கு ஒரு தூய்மையான அன்றாட உதாரணம் — KE, PE தொடர்ந்து பரிமாறிக்கொள்கின்றன, அவற்றின் கூட்டுத்தொகை மாறாமல் இருக்கும் (காற்று எதிர்ப்பைப் புறக்கணித்தால்).$Q$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values
('eeeeeeee-eeee-eeee-eeee-000000000501', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000501', 1),
('eeeeeeee-eeee-eeee-eeee-000000000502', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000502', 2),
('eeeeeeee-eeee-eeee-eeee-000000000503', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000503', 3),
('eeeeeeee-eeee-eeee-eeee-000000000504', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000504', 4),
('eeeeeeee-eeee-eeee-eeee-000000000505', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000505', 5),
('eeeeeeee-eeee-eeee-eeee-000000000506', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000506', 6),
('eeeeeeee-eeee-eeee-eeee-000000000507', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000507', 7),
('eeeeeeee-eeee-eeee-eeee-000000000508', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000508', 8),
('eeeeeeee-eeee-eeee-eeee-000000000509', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000509', 9),
('eeeeeeee-eeee-eeee-eeee-000000000510', 'cccccccc-cccc-cccc-cccc-000000000010', 'question', null, null, null, null, null, 'dddddddd-dddd-dddd-dddd-000000000510', 10)
on conflict (id) do nothing;


-- ============================================================
-- FORMULAS TAB -- chapter-wide formula sheet, grouped by the
-- same 7 wep_* group_keys used by the lesson list.
-- ============================================================
insert into physics_formulas (id, chapter_id, group_key, formula_latex, description, description_ta, order_index) values

('ffffffff-ffff-ffff-ffff-000000000001', '22222222-2222-2222-2222-222222220004', 'wep_introduction',
 'W = F d \cos\theta',
 'Work done by a constant force -- force times displacement times the cosine of the angle between them.',
 $Q$ஒரு மாறாத விசையால் செய்யப்படும் வேலை — விசை பெருக்கல் இடப்பெயர்ச்சி பெருக்கல் அவற்றுக்கிடையேயான கோணத்தின் கொசைன்.$Q$,
 1),

('ffffffff-ffff-ffff-ffff-000000000002', '22222222-2222-2222-2222-222222220004', 'wep_introduction',
 'W = \int \vec F \cdot d\vec r',
 'Work done by a variable force -- the integral of force over the path of displacement.',
 $Q$மாறும் விசையால் செய்யப்படும் வேலை — இடப்பெயர்ச்சிப் பாதையின் மீது விசையின் தொகையீடு.$Q$,
 2),

('ffffffff-ffff-ffff-ffff-000000000003', '22222222-2222-2222-2222-222222220004', 'wep_energy',
 'KE = \dfrac{1}{2}mv^2 = \dfrac{p^2}{2m}',
 'Kinetic energy, in terms of velocity or of momentum.',
 $Q$இயக்க ஆற்றல், வேகம் அல்லது உந்தத்தின் அடிப்படையில்.$Q$,
 1),

('ffffffff-ffff-ffff-ffff-000000000004', '22222222-2222-2222-2222-222222220004', 'wep_energy',
 'W = \Delta KE = KE_f - KE_i',
 'Work-energy theorem -- the net work done on an object equals its change in kinetic energy.',
 $Q$வேலை-இயக்க ஆற்றல் தேற்றம் — ஒரு பொருள் மீது செய்யப்படும் நிகர வேலை அதன் இயக்க ஆற்ற மாற்றத்திற்குச் சமம்.$Q$,
 2),

('ffffffff-ffff-ffff-ffff-000000000005', '22222222-2222-2222-2222-222222220004', 'wep_energy',
 'U_{gravity} = mgh, \quad U_{spring} = \dfrac{1}{2}kx^2',
 'Gravitational potential energy (height h above a reference) and spring potential energy (extension/compression x).',
 $Q$ஈர்ப்பு நிலை ஆற்றல் (குறிப்புக்கு மேல் உயரம் h) மற்றும் சுருள் நிலை ஆற்றல் (நீட்சி/சுருக்கம் x).$Q$,
 3),

('ffffffff-ffff-ffff-ffff-000000000006', '22222222-2222-2222-2222-222222220004', 'wep_conservative',
 'KE + U = \text{constant}',
 'Law of conservation of energy -- in a conservative force field, the total mechanical energy of a system never changes.',
 $Q$ஆற்றல் அழிவின்மை விதி — ஒரு பாதுகாப்பு விசைப் புலத்தில், ஒரு அமைப்பின் மொத்த இயந்திர ஆற்றல் ஒருபோதும் மாறாது.$Q$,
 1),

('ffffffff-ffff-ffff-ffff-000000000007', '22222222-2222-2222-2222-222222220004', 'wep_conservative',
 '\oint \vec F \cdot d\vec r = 0',
 'A force is conservative if and only if the work done around any closed path is zero.',
 $Q$எந்தவொரு மூடிய பாதையிலும் செய்யப்படும் வேலை பூஜ்ஜியமாக இருந்தால் மட்டுமே ஒரு விசை பாதுகாப்பு விசையாகும்.$Q$,
 2),

('ffffffff-ffff-ffff-ffff-000000000008', '22222222-2222-2222-2222-222222220004', 'wep_vertical_circle',
 'T_1 - T_2 = 6mg',
 'Difference in string tension between the bottom (T1) and top (T2) of a vertical circle -- independent of the radius or speed.',
 $Q$செங்குத்து வட்டத்தின் அடிப்பகுதி (T1) மற்றும் மேற்பகுதி (T2) இடையேயான சரட்டு இழுவிசை வேறுபாடு — ஆரம் அல்லது வேகத்தை சாராதது.$Q$,
 1),

('ffffffff-ffff-ffff-ffff-000000000009', '22222222-2222-2222-2222-222222220004', 'wep_vertical_circle',
 'v_{top,min} = \sqrt{gr}, \quad v_{bottom,min} = \sqrt{5gr} \; \text{(string)}, \quad v_{bottom,min} = \sqrt{4gr} \; \text{(rigid rod)}',
 'Minimum speeds to complete a vertical circle -- a rod needs less speed at the bottom than a string, since it can push as well as pull.',
 $Q$ஒரு செங்குத்து வட்டத்தை நிறைவு செய்ய தேவையான குறைந்தபட்ச வேகங்கள் — ஒரு தண்டு அடிப்பகுதியில் சரட்டை விட குறைந்த வேகம் தேவை, ஏனெனில் அது இழுக்கவும் தள்ளவும் முடியும்.$Q$,
 2),

('ffffffff-ffff-ffff-ffff-000000000010', '22222222-2222-2222-2222-222222220004', 'wep_power',
 'P = \dfrac{W}{t}, \quad P = \vec F \cdot \vec v',
 'Power -- the rate of doing work, expressible either as work over time, or directly as force dotted with velocity.',
 $Q$திறன் — வேலை செய்யப்படும் வீதம், நேரத்தின் மீது வேலையாகவோ, அல்லது நேரடியாக விசை மற்றும் திசைவேகத்தின் புள்ளிப் பெருக்கமாகவோ வெளிப்படுத்தலாம்.$Q$,
 1),

('ffffffff-ffff-ffff-ffff-000000000011', '22222222-2222-2222-2222-222222220004', 'wep_power',
 '1 \text{ hp} = 746 \text{ W}, \quad 1 \text{ kWh} = 3.6\times10^6 \text{ J}',
 'Common power/energy unit conversions -- horsepower to watts, and the kilowatt-hour (a unit of ENERGY, not power).',
 $Q$பொதுவான திறன்/ஆற்றல் அலகு மாற்றங்கள் — ஹார்ஸ்பவரிலிருந்து வாட்டிற்கு, மற்றும் கிலோவாட்-மணிநேரம் (ஆற்றலின் அலகு, திறன் அல்ல).$Q$,
 2),

('ffffffff-ffff-ffff-ffff-000000000012', '22222222-2222-2222-2222-222222220004', 'wep_collisions',
 'v_1=\left(\dfrac{m_1-m_2}{m_1+m_2}\right)u_1+\left(\dfrac{2m_2}{m_1+m_2}\right)u_2, \quad v_2=\left(\dfrac{2m_1}{m_1+m_2}\right)u_1+\left(\dfrac{m_2-m_1}{m_1+m_2}\right)u_2',
 'Final velocities after a one-dimensional elastic collision (both momentum and kinetic energy conserved).',
 $Q$ஒரு பரிமாண மீள் மோதலுக்குப் பின் இறுதி வேகங்கள் (உந்தம் மற்றும் இயக்க ஆற்றல் இரண்டும் பாதுகாக்கப்படுகின்றன).$Q$,
 1),

('ffffffff-ffff-ffff-ffff-000000000013', '22222222-2222-2222-2222-222222220004', 'wep_collisions',
 'v = \dfrac{m_1u_1+m_2u_2}{m_1+m_2}',
 'Common velocity after a perfectly inelastic collision (bodies stick together).',
 $Q$முழுமையான தனிச்சுருக்க மோதலுக்குப் பின் பொதுவான வேகம் (உடல்கள் ஒட்டிக்கொள்கின்றன).$Q$,
 2),

('ffffffff-ffff-ffff-ffff-000000000014', '22222222-2222-2222-2222-222222220004', 'wep_restitution',
 'e = \dfrac{v_2-v_1}{u_1-u_2}, \quad \Delta Q = \dfrac{1}{2}\left(\dfrac{m_1m_2}{m_1+m_2}\right)(u_1-u_2)^2',
 'Coefficient of restitution (ratio of separation to approach velocity) and the kinetic energy lost in a perfectly inelastic collision.',
 $Q$மீள்தன்மைக் குணகம் (பிரிதல் வேகத்திற்கும் நெருங்குதல் வேகத்திற்கும் இடையேயான விகிதம்) மற்றும் முழுமையான தனிச்சுருக்க மோதலில் இழக்கப்படும் இயக்க ஆற்றல்.$Q$,
 1)
on conflict (id) do nothing;
