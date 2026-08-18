import { useState, useRef, useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import useStore from '../store/useStore'

export default function Navbar({ title = '11ஆம் தமிழ்ப் பாடம்', showBack = false, showAuth = true }) {
  const navigate  = useNavigate()
  const location  = useLocation()
  const session   = useStore((s) => s.session)
  const signOut   = useStore((s) => s.signOut)

  const [menuOpen, setMenuOpen] = useState(false)
  const menuRef = useRef(null)

  useEffect(() => {
    if (!menuOpen) return
    const onClick = (e) => { if (menuRef.current && !menuRef.current.contains(e.target)) setMenuOpen(false) }
    document.addEventListener('mousedown', onClick)
    return () => document.removeEventListener('mousedown', onClick)
  }, [menuOpen])

  const goBack = () => {
    if (window.history.length > 1) navigate(-1)
    else navigate('/')
  }

  const handleLogout = async () => {
    setMenuOpen(false)
    await signOut()
    navigate('/login', { replace: true })
  }

  const email = session?.user?.email || ''
  const initial = email ? email[0].toUpperCase() : '?'

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

        {showAuth && session && (
          <div className="relative" ref={menuRef}>
            <button
              onClick={() => setMenuOpen((v) => !v)}
              aria-label="கணக்கு மெனு"
              className="w-9 h-9 rounded-full bg-white/15 hover:bg-white/25 transition-colors
                         flex items-center justify-center font-bold text-sm"
            >
              {initial}
            </button>
            {menuOpen && (
              <div className="absolute right-0 mt-2 w-56 bg-white text-gray-800 rounded-xl shadow-2xl
                              border border-gray-100 py-2 animate-fade-in">
                <p className="px-4 py-1 text-xs text-gray-400 truncate">{email}</p>
                <button
                  onClick={handleLogout}
                  className="w-full text-left px-4 py-2 text-sm hover:bg-cream text-red-600 font-semibold"
                >
                  வெளியேறு (Logout)
                </button>
              </div>
            )}
          </div>
        )}
      </div>
    </header>
  )
}
