// Convert a YouTube watch / short URL into an embeddable iframe URL.
// Shared by StudyPage (Tamil) and the Physics Videos tab.
export function toEmbedUrl(url) {
  if (!url) return null
  if (url.includes('youtube.com/embed/')) return url
  const short = url.match(/youtu\.be\/([^?&]+)/)
  if (short) return `https://www.youtube.com/embed/${short[1]}`
  const watch = url.match(/[?&]v=([^&]+)/)
  if (watch) return `https://www.youtube.com/embed/${watch[1]}`
  return url
}
