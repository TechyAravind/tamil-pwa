-- ============================================================
-- Interactive Physics — Phase 1.5 & 1.6 content
-- Run AFTER physics_interactive_schema_v3.sql.
--
--   1. takeaway_fact for every existing question (Phase 1.5)
--   2. Curated physics_formulas rows for the whole chapter,
--      grouped by the 7 Main Sub Topics (Phase 1.6 -- Formulas tab)
-- ============================================================

-- ---------- Lesson: Why Do Things Move? ----------
update physics_ip_questions set takeaway_fact = $$On a truly frictionless surface, motion needs no force to continue -- only to change.$$, takeaway_fact_ta = $$உண்மையிலேயே உராய்வற்ற மேற்பரப்பில், இயக்கத்தைத் தொடர விசை தேவையில்லை — அதை மாற்றவே தேவை.$$ where id = '88888888-8888-8888-8888-000000000101';
update physics_ip_questions set takeaway_fact = $$The flatter the ramp, the more clearly inertia reveals itself.$$, takeaway_fact_ta = $$தளம் எவ்வளவு தட்டையாக இருக்கிறதோ, மந்தம் (inertia) அவ்வளவு தெளிவாக வெளிப்படும்.$$ where id = '88888888-8888-8888-8888-000000000102';
update physics_ip_questions set takeaway_fact = $$Aristotle tied force to motion; Galileo and Newton split them apart.$$, takeaway_fact_ta = $$அரிஸ்டாட்டில் விசையையும் இயக்கத்தையும் இணைத்தார்; கலீலியோவும் நியூட்டனும் அவற்றைப் பிரித்தனர்.$$ where id = '88888888-8888-8888-8888-000000000103';
update physics_ip_questions set takeaway_fact = $$Removing friction doesn't remove motion -- it removes the thing that WAS stopping the motion.$$, takeaway_fact_ta = $$உராய்வை நீக்குவது இயக்கத்தை நீக்காது — இயக்கத்தை நிறுத்திக் கொண்டிருந்த காரணியை நீக்குகிறது.$$ where id = '88888888-8888-8888-8888-000000000104';
update physics_ip_questions set takeaway_fact = $$As the ramp angle shrinks, the distance needed to regain height grows without bound.$$, takeaway_fact_ta = $$சரிவுக் கோணம் குறையக் குறைய, உயரத்தை மீண்டும் அடைய தேவையான தூரம் எல்லையின்றி அதிகரிக்கிறது.$$ where id = '88888888-8888-8888-8888-000000000105';

-- ---------- Lesson: Who's Really Moving? Reference Frames ----------
update physics_ip_questions set takeaway_fact = $$A frame is inertial only while it moves at constant velocity -- acceleration breaks that.$$, takeaway_fact_ta = $$ஒரு சட்டகம் மாறா வேகத்தில் நகரும்போது மட்டுமே நிலைமமானது — முடுக்கம் அதை மீறுகிறது.$$ where id = '88888888-8888-8888-8888-000000000106';
update physics_ip_questions set takeaway_fact = $$Switching reference frames just subtracts velocities; nothing physical about the objects changes.$$, takeaway_fact_ta = $$சார்பு சட்டகத்தை மாற்றுவது வேகங்களைக் கழிப்பது மட்டுமே; பொருட்களைப் பற்றிய இயற்பியல் எதுவும் மாறாது.$$ where id = '88888888-8888-8888-8888-000000000107';
update physics_ip_questions set takeaway_fact = $$Being "at rest in your own frame" is true by definition, in every frame you choose.$$, takeaway_fact_ta = $$"உங்கள் சொந்த சட்டகத்தில் நிலையாக இருப்பது" என்பது நீங்கள் தேர்ந்தெடுக்கும் ஒவ்வொரு சட்டகத்திலும் வரையறையால் உண்மை.$$ where id = '88888888-8888-8888-8888-000000000108';
update physics_ip_questions set takeaway_fact = $$Inertial frames can move relative to each other -- "at rest" is never absolute, only relative to a chosen frame.$$, takeaway_fact_ta = $$நிலைமம் சட்டகங்கள் ஒன்றையொன்று பொறுத்து நகரலாம் — "நிலையானது" என்பது ஒருபோதும் முழுமையானதல்ல, தேர்ந்தெடுக்கப்பட்ட சட்டகத்தைப் பொறுத்தே.$$ where id = '88888888-8888-8888-8888-000000000109';

