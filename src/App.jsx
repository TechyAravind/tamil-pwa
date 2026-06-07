import { useEffect } from 'react'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { supabase } from './supabase'
import useStore from './store/useStore'

// Student pages
import LandingPage    from './pages/LandingPage'
import TOCPage        from './pages/TOCPage'
import TopicPage      from './pages/TopicPage'
import ProsePage      from './pages/ProsePage'
import PoemPage       from './pages/PoemPage'

// Admin pages
import AdminLogin     from './pages/admin/LoginPage'
import AdminLayout    from './pages/admin/AdminLayout'
import AdminDashboard from './pages/admin/Dashboard'
import AdminSections  from './pages/admin/AdminSections'
import AdminTopics    from './pages/admin/AdminTopics'
import AdminPages     from './pages/admin/AdminPages'
import AdminPoemLines from './pages/admin/AdminPoemLines'
import AdminMorphemes from './pages/admin/AdminMorphemes'
import AdminVerbAnalysis  from './pages/admin/AdminVerbAnalysis'
import AdminLiteraryNotes from './pages/admin/AdminLiteraryNotes'
import AdminProseContent  from './pages/admin/AdminProseContent'

// Guard: redirect to login if not authenticated
function ProtectedRoute({ children }) {
  const session = useStore((s) => s.session)
  if (session === undefined) return null  // still loading
  if (!session) return <Navigate to="/admin/login" replace />
  return children
}

export default function App() {
  const setSession = useStore((s) => s.setSession)

  useEffect(() => {
    // Restore session on mount
    supabase.auth.getSession().then(({ data: { session } }) => setSession(session))
    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
    })
    return () => subscription.unsubscribe()
  }, [])

  return (
    <BrowserRouter>
      <Routes>
        {/* ── Student routes ─────────────────────── */}
        <Route path="/"                           element={<LandingPage />} />
        <Route path="/toc"                        element={<TOCPage />} />
        <Route path="/topic/:topicId"             element={<TopicPage />} />
        <Route path="/topic/:topicId/poem"        element={<PoemPage />} />
        <Route path="/topic/:topicId/:pageType"   element={<ProsePage />} />

        {/* ── Admin routes ───────────────────────── */}
        <Route path="/admin/login" element={<AdminLogin />} />
        <Route path="/admin" element={
          <ProtectedRoute><AdminLayout /></ProtectedRoute>
        }>
          <Route index              element={<AdminDashboard />} />
          <Route path="sections"    element={<AdminSections />} />
          <Route path="topics"      element={<AdminTopics />} />
          <Route path="pages"       element={<AdminPages />} />
          <Route path="poemlines"   element={<AdminPoemLines />} />
          <Route path="morphemes"   element={<AdminMorphemes />} />
          <Route path="verbanalysis" element={<AdminVerbAnalysis />} />
          <Route path="literary"    element={<AdminLiteraryNotes />} />
          <Route path="prose"       element={<AdminProseContent />} />
        </Route>

        {/* ── Fallback ───────────────────────────── */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
