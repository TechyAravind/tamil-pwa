import { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { supabase } from '../supabase'

export default function PhysicsTOCPage() {
  const { groupId } = useParams()
  const navigate     = useNavigate()
  const [group, setGroup]       = useState(null)
  const [chapters, setChapters] = useState([])
  const [loading, setLoading]   = useState(true)

  useEffect(() => {
    async function load() {
      const [{ data: groupData }, { data: chapterData }] = await Promise.all([
        supabase.from('physics_groups').select('*').eq('id', groupId).single(),
        supabase.from('physics_chapters').select('*').eq('group_id', groupId).order('order_index'),
      ])
      setGroup(groupData)
      setChapters(chapterData || [])
      setLoading(false)
    }
    load()
  }, [groupId])

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <header className="sticky top-0 z-30 bg-gradient-to-r from-[#4A235A] to-[#8E44AD] text-white shadow-md">
        <div className="flex items-center h-14 px-4 gap-3 max-w-2xl mx-auto">
          <button
            onClick={() => navigate('/physics/classical/11/content')}
            aria-label="Back"
            className="min-w-[44px] min-h-[44px] flex items-center justify-center
                       rounded-lg hover:bg-white/10 active:bg-white/20 transition-colors text-xl"
          >
            ←
          </button>
          <h1 className="flex-1 font-bold text-lg truncate">{group?.name || 'Table of Contents'}</h1>
        </div>
      </header>

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        <p className="text-xs text-[#8E44AD] font-bold uppercase tracking-widest mb-4 text-center">
          11th Standard Physics — Table of Contents
        </p>

        {loading && <p className="text-gray-400 text-center py-10">Loading…</p>}

        {!loading && chapters.length === 0 && (
          <div className="card text-center py-14 text-gray-400">
            No chapters added yet in this group.
          </div>
        )}

        <div className="card divide-y divide-cream-dark overflow-hidden p-0">
          {chapters.map((ch, i) => (
            <button
              key={ch.id}
              onClick={() => navigate(`/physics/chapter/${ch.id}`)}
              className="w-full text-left px-5 py-4 hover:bg-[#8E44AD]/5
                         active:bg-[#8E44AD]/10 flex items-center gap-3 min-h-[56px]
                         transition-colors"
            >
              <span className="text-[#8E44AD] font-bold shrink-0">{i + 1}.</span>
              <span className="text-base text-gray-800 flex-1 leading-snug">{ch.title}</span>
              <span className="text-gray-400 shrink-0">›</span>
            </button>
          ))}
        </div>
      </main>
    </div>
  )
}
