import { useState } from 'react'
import { Link, useNavigate, useLocation } from 'react-router-dom'
import useStore from '../../store/useStore'

const CLASSES = ['6', '7', '8', '9', '10', '11', '12']

const REFERRAL_OPTIONS = [
  { value: 'friend',        label: 'Friend' },
  { value: 'google',        label: 'Google' },
  { value: 'youtube',       label: 'YouTube' },
  { value: 'instagram',     label: 'Instagram' },
  { value: 'snapchat',      label: 'Snapchat' },
  { value: 'linkedin',      label: 'LinkedIn' },
  { value: 'ai_suggestion', label: 'AI Suggestion (ChatGPT, Claude, etc.)' },
  { value: 'others',        label: 'Others' },
]

export default function SignUpPage() {
  const navigate  = useNavigate()
  const location  = useLocation()
  const signUp    = useStore((s) => s.signUp)

  const [form, setForm] = useState({
    email: '', mobileNumber: '', password: '', confirmPassword: '',
    schoolName: '', role: '', studentClass: '', teacherClasses: [],
    referralSource: '',
  })
  const [fieldErrors, setFieldErrors] = useState({})
  const [formError, setFormError]     = useState('')
  const [loading, setLoading]         = useState(false)
  const [done, setDone]               = useState(false)

  const setField = (key, value) => {
    setForm((f) => ({ ...f, [key]: value }))
    setFieldErrors((fe) => ({ ...fe, [key]: undefined }))
  }

  const toggleTeacherClass = (cls) => {
    setForm((f) => {
      const has = f.teacherClasses.includes(cls)
      return {
        ...f,
        teacherClasses: has
          ? f.teacherClasses.filter((c) => c !== cls)
          : [...f.teacherClasses, cls],
      }
    })
    setFieldErrors((fe) => ({ ...fe, teacherClasses: undefined }))
  }

  const validate = () => {
    const e = {}
    if (!form.email.trim()) e.email = 'Email is required'
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email.trim())) e.email = 'Please enter a valid email address'

    if (!form.mobileNumber.trim()) e.mobileNumber = 'Mobile number is required'
    else if (!/^[6-9][0-9]{9}$/.test(form.mobileNumber.trim())) e.mobileNumber = 'Enter a valid 10-digit Indian mobile number (e.g. 9876543210)'

    if (!form.password) e.password = 'Password is required'
    else if (form.password.length < 6) e.password = 'Must be at least 6 characters'

    if (form.confirmPassword !== form.password) e.confirmPassword = 'Passwords do not match'

    if (!form.schoolName.trim()) e.schoolName = 'School name is required'

    if (!form.role) e.role = 'Please select one'

    if (form.role === 'student' && !form.studentClass) e.studentClass = 'Please select your class'
    if (form.role === 'teacher' && form.teacherClasses.length === 0) e.teacherClasses = 'Please select at least one class'

    if (!form.referralSource) e.referralSource = 'Please select one'

    setFieldErrors(e)
    return Object.keys(e).length === 0
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setFormError('')
    if (!validate()) return

    setLoading(true)
    const { error, needsEmailConfirmation } = await signUp({
      email: form.email,
      password: form.password,
      mobileNumber: form.mobileNumber,
      schoolName: form.schoolName,
      role: form.role,
      studentClass: form.studentClass,
      teacherClasses: form.teacherClasses,
      referralSource: form.referralSource,
    })
    setLoading(false)

    if (error) { setFormError(error); return }

    if (needsEmailConfirmation) {
      // Email confirmation is required by the Supabase project's auth
      // settings — show a clear message instead of silently redirecting.
      setDone(true)
    } else {
      const dest = location.state?.from?.pathname || '/'
      navigate(dest, { replace: true })
    }
  }

  if (done) {
    return (
      <div className="min-h-screen bg-cream flex items-center justify-center px-4">
        <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-sm text-center">
          <h1 className="text-xl font-bold text-primary mb-2">Account created!</h1>
          <p className="text-gray-600 text-sm mb-4">
            We've sent a confirmation link to your email. Please confirm it, then log in.
          </p>
          <Link to="/login" className="btn-primary w-full justify-center">Go to Log In</Link>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-cream flex items-center justify-center px-4 py-8">
      <div className="bg-white rounded-2xl shadow-xl p-6 sm:p-8 w-full max-w-lg">
        <h1 className="text-2xl font-bold text-primary mb-1">Create Your Account</h1>
        <p className="text-gray-500 text-sm mb-6">Sign Up — create a free account to continue your lessons</p>

        <form onSubmit={handleSubmit} noValidate className="space-y-4">
          <div>
            <label className="label">Email *</label>
            <input
              type="email" className="input" value={form.email}
              onChange={(e) => setField('email', e.target.value)}
              placeholder="you@example.com" autoComplete="email"
            />
            {fieldErrors.email && <p className="text-red-600 text-xs mt-1">{fieldErrors.email}</p>}
          </div>

          <div>
            <label className="label">Mobile Number *</label>
            <input
              type="tel" inputMode="numeric" className="input" value={form.mobileNumber}
              onChange={(e) => setField('mobileNumber', e.target.value.replace(/\D/g, '').slice(0, 10))}
              placeholder="9876543210" autoComplete="tel" maxLength={10}
            />
            {fieldErrors.mobileNumber && <p className="text-red-600 text-xs mt-1">{fieldErrors.mobileNumber}</p>}
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="label">Password *</label>
              <input
                type="password" className="input" value={form.password}
                onChange={(e) => setField('password', e.target.value)}
                placeholder="••••••••" autoComplete="new-password"
              />
              {fieldErrors.password && <p className="text-red-600 text-xs mt-1">{fieldErrors.password}</p>}
            </div>
            <div>
              <label className="label">Confirm Password *</label>
              <input
                type="password" className="input" value={form.confirmPassword}
                onChange={(e) => setField('confirmPassword', e.target.value)}
                placeholder="••••••••" autoComplete="new-password"
              />
              {fieldErrors.confirmPassword && <p className="text-red-600 text-xs mt-1">{fieldErrors.confirmPassword}</p>}
            </div>
          </div>

          <div>
            <label className="label">School Name *</label>
            <input
              type="text" className="input" value={form.schoolName}
              onChange={(e) => setField('schoolName', e.target.value)}
              placeholder="e.g. St. Xavier's Matriculation School"
            />
            {fieldErrors.schoolName && <p className="text-red-600 text-xs mt-1">{fieldErrors.schoolName}</p>}
          </div>

          <div>
            <label className="label">Are you a Teacher or a Student? *</label>
            <div className="flex gap-3">
              {[
                { value: 'student', label: 'Student' },
                { value: 'teacher', label: 'Teacher' },
              ].map((opt) => (
                <button
                  key={opt.value} type="button"
                  onClick={() => setField('role', opt.value)}
                  className={`flex-1 min-h-[44px] rounded-lg border-2 font-semibold text-sm transition-colors
                    ${form.role === opt.value
                      ? 'border-primary bg-primary text-white'
                      : 'border-gray-300 text-gray-600 hover:border-primary/50'}`}
                >
                  {opt.label}
                </button>
              ))}
            </div>
            {fieldErrors.role && <p className="text-red-600 text-xs mt-1">{fieldErrors.role}</p>}
          </div>

          {form.role === 'student' && (
            <div>
              <label className="label">Class — select one *</label>
              <select
                className="input" value={form.studentClass}
                onChange={(e) => setField('studentClass', e.target.value)}
              >
                <option value="">-- Select --</option>
                {CLASSES.map((c) => <option key={c} value={c}>Class {c}</option>)}
              </select>
              {fieldErrors.studentClass && <p className="text-red-600 text-xs mt-1">{fieldErrors.studentClass}</p>}
            </div>
          )}

          {form.role === 'teacher' && (
            <div>
              <label className="label">Classes you teach — select all that apply *</label>
              <div className="grid grid-cols-4 gap-2">
                {CLASSES.map((c) => {
                  const active = form.teacherClasses.includes(c)
                  return (
                    <button
                      key={c} type="button"
                      onClick={() => toggleTeacherClass(c)}
                      className={`min-h-[44px] rounded-lg border-2 font-semibold text-sm transition-colors
                        ${active ? 'border-primary bg-primary text-white' : 'border-gray-300 text-gray-600 hover:border-primary/50'}`}
                    >
                      {c}
                    </button>
                  )
                })}
              </div>
              {fieldErrors.teacherClasses && <p className="text-red-600 text-xs mt-1">{fieldErrors.teacherClasses}</p>}
            </div>
          )}

          <div>
            <label className="label">Where did you hear about us? *</label>
            <select
              className="input" value={form.referralSource}
              onChange={(e) => setField('referralSource', e.target.value)}
            >
              <option value="">-- Select --</option>
              {REFERRAL_OPTIONS.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
            {fieldErrors.referralSource && <p className="text-red-600 text-xs mt-1">{fieldErrors.referralSource}</p>}
          </div>

          {formError && (
            <div className="bg-red-50 border border-red-200 text-red-700 rounded-lg px-3 py-2 text-sm">
              {formError}
            </div>
          )}

          <button type="submit" disabled={loading} className="btn-primary w-full justify-center disabled:opacity-60">
            {loading ? 'Creating account…' : 'Create Account'}
          </button>
        </form>

        <p className="text-center text-sm text-gray-500 mt-5">
          Already have an account?{' '}
          <Link to="/login" state={location.state} className="text-primary font-semibold hover:underline">Log In</Link>
        </p>
      </div>
    </div>
  )
}
