import { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { supabase } from '../supabase'
import { toEmbedUrl } from '../utils/embedUrl'
import SlideCarousel from '../components/SlideCarousel'

const SUBTOPIC_TABS = [
  { id: 'text',         label: 'Text',         icon: '📄' },
  { id: 'presentation', label: 'Presentation', icon: '🖼️' },
  { id: 'videos',        label: 'Videos',       icon: '📹' },
]

// Instagram-post-style video card
function VideoPost({ video }) {
  const embedUrl = toEmbedUrl(video.video_url)
  return (
    <div className="card border border-gray-100 shadow-sm p-0 overflow-hidden">
      {video.caption && (
        <p className="px-4 py-3 text-gray-800 leading-relaxed text-sm whitespace-pre-wrap">
          {video.caption}
        </p>
      )}
      {embedUrl && (
        <div className="relative w-full" style={{ paddingBottom: '56.25%' }}>
          <iframe
            src={embedUrl}
            title={video.caption || 'Video'}
            className="absolute inset-0 w-full h-full"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowFullScreen
          />
        </div>
      )}
    </div>
  )
}

function EmptyTab({ label, icon }) {
  return (
    <div className="card text-center py-16 text-gray-400 space-y-3">
      <div className="text-5xl">{icon}</div>
      <p className="text-lg font-semibold text-gray-500">{label} — not added yet</p>
    </div>
  )
}

export default function PhysicsSubtopicPage() {
  const { chapterId, subtopicId } = useParams()
  const navigate = useNavigate()

  const [subtopic, setSubtopic]     = useState(null)
  const [chapterTitle, setChapterTitle] = useState('')
  const [paragraphs, setParagraphs] = useState([])
  const [slides, setSlides]         = useState([])
  const [videos, setVideos]         = useState([])
  const [activeTab, setActiveTab]   = useState('text')
  const [loading, setLoading]       = useState(true)

  useEffect(() => {
    async function load() {
      const [{ data: subtopicData }, { data: chapterData }, { data: textData }, { data: slideData }, { data: videoData }] =
        await Promise.all([
          supabase.from('physics_subtopics').select('*').eq('id', subtopicId).single(),
          supabase.from('physics_chapters').select('title').eq('id', chapterId).single(),
          supabase.from('physics_subtopic_text').select('*').eq('subtopic_id', subtopicId).order('order_index'),
          supabase.from('physics_slides').select('*').eq('subtopic_id', subtopicId).order('order_index'),
          supabase.from('physics_videos').select('*').eq('subtopic_id', subtopicId).order('order_index'),
        ])
      setSubtopic(subtopicData)
      setChapterTitle(chapterData?.title || '')
      setParagraphs(textData || [])
      setSlides(slideData || [])
      setVideos(videoData || [])
      setLoading(false)
    }
    load()
  }, [subtopicId, chapterId])

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <header className="sticky top-0 z-30 bg-gradient-to-r from-[#4A235A] to-[#8E44AD] text-white shadow-md">
        <div className="flex items-center h-14 px-4 gap-3 max-w-2xl mx-auto">
          <button
            onClick={() => navigate(`/physics/chapter/${chapterId}`)}
            aria-label="Back"
            className="min-w-[44px] min-h-[44px] flex items-center justify-center
                       rounded-lg hover:bg-white/10 active:bg-white/20 transition-colors text-xl"
          >
            ←
          </button>
          <h1 className="flex-1 font-bold text-lg truncate">{subtopic?.title || 'Subtopic'}</h1>
        </div>
      </header>

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        <p className="text-sm text-[#8E44AD] font-semibold mb-1 uppercase tracking-wide">
          {chapterTitle}
        </p>
        <h2 className="text-2xl font-bold text-gray-900 mb-6">{subtopic?.title}</h2>

        {/* Tab strip */}
        <div className="flex gap-2 mb-6 flex-wrap">
          {SUBTOPIC_TABS.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex items-center gap-2 px-4 py-2 rounded-xl border text-sm
                          font-semibold transition-colors min-h-[44px]
                          ${activeTab === tab.id
                            ? 'bg-[#8E44AD] text-white border-[#8E44AD] shadow-sm'
                            : 'bg-white text-[#8E44AD] border-gray-200 hover:border-[#8E44AD]'
                          }`}
            >
              <span>{tab.icon}</span>
              <span>{tab.label}</span>
            </button>
          ))}
        </div>

        {loading && <p className="text-gray-400 text-center py-10">Loading…</p>}

        {!loading && activeTab === 'text' && (
          paragraphs.length === 0 ? (
            <EmptyTab label="Text" icon="📄" />
          ) : (
            <div className="space-y-4">
              {paragraphs.map((p) => (
                <div key={p.id} className="card border border-gray-100 shadow-sm">
                  <p className="text-gray-800 leading-loose text-base text-justify whitespace-pre-wrap">
                    {p.content_text}
                  </p>
                </div>
              ))}
            </div>
          )
        )}

        {!loading && activeTab === 'presentation' && (
          slides.length === 0 ? <EmptyTab label="Presentation" icon="🖼️" /> : <SlideCarousel slides={slides} />
        )}

        {!loading && activeTab === 'videos' && (
          videos.length === 0 ? (
            <EmptyTab label="Videos" icon="📹" />
          ) : (
            <div className="space-y-4">
              {videos.map((v) => <VideoPost key={v.id} video={v} />)}
            </div>
          )
        )}
      </main>
    </div>
  )
}
