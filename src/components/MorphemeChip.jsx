import { useRef, useState, useCallback } from 'react'
import MorphemePopup from './MorphemePopup'

// ── Part-of-speech config ─────────────────────────────────────────────────
const POS_CONFIG = {
  'பெயர்ச்சொல்': { short: 'பெ', color: 'text-pos-noun',     bg: 'bg-blue-50',   border: 'border-blue-200' },
  'வினைச்சொல்':  { short: 'வி', color: 'text-pos-verb',     bg: 'bg-green-50',  border: 'border-green-200' },
  'இடைச்சொல்':   { short: 'இ',  color: 'text-pos-particle', bg: 'bg-yellow-50', border: 'border-yellow-200' },
  'உரிச்சொல்':   { short: 'உ',  color: 'text-pos-uri',      bg: 'bg-purple-50', border: 'border-purple-200' }
}

// How long (ms) to wait after cursor leaves before hiding.
// This is the bridge time that lets the cursor travel from chip to popup
// without the popup blinking out.
const HIDE_DELAY = 120

/**
 * MorphemeChip — a single interactive morpheme token.
 *
 * mode = 'meaning' (சொல் பொருள் tab)  → shows word meaning popup on all chips
 * mode = 'grammar' (இலக்கணம் tab)     → shows POS label; verb chips show பகுபதம் popup
 *
 * ── Desktop behaviour ──
 *   mouseenter chip  → popup appears immediately
 *   mouseleave chip  → starts HIDE_DELAY timer
 *   mouseenter popup → cancels timer (popup stays)
 *   mouseleave popup → starts HIDE_DELAY timer again
 *   Both areas left  → popup disappears after HIDE_DELAY
 *
 * ── Touch behaviour ──
 *   tap chip once    → popup appears
 *   tap chip again   → popup disappears   (toggle)
 *   tap X button     → popup disappears
 *   tap overlay      → popup disappears
 */
export default function MorphemeChip({ morpheme, verbAnalysis, mode = 'meaning' }) {
  const [popupOpen, setPopupOpen] = useState(false)
  const chipRef    = useRef(null)
  const hideTimer  = useRef(null)

  // Detect pointer capability once at mount.
  // (hover: hover) = device has a mouse that can truly hover.
  // (pointer: fine) = precise pointing device (mouse, not finger).
  const isMouseDevice = window.matchMedia(
    '(hover: hover) and (pointer: fine)'
  ).matches

  // ── Separator chips ("+") are purely decorative ───────────────────────
  if (morpheme.is_separator) {
    return (
      <span className="inline-flex items-end pb-2 px-1 text-gray-400 font-bold text-sm
                       select-none cursor-default">
        +
      </span>
    )
  }

  // Is this chip interactive? (has content to show in a popup)
  const isInteractive =
    mode === 'meaning'
      ? !!morpheme.word_meaning
      : mode === 'grammar' && morpheme.is_verb

  const popupMode  = mode === 'meaning' ? 'meaning' : 'verb'
  const posConfig  = POS_CONFIG[morpheme.grammatical_label] || {}

  // ── Shared timer helpers (used by both chip and popup) ────────────────

  const scheduleHide = useCallback(() => {
    clearTimeout(hideTimer.current)
    hideTimer.current = setTimeout(() => setPopupOpen(false), HIDE_DELAY)
  }, [])

  const cancelHide = useCallback(() => {
    clearTimeout(hideTimer.current)
  }, [])

  const openPopup = useCallback(() => {
    cancelHide()
    setPopupOpen(true)
  }, [cancelHide])

  // ── Desktop handlers (mouse) ──────────────────────────────────────────

  const handleMouseEnter = () => {
    if (!isInteractive || !isMouseDevice) return
    openPopup()
  }

  const handleMouseLeave = () => {
    if (!isInteractive || !isMouseDevice) return
    scheduleHide()
  }

  // ── Touch handlers ────────────────────────────────────────────────────
  // We use onClick (fires after touchend) for toggle so it works on both
  // touch and keyboard. Guard with isMouseDevice to avoid double-firing.

  const handleClick = () => {
    if (!isInteractive || isMouseDevice) return
    setPopupOpen((v) => !v)
  }

  // Close popup immediately (X button, overlay tap)
  const closeNow = useCallback(() => {
    clearTimeout(hideTimer.current)
    setPopupOpen(false)
  }, [])

  // ── Chip appearance ───────────────────────────────────────────────────

  const chipBase = `
    inline-flex flex-col items-center px-2 py-1 rounded-md
    border transition-colors select-none font-tamil
    min-w-[2rem] min-h-[44px] justify-center
  `
  const chipInteractive = isInteractive
    ? 'cursor-pointer hover:border-primary hover:bg-primary/5 hover:shadow-sm active:scale-95'
    : 'cursor-default'

  const chipColor = mode === 'grammar' && morpheme.grammatical_label
    ? `${posConfig.bg || 'bg-cream'} ${posConfig.border || 'border-gray-200'}`
    : 'bg-cream border-gray-200'

  const verbRing = mode === 'grammar' && morpheme.is_verb
    ? 'ring-2 ring-green-400 ring-offset-1'
    : ''

  return (
    <span className="relative inline-block">
      {/* ── The chip ── */}
      <span
        ref={chipRef}
        onClick={handleClick}
        onMouseEnter={handleMouseEnter}
        onMouseLeave={handleMouseLeave}
        className={`${chipBase} ${chipInteractive} ${chipColor} ${verbRing}`}
        role={isInteractive ? 'button' : undefined}
        tabIndex={isInteractive ? 0 : undefined}
        aria-expanded={isInteractive ? popupOpen : undefined}
        onKeyDown={isInteractive
          ? (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); setPopupOpen((v) => !v) } }
          : undefined
        }
      >
        {/* POS label above morpheme text (grammar tab only) */}
        {mode === 'grammar' && morpheme.grammatical_label && (
          <span className={`text-xs font-bold leading-none mb-1 ${posConfig.color || 'text-gray-400'}`}>
            {posConfig.short}
          </span>
        )}

        {/* Morpheme text */}
        <span className="text-gray-900 font-medium text-base leading-none">
          {morpheme.display_form}
        </span>
      </span>

      {/* ── Popup ── */}
      {popupOpen && isInteractive && (
        <MorphemePopup
          morpheme={morpheme}
          verbAnalysis={verbAnalysis}
          mode={popupMode}
          onClose={closeNow}
          triggerRef={chipRef}
          onMouseEnter={cancelHide}   // cursor entered popup → cancel hide timer
          onMouseLeave={scheduleHide} // cursor left popup  → restart hide timer
          isMouseDevice={isMouseDevice}
        />
      )}
    </span>
  )
}