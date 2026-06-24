import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import Navbar from '../components/Navbar'
import { supabase } from '../supabase'

// All possible sub-page types in display order
const SUB_PAGES = [
  { type: 'நுழையும் முன்',           icon: '🌅', desc: 'பாடத்தை அறியும் முன் தெரிந்துகொள்ள வேண்டியவை' },
  { type: 'செய்யுள் பகுதி',         icon: '📜', desc: 'கவிதையின் வரிகள் மற்றும் பொருள்விளக்கம்' },
  { type: 'உரைநடைப் பகுதி',        icon: '📄', desc: 'அருஞ்சொற்பொருள் · பத்தியின் பொருள் · சுருக்க உரை' },
  { type: 'இலக்கணப் பகுதி',        icon: '🔤', desc: 'இலக்கண விளக்கங்கள்' },
  { type: 'துணைக் குறிப்புகள்',     icon: '📌', desc: 'கூடுதல் குறிப்புகள் மற்றும் விளக்கங்கள்' },
  { type: 'நூல் வெளி',              icon: '📚', desc: 'நூல் மற்றும் ஆசிரியர் குறித்த தகவல்கள்' },
  { type: 'தேர்வுக்குப் படித்தல்',  icon: '🎧', desc: 'ஒலிப்பதிவு மற்றும் காணொளி மூலம் படிக்கலாம்' },
  { type: 'வினாடிவினா',             icon: '❓', desc: 'சுய மதிப்பீட்டு வினாக்கள்' },
]

export default function TopicPage() {
  const { topicId } = useParams()
  const navigate    = useNavigate()
  const [topic, setTopic]   = useState(null)
  const [pages, setPages]   = useState([])   // available page types in DB
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function load() {
      const [{ data: topicData }, { data: pagesData }] = await Promise.all([
        supabase.from('topics').select('*, sections(name)').eq('id', topicId).single(),
        supabase.from('pages').select('page_type').eq('topic_id', topicId)
      ])
      setTopic(topicData)
      setPages((pagesData || []).map((p) => p.page_type))
      setLoading(false)
    }
    load()
  }, [topicId])

  const navigate_to = (pageType) => {
    if (pageType === 'செய்யுள் பகுதி') {
      navigate(`/topic/${topicId}/poem`)
    } else if (pageType === 'உரைநடைப் பகுதி') {
      navigate(`/topic/${topicId}/prose-content`)
    } else if (pageType === 'தேர்வுக்குப் படித்தல்') {
      navigate(`/topic/${topicId}/study`)
    } else if (pageType === 'வினாடிவினா') {
      navigate(`/topic/${topicId}/quiz`)
    } else {
      // Encode Tamil page type for URL
      navigate(`/topic/${topicId}/${encodeURIComponent(pageType)}`)
    }
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
      <Navbar showBack title={topic?.title || 'பாடம்'} />

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        {/* Section breadcrumb */}
        <p className="text-sm text-gold font-semibold mb-2 uppercase tracking-wide">
          {topic?.sections?.name}
        </p>
        <h2 className="text-3xl font-bold text-primary mb-8">{topic?.title}</h2>

        <div className="space-y-3">
          {SUB_PAGES
            .filter((sp) => pages.includes(sp.type))
            .map((sp) => (
              <button
                key={sp.type}
                onClick={() => navigate_to(sp.type)}
                className="w-full card flex items-center gap-4 text-left
                           hover:border-primary hover:shadow-md active:scale-[0.99]
                           transition-all min-h-[72px]"
              >
                <span className="text-3xl">{sp.icon}</span>
                <div className="flex-1">
                  <p className="font-bold text-lg text-primary">{sp.type}</p>
                  <p className="text-sm text-gray-500 mt-0.5">{sp.desc}</p>
                </div>
                <span className="text-gray-300 text-xl">›</span>
              </button>
            ))
          }
        </div>
      </main>
    </div>
  )
}
