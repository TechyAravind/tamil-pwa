import { useNavigate } from 'react-router-dom'

// ── Subject catalogue ────────────────────────────────────────────────────────
const SUBJECTS = [
  { id: 'tamil',       label: 'தமிழ்',        icon: '🪔', color: 'from-[#8B0000] to-[#C0392B]', available: true  },
  { id: 'english',     label: 'English',       icon: '📖', color: 'from-[#1A5276] to-[#2980B9]', available: false },
  { id: 'maths',       label: 'Mathematics',   icon: '📐', color: 'from-[#145A32] to-[#27AE60]', available: false },
  { id: 'physics',     label: 'Physics',       icon: '⚛️', color: 'from-[#4A235A] to-[#8E44AD]', available: false },
  { id: 'chemistry',   label: 'Chemistry',     icon: '🧪', color: 'from-[#784212] to-[#CA6F1E]', available: false },
  { id: 'biology',     label: 'Biology',       icon: '🌿', color: 'from-[#0B5345] to-[#1ABC9C]', available: false },
  { id: 'economics',   label: 'Economics',     icon: '📊', color: 'from-[#1B2631] to-[#2C3E50]', available: false },
  { id: 'commerce',    label: 'Commerce',      icon: '💼', color: 'from-[#4D5656] to-[#717D7E]', available: false },
  { id: 'accountancy', label: 'Accountancy',   icon: '🧾', color: 'from-[#2E4057] to-[#48688D]', available: false },
  { id: 'psychology',  label: 'Psychology',    icon: '🧠', color: 'from-[#512E5F] to-[#9B59B6]', available: false },
  { id: 'history',     label: 'History',       icon: '🏛️', color: 'from-[#5D4037] to-[#795548]', available: false },
  { id: 'geography',   label: 'Geography',     icon: '🗺️', color: 'from-[#1A6B3C] to-[#2ECC71]', available: false },
]

// ── Decorative kolam dots ─────────────────────────────────────────────────────
const BgPattern = () => (
  <svg className="absolute inset-0 w-full h-full opacity-5 pointer-events-none"
       xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" preserveAspectRatio="xMidYMid slice">
    <defs>
      <pattern id="dots" x="0" y="0" width="30" height="30" patternUnits="userSpaceOnUse">
        <circle cx="15" cy="15" r="1.5" fill="white" />
        <circle cx="0"  cy="0"  r="0.8" fill="white" />
        <circle cx="30" cy="0"  r="0.8" fill="white" />
        <circle cx="0"  cy="30" r="0.8" fill="white" />
        <circle cx="30" cy="30" r="0.8" fill="white" />
      </pattern>
    </defs>
    <rect width="100%" height="100%" fill="url(#dots)" />
  </svg>
)

export default function LangfluencerPage() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen bg-primary relative flex flex-col overflow-hidden">
      <BgPattern />

      {/* ── Header ────────────────────────────────────────────────────────── */}
      <header className="relative z-10 text-center pt-12 pb-6 px-4">
        <div className="flex items-center justify-center gap-3 mb-2">
          <div className="w-8 h-0.5 bg-gold rounded-full" />
          <p className="text-gold text-xs font-bold tracking-[0.3em] uppercase">
            Learn · Explore · Master
          </p>
          <div className="w-8 h-0.5 bg-gold rounded-full" />
        </div>

        <h1 className="text-5xl md:text-6xl font-black text-white tracking-tight">
          Lang<span className="text-gold">fluencer</span>
        </h1>

        <p className="text-white/70 mt-3 text-base md:text-lg font-tamil">
          மொழி மற்றும் பாட கற்றல் தளம்
        </p>
      </header>

      {/* ── Subject grid ──────────────────────────────────────────────────── */}
      <main className="relative z-10 flex-1 max-w-2xl mx-auto w-full px-4 pb-10">
        <p className="text-white/50 text-xs text-center mb-4 uppercase tracking-widest">
          Choose a Subject
        </p>

        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
          {SUBJECTS.map((subj) => (
            <button
              key={subj.id}
              onClick={() => subj.available && navigate(`/subject/${subj.id}`)}
              disabled={!subj.available}
              className={`
                relative flex flex-col items-center justify-center gap-2
                rounded-2xl p-5 min-h-[110px] text-white text-center
                transition-all duration-200 border overflow-hidden
                ${subj.available
                  ? 'bg-gradient-to-br ' + subj.color + ' border-white/20 hover:scale-105 hover:shadow-xl active:scale-95 cursor-pointer shadow-md'
                  : 'bg-white/5 border-white/10 cursor-not-allowed opacity-60'
                }
              `}
            >
              {/* Coming soon badge */}
              {!subj.available && (
                <span className="absolute top-2 right-2 bg-white/20 text-white/80
                                 text-[10px] px-1.5 py-0.5 rounded-full font-semibold">
                  விரைவில்
                </span>
              )}

              <span className="text-3xl">{subj.icon}</span>
              <span className={`font-bold leading-tight ${subj.id === 'tamil' ? 'text-lg font-tamil' : 'text-sm'}`}>
                {subj.label}
              </span>

              {subj.available && (
                <span className="bg-white/25 text-white text-[10px] px-2 py-0.5 rounded-full">
                  கிடைக்கிறது
                </span>
              )}
            </button>
          ))}
        </div>
      </main>

      {/* ── Footer ────────────────────────────────────────────────────────── */}
      <footer className="relative z-10 text-center pb-6">
        <p className="text-white/30 text-xs">
          Langfluencer — Tamil Nadu Curriculum
        </p>
      </footer>
    </div>
  )
}
