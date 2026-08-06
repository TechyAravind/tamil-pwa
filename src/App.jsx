import { useEffect } from 'react'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { supabase } from './supabase'
import useStore from './store/useStore'

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
import PhysicsChapterPage   from './pages/PhysicsChapterPage'
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
    supabase.auth.getSession().then(({ data: { session } }) => setSession(session))
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
    })
    return () => subscription.unsubscribe()
  }, [])

  return (
    <BrowserRouter>
      <Routes>
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
        <Route path="/physics/chapter/:chapterId"                     element={<PhysicsChapterPage />} />
        <Route path="/physics/chapter/:chapterId/subtopic/:subtopicId" element={<PhysicsSubtopicPage />} />
        <Route path="/physics/chapter/:chapterId/interactive/:lessonId" element={<PhysicsInteractiveLessonPage />} />

        {/* Admin routes */}
        <Route path="/admin/login" element={<AdminLogin />} />
        <Route path="/admin" element={
          <ProtectedRoute><AdminLayout /></ProtectedRoute>
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
