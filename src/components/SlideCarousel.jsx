import { useState } from 'react'

// Swipeable/paged carousel for the "Presentation" tab.
// If a slide has no image_url yet, renders a purple gradient
// placeholder card with the caption — no external image dependency.
export default function SlideCarousel({ slides }) {
  const [index, setIndex] = useState(0)
  if (!slides || slides.length === 0) return null

  const slide = slides[index]
  const go = (delta) => setIndex((i) => (i + delta + slides.length) % slides.length)

  return (
    <div className="w-full">
      {/* Slide frame — fixed aspect ratio so mixed image sizes stay consistent */}
      <div className="relative w-full rounded-2xl overflow-hidden shadow-md" style={{ aspectRatio: '4 / 3' }}>
        {slide.image_url ? (
          <img src={slide.image_url} alt={slide.caption || `Slide ${index + 1}`}
               className="absolute inset-0 w-full h-full object-contain bg-white" />
        ) : (
          <div className="absolute inset-0 w-full h-full bg-gradient-to-br from-[#4A235A] to-[#8E44AD]
                          flex items-center justify-center p-8 text-center">
            <p className="text-white text-lg md:text-xl font-semibold leading-snug">
              {slide.caption || `Slide ${index + 1}`}
            </p>
          </div>
        )}

        {/* Prev / next arrows */}
        {slides.length > 1 && (
          <>
            <button
              onClick={() => go(-1)}
              aria-label="Previous slide"
              className="absolute left-2 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full
                         bg-black/30 hover:bg-black/50 text-white flex items-center justify-center transition-colors"
            >
              ‹
            </button>
            <button
              onClick={() => go(1)}
              aria-label="Next slide"
              className="absolute right-2 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full
                         bg-black/30 hover:bg-black/50 text-white flex items-center justify-center transition-colors"
            >
              ›
            </button>
          </>
        )}
      </div>

      {/* Caption below image (only shown separately when an image exists —
          otherwise the caption is already inside the placeholder above) */}
      {slide.image_url && slide.caption && (
        <p className="text-gray-700 text-sm mt-3 text-center leading-relaxed">{slide.caption}</p>
      )}

      {/* Dot indicators */}
      {slides.length > 1 && (
        <div className="flex items-center justify-center gap-2 mt-4">
          {slides.map((_, i) => (
            <button
              key={i}
              onClick={() => setIndex(i)}
              aria-label={`Go to slide ${i + 1}`}
              className={`w-2.5 h-2.5 rounded-full transition-all
                          ${i === index ? 'bg-[#8E44AD] w-6' : 'bg-gray-300 hover:bg-gray-400'}`}
            />
          ))}
        </div>
      )}
    </div>
  )
}
