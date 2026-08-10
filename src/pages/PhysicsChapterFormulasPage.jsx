import { useEffect, useState } from 'react'
import { useOutletContext } from 'react-router-dom'
import { supabase } from '../supabase'
import RichText from '../components/interactive/RichText'
import { groupByMainSubTopic } from '../utils/physicsGroups'
import { ui } from '../utils/ipLang'

// A read-only, scannable reference page: every formula introduced in
// the chapter, grouped by Main Sub Topic, sourced from the curated
// physics_formulas table (not auto-derived from question content, so
// it stays clean and exam-ready rather than reflecting question-by-
// question phrasing).
export default function PhysicsChapterFormulasPage() {
  const { chapterId } = useOutletContext()
  const [formulas, setFormulas] = useState([])
  const [loading, setLoading]   = useState(true)
  const [lang, setLang]         = useState('en')

  useEffect(() => {
    async function load() {
      const { data } = await supabase
        .from('physics_formulas')
        .select('*')
        .eq('chapter_id', chapterId)
        .order('order_index')
      setFormulas(data || [])
      setLoading(false)
    }
    load()
  }, [chapterId])

  if (loading) return <p className="text-gray-400 text-center py-10">Loading…</p>

  if (formulas.length === 0) {
    return (
      <div className="card text-center py-16 text-gray-400 space-y-3">
        <div className="text-5xl">∑</div>
        <p className="text-lg font-semibold text-gray-500">Formulas — Coming soon</p>
        <p className="text-sm text-gray-400 max-w-xs mx-auto">This section will be added in a future update.</p>
      </div>
    )
  }

  const groups = groupByMainSubTopic(formulas)

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <p className="text-xs text-gray-400">
          Every formula from this chapter, grouped by topic — a quick reference before an exam.
        </p>
        <button
          onClick={() => setLang((l) => (l === 'en' ? 'ta' : 'en'))}
          className="shrink-0 text-xs font-bold border border-[#8E44AD]/40 text-[#8E44AD] rounded-full px-3 py-1.5
                     hover:bg-[#8E44AD]/5 active:scale-95 transition-all min-h-[32px]"
        >
          {ui('langToggle', lang)}
        </button>
      </div>

      {groups.map((g) => (
        <section key={g.key}>
          <h3 className="text-sm font-bold text-[#8E44AD] uppercase tracking-wide mb-3">
            {lang === 'ta' ? g.label_ta : g.label}
          </h3>
          <div className="card divide-y divide-cream-dark p-0 overflow-hidden">
            {g.items.map((f) => (
              <div key={f.id} className="px-5 py-4">
                <p className="text-center text-lg text-gray-900 mb-1.5">
                  <RichText text={`$${f.formula_latex}$`} />
                </p>
                <p className="text-sm text-gray-600 text-center leading-snug">
                  <RichText text={(lang === 'ta' && f.description_ta) || f.description} />
                </p>
              </div>
            ))}
          </div>
        </section>
      ))}
    </div>
  )
}
