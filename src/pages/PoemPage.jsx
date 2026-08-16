import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import Navbar from '../components/Navbar'
import PoemLineAccordion from '../components/PoemLineAccordion'
import { supabase } from '../supabase'

const TABS = [
  { id: 'meaning', label: 'சொல் பொருள்' },
  { id: 'grammar', label: 'சொல் வகை' },
  { id: 'sandhi',  label: 'சொற்களின் புணர்ச்சி' },
  { id: 'literary', label: 'இலக்கிய நயம்' }
]

const POS_LEGEND = [
  { short: 'பெ', label: 'பெயர்ச்சொல்',  color: 'text-pos-noun',     bg: 'bg-blue-50 border-blue-200',   route: 'peyarchol' },
  { short: 'வி', label: 'வினைச்சொல்',  color: 'text-pos-verb',     bg: 'bg-green-50 border-green-200', route: 'vinaichol' },
  { short: 'இ',  label: 'இடைச்சொல்',   color: 'text-pos-particle', bg: 'bg-yellow-50 border-yellow-200', route: 'idaichol' },
  { short: 'உ',  label: 'உரிச்சொல்',   color: 'text-pos-uri',      bg: 'bg-purple-50 border-purple-200', route: 'urichol' }
]

export default function PoemPage() {
  const { topicId } = useParams()
  const [activeTab, setActiveTab] = useState('meaning')
  const [topic, setTopic]         = useState(null)
  const [lines, setLines]         = useState([])
  const [verbAnalysisMap, setVerbAnalysisMap]           = useState({})  // morphemeId  -> analysis object
  const [groupVerbAnalysisMap, setGroupVerbAnalysisMap] = useState({})  // wordGroupId -> analysis object
  const [sandhiRulesMap, setSandhiRulesMap]             = useState({})  // wordGroupId -> { connectorIndex: rule }
  const [literaryNotes, setLiteraryNotes] = useState([])
  const [loading, setLoading]     = useState(true)

  useEffect(() => {
    async function load() {
      // 1. Topic title
      const { data: topicData } = await supabase
        .from('topics').select('title').eq('id', topicId).single()
      setTopic(topicData)

      // 2. Get the செய்யுள் பகுதி page
      const { data: pageData } = await supabase
        .from('pages')
        .select('id')
        .eq('topic_id', topicId)
        .eq('page_type', 'செய்யுள் பகுதி')
        .single()

      if (!pageData) { setLoading(false); return }

      const pageId = pageData.id

      // 3. Get poem lines + their morphemes + word groups in one query
      const { data: linesData } = await supabase
        .from('poem_lines')
        .select(`
          id, line_number, raw_text,
          morphemes (
            id, position, display_form, word_meaning,
            grammatical_label, is_verb, is_separator, word_group_id,
            structural_role, role_category, is_sandhi_junction
          ),
          word_groups (
            id, position, combined_display_form, combined_meaning,
            combined_grammatical_label, combined_is_verb, combined_grammar_note
          )
        `)
        .eq('page_id', pageId)
        .order('line_number')

      setLines(linesData || [])

      const allGroups = (linesData || []).flatMap((l) => l.word_groups || [])
      const groupIds  = allGroups.map((g) => g.id)

      // 4a. Per-morpheme verb analyses (பகுபத உறுப்பிலக்கணம் for individual chips)
      const verbIds = (linesData || [])
        .flatMap((l) => l.morphemes || [])
        .filter((m) => m.is_verb)
        .map((m) => m.id)

      if (verbIds.length > 0) {
        const { data: analyses } = await supabase
          .from('verb_analysis')
          .select('morpheme_id, analysis')
          .in('morpheme_id', verbIds)
        const map = {}
        ;(analyses || []).forEach((a) => { map[a.morpheme_id] = a })
        setVerbAnalysisMap(map)
      }

      // 4b. Per-word-group verb analyses (பகுபத உறுப்பிலக்கணம் for the combined chip)
      if (groupIds.length > 0) {
        const { data: groupAnalyses } = await supabase
          .from('verb_analysis')
          .select('word_group_id, analysis')
          .in('word_group_id', groupIds)
        const map = {}
        ;(groupAnalyses || []).forEach((a) => { map[a.word_group_id] = a })
        setGroupVerbAnalysisMap(map)

        // 4c. புணர்ச்சி rules per group connector (இலக்கணம் tab)
        const { data: rules } = await supabase
          .from('sandhi_rules')
          .select('word_group_id, connector_index, mnemonic_tag, mnemonic_hierarchy, rule_steps, before_form, after_form, changed_letter')
          .in('word_group_id', groupIds)
        const rulesMap = {}
        ;(rules || []).forEach((r) => {
          rulesMap[r.word_group_id] ||= {}
          rulesMap[r.word_group_id][r.connector_index] = r
        })
        setSandhiRulesMap(rulesMap)
      }

      // 5. Literary notes
      const { data: notes } = await supabase
        .from('literary_notes')
        .select('content_text, order_index')
        .eq('page_id', pageId)
        .order('order_index')
      setLiteraryNotes(notes || [])

      setLoading(false)
    }
    load()
  }, [topicId])

  if (loading) return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title="செய்யுள் பகுதி" />
      <div className="flex-1 flex items-center justify-center">
        <p className="text-primary text-xl animate-pulse">ஏற்றுகிறது…</p>
      </div>
    </div>
  )

  return (
    <div className="min-h-screen bg-cream flex flex-col">
      <Navbar showBack title={topic?.title || 'செய்யுள்'} />

      {/* Tab bar — sticky below navbar */}
      <div className="sticky top-14 z-20 bg-white border-b border-gray-100 shadow-sm">
        <div className="flex max-w-2xl mx-auto">
          {TABS.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex-1 py-3 text-sm sm:text-base font-semibold transition-colors min-h-[48px]
                border-b-2 ${activeTab === tab.id
                  ? 'text-primary border-primary'
                  : 'text-gray-500 border-transparent hover:text-primary'
                }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      <main className="flex-1 max-w-2xl mx-auto w-full px-4 py-6">
        {/* Tab: சொல் பொருள் */}
        {activeTab === 'meaning' && (
          <div>
            <p className="text-sm text-gray-500 mb-4">
              ஒவ்வொரு வரியையும் அழுத்தி சொல் பொருளை அறியுங்கள்
            </p>
            {lines.length === 0 ? (
              <div className="card text-center text-gray-400 py-12">
                <p className="text-4xl mb-3">📜</p>
                <p>செய்யுள் வரிகள் சேர்க்கப்படவில்லை</p>
              </div>
            ) : (
              lines.map((line) => (
                <PoemLineAccordion
                  key={line.id}
                  line={line}
                  verbAnalysisMap={verbAnalysisMap}
                  sandhiRulesMap={sandhiRulesMap}
                  mode="meaning"
                />
              ))
            )}
          </div>
        )}

        {/* Tab: இலக்கணக்குறிப்பு */}
        {activeTab === 'grammar' && (
          <div>
            {/* Legend — tap an abbreviation to open its explanation page */}
            <div className="card mb-5 flex flex-wrap gap-3">
              {POS_LEGEND.map((p) => (
                <Link
                  key={p.short}
                  to={`/ilakkanam-kurippu/${p.route}`}
                  className={`flex items-center gap-1.5 border rounded-lg px-2 py-1 ${p.bg}
                              hover:shadow-sm active:scale-95 transition-all`}
                >
                  <span className={`font-bold text-sm ${p.color}`}>{p.short}</span>
                  <span className="text-xs text-gray-600">= {p.label}</span>
                </Link>
              ))}
              <Link
                to="/ilakkanam-kurippu/pagupatham"
                className="flex items-center gap-1.5 border-2 border-green-400 rounded-lg px-2 py-1
                           bg-green-50 hover:shadow-sm active:scale-95 transition-all"
              >
                <span className="text-xs text-gray-600">🟢 வினைச்சொல் → பகுபத உறுப்பிலக்கணம் அழுத்துக</span>
              </Link>
            </div>

            {lines.length === 0 ? (
              <div className="card text-center text-gray-400 py-12">
                <p className="text-4xl mb-3">🔤</p>
                <p>செய்யுள் வரிகள் சேர்க்கப்படவில்லை</p>
              </div>
            ) : (
              lines.map((line) => (
                <PoemLineAccordion
                  key={line.id}
                  line={line}
                  verbAnalysisMap={verbAnalysisMap}
                  groupVerbAnalysisMap={groupVerbAnalysisMap}
                  sandhiRulesMap={sandhiRulesMap}
                  mode="grammar"
                />
              ))
            )}
          </div>
        )}

        {/* Tab: இலக்கணம் (புணர்ச்சி) */}
        {activeTab === 'sandhi' && (
          <div>
            <p className="text-sm text-gray-500 mb-4 font-tamil">
              இணைப்புப் புள்ளியை அழுத்தி புணர்ச்சி விதியைப் பாருங்கள்
            </p>
            {lines.length === 0 ? (
              <div className="card text-center text-gray-400 py-12">
                <p className="text-4xl mb-3">🔗</p>
                <p>செய்யுள் வரிகள் சேர்க்கப்படவில்லை</p>
              </div>
            ) : (
              lines.map((line) => (
                <PoemLineAccordion
                  key={line.id}
                  line={line}
                  sandhiRulesMap={sandhiRulesMap}
                  mode="sandhi"
                />
              ))
            )}
          </div>
        )}

        {/* Tab: இலக்கிய நயம் */}
        {activeTab === 'literary' && (
          <div>
            {literaryNotes.length === 0 ? (
              <div className="card text-center text-gray-400 py-12">
                <p className="text-4xl mb-3">✨</p>
                <p>இலக்கிய நயக் குறிப்புகள் விரைவில் சேர்க்கப்படும்</p>
              </div>
            ) : (
              <div className="space-y-5 font-md text-gray-800 leading-relaxed">
                {literaryNotes.map((note, i) => (
                  <div key={i} className="card">
                    <p className="text-justify">{note.content_text}</p>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </main>
    </div>
  )
}
