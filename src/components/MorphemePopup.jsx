import { useEffect, useRef } from 'react'

/**
 * MorphemePopup — smart positioned popup.
 *
 * Desktop (mouse device):
 *   - Stays visible while cursor is over chip OR popup.
 *   - onMouseEnter / onMouseLeave props cancel/restart the shared hide timer.
 *   - No overlay shown — moving mouse away naturally hides it.
 *
 * Touch (mobile/tablet):
 *   - Tap chip once → popup appears.
 *   - Tap chip again OR tap X → popup closes.
 *   - Semi-transparent overlay covers screen; tapping outside also closes.
 */
export default function MorphemePopup({
  morpheme,
  verbAnalysis,
  mode,
  onClose,
  triggerRef,
  onMouseEnter,   // called when cursor enters popup (cancels hide timer)
  onMouseLeave,   // called when cursor leaves popup (restarts hide timer)
  isMouseDevice,  // true = desktop hover mode, false = touch tap mode
  onShowVerbAnalysis,      // சொல் வகை tab: switch this popup to the verb breakdown
  onBackToClassification,  // verb breakdown: switch back to classification
}) {
  const popupRef = useRef(null)

  // ── Smart positioning ──────────────────────────────────────────────────
  useEffect(() => {
    const popup   = popupRef.current
    const trigger = triggerRef?.current
    if (!popup || !trigger) return

    const trigRect = trigger.getBoundingClientRect()
    const popupW   = 288   // w-72 = 18rem = 288px
    const gap      = 10    // px gap between chip bottom and popup top
    const vh       = window.innerHeight
    const vw       = window.innerWidth

    // Vertical: open downward unless < 200px remains below
    if (vh - trigRect.bottom > 200) {
      popup.style.top    = `${trigRect.bottom + gap}px`
      popup.style.bottom = 'auto'
    } else {
      popup.style.top    = 'auto'
      popup.style.bottom = `${vh - trigRect.top + gap}px`
    }

    // Horizontal: centre on chip, clamped inside viewport with 8px margin
    const idealLeft = trigRect.left + trigRect.width / 2 - popupW / 2
    popup.style.left = `${Math.max(8, Math.min(idealLeft, vw - popupW - 8))}px`
  }, [triggerRef])

  return (
    <>
      {/*
        Touch-only overlay: tapping outside popup closes it.
        Not rendered on desktop — mouse movement handles closing there.
      */}
      {!isMouseDevice && (
        <div
          className="fixed inset-0 z-40 bg-black/10"
          onPointerDown={onClose}
        />
      )}

      {/* ── Popup card ── */}
      <div
        ref={popupRef}
        onMouseEnter={onMouseEnter}
        onMouseLeave={onMouseLeave}
        className="fixed z-50 bg-white rounded-2xl shadow-2xl border border-gray-100
                   p-5 w-72 max-w-[90vw] animate-fade-in"
        style={{ position: 'fixed' }}
      >
        {/* ── Close button — always visible, main dismiss on touch ── */}
        <button
          onPointerDown={(e) => { e.stopPropagation(); onClose() }}
          className="absolute top-3 right-3 w-7 h-7 flex items-center justify-center
                     rounded-full bg-gray-100 hover:bg-gray-200 active:bg-gray-300
                     text-gray-500 hover:text-gray-800 text-sm font-bold transition-colors"
          aria-label="மூடு"
        >
          ✕
        </button>

        {/* ── Morpheme heading ── */}
        <p className="font-bold text-primary text-xl mb-3 pr-8 font-tamil">
          {morpheme.display_form}
        </p>

        {/* ── சொல் பொருள் tab mode ── */}
        {mode === 'meaning' && (
          <div>
            <p className="text-xs text-gold font-bold uppercase tracking-widest mb-2">
              பொருள்
            </p>
            <p className="text-gray-800 leading-relaxed font-tamil text-base">
              {morpheme.word_meaning || 'பொருள் சேர்க்கப்படவில்லை'}
            </p>
          </div>
        )}

        {/* ── சொல் வகை tab mode — word classification ── */}
        {mode === 'classification' && (
          <div>
            <p className="text-xs text-gold font-bold uppercase tracking-widest mb-2">
              சொல் வகை
            </p>
            <p className="text-gray-800 leading-relaxed font-tamil text-base">
              {morpheme.grammatical_label || 'சொல் வகை சேர்க்கப்படவில்லை'}
            </p>

            {morpheme.is_verb && verbAnalysis && (
              <button
                type="button"
                onClick={onShowVerbAnalysis}
                className="mt-4 text-sm text-primary font-semibold hover:underline
                           underline-offset-2 font-tamil"
              >
                பகுபத உறுப்பிலக்கணம் காண →
              </button>
            )}
          </div>
        )}

        {/* ── சொல் வகை tab mode — பகுபத உறுப்பிலக்கணம் (verb drill-down) ── */}
        {mode === 'verb' && verbAnalysis && (
          <div>
            {onBackToClassification && (
              <button
                type="button"
                onClick={onBackToClassification}
                className="text-xs text-gray-400 hover:text-primary mb-3 font-tamil"
              >
                ← சொல் வகை
              </button>
            )}
            <p className="text-xs text-gold font-bold uppercase tracking-widest mb-2">
              பகுபத உறுப்பிலக்கணம்
            </p>

            {/* Combined: தோய் + த் + த் + உ */}
            <p className="text-primary font-bold text-base mb-4 font-tamil tracking-wide">
              {verbAnalysis.analysis.map((a) => a.part).join(' + ')}
            </p>

            {/* Row-by-row breakdown */}
            <div className="space-y-2">
              {verbAnalysis.analysis.map((row, i) => (
                <div key={i} className="flex items-center gap-3">
                  <span className="bg-primary text-white font-bold rounded-lg px-3 py-1
                                   text-sm min-w-[3rem] text-center font-tamil shrink-0">
                    {row.part}
                  </span>
                  <span className="text-gray-600 text-sm leading-snug font-tamil">
                    {row.label}
                  </span>
                </div>
              ))}
            </div>
          </div>
        )}

        {mode === 'verb' && !verbAnalysis && (
          <p className="text-gray-400 text-sm font-tamil">
            பகுபத உறுப்பிலக்கணம் சேர்க்கப்படவில்லை
          </p>
        )}
      </div>
    </>
  )
}