import { useEffect } from 'react'
import { Navigate, Outlet, useLocation } from 'react-router-dom'
import useStore from '../../store/useStore'

export function FullScreenLoader() {
  return (
    <div className="min-h-screen bg-cream flex items-center justify-center">
      <div className="flex flex-col items-center gap-3">
        <div className="w-10 h-10 border-4 border-primary/20 border-t-primary rounded-full animate-spin" />
        <p className="text-gray-500 text-sm">ஏற்றுகிறது…</p>
      </div>
    </div>
  )
}

// Gate for every regular (non-admin) page: must be logged in.
// Waits for the initial getSession() check before deciding, so a logged-in
// user is never incorrectly bounced to /login on refresh.
export function RequireAuth() {
  const authChecked = useStore((s) => s.authChecked)
  const session      = useStore((s) => s.session)
  const location      = useLocation()

  if (!authChecked) return <FullScreenLoader />
  if (!session) return <Navigate to="/login" state={{ from: location }} replace />
  return <Outlet />
}

// Gate for /login and /signup: if already logged in, skip straight past them.
export function PublicOnlyRoute({ children }) {
  const authChecked = useStore((s) => s.authChecked)
  const session      = useStore((s) => s.session)
  const location      = useLocation()

  if (!authChecked) return <FullScreenLoader />
  if (session) {
    const dest = location.state?.from?.pathname || '/'
    return <Navigate to={dest} replace />
  }
  return children
}

// Gate for /admin/*: must be logged in AND present in the public.admins
// allowlist. Being logged in alone is NOT enough — see auth_signup_setup.sql
// for why (public sign-up would otherwise let any student/teacher into the CMS).
export function AdminRoute({ children }) {
  const authChecked    = useStore((s) => s.authChecked)
  const session          = useStore((s) => s.session)
  const isAdmin           = useStore((s) => s.isAdmin)
  const isAdminChecked    = useStore((s) => s.isAdminChecked)
  const checkAdminStatus  = useStore((s) => s.checkAdminStatus)

  useEffect(() => {
    if (authChecked && session && !isAdminChecked) checkAdminStatus()
  }, [authChecked, session, isAdminChecked, checkAdminStatus])

  if (!authChecked) return <FullScreenLoader />
  if (!session) return <Navigate to="/admin/login" replace />
  if (!isAdminChecked) return <FullScreenLoader />
  if (!isAdmin) {
    return (
      <div className="min-h-screen bg-cream flex items-center justify-center px-4">
        <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-sm text-center">
          <h1 className="text-xl font-bold text-primary mb-2">அணுகல் மறுக்கப்பட்டது</h1>
          <p className="text-gray-600 text-sm mb-1">இது நிர்வாகக் கணக்கு அல்ல.</p>
          <p className="text-gray-400 text-xs">This account does not have admin access.</p>
        </div>
      </div>
    )
  }
  return children
}
