import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const BLANK = { page_id: '', content_text: '', order_index: 1 }

export default function AdminLiteraryNotes() {
  const [rows, setRows]   = useState([])
  const [pages, setPages] = useState([])
  const [form, setForm]   = useState(BLANK)
  const [editing, setEditing] = useState(null)
  const [toast, setToast] = useState(null)

  const load = async () => {
    const [{ data: notes }, { data: pagesData }] = await Promise.all([
      supabase.from('literary_notes')
        .select('*, pages(page_type, topics(title))').order('order_index'),
      supabase.from('pages')
        .select('id, page_type, topics(title)').eq('page_type', 'செய்யுள் பகுதி')
    ])
    setRows(notes || [])
    setPages(pagesData || [])
    if (pagesData?.length && !form.page_id) setForm((f) => ({ ...f, page_id: pagesData[0].id }))
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const save = async (e) => {
    e.preventDefault()
    if (!form.content_text.trim()) return showToast('உள்ளடக்கம் தேவை', 'error')
    const payload = { page_id: form.page_id, content_text: form.content_text, order_index: +form.order_index }
    if (editing) {
      const { error } = await supabase.from('literary_notes').update(payload).eq('id', editing)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('திருத்தப்பட்டது ✓'); setEditing(null)
    } else {
      const { error } = await supabase.from('literary_notes').insert(payload)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('குறிப்பு சேர்க்கப்பட்டது ✓')
    }
    setForm({ ...BLANK, page_id: form.page_id })
    load()
  }

  const remove = async (id) => {
    if (!confirm('இந்த குறிப்பை நீக்கவா?')) return
    await supabase.from('literary_notes').delete().eq('id', id)
    showToast('நீக்கப்பட்டது'); load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Literary Notes (இலக்கிய நயம்)</h2>

      <form onSubmit={save} className="card mb-6 space-y-3 max-w-xl">
        <h3 className="font-semibold">{editing ? 'Edit Note' : 'Add Literary Note'}</h3>
        <div>
          <label className="label">செய்யுள் Page *</label>
          <select className="input" value={form.page_id}
            onChange={(e) => setForm({ ...form, page_id: e.target.value })}>
            <option value="">— தேர்வு செய்க —</option>
            {pages.map((p) => <option key={p.id} value={p.id}>{p.topics?.title}</option>)}
          </select>
        </div>
        <div>
          <label className="label">இலக்கிய நயக் குறிப்பு *</label>
          <textarea rows={4} className="input font-tamil resize-y"
            placeholder="e.g. இக்கவிதையில் உருவக அணி அமைந்துள்ளது..."
            value={form.content_text}
            onChange={(e) => setForm({ ...form, content_text: e.target.value })} />
        </div>
        <div>
          <label className="label">வரிசை எண்</label>
          <input type="number" className="input" min={1} value={form.order_index}
            onChange={(e) => setForm({ ...form, order_index: +e.target.value })} />
        </div>
        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editing ? 'Update' : 'Add Note'}</button>
          {editing && (
            <button type="button" className="btn-ghost"
              onClick={() => { setEditing(null); setForm(BLANK) }}>Cancel</button>
          )}
        </div>
      </form>

      <div className="space-y-3">
        {rows.map((row) => (
          <div key={row.id} className="card">
            <p className="text-xs text-gray-400 mb-2">{row.pages?.topics?.title}</p>
            <p className="font-tamil text-gray-800 leading-relaxed">{row.content_text}</p>
            <div className="flex gap-2 mt-3">
              <button onClick={() => { setEditing(row.id); setForm({ page_id: row.page_id, content_text: row.content_text, order_index: row.order_index }) }}
                className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
              <button onClick={() => remove(row.id)}
                className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
            </div>
          </div>
        ))}
        {rows.length === 0 && (
          <div className="card text-center text-gray-400 py-8">No literary notes yet</div>
        )}
      </div>
    </div>
  )
}
