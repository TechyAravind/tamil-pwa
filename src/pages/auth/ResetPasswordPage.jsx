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
    if (password.length < 6) { setError('Must be at least 6 characters.'); return }
    if (password !== confirmPassword) { setError('Passwords do not match.'); return }

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
          <h1 className="text-xl font-bold text-primary mb-2">Link Expired</h1>
          <p className="text-gray-600 text-sm mb-4">This reset link has expired. Please try again.</p>
          <button onClick={() => navigate('/login')} className="btn-primary">Go to Log In</button>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-cream flex items-center justify-center px-4">
      <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-sm">
        <h1 className="text-2xl font-bold text-primary mb-1">Reset Password</h1>
        <p className="text-gray-500 text-sm mb-6">Choose a new password for your account</p>

        {done ? (
          <p className="text-green-700 bg-green-50 border border-green-200 rounded-lg px-3 py-2 text-sm">
            Password changed! Redirecting…
          </p>
        ) : (
          <form onSubmit={handleSubmit} noValidate className="space-y-4">
            <div>
              <label className="label">New Password</label>
              <input
                type="password" className="input" value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••" autoComplete="new-password"
              />
            </div>
            <div>
              <label className="label">Confirm Password</label>
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
              {loading ? 'Changing…' : 'Change Password'}
            </button>
          </form>
        )}
      </div>
    </div>
  )
}
