import { useEffect, useState, useRef } from 'react'
import { useParams } from 'react-router-dom'
import Navbar from '../components/Navbar'
import { supabase } from '../supabase'
import { toEmbedUrl } from '../utils/embedUrl'

// ── Tab config ────────────────────────────────────────────────────────────────
const STUDY_TABS = [
  { id: 'audio', label: 'ஒலிப்பதிவு', icon: '🎙' },
  { id: 'video', label: 'காணொளி',     icon: '📹' },
]

// ── Audio Card ────────────────────────────────────────────────────────────────
function AudioCard({ card }) {
  const [playing, setPlaying] = useState(false)
  const audioRef = useRef(null)

  const handleToggle = () => {
    const el = audioRef.current
    if (!el) return
    if (playing) {
      el.pause()
      setPlaying(false)
    } else {
      el.play()
      setPlaying(true)
    }
  }

  return (
    <div className="card border border-gray-100 shadow-sm">
      {/* Text content */}
      <p className="text-gray-800 font-tamil leading-relaxed text-base mb-4 whitespace-pre-wrap">
        {card.text_content}
      </p>

      {/* Audio player */}
      {card.audio_url ? (
        <div className="flex items-center gap-3">
          <audio
            ref={audioRef}
            src={card.audio_url}
            onEnded={() => setPlaying(false)}
            onPause={() => setPlaying(false)}
            className="hidden"
          />
          <button
            onClick={handleToggle}
            className={`flex items-center gap-2 px-5 py-2 rounded-full border-2 font-tamil
                        text-sm font-bold transition-all min-h-[44px] active:scale-95
                        ${playing
                          ? 'bg-primary text-white border-primary shadow-md'
                          : 'bg-white text-primary border-primary hover:bg-primary/5'
                        }`}
          >
            <span className="text-lg">{playing ? '⏸' : '🔊'}</span>
            <span>{playing ? 'நிறுத்து' : 'ஒலிக்க'}</span>
          </button>
          {playing && (
            <span className="flex gap-0.5 items-end h-4">
              {[1, 2, 3, 4].map((i) => (
                <span
                  key={i}
                  className="w-1 bg-primary rounded-full animate-pulse"
                  style={{ height: `${[60, 100, 40, 80][i - 1]}%`, animationDelay: `${i * 0.1}s` }}
                />
              ))}
            </span>
          )}
        </div>
      ) : (
        <p className="text-xs text-gray-400 font-tamil italic">
          🎙 ஒலிப்பதிவு விரைவில் சேர்க்கப்படும்
        </p>
      )}
    </div>
  )
}

// ── Video Card ────────────────────────────────────────────────────────────────
function VideoCard({ card }) {
  const embedUrl = toEmbedUrl(card.video_url)

  return (
    <div className="card border border-gray-100 shadow-sm p-0 overflow-hidden">
      {/* Text content */}
      <p className="px-4 py-4 text-gray-800 font-tamil leading-relaxed text-base whitespace-pre-wrap">
        {card.text_content}
      </p>

      {/* Video embed or placeholder */}
      {embedUrl ? (
        <>
          <div className="border-t border-gray-100 mx-4 mb-3" />
          <div className="relative w-full mb-0" style={{ paddingBottom: '56.25%' }}>
            <iframe
              src={embedUrl}
              title="காணொளி"
              className="absolute inset-0 w-full h-full"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowFullScreen
            />
          </div>
        </>
      ) : (
        <div className="px-4 pb-4">
          <p className="text-xs text-gray-400 font-tamil italic">
            📹 காணொளி விரைவில் சேர்க்கப்படும்
          </p>
        </div>
      )}
    </div>
  )
}

// ── Placeholder when no cards added yet ──────────────────────────────────────
function EmptyPlaceholder({ tab }) {
  return (
    <div className="card text-center py-16 text-gray-400 space-y-4">
      <div className="text-6xl">{tab === 'audio' ? '🎙' : '📹'}</div>
      <p className="text-lg font-tamil font-semibold text-gray-500">
        {tab === 'audio' ? 'ஒலிப்பதிவு' : 'காணொளி'} விரைவில் சேர்க்கப்படும்
      </p>
      <p className="text-sm text-gray-400 font-tamil max-w-xs mx-auto">
        {tab === 'audio'
          ? 'ஒவ்வொரு பகுதியின் ஒலிப்பதிவு இங்கு சேர்க்கப்படும். பொறுத்திருக்கவும்.'
          : 'ஒவ்வொரு பகுதியின் காணொளி விளக்கம் இங்கு சேர்க்கப்படும். பொறுத்திருக்கவும்.'}
      </p>
    </div>
  )
}

// ══════════════════════════════════════════════════════════════════════════════
export default function StudyPage() {
  const { topicId } = useParams()
  const [topic,     setTopic]     = useState(null)
  const [cards,     setCards]     = useState([])
  const [activeTab, setActiveTab] = useState('audio')
  const [loading,   setLoading]   = useState(true)

  useEffect(() => {
    async function load() {
      const [{ data: topicData }, { data: pageData }] = await Promise.all([
        supabase.from('topics').select('title').eq('id', topicId).single(),
        supabase
          .from('pages')
          .select('id')
          .eq('topic_id', topicId)
          .eq('page_type', 'தேர்வுக்குப் படித்தல்')
          .single(),
      ])
      setTopic(topicData)

      if (pageData?.id) {
        const { data: cardsData } = await supabase
          .from('study_cards')
          .select('*')
          .eq('page_id', pageData.id)
          .order('order_index')
        setCards(cardsData || [])
      }
      setLoading(false)
    }
    load()
  }, [topicId])

  if (loading) return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title="தேர்வுக்குப் படித்தல்" />
      <div className="flex-1 flex items-center justify-center">
        <p className="text-primary text-xl animate-pulse font-tamil">ஏற்றுகிறது…</p>
      </div>
    </div>
  )

  // Audio tab: only cards that have audio_url
  // Video tab: only cards that have video_url
  // Completely separate content sets
  const tabCards = cards.filter((c) =>
    activeTab === 'audio' ? !!c.audio_url : !!c.video_url
  )

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title="தேர்வுக்குப் படித்தல்" />

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        {/* Breadcrumb */}
        <p className="text-sm text-gold font-semibold mb-1 font-tamil">{topic?.title}</p>
        <h2 className="section-heading font-tamil mb-4">தேர்வுக்குப் படித்தல்</h2>

        {/* ── Tab strip ─────────────────────────────────────────────────────── */}
        <div className="flex gap-2 mb-6">
          {STUDY_TABS.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex items-center gap-2 px-5 py-2 rounded-xl border text-sm
                          font-semibold transition-colors min-h-[44px] font-tamil
                          ${activeTab === tab.id
                            ? 'bg-primary text-white border-primary shadow-sm'
                            : 'bg-white text-primary border-gray-200 hover:border-primary'
                          }`}
            >
              <span className="text-base">{tab.icon}</span>
              <span>{tab.label}</span>
            </button>
          ))}
        </div>

        {/* ── Tab content ───────────────────────────────────────────────────── */}
        {tabCards.length === 0 ? (
          <EmptyPlaceholder tab={activeTab} />
        ) : (
          <div className="space-y-4">
            {tabCards.map((card) =>
              activeTab === 'audio'
                ? <AudioCard key={card.id} card={card} />
                : <VideoCard key={card.id} card={card} />
            )}
          </div>
        )}
      </main>
    </div>
  )
}
