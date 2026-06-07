import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const BLANK = { name: '', order_index: 1 }

export default function AdminSections() {
  const [rows, setRows]     = useState([])
  const [form, setForm]     = useState(BLANK)
  const [editing, setEditing] = useState(null)   // id being edited
  const [toast, setToast]   = useState(null)

  const load = async () => {
    const { data } = await supabase.from('sections').select('*').order('order_index')
    setRows(data || [])
  }
  useEffect(() => { load() }, [])

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const save = async (e) => {
    e.preventDefault()
    if (!form.name.trim()) return showToast('பகுதி பெயர் தேவை', 'error')

    if (editing) {
      const { error } = await supabase.from('sections').update(form).eq('id', editing)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('திருத்தப்பட்டது ✓')
      setEditing(null)
    } else {
      const { error } = await supabase.from('sections').insert(form)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('சேர்க்கப்பட்டது ✓')
    }
    setForm(BLANK)
    load()
  }

  const remove = async (id) => {
    if (!confirm('இந்த பகுதியை நீக்கவா? அதில் உள்ள அனைத்தும் அழிக்கப்படும்.')) return
    const { error } = await supabase.from('sections').delete().eq('id', id)
    if (error) return showToast('பிழை: ' + error.message, 'error')
    showToast('நீக்கப்பட்டது')
    load()
  }

  const startEdit = (row) => {
    setEditing(row.id)
    setForm({ name: row.name, order_index: row.order_index })
  }

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Sections (பகுதிகள்)</h2>

      {/* Form */}
      <form onSubmit={save} className="card mb-6 space-y-3 max-w-lg">
        <h3 className="font-semibold">{editing ? 'Edit Section' : 'Add New Section'}</h3>
        <div>
          <label className="label">பகுதி பெயர் *</label>
          <input className="input" placeholder="e.g. செய்யுள்"
            value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
        </div>
        <div>
          <label className="label">வரிசை எண் (Order)</label>
          <input type="number" className="input" min={1}
            value={form.order_index}
            onChange={(e) => setForm({ ...form, order_index: +e.target.value })} />
        </div>
        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editing ? 'Update' : 'Add Section'}</button>
          {editing && (
            <button type="button" className="btn-ghost"
              onClick={() => { setEditing(null); setForm(BLANK) }}>Cancel</button>
          )}
        </div>
      </form>

      {/* Table */}
      <div className="card overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-gray-100 text-left text-gray-500">
              <th className="py-2 pr-4">பெயர்</th>
              <th className="py-2 pr-4">வரிசை</th>
              <th className="py-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-3 pr-4 font-medium">{row.name}</td>
                <td className="py-3 pr-4 text-gray-500">{row.order_index}</td>
                <td className="py-3 flex gap-2">
                  <button onClick={() => startEdit(row)}
                    className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">
                    Edit
                  </button>
                  <button onClick={() => remove(row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">
                    Delete
                  </button>
                </td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan={3} className="py-8 text-center text-gray-400">No sections yet</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
