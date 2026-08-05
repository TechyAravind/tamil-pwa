import { useNavigate } from 'react-router-dom'

// Decorative background pattern (orbit / atom motif, purple accent)
const AtomPattern = () => (
  <svg className="absolute inset-0 w-full h-full opacity-10 pointer-events-none"
       xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" preserveAspectRatio="xMidYMid slice">
    <defs>
      <pattern id="atom" x="0" y="0" width="50" height="50" patternUnits="userSpaceOnUse">
        <circle cx="25" cy="25" r="2" fill="#C9A6E0" />
        <ellipse cx="25" cy="25" rx="20" ry="8" fill="none" stroke="#8E44AD" strokeWidth="0.7" />
        <ellipse cx="25" cy="25" rx="8" ry="20" fill="none" stroke="#8E44AD" strokeWidth="0.7"
                  transform="rotate(60 25 25)" />
      </pattern>
    </defs>
    <rect width="100%" height="100%" fill="url(#atom)" />
  </svg>
)

export default function PhysicsLandingPage() {
  const navigate = useNavigate()

  return (
    <div className="min-h-screen bg-primary relative flex flex-col overflow-hidden">
      <AtomPattern />

      {/* Back to Classical Physics */}
      <div className="relative z-10 pt-4 px-4">
        <button
          onClick={() => navigate('/physics/classical')}
          className="flex items-center gap-1 text-white/60 hover:text-white
                     transition-colors text-sm min-h-[44px]"
        >
          ← Classical Physics
        </button>
      </div>

      {/* Main content */}
      <div className="relative z-10 flex flex-col items-center justify-center flex-1 px-6 py-20 text-center">
        <div className="w-24 h-1 bg-[#8E44AD] rounded-full mb-8" />

        <p className="text-[#C9A6E0] text-xs font-bold tracking-[0.3em] uppercase mb-3">
          Classical Physics
        </p>

        <h1 className="text-5xl md:text-7xl font-bold text-white leading-tight mb-2">
          11th Standard
        </h1>
        <h1 className="text-4xl md:text-6xl font-bold text-[#C9A6E0] leading-tight mb-6">
          Physics
        </h1>

        <div className="w-16 h-0.5 bg-[#8E44AD]/60 rounded-full mb-6" />

        <p className="text-white/80 text-xl md:text-2xl mb-12 leading-relaxed max-w-md">
          Explore mechanics, thermal physics, oscillations & waves — one chapter at a time.
        </p>

        <button
          onClick={() => navigate('/physics/classical/11/content')}
          className="bg-[#8E44AD] text-white font-bold text-xl px-10 py-4 rounded-full
                     hover:bg-[#9B59B6] active:scale-95 transition-all shadow-lg
                     min-h-[56px]"
        >
          Content →
        </button>
      </div>
    </div>
  )
}
