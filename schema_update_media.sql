-- ============================================================
-- SCHEMA UPDATE — Add Image & Video support for Prose Pages
-- Run ONCE in Supabase → SQL Editor
-- ============================================================

-- 1. Images table (multiple images per page, ordered)
CREATE TABLE IF NOT EXISTS page_images (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id     uuid        REFERENCES pages(id) ON DELETE CASCADE,
  image_url   text        NOT NULL,
  caption     text,
  order_index int         NOT NULL DEFAULT 0,
  created_at  timestamptz DEFAULT now()
);

-- 2. Videos table (support multiple videos per page)
CREATE TABLE IF NOT EXISTS page_videos (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id     uuid        REFERENCES pages(id) ON DELETE CASCADE,
  video_url   text        NOT NULL,   -- YouTube URL or direct embed URL
  title       text,
  order_index int         NOT NULL DEFAULT 0,
  created_at  timestamptz DEFAULT now()
);

-- 3. Row Level Security
ALTER TABLE page_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE page_videos ENABLE ROW LEVEL SECURITY;

-- Public can read
CREATE POLICY "public read page_images"
  ON page_images FOR SELECT USING (true);
CREATE POLICY "public read page_videos"
  ON page_videos FOR SELECT USING (true);

-- Only logged-in admin can write
CREATE POLICY "admin write page_images"
  ON page_images FOR ALL
  USING      (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "admin write page_videos"
  ON page_videos FOR ALL
  USING      (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

-- 4. Indexes
CREATE INDEX ON page_images (page_id, order_index);
CREATE INDEX ON page_videos (page_id, order_index);
