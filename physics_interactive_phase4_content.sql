-- ============================================================
-- Interactive Physics — Phase 4 Content
-- Run AFTER physics_interactive_schema_v4.sql.
--
-- 1. Renames the old "One Mark Questions" lesson (10 supplementary
--    MCQs spanning the whole chapter) to "Extra One Mark Questions"
--    and moves it to the LAST slot in the Interactive Physics tab.
-- 2. Adds a new lesson "Book Back One Mark Questions" -- the REAL
--    15 MCQs from the textbook's "I. Multiple Choice Questions"
--    section, each with the book's own answer, a full worked
--    explanation, and a 2D diagram wherever the textbook itself
--    shows one (or the concept is diagram-worthy).
-- 3. Replaces the 6 illustrative problems in "Book Back Problems"
--    with all 15 REAL numerical problems from the textbook's
--    "IV. Numerical Problems" section, each fully worked out.
--
-- Uses fixed UUIDs and "on conflict do nothing" / explicit deletes --
-- safe to re-run.
-- ============================================================

-- ------------------------------------------------------------
-- 1. Rename + move "One Mark Questions" -> "Extra One Mark Questions"
-- ------------------------------------------------------------
update physics_ip_lessons set
  title = 'Extra One Mark Questions',
  title_ta = $$கூடுதல் ஒரு மதிப்பெண் வினாக்கள்$$,
  hook_summary = 'Ten more quick questions, spanning the whole chapter -- good for extra practice.',
  hook_summary_ta = $$முழு அத்தியாயத்திலிருந்தும் மேலும் பத்து விரைவான வினாக்கள் — கூடுதல் பயிற்சிக்கு ஏற்றது.$$,
  group_key = 'extra_one_mark',
  order_index = 11
where id = '77777777-7777-7777-7777-000000000009';


