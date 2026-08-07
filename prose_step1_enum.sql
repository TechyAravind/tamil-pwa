-- ============================================================
-- STEP 1 of 3 — Add new enum value
-- Run this ALONE first. Click Run. Wait for success.
-- Then go run prose_step2_setup.sql
-- ============================================================

ALTER TYPE page_type ADD VALUE IF NOT EXISTS 'உரைநடைப் பகுதி';
