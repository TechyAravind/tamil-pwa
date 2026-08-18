import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import useStore from '../../store/useStore'

// Reached via the link Supabase emails from requestPasswordReset(). Supabase
// JS automatically turns the URL's auth fragment into a real session before
// this component even mounts (detectSessionInUrl, on by default), so we can
// go straight to calling updateUser({ password }).
export default function ResetPasswordPage() {
  const navigate       = useNavigate()
  const updatePassword = useStore((s) => s.updatePassword)
  const session         = useStore((s) => s.session)

  const [password, setPassword]               = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [error, setError]                     = useState('')
  const [loading, setLoading]                 = useState(false)
  const [done, setDone]                       = useState(false)

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    if (password.length < 6) { setError('குறைந்தது 6 எழுத்துகள் தேவை.'); return }
    if (password !== confirmPassword) { setError('கடவுச்சொற்கள் பொருந்தவில்லை.'); return }

    setLoading(true)
    const { error: err } = await updatePassword(password)
    setLoading(false)

    if (err) { setError(err); return }
    setDone(true)
    setTimeout(() => navigate('/', { replace: true }), 1500)
  }

  if (!session) {
    return (
      <div className="min-h-screen bg-cream flex items-center justify-center px-4">
        <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-sm text-center">
          <h1 className="text-xl font-bold text-primary mb-2">இணைப்பு காலாவதியானது</h1>
          <p className="text-gray-600 text-sm mb-4">இந்த மீட்டமைப்பு இணைப்பு காலாவதியாகிவிட்டது. மீண்டும் முயற்சிக்கவும்.</p>
          <button onClick={() => navigate('/login')} className="btn-primary">உள்நுழைவுக்குச் செல்க</button>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-cream flex items-center justify-center px-4">
      <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-sm">
        <h1 className="text-2xl font-bold text-primary mb-1">புதிய கடவுச்சொல்</h1>
        <p className="text-gray-500 text-sm mb-6">Reset Password</p>

        {done ? (
          <p className="text-green-700 bg-green-50 border border-green-200 rounded-lg px-3 py-2 text-sm">
            கடவுச்சொல் மாற்றப்பட்டது! பக்கத்திற்குச் செல்கிறது…
          </p>
        ) : (
          <form onSubmit={handleSubmit} noValidate className="space-y-4">
            <div>
              <label className="label">புதிய கடவுச்சொல்</label>
              <input
                type="password" className="input" value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••" autoComplete="new-password"
              />
            </div>
            <div>
              <label className="label">உறுதிசெய்க</label>
              <input
                type="password" className="input" value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder="••••••••" autoComplete="new-password"
              />
            </div>
            {error && (
              <div className="bg-red-50 border border-red-200 text-red-700 rounded-lg px-3 py-2 text-sm">
                {error}
              </div>
            )}
            <button type="submit" disabled={loading} className="btn-primary w-full justify-center disabled:opacity-60">
              {loading ? 'மாற்றுகிறது…' : 'கடவுச்சொல்லை மாற்றுக'}
            </button>
          </form>
        )}
      </div>
    </div>
  )
}
