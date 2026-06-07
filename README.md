# 11ஆம் தமிழ்ப் பாடம் — PWA

A Progressive Web App for Tamil Literature learning (11th grade).

## Tech Stack
- **React 18** + **Vite** (PWA via vite-plugin-pwa)
- **Tailwind CSS** + Noto Sans Tamil font
- **Supabase** (PostgreSQL database + Auth)
- **Zustand** for state

---

## Setup Guide

### 1. Clone & Install

```bash
git clone <your-repo-url>
cd tamil-pwa
npm install
```

### 2. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a new project.
2. In the SQL Editor, run `schema.sql` (copy-paste the full file).
3. Then run `seed.sql` to insert demo data.

### 3. Configure Environment

```bash
cp .env.example .env
```

Edit `.env`:
```
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

Find these in Supabase → Project Settings → API.

### 4. Create Admin User

In Supabase → Authentication → Users → **Add User**:
- Email: your admin email
- Password: a strong password

This is the account you use to log in at `/admin/login`.

### 5. Run Locally

```bash
npm run dev
```

Visit: `http://localhost:5173`

---

## Deployment (Vercel — recommended)

1. Push to GitHub.
2. Import repo in [vercel.com](https://vercel.com).
3. Set Environment Variables: `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`.
4. Deploy. Done — your PWA is live!

---

## How to Add Content (Admin Workflow)

1. Log in at `yoursite.com/admin/login`
2. **Sections** → already seeded (செய்யுள், உரை நடை, துணைப்பாடம்)
3. **Topics** → Add a new poem/prose title under its section
4. **Pages** → For each topic, create the required page types
5. **Poem Lines** → Add each poem line with a line number
6. **Morphemes** → For each line, add the syllable/morpheme breakdown:
   - Set `position` (ordering), `display_form` (the morpheme text)
   - Set `word_meaning` (shown as popup in students' சொல் பொருள் tab)
   - Set grammatical label (POS) for இலக்கணம் tab
   - Check "is_verb" for verb roots
7. **Verb Analysis** → For verb morphemes, enter the பகுபத உறுப்பிலக்கணம் rows
8. **Literary Notes** → Add இலக்கிய நயம் paragraphs per poem page
9. **Prose Content** → Add paragraphs for நுழையும் முன், நூல் வெளி, etc.

---

## Project Structure

```
tamil-pwa/
├── public/
│   ├── manifest.json
│   └── icons/
├── src/
│   ├── main.jsx
│   ├── App.jsx               ← All routes
│   ├── supabase.js           ← Supabase client
│   ├── store/useStore.js     ← Zustand global state
│   ├── styles/index.css      ← Tailwind + custom classes
│   ├── components/
│   │   ├── Navbar.jsx
│   │   ├── Toast.jsx
│   │   ├── MorphemeChip.jsx  ← Interactive morpheme chip
│   │   ├── MorphemePopup.jsx ← Smart popup (meaning / verb analysis)
│   │   └── PoemLineAccordion.jsx
│   └── pages/
│       ├── LandingPage.jsx
│       ├── TOCPage.jsx
│       ├── TopicPage.jsx
│       ├── ProsePage.jsx
│       ├── PoemPage.jsx      ← 3-tab poem page (most complex)
│       └── admin/
│           ├── LoginPage.jsx
│           ├── AdminLayout.jsx
│           ├── Dashboard.jsx
│           ├── AdminSections.jsx
│           ├── AdminTopics.jsx
│           ├── AdminPages.jsx
│           ├── AdminPoemLines.jsx
│           ├── AdminMorphemes.jsx
│           ├── AdminVerbAnalysis.jsx
│           ├── AdminLiteraryNotes.jsx
│           └── AdminProseContent.jsx
├── schema.sql   ← Run first in Supabase SQL Editor
├── seed.sql     ← Run second (demo data)
├── vite.config.js
├── tailwind.config.js
└── package.json
```
