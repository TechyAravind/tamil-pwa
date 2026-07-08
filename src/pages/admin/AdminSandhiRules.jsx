import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const RULE_BLANK = { rule_text: '', before_form: '', after_form: '', changed_letter: '' }

/**
 * Admin UI for புணர்ச்சி விதிகள் (sandhi_rules) — the rule shown when the
 * user taps a junction point in the new இலக்கணம் tab. One row per
 * connector (junction) inside a word group.
 */
export default function AdminSandhiRules() {
  const [lines, setLines]   = useState([])
  const [groups, setGroups] = useState([])       // all word_groups (with poem_lines join)
  const [morphemes, setMorphemes] = useState([]) // all morphemes (to compute units per group)
  const [rules, setRules]   = useState([])       // all sandhi_rules

  const [lineId, setLineId]   = useState('')
  const [groupId, setGroupId] = useState('')
  const [toast, setToast]     = useState(null)

  const load = async () => {
    const [{ data: l }, { data: g }, { data: m }, { data: r }] = await Promise.all([
      supabase.from('poem_lines').select('id, raw_text, line_number').order('line_number'),
      supabase.from('word_groups').select('*').order('position'),
      supabase.from('morphemes').select('id, poem_line_id, position, display_form, is_separator, word_group_id').order('position'),
      supabase.from('sandhi_rules').select('*').order('connector_index')
    ])
    setLines(l || [])
    setGroups(g || [])
    setMorphemes(m || [])
    setRules(r || [])
    if (l?.length && !lineId) setLineId(l[0].id)
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const groupsForLine = groups.filter((g) => g.poem_line_id === lineId)
  const unitsForGroup = (gId) => morphemes
    .filter((m) => m.word_group_id === gId && !m.is_separator)
    .sort((a, b) => a.position - b.position)

  const units = groupId ? unitsForGroup(groupId) : []
  const connectorCount = Math.max(units.length - 1, 0)
  const rulesForGroup = rules.filter((r) => r.word_group_id === groupId)
  const ruleByConnector = {}
  rulesForGroup.forEach((r) => { ruleByConnector[r.connector_index] = r })

  const [drafts, setDrafts] = useState({}) // connectorIndex → form fields, edited in this session

  const draftFor = (i) => drafts[i] || {
    rule_text: ruleByConnector[i]?.rule_text || '',
    before_form: ruleByConnector[i]?.before_form || '',
    after_form: ruleByConnector[i]?.after_form || '',
    changed_letter: ruleByConnector[i]?.changed_letter || ''
  }

  const updateDraft = (i, field, val) =>
    setDrafts((d) => ({ ...d, [i]: { ...draftFor(i), [field]: val } }))

  const saveConnector = async (i) => {
    const d = draftFor(i)
    if (!d.rule_text.trim()) return showToast('விதி உரை தேவை', 'error')

    const payload = {
      word_group_id: groupId,
      connector_index: i,
      rule_text: d.rule_text,
      before_form: d.before_form || null,
      after_form: d.after_form || null,
      changed_letter: d.changed_letter || null
    }

    const existing = ruleByConnector[i]
    const { error } = existing
      ? await supabase.from('sandhi_rules').update(payload).eq('id', existing.id)
      : await supabase.from('sandhi_rules').insert(payload)

    if (error) return showToast('பிழை: ' + error.message, 'error')
    showToast('விதி சேமிக்கப்பட்டது ✓')
    setDrafts((d) => { const n = { ...d }; delete n[i]; return n })
    load()
  }

  const removeConnector = async (i) => {
    const existing = ruleByConnector[i]
    if (!existing) return
    if (!confirm('இந்த விதியை நீக்கவா?')) return
    await supabase.from('sandhi_rules').delete().eq('id', existing.id)
    showToast('நீக்கப்பட்டது'); load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-2">Sandhi Rules (புணர்ச்சி விதிகள்)</h2>
      <p className="text-sm text-gray-500 mb-4 max-w-2xl">
        One row per junction inside a word group — the point where two morphemes are
        combined. Word groups are created on the Morphemes admin page; pick one here to
        add the சந்தி rule shown when a student taps that junction in the app.
      </p>

      <div className="grid grid-cols-2 gap-3 max-w-xl mb-6">
        <div>
          <label className="label">வரி (Line)</label>
          <select className="input" value={lineId}
            onChange={(e) => { setLineId(e.target.value); setGroupId(''); setDrafts({}) }}>
            {lines.map((l) => <option key={l.id} value={l.id}>#{l.line_number}: {l.raw_text}</option>)}
          </select>
        </div>
        <div>
          <label className="label">சொல் தொகுப்பு (Word Group)</label>
          <select className="input" value={groupId}
            onChange={(e) => { setGroupId(e.target.value); setDrafts({}) }}>
            <option value="">— தேர்வு செய்க —</option>
            {groupsForLine.map((g) => (
              <option key={g.id} value={g.id}>#{g.position} {g.combined_display_form}</option>
            ))}
          </select>
        </div>
      </div>

      {groupId && units.length <= 1 && (
        <div className="card text-center text-gray-400 py-8 max-w-xl">
          இந்தத் தொகுப்பில் ஒரே ஒரு உறுப்பு மட்டுமே உள்ளது — இணைப்புப் புள்ளி இல்லை.
        </div>
      )}

      {groupId && connectorCount > 0 && (
        <div className="space-y-4 max-w-xl">
          {Array.from({ length: connectorCount }).map((_, i) => {
            const d = draftFor(i)
            const existing = ruleByConnector[i]
            return (
              <div key={i} className="card space-y-2">
                <h3 className="font-semibold font-tamil">
                  இணைப்பு {i + 1}: {units[i]?.display_form} + {units[i + 1]?.display_form}
                </h3>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="label">Before (e.g. காற்று + இல்)</label>
                    <input className="input font-tamil" value={d.before_form}
                      onChange={(e) => updateDraft(i, 'before_form', e.target.value)} />
                  </div>
                  <div>
                    <label className="label">After (e.g. காற்றில்)</label>
                    <input className="input font-tamil" value={d.after_form}
                      onChange={(e) => updateDraft(i, 'after_form', e.target.value)} />
                  </div>
                </div>

                <div>
                  <label className="label">விதி உரை (Rule text) *</label>
                  <textarea className="input font-tamil" rows={2}
                    placeholder="e.g. உயிர் வரின் மிக்குறும் மெய்யீட்டு பேறே"
                    value={d.rule_text}
                    onChange={(e) => updateDraft(i, 'rule_text', e.target.value)} />
                </div>

                <div>
                  <label className="label">புதிதாகச் சேர்க்கப்பட்ட எழுத்து (optional)</label>
                  <input className="input font-tamil w-32" placeholder="e.g. ற்"
                    value={d.changed_letter}
                    onChange={(e) => updateDraft(i, 'changed_letter', e.target.value)} />
                </div>

                <div className="flex gap-2">
                  <button type="button" onClick={() => saveConnector(i)} className="btn-primary text-sm">
                    {existing ? 'Update' : 'Save'}
                  </button>
                  {existing && (
                    <button type="button" onClick={() => removeConnector(i)}
                      className="text-red-600 text-xs px-3 py-1.5 border border-red-300 rounded hover:bg-red-50">
                      Delete
                    </button>
                  )}
                </div>
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}
