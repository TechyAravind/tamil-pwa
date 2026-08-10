import { useEffect, useState } from 'react'
import { useNavigate, useParams, NavLink, Outlet } from 'react-router-dom'
import { supabase } from '../supabase'

const TABS = [
  { to: 'theory',      label: 'Theory (Full Portion)', icon: '📘' },
  { to: 'exam-notes',  label: 'Exam Notes',             icon: '📝' },
  { to: 'interactive', label: 'Interactive Physics',    icon: '🧪' },
  { to: 'formulas',    label: 'Formulas',                icon: '∑' },
]

// Shared shell for the 4 chapter pages (Theory / Exam Notes /
// Interactive Physics / Formulas). Each is now a real route instead of
// client-side tab state, so switching between them is a normal
// navigation (URL updates, browser back/forward works). Fetches the
// chapter + group once and hands it down to children via <Outlet context>.
export default function PhysicsChapterLayout() {
  const { chapterId } = useParams()
  const navigate = useNavigate()
  const [chapter, setChapter]     = useState(null)
  const [groupId, setGroupId]     = useState(null)
  const [groupName, setGroupName] = useState('')
  const [loading, setLoading]     = useState(true)

  useEffect(() => {
    async function load() {
      const { data } = await supabase
        .from('physics_chapters')
        .select('*, physics_groups(name)')
        .eq('id', chapterId)
        .single()
      setChapter(data)
      setGroupName(data?.physics_groups?.name || '')
      setGroupId(data?.group_id || null)
      setLoading(false)
    }
    load()
  }, [chapterId])

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
          <p className="text-sm text-[#8E44AD] font-semibold uppercase tracking-wide">{groupName}</p>
          <button
            onClick={goToTOC}
            className="text-xs font-semibold text-[#8E44AD] hover:text-[#6b3384]
                       flex items-center gap-1 shrink-0 min-h-[32px] px-1"
          >
            ← All Chapters
          </button>
        </div>
        <h2 className="text-2xl font-bold text-gray-900 mb-6">{chapter?.title}</h2>

        {/* Tab strip -- now real links, not local state */}
        <div className="flex gap-2 mb-6 flex-wrap">
          {TABS.map((tab) => (
            <NavLink
              key={tab.to}
              to={`/physics/chapter/${chapterId}/${tab.to}`}
              className={({ isActive }) =>
                `flex items-center gap-2 px-4 py-2 rounded-xl border text-sm
                 font-semibold transition-colors min-h-[44px]
                 ${isActive
                   ? 'bg-[#8E44AD] text-white border-[#8E44AD] shadow-sm'
                   : 'bg-white text-[#8E44AD] border-gray-200 hover:border-[#8E44AD]'
                 }`
              }
            >
              <span>{tab.icon}</span>
              <span>{tab.label}</span>
            </NavLink>
          ))}
        </div>

        {loading ? (
          <p className="text-gray-400 text-center py-10">Loading…</p>
        ) : (
          <Outlet context={{ chapter, chapterId, groupId, groupName }} />
        )}
      </main>
    </div>
  )
}
