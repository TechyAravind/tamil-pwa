import { useNavigate, useLocation } from 'react-router-dom'

export default function Navbar({ title = '11ஆம் தமிழ்ப் பாடம்', showBack = false }) {
  const navigate  = useNavigate()
  const location  = useLocation()

  const goBack = () => {
    if (window.history.length > 1) navigate(-1)
    else navigate('/')
  }

  return (
    <header className="sticky top-0 z-30 bg-primary text-white shadow-md">
      <div className="flex items-center h-14 px-4 gap-3 max-w-2xl mx-auto">
        {showBack && (
          <button
            onClick={goBack}
            aria-label="பின்னால் செல்"
            className="min-w-[44px] min-h-[44px] flex items-center justify-center
                       rounded-lg hover:bg-white/10 active:bg-white/20 transition-colors text-xl"
          >
            ←
          </button>
        )}
        <h1 className="flex-1 font-bold text-lg truncate">{title}</h1>
      </div>
    </header>
  )
}
