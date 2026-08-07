import { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { supabase } from '../supabase'
import QuestionRenderer from '../components/interactive/QuestionRenderer'
import RichText from '../components/interactive/RichText'
import DiagramSlot from '../components/interactive/diagrams/DiagramSlot'
import VideoEmbed from '../components/interactive/VideoEmbed'
import { markLessonComplete } from '../utils/lessonProgress'
import { ui, UI_STRINGS } from '../utils/ipLang'

const STEP_ICON = { motivation: '💡', explanation: '📘', example: '📝', question: '❓' }
const STEP_COLOR = { motivation: 'text-amber-600', explanation: 'text-blue-600', example: 'text-purple-600', question: 'text-gray-500' }

export default function PhysicsInteractiveLessonPage() {
  const { chapterId, lessonId } = useParams()
  const navigate = useNavigate()

  const [lesson, setLesson] = useState(null)
  const [steps, setSteps] = useState([])
  const [current, setCurrent] = useState(0)
  const [loading, setLoading] = useState(true)
  const [lang, setLang] = useState('en')

  useEffect(() => {
    async function load() {
      const [{ data: lessonData }, { data: stepData }] = await Promise.all([
        supabase.from('physics_ip_lessons').select('*').eq('id', lessonId).single(),
        supabase.from('physics_ip_steps').select('*, physics_ip_questions(*)').eq('lesson_id', lessonId).order('order_index'),
      ])
      setLesson(lessonData)
      setSteps(stepData || [])
      setLoading(false)
    }
    load()
    setCurrent(0)
  }, [lessonId])

  if (loading) {
    return (
      <div className="min-h-screen bg-cream flex items-center justify-center">
        <p className="text-gray-400 animate-pulse">Loading…</p>
      </div>
    )
  }

  if (steps.length === 0) {
    return (
      <div className="min-h-screen bg-cream flex flex-col items-center justify-center gap-4 px-6 text-center">
        <p className="text-gray-400">This lesson doesn't have any content yet.</p>
        <button onClick={() => navigate(`/physics/chapter/${chapterId}`)} className="text-[#8E44AD] font-semibold underline">
          ← Back to chapter
        </button>
      </div>
    )
  }

  const step = steps[current]
  const isLast = current === steps.length - 1
  const stepLabel = (type) => (UI_STRINGS.stepLabel[type] ? (lang === 'ta' ? UI_STRINGS.stepLabel[type].ta : UI_STRINGS.stepLabel[type].en) : type)

  const goToChapter = () => navigate(`/physics/chapter/${chapterId}`)

  const goNext = () => {
    if (isLast) {
      markLessonComplete(lessonId)
      goToChapter()
      return
    }
    setCurrent((c) => c + 1)
  }

  const jumpTo = (i) => { if (i <= current) setCurrent(i) }

  const title = (lang === 'ta' && lesson?.title_ta) || lesson?.title

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <header className="sticky top-0 z-30 bg-gradient-to-r from-[#4A235A] to-[#8E44AD] text-white shadow-md">
        <div className="flex items-center h-14 px-4 gap-3 max-w-2xl mx-auto">
          <button onClick={goToChapter} aria-label="Back to chapter"
            className="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-lg hover:bg-white/10 transition-colors text-xl">
            ←
          </button>
          <h1 className="flex-1 font-bold text-lg truncate">{title}</h1>
          <button
            onClick={() => setLang((l) => (l === 'en' ? 'ta' : 'en'))}
            className="shrink-0 text-xs font-bold border border-white/40 rounded-full px-3 py-1.5
                       hover:bg-white/10 active:scale-95 transition-all min-h-[32px]"
          >
            {ui('langToggle', lang)}
          </button>
        </div>
      </header>

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        {/* Icon stepper */}
        <div className="flex items-center gap-1.5 mb-6 flex-wrap">
          {steps.map((s, i) => (
            <button
              key={s.id}
              onClick={() => jumpTo(i)}
              disabled={i > current}
              title={stepLabel(s.step_type)}
              className={`w-8 h-8 rounded-full flex items-center justify-center text-sm border-2 transition-all shrink-0
                          ${i === current ? 'border-[#8E44AD] bg-[#8E44AD] scale-110' :
                            i < current ? 'border-[#8E44AD]/50 bg-white cursor-pointer' :
                            'border-gray-200 bg-gray-50 opacity-50 cursor-not-allowed'}`}
            >
              {STEP_ICON[s.step_type]}
            </button>
          ))}
          <span className="ml-2 text-xs text-gray-400">{current + 1} / {steps.length}</span>
        </div>

        {/* Content card */}
        {step.step_type === 'question' ? (
          <QuestionRenderer
            key={step.id}
            question={step.physics_ip_questions}
            onNext={goNext}
            nextLabel={isLast ? ui('finish', lang) : ui('next', lang)}
            lang={lang}
          />
        ) : (
          <div className="card">
            <p className={`text-xs font-bold uppercase tracking-widest mb-1 ${STEP_COLOR[step.step_type]}`}>
              {stepLabel(step.step_type)}
            </p>
            {step.title && (
              <h2 className="text-xl font-bold text-gray-900 mb-3">
                <RichText text={(lang === 'ta' && step.title_ta) || step.title} />
              </h2>
            )}
            <div className="text-gray-700 leading-relaxed text-base">
              <RichText text={(lang === 'ta' && step.body_text_ta) || step.body_text} />
            </div>

            <DiagramSlot diagramKey={step.diagram_key} />
            <VideoEmbed url={step.video_url} />

            {!step.diagram_key && !step.video_url && step.diagram_note && (
              <div className="mt-4 rounded-xl border border-dashed border-gray-300 bg-gray-50 p-6 text-center text-xs text-gray-400">
                🎬 {(lang === 'ta' && step.diagram_note_ta) || step.diagram_note}
              </div>
            )}

            <button
              onClick={goNext}
              className="mt-5 bg-[#8E44AD] text-white text-sm font-bold px-6 py-2.5 rounded-lg
                         hover:bg-[#9B59B6] active:scale-95 transition-all min-h-[44px]"
            >
              {isLast ? ui('finish', lang) : ui('next', lang)}
            </button>
          </div>
        )}
      </main>
    </div>
  )
}
