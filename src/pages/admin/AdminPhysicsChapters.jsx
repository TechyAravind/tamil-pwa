import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const BLANK = { group_id: '', title: '', order_index: 1 }

export default function AdminPhysicsChapters() {
  const [rows, setRows]       = useState([])
  const [groups, setGroups]   = useState([])
  const [form, setForm]       = useState(BLANK)
  const [editing, setEditing] = useState(null)
  const [toast, setToast]     = useState(null)

  const load = async () => {
    const [{ data: c }, { data: g }] = await Promise.all([
      supabase.from('physics_chapters').select('*, physics_groups(name)').order('order_index'),
      supabase.from('physics_groups').select('id, name').order('order_index'),
    ])
    setRows(c || [])
    setGroups(g || [])
    if (g?.length && !form.group_id) setForm((f) => ({ ...f, group_id: g[0].id }))
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const save = async (e) => {
    e.preventDefault()
    if (!form.title.trim()) return showToast('Chapter title is required', 'error')
    if (!form.group_id)     return showToast('Choose a group', 'error')

    const payload = { group_id: form.group_id, title: form.title, order_index: +form.order_index }
    if (editing) {
      const { error } = await supabase.from('physics_chapters').update(payload).eq('id', editing)
      if (error) return showToast('Error: ' + error.message, 'error')
      showToast('Updated ✓')
      setEditing(null)
    } else {
      const { error } = await supabase.from('physics_chapters').insert(payload)
      if (error) return showToast('Error: ' + error.message, 'error')
      showToast('Added ✓')
    }
    setForm({ ...BLANK, group_id: form.group_id })
    load()
  }

  const remove = async (id) => {
    if (!confirm('Delete this chapter? All its subtopics/content will be deleted too.')) return
    const { error } = await supabase.from('physics_chapters').delete().eq('id', id)
    if (error) return showToast('Error: ' + error.message, 'error')
    showToast('Deleted')
    load()
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Physics — Chapters (TOC)</h2>

      <form onSubmit={save} className="card mb-6 space-y-3 max-w-lg">
        <h3 className="font-semibold">{editing ? 'Edit Chapter' : 'Add New Chapter'}</h3>
        <div>
          <label className="label">Group *</label>
          <select className="input font-sans" value={form.group_id}
            onChange={(e) => setForm({ ...form, group_id: e.target.value })}>
            <option value="">— choose —</option>
            {groups.map((g) => <option key={g.id} value={g.id}>{g.name}</option>)}
          </select>
        </div>
        <div>
          <label className="label">Chapter title *</label>
          <input className="input font-sans" placeholder="e.g. Kinematics"
            value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} />
        </div>
        <div>
          <label className="label">Order</label>
          <input type="number" className="input font-sans" min={1} value={form.order_index}
            onChange={(e) => setForm({ ...form, order_index: +e.target.value })} />
        </div>
        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editing ? 'Update' : 'Add Chapter'}</button>
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
              <th className="py-2 pr-4">Group</th>
              <th className="py-2 pr-4">Order</th>
              <th className="py-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-3 pr-4 font-medium">{row.title}</td>
                <td className="py-3 pr-4 text-gray-500">{row.physics_groups?.name}</td>
                <td className="py-3 pr-4 text-gray-500">{row.order_index}</td>
                <td className="py-3 flex gap-2">
                  <button onClick={() => { setEditing(row.id); setForm({ group_id: row.group_id, title: row.title, order_index: row.order_index }) }}
                    className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
                  <button onClick={() => remove(row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
                </td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan={4} className="py-8 text-center text-gray-400">No chapters yet</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