-- ---------- Lesson: The Three Rules That Run the Universe ----------
update physics_ip_questions set takeaway_fact = $$For a fixed force, acceleration and mass are inversely proportional.$$, takeaway_fact_ta = $$ஒரு நிலையான விசைக்கு, முடுக்கமும் திணிவும் நேர்மாறு விகிதத்தில் உள்ளன.$$ where id = '88888888-8888-8888-8888-000000000004';
update physics_ip_questions set takeaway_fact = $$Exactly two real forces act on a swinging pendulum bob -- weight and tension. Motion itself never needs its own force.$$, takeaway_fact_ta = $$ஊசலாடும் பந்தின் மீது சரியாக இரண்டு உண்மையான விசைகள் மட்டுமே செயல்படுகின்றன — எடை மற்றும் இழுவிசை.$$ where id = '88888888-8888-8888-8888-000000000005';
update physics_ip_questions set takeaway_fact = $$Action-reaction pairs act on two different objects, so they never cancel out a system's own acceleration.$$, takeaway_fact_ta = $$செயல்-எதிர்செயல் ஜோடிகள் இரண்டு வெவ்வேறு பொருட்கள் மீது செயல்படுகின்றன, எனவே அவை ஒரு அமைப்பின் சொந்த முடுக்கத்தை ஒருபோதும் ரத்து செய்யாது.$$ where id = '88888888-8888-8888-8888-000000000006';
update physics_ip_questions set takeaway_fact = $$Newton's three laws describe three separate ideas: staying in motion, changing motion, and paired forces.$$, takeaway_fact_ta = $$நியூட்டனின் மூன்று விதிகள் மூன்று தனித்தனி கருத்துகளை விவரிக்கின்றன: இயக்கத்தில் தொடர்தல், இயக்கத்தை மாற்றுதல், ஜோடி விசைகள்.$$ where id = '88888888-8888-8888-8888-000000000007';

-- ---------- Lesson: Reading a Force Diagram ----------
update physics_ip_questions set takeaway_fact = $$On flat ground with nothing else acting, normal force always equals weight.$$, takeaway_fact_ta = $$தட்டையான தரையில், வேறு எதுவும் செயல்படாதபோது, இயல்விசை எப்போதும் எடைக்குச் சமமாக இருக்கும்.$$ where id = '88888888-8888-8888-8888-000000000008';
update physics_ip_questions set takeaway_fact = $$Tilting a surface splits weight into two components -- only one of which the normal force balances.$$, takeaway_fact_ta = $$ஒரு மேற்பரப்பைச் சாய்ப்பது எடையை இரண்டு கூறுகளாகப் பிரிக்கிறது — இயல்விசை அவற்றில் ஒன்றை மட்டுமே சமன் செய்கிறது.$$ where id = '88888888-8888-8888-8888-000000000009';
update physics_ip_questions set takeaway_fact = $$Every extra weight pressing down on an object must be carried by the normal force beneath it.$$, takeaway_fact_ta = $$ஒரு பொருளின் மீது கூடுதலாக அழுத்தும் எடையை, அதற்குக் கீழே உள்ள இயல்விசை தாங்க வேண்டும்.$$ where id = '88888888-8888-8888-8888-000000000010';
update physics_ip_questions set takeaway_fact = $$The steeper the incline, the smaller the fraction of weight the normal force has to support.$$, takeaway_fact_ta = $$சரிவு எவ்வளவு செங்குத்தாக இருக்கிறதோ, இயல்விசை தாங்க வேண்டிய எடையின் பங்கு அவ்வளவு குறையும்.$$ where id = '88888888-8888-8888-8888-000000000011';

