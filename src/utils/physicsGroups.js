// The 7 "Main Sub Topics" that both the Interactive Physics lesson
// list and the Formulas page group content under. Keys match the
// `group_key` column on physics_ip_lessons and physics_formulas.
export const MAIN_SUB_TOPICS = [
  { key: 'introduction',    label: 'Introduction',                      label_ta: 'அறிமுகம்' },
  { key: 'newtons_laws',    label: "Newton's Laws",                     label_ta: 'நியூட்டனின் விதிகள்' },
  { key: 'application',     label: "Application of Newton's Laws",      label_ta: 'நியூட்டனின் விதிகளின் பயன்பாடு' },
  { key: 'lamis_theorem',   label: "Lami's Theorem",                    label_ta: 'லாமியின் தேற்றம்' },
  { key: 'momentum',        label: 'Law of Conservation of Linear Momentum', label_ta: 'நேர்கோட்டு உந்தத்தின் அழிவின்மை விதி' },
  { key: 'friction',        label: 'Friction',                          label_ta: 'உராய்வு' },
  { key: 'circular_motion', label: 'Dynamics of Circular Motion',       label_ta: 'வட்ட இயக்கவியல்' },
]

export function groupLabel(key, lang = 'en') {
  const g = MAIN_SUB_TOPICS.find((g) => g.key === key)
  if (!g) return key || 'Other'
  return lang === 'ta' ? g.label_ta : g.label
}

// Groups a flat list of rows (each with a `group_key` field) into the
// fixed MAIN_SUB_TOPICS order, dropping empty groups.
export function groupByMainSubTopic(rows, keyField = 'group_key') {
  return MAIN_SUB_TOPICS
    .map((g) => ({ ...g, items: rows.filter((r) => r[keyField] === g.key) }))
    .filter((g) => g.items.length > 0)
}
