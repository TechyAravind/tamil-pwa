import { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { supabase } from '../supabase'

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
  const [subtopics, setSubtopics] = useState([])
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

      const { data: subtopicData } = await supabase
        .from('physics_subtopics')
        .select('*')
        .eq('chapter_id', chapterId)
        .order('order_index')
      setSubtopics(subtopicData || [])
      setLoading(false)
    }
    load()
  }, [chapterId])

  const tree = buildTree(subtopics)

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <header className="sticky top-0 z-30 bg-gradient-to-r from-[#4A235A] to-[#8E44AD] text-white shadow-md">
        <div className="flex items-center h-14 px-4 gap-3 max-w-2xl mx-auto">
          <button
            onClick={() => navigate(-1)}
            aria-label="Back"
            className="min-w-[44px] min-h-[44px] flex items-center justify-center
                       rounded-lg hover:bg-white/10 active:bg-white/20 transition-colors text-xl"
          >
            ←
          </button>
          <h1 className="flex-1 font-bold text-lg truncate">{chapter?.title || 'Chapter'}</h1>
        </div>
      </header>

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        <p className="text-sm text-[#8E44AD] font-semibold mb-1 uppercase tracking-wide">
          {groupName}
        </p>
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
          <ComingSoon label="Interactive Physics" icon="🧪" />
        )}
      </main>
    </div>
  )
}
