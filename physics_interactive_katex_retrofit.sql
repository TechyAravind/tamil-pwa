-- ============================================================
-- Interactive Physics — KaTeX Retrofit for Lessons 2-7
--
-- Run this AFTER physics_interactive_schema_v2.sql and
-- physics_interactive_seed_ch3_v2.sql.
--
-- Lessons 1 and "Reference Frames" were already written with
-- proper $...$ LaTeX math. This patch rewrites the remaining
-- original 6 lessons' text (prompts, explanations, common
-- mistakes, step bodies, and fill-blank labels) so formulas and
-- units render as real typeset math (superscripts, fractions,
-- Greek letters) instead of plain-text "^2" / "theta" / "x".
-- Wording and numbers are unchanged -- only notation.
--
-- Idempotent: plain UPDATEs by fixed id, safe to re-run.
-- ============================================================

-- ---------- LESSON "The Three Rules That Run the Universe" ----------

update physics_ip_questions set
  explanation_text = $$$a = F/m$. For 4 kg: $8/4 = 2\ \text{m/s}^2$. For 20 kg: $8/20 = 0.4\ \text{m/s}^2$. The heavier block accelerates five times slower for the same force -- acceleration is inversely proportional to mass.$$,
  data = $${"blanks": [{"label": "Acceleration of 4 kg block ($\\text{m/s}^2$)", "type": "number", "correct": 2}, {"label": "Acceleration of 20 kg block ($\\text{m/s}^2$)", "type": "number", "correct": 0.4}]}$$::jsonb
where id = '88888888-8888-8888-8888-000000000004';

update physics_ip_questions set
  prompt_text = $$Solve the horse-and-cart puzzle. The horse pulls the cart forward with force $F_h$. By Newton's Third Law, the cart pulls the horse backward with force $F_c$. How does $F_c$ compare to $F_h$, do the two forces act on the same object or two different objects, and what actually pushes the horse forward?$$,
  data = $${"blanks": [{"label": "$F_c$ compared to $F_h$", "type": "dropdown", "choices": ["greater than", "less than", "equal to"], "correct": "equal to"}, {"label": "$F_h$ and $F_c$ act on", "type": "dropdown", "choices": ["the same object", "two different objects"], "correct": "two different objects"}, {"label": "The horse is pushed forward by", "type": "dropdown", "choices": ["the ground, through friction on its hooves", "the cart", "the air"], "correct": "the ground, through friction on its hooves"}]}$$::jsonb,
  explanation_text = $$$F_h$ acts ON the cart; $F_c$ acts ON the horse -- two different objects, so they never cancel in the same free-body diagram. What actually moves the system forward is the ground pushing the horse's hooves forward (friction), which is bigger than the backward pull of the cart.$$
where id = '88888888-8888-8888-8888-000000000006';

update physics_ip_steps set
  body_text = $$First Law (Inertia): an object keeps doing what it's already doing -- staying still or moving at constant velocity -- unless a net force acts on it. This resistance to changing motion is called inertia; heavier objects have more of it.

Second Law ($F = ma$): a net force causes an object to accelerate. More force means more acceleration; more mass means less acceleration for the same force. This single equation lets us calculate motion whenever we know the forces involved.

Third Law (Action-Reaction): whenever one object pushes or pulls on a second object, the second object pushes or pulls back on the first with equal strength, in the opposite direction. These two forces always act on two DIFFERENT objects -- never the same one -- which is the key to solving the horse-and-cart puzzle above.$$
where id = '99999999-9999-9999-9999-000000000008';

update physics_ip_steps set
  body_text = $$Two objects -- one of mass 2.5 kg, one of mass 100 kg -- each feel the exact same 5 N push. What acceleration does each one experience?

Using Newton's Second Law, $a = F/m$.

For the 2.5 kg object: $a = 5/2.5 = 2\ \text{m/s}^2$.
For the 100 kg object: $a = 5/100 = 0.05\ \text{m/s}^2$.

