import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../../supabase'

export default function AdminDashboard() {
  const navigate = useNavigate()
  const [counts, setCounts] = useState({})

  useEffect(() => {
    async function loadCounts() {
      const tables = ['sections', 'topics', 'pages', 'poem_lines', 'morphemes']
      const results = await Promise.all(
        tables.map((t) => supabase.from(t).select('id', { count: 'exact', head: true }))
      )
      const c = {}
      tables.forEach((t, i) => { c[t] = results[i].count || 0 })
      setCounts(c)
    }
    loadCounts()
  }, [])

  const STATS = [
    { label: 'Sections',  value: counts.sections,   to: '/admin/sections' },
    { label: 'Topics',    value: counts.topics,     to: '/admin/topics' },
    { label: 'Pages',     value: counts.pages,      to: '/admin/pages' },
    { label: 'Poem Lines', value: counts.poem_lines, to: '/admin/poemlines' },
    { label: 'Morphemes', value: counts.morphemes,  to: '/admin/morphemes' }
  ]

  return (
    <div>
      <h2 className="text-2xl font-bold text-primary mb-6">Dashboard</h2>

      <div className="grid grid-cols-2 md:grid-cols-3 gap-4 mb-8">
        {STATS.map((s) => (
          <button
            key={s.label}
            onClick={() => navigate(s.to)}
            className="card text-left hover:border-primary hover:shadow transition-all"
          >
            <p className="text-3xl font-bold text-primary">{s.value ?? '…'}</p>
            <p className="text-gray-500 text-sm mt-1">{s.label}</p>
          </button>
        ))}
      </div>

      <div className="card">
        <h3 className="font-bold text-primary mb-3">Quick Links</h3>
        <div className="space-y-2">
          <a href="/" target="_blank" className="text-primary underline text-sm block">
            → Student view (new tab)
          </a>
          <a href="https://supabase.com/dashboard" target="_blank" className="text-primary underline text-sm block">
            → Supabase Dashboard
          </a>
        </div>
      </div>
    </div>
  )
}
