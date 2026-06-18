# 📚 11ஆம் தமிழ்ப் பாடம் — Content Addition Guide

Complete step-by-step guide for adding and managing all content in the app.

---

## Quick-Start Checklist (Do Once)

1. **Run schema updates** in Supabase SQL Editor:
   - `schema_update_media.sql` — adds image & video tables
   - (already done) `schema.sql` — base tables
2. **Commit & deploy** the updated `ProsePage.jsx` to Vercel
3. Log in at `yoursite.com/admin/login`

---

## Understanding the App Structure

```
Section (செய்யுள் / உரை நடை / துணைப்பாடம்)
  └── Topic (e.g., யுகத்தின் பாடல்)
        ├── நுழையும் முன்        ← Text / Image / Video tabs
        ├── செய்யுள் பகுதி      ← Poem lines with morpheme chips
        ├── இலக்கணப் பகுதி     ← Text / Image / Video tabs
        ├── துணைக் குறிப்புகள்  ← Text / Image / Video tabs
        └── நூல் வெளி           ← Text / Image / Video tabs
```

Each non-poem page now has **three tabs**:

| Tab | Symbol | What goes here |
|-----|--------|---------------|
| எழுத்து விளக்கம் | அ | Text paragraphs (typed content) |
| பட விளக்கம் | 🖼 | Explanatory images / diagrams |
| காட்சி விளக்கம் | ▶ | YouTube video or any video link |

---

## PART A — Adding a New Poem (Topic)

### Step 1 — Create the Topic
1. Admin → **Topics** → **Add Topic**
2. Select the correct **Section** (e.g., செய்யுள்)
3. Enter the **Title** (e.g., `குறுந்தொகை`)
4. Set **Order** (determines position in the table of contents)
5. Save

### Step 2 — Create the 5 Pages
For each topic, you must create all 5 page types:

1. Admin → **Pages** → **Add Page**
2. Select the **Topic** you just created
3. Select **Page Type** from the dropdown:
   - நுழையும் முன்
   - செய்யுள் பகுதி
   - இலக்கணப் பகுதி
   - துணைக் குறிப்புகள்
   - நூல் வெளி
4. Repeat for all 5 types

---

## PART B — Adding Text Content (எழுத்து விளக்கம் Tab)

This applies to: நுழையும் முன், இலக்கணப் பகுதி, துணைக் குறிப்புகள், நூல் வெளி

### Via Admin Dashboard
1. Admin → **Prose Content** → **Add**
2. Select the **Page** (e.g., "குறுந்தொகை → நுழையும் முன்")
3. Enter your text in **Content Text** (one paragraph per entry)
4. Set **Order Index**: 1 for first paragraph, 2 for second, etc.
5. Save
6. Repeat for each paragraph

> **Tip:** Each paragraph is a separate row. Order Index controls the sequence.
> Use Order Index 10, 20, 30 (with gaps) so you can insert paragraphs in between later.

### Via Supabase SQL Editor (faster for bulk content)
```sql
-- First find your page ID
SELECT p.id, p.page_type, t.title
FROM pages p JOIN topics t ON t.id = p.topic_id
WHERE t.title ILIKE '%குறுந்தொகை%';

-- Then insert paragraphs
INSERT INTO prose_content (page_id, content_text, order_index) VALUES
  ('paste-page-id-here', 'முதல் பத்தி உரை இங்கே...', 10),
  ('paste-page-id-here', 'இரண்டாம் பத்தி உரை இங்கே...', 20),
  ('paste-page-id-here', 'மூன்றாம் பத்தி உரை இங்கே...', 30);
```

---

## PART C — Adding Images (பட விளக்கம் Tab)

### Step 1 — Upload Image to Supabase Storage
1. Supabase Dashboard → **Storage** → **New Bucket** (name: `page-images`, Public: ON)
2. Click **Upload** → select your image file
3. Right-click the uploaded file → **Get URL**
4. Copy the public URL (looks like `https://xxx.supabase.co/storage/v1/object/public/page-images/your-image.jpg`)

### Step 2 — Add Image Record via SQL
```sql
-- Find your page ID first (see above)
INSERT INTO page_images (page_id, image_url, caption, order_index) VALUES
  ('paste-page-id-here',
   'https://xxx.supabase.co/storage/v1/object/public/page-images/your-image.jpg',
   'இது படத்தின் விளக்கம் (caption)',
   10);
```

### Step 3 — Add Admin UI for Images (Optional — Future)
Currently images are added via SQL. An admin UI for images will be added in a future update.

### Tips for Images
- Use clear, high-resolution scans or diagrams
- JPG/PNG/WebP all work
- Recommended width: at least 800px
- Caption is optional but helpful for students
- Multiple images per page are supported (use order_index 10, 20, 30...)

---

## PART D — Adding Videos (காட்சி விளக்கம் Tab)

### Supported Video Types
- ✅ YouTube (`https://www.youtube.com/watch?v=VIDEO_ID`)
- ✅ YouTube short link (`https://youtu.be/VIDEO_ID`)
- ✅ YouTube embed URL (`https://www.youtube.com/embed/VIDEO_ID`)

### Add via SQL
```sql
-- Find your page ID first
INSERT INTO page_videos (page_id, video_url, title, order_index) VALUES
  ('paste-page-id-here',
   'https://www.youtube.com/watch?v=YOUR_VIDEO_ID',
   'பாடல் விளக்கம் — யுகத்தின் பாடல்',
   10);
```

