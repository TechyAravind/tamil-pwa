import { useParams } from 'react-router-dom'
import Navbar from '../components/Navbar'
import useStore from '../store/useStore'
import { useEffect, useState } from 'react'
import { supabase } from '../supabase'

export default function QuizPage() {
  const { topicId } = useParams()
  const [topic, setTopic] = useState(null)

  useEffect(() => {
    supabase.from('topics').select('title').eq('id', topicId).single()
      .then(({ data }) => setTopic(data))
  }, [topicId])

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title="வினாடிவினா" />

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        <p className="text-sm text-gold font-semibold mb-1 font-tamil">{topic?.title}</p>
        <h2 className="section-heading font-tamil mb-6">வினாடிவினா</h2>

        <div className="card text-center py-20 space-y-5">
          <div className="text-7xl">❓</div>
          <p className="text-2xl font-bold text-primary font-tamil">சுய மதிப்பீட்டு வினாக்கள்</p>
          <p className="text-gray-500 font-tamil max-w-xs mx-auto leading-relaxed">
            இந்தப் பாடத்திற்கான வினாடிவினா விரைவில் தயாராகும்.
            அதுவரை மற்ற பகுதிகளில் படிக்கலாம்!
          </p>
          <div className="flex justify-center gap-3 pt-2">
            <span className="px-3 py-1 bg-primary/10 text-primary rounded-full text-sm font-tamil">
              📖 பல்தேர்வு வினாக்கள்
            </span>
            <span className="px-3 py-1 bg-primary/10 text-primary rounded-full text-sm font-tamil">
              ✍️ குறுவினாக்கள்
            </span>
          </div>
        </div>
      </main>
    </div>
  )
}
