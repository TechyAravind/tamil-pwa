import { useState } from 'react'
import { Link, useNavigate, useLocation } from 'react-router-dom'
import useStore from '../../store/useStore'

export default function LoginPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const signIn   = useStore((s) => s.signIn)
  const requestPasswordReset = useStore((s) => s.requestPasswordReset)

  const [email, setEmail]       = useState('')
  const [password, setPassword] = useState('')
  const [error, setError]       = useState('')
  const [loading, setLoading]   = useState(false)

  const [showReset, setShowReset]     = useState(false)
  const [resetEmail, setResetEmail]   = useState('')
  const [resetSent, setResetSent]     = useState(false)
  const [resetLoading, setResetLoading] = useState(false)
  const [resetError, setResetError]   = useState('')

  const handleLogin = async (e) => {
    e.preventDefault()
    setError('')
    if (!email.trim() || !password) { setError('மின்னஞ்சல் மற்றும் கடவுச்சொல் இரண்டும் தேவை.'); return }

    setLoading(true)
    const { error: err } = await signIn(email, password)
    setLoading(false)

    if (err) { setError(err); return }
    const dest = location.state?.from?.pathname || '/'
    navigate(dest, { replace: true })
  }

  const handleReset = async (e) => {
    e.preventDefault()
    setResetError('')
    if (!resetEmail.trim()) { setResetError('மின்னஞ்சலை உள்ளிடவும்.'); return }
    setResetLoading(true)
    const { error: err } = await requestPasswordReset(resetEmail)
    setResetLoading(false)
    if (err) { setResetError(err); return }
    setResetSent(true)
  }

  return (
    <div className="min-h-screen bg-cream flex items-center justify-center px-4">
      <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-sm">
        <h1 className="text-2xl font-bold text-primary mb-1">உள்நுழைவு</h1>
        <p className="text-gray-500 text-sm mb-6">Log In — உங்கள் கணக்கிற்குச் செல்லவும்</p>

        {!showReset ? (
          <>
            <form onSubmit={handleLogin} noValidate className="space-y-4">
              <div>
                <label className="label">மின்னஞ்சல் (Email)</label>
                <input
                  type="email" className="input" value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="you@example.com" autoComplete="email"
                />
              </div>
              <div>
                <label className="label">கடவுச்சொல் (Password)</label>
                <input
                  type="password" className="input" value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••" autoComplete="current-password"
                />
              </div>

              {error && (
                <div className="bg-red-50 border border-red-200 text-red-700 rounded-lg px-3 py-2 text-sm">
                  {error}
                </div>
              )}

              <button type="submit" disabled={loading} className="btn-primary w-full justify-center disabled:opacity-60">
                {loading ? 'உள்நுழைகிறது…' : 'உள்நுழைக'}
              </button>
            </form>

            <button
              type="button"
              onClick={() => { setShowReset(true); setResetEmail(email); setResetSent(false); setResetError('') }}
              className="text-sm text-primary hover:underline mt-3 block mx-auto"
            >
              கடவுச்சொல் மறந்துவிட்டதா?
            </button>
          </>
        ) : resetSent ? (
          <div className="text-center">
            <p className="text-gray-600 text-sm mb-4">
              கடவுச்சொல் மீட்டமைப்பு இணைப்பு <strong>{resetEmail}</strong> க்கு அனுப்பப்பட்டுள்ளது.
            </p>
            <button type="button" onClick={() => setShowReset(false)} className="btn-ghost">
              உள்நுழைவுக்குத் திரும்புக
            </button>
          </div>
        ) : (
          <form onSubmit={handleReset} noValidate className="space-y-4">
            <p className="text-gray-500 text-sm">உங்கள் மின்னஞ்சலை உள்ளிடவும் — கடவுச்சொல் மீட்டமைப்பு இணைப்பு அனுப்பப்படும்.</p>
            <div>
              <label className="label">மின்னஞ்சல் (Email)</label>
              <input
                type="email" className="input" value={resetEmail}
                onChange={(e) => setResetEmail(e.target.value)}
                placeholder="you@example.com" autoComplete="email"
              />
            </div>
            {resetError && (
              <div className="bg-red-50 border border-red-200 text-red-700 rounded-lg px-3 py-2 text-sm">
                {resetError}
              </div>
            )}
            <div className="flex gap-2">
              <button type="button" onClick={() => setShowReset(false)} className="btn-ghost flex-1 justify-center">ரத்து செய்</button>
              <button type="submit" disabled={resetLoading} className="btn-primary flex-1 justify-center disabled:opacity-60">
                {resetLoading ? 'அனுப்புகிறது…' : 'இணைப்பை அனுப்புக'}
              </button>
            </div>
          </form>
        )}

        <p className="text-center text-sm text-gray-500 mt-5">
          கணக்கு இல்லையா?{' '}
          <Link to="/signup" state={location.state} className="text-primary font-semibold hover:underline">புதிய கணக்கு உருவாக்குக</Link>
        </p>
      </div>
    </div>
  )
}
