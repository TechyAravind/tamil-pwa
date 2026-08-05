import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const BLANK = { chapter_id: '', parent_id: '', title: '', order_index: 1 }

export default function AdminPhysicsSubtopics() {
  const [rows, setRows]         = useState([])
  const [chapters, setChapters] = useState([])
  const [form, setForm]         = useState(BLANK)
  const [editing, setEditing]   = useState(null)
  const [toast, setToast]       = useState(null)

  const load = async () => {
    const [{ data: s }, { data: c }] = await Promise.all([
      supabase.from('physics_subtopics').select('*, physics_chapters(title)').order('order_index'),
      supabase.from('physics_chapters').select('id, title').order('order_index'),
    ])
    setRows(s || [])
    setChapters(c || [])
    if (c?.length && !form.chapter_id) setForm((f) => ({ ...f, chapter_id: c[0].id }))
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  // Only top-level subtopics (no parent) of the currently chosen chapter
  // can be picked as a parent — keeps the outline to 2 levels deep.
  const parentOptions = rows.filter((r) => r.chapter_id === form.chapter_id && !r.parent_id)

  const save = async (e) => {
    e.preventDefault()
    if (!form.title.trim()) return showToast('Subtopic title is required', 'error')
    if (!form.chapter_id)   return showToast('Choose a chapter', 'error')

    const payload = {
      chapter_id: form.chapter_id,
      parent_id: form.parent_id || null,
      title: form.title,
      order_index: +form.order_index,
    }
    if (editing) {
      const { error } = await supabase.from('physics_subtopics').update(payload).eq('id', editing)
      if (error) return showToast('Error: ' + error.message, 'error')
      showToast('Updated ✓')
      setEditing(null)
    } else {
      const { error } = await supabase.from('physics_subtopics').insert(payload)
      if (error) return showToast('Error: ' + error.message, 'error')
      showToast('Added ✓')
    }
    setForm({ ...BLANK, chapter_id: form.chapter_id })
    load()
  }

  const remove = async (id) => {
    if (!confirm('Delete this subtopic? Its text/slides/videos and any children will be deleted too.')) return
    const { error } = await supabase.from('physics_subtopics').delete().eq('id', id)
    if (error) return showToast('Error: ' + error.message, 'error')
    showToast('Deleted')
    load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Physics — Subtopics (Theory outline)</h2>

      <form onSubmit={save} className="card mb-6 space-y-3 max-w-lg">
        <h3 className="font-semibold">{editing ? 'Edit Subtopic' : 'Add New Subtopic'}</h3>
        <div>
          <label className="label">Chapter *</label>
          <select className="input font-sans" value={form.chapter_id}
            onChange={(e) => setForm({ ...form, chapter_id: e.target.value, parent_id: '' })}>
            <option value="">— choose —</option>
            {chapters.map((c) => <option key={c.id} value={c.id}>{c.title}</option>)}
          </select>
        </div>
        <div>
          <label className="label">Parent subtopic (leave blank for a top-level item)</label>
          <select className="input font-sans" value={form.parent_id}
            onChange={(e) => setForm({ ...form, parent_id: e.target.value })}>
            <option value="">— top-level —</option>
            {parentOptions.map((p) => <option key={p.id} value={p.id}>{p.title}</option>)}
          </select>
        </div>
        <div>
          <label className="label">Title *</label>
          <input className="input font-sans" placeholder="e.g. Science – Introduction"
            value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} />
        </div>
        <div>
          <label className="label">Order</label>
          <input type="number" className="input font-sans" min={1} value={form.order_index}
            onChange={(e) => setForm({ ...form, order_index: +e.target.value })} />
        </div>
        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editing ? 'Update' : 'Add Subtopic'}</button>
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
              <th className="py-2 pr-4">Title</th>
              <th className="py-2 pr-4">Chapter</th>
              <th className="py-2 pr-4">Parent?</th>
              <th className="py-2 pr-4">Order</th>
              <th className="py-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-3 pr-4 font-medium">{row.parent_id ? '↳ ' : ''}{row.title}</td>
                <td className="py-3 pr-4 text-gray-500">{row.physics_chapters?.title}</td>
                <td className="py-3 pr-4 text-gray-500">{row.parent_id ? 'child' : 'top-level'}</td>
                <td className="py-3 pr-4 text-gray-500">{row.order_index}</td>
                <td className="py-3 flex gap-2">
                  <button onClick={() => { setEditing(row.id); setForm({ chapter_id: row.chapter_id, parent_id: row.parent_id || '', title: row.title, order_index: row.order_index }) }}
                    className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
                  <button onClick={() => remove(row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
                </td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan={5} className="py-8 text-center text-gray-400">No subtopics yet</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