-- ------------------------------------------------------------
-- 2. NEW LESSON -- "Book Back One Mark Questions"
--    (real textbook MCQs, section I, with the book's own answer key)
-- ------------------------------------------------------------
insert into physics_ip_lessons (id, chapter_id, title, title_ta, hook_summary, hook_summary_ta, order_index, group_key) values
('77777777-7777-7777-7777-000000000011', '22222222-2222-2222-2222-222222220003',
 'Book Back One Mark Questions',
 $$பாட புத்தக ஒரு மதிப்பெண் வினாக்கள்$$,
 'The real 15 MCQs from the textbook''s evaluation section -- exact questions, exact answer key.',
 $$பாடப்புத்தகத்தின் மதிப்பீட்டுப் பகுதியிலிருந்து உண்மையான 15 MCQ வினாக்கள் — சரியான வினாக்கள், சரியான விடைத்திறவுகோல்.$$,
 9, 'book_back_mcq')
on conflict (id) do nothing;

insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('88888888-8888-8888-8888-000000000301', 'mcq',
 $$When a car takes a sudden left turn on a curved road, passengers are pushed towards the right due to$$,
 $$வளைந்த சாலையில் ஒரு கார் திடீரென இடதுபுறம் திரும்பும்போது, பயணிகள் வலதுபுறம் தள்ளப்படுவதற்குக் காரணம்$$,
 $${"options": ["inertia of direction", "inertia of motion", "inertia of rest", "absence of inertia"], "correct_index": 0}$$::jsonb,
 $${"options": ["திசை மந்தம் (inertia of direction)", "இயக்க மந்தம் (inertia of motion)", "ஓய்வு மந்தம் (inertia of rest)", "மந்தம் இல்லாமை"]}$$::jsonb,
 $$Passengers tend to keep moving in their original straight-line direction -- that resistance to a CHANGE IN DIRECTION is called inertia of direction. As the car turns left beneath them, they appear (relative to the car) to be pushed toward the right.$$,
 $$பயணிகள் தங்கள் அசல் நேர்கோட்டுத் திசையிலேயே தொடர்ந்து செல்ல முனைகிறார்கள் — திசையில் ஏற்படும் மாற்றத்தை எதிர்க்கும் இந்தப் பண்பே திசை மந்தம் எனப்படும். கார் இடதுபுறம் திரும்பும்போது, காரைப் பொறுத்து அவர்கள் வலதுபுறம் தள்ளப்படுவது போல் தோன்றுகிறார்கள்.$$,
 $$Don't confuse this with inertia of motion (resisting a change in SPEED) or inertia of rest (resisting starting to move) -- a turn changes direction, not speed, so it specifically tests inertia of direction.$$,
 $$இதை இயக்க மந்தத்துடன் (வேகத்தில் ஏற்படும் மாற்றத்தை எதிர்ப்பது) அல்லது ஓய்வு மந்தத்துடன் (நகரத் தொடங்குவதை எதிர்ப்பது) குழப்பிக்கொள்ள வேண்டாம் — ஒரு திருப்பம் திசையை மாற்றுகிறது, வேகத்தை அல்ல, எனவே இது குறிப்பாக திசை மந்தத்தைச் சோதிக்கிறது.$$,
 'Inertia has three flavours: rest, motion, and direction -- a sudden turn specifically tests inertia of direction.',
 $$மந்தம் மூன்று வகைகளில் வரும்: ஓய்வு, இயக்கம், திசை — திடீர் திருப்பம் திசை மந்தத்தைச் சோதிக்கிறது.$$,
 null
),

('88888888-8888-8888-8888-000000000302', 'mcq',
 $$An object of mass $m$ is held against a vertical wall by applying a horizontal force $F$, as shown. The minimum value of the force $F$ is (IIT JEE 1994)$$,
 $$$m$ நிறையுள்ள ஒரு பொருள், கிடைமட்ட விசை $F$ ஐப் பயன்படுத்தி ஒரு செங்குத்துச் சுவருக்கு எதிராகப் பிடிக்கப்படுகிறது, படத்தில் காட்டியுள்ளபடி. $F$ இன் குறைந்தபட்ச மதிப்பு (IIT JEE 1994)$$,
 $${"options": ["Less than mg", "Equal to mg", "Greater than mg", "Cannot determine"], "correct_index": 2}$$::jsonb,
 $${"options": ["mg ஐ விடக் குறைவு", "mg க்குச் சமம்", "mg ஐ விட அதிகம்", "தீர்மானிக்க முடியாது"]}$$::jsonb,
 $$The wall's normal force equals $F$ (it just pushes back on whatever presses into it), so the maximum friction available is $\mu_s F$. For the block not to slide down, that friction must support the full weight: $\mu_s F \geq mg \Rightarrow F \geq mg/\mu_s$. Since $\mu_s$ is typically less than 1 for everyday surfaces, $mg/\mu_s$ is greater than $mg$ -- so the minimum required $F$ is greater than $mg$.$$,
 $$சுவரின் இயல்நிலை விசை $F$ க்குச் சமம் (அதன் மீது அழுத்தும் எதையும் அது திருப்பித் தள்ளுகிறது), எனவே கிடைக்கும் அதிகபட்ச உராய்வு $\mu_s F$. தொகுதி கீழே சறுக்காமல் இருக்க, அந்த உராய்வு முழு எடையையும் தாங்க வேண்டும்: $\mu_s F \geq mg \Rightarrow F \geq mg/\mu_s$. அன்றாட மேற்பரப்புகளுக்கு $\mu_s$ பொதுவாக 1 ஐ விடக் குறைவாக இருப்பதால், $mg/\mu_s$ ஆனது $mg$ ஐ விட அதிகமாகும் — எனவே தேவையான குறைந்தபட்ச $F$, $mg$ ஐ விட அதிகம்.$$,
 $$It's tempting to say $F = mg$ (as if friction perfectly matches weight at the threshold with $F=mg$) -- but that ignores that friction is capped at $\mu_s F$, not $\mu_s mg$, so you must solve the inequality in terms of $F$ itself.$$,
 $$$F = mg$ என்று கூறத் தோன்றலாம் (வாசல் நிலையில் உராய்வு எடையுடன் சரியாகப் பொருந்துவது போல்) — ஆனால் உராய்வு $\mu_s mg$ அல்ல, $\mu_s F$ ஆல் வரம்பிடப்பட்டுள்ளது என்பதைப் புறக்கணிக்கிறது, எனவே $F$ ஐப் பொறுத்தே சமனிலி (inequality) தீர்க்க வேண்டும்.$$,
 'The harder you press an object into a wall, the more friction is available to hold it up -- but you always need MORE force than the object''s weight, never less.',
 $$ஒரு பொருளை சுவரில் அழுத்தும் அளவுக்கு, அதைத் தாங்க கிடைக்கும் உராய்வு அதிகரிக்கும் — ஆனால் எப்போதும் பொருளின் எடையை விட அதிக விசை தேவை, குறைவானது ஒருபோதும் இல்லை.$$,
 'block_against_wall'
),

('88888888-8888-8888-8888-000000000303', 'mcq',
 $$A vehicle is moving along the positive $x$ direction. If sudden brakes are applied, then$$,
 $$ஒரு வாகனம் நேர்குறி $x$ திசையில் நகர்கிறது. திடீரென பிரேக் போடப்பட்டால்,$$,
 $${"options": ["frictional force acting on the vehicle is along the negative x direction", "frictional force acting on the vehicle is along the positive x direction", "no frictional force acts on the vehicle", "frictional force acts in the downward direction"], "correct_index": 0}$$::jsonb,
 $${"options": ["வாகனத்தின் மீது செயல்படும் உராய்வு விசை எதிர்குறி x திசையில்", "வாகனத்தின் மீது செயல்படும் உராய்வு விசை நேர்குறி x திசையில்", "வாகனத்தின் மீது எந்த உராய்வு விசையும் செயல்படவில்லை", "உராய்வு விசை கீழ்நோக்கிச் செயல்படுகிறது"]}$$::jsonb,
 $$Braking makes the tyres tend to slide forward relative to the road (in the +x direction the vehicle was already moving). Kinetic/static friction always opposes this relative sliding tendency, so it acts backward -- along the negative x direction -- decelerating the vehicle.$$,
 $$பிரேக் போடும்போது, டயர்கள் சாலையைப் பொறுத்து முன்னோக்கி (வாகனம் ஏற்கெனவே நகர்ந்த +x திசையில்) சறுக்க முனைகின்றன. இயக்க/நிலை உராய்வு எப்போதும் இந்த சார்பு சறுக்கும் போக்கை எதிர்க்கிறது, எனவே அது பின்னோக்கி — எதிர்குறி x திசையில் — செயல்பட்டு வாகனத்தை மந்தப்படுத்துகிறது.$$,
 null, null,
 'Friction always opposes relative sliding (or the tendency to slide) -- braking friction points opposite to the direction of travel.',
 $$உராய்வு எப்போதும் சார்பு சறுக்கலை (அல்லது சறுக்கும் போக்கை) எதிர்க்கிறது — பிரேக் உராய்வு பயணத் திசைக்கு எதிராகச் செயல்படுகிறது.$$,
 null
),

('88888888-8888-8888-8888-000000000304', 'mcq',
 $$A book is at rest on a table, which exerts a normal force on the book. If this normal force is considered as the REACTION force, what is the ACTION force according to Newton's third law?$$,
 $$ஒரு புத்தகம் மேசையின் மீது ஓய்வில் உள்ளது, மேசை புத்தகத்தின் மீது இயல்நிலை விசையைச் செலுத்துகிறது. இந்த இயல்நிலை விசையை எதிர்செயல் விசையாகக் கருதினால், நியூட்டனின் மூன்றாம் விதியின்படி செயல் விசை எது?$$,
 $${"options": ["Gravitational force exerted by Earth on the book", "Gravitational force exerted by the book on Earth", "Normal force exerted by the book on the table", "None of the above"], "correct_index": 2}$$::jsonb,
 $${"options": ["பூமியால் புத்தகத்தின் மீது செலுத்தப்படும் ஈர்ப்பு விசை", "புத்தகத்தால் பூமியின் மீது செலுத்தப்படும் ஈர்ப்பு விசை", "புத்தகத்தால் மேசையின் மீது செலுத்தப்படும் இயல்நிலை விசை", "மேற்கண்டவை எதுவும் இல்லை"]}$$::jsonb,
 $$Every Newton's-third-law pair involves the SAME two objects and the SAME type of force, just swapped in direction. The reaction here is "table pushes book up" (a normal force). Its action-reaction partner must also be a normal force between the same two objects, in the opposite direction: "book pushes table down."$$,
 $$நியூட்டனின் மூன்றாம் விதி ஜோடி ஒவ்வொன்றும் ஒரே இரு பொருட்களையும் ஒரே வகை விசையையும் உள்ளடக்கும், திசை மட்டும் மாறும். இங்கு எதிர்செயல் "மேசை புத்தகத்தை மேலே தள்ளுகிறது" (இயல்நிலை விசை). அதன் செயல்-எதிர்செயல் ஜோடி, அதே இரு பொருட்களுக்கு இடையேயான, எதிர் திசையிலான, மற்றொரு இயல்நிலை விசையாகவே இருக்க வேண்டும்: "புத்தகம் மேசையைக் கீழே தள்ளுகிறது."$$,
 $$Gravity and the normal force are NOT an action-reaction pair, even though they're equal and opposite here -- they act on the SAME object (the book) and are different force types. A true Newton's-third-law pair always involves two different objects.$$,
 $$ஈர்ப்பு விசையும் இயல்நிலை விசையும் இங்கு சமமாகவும் எதிராகவும் இருந்தாலும், அவை செயல்-எதிர்செயல் ஜோடி அல்ல — அவை ஒரே பொருளின் (புத்தகம்) மீது செயல்படுகின்றன, வெவ்வேறு வகை விசைகள். உண்மையான நியூட்டனின் மூன்றாம் விதி ஜோடி எப்போதும் இரு வெவ்வேறு பொருட்களை உள்ளடக்கும்.$$,
 'Action-reaction pairs share the same force type and the same two objects (roles swapped) -- gravity-vs-normal-force on ONE object is never a valid pair.',
 $$செயல்-எதிர்செயல் ஜோடிகள் ஒரே வகை விசையையும் ஒரே இரு பொருட்களையும் (பங்குகள் மாற்றப்பட்டவை) பகிர்ந்துகொள்கின்றன — ஒரே பொருளின் மீதான ஈர்ப்பு-vs-இயல்நிலை விசை ஒருபோதும் சரியான ஜோடி அல்ல.$$,
 null
),

('88888888-8888-8888-8888-000000000305', 'mcq',
 $$Two masses $m_1$ and $m_2$ experience the same force, where $m_1 < m_2$. The ratio of their accelerations $a_1/a_2$ is$$,
 $$$m_1$ மற்றும் $m_2$ ஆகிய இரு நிறைகள் ஒரே விசையை அனுபவிக்கின்றன, $m_1 < m_2$. அவற்றின் முடுக்கங்களின் விகிதம் $a_1/a_2$ ஆகும்$$,
 $${"options": ["1", "less than 1", "greater than 1", "cannot be determined"], "correct_index": 2}$$::jsonb,
 $${"options": ["1", "1 ஐ விடக் குறைவு", "1 ஐ விட அதிகம்", "தீர்மானிக்க முடியாது"]}$$::jsonb,
 $$By Newton's Second Law, $a = F/m$. With the same $F$ for both: $a_1 = F/m_1$ and $a_2 = F/m_2$, so $\dfrac{a_1}{a_2} = \dfrac{m_2}{m_1}$. Since $m_2 > m_1$, this ratio is greater than 1 -- the lighter object always accelerates more under the same force.$$,
 $$நியூட்டனின் இரண்டாம் விதியின்படி, $a = F/m$. இரண்டிற்கும் ஒரே $F$ இருப்பதால்: $a_1 = F/m_1$, $a_2 = F/m_2$, எனவே $\dfrac{a_1}{a_2} = \dfrac{m_2}{m_1}$. $m_2 > m_1$ என்பதால், இந்த விகிதம் 1 ஐ விட அதிகம் — ஒரே விசையின் கீழ், இலகுவான பொருள் எப்போதும் அதிக முடுக்கம் அடையும்.$$,
 null, null,
 'Same force, smaller mass -- bigger acceleration. Acceleration and mass are inversely related.',
 $$ஒரே விசை, சிறிய நிறை — பெரிய முடுக்கம். முடுக்கமும் நிறையும் நேர்மாறு தொடர்பு கொண்டவை.$$,
 null
),

('88888888-8888-8888-8888-000000000306', 'mcq',
 $$A particle experiences a net acceleration directed along the negative $y$ direction. Which of the following must be TRUE about the free body diagram of the forces acting on it?$$,
 $$ஒரு துகள் எதிர்குறி $y$ திசையில் நிகர முடுக்கத்தை அனுபவிக்கிறது. அதன் மீது செயல்படும் விசைகளின் இயல்நிலை உரு வரைபடத்தைப் பற்றி பின்வருவனவற்றுள் எது உண்மையாக இருக்க வேண்டும்?$$,
 $${"options": ["The vector sum of all the forces points along +y", "The vector sum of all the forces points along +x", "The vector sum of all the forces points along -y", "The vector sum of all the forces must be zero"], "correct_index": 2}$$::jsonb,
 $${"options": ["அனைத்து விசைகளின் திசையன் கூட்டுத்தொகை +y திசையில்", "அனைத்து விசைகளின் திசையன் கூட்டுத்தொகை +x திசையில்", "அனைத்து விசைகளின் திசையன் கூட்டுத்தொகை -y திசையில்", "அனைத்து விசைகளின் திசையன் கூட்டுத்தொகை பூஜ்ஜியமாக இருக்க வேண்டும்"]}$$::jsonb,
 $$By Newton's Second Law, $\vec F_{net} = m\vec a$ -- the net force always points in the SAME direction as the acceleration. Since the acceleration is along $-y$, the vector sum of every force arrow in the free body diagram must also point along $-y$, no matter how many individual forces are involved.$$,
 $$நியூட்டனின் இரண்டாம் விதியின்படி, $\vec F_{net} = m\vec a$ — நிகர விசை எப்போதும் முடுக்கத்தின் அதே திசையில் இருக்கும். முடுக்கம் $-y$ திசையில் இருப்பதால், இயல்நிலை உரு வரைபடத்தில் உள்ள ஒவ்வொரு விசை அம்புக்குறியின் திசையன் கூட்டுத்தொகையும் $-y$ திசையில் இருக்க வேண்டும், எத்தனை தனிப்பட்ட விசைகள் ஈடுபட்டிருந்தாலும்.$$,
 $$A common trap: assuming the diagram with the "biggest-looking" downward arrow is correct. What matters is the VECTOR SUM of every force shown, not any single arrow.$$,
 $$ஒரு பொதுவான தவறு: "பெரிதாகத் தெரியும்" கீழ்நோக்கிய அம்புக்குறி உள்ள வரைபடம் சரி என்று கருதுவது. முக்கியமானது காட்டப்பட்ட ஒவ்வொரு விசையின் திசையன் கூட்டுத்தொகையே, எந்த ஒரு தனி அம்புக்குறியும் அல்ல.$$,
 'The direction of the net force ALWAYS matches the direction of acceleration -- that''s Newton''s Second Law in one sentence.',
 $$நிகர விசையின் திசை எப்போதும் முடுக்கத்தின் திசையுடன் பொருந்தும் — இதுவே நியூட்டனின் இரண்டாம் விதி ஒரே வாக்கியத்தில்.$$,
 null
),

('88888888-8888-8888-8888-000000000307', 'mcq',
 $$A particle of mass $m$ slides on the smooth double inclined plane shown (peak $A$, sliding down to $B$ at $30°$ or to $C$ at $45°$). It will experience$$,
 $$$m$ நிறையுள்ள ஒரு துகள், காட்டப்பட்டுள்ள மென்மையான இரட்டைச் சாய்தளத்தில் (உச்சி $A$, $30°$ இல் $B$ க்கு அல்லது $45°$ இல் $C$ க்கு சறுக்குகிறது) சறுக்குகிறது. அது அனுபவிக்கும்$$,
 $${"options": ["greater acceleration along the path AB", "greater acceleration along the path AC", "same acceleration in both the paths", "no acceleration in both the paths"], "correct_index": 1}$$::jsonb,
 $${"options": ["AB பாதையில் அதிக முடுக்கம்", "AC பாதையில் அதிக முடுக்கம்", "இரு பாதைகளிலும் ஒரே முடுக்கம்", "இரு பாதைகளிலும் முடுக்கம் இல்லை"]}$$::jsonb,
 $$Since both surfaces are smooth (frictionless), the acceleration down each slope is simply $a = g\sin\theta$. Path AC is steeper ($45°$) than path AB ($30°$), and $\sin 45° > \sin 30°$, so the particle accelerates more along AC.$$,
 $$இரு மேற்பரப்புகளும் மென்மையானவை (உராய்வற்றவை) என்பதால், ஒவ்வொரு சாய்விலும் முடுக்கம் வெறுமனே $a = g\sin\theta$. AC பாதை ($45°$) AB பாதையை ($30°$) விட செங்குத்தானது, $\sin 45° > \sin 30°$ என்பதால், துகள் AC வழியாக அதிக முடுக்கத்தை அடையும்.$$,
 null, null,
 'On a frictionless slope, steeper always means faster acceleration -- a = g sinθ grows with the angle.',
 $$உராய்வற்ற சாய்வில், செங்குத்தானது எப்போதும் அதிக முடுக்கத்தைக் குறிக்கும் — a = g sinθ கோணத்துடன் அதிகரிக்கும்.$$,
 'double_incline'
),

('88888888-8888-8888-8888-000000000308', 'mcq',
 $$Two blocks of masses $m$ and $2m$ are placed in contact on a smooth horizontal surface. In Case 1, only a force $F_1$ is applied from the left (through $2m$ into $m$). In Case 2, only a force $F_2$ is applied from the right (through $m$ into $2m$). If the contact force at the interface of the two blocks is the same in both cases, then $F_1 : F_2$ is (Physics Olympiad 2016)$$,
 $$$m$ மற்றும் $2m$ நிறையுள்ள இரு தொகுதிகள், மென்மையான கிடைமட்டப் பரப்பில் தொடர்பில் வைக்கப்பட்டுள்ளன. வழக்கு 1 இல், இடதுபுறத்திலிருந்து ($2m$ வழியாக $m$ க்குள்) $F_1$ மட்டும் செலுத்தப்படுகிறது. வழக்கு 2 இல், வலதுபுறத்திலிருந்து ($m$ வழியாக $2m$ க்குள்) $F_2$ மட்டும் செலுத்தப்படுகிறது. இரு தொகுதிகளுக்கும் இடையேயான தொடர்பு விசை இரு வழக்குகளிலும் ஒரே அளவாக இருந்தால், $F_1 : F_2$ ஆனது$$,
 $${"options": ["1:1", "1:2", "2:1", "1:3"], "correct_index": 2}$$::jsonb,
 $${"options": ["1:1", "1:2", "2:1", "1:3"]}$$::jsonb,
 $$Case 1: the whole system (mass $3m$) accelerates at $a_1 = F_1/3m$. The contact force is whatever's needed to accelerate just the $m$ block: $N_1 = m \times a_1 = F_1/3$. Case 2: system accelerates at $a_2 = F_2/3m$; the contact force now accelerates the $2m$ block: $N_2 = 2m \times a_2 = 2F_2/3$. Setting $N_1 = N_2$: $F_1/3 = 2F_2/3 \Rightarrow F_1 = 2F_2 \Rightarrow F_1:F_2 = 2:1$.$$,
 $$வழக்கு 1: முழு அமைப்பும் (நிறை $3m$) $a_1 = F_1/3m$ இல் முடுக்கமடைகிறது. தொடர்பு விசை என்பது $m$ தொகுதியை மட்டும் முடுக்க தேவையானது: $N_1 = m \times a_1 = F_1/3$. வழக்கு 2: அமைப்பு $a_2 = F_2/3m$ இல் முடுக்கமடைகிறது; இப்போது தொடர்பு விசை $2m$ தொகுதியை முடுக்குகிறது: $N_2 = 2m \times a_2 = 2F_2/3$. $N_1 = N_2$ எனவைத்தால்: $F_1/3 = 2F_2/3 \Rightarrow F_1 = 2F_2 \Rightarrow F_1:F_2 = 2:1$.$$,
 $$The contact force is NOT simply $F_1$ or $F_2$ -- it's only the portion of the applied force needed to accelerate the block on the far side of the contact point. Always isolate just that one block to find it.$$,
 $$தொடர்பு விசை வெறுமனே $F_1$ அல்லது $F_2$ அல்ல — அது தொடர்புப் புள்ளியின் மறுபுறத்தில் உள்ள தொகுதியை மட்டும் முடுக்கத் தேவையான பகுதி மட்டுமே. அதைக் காண, அந்த ஒரு தொகுதியை மட்டும் தனிமைப்படுத்தவும்.$$,
 'The interface (contact) force between two blocks depends on which block is "downstream" of the push -- pushing the lighter block from the far side gives a smaller contact force.',
 $$இரு தொகுதிகளுக்கு இடையேயான தொடர்பு விசை, தள்ளுதலின் "பின்புற" தொகுதி எது என்பதைப் பொறுத்தது — இலகுவான தொகுதியை தொலைபுறத்திலிருந்து தள்ளுவது சிறிய தொடர்பு விசையைத் தரும்.$$,
 'two_blocks_force'
),

('88888888-8888-8888-8888-000000000309', 'mcq',
 $$The force acting on a particle moving with constant SPEED is$$,
 $$மாறாத வேகத்தில் நகரும் ஒரு துகளின் மீது செயல்படும் விசை$$,
 $${"options": ["always zero", "need not be zero", "always non-zero", "cannot be concluded"], "correct_index": 1}$$::jsonb,
 $${"options": ["எப்போதும் பூஜ்ஜியம்", "பூஜ்ஜியமாக இருக்க வேண்டிய அவசியமில்லை", "எப்போதும் பூஜ்ஜியமற்றது", "முடிவு செய்ய முடியாது"]}$$::jsonb,
 $$Constant SPEED doesn't mean constant VELOCITY -- direction can still be changing. In uniform circular motion, for example, speed is constant but a real, non-zero centripetal force constantly changes the direction of motion. So the force need not be zero.$$,
 $$மாறாத வேகம் என்றால் மாறாத திசைவேகம் என்று அர்த்தமல்ல — திசை இன்னும் மாறிக்கொண்டே இருக்கலாம். உதாரணமாக சீரான வட்ட இயக்கத்தில், வேகம் மாறாமல் இருந்தாலும், ஒரு உண்மையான, பூஜ்ஜியமற்ற நோக்குமைய விசை தொடர்ந்து இயக்கத்தின் திசையை மாற்றுகிறது. எனவே விசை பூஜ்ஜியமாக இருக்க வேண்டிய அவசியமில்லை.$$,
 $$"Speed" (a scalar) and "velocity" (a vector) are not the same thing -- constant speed with changing direction is exactly what circular motion looks like, and it definitely needs a net force.$$,
 $$"வேகம்" (ஒரு அளவெண்) மற்றும் "திசைவேகம்" (ஒரு திசையன்) ஒன்றல்ல — மாறாத வேகத்துடன் மாறும் திசை என்பது வட்ட இயக்கத்தின் தன்மையே, அதற்கு நிச்சயம் ஒரு நிகர விசை தேவை.$$,
 'Constant speed only means the magnitude of velocity isn''t changing -- constant VELOCITY (magnitude AND direction) is the one that needs zero net force.',
 $$மாறாத வேகம் என்பது திசைவேகத்தின் அளவு மாறவில்லை என்பதை மட்டுமே குறிக்கும் — மாறாத திசைவேகம் (அளவும் திசையும்) மட்டுமே பூஜ்ஜிய நிகர விசையைத் தேவைப்படுத்தும்.$$,
 null
),

('88888888-8888-8888-8888-000000000310', 'mcq',
 $$An object of mass $m$ begins to move on a plane inclined at angle $\theta$. The coefficient of static friction of the inclined surface is $\mu_s$. The maximum static friction experienced by the mass is$$,
 $$$m$ நிறையுள்ள ஒரு பொருள் $\theta$ கோணத்தில் சாய்ந்த தளத்தில் நகரத் தொடங்குகிறது. சாய்தளத்தின் நிலை உராய்வு குணகம் $\mu_s$. நிறை அனுபவிக்கும் அதிகபட்ச நிலை உராய்வு$$,
 $${"options": ["mg", "\\mu_s mg", "\\mu_s mg \\sin\\theta", "\\mu_s mg \\cos\\theta"], "correct_index": 3}$$::jsonb,
 $${"options": ["mg", "\\mu_s mg", "\\mu_s mg \\sin\\theta", "\\mu_s mg \\cos\\theta"]}$$::jsonb,
 $$Maximum static friction is $\mu_s N$, where $N$ is the ACTUAL normal force -- not the full weight $mg$. On an incline, the normal force balances only the perpendicular component of weight: $N = mg\cos\theta$. So maximum static friction $= \mu_s mg\cos\theta$.$$,
 $$அதிகபட்ச நிலை உராய்வு $\mu_s N$, இங்கு $N$ என்பது உண்மையான இயல்நிலை விசை — முழு எடை $mg$ அல்ல. சாய்தளத்தில், இயல்நிலை விசை எடையின் செங்குத்துப் பகுதியை மட்டுமே சமன் செய்கிறது: $N = mg\cos\theta$. எனவே அதிகபட்ச நிலை உராய்வு $= \mu_s mg\cos\theta$.$$,
 $$A very common slip is writing $\mu_s mg$ (using the full weight) instead of $\mu_s mg\cos\theta$ (using the actual normal force) -- always find $N$ for the specific geometry first.$$,
 $$$\mu_s mg\cos\theta$ (உண்மையான இயல்நிலை விசையைப் பயன்படுத்துவது) க்குப் பதிலாக $\mu_s mg$ (முழு எடையைப் பயன்படுத்துவது) எழுதுவது ஒரு மிகப் பொதுவான தவறு — குறிப்பிட்ட வடிவவியலுக்கான $N$ ஐ முதலில் காணவும்.$$,
 'Maximum static friction is always μsN -- and N depends on the geometry, so on an incline it''s μsmg cosθ, not μsmg.',
 $$அதிகபட்ச நிலை உராய்வு எப்போதும் μsN — N வடிவவியலைப் பொறுத்தது, எனவே சாய்தளத்தில் அது μsmg cosθ, μsmg அல்ல.$$,
 'block_on_rough_incline'
),

('88888888-8888-8888-8888-000000000311', 'mcq',
 $$When an object is moving at constant velocity on a rough surface,$$,
 $$ஒரு பொருள் கரடுமுரடான மேற்பரப்பில் மாறாத திசைவேகத்தில் நகரும்போது,$$,
 $${"options": ["net force on the object is zero", "no force acts on the object", "only external force acts on the object", "only kinetic friction acts on the object"], "correct_index": 0}$$::jsonb,
 $${"options": ["பொருளின் மீது நிகர விசை பூஜ்ஜியம்", "பொருளின் மீது எந்த விசையும் செயல்படவில்லை", "பொருளின் மீது வெளிப்புற விசை மட்டுமே செயல்படுகிறது", "பொருளின் மீது இயக்க உராய்வு மட்டுமே செயல்படுகிறது"]}$$::jsonb,
 $$Constant velocity means zero acceleration, so by Newton's Second Law the NET force is zero. That doesn't mean no forces act -- gravity, normal force, the applied force, and kinetic friction are all present, but they add up to zero.$$,
 $$மாறாத திசைவேகம் என்றால் பூஜ்ஜிய முடுக்கம், எனவே நியூட்டனின் இரண்டாம் விதியின்படி நிகர விசை பூஜ்ஜியம். இதன் பொருள் விசைகள் எதுவும் செயல்படவில்லை என்பதல்ல — ஈர்ப்பு, இயல்நிலை விசை, செலுத்தப்படும் விசை, இயக்க உராய்வு அனைத்தும் இருக்கின்றன, ஆனால் அவை கூட்டி பூஜ்ஜியமாகின்றன.$$,
 null, null,
 'Constant velocity = zero net force, NOT zero forces. Multiple real forces can still be present, perfectly balanced.',
 $$மாறாத திசைவேகம் = பூஜ்ஜிய நிகர விசை, பூஜ்ஜிய விசைகள் அல்ல. பல உண்மையான விசைகள் இன்னும் இருக்கலாம், சரியாகச் சமநிலையில்.$$,
 null
),

('88888888-8888-8888-8888-000000000312', 'mcq',
 $$When an object is at rest on a rough inclined surface (and not on the verge of sliding),$$,
 $$ஒரு பொருள் கரடுமுரடான சாய்தளத்தில் ஓய்வில் இருக்கும்போது (சறுக்கும் விளிம்பில் இல்லாதபோது),$$,
 $${"options": ["static and kinetic frictions acting on the object are both zero", "static friction is zero but kinetic friction is not zero", "static friction is not zero and kinetic friction is zero", "static and kinetic frictions are both not zero"], "correct_index": 2}$$::jsonb,
 $${"options": ["நிலை மற்றும் இயக்க உராய்வு இரண்டும் பூஜ்ஜியம்", "நிலை உராய்வு பூஜ்ஜியம், ஆனால் இயக்க உராய்வு பூஜ்ஜியமல்ல", "நிலை உராய்வு பூஜ்ஜியமல்ல, இயக்க உராய்வு பூஜ்ஜியம்", "நிலை மற்றும் இயக்க உராய்வு இரண்டும் பூஜ்ஜியமல்ல"]}$$::jsonb,
 $$The object isn't sliding, so kinetic friction (which only applies to relative motion) is zero -- there's no motion for it to act on. But it isn't sliding precisely BECAUSE static friction is actively balancing the component of gravity pulling it down the slope, so static friction is non-zero.$$,
 $$பொருள் சறுக்கவில்லை, எனவே இயக்க உராய்வு (சார்பு இயக்கத்திற்கு மட்டுமே பொருந்தும்) பூஜ்ஜியம் — அது செயல்பட எந்த இயக்கமும் இல்லை. ஆனால் அது சறுக்காமல் இருப்பதற்குக் காரணமே, சாய்வில் கீழிழுக்கும் ஈர்ப்பின் பகுதியை நிலை உராய்வு தீவிரமாகச் சமன் செய்வதால்தான், எனவே நிலை உராய்வு பூஜ்ஜியமல்ல.$$,
 $$Static and kinetic friction are never both active at once on the same object -- an object is either not sliding (only static friction can act) or sliding (only kinetic friction can act), never both.$$,
 $$நிலை மற்றும் இயக்க உராய்வு ஒரே பொருளின் மீது ஒரே நேரத்தில் ஒருபோதும் இயங்காது — ஒரு பொருள் சறுக்கவில்லை (நிலை உராய்வு மட்டுமே செயல்படும்) அல்லது சறுக்குகிறது (இயக்க உராய்வு மட்டுமே செயல்படும்), இரண்டும் ஒருபோதும் இல்லை.$$,
 'A stationary object on a rough slope: static friction is doing real work (non-zero); kinetic friction doesn''t apply at all (zero) since nothing is sliding.',
 $$கரடுமுரடான சாய்தளத்தில் நிலையான பொருள்: நிலை உராய்வு உண்மையான வேலையைச் செய்கிறது (பூஜ்ஜியமல்ல); எதுவும் சறுக்காததால் இயக்க உராய்வு பொருந்தவே இல்லை (பூஜ்ஜியம்).$$,
 'block_on_rough_incline'
),

('88888888-8888-8888-8888-000000000313', 'mcq',
 $$The centrifugal force appears to exist$$,
 $$மையவிலக்கு விசை இருப்பதாகத் தோன்றுவது$$,
 $${"options": ["only in inertial frames", "only in rotating frames", "in any accelerated frame", "both in inertial and non-inertial frames"], "correct_index": 1}$$::jsonb,
 $${"options": ["நிலைமம் சட்டகங்களில் மட்டும்", "சுழலும் சட்டகங்களில் மட்டும்", "எந்த முடுக்கமடைந்த சட்டகத்திலும்", "நிலைமம் மற்றும் நிலைமமற்ற சட்டகங்கள் இரண்டிலும்"]}$$::jsonb,
 $$Centrifugal force is a pseudo (fictitious) force that only shows up when you analyze motion from INSIDE a rotating (non-inertial) frame. An observer in an inertial frame never needs it -- they see only real forces, like the centripetal force actually pulling the object inward.$$,
 $$மையவிலக்கு விசை என்பது ஒரு போலி (கற்பனையான) விசை, அதை சுழலும் (நிலைமமற்ற) சட்டகத்திற்குள் இருந்து இயக்கத்தை பகுப்பாய்வு செய்யும்போது மட்டுமே காணலாம். நிலைமம் சட்டகத்தில் உள்ள ஒரு பார்வையாளருக்கு அது ஒருபோதும் தேவையில்லை — அவர்கள் உண்மையான விசைகளை மட்டுமே காண்கிறார்கள், பொருளை உண்மையில் உள்நோக்கி இழுக்கும் நோக்குமைய விசை போன்றவை.$$,
 null, null,
 'Centrifugal force is specifically a rotating-frame phenomenon -- not just any accelerating frame, and never in an inertial (non-accelerating) frame.',
 $$மையவிலக்கு விசை என்பது குறிப்பாக சுழலும்-சட்டக நிகழ்வு — வெறும் எந்த முடுக்கமடைந்த சட்டகமும் அல்ல, நிலைமம் (முடுக்கமற்ற) சட்டகத்தில் ஒருபோதும் இல்லை.$$,
 null
),

('88888888-8888-8888-8888-000000000314', 'mcq',
 $$Choose the correct statement from the following:$$,
 $$பின்வருவனவற்றுள் சரியான கூற்றைத் தேர்ந்தெடுக்கவும்:$$,
 $${"options": ["Centrifugal and centripetal forces are action-reaction pairs", "Centripetal force is a natural force", "Centrifugal force arises from gravitational force", "Centripetal force acts towards the centre, and centrifugal force appears to act away from the centre, in circular motion"], "correct_index": 3}$$::jsonb,
 $${"options": ["மையவிலக்கு மற்றும் நோக்குமைய விசைகள் செயல்-எதிர்செயல் ஜோடி", "நோக்குமைய விசை ஒரு இயற்கை விசை", "மையவிலக்கு விசை ஈர்ப்பு விசையிலிருந்து தோன்றுகிறது", "வட்ட இயக்கத்தில் நோக்குமைய விசை மையத்தை நோக்கியும், மையவிலக்கு விசை மையத்திலிருந்து விலகியும் செயல்படுவதாகத் தோன்றும்"]}$$::jsonb,
 $$Option (d) is the precise, textbook-accurate summary: centripetal force is real and points toward the centre; centrifugal force is a pseudo-force that only appears (in a rotating frame) to point away from the centre. The other options misdescribe the relationship -- they aren't an action-reaction pair (different frames, not different objects), centripetal force isn't a separate "natural" force type (it's a role played by tension, gravity, friction, etc.), and centrifugal force arises from inertia, not gravity.$$,
 $$விருப்பம் (d) துல்லியமான, பாடப்புத்தக-துல்லியமான சுருக்கம்: நோக்குமைய விசை உண்மையானது, மையத்தை நோக்கிச் செல்கிறது; மையவிலக்கு விசை ஒரு போலி விசை, (சுழலும் சட்டகத்தில்) மையத்திலிருந்து விலகிச் செல்வதாகத் தோன்றும். மற்ற விருப்பங்கள் தொடர்பை தவறாக விளக்குகின்றன — அவை செயல்-எதிர்செயல் ஜோடி அல்ல (வெவ்வேறு சட்டகங்கள், வெவ்வேறு பொருட்கள் அல்ல), நோக்குமைய விசை ஒரு தனி "இயற்கை" விசை வகை அல்ல (இது இழுவிசை, ஈர்ப்பு, உராய்வு போன்றவற்றால் வகிக்கப்படும் ஒரு பங்கு), மையவிலக்கு விசை மந்தத்திலிருந்து தோன்றுகிறது, ஈர்ப்பிலிருந்து அல்ல.$$,
 null, null,
 'Centripetal = real, toward the centre. Centrifugal = pseudo, appears to point away from the centre, only in a rotating frame.',
 $$நோக்குமைய = உண்மையானது, மையத்தை நோக்கி. மையவிலக்கு = போலியானது, மையத்திலிருந்து விலகிச் செல்வதாகத் தோன்றும், சுழலும் சட்டகத்தில் மட்டும்.$$,
 null
),

('88888888-8888-8888-8888-000000000315', 'mcq',
 $$If a person moves from the pole to the equator, the centrifugal force acting on him$$,
 $$ஒரு நபர் துருவத்திலிருந்து பூமத்திய ரேகைக்கு நகர்ந்தால், அவர் மீது செயல்படும் மையவிலக்கு விசை$$,
 $${"options": ["increases", "decreases", "remains the same", "increases and then decreases"], "correct_index": 0}$$::jsonb,
 $${"options": ["அதிகரிக்கும்", "குறையும்", "மாறாமல் இருக்கும்", "அதிகரித்துப் பின் குறையும்"]}$$::jsonb,
 $$Centrifugal force is $F_{cf} = m\omega^2 R\cos\phi$ ($\phi$ = latitude), where the effective radius from Earth's rotation axis grows from essentially zero at the pole to the full Earth radius at the equator. As that effective radius grows, so does the centrifugal force.$$,
 $$மையவிலக்கு விசை $F_{cf} = m\omega^2 R\cos\phi$ ($\phi$ = அட்சரேகை), இங்கு பூமியின் சுழற்சி அச்சிலிருந்து பயனுள்ள ஆரம், துருவத்தில் கிட்டத்தட்ட பூஜ்ஜியத்திலிருந்து பூமத்திய ரேகையில் முழு பூமியின் ஆரம் வரை வளர்கிறது. அந்த பயனுள்ள ஆரம் வளரும்போது, மையவிலக்கு விசையும் வளர்கிறது.$$,
 null, null,
 'Centrifugal force depends on distance from Earth''s rotation AXIS, not distance from the centre -- that distance is zero at the poles and maximum at the equator.',
 $$மையவிலக்கு விசை பூமியின் சுழற்சி அச்சிலிருந்தான தூரத்தைப் பொறுத்தது, மையத்திலிருந்தான தூரத்தை அல்ல — அந்தத் தூரம் துருவங்களில் பூஜ்ஜியமும் பூமத்திய ரேகையில் அதிகபட்சமும் ஆகும்.$$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('99999999-9999-9999-9999-000000000301', '77777777-7777-7777-7777-000000000011', 'motivation',
 'The Real Book Back MCQs',
 $$உண்மையான பாடப்புத்தக MCQ வினாக்கள்$$,
 $$These are the exact 15 multiple-choice questions from the textbook's evaluation section, in order, with the book's own answer key -- each with a full explanation and a diagram wherever the original question has one.$$,
 $$இவை பாடப்புத்தகத்தின் மதிப்பீட்டுப் பகுதியிலிருந்து சரியான வரிசையில் உள்ள 15 பலவுள் தேர்வு வினாக்கள், பாடப்புத்தகத்தின் சொந்த விடைத்திறவுகோலுடன் — ஒவ்வொன்றும் முழுமையான விளக்கத்துடனும், அசல் வினாவில் படம் இருந்தால் அதுவும் இணைக்கப்பட்டுள்ளது.$$,
 null, null, 1),

('99999999-9999-9999-9999-000000000302', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000301', 2),
('99999999-9999-9999-9999-000000000303', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000302', 3),
('99999999-9999-9999-9999-000000000304', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000303', 4),
('99999999-9999-9999-9999-000000000305', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000304', 5),
('99999999-9999-9999-9999-000000000306', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000305', 6),
('99999999-9999-9999-9999-000000000307', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000306', 7),
('99999999-9999-9999-9999-000000000308', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000307', 8),
('99999999-9999-9999-9999-000000000309', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000308', 9),
('99999999-9999-9999-9999-000000000310', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000309', 10),
('99999999-9999-9999-9999-000000000311', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000310', 11),
('99999999-9999-9999-9999-000000000312', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000311', 12),
('99999999-9999-9999-9999-000000000313', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000312', 13),
('99999999-9999-9999-9999-000000000314', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000313', 14),
('99999999-9999-9999-9999-000000000315', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000314', 15),
('99999999-9999-9999-9999-000000000316', '77777777-7777-7777-7777-000000000011', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000315', 16)
on conflict (id) do nothing;


-- ============================================================
-- 3. Replace "Book Back Problems" content: out with the 6
--    illustrative problems, in with all 15 real textbook problems.
-- ============================================================
delete from physics_ip_steps where id in (
  '99999999-9999-9999-9999-000000000213', '99999999-9999-9999-9999-000000000214',
  '99999999-9999-9999-9999-000000000215', '99999999-9999-9999-9999-000000000216',
  '99999999-9999-9999-9999-000000000217', '99999999-9999-9999-9999-000000000218'
);
delete from physics_ip_questions where id in (
  '88888888-8888-8888-8888-000000000211', '88888888-8888-8888-8888-000000000212',
  '88888888-8888-8888-8888-000000000213', '88888888-8888-8888-8888-000000000214',
  '88888888-8888-8888-8888-000000000215', '88888888-8888-8888-8888-000000000216'
);

update physics_ip_lessons set
  hook_summary = 'All 15 numerical problems from the textbook''s evaluation section, fully worked out.',
  hook_summary_ta = $$பாடப்புத்தகத்தின் மதிப்பீட்டுப் பகுதியிலிருந்து அனைத்து 15 எண்ணியல் பிரச்சினைகளும், முழுமையாகத் தீர்க்கப்பட்டவை.$$
where id = '77777777-7777-7777-7777-000000000010';

insert into physics_ip_questions (id, question_type, prompt_text, prompt_text_ta, data, data_ta, explanation_text, explanation_text_ta, common_mistake, common_mistake_ta, takeaway_fact, takeaway_fact_ta, diagram_key) values

('88888888-8888-8888-8888-000000000401', 'fill_blank',
 $$1. A force of $50$ N acts on an object of mass $20$ kg at an angle of $30°$ above the horizontal, as shown. Calculate the acceleration of the object in the $x$ and $y$ directions.$$,
 $$1. $50$ N விசை, $20$ kg நிறையுள்ள ஒரு பொருளின் மீது கிடைமட்டத்திலிருந்து $30°$ கோணத்தில் செயல்படுகிறது, படத்தில் காட்டியுள்ளபடி. $x$ மற்றும் $y$ திசைகளில் பொருளின் முடுக்கத்தைக் கணக்கிடவும்.$$,
 $${"blanks": [{"label": "Acceleration a_x (m/s²)", "type": "number", "correct": 2.165}, {"label": "Acceleration a_y (m/s²)", "type": "number", "correct": 1.25}]}$$::jsonb,
 $${"blanks": [{"label": "முடுக்கம் a_x (m/s²)"}, {"label": "முடுக்கம் a_y (m/s²)"}]}$$::jsonb,
 $$Resolve $F = 50$ N into components: $F_x = F\cos30° = 50 \times 0.866 = 43.3$ N and $F_y = F\sin30° = 50 \times 0.5 = 25$ N. Then apply Newton's Second Law separately in each direction: $a_x = F_x/m = 43.3/20 = 2.165$ m/s² and $a_y = F_y/m = 25/20 = 1.25$ m/s².$$,
 $$$F = 50$ N ஐப் பகுதிகளாகப் பிரிக்கவும்: $F_x = F\cos30° = 43.3$ N, $F_y = F\sin30° = 25$ N. பின்னர் ஒவ்வொரு திசையிலும் தனித்தனியாக நியூட்டனின் இரண்டாம் விதியைப் பயன்படுத்தவும்: $a_x = F_x/m = 43.3/20 = 2.165$ m/s², $a_y = F_y/m = 25/20 = 1.25$ m/s².$$,
 $$Don't apply $F = ma$ using the full $50$ N in both directions -- each direction only "feels" its own component of the force.$$,
 $$இரு திசைகளிலும் முழு $50$ N ஐப் பயன்படுத்தி $F = ma$ ஐப் பயன்படுத்த வேண்டாம் — ஒவ்வொரு திசையும் அதன் சொந்த விசைப் பகுதியை மட்டுமே "உணரும்".$$,
 'Resolve first, then apply F = ma separately along each axis -- x and y accelerations are always independent.',
 $$முதலில் பிரிக்கவும், பின்னர் ஒவ்வொரு அச்சிலும் தனித்தனியாக F = ma ஐப் பயன்படுத்தவும் — x மற்றும் y முடுக்கங்கள் எப்போதும் சார்பற்றவை.$$,
 'force_components'
),

('88888888-8888-8888-8888-000000000402', 'fill_blank',
 $$2. A spider of mass $50$ g hangs on a single strand of a cobweb. What is the tension in the strand?$$,
 $$2. $50$ g நிறையுள்ள ஒரு சிலந்தி, சிலந்தி வலையின் ஒற்றை இழையில் தொங்குகிறது. இழையில் உள்ள இழுவிசை என்ன?$$,
 $${"blanks": [{"label": "Tension T (N)", "type": "number", "correct": 0.49}]}$$::jsonb,
 $${"blanks": [{"label": "இழுவிசை T (N)"}]}$$::jsonb,
 $$The spider hangs in equilibrium, so the strand's tension simply balances its weight: $T = mg = 0.050 \times 9.8 = 0.49$ N. (Note the mass was converted from $50$ g to $0.050$ kg first.)$$,
 $$சிலந்தி சமநிலையில் தொங்குகிறது, எனவே இழையின் இழுவிசை அதன் எடையை மட்டுமே சமன் செய்கிறது: $T = mg = 0.050 \times 9.8 = 0.49$ N. ($50$ g ஐ முதலில் $0.050$ kg ஆக மாற்றியது கவனிக்கவும்.)$$,
 $$Always convert grams to kilograms before plugging into $F=ma$ or $mg$ -- forgetting this gives an answer 1000 times too large.$$,
 $$$F=ma$ அல்லது $mg$ இல் பயன்படுத்தும் முன் கிராமை எப்போதும் கிலோகிராமாக மாற்றவும் — இதை மறப்பது 1000 மடங்கு பெரிய பதிலைத் தரும்.$$,
 'For any object hanging still from a single support, tension always just equals weight: T = mg.',
 $$ஒற்றை ஆதரவில் அசையாமல் தொங்கும் எந்தப் பொருளுக்கும், இழுவிசை எப்போதும் எடைக்குச் சமம்: T = mg.$$,
 null
),

('88888888-8888-8888-8888-000000000403', 'fill_blank',
 $$3. Two situations with a spring balance are shown: (a) two identical $4$ kg blocks rest on a smooth table, connected only by a spring balance that isn't attached to any support pulling it taut -- what does it read? (b) a $2$ kg block on a frictionless $30°$ incline is held in equilibrium by a spring balance oriented along the slope -- what does it read?$$,
 $$3. விசைச் சுருள் தராசு தொடர்பான இரு சூழ்நிலைகள் காட்டப்பட்டுள்ளன: (a) இரு ஒரே மாதிரியான $4$ kg தொகுதிகள் ஒரு மென்மையான மேசையில் உள்ளன, இழுக்கும் எந்த ஆதரவுடனும் இணைக்கப்படாத ஒரு விசைச் சுருள் தராசால் மட்டும் இணைக்கப்பட்டுள்ளன — அது என்ன காட்டும்? (b) $2$ kg தொகுதி ஒரு உராய்வற்ற $30°$ சாய்தளத்தில், சாய்வுக்கு இணையாக அமைந்த ஒரு விசைச் சுருள் தராசால் சமநிலையில் வைக்கப்பட்டுள்ளது — அது என்ன காட்டும்?$$,
 $${"blanks": [{"label": "Reading in case (a) (N)", "type": "number", "correct": 0}, {"label": "Reading in case (b) (N)", "type": "number", "correct": 9.8}]}$$::jsonb,
 $${"blanks": [{"label": "வழக்கு (a) இல் அளவீடு (N)"}, {"label": "வழக்கு (b) இல் அளவீடு (N)"}]}$$::jsonb,
 $$(a) A spring balance only reads a force if it's actually under tension. With nothing pulling the two blocks apart and no support holding the balance taut, there's no tension in it -- it reads $0$ N, even though both blocks have weight. (b) On the incline, equilibrium along the slope requires the balance's tension to exactly cancel the component of weight pulling the block down the slope: $T = mg\sin\theta = 2 \times 9.8 \times \sin30° = 2 \times 9.8 \times 0.5 = 9.8$ N.$$,
 $$(a) ஒரு விசைச் சுருள் தராசு அது உண்மையில் இழுவிசையின் கீழ் இருந்தால் மட்டுமே ஒரு விசையைக் காட்டும். இரு தொகுதிகளையும் பிரிக்க எதுவும் இழுக்காமலும், தராசை இறுக்கமாக வைக்கும் ஆதரவு எதுவும் இல்லாமலும் இருப்பதால், அதில் இழுவிசை இல்லை — இரு தொகுதிகளுக்கும் எடை இருந்தாலும், அது $0$ N ஐக் காட்டும். (b) சாய்தளத்தில், சாய்வில் சமநிலைக்கு, தராசின் இழுவிசை தொகுதியை சாய்வில் கீழிழுக்கும் எடையின் பகுதியை சரியாக ரத்து செய்ய வேண்டும்: $T = mg\sin\theta = 2 \times 9.8 \times 0.5 = 9.8$ N.$$,
 $$Seeing a "heavy-looking" object doesn't automatically mean a connected spring balance reads its weight -- the balance only reads what it's actually pulling against.$$,
 $$"கனமாகத் தெரியும்" ஒரு பொருளைப் பார்ப்பது, இணைக்கப்பட்ட விசைச் சுருள் தராசு அதன் எடையைக் காட்டும் என்று தானாக அர்த்தமல்ல — தராசு அது உண்மையில் எதிர்த்து இழுப்பதை மட்டுமே காட்டும்.$$,
 'A spring balance reads TENSION, not weight -- if nothing is pulling it taut, it reads zero no matter how heavy the objects around it are.',
 $$விசைச் சுருள் தராசு இழுவிசையைக் காட்டும், எடையை அல்ல — அதை இறுக்கமாக இழுக்க எதுவும் இல்லையென்றால், சுற்றியுள்ள பொருட்கள் எவ்வளவு கனமாக இருந்தாலும் அது பூஜ்ஜியத்தைக் காட்டும்.$$,
 null
),

('88888888-8888-8888-8888-000000000404', 'mcq',
 $$4. Several physics textbooks are stacked on a table, one directly on top of another. According to Newton's third law, which statement correctly describes the force pair between any two books that are touching each other?$$,
 $$4. பல இயற்பியல் பாடப்புத்தகங்கள் ஒன்றன் மேல் ஒன்றாக மேசையில் அடுக்கப்பட்டுள்ளன. நியூட்டனின் மூன்றாம் விதியின்படி, தொடர்பில் உள்ள எந்த இரு புத்தகங்களுக்கும் இடையேயான விசை ஜோடியை சரியாக விவரிக்கும் கூற்று எது?$$,
 $${"options": ["The lower book pushes the upper book down, and the upper book pushes the lower book up, with equal magnitude", "The upper book pushes down on the lower book, and the lower book pushes up on the upper book, with equal magnitude", "Only the upper book exerts a force on the lower book; the lower book exerts none back", "The force between any two books equals the weight of the entire stack"], "correct_index": 1}$$::jsonb,
 $${"options": ["கீழ் புத்தகம் மேல் புத்தகத்தை கீழே தள்ளுகிறது, மேல் புத்தகம் கீழ் புத்தகத்தை மேலே தள்ளுகிறது, சம அளவில்", "மேல் புத்தகம் கீழ் புத்தகத்தின் மீது கீழே அழுத்துகிறது, கீழ் புத்தகம் மேல் புத்தகத்தின் மீது மேலே தள்ளுகிறது, சம அளவில்", "மேல் புத்தகம் மட்டுமே கீழ் புத்தகத்தின் மீது விசையை செலுத்துகிறது; கீழ் புத்தகம் திரும்பப் பதிலளிக்காது", "எந்த இரு புத்தகங்களுக்கும் இடையேயான விசை முழு அடுக்கின் எடைக்குச் சமம்"]}$$::jsonb,
 $$Isolate any adjacent pair. The upper book presses down on the lower one with its own normal-force reaction (a real, downward push). By Newton's third law, the lower book must push back up on the upper one with exactly equal magnitude -- this is the normal-force pair that ultimately supports the whole stack, book by book, all the way down to the table.$$,
 $$எந்த அருகிலுள்ள ஜோடியையும் தனிமைப்படுத்தவும். மேல் புத்தகம் அதன் சொந்த இயல்நிலை-விசை எதிர்வினையுடன் (உண்மையான, கீழ்நோக்கிய தள்ளுதல்) கீழ் புத்தகத்தின் மீது அழுத்துகிறது. நியூட்டனின் மூன்றாம் விதியின்படி, கீழ் புத்தகம் சரியாக சம அளவில் மேல் புத்தகத்தின் மீது மீண்டும் தள்ள வேண்டும் — இதுவே மேசை வரை, புத்தகம் புத்தகமாக, முழு அடுக்கையும் இறுதியில் தாங்கும் இயல்நிலை-விசை ஜோடி.$$,
 $$Each book only needs to support the weight of the books ABOVE it, not the whole stack -- the force between any pair is smaller the higher up you go.$$,
 $$ஒவ்வொரு புத்தகமும் அதற்கு மேலே உள்ள புத்தகங்களின் எடையை மட்டுமே தாங்க வேண்டும், முழு அடுக்கையும் அல்ல — மேலே செல்லும்போது எந்த ஜோடிக்கும் இடையேயான விசை சிறியதாகிறது.$$,
 'A stack of objects is just a chain of Newton''s-third-law pairs -- each contact point supports only the weight above it.',
 $$ஒரு பொருட்களின் அடுக்கு என்பது நியூட்டனின் மூன்றாம் விதி ஜோடிகளின் ஒரு சங்கிலி — ஒவ்வொரு தொடர்புப் புள்ளியும் அதற்கு மேலே உள்ள எடையை மட்டுமே தாங்கும்.$$,
 null
),

('88888888-8888-8888-8888-000000000405', 'mcq',
 $$5. A bob attached to a string oscillates back and forth. At an angle $\theta$ from the vertical, which pair correctly gives the bob's tangential and centripetal acceleration (string tension $T$, mass $m$)?$$,
 $$5. ஒரு நூலில் இணைக்கப்பட்ட ஒரு பந்து முன்னும் பின்னுமாக ஊசலாடுகிறது. செங்குத்திலிருந்து $\theta$ கோணத்தில், பந்தின் தொடுகோட்டு மற்றும் நோக்குமைய முடுக்கத்தை சரியாகத் தரும் ஜோடி எது (நூல் இழுவிசை $T$, நிறை $m$)?$$,
 $${"options": ["Tangential = g sinθ; centripetal = (T - mg cosθ)/m", "Tangential = g cosθ; centripetal = (T - mg sinθ)/m", "Tangential = g sinθ; centripetal = T/m", "Tangential = 0; centripetal = g"], "correct_index": 0}$$::jsonb,
 $${"options": ["தொடுகோடு = g sinθ; நோக்குமையம் = (T - mg cosθ)/m", "தொடுகோடு = g cosθ; நோக்குமையம் = (T - mg sinθ)/m", "தொடுகோடு = g sinθ; நோக்குமையம் = T/m", "தொடுகோடு = 0; நோக்குமையம் = g"]}$$::jsonb,
 $$Resolve the bob's weight $mg$ into two directions: along the string (radial) and perpendicular to it (tangential). The tangential component, $mg\sin\theta$, causes tangential acceleration $g\sin\theta$ -- this is what speeds the bob up or slows it down along its arc. Along the string, tension pulls in and the radial component of weight ($mg\cos\theta$) pulls out, so the net inward (centripetal) force is $T - mg\cos\theta$, giving centripetal acceleration $(T-mg\cos\theta)/m$.$$,
 $$பந்தின் எடை $mg$ ஐ இரு திசைகளாகப் பிரிக்கவும்: நூலுக்கு இணையாக (ஆரை வழி) மற்றும் அதற்குச் செங்குத்தாக (தொடுகோடு வழி). தொடுகோட்டுப் பகுதி, $mg\sin\theta$, தொடுகோட்டு முடுக்கம் $g\sin\theta$ ஐ ஏற்படுத்துகிறது — இது பந்தை அதன் வளைவில் வேகப்படுத்துகிறது அல்லது மந்தப்படுத்துகிறது. நூலுக்கு இணையாக, இழுவிசை உள்நோக்கி இழுக்கிறது, எடையின் ஆரை வழிப் பகுதி ($mg\cos\theta$) வெளிநோக்கி இழுக்கிறது, எனவே நிகர உள்நோக்கிய (நோக்குமைய) விசை $T - mg\cos\theta$, நோக்குமைய முடுக்கம் $(T-mg\cos\theta)/m$ ஐத் தருகிறது.$$,
 $$It's tempting to think tension alone gives the centripetal acceleration ($T/m$) -- but you must first subtract the outward-pulling radial component of gravity.$$,
 $$இழுவிசை மட்டுமே நோக்குமைய முடுக்கத்தைத் தரும் ($T/m$) என்று நினைக்கத் தோன்றும் — ஆனால் முதலில் ஈர்ப்பின் வெளிநோக்கி இழுக்கும் ஆரை வழிப் பகுதியைக் கழிக்க வேண்டும்.$$,
 'A swinging bob has BOTH a tangential acceleration (changing speed) and a centripetal one (changing direction) at the same time -- pendulum motion is not simple circular motion.',
 $$ஊசலாடும் பந்துக்கு ஒரே நேரத்தில் தொடுகோட்டு முடுக்கமும் (வேகம் மாறுவது) நோக்குமைய முடுக்கமும் (திசை மாறுவது) இரண்டும் உள்ளன — ஊசல் இயக்கம் எளிய வட்ட இயக்கம் அல்ல.$$,
 null
),

('88888888-8888-8888-8888-000000000406', 'fill_blank',
 $$6. Masses $m_1$ and $m_2$ are connected by a string over a frictionless pulley fixed at the corner of a table. $m_1$ sits on the table (coefficient of static friction $\mu_s$) and $m_2$ hangs freely. Calculate the minimum mass $m_3$ that must be placed on top of $m_1$ to prevent it from sliding, if $m_1=15$ kg, $m_2=10$ kg, $\mu_s=0.2$.$$,
 $$6. $m_1$ மற்றும் $m_2$ ஆகிய நிறைகள், மேசையின் மூலையில் பொருத்தப்பட்ட உராய்வற்ற கப்பி வழியாக ஒரு நூலால் இணைக்கப்பட்டுள்ளன. $m_1$ மேசையின் மீது உள்ளது (நிலை உராய்வு குணகம் $\mu_s$), $m_2$ தொங்குகிறது. $m_1$ சறுக்காமல் இருக்க, அதன் மேல் வைக்க வேண்டிய குறைந்தபட்ச நிறை $m_3$ ஐக் கணக்கிடவும், $m_1=15$ kg, $m_2=10$ kg, $\mu_s=0.2$ எனில்.$$,
 $${"blanks": [{"label": "Minimum m3 (kg)", "type": "number", "correct": 35}]}$$::jsonb,
 $${"blanks": [{"label": "குறைந்தபட்ச m3 (kg)"}]}$$::jsonb,
 $$For $m_1$ (plus $m_3$ on top) to stay still, the string tension (equal to the hanging weight $m_2g$, since the pulley is frictionless and $m_2$ is in equilibrium) must not exceed the maximum static friction: $m_2g \leq \mu_s(m_1+m_3)g \Rightarrow m_3 \geq m_2/\mu_s - m_1$. Substituting: $m_3 \geq 10/0.2 - 15 = 50 - 15 = 35$ kg. (Check: with the given $m_3=25$ kg, which is LESS than the required $35$ kg, the combined mass $m_1+m_3$ would indeed slide -- confirming why a minimum of $35$ kg is needed.)$$,
 $$$m_1$ (மற்றும் அதன் மேல் $m_3$) அசையாமல் இருக்க, நூல் இழுவிசை (கப்பி உராய்வற்றது மற்றும் $m_2$ சமநிலையில் இருப்பதால், தொங்கும் எடை $m_2g$ க்குச் சமம்) அதிகபட்ச நிலை உராய்வை மீறக்கூடாது: $m_2g \leq \mu_s(m_1+m_3)g \Rightarrow m_3 \geq m_2/\mu_s - m_1$. மதிப்பிட்டால்: $m_3 \geq 10/0.2 - 15 = 50 - 15 = 35$ kg. (சரிபார்ப்பு: கொடுக்கப்பட்ட $m_3=25$ kg, தேவையான $35$ kg ஐ விடக் குறைவு என்பதால், இணைந்த நிறை $m_1+m_3$ உண்மையில் சறுக்கும் — குறைந்தபட்சம் $35$ kg தேவை என்பதை உறுதிப்படுத்துகிறது.)$$,
 $$The extra mass $m_3$ increases the NORMAL force (and hence available friction) but doesn't add to the pulling tension -- it only sits on top, it isn't attached to the string.$$,
 $$கூடுதல் நிறை $m_3$ இயல்நிலை விசையை (எனவே கிடைக்கும் உராய்வையும்) அதிகரிக்கிறது, ஆனால் இழுக்கும் இழுவிசையுடன் சேராது — அது மேலே வைக்கப்படுகிறது மட்டுமே, நூலுடன் இணைக்கப்படவில்லை.$$,
 'Adding mass on top of a block increases its friction without adding to whatever''s trying to pull it -- that''s the whole trick behind this kind of problem.',
 $$ஒரு தொகுதியின் மேல் நிறையைச் சேர்ப்பது, அதை இழுக்க முயற்சிப்பதுடன் சேராமல், அதன் உராய்வை அதிகரிக்கிறது — இதுவே இந்த வகை பிரச்சினைக்குப் பின்னால் உள்ள முழுத் தந்திரம்.$$,
 null
),

('88888888-8888-8888-8888-000000000407', 'fill_blank',
 $$7. A $25$ kg bicycle experiences the horizontal forces shown in two different figures: Figure 1 has a $500$ N forward driving force opposed by $400$ N of resistance; Figure 2 has $400$ N pushing one way and $400$ N pushing the other. Calculate the bicycle's acceleration in each figure.$$,
 $$7. $25$ kg நிறையுள்ள ஒரு சைக்கிள், இரு வெவ்வேறு படங்களில் காட்டப்பட்டுள்ள கிடைமட்ட விசைகளை அனுபவிக்கிறது: படம் 1 இல் $500$ N முன்னோக்கிய இயக்கு விசையை $400$ N எதிர்ப்பு விசை எதிர்க்கிறது; படம் 2 இல் $400$ N ஒரு பக்கமும் $400$ N மறுபக்கமும் தள்ளுகின்றன. ஒவ்வொரு படத்திலும் சைக்கிளின் முடுக்கத்தைக் கணக்கிடவும்.$$,
 $${"blanks": [{"label": "Acceleration, Figure 1 (m/s²)", "type": "number", "correct": 4}, {"label": "Acceleration, Figure 2 (m/s²)", "type": "number", "correct": 0}]}$$::jsonb,
 $${"blanks": [{"label": "முடுக்கம், படம் 1 (m/s²)"}, {"label": "முடுக்கம், படம் 2 (m/s²)"}]}$$::jsonb,
 $$Figure 1: the net force is the difference between the two opposing forces, $500 - 400 = 100$ N, so $a = F_{net}/m = 100/25 = 4$ m/s². Figure 2: the two $400$ N forces are equal and opposite, so they cancel completely -- net force is zero, and $a = 0$ (the bicycle moves at constant velocity, if it was already moving, or stays at rest).$$,
 $$படம் 1: நிகர விசை என்பது எதிர் விசைகளுக்கு இடையேயான வேறுபாடு, $500 - 400 = 100$ N, எனவே $a = F_{net}/m = 100/25 = 4$ m/s². படம் 2: இரு $400$ N விசைகளும் சமமும் எதிருமாக இருப்பதால், அவை முழுமையாக ரத்தாகின்றன — நிகர விசை பூஜ்ஜியம், $a = 0$ (சைக்கிள் ஏற்கெனவே நகர்ந்திருந்தால் மாறாத திசைவேகத்தில் நகரும், அல்லது ஓய்வில் இருக்கும்).$$,
 null, null,
 'Always find the NET force first (add up all forces as vectors) before applying F=ma -- equal opposing forces mean zero acceleration, not zero force.',
 $$F=ma ஐப் பயன்படுத்தும் முன் எப்போதும் முதலில் நிகர விசையைக் (அனைத்து விசைகளையும் திசையன்களாகக் கூட்டி) காணவும் — சம எதிர் விசைகள் என்றால் பூஜ்ஜிய முடுக்கம், பூஜ்ஜிய விசை அல்ல.$$,
 null
),

('88888888-8888-8888-8888-000000000408', 'fill_blank',
 $$8. A "sling shot" Y-shaped setup has two strings, each making $30°$ with the vertical line of pull, symmetric about a force $F=50$ N. Apply Lami's theorem to calculate the tension $T$ in each string.$$,
 $$8. ஒரு "கவண்" Y-வடிவ அமைப்பில், இழுக்கும் செங்குத்துக் கோட்டுடன் ஒவ்வொன்றும் $30°$ கோணத்தில் அமைந்த, $F=50$ N விசையைப் பொறுத்து சமச்சீரான இரு நூல்கள் உள்ளன. ஒவ்வொரு நூலிலும் உள்ள இழுவிசை $T$ ஐக் கணக்கிட லாமியின் தேற்றத்தைப் பயன்படுத்தவும்.$$,
 $${"blanks": [{"label": "Tension T (N)", "type": "number", "correct": 28.87}]}$$::jsonb,
 $${"blanks": [{"label": "இழுவிசை T (N)"}]}$$::jsonb,
 $$By symmetry, both strings carry equal tension $T$. Balancing forces along the direction of $F$: the two strings' components along that line must together equal $F$: $2T\cos30° = F \Rightarrow T = \dfrac{F}{2\cos30°} = \dfrac{50}{2 \times 0.866} = \dfrac{50}{1.732} \approx 28.87$ N.$$,
 $$சமச்சீர் காரணமாக, இரு நூல்களும் சம இழுவிசை $T$ ஐத் தாங்கும். $F$ இன் திசையில் விசைகளைச் சமன் செய்யவும்: அந்தக் கோட்டில் இரு நூல்களின் பகுதிகளும் சேர்ந்து $F$ க்குச் சமமாக இருக்க வேண்டும்: $2T\cos30° = F \Rightarrow T = \dfrac{F}{2\cos30°} = \dfrac{50}{1.732} \approx 28.87$ N.$$,
 $$Each string's FULL tension isn't simply $F/2 = 25$ N -- only the component of each tension along the pull direction contributes, so you must divide by $\cos30°$ as well.$$,
 $$ஒவ்வொரு நூலின் முழு இழுவிசையும் வெறுமனே $F/2 = 25$ N அல்ல — ஒவ்வொரு இழுவிசையின் இழுக்கும் திசையிலான பகுதி மட்டுமே பங்களிக்கிறது, எனவே $\cos30°$ ஆலும் வகுக்க வேண்டும்.$$,
 'In a symmetric two-string setup, tension is always larger than F/2 -- the more "spread out" the strings, the larger the tension needed.',
 $$சமச்சீரான இரு-நூல் அமைப்பில், இழுவிசை எப்போதும் F/2 ஐ விட அதிகமாக இருக்கும் — நூல்கள் எவ்வளவு "விரிந்திருக்கிறதோ", அவ்வளவு அதிக இழுவிசை தேவை.$$,
 null
),

('88888888-8888-8888-8888-000000000409', 'fill_blank',
 $$9. A football player kicks a $0.8$ kg ball, imparting a velocity of $12$ m/s. The contact between foot and ball lasts only $1/60$ of a second. Find the average kicking force.$$,
 $$9. ஒரு கால்பந்து வீரர் $0.8$ kg நிறையுள்ள பந்தை உதைத்து $12$ m/s வேகத்தை அளிக்கிறார். கால்பந்திற்கும் காலுக்கும் இடையேயான தொடர்பு $1/60$ வினாடி மட்டுமே நீடிக்கிறது. சராசரி உதைக்கும் விசையைக் காணவும்.$$,
 $${"blanks": [{"label": "Average force (N)", "type": "number", "correct": 576}]}$$::jsonb,
 $${"blanks": [{"label": "சராசரி விசை (N)"}]}$$::jsonb,
 $$Using impulse-momentum: $F_{avg} \times \Delta t = \Delta p = m\Delta v$. So $F_{avg} = \dfrac{m\Delta v}{\Delta t} = \dfrac{0.8 \times 12}{1/60} = 0.8 \times 12 \times 60 = 576$ N.$$,
 $$கவின்-உந்த சமன்பாட்டைப் பயன்படுத்தி: $F_{avg} \times \Delta t = \Delta p = m\Delta v$. எனவே $F_{avg} = \dfrac{m\Delta v}{\Delta t} = \dfrac{0.8 \times 12}{1/60} = 576$ N.$$,
 $$Dividing by a small time interval (like $1/60$ s) is the same as multiplying by $60$ -- don't accidentally divide by $60$ instead.$$,
 $$ஒரு சிறிய கால இடைவெளியால் ($1/60$ வி போன்றவை) வகுப்பது $60$ ஆல் பெருக்குவதற்குச் சமம் — தவறாக $60$ ஆல் வகுக்க வேண்டாம்.$$,
 'Very short contact times need very large average forces to produce a normal-sized change in momentum -- that''s why a kick, unlike a steady push, can deliver so much force.',
 $$மிகக் குறுகிய தொடர்பு நேரங்களுக்கு, ஒரு சாதாரண உந்த மாற்றத்தை உருவாக்க மிகப் பெரிய சராசரி விசைகள் தேவை — அதனால்தான் ஒரு உதை, நிலையான தள்ளுதலைப் போலல்லாமல், இவ்வளவு அதிக விசையை வழங்க முடியும்.$$,
 null
),

('88888888-8888-8888-8888-000000000410', 'fill_blank',
 $$10. A stone of mass $2$ kg is attached to a string of length $1$ m and whirled in a horizontal circle. The string can withstand a maximum tension of $200$ N. What is the maximum speed the stone can have?$$,
 $$10. $2$ kg நிறையுள்ள ஒரு கல், $1$ m நீளமுள்ள நூலில் கட்டப்பட்டு கிடைமட்ட வட்டத்தில் சுழற்றப்படுகிறது. நூல் தாங்கக்கூடிய அதிகபட்ச இழுவிசை $200$ N. கல் அடையக்கூடிய அதிகபட்ச வேகம் என்ன?$$,
 $${"blanks": [{"label": "Maximum speed (m/s)", "type": "number", "correct": 10}]}$$::jsonb,
 $${"blanks": [{"label": "அதிகபட்ச வேகம் (m/s)"}]}$$::jsonb,
 $$The string tension supplies the centripetal force: $T_{max} = \dfrac{mv_{max}^2}{r} \Rightarrow v_{max} = \sqrt{\dfrac{T_{max}\, r}{m}} = \sqrt{\dfrac{200 \times 1}{2}} = \sqrt{100} = 10$ m/s.$$,
 $$நூல் இழுவிசை நோக்குமைய விசையை வழங்குகிறது: $T_{max} = \dfrac{mv_{max}^2}{r} \Rightarrow v_{max} = \sqrt{\dfrac{T_{max}\, r}{m}} = \sqrt{\dfrac{200 \times 1}{2}} = 10$ m/s.$$,
 $$Remember to take the SQUARE ROOT at the end -- it's easy to solve for $v^2$ and stop there.$$,
 $$இறுதியில் வர்க்கமூலம் எடுக்க மறக்க வேண்டாம் — $v^2$ க்குத் தீர்வு கண்டு அங்கேயே நிறுத்துவது எளிது.$$,
 'The string breaks the instant the required centripetal force exceeds its maximum tension -- speed and required tension grow together, but only as the SQUARE ROOT of tension.',
 $$தேவையான நோக்குமைய விசை அதிகபட்ச இழுவிசையை மீறும் தருணமே நூல் அறுந்துவிடும் — வேகமும் தேவையான இழுவிசையும் இணைந்து வளரும், ஆனால் இழுவிசையின் வர்க்கமூலமாக மட்டுமே.$$,
 null
),

('88888888-8888-8888-8888-000000000411', 'fill_blank',
 $$11. Imagine the gravitational pull between Earth and the Moon as an "invisible string" providing Earth's centripetal force on the Moon. Find the tension in this string (Mass of Moon $= 7.34\times10^{22}$ kg; Earth-Moon distance $= 3.84\times10^8$ m; Moon's orbital period $\approx 27.3$ days). Give your answer in units of $10^{20}$ N.$$,
 $$11. பூமிக்கும் நிலவுக்கும் இடையேயான ஈர்ப்பு விசையை, நிலவின் மீது பூமியின் நோக்குமைய விசையை வழங்கும் ஒரு "கண்ணுக்குத் தெரியாத நூல்" என்று கருதுங்கள். இந்த நூலில் உள்ள இழுவிசையைக் காணவும் (நிலவின் நிறை $= 7.34\times10^{22}$ kg; பூமி-நிலவு தூரம் $= 3.84\times10^8$ m; நிலவின் சுற்றுக் காலம் $\approx 27.3$ நாட்கள்). உங்கள் பதிலை $10^{20}$ N அலகுகளில் தரவும்.$$,
 $${"blanks": [{"label": "Tension (× 10^20 N)", "type": "number", "correct": 2}]}$$::jsonb,
 $${"blanks": [{"label": "இழுவிசை (× 10^20 N)"}]}$$::jsonb,
 $$Angular velocity: $\omega = \dfrac{2\pi}{T} = \dfrac{2\pi}{27.3 \times 24 \times 3600} \approx 2.665\times10^{-6}$ rad/s. Centripetal force: $F = m\omega^2 R = 7.34\times10^{22} \times (2.665\times10^{-6})^2 \times 3.84\times10^8 \approx 2\times10^{20}$ N.$$,
 $$கோண வேகம்: $\omega = \dfrac{2\pi}{T} = \dfrac{2\pi}{27.3 \times 24 \times 3600} \approx 2.665\times10^{-6}$ rad/s. நோக்குமைய விசை: $F = m\omega^2 R = 7.34\times10^{22} \times (2.665\times10^{-6})^2 \times 3.84\times10^8 \approx 2\times10^{20}$ N.$$,
 $$Use the MOON's own orbital period ($27.3$ days) here, not Earth's 24-hour rotation period -- they're different motions entirely.$$,
 $$இங்கு பூமியின் 24 மணிநேர சுழற்சிக் காலத்தை அல்ல, நிலவின் சொந்த சுற்றுக் காலத்தை ($27.3$ நாட்கள்) பயன்படுத்தவும் — அவை முற்றிலும் வேறுபட்ட இயக்கங்கள்.$$,
 'The Moon''s orbit isn''t held up by "nothing" -- gravity itself IS the centripetal force here, and the numbers work out to a tension of about 2×10²⁰ N.',
 $$நிலவின் சுற்றுப்பாதை "எதுவும் இல்லாமல்" நிலைநிறுத்தப்படவில்லை — ஈர்ப்பு விசையே இங்கு நோக்குமைய விசையாகும், எண்கள் சுமார் 2×10²⁰ N இழுவிசையைத் தருகின்றன.$$,
 null
),

('88888888-8888-8888-8888-000000000412', 'fill_blank',
 $$12. Two bodies of masses $15$ kg and $10$ kg are connected by a light string, resting on a smooth surface. A horizontal force $F=500$ N is applied to the $15$ kg mass. Calculate the tension in the string.$$,
 $$12. $15$ kg மற்றும் $10$ kg நிறையுள்ள இரு பொருட்கள் ஒரு இலகுவான நூலால் இணைக்கப்பட்டு, மென்மையான பரப்பில் உள்ளன. $15$ kg நிறையின் மீது $F=500$ N கிடைமட்ட விசை செலுத்தப்படுகிறது. நூலில் உள்ள இழுவிசையைக் கணக்கிடவும்.$$,
 $${"blanks": [{"label": "Tension T (N)", "type": "number", "correct": 200}]}$$::jsonb,
 $${"blanks": [{"label": "இழுவிசை T (N)"}]}$$::jsonb,
 $$The whole system (total mass $25$ kg) accelerates together: $a = F/(m_1+m_2) = 500/25 = 20$ m/s². The string only needs to accelerate the $10$ kg mass on the far end: $T = m_2 \times a = 10 \times 20 = 200$ N.$$,
 $$முழு அமைப்பும் (மொத்த நிறை $25$ kg) சேர்ந்து முடுக்கமடைகிறது: $a = F/(m_1+m_2) = 500/25 = 20$ m/s². நூல் தொலைபுற $10$ kg நிறையை மட்டுமே முடுக்க வேண்டும்: $T = m_2 \times a = 10 \times 20 = 200$ N.$$,
 $$The tension isn't the full $500$ N -- find the system's shared acceleration first, then isolate just the far block to get the string force.$$,
 $$இழுவிசை முழு $500$ N அல்ல — முதலில் அமைப்பின் பகிரப்பட்ட முடுக்கத்தைக் கண்டறியவும், பின்னர் நூல் விசையைப் பெற தொலைபுறத் தொகுதியை மட்டும் தனிமைப்படுத்தவும்.$$,
 'When two connected blocks are pulled, find the shared acceleration first (whole system), then isolate one block to get the connecting string''s tension.',
 $$இணைக்கப்பட்ட இரு தொகுதிகள் இழுக்கப்படும்போது, முதலில் பகிரப்பட்ட முடுக்கத்தைக் (முழு அமைப்பு) கண்டறியவும், பின்னர் இணைக்கும் நூலின் இழுவிசையைப் பெற ஒரு தொகுதியை தனிமைப்படுத்தவும்.$$,
 'two_blocks_force'
),

('88888888-8888-8888-8888-000000000413', 'mcq',
 $$13. People often say "for every action there is an equal and opposite reaction," extending it to human actions. Is it correct to apply Newton's third law to a human's PSYCHOLOGICAL actions or thoughts?$$,
 $$13. "ஒவ்வொரு செயலுக்கும் சம மற்றும் எதிரான எதிர்வினை உள்ளது" என்று பலர் கூறுவார்கள், இதை மனிதச் செயல்களுக்கும் விரிவுபடுத்துவார்கள். நியூட்டனின் மூன்றாம் விதியை ஒரு மனிதனின் உளவியல் செயல்கள் அல்லது எண்ணங்களுக்குப் பயன்படுத்துவது சரியா?$$,
 $${"options": ["Yes, the third law applies to every kind of human action, physical or psychological", "No -- Newton's third law is a law of physical (mechanical) forces, and applies only to a human's actions that involve an actual physical force", "The third law applies only to actions performed while standing still", "Newton's third law doesn't apply to humans at all, only to inanimate objects"], "correct_index": 1}$$::jsonb,
 $${"options": ["ஆம், மூன்றாம் விதி மனிதனின் ஒவ்வொரு வகையான செயலுக்கும் பொருந்தும், உடல் ரீதியானதோ உளவியல் ரீதியானதோ", "இல்லை — நியூட்டனின் மூன்றாம் விதி உடல் (இயந்திரவியல்) விசைகளின் விதி, மேலும் உண்மையான உடல் விசையை உள்ளடக்கிய மனிதனின் செயல்களுக்கு மட்டுமே பொருந்தும்", "மூன்றாம் விதி அசையாமல் நிற்கும்போது செய்யப்படும் செயல்களுக்கு மட்டுமே பொருந்தும்", "நியூட்டனின் மூன்றாம் விதி மனிதர்களுக்கு பொருந்தவே இல்லை, உயிரற்ற பொருட்களுக்கு மட்டுமே"]}$$::jsonb,
 $$Newton's third law is strictly a statement about physical forces between physical bodies -- for every real force one body exerts on another, an equal and opposite real force acts back. It says nothing about "action" in the everyday, psychological, or moral sense (like a kind act or an insult). Applying it to human intentions or feelings is a loose metaphor, not physics -- the law only applies when an actual mechanical force is involved (e.g., pushing, pulling, walking, throwing).$$,
 $$நியூட்டனின் மூன்றாம் விதி, உடல் பொருட்களுக்கு இடையேயான உடல் விசைகளைப் பற்றிய ஒரு துல்லியமான கூற்று — ஒரு பொருள் மற்றொன்றின் மீது செலுத்தும் ஒவ்வொரு உண்மையான விசைக்கும், சம மற்றும் எதிரான உண்மையான விசை மீண்டும் செயல்படும். இது அன்றாட, உளவியல் அல்லது தார்மீக அர்த்தத்தில் "செயல்" (ஒரு அன்பான செயல் அல்லது ஒரு அவமானம் போன்றவை) பற்றி எதுவும் கூறவில்லை. மனித நோக்கங்கள் அல்லது உணர்வுகளுக்கு அதைப் பயன்படுத்துவது ஒரு தளர்வான உருவகம், இயற்பியல் அல்ல — உண்மையான இயந்திரவியல் விசை ஈடுபட்டிருக்கும்போது மட்டுமே (உதாரணமாக தள்ளுதல், இழுத்தல், நடத்தல், எறிதல்) இந்த விதி பொருந்தும்.$$,
 null, null,
 'Newton''s third law is a law about physical forces between bodies -- it doesn''t govern psychology, morality, or human intentions, however tempting the popular quote is to over-apply.',
 $$நியூட்டனின் மூன்றாம் விதி பொருட்களுக்கு இடையேயான உடல் விசைகள் பற்றிய ஒரு விதி — பிரபலமான மேற்கோள் அதிகமாகப் பயன்படுத்தத் தூண்டினாலும், அது உளவியல், தார்மீகம் அல்லது மனித நோக்கங்களை நிர்வகிக்காது.$$,
 null
),

('88888888-8888-8888-8888-000000000414', 'fill_blank',
 $$14. A car takes a turn at $50$ m/s on a circular road of radius of curvature $10$ m. Calculate the centrifugal force experienced by a $60$ kg person inside the car.$$,
 $$14. ஒரு கார் $10$ m வளைவு ஆரமுள்ள வட்டப் பாதையில் $50$ m/s வேகத்தில் திரும்புகிறது. காருக்குள் இருக்கும் $60$ kg நபர் அனுபவிக்கும் மையவிலக்கு விசையைக் கணக்கிடவும்.$$,
 $${"blanks": [{"label": "Centrifugal force (N)", "type": "number", "correct": 15000}]}$$::jsonb,
 $${"blanks": [{"label": "மையவிலக்கு விசை (N)"}]}$$::jsonb,
 $$In the car's (rotating, non-inertial) frame, the person experiences a centrifugal force equal in magnitude to the centripetal force needed for the turn: $F = \dfrac{mv^2}{r} = \dfrac{60 \times 50^2}{10} = \dfrac{60 \times 2500}{10} = 15000$ N.$$,
 $$காரின் (சுழலும், நிலைமமற்ற) சட்டகத்தில், நபர் திருப்பத்திற்குத் தேவையான நோக்குமைய விசைக்கு சம அளவுள்ள மையவிலக்கு விசையை அனுபவிக்கிறார்: $F = \dfrac{mv^2}{r} = \dfrac{60 \times 2500}{10} = 15000$ N.$$,
 $$Don't forget to square the speed -- $50^2 = 2500$, not $50 \times 2 = 100$.$$,
 $$வேகத்தை வர்க்கமாக்க மறக்க வேண்டாம் — $50^2 = 2500$, $50 \times 2 = 100$ அல்ல.$$,
 'The magnitude of centrifugal force always equals the centripetal force required for that same motion -- they''re the same number, just opposite in direction and existing in different frames.',
 $$மையவிலக்கு விசையின் அளவு எப்போதும் அதே இயக்கத்திற்குத் தேவையான நோக்குமைய விசைக்குச் சமம் — அவை ஒரே எண், திசையில் மட்டும் எதிரானவை, வெவ்வேறு சட்டகங்களில் இருப்பவை.$$,
 null
),

('88888888-8888-8888-8888-000000000415', 'fill_blank',
 $$15. A long stick rests on a rough surface. A person standing $10$ m away wants an object of mass $0.5$ kg to slide along the surface and just reach the stick. With what minimum speed should the object be thrown (coefficient of kinetic friction $= 0.7$)?$$,
 $$15. ஒரு நீண்ட குச்சி கரடுமுரடான பரப்பில் உள்ளது. $10$ m தொலைவில் நிற்கும் ஒரு நபர், $0.5$ kg நிறையுள்ள ஒரு பொருள் பரப்பில் சறுக்கி குச்சியை சரியாக அடைய வேண்டும் என விரும்புகிறார். எந்த குறைந்தபட்ச வேகத்தில் அந்தப் பொருளை வீச வேண்டும் (இயக்க உராய்வு குணகம் $= 0.7$)?$$,
 $${"blanks": [{"label": "Minimum speed (m/s)", "type": "number", "correct": 11.71}]}$$::jsonb,
 $${"blanks": [{"label": "குறைந்தபட்ச வேகம் (m/s)"}]}$$::jsonb,
 $$Kinetic friction decelerates the sliding object at $a = \mu_k g = 0.7 \times 9.8 = 6.86$ m/s². For it to just stop (final velocity $= 0$) after travelling $d=10$ m: $v^2 = 2ad = 2 \times 6.86 \times 10 = 137.2 \Rightarrow v = \sqrt{137.2} \approx 11.71$ m/s.$$,
 $$இயக்க உராய்வு சறுக்கும் பொருளை $a = \mu_k g = 0.7 \times 9.8 = 6.86$ m/s² இல் மந்தப்படுத்துகிறது. $d=10$ m சென்ற பிறகு அது சரியாக நிற்க (இறுதி வேகம் $= 0$): $v^2 = 2ad = 2 \times 6.86 \times 10 = 137.2 \Rightarrow v = \sqrt{137.2} \approx 11.71$ m/s.$$,
 $$This uses the same $v^2 = u^2 + 2as$ kinematics relation as any deceleration problem -- friction's role is just to set the value of $a$ via $a=\mu_k g$.$$,
 $$இது எந்த மந்தப்படுத்தும் பிரச்சினையையும் போலவே அதே $v^2 = u^2 + 2as$ இயக்கவியல் தொடர்பைப் பயன்படுத்துகிறது — உராய்வின் பங்கு $a=\mu_k g$ வழியாக $a$ இன் மதிப்பை நிர்ணயிப்பது மட்டுமே.$$,
 'Friction turns a "how far does it slide" problem into ordinary constant-deceleration kinematics -- the friction coefficient just sets the deceleration rate.',
 $$உராய்வு "எவ்வளவு தூரம் சறுக்கும்" என்ற பிரச்சினையை சாதாரண மாறா-மந்தமாக்கும் இயக்கவியலாக மாற்றுகிறது — உராய்வு குணகம் மந்தப்படுத்தும் வீதத்தை நிர்ணயிக்கிறது.$$,
 null
)
on conflict (id) do nothing;

insert into physics_ip_steps (id, lesson_id, step_type, title, title_ta, body_text, body_text_ta, diagram_key, question_id, order_index) values

('99999999-9999-9999-9999-000000000419', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000401', 2),
('99999999-9999-9999-9999-000000000420', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000402', 3),
('99999999-9999-9999-9999-000000000421', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000403', 4),
('99999999-9999-9999-9999-000000000422', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000404', 5),
('99999999-9999-9999-9999-000000000423', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000405', 6),
('99999999-9999-9999-9999-000000000424', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000406', 7),
('99999999-9999-9999-9999-000000000425', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000407', 8),
('99999999-9999-9999-9999-000000000426', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000408', 9),
('99999999-9999-9999-9999-000000000427', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000409', 10),
('99999999-9999-9999-9999-000000000428', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000410', 11),
('99999999-9999-9999-9999-000000000429', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000411', 12),
('99999999-9999-9999-9999-000000000430', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000412', 13),
('99999999-9999-9999-9999-000000000431', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000413', 14),
('99999999-9999-9999-9999-000000000432', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000414', 15),
('99999999-9999-9999-9999-000000000433', '77777777-7777-7777-7777-000000000010', 'question', null, null, null, null, null, '88888888-8888-8888-8888-000000000415', 16)
on conflict (id) do nothing;
