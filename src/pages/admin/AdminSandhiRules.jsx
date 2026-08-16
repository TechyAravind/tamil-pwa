import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const STEP_BLANK = { condition: '', rule: '', result: '' }

/**
 * Admin UI for புணர்ச்சி விதிகள் (sandhi_rules) — the rule shown when the
 * user taps an Active-Junction connector in the சொற்களின் புணர்ச்சி tab.
 * One row per connector (junction) inside a word group.
 *
 * Each connector also has an Active Junction / Base Merge toggle — this
 * writes to morphemes.is_sandhi_junction on the morpheme immediately
 * BEFORE that connector (word_groups store their morphemes in position
 * order; connector i sits between units[i] and units[i+1], so the flag
 * lives on units[i]).
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
      supabase.from('morphemes').select('id, poem_line_id, position, display_form, is_separator, word_group_id, is_sandhi_junction').order('position'),
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
    mnemonic_tag: ruleByConnector[i]?.mnemonic_tag || '',
    before_form: ruleByConnector[i]?.before_form || '',
    after_form: ruleByConnector[i]?.after_form || '',
    changed_letter: ruleByConnector[i]?.changed_letter || '',
    rule_steps: (Array.isArray(ruleByConnector[i]?.rule_steps) && ruleByConnector[i].rule_steps.length > 0)
      ? ruleByConnector[i].rule_steps
      : [STEP_BLANK]
  }

  const updateDraft = (i, field, val) =>
    setDrafts((d) => ({ ...d, [i]: { ...draftFor(i), [field]: val } }))

  const updateStep = (i, stepIdx, field, val) => {
    const d = draftFor(i)
    const steps = d.rule_steps.map((s, si) => si === stepIdx ? { ...s, [field]: val } : s)
    updateDraft(i, 'rule_steps', steps)
  }
  const addStep = (i) => updateDraft(i, 'rule_steps', [...draftFor(i).rule_steps, { ...STEP_BLANK }])
  const removeStep = (i, stepIdx) => {
    const remaining = draftFor(i).rule_steps.filter((_, si) => si !== stepIdx)
    updateDraft(i, 'rule_steps', remaining.length > 0 ? remaining : [{ ...STEP_BLANK }])
  }

  const saveConnector = async (i) => {
    const d = draftFor(i)
    const steps = d.rule_steps.filter((s) => s.condition.trim() || s.rule.trim() || s.result.trim())
    if (steps.length === 0) return showToast('குறைந்தது ஒரு விதிப்படி (rule step) தேவை', 'error')

    const payload = {
      word_group_id: groupId,
      connector_index: i,
      mnemonic_tag: d.mnemonic_tag || null,
      rule_steps: steps,
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
    setDrafts((d2) => { const n = { ...d2 }; delete n[i]; return n })
    load()
  }

  const removeConnector = async (i) => {
    const existing = ruleByConnector[i]
    if (!existing) return
    if (!confirm('இந்த விதியை நீக்கவா?')) return
    await supabase.from('sandhi_rules').delete().eq('id', existing.id)
    showToast('நீக்கப்பட்டது'); load()
  }

  // Toggle Active Junction / Base Merge — lives on the morpheme immediately
  // BEFORE this connector (units[i]).
  const toggleJunction = async (i) => {
    const morph = units[i]
    if (!morph) return
    const nextValue = morph.is_sandhi_junction === false ? true : false
    const { error } = await supabase.from('morphemes').update({ is_sandhi_junction: nextValue }).eq('id', morph.id)
    if (error) return showToast('பிழை: ' + error.message, 'error')
    showToast(nextValue ? 'Active Junction ஆக மாற்றப்பட்டது' : 'Base Merge ஆக மாற்றப்பட்டது')
    load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-2">Sandhi Rules (புணர்ச்சி விதிகள்)</h2>
      <p className="text-sm text-gray-500 mb-4 max-w-2xl">
        One row per junction inside a word group — the point where two morphemes are
        combined. Word groups are created on the Morphemes admin page; pick one here to
        add the சந்தி rule shown when a student taps that junction in the app. Each
        junction can be marked Active (interactive button + mnemonic pill) or Base Merge
        (subtle static divider, non-interactive — used for plain concatenation or internal
        verb-tense suffixing that isn't a real documented sandhi phenomenon).
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
        <div className="space-y-4 max-w-2xl">
          {Array.from({ length: connectorCount }).map((_, i) => {
            const d = draftFor(i)
            const existing = ruleByConnector[i]
            const isActive = units[i]?.is_sandhi_junction !== false
            return (
              <div key={i} className="card space-y-3">
                <div className="flex items-center justify-between flex-wrap gap-2">
                  <h3 className="font-semibold font-tamil">
                    இணைப்பு {i + 1}: {units[i]?.display_form} + {units[i + 1]?.display_form}
                  </h3>
                  <button
                    type="button"
                    onClick={() => toggleJunction(i)}
                    className={`text-xs font-bold px-3 py-1.5 rounded-full border transition-colors
                      ${isActive
                        ? 'bg-blue-50 text-blue-700 border-blue-200 hover:bg-blue-100'
                        : 'bg-gray-100 text-gray-500 border-gray-200 hover:bg-gray-200'}`}
                  >
                    {isActive ? '🔵 Active Junction' : '· Base Merge'} — click to toggle
                  </button>
                </div>

                <div className="grid grid-cols-3 gap-3">
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
                  <div>
                    <label className="label">மாறிய எழுத்து (optional)</label>
                    <input className="input font-tamil" placeholder="e.g. ற்"
                      value={d.changed_letter}
                      onChange={(e) => updateDraft(i, 'changed_letter', e.target.value)} />
                  </div>
                </div>

                <div>
                  <label className="label">Mnemonic tag (optional pill, e.g. "இ ஈ ஐ | உயிர்")</label>
                  <input className="input font-tamil" placeholder="e.g. உ | மெ"
                    value={d.mnemonic_tag}
                    onChange={(e) => updateDraft(i, 'mnemonic_tag', e.target.value)} />
                </div>

                <div className="space-y-2">
                  <label className="label">விதிப்படிகள் (Rule steps — shown in order in the popup)</label>
                  {d.rule_steps.map((step, si) => (
                    <div key={si} className="grid grid-cols-[1fr_1fr_1fr_auto] gap-2 items-start bg-cream/50 p-2 rounded-lg">
                      <input className="input font-tamil text-sm" placeholder="condition (எ.கா. உ | மெ)"
                        value={step.condition}
                        onChange={(e) => updateStep(i, si, 'condition', e.target.value)} />
                      <input className="input font-tamil text-sm" placeholder="rule (விதி உரை)"
                        value={step.rule}
                        onChange={(e) => updateStep(i, si, 'rule', e.target.value)} />
                      <input className="input font-tamil text-sm" placeholder="result (விளைவு)"
                        value={step.result}
                        onChange={(e) => updateStep(i, si, 'result', e.target.value)} />
                      <button type="button" onClick={() => removeStep(i, si)}
                        className="text-red-500 text-xs px-2 py-1.5 hover:bg-red-50 rounded">✕</button>
                    </div>
                  ))}
                  <button type="button" onClick={() => addStep(i)}
                    className="text-xs text-primary font-semibold hover:underline">+ படி சேர்</button>
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