-- ---------- Lesson: Three Forces in Balance ----------
update physics_ip_questions set takeaway_fact = $$Splitting a hanging weight between two supporting chains always costs you a cos(theta) factor.$$, takeaway_fact_ta = $$தொங்கும் எடையை இரண்டு சங்கிலிகளுக்கிடையே பிரிப்பது எப்போதும் cos(theta) காரணியை உள்ளடக்கியது.$$ where id = '88888888-8888-8888-8888-000000000012';
update physics_ip_questions set takeaway_fact = $$Lami's theorem only needs three concurrent, coplanar forces in equilibrium -- no equal magnitudes or right angles required.$$, takeaway_fact_ta = $$லாமியின் தேற்றத்திற்கு சமநிலையில் உள்ள மூன்று ஒரே தளத்து, ஒரே புள்ளியில் இணையும் விசைகள் மட்டுமே தேவை.$$ where id = '88888888-8888-8888-8888-000000000013';
update physics_ip_questions set takeaway_fact = $$At theta = 0, Lami's general formula collapses back to the simple mg/2 you'd expect.$$, takeaway_fact_ta = $$theta = 0 இல், லாமியின் பொது சூத்திரம் எளிய mg/2 என்பதற்குத் திரும்பும்.$$ where id = '88888888-8888-8888-8888-000000000014';

-- ---------- Lesson: What Never Changes in a Collision ----------
update physics_ip_questions set takeaway_fact = $$A gun's recoil momentum always exactly matches the bullet's forward momentum.$$, takeaway_fact_ta = $$துப்பாக்கியின் பின்தள்ளும் உந்தம் எப்போதும் தோட்டாவின் முன்னோக்கிய உந்தத்திற்குச் சமமாக இருக்கும்.$$ where id = '88888888-8888-8888-8888-000000000015';
update physics_ip_questions set takeaway_fact = $$Momentum conservation only holds when no outside force acts on the system -- internal forces never break it.$$, takeaway_fact_ta = $$அமைப்பின் மீது வெளிப்புற விசை இல்லாதபோது மட்டுமே உந்த அழிவின்மை பொருந்தும் — உள் விசைகள் அதை ஒருபோதும் மீறாது.$$ where id = '88888888-8888-8888-8888-000000000016';
update physics_ip_questions set takeaway_fact = $$Recoil speed tracks bullet momentum, not bullet speed alone -- mass matters just as much.$$, takeaway_fact_ta = $$பின்தள்ளும் வேகம் தோட்டாவின் உந்தத்தைப் பின்பற்றுகிறது, வேகத்தை மட்டும் அல்ல — திணிவும் அதே அளவு முக்கியம்.$$ where id = '88888888-8888-8888-8888-000000000017';

-- ---------- Lesson: The Force That Almost Stops Everything ----------
update physics_ip_questions set takeaway_fact = $$Static friction isn't fixed -- it grows to match your push, right up to its maximum.$$, takeaway_fact_ta = $$நிலை உராய்வு நிலையானதல்ல — அது உங்கள் தள்ளுதலுக்கு ஏற்ப, அதன் அதிகபட்சம் வரை அதிகரிக்கும்.$$ where id = '88888888-8888-8888-8888-000000000018';
update physics_ip_questions set takeaway_fact = $$An object stays put exactly as long as the pulling force stays under the maximum static friction available.$$, takeaway_fact_ta = $$இழுக்கும் விசை கிடைக்கக்கூடிய அதிகபட்ச நிலை உராய்வுக்குக் கீழே இருக்கும் வரை, ஒரு பொருள் அசையாமல் இருக்கும்.$$ where id = '88888888-8888-8888-8888-000000000019';
update physics_ip_questions set takeaway_fact = $$Constant velocity means the net force is zero, not that no forces are acting at all.$$, takeaway_fact_ta = $$மாறா வேகம் என்றால் நிகர விசை பூஜ்ஜியம் என்று பொருள், விசைகளே இல்லை என்று அல்ல.$$ where id = '88888888-8888-8888-8888-000000000020';
update physics_ip_questions set takeaway_fact = $$Rougher surface pairs have higher friction coefficients, so they resist the start of sliding more strongly.$$, takeaway_fact_ta = $$கரடுமுரடான மேற்பரப்பு ஜோடிகள் அதிக உராய்வு குணகத்தைக் கொண்டவை, எனவே சறுக்கத் தொடங்குவதை அதிகமாக எதிர்க்கும்.$$ where id = '88888888-8888-8888-8888-000000000021';

