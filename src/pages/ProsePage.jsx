import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import Navbar from '../components/Navbar'
import useStore from '../store/useStore'
import { supabase } from '../supabase'

// ── Content-type tabs ─────────────────────────────────────────────────────────
const CONTENT_TABS = [
  { id: 'text',  label: 'எழுத்து விளக்கம்', icon: 'அ'  },
  { id: 'image', label: 'பட விளக்கம்',       icon: '🖼'  },
  { id: 'video', label: 'காட்சி விளக்கம்',   icon: '▶'  },
]

// ── Font-size options (used inside the text tab) ──────────────────────────────
const FONT_SIZES   = { small: 'text-sm', medium: 'text-base', large: 'text-xl' }
const FONT_LABELS  = [
  { key: 'small',  label: 'அ', sz: 14 },
  { key: 'medium', label: 'அ', sz: 18 },
  { key: 'large',  label: 'அ', sz: 24 },
]

// ── Helpers ───────────────────────────────────────────────────────────────────

/** Convert a YouTube watch URL → embed URL, or pass through embed/direct URLs */
function toEmbedUrl(url) {
  if (!url) return null
  // Already an embed URL
  if (url.includes('youtube.com/embed/')) return url
  // youtu.be/VIDEO_ID
  const short = url.match(/youtu\.be\/([^?&]+)/)
  if (short) return `https://www.youtube.com/embed/${short[1]}`
  // youtube.com/watch?v=VIDEO_ID
  const watch = url.match(/[?&]v=([^&]+)/)
  if (watch) return `https://www.youtube.com/embed/${watch[1]}`
  // Treat as a raw embed/direct URL
  return url
}

