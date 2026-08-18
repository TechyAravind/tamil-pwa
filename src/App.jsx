import { useEffect } from 'react'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { supabase } from './supabase'
import useStore from './store/useStore'
import { RequireAuth, PublicOnlyRoute, AdminRoute } from './components/auth/RouteGuards'

// -- Auth pages -------------------------------------------------------------
import SignUpPage        from './pages/auth/SignUpPage'
import LoginPage         from './pages/auth/LoginPage'
import ResetPasswordPage from './pages/auth/ResetPasswordPage'

// -- Platform pages -----------------------------------------------------------
import LangfluencerPage from './pages/LangfluencerPage'
import SubjectPage      from './pages/SubjectPage'

// -- Student pages (11th Tamil) -------------------------------------------------
import LandingPage    from './pages/LandingPage'
import TOCPage        from './pages/TOCPage'
import TopicPage      from './pages/TopicPage'
import ProsePage      from './pages/ProsePage'
import PoemPage       from './pages/PoemPage'
import StudyPage          from './pages/StudyPage'
import QuizPage           from './pages/QuizPage'
import ProseContentPage   from './pages/ProseContentPage'
import GrammarNotePage    from './pages/GrammarNotePage'

// -- Physics pages (Classical Physics · 11th Standard) --------------------------
import PhysicsBranchPage    from './pages/PhysicsBranchPage'
import PhysicsLandingPage   from './pages/PhysicsLandingPage'
import PhysicsGroupsPage    from './pages/PhysicsGroupsPage'
import PhysicsTOCPage       from './pages/PhysicsTOCPage'
import PhysicsChapterLayout        from './pages/PhysicsChapterLayout'
import PhysicsChapterTheoryPage    from './pages/PhysicsChapterTheoryPage'
import PhysicsChapterExamNotesPage from './pages/PhysicsChapterExamNotesPage'
import PhysicsChapterInteractivePage from './pages/PhysicsChapterInteractivePage'
import PhysicsChapterFormulasPage  from './pages/PhysicsChapterFormulasPage'
import PhysicsSubtopicPage  from './pages/PhysicsSubtopicPage'
import PhysicsInteractiveLessonPage from './pages/PhysicsInteractiveLessonPage'

// -- Admin pages ----------------------------------------------------------------
import AdminLogin     from './pages/admin/LoginPage'
import AdminLayout    from './pages/admin/AdminLayout'
import AdminDashboard from './pages/admin/Dashboard'
import AdminSections  from './pages/admin/AdminSections'
import AdminTopics    from './pages/admin/AdminTopics'
import AdminPages     from './pages/admin/AdminPages'
import AdminPoemLines from './pages/admin/AdminPoemLines'
import AdminMorphemes from './pages/admin/AdminMorphemes'
import AdminVerbAnalysis  from './pages/admin/AdminVerbAnalysis'
import AdminSandhiRules   from './pages/admin/AdminSandhiRules'
import AdminLiteraryNotes from './pages/admin/AdminLiteraryNotes'
import AdminProseContent  from './pages/admin/AdminProseContent'
import AdminPhysicsGroups    from './pages/admin/AdminPhysicsGroups'
import AdminPhysicsChapters  from './pages/admin/AdminPhysicsChapters'
import AdminPhysicsSubtopics from './pages/admin/AdminPhysicsSubtopics'
import AdminPhysicsContent   from './pages/admin/AdminPhysicsContent'

