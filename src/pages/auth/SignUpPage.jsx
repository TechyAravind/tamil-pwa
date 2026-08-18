import { useState } from 'react'
import { Link, useNavigate, useLocation } from 'react-router-dom'
import useStore from '../../store/useStore'

const CLASSES = ['6', '7', '8', '9', '10', '11', '12']

const REFERRAL_OPTIONS = [
  { value: 'friend',        label: 'நண்பர் (Friend)' },
  { value: 'google',        label: 'Google' },
  { value: 'youtube',       label: 'YouTube' },
  { value: 'instagram',     label: 'Instagram' },
  { value: 'snapchat',      label: 'Snapchat' },
  { value: 'linkedin',      label: 'LinkedIn' },
  { value: 'ai_suggestion', label: 'AI Suggestion (ChatGPT / Claude போன்றவை)' },
  { value: 'others',        label: 'மற்றவை (Others)' },
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
    if (!form.email.trim()) e.email = 'மின்னஞ்சல் தேவை'
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email.trim())) e.email = 'சரியான மின்னஞ்சலை உள்ளிடவும்'

    if (!form.mobileNumber.trim()) e.mobileNumber = 'கைபேசி எண் தேவை'
    else if (!/^[6-9][0-9]{9}$/.test(form.mobileNumber.trim())) e.mobileNumber = '10 இலக்க இந்திய கைபேசி எண்ணை உள்ளிடவும் (உ.ம். 9876543210)'

    if (!form.password) e.password = 'கடவுச்சொல் தேவை'
    else if (form.password.length < 6) e.password = 'குறைந்தது 6 எழுத்துகள் தேவை'

    if (form.confirmPassword !== form.password) e.confirmPassword = 'கடவுச்சொற்கள் பொருந்தவில்லை'

    if (!form.schoolName.trim()) e.schoolName = 'பள்ளியின் பெயர் தேவை'

    if (!form.role) e.role = 'ஒன்றைத் தேர்ந்தெடுக்கவும்'

    if (form.role === 'student' && !form.studentClass) e.studentClass = 'வகுப்பைத் தேர்ந்தெடுக்கவும்'
    if (form.role === 'teacher' && form.teacherClasses.length === 0) e.teacherClasses = 'குறைந்தது ஒரு வகுப்பையேனும் தேர்ந்தெடுக்கவும்'

    if (!form.referralSource) e.referralSource = 'ஒன்றைத் தேர்ந்தெடுக்கவும்'

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
          <h1 className="text-xl font-bold text-primary mb-2">கணக்கு உருவாக்கப்பட்டது!</h1>
          <p className="text-gray-600 text-sm mb-4">
            உங்கள் மின்னஞ்சலுக்கு ஒரு உறுதிப்படுத்தல் இணைப்பு அனுப்பப்பட்டுள்ளது.
            அதை உறுதிசெய்த பின் உள்நுழையவும்.
          </p>
          <Link to="/login" className="btn-primary w-full justify-center">உள்நுழைவுக்குச் செல்க</Link>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-cream flex items-center justify-center px-4 py-8">
      <div className="bg-white rounded-2xl shadow-xl p-6 sm:p-8 w-full max-w-lg">
        <h1 className="text-2xl font-bold text-primary mb-1">புதிய கணக்கு உருவாக்குக</h1>
        <p className="text-gray-500 text-sm mb-6">Sign Up — பாடங்களைத் தொடர இலவசக் கணக்கு உருவாக்கவும்</p>

        <form onSubmit={handleSubmit} noValidate className="space-y-4">
          <div>
            <label className="label">மின்னஞ்சல் (Email) *</label>
            <input
              type="email" className="input" value={form.email}
              onChange={(e) => setField('email', e.target.value)}
              placeholder="you@example.com" autoComplete="email"
            />
            {fieldErrors.email && <p className="text-red-600 text-xs mt-1">{fieldErrors.email}</p>}
          </div>

          <div>
            <label className="label">கைபேசி எண் (Mobile Number) *</label>
            <input
              type="tel" inputMode="numeric" className="input" value={form.mobileNumber}
              onChange={(e) => setField('mobileNumber', e.target.value.replace(/\D/g, '').slice(0, 10))}
              placeholder="9876543210" autoComplete="tel" maxLength={10}
            />
            {fieldErrors.mobileNumber && <p className="text-red-600 text-xs mt-1">{fieldErrors.mobileNumber}</p>}
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="label">கடவுச்சொல் (Password) *</label>
              <input
                type="password" className="input" value={form.password}
                onChange={(e) => setField('password', e.target.value)}
                placeholder="••••••••" autoComplete="new-password"
              />
              {fieldErrors.password && <p className="text-red-600 text-xs mt-1">{fieldErrors.password}</p>}
            </div>
            <div>
              <label className="label">உறுதிசெய்க (Confirm) *</label>
              <input
                type="password" className="input" value={form.confirmPassword}
                onChange={(e) => setField('confirmPassword', e.target.value)}
                placeholder="••••••••" autoComplete="new-password"
              />
              {fieldErrors.confirmPassword && <p className="text-red-600 text-xs mt-1">{fieldErrors.confirmPassword}</p>}
            </div>
          </div>

          <div>
            <label className="label">பள்ளியின் பெயர் (School Name) *</label>
            <input
              type="text" className="input" value={form.schoolName}
              onChange={(e) => setField('schoolName', e.target.value)}
              placeholder="உ.ம. St. Xavier's Matriculation School"
            />
            {fieldErrors.schoolName && <p className="text-red-600 text-xs mt-1">{fieldErrors.schoolName}</p>}
          </div>

          <div>
            <label className="label">நீங்கள் யார்? (Teacher / Student) *</label>
            <div className="flex gap-3">
              {[
                { value: 'student', label: 'மாணவர் (Student)' },
                { value: 'teacher', label: 'ஆசிரியர் (Teacher)' },
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
              <label className="label">வகுப்பு (Class) — ஒன்றைத் தேர்ந்தெடுக்கவும் *</label>
              <select
                className="input" value={form.studentClass}
                onChange={(e) => setField('studentClass', e.target.value)}
              >
                <option value="">-- தேர்ந்தெடுக்கவும் --</option>
                {CLASSES.map((c) => <option key={c} value={c}>{c}ஆம் வகுப்பு</option>)}
              </select>
              {fieldErrors.studentClass && <p className="text-red-600 text-xs mt-1">{fieldErrors.studentClass}</p>}
            </div>
          )}

          {form.role === 'teacher' && (
            <div>
              <label className="label">நீங்கள் கற்பிக்கும் வகுப்புகள் — பொருந்துவனவற்றைத் தேர்ந்தெடுக்கவும் *</label>
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
            <label className="label">எங்களைப் பற்றி எப்படி அறிந்தீர்கள்? (Where did you hear about us?) *</label>
            <select
              className="input" value={form.referralSource}
              onChange={(e) => setField('referralSource', e.target.value)}
            >
              <option value="">-- தேர்ந்தெடுக்கவும் --</option>
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
            {loading ? 'உருவாக்குகிறது…' : 'கணக்கு உருவாக்குக'}
          </button>
        </form>

        <p className="text-center text-sm text-gray-500 mt-5">
          ஏற்கெனவே கணக்கு உள்ளதா?{' '}
          <Link to="/login" state={location.state} className="text-primary font-semibold hover:underline">உள்நுழையவும்</Link>
        </p>
      </div>
    </div>
  )
}
