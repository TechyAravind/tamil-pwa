import { useEffect, useState, useRef } from 'react'
import { useParams } from 'react-router-dom'
import Navbar from '../components/Navbar'
import { supabase } from '../supabase'

// ── Tab config ────────────────────────────────────────────────────────────────
const PROSE_TABS = [
  { id: 'words',   label: 'அருஞ்சொற்பொருள்', icon: '📖' },
  { id: 'meaning', label: 'பத்தியின் பொருள்',  icon: '💡' },
  { id: 'summary', label: 'சுருக்க உரை',       icon: '📝' },
]

// ── Parse raw_text: split on /word/ markers ───────────────────────────────────
// Returns array of { type: 'text' | 'hardword', content: string }
function parseText(rawText) {
  const parts = rawText.split(/\/([^/]+)\//)
  return parts
    .map((seg, i) => ({ type: i % 2 === 0 ? 'text' : 'hardword', content: seg }))
    .filter((s) => s.content.length > 0)
}

// Strip /markers/ from raw_text → plain paragraph
function stripMarkers(rawText) {
  return rawText.replace(/\/([^/]+)\//g, '$1')
}

// ── Hard Word Chip (inline popup dictionary) ──────────────────────────────────
function HardWordChip({ word, definition }) {
  const [open, setOpen] = useState(false)
  const ref = useRef(null)

  useEffect(() => {
    if (!open) return
    const handleClick = (e) => {
      if (ref.current && !ref.current.contains(e.target)) setOpen(false)
    }
    document.addEventListener('mousedown', handleClick)
    return () => document.removeEventListener('mousedown', handleClick)
  }, [open])

  return (
    <span className="relative inline" ref={ref}>
      <button
        onClick={() => setOpen(!open)}
        className="relative bg-amber-50 text-amber-900 border-b-2 border-amber-400
                   font-semibold font-tamil px-0.5 mx-0.5 rounded-sm
                   hover:bg-amber-100 active:scale-95 transition-colors cursor-pointer"
      >
        {word}
      </button>
      {open && (
        <span
          className="absolute z-50 bottom-full left-0 mb-2 w-72
                     bg-white rounded-xl shadow-2xl border border-amber-200 p-4
                     text-left block"
          onClick={(e) => e.stopPropagation()}
        >
          {/* Word heading */}
          <span className="block font-bold text-amber-800 font-tamil text-base mb-1">
            {word}
          </span>
          {/* Definition */}
          <span className="block text-gray-700 font-tamil text-sm leading-relaxed">
            {definition || 'பொருள் விரைவில் சேர்க்கப்படும்'}
          </span>
          {/* Close */}
          <button
            onClick={() => setOpen(false)}
            className="absolute top-2 right-2 text-gray-400 hover:text-gray-600
                       text-xs w-5 h-5 flex items-center justify-center rounded-full
                       hover:bg-gray-100 transition-colors"
          >
            ✕
          </button>
        </span>
      )}
    </span>
  )
}

// ── Paragraph rendered with hard word chips ───────────────────────────────────
function ParagraphWithChips({ paragraph, wordMap }) {
  const segments = parseText(paragraph.raw_text)
  return (
    <div className="card border border-gray-100 shadow-sm">
      <p className="font-tamil text-gray-800 leading-loose text-base text-justify">
        {segments.map((seg, i) =>
          seg.type === 'text' ? (
            <span key={i}>{seg.content}</span>
          ) : (
            <HardWordChip
              key={i}
              word={seg.content}
              definition={wordMap[seg.content]}
            />
          )
        )}
      </p>
    </div>
  )
}

// ══════════════════════════════════════════════════════════════════════════════
export default function ProseContentPage() {
  const { topicId } = useParams()
  const [topic,      setTopic]      = useState(null)
  const [paragraphs, setParagraphs] = useState([])
  const [wordMap,    setWordMap]    = useState({}) // word → definition
  const [summary,    setSummary]    = useState([])
  const [activeTab,  setActiveTab]  = useState('words')
  const [loading,    setLoading]    = useState(true)

  useEffect(() => {
    async function load() {
      // 1. Topic name + the page record for 'உரைநடைப் பகுதி'
      const [{ data: topicData }, { data: pageData }] = await Promise.all([
        supabase.from('topics').select('title').eq('id', topicId).single(),
        supabase
          .from('pages')
          .select('id')
          .eq('topic_id', topicId)
          .eq('page_type', 'உரைநடைப் பகுதி')
          .single(),
      ])
      setTopic(topicData)

      if (pageData?.id) {
        const [{ data: parasData }, { data: wordsData }, { data: sumData }] =
          await Promise.all([
            supabase
              .from('prose_paragraphs')
              .select('id, raw_text, paragraph_number, paragraph_meaning')
              .eq('page_id', pageData.id)
              .order('paragraph_number'),
            supabase
              .from('prose_hard_words')
              .select('word, definition')
              .eq('page_id', pageData.id),
            supabase
              .from('prose_summary')
              .select('summary_text, order_index')
              .eq('page_id', pageData.id)
              .order('order_index'),
          ])
        setParagraphs(parasData || [])
        const map = {}
        ;(wordsData || []).forEach((w) => { map[w.word] = w.definition })
        setWordMap(map)
        setSummary(sumData || [])
      }
      setLoading(false)
    }
    load()
  }, [topicId])

  if (loading) {
    return (
      <div className="min-h-screen bg-cream flex flex-col">
        <Navbar showBack title="உரைநடைப் பகுதி" />
        <div className="flex-1 flex items-center justify-center">
          <p className="text-primary text-xl animate-pulse font-tamil">ஏற்றுகிறது…</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title="உரைநடைப் பகுதி" />

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        {/* Breadcrumb */}
        <p className="text-sm text-gold font-semibold mb-1 font-tamil">{topic?.title}</p>
        <h2 className="section-heading font-tamil mb-5">உரைநடைப் பகுதி</h2>

        {/* ── Tab strip ─────────────────────────────────────────────────────── */}
        <div className="flex gap-2 mb-6 flex-wrap">
          {PROSE_TABS.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex items-center gap-2 px-4 py-2 rounded-xl border text-sm
                          font-semibold transition-colors min-h-[44px] font-tamil
                          ${activeTab === tab.id
                            ? 'bg-primary text-white border-primary shadow-sm'
                            : 'bg-white text-primary border-gray-200 hover:border-primary'
                          }`}
            >
              <span>{tab.icon}</span>
              <span>{tab.label}</span>
            </button>
          ))}
        </div>

        {/* ══ TAB 1 — அருஞ்சொற்பொருள் ════════════════════════════════════════ */}
        {activeTab === 'words' && (
          <div>
            {paragraphs.length === 0 ? (
              <div className="card text-center py-14 text-gray-400">
                <p className="text-5xl mb-3">📖</p>
                <p className="font-tamil text-base">உரை விரைவில் சேர்க்கப்படும்</p>
              </div>
            ) : (
              <>
                {/* Hint */}
                <div className="flex items-center gap-2 text-xs text-amber-700 bg-amber-50
                                border border-amber-200 rounded-lg px-3 py-2 mb-4 font-tamil">
                  <span>💡</span>
                  <span>அடிக்கோடிட்ட சொல்லைத் தொட்டால் பொருள் காண்பீர்கள்</span>
                </div>
                <div className="space-y-4">
                  {paragraphs.map((para) => (
                    <ParagraphWithChips
                      key={para.id}
                      paragraph={para}
                      wordMap={wordMap}
                    />
                  ))}
                </div>
              </>
            )}
          </div>
        )}

        {/* ══ TAB 2 — பத்தியின் பொருள் ════════════════════════════════════════ */}
        {activeTab === 'meaning' && (
          <div className="space-y-5">
            {paragraphs.length === 0 ? (
              <div className="card text-center py-14 text-gray-400">
                <p className="text-5xl mb-3">💡</p>
                <p className="font-tamil text-base">பொருள் விளக்கம் விரைவில் சேர்க்கப்படும்</p>
              </div>
            ) : (
              paragraphs.map((para) => (
                <div key={para.id} className="card space-y-3">
                  {/* Original paragraph — stripped of markers, highlighted */}
                  <p className="font-tamil text-gray-700 text-base leading-loose text-justify
                                 border-l-4 border-gold bg-amber-50/60 pl-4 py-2 pr-2 rounded-r-lg">
                    {stripMarkers(para.raw_text)}
                  </p>
                  {/* Explanation below */}
                  {para.paragraph_meaning ? (
                    <p className="font-tamil text-gray-800 text-base leading-relaxed">
                      {para.paragraph_meaning}
                    </p>
                  ) : (
                    <p className="font-tamil text-gray-400 text-sm italic">
                      — பத்தியின் பொருள் விரைவில் சேர்க்கப்படும்…
                    </p>
                  )}
                </div>
              ))
            )}
          </div>
        )}

        {/* ══ TAB 3 — சுருக்க உரை ════════════════════════════════════════════ */}
        {activeTab === 'summary' && (
          <div className="space-y-4">
            {summary.length === 0 ? (
              <div className="card text-center py-14 text-gray-400">
                <p className="text-5xl mb-3">📝</p>
                <p className="font-tamil text-base">சுருக்க உரை விரைவில் சேர்க்கப்படும்</p>
              </div>
            ) : (
              summary.map((s, i) => (
                <div
                  key={i}
                  className="card border-l-4 border-primary bg-white"
                >
                  <p className="font-tamil text-gray-800 text-base leading-relaxed text-justify">
                    {s.summary_text}
                  </p>
                </div>
              ))
            )}
          </div>
        )}
      </main>
    </div>
  )
}