export default function App() {
  const setSession     = useStore((s) => s.setSession)
  const setAuthChecked = useStore((s) => s.setAuthChecked)
  const fetchProfile    = useStore((s) => s.fetchProfile)
  const resetAuthDerivedState = useStore((s) => s.resetAuthDerivedState)

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session)
      setAuthChecked(true)
      if (session) fetchProfile()
    })
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
      setAuthChecked(true)
      if (session) fetchProfile()
      else resetAuthDerivedState()
    })
    return () => subscription.unsubscribe()
  }, [])

  return (
    <BrowserRouter>
      <Routes>
        {/* Auth */}
        <Route path="/login"          element={<PublicOnlyRoute><LoginPage /></PublicOnlyRoute>} />
        <Route path="/signup"         element={<PublicOnlyRoute><SignUpPage /></PublicOnlyRoute>} />
        <Route path="/reset-password" element={<ResetPasswordPage />} />

        {/* Everything below requires a logged-in user */}
        <Route element={<RequireAuth />}>
          {/* Langfluencer platform (root) */}
          <Route path="/"                      element={<LangfluencerPage />} />
          <Route path="/subject/:subjectId"    element={<SubjectPage />} />

          {/* 11th Tamil app */}
          <Route path="/tamil/11"                        element={<LandingPage />} />
          <Route path="/toc"                             element={<TOCPage />} />
          <Route path="/topic/:topicId"                  element={<TopicPage />} />
          <Route path="/topic/:topicId/poem"             element={<PoemPage />} />
          <Route path="/topic/:topicId/prose-content"   element={<ProseContentPage />} />
          <Route path="/ilakkanam-kurippu/:label"        element={<GrammarNotePage />} />
          <Route path="/topic/:topicId/study"            element={<StudyPage />} />
          <Route path="/topic/:topicId/quiz"             element={<QuizPage />} />
          <Route path="/topic/:topicId/:pageType"        element={<ProsePage />} />

          {/* Physics (Classical Physics · 11th Standard) */}
          <Route path="/physics/classical"                              element={<PhysicsBranchPage />} />
          <Route path="/physics/classical/11"                           element={<PhysicsLandingPage />} />
          <Route path="/physics/classical/11/content"                  element={<PhysicsGroupsPage />} />
          <Route path="/physics/classical/11/content/:groupId"         element={<PhysicsTOCPage />} />
          <Route path="/physics/chapter/:chapterId" element={<PhysicsChapterLayout />}>
            <Route index               element={<Navigate to="theory" replace />} />
            <Route path="theory"       element={<PhysicsChapterTheoryPage />} />
            <Route path="exam-notes"   element={<PhysicsChapterExamNotesPage />} />
            <Route path="interactive"  element={<PhysicsChapterInteractivePage />} />
            <Route path="formulas"     element={<PhysicsChapterFormulasPage />} />
          </Route>
          <Route path="/physics/chapter/:chapterId/subtopic/:subtopicId" element={<PhysicsSubtopicPage />} />
          <Route path="/physics/chapter/:chapterId/interactive/:lessonId" element={<PhysicsInteractiveLessonPage />} />
        </Route>

        {/* Admin routes — separate login, separate allowlist check (see AdminRoute) */}
        <Route path="/admin/login" element={<AdminLogin />} />
        <Route path="/admin" element={
          <AdminRoute><AdminLayout /></AdminRoute>
        }>
          <Route index               element={<AdminDashboard />} />
          <Route path="sections"     element={<AdminSections />} />
          <Route path="topics"       element={<AdminTopics />} />
          <Route path="pages"        element={<AdminPages />} />
          <Route path="poemlines"    element={<AdminPoemLines />} />
          <Route path="morphemes"    element={<AdminMorphemes />} />
          <Route path="verbanalysis" element={<AdminVerbAnalysis />} />
          <Route path="sandhirules"  element={<AdminSandhiRules />} />
          <Route path="literary"     element={<AdminLiteraryNotes />} />
          <Route path="prose"        element={<AdminProseContent />} />
          <Route path="physics-groups"    element={<AdminPhysicsGroups />} />
          <Route path="physics-chapters"  element={<AdminPhysicsChapters />} />
          <Route path="physics-subtopics" element={<AdminPhysicsSubtopics />} />
          <Route path="physics-content"   element={<AdminPhysicsContent />} />
        </Route>

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
