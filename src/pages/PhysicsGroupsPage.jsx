import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../supabase'

const GROUP_ICONS = ['🧲', '🌡️', '🌊'] // Mechanics / Bulk Matter & Thermal / Oscillations & Waves — by order

export default function PhysicsGroupsPage() {
  const navigate = useNavigate()
  const [groups, setGroups]   = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function load() {
      const { data } = await supabase
        .from('physics_groups')
        .select('*')
        .order('order_index')
      setGroups(data || [])
      setLoading(false)
    }
    load()
  }, [])

  return (
    <div className="min-h-screen bg-primary flex flex-col">
      <div className="relative z-10 pt-4 px-4">
        <button
          onClick={() => navigate('/physics/classical/11')}
          className="flex items-center gap-2 text-white/70 hover:text-white
                     transition-colors min-h-[44px] text-sm"
        >
          ← Physics
        </button>
      </div>

      <header className="relative z-10 text-center pt-6 pb-6 px-4">
        <p className="text-[#C9A6E0] text-xs font-bold tracking-[0.3em] uppercase mb-2">
          11th Standard · Physics
        </p>
        <h1 className="text-4xl font-black text-white">Content</h1>
        <p className="text-white/50 text-sm mt-2">Choose a broad topic to see its chapters</p>
      </header>

      <main className="flex-1 max-w-md mx-auto w-full px-4 pb-10 space-y-3">
        {loading && (
          <p className="text-white/50 text-center py-10">Loading…</p>
        )}

        {!loading && groups.length === 0 && (
          <div className="bg-white/5 border border-white/10 rounded-2xl p-8 text-center text-white/50">
            No topics added yet. Add groups from /admin/physics-groups.
          </div>
        )}

        {groups.map((g, i) => (
          <button
            key={g.id}
            onClick={() => navigate(`/physics/classical/11/content/${g.id}`)}
            className="w-full flex items-center gap-4 px-6 py-5 rounded-2xl
                       bg-gradient-to-br from-[#4A235A] to-[#8E44AD] border border-white/20
                       text-white hover:scale-[1.02] active:scale-95 shadow-md
                       transition-all duration-200"
          >
            <span className="text-3xl">{GROUP_ICONS[i % GROUP_ICONS.length]}</span>
            <span className="flex-1 text-left font-bold text-lg leading-tight">{g.name}</span>
            <span className="text-xl opacity-70">›</span>
          </button>
        ))}
      </main>
    </div>
  )
}
