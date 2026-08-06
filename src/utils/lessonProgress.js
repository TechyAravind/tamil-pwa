// Client-side-only "completed" tracking for Interactive Physics lessons.
// There's no student login system yet, so this is a soft, per-device
// convenience marker via localStorage -- not real account progress.
const KEY = 'physics_ip_completed'

export function markLessonComplete(lessonId) {
  try {
    const done = JSON.parse(localStorage.getItem(KEY) || '[]')
    if (!done.includes(lessonId)) {
      done.push(lessonId)
      localStorage.setItem(KEY, JSON.stringify(done))
    }
  } catch { /* localStorage unavailable — ignore */ }
}

export function isLessonComplete(lessonId) {
  try {
    const done = JSON.parse(localStorage.getItem(KEY) || '[]')
    return done.includes(lessonId)
  } catch { return false }
}
