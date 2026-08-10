-- ============================================================
-- Interactive Physics — Presentation-Model Formatting Retrofit
--
-- Run AFTER physics_interactive_katex_retrofit.sql.
--
-- Rewrites explanation/example step bodies (all 8 lessons, old and
-- new) into "Presentation model" formatting: short paragraphs,
-- real bulleted lists (lines starting with "- "), and standalone
-- formulas on their own centered line (lines wrapped in $$...$$),
-- per RichText.jsx's block-formatting support. Wording/numbers
-- unchanged from the KaTeX retrofit -- structure only.
-- ============================================================

-- ---------- Lesson "Why Do Things Move?" (already deep; light polish) ----------

update physics_ip_steps set body_text = $BT$About 2500 years ago, Aristotle claimed that a force is needed to keep anything moving -- stop pushing, and motion stops. It matched everyday experience: carts stop when you stop pulling them.

In the 1600s, Galileo challenged this with a clever experiment using two smooth, facing ramps:

- He noticed the ball always climbed back to nearly its starting height, no matter the second ramp's angle.
- As he flattened that ramp, the ball had to travel farther and farther to reach the same height.
- At a perfectly flat angle, the ball would have to travel forever to reach that height -- so it just kept rolling.

Galileo's conclusion: motion doesn't need a force to continue. It only needs a force to change. In essence: Aristotle coupled motion with force, while Galileo decoupled them.$BT$
where id = '99999999-9999-9999-9999-000000000102';

update physics_ip_steps set body_text = $BT$Setup: a ball rolls down a smooth ramp from height $h = 0.20$ m and up a second smooth ramp inclined at angle $\theta$. Since there's no friction, it always regains height $h$ before momentarily stopping.

The horizontal distance it needs to travel to regain that height:

$$d = h / \sin\theta$$

- At $\theta = 30°$: $d = 0.20 / \sin 30° = 0.20/0.5 = 0.40$ m.
- At $\theta = 10°$: $d = 0.20 / \sin 10° \approx 1.15$ m.

As the angle drops, the ball must travel much farther to regain the same height. Push $\theta$ all the way to $0°$ and $\sin\theta \to 0$, so $d \to \infty$ -- the ball never gets there. It just keeps rolling, forever, in a straight line. That's inertia in action.$BT$
where id = '99999999-9999-9999-9999-000000000104';


-- ---------- Lesson "Who's Really Moving? Reference Frames" (light polish) ----------

update physics_ip_steps set body_text = $BT$Newton's First Law says a force-free object keeps constant velocity. But that's only true in certain special frames, called inertial frames -- Newton's First Law is what DEFINES an inertial frame.

The textbook's own example -- a train moving at constant velocity:

- An object resting on a smooth table inside the train stays at rest relative to the train.
- Both the ground and the train are inertial frames here, since they move at constant velocity relative to each other.

Now suppose the train suddenly accelerates:

- The object on the table appears to slide backward, even though no real horizontal force acts on it.
- That's a direct violation of Newton's First Law -- so the accelerating train is a non-inertial frame.

The same idea, played out with a car instead of a train, is shown below: a ball hanging from a string stays vertical at constant velocity, but swings forward the instant the car brakes.

For practical purposes, Earth's surface is treated as an (approximately) inertial frame -- even though, strictly, its rotation makes it slightly non-inertial.$BT$
where id = '99999999-9999-9999-9999-000000000112';


-- ---------- Lesson "The Three Rules That Run the Universe" ----------

update physics_ip_steps set body_text = $BT$Newton's three laws, in plain language:

- First Law (Inertia) -- an object keeps doing what it's already doing (staying still, or moving at constant velocity) unless a net force acts on it. This resistance to changing motion is called inertia; heavier objects have more of it.
- Second Law -- a net force causes an object to accelerate:

$$F = ma$$

  More force means more acceleration; more mass means less acceleration for the same force.

