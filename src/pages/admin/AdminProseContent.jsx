import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const PROSE_TYPES = ['நுழையும் முன்', 'இலக்கணப் பகுதி', 'துணைக் குறிப்புகள்', 'நூல் வெளி']
const BLANK = { page_id: '', content_text: '', order_index: 1 }

export default function AdminProseContent() {
  const [rows, setRows]   = useState([])
  const [pages, setPages] = useState([])
  const [form, setForm]   = useState(BLANK)
  const [editing, setEditing] = useState(null)
  const [toast, setToast] = useState(null)

  const load = async () => {
    const [{ data: prose }, { data: pagesData }] = await Promise.all([
      supabase.from('prose_content')
        .select('*, pages(page_type, topics(title))').order('order_index'),
      supabase.from('pages')
        .select('id, page_type, topics(title)')
        .in('page_type', PROSE_TYPES)
    ])
    setRows(prose || [])
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
      const { error } = await supabase.from('prose_content').update(payload).eq('id', editing)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('திருத்தப்பட்டது ✓'); setEditing(null)
    } else {
      const { error } = await supabase.from('prose_content').insert(payload)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('உரை சேர்க்கப்பட்டது ✓')
    }
    setForm({ ...BLANK, page_id: form.page_id })
    load()
  }

  const remove = async (id) => {
    if (!confirm('இந்த உரையை நீக்கவா?')) return
    await supabase.from('prose_content').delete().eq('id', id)
    showToast('நீக்கப்பட்டது'); load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Prose Content (உரை நடை உள்ளடக்கம்)</h2>

      <form onSubmit={save} className="card mb-6 space-y-3 max-w-xl">
        <h3 className="font-semibold">{editing ? 'Edit Prose' : 'Add Prose Paragraph'}</h3>
        <div>
          <label className="label">Page *</label>
          <select className="input" value={form.page_id}
            onChange={(e) => setForm({ ...form, page_id: e.target.value })}>
            <option value="">— தேர்வு செய்க —</option>
            {pages.map((p) => (
              <option key={p.id} value={p.id}>{p.topics?.title} — {p.page_type}</option>
            ))}
          </select>
        </div>
        <div>
          <label className="label">உரை (Text) *</label>
          <textarea rows={5} className="input font-tamil resize-y"
            placeholder="Tamil text paragraph..."
            value={form.content_text}
            onChange={(e) => setForm({ ...form, content_text: e.target.value })} />
        </div>
        <div>
          <label className="label">வரிசை எண்</label>
          <input type="number" className="input" min={1} value={form.order_index}
            onChange={(e) => setForm({ ...form, order_index: +e.target.value })} />
        </div>
        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editing ? 'Update' : 'Add Paragraph'}</button>
          {editing && (
            <button type="button" className="btn-ghost"
              onClick={() => { setEditing(null); setForm(BLANK) }}>Cancel</button>
          )}
        </div>
      </form>

      <div className="space-y-3">
        {rows.map((row) => (
          <div key={row.id} className="card">
            <p className="text-xs text-gray-400 mb-2">
              {row.pages?.topics?.title} — {row.pages?.page_type} (#{row.order_index})
            </p>
            <p className="font-tamil text-gray-800 leading-relaxed line-clamp-3">{row.content_text}</p>
            <div className="flex gap-2 mt-3">
              <button onClick={() => { setEditing(row.id); setForm({ page_id: row.page_id, content_text: row.content_text, order_index: row.order_index }) }}
                className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
              <button onClick={() => remove(row.id)}
                className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
            </div>
          </div>
        ))}
        {rows.length === 0 && (
          <div className="card text-center text-gray-400 py-8">No prose content yet</div>
        )}
      </div>
    </div>
  )
}
