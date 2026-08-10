from manim import *

# Reusable starting point for new physics diagram animations.
# Copy this file, rename the class, and fill in the construct() method.
#
# Pattern used across this project's scripts:
#   1. Title text at the top (Text, not MathTex -- titles are plain words)
#   2. Draw the static scene (ground line, incline, object, etc.)
#   3. Add force/vector arrows one at a time with GrowArrow + a MathTex label
#   4. If decomposing a vector into components, use TransformFromCopy so the
#      component arrows visibly "peel off" the original vector
#   5. End with the relevant equation(s) written at the bottom via MathTex
#
# Color convention used in this project (keep it consistent across videos):
#   RED    = weight / gravity (mg)
#   BLUE   = normal force (N)
#   ORANGE = component along a surface (e.g. mg sin theta)
#   TEAL   = component perpendicular to a surface (e.g. mg cos theta)
#   GREEN  = the object / block itself
#   YELLOW = angle arcs and angle labels

class TemplateScene(Scene):
    def construct(self):
        title = Text("Scene Title Here", font_size=32)
        title.to_edge(UP)
        self.play(Write(title))

        # ... build your diagram here ...

        self.wait(2)


# Render (preview, fast):
#   manim -pql template_scene.py TemplateScene
# Render (final, high quality):
#   manim -pqh template_scene.py TemplateScene
