from manim import *

class FBDFlatGround(Scene):
    """Free Body Diagram: object at rest on flat, horizontal ground.
    Matches the site's FBD explanation step -- weight (mg) down,
    normal force (N) up, on a flat surface."""

    def construct(self):
        title = Text("Free Body Diagram - Object on Flat Ground", font_size=32)
        title.to_edge(UP)
        self.play(Write(title))

        # Ground line
        ground = Line(LEFT * 4, RIGHT * 4, color=GRAY).shift(DOWN * 1.5)
        hatch = VGroup(*[
            Line(ground.get_start() + RIGHT * i * 0.3 + UP * 0.05,
                 ground.get_start() + RIGHT * i * 0.3 + DOWN * 0.2, color=GRAY, stroke_width=2)
            for i in range(27)
        ])
        self.play(Create(ground), Create(hatch))

        # Object (point mass) on the ground
        obj = Dot(point=ORIGIN + DOWN * 1.5, radius=0.18, color=GREEN)
        obj_label = Text("Object", font_size=22).next_to(obj, LEFT, buff=0.6)
        self.play(FadeIn(obj), Write(obj_label))

        # Weight vector (mg) pointing down
        mg_arrow = Arrow(start=obj.get_center(), end=obj.get_center() + DOWN * 2,
                          buff=0, color=RED, stroke_width=6)
        mg_label = MathTex("mg", color=RED, font_size=36).next_to(mg_arrow, RIGHT, buff=0.2)

        # Normal force vector (N) pointing up
        n_arrow = Arrow(start=obj.get_center(), end=obj.get_center() + UP * 2,
                         buff=0, color=BLUE, stroke_width=6)
        n_label = MathTex("N", color=BLUE, font_size=36).next_to(n_arrow, LEFT, buff=0.2)

        self.play(GrowArrow(mg_arrow), Write(mg_label))
        self.play(GrowArrow(n_arrow), Write(n_label))
        self.wait(0.5)

        equation = MathTex("N = mg", font_size=40).to_edge(DOWN, buff=0.8)
        self.play(Write(equation))
        self.wait(2)


# Render (preview, fast):
#   manim -pql fbd_scene.py FBDFlatGround
# Render (final, high quality):
#   manim -pqh fbd_scene.py FBDFlatGround
#
# NOTE: this script uses MathTex (needs a LaTeX install). If you don't
# have LaTeX set up, replace every MathTex(...) call with Text(...) --
# e.g. MathTex("N = mg") becomes Text("N = mg") -- and it will render
# with no LaTeX dependency at all, just slightly plainer-looking text.