Same force, wildly different results -- the heavier object barely notices the push. This is why a gentle shove moves a bicycle easily but does almost nothing to a parked car: mass resists acceleration.$$
where id = '99999999-9999-9999-9999-000000000009';


-- ---------- LESSON "Reading a Force Diagram" ----------

update physics_ip_questions set
  prompt_text = $$A 5 kg object rests on flat, horizontal ground ($g = 9.8\ \text{m/s}^2$). Since it isn't accelerating, find the normal force $N$.$$,
  explanation_text = $$On flat ground, $N = mg = 5 \times 9.8 = 49\ \text{N}$. Weight and normal force are the only two forces, and they must balance exactly since there's no vertical acceleration.$$
where id = '88888888-8888-8888-8888-000000000008';

update physics_ip_questions set
  prompt_text = $$A 4 kg block rests on a frictionless incline tilted at 30°. Find the normal force acting on it. ($\cos 30° \approx 0.87$, $g = 9.8\ \text{m/s}^2$)$$,
  explanation_text = $$$N = mg\cos\theta = 4 \times 9.8 \times 0.87 = 34.10\ \text{N}$ -- noticeably less than the full weight of 39.2 N, because part of the weight now acts down the slope instead of into it.$$
where id = '88888888-8888-8888-8888-000000000009';

update physics_ip_questions set
  explanation_text = $$$N = mg\cos\theta$, and $\cos\theta$ shrinks as $\theta$ grows. So the gentlest slope (10°) has the largest normal force, and the steepest (70°) has the smallest -- most of the weight has "tipped over" into pulling the object down the slope instead of into it.$$
where id = '88888888-8888-8888-8888-000000000011';

update physics_ip_steps set
  body_text = $$A free body diagram is a simple sketch of a single object with an arrow for every force acting on it -- nothing else. The four forces you'll draw again and again are: weight ($mg$, always straight down), the normal force ($N$, always perpendicular to the surface, pushing the object away from it), tension ($T$, along a string or rope, pulling), and friction ($f$, along the surface, opposing sliding or attempted sliding).

On a flat, horizontal surface, weight and normal force point in exactly opposite directions, so they cancel and $N = mg$. But tilt the surface into a ramp, and weight still points straight down while the normal force stays perpendicular to the ramp -- they're no longer simple opposites of each other anymore.$$
where id = '99999999-9999-9999-9999-000000000015';

update physics_ip_steps set
  body_text = $$An object rests on a frictionless surface tilted at angle $\theta$. Since the object doesn't accelerate perpendicular to the ramp, the forces in that direction must balance: the normal force $N$ exactly cancels the perpendicular component of weight.

The perpendicular component of weight is $mg\cos\theta$, so: $N = mg\cos\theta$.

Notice this is smaller than the full weight $mg$, since $\cos\theta$ is less than 1 for any tilt -- some of the weight is "used up" pulling the object down the slope instead of into the surface. That's the extra pull you feel pushing a cart uphill: part of its weight now acts along the direction you're pushing.$$
where id = '99999999-9999-9999-9999-000000000016';


-- ---------- LESSON "Three Forces in Balance" ----------

update physics_ip_questions set
  prompt_text = $$A 12 kg baby hangs from two identical chains, each at 20° from the vertical ($\cos 20° \approx 0.94$, $g = 9.8\ \text{m/s}^2$). Find the tension in each chain.$$,
  explanation_text = $$$T = \dfrac{mg}{2\cos\theta} = \dfrac{12 \times 9.8}{2 \times 0.94} = \dfrac{117.6}{1.88} = 62.6\ \text{N}$ per chain.$$
where id = '88888888-8888-8888-8888-000000000012';

update physics_ip_questions set
  data = $${"left": ["$mg$", "$T$ (each chain)", "$\\theta = 0°$"], "right": ["Special case where each chain simply carries half the weight", "The baby's weight, acting straight down", "The tension in each identical chain, acting along the chain"], "correct_pairs": [[0,1],[1,2],[2,0]]}$$::jsonb
