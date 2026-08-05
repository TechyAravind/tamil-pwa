import { useNavigate } from 'react-router-dom'

// Physics "branch" tier — Classical Physics (available) / Modern Physics (future)
const BRANCH_META = {
  color: 'from-[#4A235A] to-[#8E44AD]',
  icon:  '⚛️',
}

const CLASSES = [
  { id: '11', label: '11th Standard', sublabel: 'Grade 11 · Volume 1 & 2', available: true },
  { id: '12', label: '12th Standard', sublabel: 'Grade 12',                available: false },
]

export default function PhysicsBranchPage() {
  const navigate = useNavigate()

  const handleClick = (cls) => {
    if (!cls.available) return
    if (cls.id === '11') navigate('/physics/classical/11')
  }

  return (
    <div className="min-h-screen bg-primary flex flex-col">
      {/* Back button */}
      <div className="relative z-10 pt-4 px-4">
        <button
          onClick={() => navigate('/subject/physics')}
          className="flex items-center gap-2 text-white/70 hover:text-white
                     transition-colors min-h-[44px] text-sm"
        >
          ← Physics
        </button>
      </div>

      {/* Branch hero */}
      <div className={`bg-gradient-to-br ${BRANCH_META.color} mx-4 rounded-2xl
                       p-8 text-center text-white mb-8 shadow-xl`}>
        <p className="text-5xl mb-3">{BRANCH_META.icon}</p>
        <h1 className="font-black text-4xl mb-1">Classical Physics</h1>
        <p className="text-white/70 text-sm">Mechanics · Thermal Physics · Waves & Oscillations</p>
      </div>

      {/* Class level cards */}
      <main className="flex-1 max-w-md mx-auto w-full px-4 space-y-3">
        <p className="text-white/50 text-xs uppercase tracking-widest text-center mb-2">
          Select Class
        </p>

        {CLASSES.map((cls) => (
          <button
            key={cls.id}
            onClick={() => handleClick(cls)}
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
              <p className="font-bold text-white text-xl">{cls.label}</p>
              <p className="text-white/60 text-sm mt-0.5">{cls.sublabel}</p>
            </div>
            <div className="flex items-center gap-2">
              {!cls.available && (
                <span className="text-white/50 text-xs bg-white/10 px-2 py-1 rounded-full">
                  Coming soon
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
