import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const CONTENT_TABS = [
  { id: 'text',  label: 'Text' },
  { id: 'slides', label: 'Presentation Slides' },
  { id: 'videos', label: 'Videos' },
]

export default function AdminPhysicsContent() {
  const [subtopics, setSubtopics]     = useState([])
  const [subtopicId, setSubtopicId]   = useState('')
  const [activeTab, setActiveTab]     = useState('text')
  const [toast, setToast]             = useState(null)

  const [textRows, setTextRows]     = useState([])
  const [slideRows, setSlideRows]   = useState([])
  const [videoRows, setVideoRows]   = useState([])

  const [textForm, setTextForm]   = useState({ content_text: '', order_index: 1 })
  const [slideForm, setSlideForm] = useState({ image_url: '', caption: '', order_index: 1 })
  const [videoForm, setVideoForm] = useState({ video_url: '', caption: '', order_index: 1 })
  const [editingId, setEditingId] = useState(null)

  const showToast = (msg, type = 'success') => setToast({ msg, type })

  const loadSubtopics = async () => {
    const { data } = await supabase
      .from('physics_subtopics')
      .select('id, title, physics_chapters(title)')
      .order('order_index')
    setSubtopics(data || [])
    if (data?.length && !subtopicId) setSubtopicId(data[0].id)
  }
  useEffect(() => { loadSubtopics() }, [])

  const loadContent = async () => {
    if (!subtopicId) return
    const [{ data: t }, { data: sl }, { data: v }] = await Promise.all([
      supabase.from('physics_subtopic_text').select('*').eq('subtopic_id', subtopicId).order('order_index'),
      supabase.from('physics_slides').select('*').eq('subtopic_id', subtopicId).order('order_index'),
      supabase.from('physics_videos').select('*').eq('subtopic_id', subtopicId).order('order_index'),
    ])
    setTextRows(t || [])
    setSlideRows(sl || [])
    setVideoRows(v || [])
  }
  useEffect(() => { loadContent(); setEditingId(null) }, [subtopicId])

  // ── Generic save/delete per table ────────────────────────────────────────
  const saveRow = async (table, payload, resetForm) => {
    if (editingId) {
      const { error } = await supabase.from(table).update(payload).eq('id', editingId)
      if (error) return showToast('Error: ' + error.message, 'error')
      showToast('Updated ✓')
    } else {
      const { error } = await supabase.from(table).insert({ ...payload, subtopic_id: subtopicId })
      if (error) return showToast('Error: ' + error.message, 'error')
      showToast('Added ✓')
    }
    setEditingId(null)
    resetForm()
    loadContent()
  }

  const removeRow = async (table, id) => {
    if (!confirm('Delete this item?')) return
    const { error } = await supabase.from(table).delete().eq('id', id)
    if (error) return showToast('Error: ' + error.message, 'error')
    showToast('Deleted')
    loadContent()
  }

  const currentChapterLabel = (s) => s.physics_chapters?.title ? `${s.physics_chapters.title} — ${s.title}` : s.title

  return (
    <div>
      {toast && <Toast message={toast.msg} type={toast.type} onClose={() => setToast(null)} />}
      <h2 className="text-xl font-bold text-primary mb-5">Physics — Subtopic Content</h2>

      {/* Subtopic picker */}
      <div className="card mb-6 max-w-lg">
        <label className="label">Subtopic *</label>
        <select className="input font-sans" value={subtopicId} onChange={(e) => setSubtopicId(e.target.value)}>
          {subtopics.map((s) => <option key={s.id} value={s.id}>{currentChapterLabel(s)}</option>)}
        </select>
        {subtopics.length === 0 && (
          <p className="text-sm text-gray-400 mt-2">Add subtopics first from /admin/physics-subtopics.</p>
        )}
      </div>

      {/* Content-type tabs */}
      <div className="flex gap-2 mb-6">
        {CONTENT_TABS.map((tab) => (
          <button key={tab.id} onClick={() => { setActiveTab(tab.id); setEditingId(null) }}
            className={`px-4 py-2 rounded-lg text-sm font-semibold border transition-colors
                        ${activeTab === tab.id ? 'bg-primary text-white border-primary' : 'bg-white text-primary border-gray-200 hover:border-primary'}`}>
            {tab.label}
          </button>
        ))}
      </div>

      {/* ── TEXT ─────────────────────────────────────────────────────────── */}
      {activeTab === 'text' && (
        <>
          <form onSubmit={(e) => { e.preventDefault(); saveRow('physics_subtopic_text', { content_text: textForm.content_text, order_index: +textForm.order_index }, () => setTextForm({ content_text: '', order_index: textRows.length + 1 })) }}
            className="card mb-6 space-y-3 max-w-2xl">
            <h3 className="font-semibold">{editingId ? 'Edit Paragraph' : 'Add Paragraph'}</h3>
            <div>
              <label className="label">Paragraph text *</label>
              <textarea className="input font-sans" rows={5}
                value={textForm.content_text} onChange={(e) => setTextForm({ ...textForm, content_text: e.target.value })} />
            </div>
            <div>
              <label className="label">Order</label>
              <input type="number" className="input font-sans" min={1} value={textForm.order_index}
                onChange={(e) => setTextForm({ ...textForm, order_index: +e.target.value })} />
            </div>
            <div className="flex gap-2">
              <button type="submit" className="btn-primary">{editingId ? 'Update' : 'Add Paragraph'}</button>
              {editingId && <button type="button" className="btn-ghost" onClick={() => { setEditingId(null); setTextForm({ content_text: '', order_index: 1 }) }}>Cancel</button>}
            </div>
          </form>
          <div className="space-y-3 max-w-2xl">
            {textRows.map((row) => (
              <div key={row.id} className="card flex items-start justify-between gap-4">
                <p className="text-sm text-gray-700 flex-1 whitespace-pre-wrap">{row.content_text}</p>
                <div className="flex gap-2 shrink-0">
                  <button onClick={() => { setEditingId(row.id); setTextForm({ content_text: row.content_text, order_index: row.order_index }) }}
                    className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
                  <button onClick={() => removeRow('physics_subtopic_text', row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
                </div>
              </div>
            ))}
            {textRows.length === 0 && <p className="text-center text-gray-400 py-8">No paragraphs yet</p>}
          </div>
        </>
      )}

      {/* ── SLIDES ───────────────────────────────────────────────────────── */}
      {activeTab === 'slides' && (
        <>
          <form onSubmit={(e) => { e.preventDefault(); saveRow('physics_slides', { image_url: slideForm.image_url || null, caption: slideForm.caption, order_index: +slideForm.order_index }, () => setSlideForm({ image_url: '', caption: '', order_index: slideRows.length + 1 })) }}
            className="card mb-6 space-y-3 max-w-2xl">
            <h3 className="font-semibold">{editingId ? 'Edit Slide' : 'Add Slide'}</h3>
            <div>
              <label className="label">Image URL (leave blank to show a text-only placeholder slide)</label>
              <input className="input font-sans" placeholder="https://…"
                value={slideForm.image_url} onChange={(e) => setSlideForm({ ...slideForm, image_url: e.target.value })} />
            </div>
            <div>
              <label className="label">Caption</label>
              <textarea className="input font-sans" rows={2}
                value={slideForm.caption} onChange={(e) => setSlideForm({ ...slideForm, caption: e.target.value })} />
            </div>
            <div>
              <label className="label">Order</label>
              <input type="number" className="input font-sans" min={1} value={slideForm.order_index}
                onChange={(e) => setSlideForm({ ...slideForm, order_index: +e.target.value })} />
            </div>
            <div className="flex gap-2">
              <button type="submit" className="btn-primary">{editingId ? 'Update' : 'Add Slide'}</button>
              {editingId && <button type="button" className="btn-ghost" onClick={() => { setEditingId(null); setSlideForm({ image_url: '', caption: '', order_index: 1 }) }}>Cancel</button>}
            </div>
          </form>
          <div className="space-y-3 max-w-2xl">
            {slideRows.map((row) => (
              <div key={row.id} className="card flex items-start justify-between gap-4">
                <div className="flex-1">
                  {row.image_url && <p className="text-xs text-gray-400 truncate mb-1">{row.image_url}</p>}
                  <p className="text-sm text-gray-700 whitespace-pre-wrap">{row.caption}</p>
                </div>
                <div className="flex gap-2 shrink-0">
                  <button onClick={() => { setEditingId(row.id); setSlideForm({ image_url: row.image_url || '', caption: row.caption || '', order_index: row.order_index }) }}
                    className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
                  <button onClick={() => removeRow('physics_slides', row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
                </div>
              </div>
            ))}
            {slideRows.length === 0 && <p className="text-center text-gray-400 py-8">No slides yet</p>}
          </div>
        </>
      )}

      {/* ── VIDEOS ───────────────────────────────────────────────────────── */}
      {activeTab === 'videos' && (
        <>
          <form onSubmit={(e) => { e.preventDefault(); saveRow('physics_videos', { video_url: videoForm.video_url, caption: videoForm.caption, order_index: +videoForm.order_index }, () => setVideoForm({ video_url: '', caption: '', order_index: videoRows.length + 1 })) }}
            className="card mb-6 space-y-3 max-w-2xl">
            <h3 className="font-semibold">{editingId ? 'Edit Video' : 'Add Video'}</h3>
            <div>
              <label className="label">YouTube URL *</label>
              <input className="input font-sans" placeholder="https://www.youtube.com/watch?v=…"
                value={videoForm.video_url} onChange={(e) => setVideoForm({ ...videoForm, video_url: e.target.value })} />
            </div>
            <div>
              <label className="label">Caption</label>
              <textarea className="input font-sans" rows={2}
                value={videoForm.caption} onChange={(e) => setVideoForm({ ...videoForm, caption: e.target.value })} />
            </div>
            <div>
              <label className="label">Order</label>
              <input type="number" className="input font-sans" min={1} value={videoForm.order_index}
                onChange={(e) => setVideoForm({ ...videoForm, order_index: +e.target.value })} />
            </div>
            <div className="flex gap-2">
              <button type="submit" className="btn-primary">{editingId ? 'Update' : 'Add Video'}</button>
              {editingId && <button type="button" className="btn-ghost" onClick={() => { setEditingId(null); setVideoForm({ video_url: '', caption: '', order_index: 1 }) }}>Cancel</button>}
            </div>
          </form>
          <div className="space-y-3 max-w-2xl">
            {videoRows.map((row) => (
              <div key={row.id} className="card flex items-start justify-between gap-4">
                <div className="flex-1">
                  <p className="text-xs text-gray-400 truncate mb-1">{row.video_url}</p>
                  <p className="text-sm text-gray-700 whitespace-pre-wrap">{row.caption}</p>
                </div>
                <div className="flex gap-2 shrink-0">
                  <button onClick={() => { setEditingId(row.id); setVideoForm({ video_url: row.video_url, caption: row.caption || '', order_index: row.order_index }) }}
                    className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">Edit</button>
                  <button onClick={() => removeRow('physics_videos', row.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Delete</button>
                </div>
              </div>
            ))}
            {videoRows.length === 0 && <p className="text-center text-gray-400 py-8">No videos yet</p>}
          </div>
        </>
      )}
    </div>
  )
}
