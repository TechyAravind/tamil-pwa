import { useEffect, useState } from 'react'
import { useNavigate, useOutletContext } from 'react-router-dom'
import { supabase } from '../supabase'

// Build a parent → children tree from a flat subtopics list
function buildTree(subtopics) {
  const parents = subtopics.filter((s) => !s.parent_id)
  return parents.map((p) => ({
    ...p,
    children: subtopics.filter((c) => c.parent_id === p.id),
  }))
}

export default function PhysicsChapterTheoryPage() {
  const { chapterId } = useOutletContext()
  const navigate = useNavigate()
  const [subtopics, setSubtopics] = useState([])
  const [loading, setLoading]     = useState(true)

  useEffect(() => {
    async function load() {
      const { data } = await supabase
        .from('physics_subtopics')
        .select('*')
        .eq('chapter_id', chapterId)
        .order('order_index')
      setSubtopics(data || [])
      setLoading(false)
    }
    load()
  }, [chapterId])

  const tree = buildTree(subtopics)

  if (loading) return <p className="text-gray-400 text-center py-10">Loading…</p>

  if (tree.length === 0) {
    return (
      <div className="card text-center py-14 text-gray-400">
        No subtopics added yet for this chapter.
      </div>
    )
  }

  return (
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
}
