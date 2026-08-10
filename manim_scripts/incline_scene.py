from manim import *
import numpy as np

class WeightOnIncline(Scene):
    """Free Body Diagram: block on a frictionless inclined plane.
    Shows the weight mg resolved into components mg*cos(theta) (into
    the incline) and mg*sin(theta) (down the slope), plus the normal
    force N perpendicular to the surface."""

    def construct(self):
        theta_deg = 30
        theta = theta_deg * DEGREES

        title = Text("Free Body Diagram - Block on an Incline", font_size=32)
        title.to_edge(UP)
        self.play(Write(title))

        # Build the incline as a right triangle, base on the ground
        base_len = 5
        height = base_len * np.tan(theta)
        p_bottom_left = LEFT * 3 + DOWN * 1.5
        p_bottom_right = p_bottom_left + RIGHT * base_len
        p_top = p_bottom_left + UP * height

        incline = Polygon(p_bottom_left, p_bottom_right, p_top,
                           color=GRAY, fill_color=GRAY, fill_opacity=0.25)
        self.play(Create(incline))

        # Angle arc at the bottom-left vertex
        angle_arc = Angle(
            Line(p_bottom_left, p_bottom_right),
            Line(p_bottom_left, p_top),
            radius=0.6, color=YELLOW
        )
        theta_label = MathTex(r"\theta", color=YELLOW, font_size=32).next_to(angle_arc, RIGHT, buff=0.15)
        self.play(Create(angle_arc), Write(theta_label))

        # Block sits partway up the slope
        t = 0.55
        block_pos = p_bottom_left + (p_top - p_bottom_left) * t
        # nudge block perpendicular to the slope surface so it visually sits "on" it
        normal_dir = np.array([-np.sin(theta), np.cos(theta), 0])
        block_pos = block_pos + normal_dir * 0.25
        block = Square(side_length=0.5, color=GREEN, fill_color=GREEN, fill_opacity=0.6)
        block.move_to(block_pos)
        block.rotate(theta)
        self.play(FadeIn(block))

        origin = block.get_center()

        # Weight vector mg, straight down
        mg_end = origin + DOWN * 2.2
        mg_arrow = Arrow(origin, mg_end, buff=0, color=RED, stroke_width=6)
        mg_label = MathTex("mg", color=RED, font_size=34).next_to(mg_arrow, DOWN, buff=0.15)

        # Normal force N, perpendicular to incline surface
        n_end = origin + normal_dir * 1.8
        n_arrow = Arrow(origin, n_end, buff=0, color=BLUE, stroke_width=6)
        n_label = MathTex("N", color=BLUE, font_size=34).next_to(n_arrow, UP, buff=0.15)

        self.play(GrowArrow(mg_arrow), Write(mg_label))
        self.play(GrowArrow(n_arrow), Write(n_label))
        self.wait(0.5)

        # Decompose mg into components along and perpendicular to the incline
        along_dir = np.array([np.cos(theta), -np.sin(theta), 0])   # down-the-slope direction
        perp_dir = -normal_dir                                      # into-the-slope direction

        comp_along_end = origin + along_dir * (2.2 * np.sin(theta))
        comp_perp_end = origin + perp_dir * (2.2 * np.cos(theta))

        comp_along = Arrow(origin, comp_along_end, buff=0, color=ORANGE, stroke_width=5)
        comp_along_label = MathTex(r"mg\sin\theta", color=ORANGE, font_size=28).next_to(comp_along_end, DOWN, buff=0.1)

        comp_perp = Arrow(origin, comp_perp_end, buff=0, color=TEAL, stroke_width=5)
        comp_perp_label = MathTex(r"mg\cos\theta", color=TEAL, font_size=28).next_to(comp_perp_end, LEFT, buff=0.1)

        self.play(TransformFromCopy(mg_arrow, comp_along), Write(comp_along_label))
        self.play(TransformFromCopy(mg_arrow, comp_perp), Write(comp_perp_label))
        self.wait(0.5)

        equations = VGroup(
            MathTex(r"N = mg\cos\theta", font_size=32),
            MathTex(r"a = g\sin\theta \quad \text{(frictionless)}", font_size=32),
        ).arrange(DOWN, buff=0.25).to_edge(DOWN, buff=0.6)
        self.play(Write(equations))
        self.wait(2)


# Render (preview, fast):
#   manim -pql incline_scene.py WeightOnIncline
# Render (final, high quality):
#   manim -pqh incline_scene.py WeightOnIncline
#
# NOTE: this script uses MathTex (needs a LaTeX install). If LaTeX isn't
# available in your environment, swap MathTex(...) calls for Text(...)
# with plain-text equivalents (e.g. "N = mg cos(theta)") to render
# without any LaTeX dependency.
