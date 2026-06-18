import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const PAGE_TYPES = ['நுழையும் முன்', 'செய்யுள் பகுதி', 'இலக்கணப் பகுதி', 'துணைக் குறிப்புகள்', 'நூல் வெளி']
const BLANK = { topic_id: '', page_type: PAGE_TYPES[0] }

export default function AdminPages() {
  const [rows, setRows]     = useState([])
  const [topics, setTopics] = useState([])
  const [form, setForm]     = useState(BLANK)
  const [toast, setToast]   = useState(null)

  const load = async () => {
    const [{ data: p }, { data: t }] = await Promise.all([
      supabase.from('pages').select('*, topics(title)').order('created_at'),
      supabase.from('topics').select('id, title').order('title')
    ])
    setRows(p || [])
    setTopics(t || [])
    if (t?.length) setForm((f) => ({ ...f, topic_id: f.topic_id || t[0].id }))
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const save = async (e) => {
    e.preventDefault()
    if (!form.topic_id) return showToast('தலைப்பு தேர்வு செய்யவும்', 'error')
    const { error } = await supabase.from('pages').insert(form)
    if (error) return showToast('பிழை (ஏற்கனவே இருக்கலாம்): ' + error.message, 'error')
    showToast('பக்கம் சேர்க்கப்பட்டது ✓')
    load()
  }

  const remove = async (id) => {
    if (!confirm('இந்த பக்கத்தை நீக்கவா?')) return
    await supabase.from('pages').delete().eq('id', id)
    showToast('நீக்கப்பட்டது')
    load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Pages (பக்கங்கள்)</h2>

      <form onSubmit={save} className="card mb-6 space-y-3 max-w-lg">
        <h3 className="font-semibold">Add New Page</h3>
        <div>
          <label className="label">தலைப்பு (Topic) *</label>
          <select className="input" value={form.topic_id}
            onChange={(e) => setForm({ ...form, topic_id: e.target.value })}>
            <option value="">— தேர்வு செய்க —</option>
            {topics.map((t) => <option key={t.id} value={t.id}>{t.title}</option>)}
          </select>
        </div>
        <div>
          <label className="label">பக்க வகை (Page Type) *</label>
          <select className="input" value={form.page_type}
            onChange={(e) => setForm({ ...form, page_type: e.target.value })}>
            {PAGE_TYPES.map((pt) => <option key={pt} value={pt}>{pt}</option>)}
          </select>
        </div>
        <button type="submit" className="btn-primary">Add Page</button>
      </form>

      <div className="card overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-gray-100 text-left text-gray-500">
              <th className="py-2 pr-4">Topic</th>
              <th className="py-2 pr-4">Page Type</th>
              <th className="py-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-3 pr-4">{row.topics?.title}</td>
                <td className="py-3 pr-4 font-medium">{row.page_type}</td>
                <td className="py-3">
                  <button onClick={() => remove(row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
                </td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan={3} className="py-8 text-center text-gray-400">No pages yet</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
