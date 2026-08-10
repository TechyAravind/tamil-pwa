# Manim Animation Scripts — Interactive Physics

Python scripts that generate short diagram animations (Manim Community Edition)
for the Interactive Physics lessons. Two are ready to render now; a third is a
reusable template for future modules.

| File | Produces |
|---|---|
| `fbd_scene.py` | Free body diagram: object on flat ground (weight + normal force) |
| `incline_scene.py` | Free body diagram: block on a frictionless incline (weight resolved into components, normal force) |
| `template_scene.py` | Empty starting point + color/style conventions for new scenes |

## 1. Set up your machine (one-time)

You need Python 3.9+, FFmpeg, and Manim. A LaTeX distribution is optional —
only needed if you want the nicer `MathTex` equation rendering (both scripts
have a fallback note at the bottom showing how to swap to plain `Text` if you
skip LaTeX).

**Windows:**
```powershell
# Python: install from python.org if not already present
# FFmpeg:
winget install ffmpeg
# Manim:
pip install manim
# Optional, for MathTex equations:
winget install MiKTeX.MiKTeX
```

**macOS:**
```bash
brew install ffmpeg
brew install --cask mactex-no-gui   # optional, for MathTex
pip install manim
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt install libcairo2-dev libpango1.0-dev pkg-config python3-dev ffmpeg
pip install manim
sudo apt install texlive texlive-latex-extra   # optional, for MathTex
```

Verify: `manim --version`

## 2. Render

From inside `manim_scripts/`:

```bash
# fast draft preview (low quality, opens a video player automatically)
manim -pql fbd_scene.py FBDFlatGround
manim -pql incline_scene.py WeightOnIncline

# final high-quality render for upload
manim -pqh fbd_scene.py FBDFlatGround
manim -pqh incline_scene.py WeightOnIncline
```

Output video lands in `media/videos/<script_name>/<quality>/<SceneName>.mp4`
(Manim creates this folder automatically next to the script).

If you don't want to install a LaTeX distribution, open the script and
replace every `MathTex("...")` call with `Text("...")` using a plain-text
version of the same formula (e.g. `MathTex("N = mg")` → `Text("N = mg")`).
Everything else in both scripts works with zero LaTeX dependency.

## 3. Publish and wire into the site

1. Upload the rendered `.mp4` to YouTube (unlisted is fine) or another host.
2. Copy the video's embed URL.
3. Set it on the matching lesson step in the database:
   ```sql
   update physics_ip_steps
   set video_url = 'https://www.youtube.com/embed/VIDEO_ID'
   where id = '<step-id>';
   ```
4. The step's `VideoEmbed` component (already built into
   `PhysicsInteractiveLessonPage.jsx`) will pick it up automatically — no
   frontend changes needed.

## 4. Making a new scene for a future module

1. Copy `template_scene.py`, rename the file and the `Scene` class.
2. Follow the construct() pattern documented in the template's comments:
   title → static scene → vectors one at a time with `GrowArrow` + `MathTex`
   labels → component decomposition via `TransformFromCopy` if needed →
   closing equation(s) at the bottom.
3. Keep the color convention consistent across all videos so students learn
   to read them at a glance:
   - **Red** = weight / gravity (`mg`)
   - **Blue** = normal force (`N`)
   - **Orange** = component along a surface (e.g. `mg sin θ`)
   - **Teal** = component perpendicular to a surface (e.g. `mg cos θ`)
   - **Green** = the object/block itself
   - **Yellow** = angle arcs and angle labels
4. Render with `manim -pql your_scene.py YourSceneName`, review, then `-pqh`
   for the final version, and follow step 3 above to publish.

## Note on this build

These scripts were authored and syntax-checked but **not rendered** in the
current environment — the sandbox has the Manim runtime libraries but not
the pango/cairo development headers, and installing them requires root
access this sandbox doesn't have. Render them on your own machine following
step 1 above; the scripts don't need any changes.
