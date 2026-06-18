import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const BLANK = { page_id: '', line_number: 1, raw_text: '' }

export default function AdminPoemLines() {
  const [rows, setRows]   = useState([])
  const [pages, setPages] = useState([])   // only செய்யுள் பகுதி pages
  const [form, setForm]   = useState(BLANK)
  const [editing, setEditing] = useState(null)
  const [toast, setToast] = useState(null)

  const load = async () => {
    const [{ data: lines }, { data: pagesData }] = await Promise.all([
      supabase.from('poem_lines').select('*, pages(page_type, topics(title))').order('line_number'),
      supabase.from('pages').select('id, page_type, topics(title)').eq('page_type', 'செய்யுள் பகுதி')
    ])
    setRows(lines || [])
    setPages(pagesData || [])
    if (pagesData?.length && !form.page_id) setForm((f) => ({ ...f, page_id: pagesData[0].id }))
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const save = async (e) => {
    e.preventDefault()
    if (!form.raw_text.trim()) return showToast('வரி உரை தேவை', 'error')
    if (!form.page_id) return showToast('பக்கம் தேர்வு செய்யவும்', 'error')

    const payload = { page_id: form.page_id, line_number: +form.line_number, raw_text: form.raw_text }
    if (editing) {
      const { error } = await supabase.from('poem_lines').update(payload).eq('id', editing)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('திருத்தப்பட்டது ✓')
      setEditing(null)
    } else {
      const { error } = await supabase.from('poem_lines').insert(payload)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('வரி சேர்க்கப்பட்டது ✓')
    }
    setForm({ ...BLANK, page_id: form.page_id })
    load()
  }

  const remove = async (id) => {
    if (!confirm('இந்த வரியை நீக்கவா? அதில் உள்ள சொல் பகுப்பும் அழியும்.')) return
    await supabase.from('poem_lines').delete().eq('id', id)
    showToast('நீக்கப்பட்டது')
    load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Poem Lines (கவிதை வரிகள்)</h2>

      <form onSubmit={save} className="card mb-6 space-y-3 max-w-lg">
        <h3 className="font-semibold">{editing ? 'Edit Line' : 'Add New Poem Line'}</h3>
        <div>
          <label className="label">செய்யுள் பகுதி Page *</label>
          <select className="input" value={form.page_id}
            onChange={(e) => setForm({ ...form, page_id: e.target.value })}>
            <option value="">— தேர்வு செய்க —</option>
            {pages.map((p) => (
              <option key={p.id} value={p.id}>{p.topics?.title} — {p.page_type}</option>
            ))}
          </select>
        </div>
        <div>
          <label className="label">வரி எண் (Line Number) *</label>
          <input type="number" className="input" min={1} value={form.line_number}
            onChange={(e) => setForm({ ...form, line_number: +e.target.value })} />
        </div>
        <div>
          <label className="label">வரி உரை (Raw Text) *</label>
          <input className="input font-tamil text-lg" placeholder="e.g. விரல் முனையைத் தீயிலே தோய்த்து"
            value={form.raw_text} onChange={(e) => setForm({ ...form, raw_text: e.target.value })} />
        </div>
        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editing ? 'Update' : 'Add Line'}</button>
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
              <th className="py-2 pr-4">Topic</th>
              <th className="py-2 pr-4">#</th>
              <th className="py-2 pr-4">வரி</th>
              <th className="py-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-3 pr-4 text-gray-500">{row.pages?.topics?.title}</td>
                <td className="py-3 pr-4 font-bold text-primary">{row.line_number}</td>
                <td className="py-3 pr-4 font-tamil">{row.raw_text}</td>
                <td className="py-3 flex gap-2">
                  <button onClick={() => { setEditing(row.id); setForm({ page_id: row.page_id, line_number: row.line_number, raw_text: row.raw_text }) }}
                    className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
                  <button onClick={() => remove(row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
                </td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan={4} className="py-8 text-center text-gray-400">No poem lines yet</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
