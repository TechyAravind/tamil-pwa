import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const BLANK_ROW = { part: '', label: '' }

export default function AdminVerbAnalysis() {
  const [rows, setRows]         = useState([])   // existing verb_analysis records
  const [verbMorphemes, setVerbMorphemes] = useState([])  // morphemes where is_verb=true
  const [selectedMorpheme, setSelectedMorpheme] = useState('')
  const [analysisRows, setAnalysisRows] = useState([{ ...BLANK_ROW }])
  const [editingId, setEditingId] = useState(null)
  const [toast, setToast]       = useState(null)

  const load = async () => {
    const [{ data: va }, { data: vm }] = await Promise.all([
      supabase.from('verb_analysis')
        .select('*, morphemes(display_form, poem_lines(raw_text))')
        .order('created_at'),
      supabase.from('morphemes')
        .select('id, display_form, poem_lines(raw_text)')
        .eq('is_verb', true)
    ])
    setRows(va || [])
    setVerbMorphemes(vm || [])
    if (vm?.length && !selectedMorpheme) setSelectedMorpheme(vm[0].id)
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const addRow    = () => setAnalysisRows((r) => [...r, { ...BLANK_ROW }])
  const removeRow = (i) => setAnalysisRows((r) => r.filter((_, idx) => idx !== i))
  const updateRow = (i, field, val) =>
    setAnalysisRows((r) => r.map((row, idx) => idx === i ? { ...row, [field]: val } : row))

  const save = async (e) => {
    e.preventDefault()
    if (!selectedMorpheme) return showToast('வினைச்சொல் தேர்வு செய்யவும்', 'error')
    const incomplete = analysisRows.some((r) => !r.part.trim() || !r.label.trim())
    if (incomplete) return showToast('அனைத்து நெடுவரிகளையும் நிரப்பவும்', 'error')

    const payload = { morpheme_id: selectedMorpheme, analysis: analysisRows }

    if (editingId) {
      const { error } = await supabase.from('verb_analysis').update(payload).eq('id', editingId)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('திருத்தப்பட்டது ✓'); setEditingId(null)
    } else {
      const { error } = await supabase.from('verb_analysis').insert(payload)
      if (error) return showToast('பிழை (ஏற்கனவே இருக்கலாம்): ' + error.message, 'error')
      showToast('பகுபதம் சேர்க்கப்பட்டது ✓')
    }
    setAnalysisRows([{ ...BLANK_ROW }])
    load()
  }

  const remove = async (id) => {
    if (!confirm('இந்த பகுபதத்தை நீக்கவா?')) return
    await supabase.from('verb_analysis').delete().eq('id', id)
    showToast('நீக்கப்பட்டது'); load()
  }

  const startEdit = (row) => {
    setEditingId(row.id)
    setSelectedMorpheme(row.morpheme_id)
    setAnalysisRows(row.analysis.map((a) => ({ part: a.part, label: a.label })))
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Verb Analysis (பகுபத உறுப்பிலக்கணம்)</h2>

      <form onSubmit={save} className="card mb-6 space-y-4 max-w-xl">
        <h3 className="font-semibold">{editingId ? 'Edit Analysis' : 'Add Verb Analysis'}</h3>

        <div>
          <label className="label">வினைச்சொல் (Verb Morpheme) *</label>
          <select className="input" value={selectedMorpheme}
            onChange={(e) => setSelectedMorpheme(e.target.value)}>
            <option value="">— தேர்வு செய்க —</option>
            {verbMorphemes.map((m) => (
              <option key={m.id} value={m.id}>
                {m.display_form} — "{m.poem_lines?.raw_text}"
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="label">பகுப்பு வரிகள் (Analysis Rows)</label>
          <div className="space-y-2">
            {analysisRows.map((row, i) => (
              <div key={i} className="flex gap-2 items-center">
                <input className="input w-24 text-center font-tamil font-bold"
                  placeholder="பகுதி" value={row.part}
                  onChange={(e) => updateRow(i, 'part', e.target.value)} />
                <span className="text-gray-400">—</span>
                <input className="input flex-1 font-tamil"
                  placeholder="e.g. பகுதி (verb root)"
                  value={row.label}
                  onChange={(e) => updateRow(i, 'label', e.target.value)} />
                {analysisRows.length > 1 && (
                  <button type="button" onClick={() => removeRow(i)}
                    className="text-red-400 hover:text-red-600 text-lg w-8 h-8 flex items-center justify-center">
                    ✕
                  </button>
                )}
              </div>
            ))}
          </div>
          <button type="button" onClick={addRow}
            className="mt-2 text-primary text-sm border border-primary rounded-lg px-3 py-1.5 hover:bg-primary/5">
            + வரி சேர்க்க
          </button>
        </div>

        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editingId ? 'Update' : 'Save Analysis'}</button>
          {editingId && (
            <button type="button" className="btn-ghost"
              onClick={() => { setEditingId(null); setAnalysisRows([{ ...BLANK_ROW }]) }}>Cancel</button>
          )}
        </div>
      </form>

      <div className="card overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-gray-100 text-left text-gray-500">
              <th className="py-2 pr-4">Morpheme</th>
              <th className="py-2 pr-4">Analysis</th>
              <th className="py-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-3 pr-4 font-bold font-tamil text-primary">
                  {row.morphemes?.display_form}
                </td>
                <td className="py-3 pr-4 text-gray-600">
                  {row.analysis.map((a) => a.part).join(' + ')}
                </td>
                <td className="py-3 flex gap-2">
                  <button onClick={() => startEdit(row)}
                    className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
                  <button onClick={() => remove(row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
                </td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan={3} className="py-8 text-center text-gray-400">No verb analyses yet</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