-- ---------- Lesson: Why You Feel Pushed Outward on a Turn ----------
update physics_ip_questions set takeaway_fact = $$Centripetal force always points toward the center, never outward.$$, takeaway_fact_ta = $$நோக்குமைய விசை எப்போதும் மையத்தை நோக்கியே செயல்படும், வெளிநோக்கி ஒருபோதும் இல்லை.$$ where id = '88888888-8888-8888-8888-000000000022';
update physics_ip_questions set takeaway_fact = $$On a frictionless banked curve, the banking angle alone -- combined with speed and radius -- decides the safe turning speed.$$, takeaway_fact_ta = $$உராய்வற்ற சாய்வான வளைவில், சாய்வுக் கோணம் மட்டுமே — வேகம் மற்றும் ஆரத்துடன் சேர்ந்து — பாதுகாப்பான திருப்பு வேகத்தை தீர்மானிக்கிறது.$$ where id = '88888888-8888-8888-8888-000000000023';
update physics_ip_questions set takeaway_fact = $$Centrifugal force only exists if you choose to work inside the rotating frame -- it's not a real, source-based force.$$, takeaway_fact_ta = $$சுழலும் சட்டகத்திற்குள் வேலை செய்யத் தேர்ந்தெடுத்தால் மட்டுமே மையவிலக்கு விசை உள்ளது — இது ஒரு உண்மையான விசை அல்ல.$$ where id = '88888888-8888-8888-8888-000000000024';
update physics_ip_questions set takeaway_fact = $$Whatever supplies the inward pull -- tension, gravity, or friction -- IS the centripetal force in that scenario.$$, takeaway_fact_ta = $$உள்நோக்கிய இழுவையை எது வழங்குகிறதோ — இழுவிசை, ஈர்ப்பு, அல்லது உராய்வு — அதுவே அந்த சூழ்நிலையில் நோக்குமைய விசை.$$ where id = '88888888-8888-8888-8888-000000000025';


-- ============================================================
-- Curated Formulas -- one row per formula, grouped by Main Sub Topic
-- Fixed UUIDs (prefix bbbbbbbb-...) so re-running this file never
-- duplicates rows, consistent with this project's idempotent pattern.
-- ============================================================
insert into physics_formulas (id, chapter_id, group_key, formula_latex, description, description_ta, order_index) values

('bbbbbbbb-bbbb-bbbb-bbbb-000000000001', '22222222-2222-2222-2222-222222220003', 'introduction', 'd = \dfrac{h}{\sin\theta}',
 'Horizontal distance a ball must travel on a ramp of angle theta to regain its starting height h (Galileo''s ramp experiment).',
 $$கலீலியோவின் சரிவுத்தள சோதனையில், h உயரத்தை மீண்டும் அடைய, theta கோணத்தில் உள்ள தளத்தில் பந்து செல்ல வேண்டிய கிடைமட்டத் தூரம்.$$, 1),

