import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Navbar from '../components/Navbar'
import useStore from '../store/useStore'

const SECTION_ICONS = { 'செய்யுள்': '📜', 'உரை நடை': '📖', 'துணைப்பாடம்': '🎵' }

export default function TOCPage() {
  const navigate = useNavigate()
  const { sections, topics, fetchSections, fetchTopicsForSection } = useStore()
  const [open, setOpen] = useState({})   // sectionId → boolean
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchSections().then(() => setLoading(false))
  }, [])

  const toggleSection = async (sec) => {
    const isOpen = !!open[sec.id]
    if (!isOpen && !topics[sec.id]) {
      await fetchTopicsForSection(sec.id)
    }
    setOpen((prev) => ({ ...prev, [sec.id]: !isOpen }))
  }

  if (loading) return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack />
      <div className="flex-1 flex items-center justify-center">
        <p className="text-primary text-xl animate-pulse">ஏற்றுகிறது…</p>
      </div>
    </div>
  )

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack />

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6 space-y-4">
        <h2 className="section-heading text-center">பாட அட்டவணை</h2>

        {sections.map((sec) => (
          <div key={sec.id} className="card overflow-hidden">
            {/* Section header — clickable accordion */}
            <button
              onClick={() => toggleSection(sec)}
              className="w-full flex items-center gap-3 text-left min-h-[56px] px-1"
            >
              <span className="text-3xl">{SECTION_ICONS[sec.name] || '📚'}</span>
              <span className="flex-1 text-xl font-bold text-primary">{sec.name}</span>
              <span className={`text-primary text-xl transition-transform duration-200 ${open[sec.id] ? 'rotate-180' : ''}`}>
                ▼
              </span>
            </button>

            {/* Topics list */}
            {open[sec.id] && (
              <div className="border-t border-cream-dark mt-2 pt-2 space-y-1 animate-slide-down">
                {(topics[sec.id] || []).length === 0 ? (
                  <p className="text-gray-400 px-2 py-3 text-center">
                    உள்ளடக்கம் விரைவில் சேர்க்கப்படும்
                  </p>
                ) : (
                  (topics[sec.id] || []).map((topic, i) => (
                    <button
                      key={topic.id}
                      onClick={() => navigate(`/topic/${topic.id}`)}
                      className="w-full text-left px-4 py-3 rounded-lg hover:bg-primary/5
                                 active:bg-primary/10 flex items-center gap-3 min-h-[52px]
                                 transition-colors"
                    >
                      <span className="text-gold font-bold">{i + 1}.</span>
                      <span className="text-lg text-gray-800 flex-1">{topic.title}</span>
                      <span className="text-gray-400">›</span>
                    </button>
                  ))
                )}
              </div>
            )}
          </div>
        ))}
      </main>
    </div>
  )
}
