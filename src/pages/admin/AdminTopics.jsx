import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const BLANK = { section_id: '', title: '', order_index: 1 }

export default function AdminTopics() {
  const [rows, setRows]       = useState([])
  const [sections, setSections] = useState([])
  const [form, setForm]       = useState(BLANK)
  const [editing, setEditing] = useState(null)
  const [toast, setToast]     = useState(null)

  const load = async () => {
    const [{ data: t }, { data: s }] = await Promise.all([
      supabase.from('topics').select('*, sections(name)').order('order_index'),
      supabase.from('sections').select('id, name').order('order_index')
    ])
    setRows(t || [])
    setSections(s || [])
    if (s?.length && !form.section_id) setForm((f) => ({ ...f, section_id: s[0].id }))
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const save = async (e) => {
    e.preventDefault()
    if (!form.title.trim()) return showToast('தலைப்பு தேவை', 'error')
    if (!form.section_id)   return showToast('பகுதி தேர்வு செய்யவும்', 'error')

    const payload = { section_id: form.section_id, title: form.title, order_index: +form.order_index }
    if (editing) {
      const { error } = await supabase.from('topics').update(payload).eq('id', editing)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('திருத்தப்பட்டது ✓')
      setEditing(null)
    } else {
      const { error } = await supabase.from('topics').insert(payload)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('சேர்க்கப்பட்டது ✓')
    }
    setForm({ ...BLANK, section_id: form.section_id })
    load()
  }

  const remove = async (id) => {
    if (!confirm('இந்த தலைப்பை நீக்கவா?')) return
    const { error } = await supabase.from('topics').delete().eq('id', id)
    if (error) return showToast('பிழை: ' + error.message, 'error')
    showToast('நீக்கப்பட்டது')
    load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Topics (தலைப்புகள்)</h2>

      <form onSubmit={save} className="card mb-6 space-y-3 max-w-lg">
        <h3 className="font-semibold">{editing ? 'Edit Topic' : 'Add New Topic'}</h3>
        <div>
          <label className="label">பகுதி (Section) *</label>
          <select className="input" value={form.section_id}
            onChange={(e) => setForm({ ...form, section_id: e.target.value })}>
            <option value="">— தேர்வு செய்க —</option>
            {sections.map((s) => <option key={s.id} value={s.id}>{s.name}</option>)}
          </select>
        </div>
        <div>
          <label className="label">தலைப்பு (Title) *</label>
          <input className="input" placeholder="e.g. யுகத்தின் பாடல்"
            value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} />
        </div>
        <div>
          <label className="label">வரிசை எண்</label>
          <input type="number" className="input" min={1} value={form.order_index}
            onChange={(e) => setForm({ ...form, order_index: +e.target.value })} />
        </div>
        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editing ? 'Update' : 'Add Topic'}</button>
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
              <th className="py-2 pr-4">தலைப்பு</th>
              <th className="py-2 pr-4">பகுதி</th>
              <th className="py-2 pr-4">வரிசை</th>
              <th className="py-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-3 pr-4 font-medium">{row.title}</td>
                <td className="py-3 pr-4 text-gray-500">{row.sections?.name}</td>
                <td className="py-3 pr-4 text-gray-500">{row.order_index}</td>
                <td className="py-3 flex gap-2">
                  <button onClick={() => { setEditing(row.id); setForm({ section_id: row.section_id, title: row.title, order_index: row.order_index }) }}
                    className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
                  <button onClick={() => remove(row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
                </td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan={4} className="py-8 text-center text-gray-400">No topics yet</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