('bbbbbbbb-bbbb-bbbb-bbbb-000000000002', '22222222-2222-2222-2222-222222220003', 'newtons_laws', '\sum F = 0 \Rightarrow v = \text{constant}',
 $$Newton's First Law: with zero net force, velocity never changes.$$, $$நியூட்டனின் முதல் விதி: நிகர விசை பூஜ்ஜியமாக இருந்தால், திசைவேகம் ஒருபோதும் மாறாது.$$, 1),
('bbbbbbbb-bbbb-bbbb-bbbb-000000000003', '22222222-2222-2222-2222-222222220003', 'newtons_laws', 'F = ma',
 $$Newton's Second Law: net force equals mass times acceleration.$$, $$நியூட்டனின் இரண்டாம் விதி: நிகர விசை என்பது திணிவு பெருக்கல் முடுக்கம்.$$, 2),
('bbbbbbbb-bbbb-bbbb-bbbb-000000000004', '22222222-2222-2222-2222-222222220003', 'newtons_laws', 'F_{12} = -F_{21}',
 $$Newton's Third Law: action and reaction act on two different objects, equal and opposite.$$, $$நியூட்டனின் மூன்றாம் விதி: செயல் மற்றும் எதிர்செயல் இரண்டு வெவ்வேறு பொருட்கள் மீது சமமாகவும் எதிர் திசையிலும் செயல்படும்.$$, 3),
('bbbbbbbb-bbbb-bbbb-bbbb-000000000005', '22222222-2222-2222-2222-222222220003', 'newtons_laws', 'v_{rel} = v_A - v_B',
 $$Relative velocity of object A as seen from object B's reference frame.$$, $$B இன் சார்பு சட்டகத்தில் இருந்து பார்க்கும்போது A இன் சார்பு வேகம்.$$, 4),

('bbbbbbbb-bbbb-bbbb-bbbb-000000000006', '22222222-2222-2222-2222-222222220003', 'application', 'N = mg',
 'Normal force on flat ground when only weight and normal force act on an object.', $$தட்டையான தரையில், எடையும் இயல்விசையும் மட்டும் செயல்படும்போது இயல்விசை.$$, 1),
('bbbbbbbb-bbbb-bbbb-bbbb-000000000007', '22222222-2222-2222-2222-222222220003', 'application', 'N = mg\cos\theta',
 'Normal force on a frictionless incline tilted at angle theta.', $$theta கோணத்தில் சாய்ந்த உராய்வற்ற தளத்தில் இயல்விசை.$$, 2),

('bbbbbbbb-bbbb-bbbb-bbbb-000000000008', '22222222-2222-2222-2222-222222220003', 'lamis_theorem', '\dfrac{F_1}{\sin\alpha_1} = \dfrac{F_2}{\sin\alpha_2} = \dfrac{F_3}{\sin\alpha_3}',
 $$Lami's Theorem, for three concurrent, coplanar forces in equilibrium.$$, $$சமநிலையில் உள்ள மூன்று ஒரே தளத்து, ஒரே புள்ளியில் இணையும் விசைகளுக்கான லாமியின் தேற்றம்.$$, 1),
('bbbbbbbb-bbbb-bbbb-bbbb-000000000009', '22222222-2222-2222-2222-222222220003', 'lamis_theorem', 'T = \dfrac{mg}{2\cos\theta}',
 'Tension in each of two symmetric chains supporting a hanging weight.', $$தொங்கும் எடையைத் தாங்கும் இரு சமச்சீர் சங்கிலிகளில் ஒவ்வொன்றிலும் உள்ள இழுவிசை.$$, 2),

('bbbbbbbb-bbbb-bbbb-bbbb-000000000010', '22222222-2222-2222-2222-222222220003', 'momentum', 'm_1 v_1 = m_2 v_2',
 'Conservation of linear momentum for an isolated system starting at rest (e.g. a recoiling gun).', $$ஓய்வு நிலையில் தொடங்கும் தனிமைப்படுத்தப்பட்ட அமைப்புக்கான நேர்கோட்டு உந்த அழிவின்மை (எ.கா. பின்தள்ளும் துப்பாக்கி).$$, 1),

('bbbbbbbb-bbbb-bbbb-bbbb-000000000011', '22222222-2222-2222-2222-222222220003', 'friction', 'f_{max} = \mu_s N',
 'Maximum static friction available before an object starts to slide.', $$ஒரு பொருள் சறுக்கத் தொடங்குவதற்கு முன் கிடைக்கக்கூடிய அதிகபட்ச நிலை உராய்வு.$$, 1),
('bbbbbbbb-bbbb-bbbb-bbbb-000000000012', '22222222-2222-2222-2222-222222220003', 'friction', 'f_k = \mu_k N',
 'Kinetic friction acting on an object while it is sliding.', $$ஒரு பொருள் சறுக்கிக் கொண்டிருக்கும்போது அதன் மீது செயல்படும் இயக்க உராய்வு.$$, 2),

('bbbbbbbb-bbbb-bbbb-bbbb-000000000013', '22222222-2222-2222-2222-222222220003', 'circular_motion', 'F = \dfrac{mv^2}{r}',
 'Centripetal force needed to keep an object moving in a circle of radius r at speed v.', $$r ஆரத்தில் v வேகத்தில் ஒரு பொருளை வட்டப்பாதையில் வைத்திருக்க தேவையான நோக்குமைய விசை.$$, 1),
('bbbbbbbb-bbbb-bbbb-bbbb-000000000014', '22222222-2222-2222-2222-222222220003', 'circular_motion', 'v = \sqrt{rg\tan\theta}',
 'Safe turning speed on a frictionless banked curve.', $$உராய்வற்ற சாய்வான வளைவில் பாதுகாப்பான திருப்பு வேகம்.$$, 2)

on conflict (id) do nothing;
