import { useRef, useState, useCallback } from 'react'
import MorphemePopup from './MorphemePopup'

// How long (ms) to wait after cursor leaves before hiding.
// This is the bridge time that lets the cursor travel from chip to popup
// without the popup blinking out.
const HIDE_DELAY = 120

/**
 * MorphemeChip — a single interactive morpheme token.
 *
 * mode = 'meaning' (சொல் பொருள் tab) → tap shows word meaning popup
 * mode = 'grammar' (சொல் வகை tab)    → tap shows word-classification popup;
 *                                       verb chips get a button inside that
 *                                       popup to drill into the பகுபத
 *                                       உறுப்பிலக்கணம் breakdown
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
  // சொல் வகை tab: tapping a chip opens its word-classification first;
  // verb chips get a button inside that popup to drill into the detailed
  // பகுபத உறுப்பிலக்கணம் breakdown as a second step.
  const [popupView, setPopupView] = useState('classification')
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
  // Grammar-mode chips are interactive whenever a word classification or a
  // verb breakdown exists. An in-progress merged unit (mid-combine) has
  // neither, so it is deliberately not tappable.
  const isInteractive =
    mode === 'meaning'
      ? !!morpheme.word_meaning
      : mode === 'grammar' && !!(morpheme.grammatical_label || morpheme.is_verb)

  const popupMode  = mode === 'meaning' ? 'meaning' : popupView

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

  // Close popup immediately (X button, overlay tap) — also resets the
  // classification/verb sub-view so it re-opens fresh next time.
  const closeNow = useCallback(() => {
    clearTimeout(hideTimer.current)
    setPopupOpen(false)
    setPopupView('classification')
  }, [])

  // ── Chip appearance ───────────────────────────────────────────────────
  // Same neutral look in every mode — சொல் பொருள் and சொல் வகை boxes must
  // be visually identical (no POS colour-coding / green verb ring), the
  // classification now lives inside the tap popup instead.

  const chipBase = `
    inline-flex flex-col items-center px-2 py-1 rounded-md
    border transition-colors select-none font-tamil
    min-w-[2rem] min-h-[44px] justify-center
  `
  const chipInteractive = isInteractive
    ? 'cursor-pointer hover:border-primary hover:bg-primary/5 hover:shadow-sm active:scale-95'
    : 'cursor-default'

  const chipColor = 'bg-cream border-gray-200'

  return (
    <span className="relative inline-block">
      {/* ── The chip ── */}
      <span
        ref={chipRef}
        onClick={handleClick}
        onMouseEnter={handleMouseEnter}
        onMouseLeave={handleMouseLeave}
        className={`${chipBase} ${chipInteractive} ${chipColor}`}
        role={isInteractive ? 'button' : undefined}
        tabIndex={isInteractive ? 0 : undefined}
        aria-expanded={isInteractive ? popupOpen : undefined}
        onKeyDown={isInteractive
          ? (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); setPopupOpen((v) => !v) } }
          : undefined
        }
      >
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
          onShowVerbAnalysis={() => setPopupView('verb')}
          onBackToClassification={() => setPopupView('classification')}
        />
      )}
    </span>
  )
}