### Tips for Videos
- The app automatically converts YouTube watch URLs to embed URLs
- You can add multiple videos per page
- Title is optional but recommended
- Make sure the YouTube video is **not** set to private

---

## PART E — Adding Poem Lines (செய்யுள் பகுதி)

### Step 1 — Add Poem Lines
1. Admin → **Poem Lines** → **Add**
2. Select the **Page** (Topic → செய்யுள் பகுதி)
3. Enter **Line Number** (1, 2, 3...)
4. Enter **Raw Text** (the poem line exactly as it appears)
5. Save

### Step 2 — Add Morphemes for Each Line
1. Admin → **Morphemes** → **Add**
2. Select the **Poem Line**
3. For each morpheme/word in the line:
   - **Position**: 1, 2, 3... (left to right order)
   - **Display Form**: the word/syllable (e.g., `விரல்`)
   - **Word Meaning**: Tamil meaning (shown in சொல் பொருள் tab popup)
   - **Grammatical Label**: POS type (பெயர்ச்சொல் / வினைச்சொல் / இடைச்சொல் / உரிச்சொல்)
   - **Is Verb**: Check this for verb roots (enables பகுபதம் popup)
   - **Is Separator**: Check this for the `+` connector chips between morphemes

> **Tip:** For the line `விரல் முனையைத் தீயிலே தோய்த்து`, create morphemes like:
> | Position | Display Form | Word Meaning | POS | Is Verb |
> |----------|-------------|--------------|-----|---------|
> | 1 | விரல் | விரல் என்பது கை விரலைக் குறிக்கிறது | பெயர்ச்சொல் | No |
> | 2 | + | — | — | No (Is Separator ✓) |
> | 3 | முனை | நுனி | பெயர்ச்சொல் | No |
> | 4 | + | — | — | No (Is Separator ✓) |
> | 5 | யைத் | இரண்டாம் வேற்றுமை உருபு | இடைச்சொல் | No |
> | 6 | + | — | — | No (Is Separator ✓) |
> | 7 | தீ | நெருப்பு | பெயர்ச்சொல் | No |
> | 8 | + | — | — | No (Is Separator ✓) |
> | 9 | இலே | இடவேற்றுமை உருபு | இடைச்சொல் | No |
> | 10 | + | — | — | No (Is Separator ✓) |
> | 11 | தோய்த்து | தோய்த்து என்பது... | வினைச்சொல் | Yes ✓ |

### Step 3 — Add Verb Analysis (பகுபத உறுப்பிலக்கணம்)
For morphemes with **Is Verb** checked:
1. Admin → **Verb Analysis** → **Add**
2. Select the **Morpheme** (the verb root)
3. Add rows for each morpheme part:
   - e.g., `தோய்` → பகுதி, `த்` → இறந்தகால இடைநிலை, `த்` → சந்தி, `உ` → வினையெச்ச விகுதி
4. Save

### Step 4 — Add Literary Notes (இலக்கிய நயம்)
1. Admin → **Literary Notes** → **Add**
2. Select the poem's **செய்யுள் பகுதி** page
3. Enter each note as a paragraph (one per row)
4. Set Order Index

---

## PART F — Quick Reference: Where to Enter What

| Content | Admin Section | Tab Shown |
|---------|--------------|-----------|
| Introduction text | Prose Content | எழுத்து விளக்கம் |
| Introduction images | page_images (SQL) | பட விளக்கம் |
| Introduction video | page_videos (SQL) | காட்சி விளக்கம் |
| Grammar notes text | Prose Content | எழுத்து விளக்கம் |
| Grammar images | page_images (SQL) | பட விளக்கம் |
| Grammar video | page_videos (SQL) | காட்சி விளக்கம் |
| Poem lines | Poem Lines | செய்யுள் பகுதி |
| Word meanings | Morphemes (Word Meaning field) | சொல் பொருள் |
| POS labels | Morphemes (Grammatical Label) | இலக்கணம் |
| Verb breakdown | Verb Analysis | இலக்கணம் (popup) |
| Literary notes | Literary Notes | இலக்கிய நயம் |
| Author / book info text | Prose Content | எழுத்து விளக்கம் |
| Author photo | page_images (SQL) | பட விளக்கம் |

---

## PART G — Running the SQL Scripts

Open Supabase → Your Project → **SQL Editor** → **New Query**

### 1. Schema Update (run once — adds image & video tables)
Copy the entire contents of `schema_update_media.sql` and run it.

### 2. Poem Line Reorder
Copy the entire contents of `poem_reorder.sql` and run it.
After running, the SELECT at the bottom will show you the corrected line order.

---

## PART H — Deploying Updates

After any code change:
1. Open PowerShell in the project folder
2. Run:
```
git add .
git commit -m "describe your change"
git push origin main
```
3. Vercel auto-deploys within ~2 minutes

After any database-only change (SQL), no deployment is needed — the app reads live data.

---

## PART I — Troubleshooting

| Problem | Fix |
|---------|-----|
| Page shows "உள்ளடக்கம் விரைவில்..." | No prose_content rows for that page — add via Admin |
| Image tab shows placeholder | No page_images rows — add via SQL |
| Video tab shows placeholder | No page_videos rows — add via SQL |
| Poem line missing morpheme chips | Add morphemes via Admin → Morphemes |
| Popup shows "பொருள் சேர்க்கப்படவில்லை" | Morpheme's word_meaning is empty — edit via Admin |
| Verb popup shows no data | Add verb analysis via Admin → Verb Analysis |
