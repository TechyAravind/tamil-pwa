-- ============================================================================
-- Sign Up / Log In system — profiles table, admin allowlist, auto-provision
-- trigger, and RLS policies.
--
-- Run this ONCE in the Supabase SQL editor for THIS project
-- (the one referenced by VITE_SUPABASE_URL in .env — uuupyaumrkjrjtyobxdl).
--
-- WHAT THIS DOES
--   1. Creates public.profiles — one row per signed-up user, holding the
--      mandatory fields collected at signup (mobile, school, role, class(es),
--      referral source). Row is auto-created by a trigger the instant a new
--      auth.users row is inserted, so a signup can never "half succeed"
--      (leave an auth account with no profile, or vice versa) — Postgres
--      runs the trigger inside the SAME transaction as the user creation.
--   2. Creates public.admins — a small, separate allowlist table. This is
--      the fix for a real security hole: the existing /admin route only
--      checked "is someone logged in?", not "is this person an admin?".
--      Once public sign-up exists, ANY student/teacher who signs up would
--      otherwise be able to open /admin and edit all lesson content. Now
--      /admin requires the user's id to also appear in public.admins.
--   3. Locks both tables down with Row Level Security so a user can only
--      ever read/write their OWN row — never anyone else's.
--
-- AFTER RUNNING THIS FILE — ONE MANUAL STEP REQUIRED:
--   Your existing admin account(s) were created before this migration, so
--   they are not yet in public.admins. Add them by email:
--
--     INSERT INTO public.admins (id)
--     SELECT id FROM auth.users WHERE email = 'YOUR-ADMIN-EMAIL@example.com';
--
--   Repeat one line per admin. Until you do this, /admin login will show
--   "இது நிர்வாகக் கணக்கு அல்ல" (not an admin account) even with the
--   correct password — that is the fix working as intended, not a bug.
-- ============================================================================

-- ── 1. profiles ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id               uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email            text NOT NULL,
  mobile_number    text NOT NULL,
  school_name      text NOT NULL,
  role             text NOT NULL,
  student_class    text,          -- single class, only for role = 'student'
  teacher_classes  text[],        -- one or more classes, only for role = 'teacher'
  referral_source  text NOT NULL,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT profiles_role_check
    CHECK (role IN ('teacher', 'student')),

  CONSTRAINT profiles_mobile_format_check
    -- Indian mobile numbers: 10 digits, starts 6-9. Stored without +91/spaces.
    CHECK (mobile_number ~ '^[6-9][0-9]{9}$'),

  CONSTRAINT profiles_referral_source_check
    CHECK (referral_source IN
      ('friend', 'google', 'youtube', 'instagram', 'snapchat', 'linkedin', 'ai_suggestion', 'others')),

  CONSTRAINT profiles_class_matches_role_check
    CHECK (
      (role = 'student' AND student_class IN ('6','7','8','9','10','11','12')
                        AND teacher_classes IS NULL)
      OR
      (role = 'teacher' AND student_class IS NULL
                        AND teacher_classes IS NOT NULL
                        AND array_length(teacher_classes, 1) > 0
                        AND teacher_classes <@ ARRAY['6','7','8','9','10','11','12'])
    )
);

CREATE INDEX IF NOT EXISTS profiles_role_idx ON public.profiles (role);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "profiles: select own" ON public.profiles;
CREATE POLICY "profiles: select own" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "profiles: update own" ON public.profiles;
CREATE POLICY "profiles: update own" ON public.profiles
  FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- No public INSERT policy — rows are only ever created by the trigger below
-- (SECURITY DEFINER), never directly by a client. This prevents anyone from
-- inserting a profile for someone else's uid or skipping the CHECK logic.

-- ── 2. admins (allowlist for the CMS at /admin) ─────────────────────────────
CREATE TABLE IF NOT EXISTS public.admins (
  id          uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;

-- A logged-in user may only check whether THEIR OWN id is in this table
-- (used by the app to decide whether to show the /admin link) — they can
-- never list who else is an admin, and can never insert/update/delete here
-- (that's deliberately SQL-editor-only, done by you).
DROP POLICY IF EXISTS "admins: self check only" ON public.admins;
CREATE POLICY "admins: self check only" ON public.admins
  FOR SELECT USING (auth.uid() = id);

-- ── 3. auto-provision trigger ────────────────────────────────────────────────
-- Reads the extra signup fields out of auth.users.raw_user_meta_data (passed
-- from the client as `options.data` in supabase.auth.signUp(...)) and writes
-- the profile row atomically with account creation.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (
    id, email, mobile_number, school_name, role, student_class, teacher_classes, referral_source
  )
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data ->> 'mobile_number',
    NEW.raw_user_meta_data ->> 'school_name',
    NEW.raw_user_meta_data ->> 'role',
    NEW.raw_user_meta_data ->> 'student_class',
    CASE
      WHEN NEW.raw_user_meta_data -> 'teacher_classes' IS NOT NULL
      THEN ARRAY(SELECT jsonb_array_elements_text(NEW.raw_user_meta_data -> 'teacher_classes'))
      ELSE NULL
    END,
    NEW.raw_user_meta_data ->> 'referral_source'
  );
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ── 4. keep updated_at fresh on manual profile edits ────────────────────────
CREATE OR REPLACE FUNCTION public.set_profiles_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS profiles_set_updated_at ON public.profiles;
CREATE TRIGGER profiles_set_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_profiles_updated_at();

-- ── Verify ───────────────────────────────────────────────────────────────────
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public' AND tablename IN ('profiles', 'admins');
