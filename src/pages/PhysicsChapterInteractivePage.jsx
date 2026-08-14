import { useEffect, useState } from 'react'
import { useNavigate, useOutletContext } from 'react-router-dom'
import { supabase } from '../supabase'
import { isLessonComplete } from '../utils/lessonProgress'
import { groupByMainSubTopic, groupLabel } from '../utils/physicsGroups'

// Order here is the render order -- Extra One Mark Questions goes last,
// per the "these are supplementary, not the real book-back ones" framing.
const EXTRA_SECTIONS = [
  { key: 'book_back_mcq', label: 'Book Back One Mark Questions', icon: '⚡' },
  { key: 'book_back',     label: 'Book Back Problems',           icon: '📖' },
  { key: 'extra_one_mark', label: 'Extra One Mark Questions',    icon: '➕' },
]

function LessonRow({ lesson, chapterId, navigate, i }) {
  const done = isLessonComplete(lesson.id)
  return (
    <button
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
        {lesson.hook_summary && <p className="text-sm text-gray-500 mt-0.5">{lesson.hook_summary}</p>}
      </div>
      {done ? (
        <span className="text-green-600 text-xs font-bold bg-green-50 border border-green-200
                         rounded-full px-2.5 py-1 shrink-0">✓ Done</span>
      ) : (
        <span className="text-gray-300 text-xl shrink-0">›</span>
      )}
    </button>
  )
}

export default function PhysicsChapterInteractivePage() {
  const { chapterId } = useOutletContext()
  const navigate = useNavigate()
  const [lessons, setLessons] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function load() {
      const { data } = await supabase
        .from('physics_ip_lessons')
        .select('*')
        .eq('chapter_id', chapterId)
        .order('order_index')
      setLessons(data || [])
      setLoading(false)
    }
    load()
  }, [chapterId])

  if (loading) return <p className="text-gray-400 text-center py-10">Loading…</p>

  if (lessons.length === 0) {
    return (
      <div className="card text-center py-16 text-gray-400 space-y-3">
        <div className="text-5xl">🧪</div>
        <p className="text-lg font-semibold text-gray-500">Interactive Physics — Coming soon</p>
        <p className="text-sm text-gray-400 max-w-xs mx-auto">This section will be added in a future update.</p>
      </div>
    )
  }

  const mainGroups = groupByMainSubTopic(lessons)
  const extraGroups = EXTRA_SECTIONS
    .map((s) => ({ ...s, items: lessons.filter((l) => l.group_key === s.key) }))
    .filter((s) => s.items.length > 0)
  const ungrouped = lessons.filter((l) => !l.group_key)

  let runningIndex = 0

  return (
    <div className="space-y-8">
      <p className="text-xs text-gray-400 -mt-1">
        Short, story-driven lessons — a hook, a clear explanation, a worked example, then practice questions.
      </p>

      {mainGroups.map((g) => (
        <section key={g.key}>
          <h3 className="text-sm font-bold text-[#8E44AD] uppercase tracking-wide mb-3">{g.label}</h3>
          <div className="space-y-3">
            {g.items.map((lesson) => {
              const i = runningIndex++
              return <LessonRow key={lesson.id} lesson={lesson} chapterId={chapterId} navigate={navigate} i={i} />
            })}
          </div>
        </section>
      ))}

      {ungrouped.length > 0 && (
        <section>
          <h3 className="text-sm font-bold text-[#8E44AD] uppercase tracking-wide mb-3">More</h3>
          <div className="space-y-3">
            {ungrouped.map((lesson) => {
              const i = runningIndex++
              return <LessonRow key={lesson.id} lesson={lesson} chapterId={chapterId} navigate={navigate} i={i} />
            })}
          </div>
        </section>
      )}

      {extraGroups.map((g) => (
        <section key={g.key} className="pt-2 border-t border-cream-dark">
          <h3 className="text-sm font-bold text-gray-700 uppercase tracking-wide mb-3 flex items-center gap-2">
            <span>{g.icon}</span> {g.label}
          </h3>
          <div className="space-y-3">
            {g.items.map((lesson) => {
              const i = runningIndex++
              return <LessonRow key={lesson.id} lesson={lesson} chapterId={chapterId} navigate={navigate} i={i} />
            })}
          </div>
        </section>
      ))}
    </div>
  )
}