where id = '88888888-8888-8888-8888-000000000014';

update physics_ip_steps set
  body_text = $$When exactly three forces act at a single point and keep it in equilibrium (no net force), Lami's theorem says: each force, divided by the sine of the angle between the OTHER two forces, gives the same value for all three.

In symbols: $\dfrac{F_1}{\sin(\text{angle opposite } F_1)} = \dfrac{F_2}{\sin(\text{angle opposite } F_2)} = \dfrac{F_3}{\sin(\text{angle opposite } F_3)}$.

It's a shortcut -- instead of separately resolving every force into x and y components, you can often read the answer straight off a force triangle.$$
where id = '99999999-9999-9999-9999-000000000022';

update physics_ip_steps set
  body_text = $$A baby of weight $mg$ hangs from two identical chains, each making angle $\theta$ with the vertical. By symmetry, both chains carry the same tension $T$.

Balancing the vertical forces (both chains contribute equally): $2T\cos\theta = mg$, so $T = \dfrac{mg}{2\cos\theta}$.

Check: when $\theta = 0°$ (chains hang straight down), $T = mg/2$ -- each chain simply carries half the weight, exactly as expected.$$
where id = '99999999-9999-9999-9999-000000000023';


-- ---------- LESSON "What Never Changes in a Collision" ----------

update physics_ip_questions set
  explanation_text = $$$m_{bullet}\, v_{bullet} = m_{gun}\, v_{gun}$, so $0.02 \times 300 = 3 \times v_{gun}$, giving $v_{gun} = 6/3 = 2\ \text{m/s}$.$$
where id = '88888888-8888-8888-8888-000000000015';

update physics_ip_questions set
  explanation_text = $$Compare bullet momentum (mass $\times$ speed), since recoil speed is proportional to it for equal gun masses: A $= 0.01 \times 500 = 5$, B $= 0.02 \times 300 = 6$, C $= 0.01 \times 200 = 2$. So the order from greatest to smallest recoil is B, A, C.$$
where id = '88888888-8888-8888-8888-000000000017';

update physics_ip_steps set
  body_text = $$For an isolated system (no external force acting on it), total momentum before an event always equals total momentum after it -- this is the law of conservation of linear momentum. It doesn't matter how complicated the internal forces are (an explosion, a collision, a spring releasing); if nothing from outside pushes or pulls on the system, its total momentum cannot change.

Before firing, gun and bullet are both at rest, so total momentum $= 0$. After firing, the bullet carries forward momentum -- so the gun MUST carry exactly equal backward momentum to keep the total at zero. That backward momentum is what we feel as recoil.$$
where id = '99999999-9999-9999-9999-000000000028';

update physics_ip_steps set
  body_text = $$A 2 kg gun fires a 0.01 kg bullet at 400 m/s. Find the gun's recoil speed.

Total momentum starts at zero, so it must stay at zero: (momentum of bullet) + (momentum of gun) $= 0$.

$m_{bullet}\, v_{bullet} = m_{gun}\, v_{gun}$
$0.01 \times 400 = 2 \times v_{gun}$
$v_{gun} = 4/2 = 2\ \text{m/s}$.

The much heavier gun recoils at a much smaller speed than the bullet's -- same momentum, shared very unequally because of the huge mass difference.$$
where id = '99999999-9999-9999-9999-000000000029';


-- ---------- LESSON "The Force That Almost Stops Everything" ----------

update physics_ip_questions set
  prompt_text = $$A 10 kg block on a table (static friction coefficient 0.5) is connected over a pulley to a hanging mass $m_2$. Find the maximum static friction available, and the largest $m_2$ can be before the block starts to slide. ($g = 9.8\ \text{m/s}^2$)$$,
  explanation_text = $$Maximum static friction $= 0.5 \times 10 \times 9.8 = 49\ \text{N}$. The block slides once the hanging weight ($m_2 g$) exceeds this, i.e. $m_2 > 49/9.8 = 5$ kg.$$
where id = '88888888-8888-8888-8888-000000000019';