- Third Law (Action-Reaction) -- whenever one object pushes or pulls on a second object, the second object pushes or pulls back on the first with equal strength, in the opposite direction. These two forces always act on two DIFFERENT objects -- never the same one -- which is the key to solving the horse-and-cart puzzle above.$BT$
where id = '99999999-9999-9999-9999-000000000008';

update physics_ip_steps set body_text = $BT$Two objects -- one of mass 2.5 kg, one of mass 100 kg -- each feel the exact same 5 N push. What acceleration does each one experience?

Using Newton's Second Law:

$$a = F/m$$

- For the 2.5 kg object: $a = 5/2.5 = 2\ \text{m/s}^2$.
- For the 100 kg object: $a = 5/100 = 0.05\ \text{m/s}^2$.

Same force, wildly different results -- the heavier object barely notices the push. This is why a gentle shove moves a bicycle easily but does almost nothing to a parked car: mass resists acceleration.$BT$
where id = '99999999-9999-9999-9999-000000000009';


-- ---------- Lesson "Reading a Force Diagram" ----------

update physics_ip_steps set body_text = $BT$A free body diagram is a simple sketch of a single object with an arrow for every force acting on it -- nothing else. The four forces you'll draw again and again:

- Weight ($mg$) -- always straight down.
- Normal force ($N$) -- always perpendicular to the surface, pushing the object away from it.
- Tension ($T$) -- along a string or rope, pulling.
- Friction ($f$) -- along the surface, opposing sliding or attempted sliding.

On a flat, horizontal surface, weight and normal force point in exactly opposite directions, so they cancel:

$$N = mg$$

But tilt the surface into a ramp, and weight still points straight down while the normal force stays perpendicular to the ramp -- they're no longer simple opposites of each other anymore.$BT$
where id = '99999999-9999-9999-9999-000000000015';

update physics_ip_steps set body_text = $BT$An object rests on a frictionless surface tilted at angle $\theta$. Since the object doesn't accelerate perpendicular to the ramp, the forces in that direction must balance: the normal force $N$ exactly cancels the perpendicular component of weight.

The perpendicular component of weight is $mg\cos\theta$, so:

$$N = mg\cos\theta$$

Notice this is smaller than the full weight $mg$, since $\cos\theta$ is less than 1 for any tilt -- some of the weight is "used up" pulling the object down the slope instead of into the surface. That's the extra pull you feel pushing a cart uphill: part of its weight now acts along the direction you're pushing.$BT$
where id = '99999999-9999-9999-9999-000000000016';


-- ---------- Lesson "Three Forces in Balance" ----------

update physics_ip_steps set body_text = $BT$When exactly three forces act at a single point and keep it in equilibrium (no net force), Lami's theorem says: each force, divided by the sine of the angle between the OTHER two forces, gives the same value for all three.

$$\dfrac{F_1}{\sin(\text{angle opposite } F_1)} = \dfrac{F_2}{\sin(\text{angle opposite } F_2)} = \dfrac{F_3}{\sin(\text{angle opposite } F_3)}$$

It's a shortcut -- instead of separately resolving every force into x and y components, you can often read the answer straight off a force triangle.$BT$
where id = '99999999-9999-9999-9999-000000000022';

update physics_ip_steps set body_text = $BT$A baby of weight $mg$ hangs from two identical chains, each making angle $\theta$ with the vertical. By symmetry, both chains carry the same tension $T$.

Balancing the vertical forces (both chains contribute equally):

$$2T\cos\theta = mg \quad\Rightarrow\quad T = \dfrac{mg}{2\cos\theta}$$

Check: when $\theta = 0°$ (chains hang straight down), $T = mg/2$ -- each chain simply carries half the weight, exactly as expected.$BT$
where id = '99999999-9999-9999-9999-000000000023';


-- ---------- Lesson "What Never Changes in a Collision" ----------

update physics_ip_steps set body_text = $BT$For an isolated system (no external force acting on it), total momentum before an event always equals total momentum after it -- the law of conservation of linear momentum.

