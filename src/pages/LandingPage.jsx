import { useNavigate } from 'react-router-dom'
import { useEffect, useState } from 'react'

// Inline kolam SVG pattern as a decorative background
const KolamPattern = () => (
  <svg className="absolute inset-0 w-full h-full opacity-10 pointer-events-none"
       xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" preserveAspectRatio="xMidYMid slice">
    <defs>
      <pattern id="kolam" x="0" y="0" width="40" height="40" patternUnits="userSpaceOnUse">
        <circle cx="20" cy="20" r="2" fill="#C8A84B" />
        <circle cx="0"  cy="0"  r="1" fill="#C8A84B" />
        <circle cx="40" cy="0"  r="1" fill="#C8A84B" />
        <circle cx="0"  cy="40" r="1" fill="#C8A84B" />
        <circle cx="40" cy="40" r="1" fill="#C8A84B" />
        <path d="M20,4 Q36,20 20,36 Q4,20 20,4Z" fill="none" stroke="#8B0000" strokeWidth="0.8"/>
        <path d="M4,20 Q20,4 36,20 Q20,36 4,20Z" fill="none" stroke="#8B0000" strokeWidth="0.8"/>
      </pattern>
    </defs>
    <rect width="100%" height="100%" fill="url(#kolam)" />
  </svg>
)

export default function LandingPage() {
  const navigate = useNavigate()
  const [showInstall, setShowInstall] = useState(false)
  const [deferredPrompt, setDeferredPrompt] = useState(null)

  useEffect(() => {
    const handler = (e) => {
      e.preventDefault()
      setDeferredPrompt(e)
      setShowInstall(true)
    }
    window.addEventListener('beforeinstallprompt', handler)
    return () => window.removeEventListener('beforeinstallprompt', handler)
  }, [])

  const handleInstall = async () => {
    if (!deferredPrompt) return
    deferredPrompt.prompt()
    const { outcome } = await deferredPrompt.userChoice
    if (outcome === 'accepted') setShowInstall(false)
    setDeferredPrompt(null)
  }

  return (
    <div className="min-h-screen bg-primary relative flex flex-col overflow-hidden">
      <KolamPattern />

      {/* Back to Langfluencer */}
      <div className="relative z-10 pt-4 px-4">
        <button
          onClick={() => navigate('/subject/tamil')}
          className="flex items-center gap-1 text-white/60 hover:text-white
                     transition-colors text-sm min-h-[44px]"
        >
          ← Langfluencer
        </button>
      </div>

      {/* Main content */}
      <div className="relative z-10 flex flex-col items-center justify-center flex-1 px-6 py-20 text-center">
        {/* Decorative top border */}
        <div className="w-24 h-1 bg-gold rounded-full mb-8" />

        <h1 className="text-5xl md:text-7xl font-bold text-white leading-tight mb-4">
          11ஆம்
        </h1>
        <h1 className="text-4xl md:text-6xl font-bold text-gold leading-tight mb-6">
          தமிழ்ப் பாடம்
        </h1>

        <div className="w-16 h-0.5 bg-gold/50 rounded-full mb-6" />

        <p className="text-white/80 text-xl md:text-2xl mb-12 leading-relaxed">
          தமிழ் இலக்கியம் — ஒரு புதிய பயணம்
        </p>

        <button
          onClick={() => navigate('/toc')}
          className="bg-gold text-primary-dark font-bold text-xl px-10 py-4 rounded-full
                     hover:bg-gold-light active:scale-95 transition-all shadow-lg
                     min-h-[56px]"
        >
          பாடங்களை காண்க →
        </button>
      </div>

      {/* PWA install banner */}
      {showInstall && (
        <div className="relative z-10 bg-white/95 mx-4 mb-6 rounded-xl p-4 flex items-center gap-3 shadow-lg">
          <div className="flex-1">
            <p className="font-semibold text-primary text-sm">ஆப்பை நிறுவுக</p>
            <p className="text-gray-600 text-xs">எந்நேரமும் படிக்க — இணையம் இல்லாமலும்</p>
          </div>
          <button onClick={handleInstall}
                  className="bg-primary text-white text-sm px-4 py-2 rounded-lg min-h-[44px]">
            நிறுவு
          </button>
          <button onClick={() => setShowInstall(false)}
                  className="text-gray-400 text-xl min-w-[44px] min-h-[44px] flex items-center justify-center">
            ✕
          </button>
        </div>
      )}
    </div>
  )
}
