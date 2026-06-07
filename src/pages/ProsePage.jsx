import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import Navbar from '../components/Navbar'
import useStore from '../store/useStore'
import { supabase } from '../supabase'

const FONT_SIZES = { small: 'font-sm', medium: 'font-md', large: 'font-lg' }
const FONT_LABELS = { small: 'அ', medium: 'அ', large: 'அ' }

export default function ProsePage() {
  const { topicId, pageType } = useParams()
  const decodedType = decodeURIComponent(pageType)

  const { fontSize, setFontSize } = useStore()
  const [content, setContent] = useState([])
  const [topic, setTopic]     = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function load() {
      // 1. Get topic name
      const { data: topicData } = await supabase
        .from('topics').select('title').eq('id', topicId).single()
      setTopic(topicData)

      // 2. Get the page for this topic + type
      const { data: pageData } = await supabase
        .from('pages')
        .select('id')
        .eq('topic_id', topicId)
        .eq('page_type', decodedType)
        .single()

      if (pageData) {
        const { data: prose } = await supabase
          .from('prose_content')
          .select('content_text, order_index')
          .eq('page_id', pageData.id)
          .order('order_index')
        setContent(prose || [])
      }
      setLoading(false)
    }
    load()
  }, [topicId, pageType])

  if (loading) return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title={decodedType} />
      <div className="flex-1 flex items-center justify-center">
        <p className="text-primary text-xl animate-pulse">ஏற்றுகிறது…</p>
      </div>
    </div>
  )

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title={decodedType} />

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        {/* Topic title + page type */}
        <p className="text-sm text-gold font-semibold mb-1">{topic?.title}</p>
        <h2 className="section-heading">{decodedType}</h2>

        {/* Font size toggle */}
        <div className="flex gap-2 mb-6">
          {Object.entries(FONT_LABELS).map(([size, label], i) => (
            <button
              key={size}
              onClick={() => setFontSize(size)}
              className={`min-w-[44px] min-h-[44px] rounded-lg border font-bold transition-colors
                ${fontSize === size
                  ? 'bg-primary text-white border-primary'
                  : 'bg-white text-primary border-gray-200 hover:border-primary'
                }`}
              style={{ fontSize: i === 0 ? 14 : i === 1 ? 18 : 22 }}
            >
              {label}
            </button>
          ))}
        </div>

        {/* Content */}
        <div className={`space-y-5 ${FONT_SIZES[fontSize]} text-gray-800 leading-relaxed`}>
          {content.length === 0 ? (
            <div className="card text-center text-gray-400 py-12">
              <p className="text-4xl mb-3">📄</p>
              <p>உள்ளடக்கம் விரைவில் சேர்க்கப்படும்</p>
            </div>
          ) : (
            content.map((para, i) => (
              <p key={i} className="text-justify">{para.content_text}</p>
            ))
          )}
        </div>
      </main>
    </div>
  )
}
