import { toEmbedUrl } from '../../utils/embedUrl'

// Renders a step's optional Manim companion video (a YouTube link stored
// in physics_ip_steps.video_url). Reuses the same URL->embed converter
// already used for the Theory tab's video lists.
export default function VideoEmbed({ url }) {
  if (!url) return null
  const embedUrl = toEmbedUrl(url)
  if (!embedUrl) return null

  return (
    <div className="my-4 rounded-xl overflow-hidden border border-gray-200 aspect-video">
      <iframe
        src={embedUrl}
        title="Visual companion video"
        className="w-full h-full"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        allowFullScreen
      />
    </div>
  )
}
