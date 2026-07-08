import { useParams } from 'react-router-dom'
import Navbar from '../components/Navbar'

// Placeholder explanation pages for the இலக்கணக்குறிப்பு tab's abbreviation
// legend (பெ/வி/இ/உ) and the பகுபத உறுப்பிலக்கணம் link. Real content +
// deep links to specific rule pages will be filled in later — this route
// just needs to exist now so the legend chips are clickable.
const NOTES = {
  peyarchol: { title: 'பெயர்ச்சொல்', short: 'பெ' },
  vinaichol:  { title: 'வினைச்சொல்', short: 'வி' },
  idaichol:   { title: 'இடைச்சொல்',  short: 'இ' },
  urichol:    { title: 'உரிச்சொல்',  short: 'உ' },
  pagupatham: { title: 'பகுபத உறுப்பிலக்கணம்', short: '🟢' }
}

export default function GrammarNotePage() {
  const { label } = useParams()
  const note = NOTES[label]

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title={note?.title || 'இலக்கணக் குறிப்பு'} />
      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-10">
        <div className="card text-center text-gray-400 py-16">
          <p className="text-4xl mb-4">{note?.short || '📘'}</p>
          <p className="font-tamil text-lg text-gray-600 mb-2">{note?.title}</p>
          <p className="font-tamil">விரிவான விளக்கப் பக்கம் விரைவில் சேர்க்கப்படும்</p>
        </div>
      </main>
    </div>
  )
}
