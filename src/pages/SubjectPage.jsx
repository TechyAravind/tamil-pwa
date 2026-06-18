import { useNavigate, useParams } from 'react-router-dom'

// ── Class levels per subject ──────────────────────────────────────────────────
const SUBJECT_META = {
  tamil: {
    label:    'தமிழ்',
    subtitle: 'Tamil Language & Literature',
    icon:     '🪔',
    color:    'from-[#8B0000] to-[#C0392B]',
    classes: [
      { id: '11', label: '11ஆம் வகுப்பு', sublabel: '11th Standard', available: true  },
      { id: '12', label: '12ஆம் வகுப்பு', sublabel: '12th Standard', available: false },
    ]
  },
  english: {
    label:    'English',
    subtitle: 'English Language & Literature',
    icon:     '📖',
    color:    'from-[#1A5276] to-[#2980B9]',
    classes: [
      { id: '11', label: '11th Standard', sublabel: 'Grade 11', available: false },
      { id: '12', label: '12th Standard', sublabel: 'Grade 12', available: false },
    ]
  },
}

// Fallback for subjects not in SUBJECT_META
const defaultMeta = (id) => ({
  label:    id.charAt(0).toUpperCase() + id.slice(1),
  subtitle: 'Coming Soon',
  icon:     '📚',
  color:    'from-[#4D5656] to-[#717D7E]',
  classes: [
    { id: '11', label: '11th Standard', sublabel: 'Grade 11', available: false },
    { id: '12', label: '12th Standard', sublabel: 'Grade 12', available: false },
  ]
})

// Route for each available class
const CLASS_ROUTES = {
  tamil: { '11': '/tamil/11' }
}

export default function SubjectPage() {
  const { subjectId } = useParams()
  const navigate      = useNavigate()
  const meta          = SUBJECT_META[subjectId] || defaultMeta(subjectId)

  const handleClassClick = (classId) => {
    const route = CLASS_ROUTES[subjectId]?.[classId]
    if (route) navigate(route)
  }

  return (
    <div className="min-h-screen bg-primary flex flex-col">

      {/* ── Back button ────────────────────────────────────────────────────── */}
      <div className="relative z-10 pt-4 px-4">
        <button
          onClick={() => navigate('/')}
          className="flex items-center gap-2 text-white/70 hover:text-white
                     transition-colors min-h-[44px] text-sm"
        >
          ← Langfluencer
        </button>
      </div>

      {/* ── Subject hero ───────────────────────────────────────────────────── */}
      <div className={`bg-gradient-to-br ${meta.color} mx-4 rounded-2xl
                       p-8 text-center text-white mb-8 shadow-xl`}>
        <p className="text-5xl mb-3">{meta.icon}</p>
        <h1 className={`font-black text-4xl mb-1 ${subjectId === 'tamil' ? 'font-tamil' : ''}`}>
          {meta.label}
        </h1>
        <p className="text-white/70 text-sm">{meta.subtitle}</p>
      </div>

      {/* ── Class level cards ─────────────────────────────────────────────── */}
      <main className="flex-1 max-w-md mx-auto w-full px-4 space-y-3">
        <p className="text-white/50 text-xs uppercase tracking-widest text-center mb-2">
          Select Class
        </p>

        {meta.classes.map((cls) => (
          <button
            key={cls.id}
            onClick={() => cls.available && handleClassClick(cls.id)}
            disabled={!cls.available}
            className={`
              w-full flex items-center justify-between px-6 py-5
              rounded-2xl border transition-all duration-200
              ${cls.available
                ? 'bg-white/10 border-white/20 hover:bg-white/20 active:scale-[0.98] cursor-pointer'
                : 'bg-white/5 border-white/10 cursor-not-allowed opacity-50'
              }
            `}
          >
            <div className="text-left">
              <p className={`font-bold text-white text-xl ${subjectId === 'tamil' ? 'font-tamil' : ''}`}>
                {cls.label}
              </p>
              <p className="text-white/60 text-sm mt-0.5">{cls.sublabel}</p>
            </div>
            <div className="flex items-center gap-2">
              {!cls.available && (
                <span className="text-white/50 text-xs bg-white/10 px-2 py-1 rounded-full">
                  விரைவில்
                </span>
              )}
              {cls.available && (
                <span className="text-white text-xl opacity-70">›</span>
              )}
            </div>
          </button>
        ))}
      </main>

      <div className="pb-10" />
    </div>
  )
}