- It doesn't matter how complicated the internal forces are (an explosion, a collision, a spring releasing).
- If nothing from outside pushes or pulls on the system, its total momentum cannot change.

Before firing, gun and bullet are both at rest, so total momentum $= 0$. After firing, the bullet carries forward momentum -- so the gun MUST carry exactly equal backward momentum to keep the total at zero. That backward momentum is what we feel as recoil.$BT$
where id = '99999999-9999-9999-9999-000000000028';

update physics_ip_steps set body_text = $BT$A 2 kg gun fires a 0.01 kg bullet at 400 m/s. Find the gun's recoil speed.

Total momentum starts at zero, so it must stay at zero:

$$m_{bullet}\, v_{bullet} = m_{gun}\, v_{gun}$$

- $0.01 \times 400 = 2 \times v_{gun}$
- $v_{gun} = 4/2 = 2\ \text{m/s}$

The much heavier gun recoils at a much smaller speed than the bullet's -- same momentum, shared very unequally because of the huge mass difference.$BT$
where id = '99999999-9999-9999-9999-000000000029';


-- ---------- Lesson "The Force That Almost Stops Everything" ----------

update physics_ip_steps set body_text = $BT$Static friction resists the START of sliding. It's not a fixed value -- it automatically adjusts to match whatever force you apply, up to a maximum:

$$f_{max} = \mu_s N$$

- As long as your push stays below this maximum, static friction matches it exactly and nothing moves.
- Once your push exceeds that maximum, the object breaks free and starts sliding.
- Now kinetic friction takes over -- usually a bit weaker than the maximum static friction, and roughly constant while sliding continues.$BT$
where id = '99999999-9999-9999-9999-000000000034';

update physics_ip_steps set body_text = $BT$A 7 kg block sits on a table (static friction coefficient 0.9 between block and table), connected by a string over a pulley to a hanging 5 kg mass. Will the 7 kg block move?

- Step 1 -- Maximum static friction available: $0.9 \times 7 \times 9.8 = 61.74\ \text{N}$.
- Step 2 -- Force actually trying to pull the block: the string tension equals the hanging weight, $5 \times 9.8 = 49\ \text{N}$.
- Step 3 -- Compare: $49\ \text{N} < 61.74\ \text{N}$, so static friction can easily match the pull. The block stays put.

To make it slide, the hanging mass would need to exceed $0.9 \times 7 = 6.3$ kg.$BT$
where id = '99999999-9999-9999-9999-000000000035';


-- ---------- Lesson "Why You Feel Pushed Outward on a Turn" ----------

update physics_ip_steps set body_text = $BT$Any object moving in a circle needs a net force pointing toward the center, called the centripetal force:

$$F = \dfrac{mv^2}{r}$$

Without it, the object would simply travel in a straight line (Newton's First Law). This is a real force -- supplied by tension in a string, gravity for orbiting planets, or friction for a car on a curve.

Centrifugal force is different:

- It only shows up if you insist on analyzing the motion from inside the rotating frame (like sitting in the turning car).
- From that viewpoint, an object at rest needs an outward pseudo-force to explain why it isn't accelerating inward with everything else.
- It's not a force from any physical source -- it's what inertia looks like when you're the one turning.$BT$
where id = '99999999-9999-9999-9999-000000000041';

update physics_ip_steps set body_text = $BT$A 0.25 kg stone tied to a string moves in a circle of radius 3 m at a constant speed of 2 m/s. Find the tension in the string.

The string supplies the centripetal force:

$$T = \dfrac{mv^2}{r} = \dfrac{0.25 \times 2^2}{3} = \dfrac{1}{3} = 0.333\ \text{N}$$

That's the entire tension in the string -- not because the stone is "flying outward," but because it takes exactly this much inward pull to keep bending the stone's path into a circle instead of letting it fly off in a straight line.$BT$
where id = '99999999-9999-9999-9999-000000000042';
