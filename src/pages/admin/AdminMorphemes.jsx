import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const POS_OPTIONS = ['பெயர்ச்சொல்', 'வினைச்சொல்', 'இடைச்சொல்', 'உரிச்சொல்']
const BLANK = {
  poem_line_id: '', position: 1, display_form: '',
  word_meaning: '', grammatical_label: POS_OPTIONS[0],
  is_verb: false, is_separator: false
}

export default function AdminMorphemes() {
  const [rows, setRows]   = useState([])
  const [lines, setLines] = useState([])
  const [form, setForm]   = useState(BLANK)
  const [editing, setEditing] = useState(null)
  const [toast, setToast] = useState(null)

  const load = async () => {
    const [{ data: m }, { data: l }] = await Promise.all([
      supabase.from('morphemes')
        .select('*, poem_lines(raw_text, pages(topics(title)))')
        .order('position'),
      supabase.from('poem_lines').select('id, raw_text, line_number').order('line_number')
    ])
    setRows(m || [])
    setLines(l || [])
    if (l?.length && !form.poem_line_id) setForm((f) => ({ ...f, poem_line_id: l[0].id }))
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const save = async (e) => {
    e.preventDefault()
    if (!form.display_form.trim()) return showToast('உருப்பு உரை தேவை', 'error')
    if (!form.poem_line_id) return showToast('வரி தேர்வு செய்யவும்', 'error')

    const payload = {
      poem_line_id:      form.poem_line_id,
      position:          +form.position,
      display_form:      form.display_form,
      word_meaning:      form.word_meaning || null,
      grammatical_label: form.is_separator ? null : form.grammatical_label,
      is_verb:           form.is_verb,
      is_separator:      form.is_separator
    }

    if (editing) {
      const { error } = await supabase.from('morphemes').update(payload).eq('id', editing)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('திருத்தப்பட்டது ✓'); setEditing(null)
    } else {
      const { error } = await supabase.from('morphemes').insert(payload)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('உறுப்பு சேர்க்கப்பட்டது ✓')
    }
    setForm({ ...BLANK, poem_line_id: form.poem_line_id })
    load()
  }

  const remove = async (id) => {
    if (!confirm('இந்த உறுப்பை நீக்கவா?')) return
    await supabase.from('morphemes').delete().eq('id', id)
    showToast('நீக்கப்பட்டது'); load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Morphemes (சொல் பகுப்பு)</h2>

      <form onSubmit={save} className="card mb-6 space-y-3 max-w-lg">
        <h3 className="font-semibold">{editing ? 'Edit Morpheme' : 'Add New Morpheme'}</h3>

        <div>
          <label className="label">கவிதை வரி *</label>
          <select className="input" value={form.poem_line_id}
            onChange={(e) => setForm({ ...form, poem_line_id: e.target.value })}>
            <option value="">— தேர்வு செய்க —</option>
            {lines.map((l) => <option key={l.id} value={l.id}>#{l.line_number}: {l.raw_text}</option>)}
          </select>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className="label">நிலை (Position) *</label>
            <input type="number" className="input" min={1} value={form.position}
              onChange={(e) => setForm({ ...form, position: +e.target.value })} />
          </div>
          <div>
            <label className="label">உருவம் (Display) *</label>
            <input className="input font-tamil" placeholder="e.g. தோய்"
              value={form.display_form} onChange={(e) => setForm({ ...form, display_form: e.target.value })} />
          </div>
        </div>

        <div>
          <label className="label">சொல் பொருள் (Word Meaning)</label>
          <input className="input font-tamil" placeholder="e.g. முக்குதல், தொடுதல் (to dip)"
            value={form.word_meaning} onChange={(e) => setForm({ ...form, word_meaning: e.target.value })} />
        </div>

        <div className="flex items-center gap-4">
          <label className="flex items-center gap-2 cursor-pointer">
            <input type="checkbox" checked={form.is_separator}
              onChange={(e) => setForm({ ...form, is_separator: e.target.checked, is_verb: false })}
              className="w-4 h-4 accent-primary" />
            <span className="text-sm">இது "+" இணைப்பி (separator)</span>
          </label>
        </div>

        {!form.is_separator && (
          <>
            <div>
              <label className="label">இலக்கண வகை (POS)</label>
              <select className="input" value={form.grammatical_label}
                onChange={(e) => setForm({ ...form, grammatical_label: e.target.value })}>
                {POS_OPTIONS.map((p) => <option key={p} value={p}>{p}</option>)}
              </select>
            </div>
            <label className="flex items-center gap-2 cursor-pointer">
              <input type="checkbox" checked={form.is_verb}
                onChange={(e) => setForm({ ...form, is_verb: e.target.checked,
                  grammatical_label: e.target.checked ? 'வினைச்சொல்' : form.grammatical_label })}
                className="w-4 h-4 accent-primary" />
              <span className="text-sm">வினைச்சொல் — பகுபத உறுப்பிலக்கணம் காட்டு</span>
            </label>
          </>
        )}

        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editing ? 'Update' : 'Add Morpheme'}</button>
          {editing && (
            <button type="button" className="btn-ghost"
              onClick={() => { setEditing(null); setForm(BLANK) }}>Cancel</button>
          )}
        </div>
      </form>

      <div className="card overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-gray-100 text-left text-gray-500">
              <th className="py-2 pr-3">Line</th>
              <th className="py-2 pr-3">Pos</th>
              <th className="py-2 pr-3">உருவம்</th>
              <th className="py-2 pr-3">POS</th>
              <th className="py-2 pr-3">Verb?</th>
              <th className="py-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-2 pr-3 text-gray-400 text-xs max-w-[120px] truncate">
                  {row.poem_lines?.raw_text}
                </td>
                <td className="py-2 pr-3 text-gray-500">{row.position}</td>
                <td className="py-2 pr-3 font-tamil font-bold">{row.display_form}</td>
                <td className="py-2 pr-3 text-gray-500">{row.is_separator ? '—' : row.grammatical_label}</td>
                <td className="py-2 pr-3">{row.is_verb ? '✓' : ''}</td>
                <td className="py-2 flex gap-1">
                  <button onClick={() => {
                    setEditing(row.id)
                    setForm({
                      poem_line_id: row.poem_line_id, position: row.position,
                      display_form: row.display_form, word_meaning: row.word_meaning || '',
                      grammatical_label: row.grammatical_label || POS_OPTIONS[0],
                      is_verb: row.is_verb, is_separator: row.is_separator
                    })
                  }} className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">
                    Edit
                  </button>
                  <button onClick={() => remove(row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Del</button>
                </td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan={6} className="py-8 text-center text-gray-400">No morphemes yet</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
