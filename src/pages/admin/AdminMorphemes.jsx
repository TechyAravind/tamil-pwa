import { useEffect, useState } from 'react'
import { supabase } from '../../supabase'
import Toast from '../../components/Toast'

const POS_OPTIONS = ['பெயர்ச்சொல்', 'வினைச்சொல்', 'இடைச்சொல்', 'உரிச்சொல்']
const BLANK = {
  poem_line_id: '', position: 1, display_form: '',
  word_meaning: '', grammatical_label: POS_OPTIONS[0],
  is_verb: false, is_separator: false
}

const GROUP_BLANK = {
  poem_line_id: '', position: 1, combined_display_form: '', combined_meaning: '',
  combined_grammatical_label: '', combined_is_verb: false
}

export default function AdminMorphemes() {
  const [rows, setRows]   = useState([])
  const [lines, setLines] = useState([])
  const [form, setForm]   = useState(BLANK)
  const [editing, setEditing] = useState(null)
  const [toast, setToast] = useState(null)

  // Word groups (சொல் தொகுப்பு box containers)
  const [groups, setGroups]           = useState([])
  const [groupLineId, setGroupLineId] = useState('')
  const [groupForm, setGroupForm]     = useState(GROUP_BLANK)
  const [editingGroup, setEditingGroup] = useState(null)

  const load = async () => {
    const [{ data: m }, { data: l }, { data: g }] = await Promise.all([
      supabase.from('morphemes')
        .select('*, poem_lines(raw_text, pages(topics(title)))')
        .order('position'),
      supabase.from('poem_lines').select('id, raw_text, line_number').order('line_number'),
      supabase.from('word_groups').select('*').order('position')
    ])
    setRows(m || [])
    setLines(l || [])
    setGroups(g || [])
    if (l?.length && !form.poem_line_id) setForm((f) => ({ ...f, poem_line_id: l[0].id }))
    if (l?.length && !groupLineId) setGroupLineId(l[0].id)
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

  // Word group CRUD
  const saveGroup = async (e) => {
    e.preventDefault()
    if (!groupForm.combined_display_form.trim()) return showToast('முழுச் சொல் தேவை', 'error')
    if (!groupForm.poem_line_id) return showToast('வரி தேர்வு செய்யவும்', 'error')

    const payload = {
      poem_line_id:               groupForm.poem_line_id,
      position:                   +groupForm.position,
      combined_display_form:      groupForm.combined_display_form,
      combined_meaning:           groupForm.combined_meaning || null,
      combined_grammatical_label: groupForm.combined_is_verb
        ? 'வினைச்சொல்'
        : (groupForm.combined_grammatical_label || null),
      combined_is_verb:           groupForm.combined_is_verb
    }

    if (editingGroup) {
      const { error } = await supabase.from('word_groups').update(payload).eq('id', editingGroup)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('தொகுப்பு திருத்தப்பட்டது ✓'); setEditingGroup(null)
    } else {
      const { error } = await supabase.from('word_groups').insert(payload)
      if (error) return showToast('பிழை: ' + error.message, 'error')
      showToast('தொகுப்பு சேர்க்கப்பட்டது ✓')
    }
    setGroupForm({ ...GROUP_BLANK, poem_line_id: groupForm.poem_line_id })
    load()
  }

  const removeGroup = async (id) => {
    if (!confirm('இந்தத் தொகுப்பை நீக்கவா? (உறுப்புகள் "பிரிக்கப்படாதவை" ஆகும்)')) return
    await supabase.from('word_groups').delete().eq('id', id)
    showToast('தொகுப்பு நீக்கப்பட்டது'); load()
  }

  const assignMorphemeGroup = async (morphemeId, wordGroupId) => {
    const { error } = await supabase.from('morphemes')
      .update({ word_group_id: wordGroupId || null })
      .eq('id', morphemeId)
    if (error) return showToast('பிழை: ' + error.message, 'error')
    load()
  }

  const groupsForLine    = groups.filter((g) => g.poem_line_id === groupLineId)
  const morphemesForLine = rows
    .filter((m) => m.poem_line_id === groupLineId)
    .sort((a, b) => a.position - b.position)

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

      {/* WORD GROUPS — box containers for சொல் பொருள் tab */}
      <h2 className="text-xl font-bold text-primary mt-10 mb-3">
        Word Groups (சொல் தொகுப்பு பெட்டிகள்)
      </h2>
      <p className="text-sm text-gray-500 mb-4 max-w-2xl">
        Each group = one boxed word made of the morphemes below it. Position numbers
        for groups and any leftover ungrouped morphemes share the same ordering —
        keep them consistent with the line's left-to-right word order.
      </p>

      <div className="mb-4 max-w-lg">
        <label className="label">வரி (Line)</label>
        <select className="input" value={groupLineId}
          onChange={(e) => { setGroupLineId(e.target.value); setGroupForm({ ...GROUP_BLANK, poem_line_id: e.target.value }) }}>
          {lines.map((l) => <option key={l.id} value={l.id}>#{l.line_number}: {l.raw_text}</option>)}
        </select>
      </div>

      <form onSubmit={saveGroup} className="card mb-6 space-y-3 max-w-lg">
        <h3 className="font-semibold">{editingGroup ? 'Edit Word Group' : 'Add Word Group'}</h3>
        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className="label">நிலை (Position) *</label>
            <input type="number" className="input" min={1} value={groupForm.position}
              onChange={(e) => setGroupForm({ ...groupForm, position: +e.target.value })} />
          </div>
          <div>
            <label className="label">முழுச் சொல் (Combined word) *</label>
            <input className="input font-tamil" placeholder="e.g. பல்லாண்டு"
              value={groupForm.combined_display_form}
              onChange={(e) => setGroupForm({ ...groupForm, combined_display_form: e.target.value })} />
          </div>
        </div>
        <div>
          <label className="label">முழுச் சொல் பொருள் (Combined meaning)</label>
          <input className="input font-tamil" placeholder="e.g. பல வருட காலம், Many years"
            value={groupForm.combined_meaning}
            onChange={(e) => setGroupForm({ ...groupForm, combined_meaning: e.target.value })} />
        </div>

        <div className="border-t border-gray-100 pt-3">
          <label className="flex items-center gap-2 cursor-pointer mb-2">
            <input type="checkbox" checked={groupForm.combined_is_verb}
              onChange={(e) => setGroupForm({ ...groupForm, combined_is_verb: e.target.checked,
                combined_grammatical_label: e.target.checked ? 'வினைச்சொல்' : groupForm.combined_grammatical_label })}
              className="w-4 h-4 accent-primary" />
            <span className="text-sm">முழுச் சொல் வினைச்சொல் — பகுபத உறுப்பிலக்கணம் காட்டு</span>
          </label>

          {!groupForm.combined_is_verb && (
            <div>
              <label className="label">முழுச் சொல் இலக்கண வகை (POS, optional)</label>
              <select className="input" value={groupForm.combined_grammatical_label}
                onChange={(e) => setGroupForm({ ...groupForm, combined_grammatical_label: e.target.value })}>
                <option value="">— இல்லை —</option>
                {POS_OPTIONS.map((p) => <option key={p} value={p}>{p}</option>)}
              </select>
            </div>
          )}
        </div>

        <div className="flex gap-2">
          <button type="submit" className="btn-primary">{editingGroup ? 'Update' : 'Add Group'}</button>
          {editingGroup && (
            <button type="button" className="btn-ghost"
              onClick={() => { setEditingGroup(null); setGroupForm({ ...GROUP_BLANK, poem_line_id: groupLineId }) }}>
              Cancel
            </button>
          )}
        </div>
      </form>

      <div className="card overflow-x-auto mb-6">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-gray-100 text-left text-gray-500">
              <th className="py-2 pr-3">Pos</th>
              <th className="py-2 pr-3">முழுச் சொல்</th>
              <th className="py-2 pr-3">பொருள்</th>
              <th className="py-2 pr-3">POS</th>
              <th className="py-2 pr-3">Verb?</th>
              <th className="py-2">Actions</th>
            </tr>
          </thead>
          <tbody>
            {groupsForLine.map((g) => (
              <tr key={g.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-2 pr-3 text-gray-500">{g.position}</td>
                <td className="py-2 pr-3 font-tamil font-bold">{g.combined_display_form}</td>
                <td className="py-2 pr-3 font-tamil text-gray-600 max-w-[240px] truncate">{g.combined_meaning}</td>
                <td className="py-2 pr-3 text-gray-500">{g.combined_grammatical_label || '—'}</td>
                <td className="py-2 pr-3">{g.combined_is_verb ? '✓' : ''}</td>
                <td className="py-2 flex gap-1">
                  <button onClick={() => {
                    setEditingGroup(g.id)
                    setGroupForm({
                      poem_line_id: g.poem_line_id, position: g.position,
                      combined_display_form: g.combined_display_form,
                      combined_meaning: g.combined_meaning || '',
                      combined_grammatical_label: g.combined_grammatical_label || '',
                      combined_is_verb: g.combined_is_verb || false
                    })
                  }} className="text-primary text-xs px-2 py-1 border border-primary rounded hover:bg-primary hover:text-white">
                    Edit
                  </button>
                  <button onClick={() => removeGroup(g.id)}
                    className="text-red-600 text-xs px-2 py-1 border border-red-300 rounded hover:bg-red-50">Del</button>
                </td>
              </tr>
            ))}
            {groupsForLine.length === 0 && (
              <tr><td colSpan={6} className="py-6 text-center text-gray-400">இந்த வரிக்கு தொகுப்புகள் இல்லை</td></tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Assign each morpheme of this line to a group */}
      <div className="card overflow-x-auto">
        <h3 className="font-semibold mb-3">Assign morphemes to a group</h3>
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-gray-100 text-left text-gray-500">
              <th className="py-2 pr-3">Pos</th>
              <th className="py-2 pr-3">உருவம்</th>
              <th className="py-2">Group</th>
            </tr>
          </thead>
          <tbody>
            {morphemesForLine.map((m) => (
              <tr key={m.id} className="border-b border-gray-50 hover:bg-cream/50">
                <td className="py-2 pr-3 text-gray-500">{m.position}</td>
                <td className="py-2 pr-3 font-tamil font-bold">{m.display_form}</td>
                <td className="py-2">
                  <select className="input" value={m.word_group_id || ''}
                    onChange={(e) => assignMorphemeGroup(m.id, e.target.value)}>
                    <option value="">— பிரிக்கப்பட்டது (ungrouped) —</option>
                    {groupsForLine.map((g) => (
                      <option key={g.id} value={g.id}>
                        #{g.position} {g.combined_display_form}
                      </option>
                    ))}
                  </select>
                </td>
              </tr>
            ))}
            {morphemesForLine.length === 0 && (
              <tr><td colSpan={3} className="py-6 text-center text-gray-400">இந்த வரிக்கு உறுப்புகள் இல்லை</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
