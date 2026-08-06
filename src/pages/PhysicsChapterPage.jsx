import { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { supabase } from '../supabase'
import { isLessonComplete } from '../utils/lessonProgress'

const CHAPTER_TABS = [
  { id: 'theory',      label: 'Theory (Full Portion)', icon: '📘' },
  { id: 'examnotes',   label: 'Exam Notes',             icon: '📝' },
  { id: 'interactive', label: 'Interactive Physics',    icon: '🧪' },
]

function ComingSoon({ label, icon }) {
  return (
    <div className="card text-center py-16 text-gray-400 space-y-3">
      <div className="text-5xl">{icon}</div>
      <p className="text-lg font-semibold text-gray-500">{label} — Coming soon</p>
      <p className="text-sm text-gray-400 max-w-xs mx-auto">
        This section will be added in a future update.
      </p>
    </div>
  )
}

// Build a parent → children tree from a flat subtopics list
function buildTree(subtopics) {
  const parents = subtopics.filter((s) => !s.parent_id)
  return parents.map((p) => ({
    ...p,
    children: subtopics.filter((c) => c.parent_id === p.id),
  }))
}

export default function PhysicsChapterPage() {
  const { chapterId } = useParams()
  const navigate       = useNavigate()
  const [chapter, setChapter]     = useState(null)
  const [groupName, setGroupName] = useState('')
  const [groupId, setGroupId]     = useState(null)
  const [subtopics, setSubtopics] = useState([])
  const [ipLessons, setIpLessons] = useState([])
  const [activeTab, setActiveTab] = useState('theory')
  const [loading, setLoading]     = useState(true)

  useEffect(() => {
    async function load() {
      const { data: chapterData } = await supabase
        .from('physics_chapters')
        .select('*, physics_groups(name)')
        .eq('id', chapterId)
        .single()
      setChapter(chapterData)
      setGroupName(chapterData?.physics_groups?.name || '')
      setGroupId(chapterData?.group_id || null)

      const { data: subtopicData } = await supabase
        .from('physics_subtopics')
        .select('*')
        .eq('chapter_id', chapterId)
        .order('order_index')
      setSubtopics(subtopicData || [])

      const { data: lessonData } = await supabase
        .from('physics_ip_lessons')
        .select('*')
        .eq('chapter_id', chapterId)
        .order('order_index')
      setIpLessons(lessonData || [])

      setLoading(false)
    }
    load()
  }, [chapterId])

  const tree = buildTree(subtopics)

  // Always resolve to the TOC page for this chapter's group — never rely on
  // browser history (navigate(-1)), which can ping-pong between this page
  // and a subtopic page when they're reached via different navigation paths.
  const goToTOC = () => {
    navigate(groupId ? `/physics/classical/11/content/${groupId}` : '/physics/classical/11/content')
  }

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <header className="sticky top-0 z-30 bg-gradient-to-r from-[#4A235A] to-[#8E44AD] text-white shadow-md">
        <div className="flex items-center h-14 px-4 gap-3 max-w-2xl mx-auto">
          <button
            onClick={goToTOC}
            aria-label="Back to Table of Contents"
            className="min-w-[44px] min-h-[44px] flex items-center justify-center
                       rounded-lg hover:bg-white/10 active:bg-white/20 transition-colors text-xl"
          >
            ←
          </button>
          <h1 className="flex-1 font-bold text-lg truncate">{chapter?.title || 'Chapter'}</h1>
        </div>
      </header>

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        <div className="flex items-center justify-between gap-3 mb-1">
          <p className="text-sm text-[#8E44AD] font-semibold uppercase tracking-wide">
            {groupName}
          </p>
          <button
            onClick={goToTOC}
            className="text-xs font-semibold text-[#8E44AD] hover:text-[#6b3384]
                       flex items-center gap-1 shrink-0 min-h-[32px] px-1"
          >
            ← All Chapters
          </button>
        </div>
        <h2 className="text-2xl font-bold text-gray-900 mb-6">{chapter?.title}</h2>

        {/* Tab strip */}
        <div className="flex gap-2 mb-6 flex-wrap">
          {CHAPTER_TABS.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex items-center gap-2 px-4 py-2 rounded-xl border text-sm
                          font-semibold transition-colors min-h-[44px]
                          ${activeTab === tab.id
                            ? 'bg-[#8E44AD] text-white border-[#8E44AD] shadow-sm'
                            : 'bg-white text-[#8E44AD] border-gray-200 hover:border-[#8E44AD]'
                          }`}
            >
              <span>{tab.icon}</span>
              <span>{tab.label}</span>
            </button>
          ))}
        </div>

        {loading && <p className="text-gray-400 text-center py-10">Loading…</p>}

        {!loading && activeTab === 'theory' && (
          tree.length === 0 ? (
            <div className="card text-center py-14 text-gray-400">
              No subtopics added yet for this chapter.
            </div>
          ) : (
            <div className="card divide-y divide-cream-dark p-0 overflow-hidden">
              {tree.map((p, i) => (
                <div key={p.id}>
                  <button
                    onClick={() => navigate(`/physics/chapter/${chapterId}/subtopic/${p.id}`)}
                    className="w-full text-left px-5 py-4 hover:bg-[#8E44AD]/5
                               active:bg-[#8E44AD]/10 flex items-center gap-3 min-h-[56px]
                               transition-colors"
                  >
                    <span className="text-[#8E44AD] font-bold shrink-0">{i + 1}.</span>
                    <span className="text-base text-gray-800 flex-1 leading-snug font-medium">{p.title}</span>
                    <span className="text-gray-400 shrink-0">›</span>
                  </button>
                  {p.children.map((c, j) => (
                    <button
                      key={c.id}
                      onClick={() => navigate(`/physics/chapter/${chapterId}/subtopic/${c.id}`)}
                      className="w-full text-left pl-11 pr-5 py-3 hover:bg-[#8E44AD]/5
                                 active:bg-[#8E44AD]/10 flex items-center gap-3 min-h-[48px]
                                 transition-colors border-t border-cream-dark/60"
                    >
                      <span className="text-[#8E44AD]/70 text-sm shrink-0">{i + 1}.{j + 1}</span>
                      <span className="text-sm text-gray-700 flex-1 leading-snug">{c.title}</span>
                      <span className="text-gray-300 shrink-0">›</span>
                    </button>
                  ))}
                </div>
              ))}
            </div>
          )
        )}

        {!loading && activeTab === 'examnotes' && (
          <ComingSoon label="Exam Notes" icon="📝" />
        )}

        {!loading && activeTab === 'interactive' && (
          ipLessons.length === 0 ? (
            <ComingSoon label="Interactive Physics" icon="🧪" />
          ) : (
            <div className="space-y-3">
              <p className="text-xs text-gray-400 -mt-1 mb-2">
                Short, story-driven lessons — a hook, a clear explanation, a worked example, then practice questions.
              </p>
              {ipLessons.map((lesson, i) => {
                const done = isLessonComplete(lesson.id)
                return (
                  <button
                    key={lesson.id}
                    onClick={() => navigate(`/physics/chapter/${chapterId}/interactive/${lesson.id}`)}
                    className="w-full text-left card flex items-center gap-4 hover:border-[#8E44AD]
                               hover:shadow-md active:scale-[0.99] transition-all min-h-[72px]"
                  >
                    <span className="w-9 h-9 rounded-full bg-[#8E44AD]/10 text-[#8E44AD] font-bold
                                     flex items-center justify-center shrink-0 text-sm">
                      {i + 1}
                    </span>
                    <div className="flex-1">
                      <p className="font-bold text-gray-900">{lesson.title}</p>
                      {lesson.hook_summary && (
                        <p className="text-sm text-gray-500 mt-0.5">{lesson.hook_summary}</p>
                      )}
                    </div>
                    {done ? (
                      <span className="text-green-600 text-xs font-bold bg-green-50 border border-green-200
                                       rounded-full px-2.5 py-1 shrink-0">✓ Done</span>
                    ) : (
                      <span className="text-gray-300 text-xl shrink-0">›</span>
                    )}
                  </button>
                )
              })}
            </div>
          )
        )}
      </main>
    </div>
  )
}