update physics_ip_steps set
  body_text = $$Static friction resists the START of sliding. It's not a fixed value -- it automatically adjusts to match whatever force you apply, up to a maximum: maximum static friction $= \mu_s N$ (coefficient of static friction $\times$ normal force). As long as your push stays below this maximum, static friction matches it exactly and nothing moves.

Once your push exceeds that maximum, the object breaks free and starts sliding. Now kinetic friction takes over -- usually a bit weaker than the maximum static friction, and roughly constant while sliding continues.$$
where id = '99999999-9999-9999-9999-000000000034';

update physics_ip_steps set
  body_text = $$A 7 kg block sits on a table (static friction coefficient 0.9 between block and table), connected by a string over a pulley to a hanging 5 kg mass. Will the 7 kg block move?

Step 1 -- Maximum static friction available: $0.9 \times 7 \times 9.8 = 61.74\ \text{N}$.

Step 2 -- Force actually trying to pull the block: the string tension equals the hanging weight, $5 \times 9.8 = 49\ \text{N}$.

Step 3 -- Compare: $49\ \text{N} < 61.74\ \text{N}$, so static friction can easily match the pull. The block stays put.

To make it slide, the hanging mass would need to exceed $0.9 \times 7 = 6.3$ kg.$$
where id = '99999999-9999-9999-9999-000000000035';


-- ---------- LESSON "Why You Feel Pushed Outward on a Turn" ----------

update physics_ip_questions set
  explanation_text = $$Centripetal force $= \dfrac{mv^2}{r} = \dfrac{0.5 \times 16}{2} = 4\ \text{N}$.$$
where id = '88888888-8888-8888-8888-000000000022';

update physics_ip_questions set
  prompt_text = $$A circular road of radius 20 m is banked at 15° ($\tan 15° \approx 0.27$, $g = 9.8\ \text{m/s}^2$). Find the safe turning speed for a car on this banked road, assuming no friction is needed. ($v = \sqrt{rg\tan\theta}$)$$,
  explanation_text = $$$v = \sqrt{rg\tan\theta} = \sqrt{20 \times 9.8 \times 0.27} = \sqrt{52.92} = 7.3\ \text{m/s}$.$$
where id = '88888888-8888-8888-8888-000000000023';

update physics_ip_steps set
  body_text = $$When a car takes a sharp turn, your body seems to get thrown toward the outside of the curve. It feels exactly like a real push. But if you were watching from above the road (an inertial frame), you'd see something different: there's no outward force at all -- just your body trying to keep going in a straight line while the car curves away underneath you.$$
where id = '99999999-9999-9999-9999-000000000040';

update physics_ip_steps set
  body_text = $$Any object moving in a circle needs a net force pointing toward the center, called the centripetal force: $F = \dfrac{mv^2}{r}$. Without it, the object would simply travel in a straight line (Newton's First Law). This is a real force -- supplied by tension in a string, gravity for orbiting planets, or friction for a car on a curve.

Centrifugal force is different: it only shows up if you insist on analyzing the motion from inside the rotating frame (like sitting in the turning car). From that viewpoint, an object at rest needs an outward pseudo-force to explain why it isn't accelerating inward with everything else. It's not a force from any physical source -- it's what inertia looks like when you're the one turning.$$
where id = '99999999-9999-9999-9999-000000000041';

update physics_ip_steps set
  body_text = $$A 0.25 kg stone tied to a string moves in a circle of radius 3 m at a constant speed of 2 m/s. Find the tension in the string.

The string supplies the centripetal force, so $T = \dfrac{mv^2}{r}$.

$T = \dfrac{0.25 \times 2^2}{3} = \dfrac{0.25 \times 4}{3} = \dfrac{1}{3} = 0.333\ \text{N}$.

That's the entire tension in the string -- not because the stone is "flying outward," but because it takes exactly this much inward pull to keep bending the stone's path into a circle instead of letting it fly off in a straight line.$$
where id = '99999999-9999-9999-9999-000000000042';