// ─────────────────────────────────────────────────────────────────────────────
export default function ProsePage() {
  const { topicId, pageType } = useParams()
  const decodedType = decodeURIComponent(pageType)

  const { fontSize, setFontSize } = useStore()
  const [activeTab, setActiveTab] = useState('text')
  const [content,   setContent]   = useState([])
  const [images,    setImages]     = useState([])
  const [videos,    setVideos]     = useState([])
  const [topic,     setTopic]      = useState(null)
  const [loading,   setLoading]    = useState(true)

  useEffect(() => {
    async function load() {
      // 1. Topic name
      const { data: topicData } = await supabase
        .from('topics').select('title').eq('id', topicId).single()
      setTopic(topicData)

      // 2. Page record
      const { data: pageData } = await supabase
        .from('pages')
        .select('id')
        .eq('topic_id', topicId)
        .eq('page_type', decodedType)
        .single()

      if (pageData) {
        // 3. Fetch all three content types in parallel
        const [proseRes, imgRes, vidRes] = await Promise.all([
          supabase
            .from('prose_content')
            .select('content_text, order_index')
            .eq('page_id', pageData.id)
            .order('order_index'),
          supabase
            .from('page_images')
            .select('image_url, caption, order_index')
            .eq('page_id', pageData.id)
            .order('order_index'),
          supabase
            .from('page_videos')
            .select('video_url, title')
            .eq('page_id', pageData.id)
            .limit(5),
        ])
        setContent(proseRes.data  || [])
        setImages(imgRes.data     || [])
        setVideos(vidRes.data     || [])
      }
      setLoading(false)
    }
    load()
  }, [topicId, pageType])

  // ── For grammar pages (விளக்கம்), topic title IS the heading ──────────────
  const isGrammar    = decodedType === 'விளக்கம்'
  const navbarTitle  = isGrammar ? (topic?.title || decodedType) : decodedType
  const pageHeading  = isGrammar ? (topic?.title || decodedType) : decodedType
  const pageSublabel = isGrammar ? 'இலக்கணம்' : topic?.title

  // ── Loading state ─────────────────────────────────────────────────────────
  if (loading) return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title={decodedType} />
      <div className="flex-1 flex items-center justify-center">
        <p className="text-primary text-xl animate-pulse font-tamil">ஏற்றுகிறது…</p>
      </div>
    </div>
  )

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title={navbarTitle} />

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        {/* Breadcrumb */}
        <p className="text-sm text-gold font-semibold mb-1 font-tamil">{pageSublabel}</p>
        <h2 className="section-heading font-tamil">{pageHeading}</h2>

        {/* ── Content-type tab strip ──────────────────────────────────────── */}
        <div className="flex gap-2 mb-6 mt-4">
          {CONTENT_TABS.map((tab) => (
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
              <span className={tab.id === 'text' ? 'font-bold text-base' : 'text-base'}>
                {tab.icon}
              </span>
              <span className="hidden sm:inline">{tab.label}</span>
            </button>
          ))}
        </div>

        {/* ══════════════════════════════════════════════════════════════════ */}
        {/* TAB 1 — எழுத்து விளக்கம் (Text)                                  */}
        {/* ══════════════════════════════════════════════════════════════════ */}
        {activeTab === 'text' && (
          <div>
            {/* Font-size control */}
            <div className="flex gap-2 mb-5">
              {FONT_LABELS.map(({ key, label, sz }) => (
                <button
                  key={key}
                  onClick={() => setFontSize(key)}
                  className={`min-w-[44px] min-h-[44px] rounded-lg border font-bold
                              transition-colors font-tamil
                              ${fontSize === key
                                ? 'bg-primary text-white border-primary'
                                : 'bg-white text-primary border-gray-200 hover:border-primary'
                              }`}
                  style={{ fontSize: sz }}
                >
                  {label}
                </button>
              ))}
            </div>

            {/* Prose paragraphs */}
            <div className={`space-y-5 text-gray-800 leading-relaxed font-tamil
                             ${FONT_SIZES[fontSize]}`}>
              {content.length === 0 ? (
                <div className="card text-center text-gray-400 py-12">
                  <p className="text-4xl mb-3">📄</p>
                  <p>உரை விளக்கம் விரைவில் சேர்க்கப்படும்</p>
                </div>
              ) : (
                content.map((para, i) => (
                  <p key={i} className="text-justify">{para.content_text}</p>
                ))
              )}
            </div>
          </div>
        )}

        {/* ══════════════════════════════════════════════════════════════════ */}
        {/* TAB 2 — பட விளக்கம் (Images)                                     */}
        {/* ══════════════════════════════════════════════════════════════════ */}
        {activeTab === 'image' && (
          <div>
            {images.length === 0 ? (
              /* Placeholder — shown until admin adds images */
              <div className="card text-center py-16 text-gray-400 space-y-4">
                <div className="text-6xl">🖼️</div>
                <p className="text-lg font-tamil font-semibold text-gray-500">
                  பட விளக்கம் விரைவில் சேர்க்கப்படும்
                </p>
                <p className="text-sm text-gray-400 font-tamil max-w-xs mx-auto">
                  இந்தப் பகுதியில் பாடத்தின் விரிவான பட விளக்கங்கள்
                  சேர்க்கப்படும். தயவுசெய்து பொறுத்திருக்கவும்.
                </p>
              </div>
            ) : (
              <div className="space-y-6">
                {images.map((img, i) => (
                  <figure key={i} className="card overflow-hidden p-0">
                    <img
                      src={img.image_url}
                      alt={img.caption || `படம் ${i + 1}`}
                      className="w-full object-contain max-h-[70vh]"
                      loading="lazy"
                    />
                    {img.caption && (
                      <figcaption className="px-4 py-3 text-sm text-gray-600
                                             font-tamil text-center bg-cream-dark">
                        {img.caption}
                      </figcaption>
                    )}
                  </figure>
                ))}
              </div>
            )}
          </div>
        )}

        {/* ══════════════════════════════════════════════════════════════════ */}
        {/* TAB 3 — காட்சி விளக்கம் (Video)                                  */}
        {/* ══════════════════════════════════════════════════════════════════ */}
        {activeTab === 'video' && (
          <div>
            {videos.length === 0 ? (
              /* Placeholder — shown until admin adds a video */
              <div className="card text-center py-16 text-gray-400 space-y-4">
                <div className="text-6xl">🎬</div>
                <p className="text-lg font-tamil font-semibold text-gray-500">
                  காட்சி விளக்கம் விரைவில் சேர்க்கப்படும்
                </p>
                <p className="text-sm text-gray-400 font-tamil max-w-xs mx-auto">
                  இந்தப் பகுதியில் பாடத்தின் ஒளிப்படக் காட்சி விளக்கம்
                  சேர்க்கப்படும். தயவுசெய்து பொறுத்திருக்கவும்.
                </p>
              </div>
            ) : (
              <div className="space-y-8">
                {videos.map((vid, i) => {
                  const embedUrl = toEmbedUrl(vid.video_url)
                  return (
                    <div key={i} className="card p-0 overflow-hidden">
                      {vid.title && (
                        <p className="px-4 pt-4 pb-2 font-tamil font-semibold
                                       text-gray-800">
                          {vid.title}
                        </p>
                      )}
                      {embedUrl ? (
                        <div className="relative w-full" style={{ paddingBottom: '56.25%' }}>
                          <iframe
                            src={embedUrl}
                            title={vid.title || `காட்சி ${i + 1}`}
                            className="absolute inset-0 w-full h-full"
                            allow="accelerometer; autoplay; clipboard-write;
                                   encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                          />
                        </div>
                      ) : (
                        <div className="p-6 text-center text-gray-400 font-tamil">
                          காட்சி இணைப்பு சரியாக இல்லை
                        </div>
                      )}
                    </div>
                  )
                })}
              </div>
            )}
          </div>
        )}
      </main>
    </div>
  )
}
