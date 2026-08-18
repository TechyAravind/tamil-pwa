import { create } from 'zustand'
import { supabase } from '../supabase'

// Turn raw Supabase Auth error messages into short, actionable English
// messages a student/teacher/parent can understand, instead of a raw API string.
function mapAuthError(error) {
  const msg = (error?.message || '').toLowerCase()

  if (msg.includes('user already registered') || msg.includes('already registered'))
    return 'This email is already registered. Try logging in instead, or reset your password.'
  if (msg.includes('invalid login credentials'))
    return 'Incorrect email or password.'
  if (msg.includes('password') && (msg.includes('at least') || msg.includes('should be') || msg.includes('weak')))
    return 'Password must be at least 6 characters.'
  if (msg.includes('email') && msg.includes('invalid'))
    return 'Please enter a valid email address.'
  if (msg.includes('rate limit') || msg.includes('too many'))
    return 'Too many attempts — please wait a moment and try again.'
  if (msg.includes('failed to fetch') || msg.includes('network'))
    return 'Network issue — please check your connection and try again.'
  if (msg.includes('email not confirmed'))
    return 'Please confirm your email using the link we sent — you can keep using the app in the meantime.'

  return error?.message || 'Something went wrong — please try again.'
}

const useStore = create((set, get) => ({
  // ── Auth: session/profile/admin state ──────────────────────────────────
  session: null,
  authChecked: false,          // becomes true once the initial getSession() resolves
  setSession: (session) => set({ session }),
  setAuthChecked: (v) => set({ authChecked: v }),

  profile: null,
  profileLoaded: false,

  isAdmin: false,
  isAdminChecked: false,

  fetchProfile: async () => {
    const { session } = get()
    if (!session) { set({ profile: null, profileLoaded: true }); return }
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', session.user.id)
      .maybeSingle()
    if (!error) set({ profile: data, profileLoaded: true })
    else set({ profileLoaded: true })
  },

  checkAdminStatus: async () => {
    const { session } = get()
    if (!session) { set({ isAdmin: false, isAdminChecked: true }); return }
    const { data, error } = await supabase
      .from('admins')
      .select('id')
      .eq('id', session.user.id)
      .maybeSingle()
    set({ isAdmin: !!data && !error, isAdminChecked: true })
  },

  resetAuthDerivedState: () => set({
    profile: null, profileLoaded: false, isAdmin: false, isAdminChecked: false,
  }),

  // ── Sign up ───────────────────────────────────────────────────────────
  // payload: { email, password, mobileNumber, schoolName, role,
  //            studentClass, teacherClasses, referralSource }
  signUp: async (payload) => {
    const {
      email, password, mobileNumber, schoolName, role,
      studentClass, teacherClasses, referralSource,
    } = payload

    const { data, error } = await supabase.auth.signUp({
      email: email.trim(),
      password,
      options: {
        data: {
          mobile_number: mobileNumber.trim(),
          school_name: schoolName.trim(),
          role,
          student_class: role === 'student' ? studentClass : null,
          teacher_classes: role === 'teacher' ? teacherClasses : null,
          referral_source: referralSource,
        },
      },
    })

    if (error) return { error: mapAuthError(error) }

    // Supabase returns a session immediately when email-confirmation is off;
    // if it's on, data.session is null and the user must click the emailed
    // link — either way we don't block the caller here.
    if (data?.session) set({ session: data.session })
    return { error: null, needsEmailConfirmation: !data?.session }
  },

  // ── Log in / out ──────────────────────────────────────────────────────
  signIn: async (email, password) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: email.trim(),
      password,
    })
    if (error) return { error: mapAuthError(error) }
    set({ session: data.session })
    return { error: null }
  },

  signOut: async () => {
    await supabase.auth.signOut()
    set({ session: null })
    get().resetAuthDerivedState()
  },

  requestPasswordReset: async (email) => {
    const { error } = await supabase.auth.resetPasswordForEmail(email.trim(), {
      redirectTo: `${window.location.origin}/reset-password`,
    })
    if (error) return { error: mapAuthError(error) }
    return { error: null }
  },

  updatePassword: async (newPassword) => {
    const { error } = await supabase.auth.updateUser({ password: newPassword })
    if (error) return { error: mapAuthError(error) }
    return { error: null }
  },

  // ── Sections & Topics ─────────────────────────
  sections: [],
  topics: {},        // keyed by sectionId
  sectionsLoaded: false,

  fetchSections: async () => {
    if (get().sectionsLoaded) return
    const { data, error } = await supabase
      .from('sections')
      .select('*')
      .order('order_index')
    if (!error) set({ sections: data, sectionsLoaded: true })
  },

  fetchTopicsForSection: async (sectionId) => {
    if (get().topics[sectionId]) return
    const { data, error } = await supabase
      .from('topics')
      .select('*')
      .eq('section_id', sectionId)
      .order('order_index')
    if (!error) set((s) => ({ topics: { ...s.topics, [sectionId]: data } }))
  },

  // ── Font size preference ───────────────────────
  fontSize: localStorage.getItem('fontSize') || 'medium',
  setFontSize: (size) => {
    localStorage.setItem('fontSize', size)
    set({ fontSize: size })
  }
}))

export default useStore
