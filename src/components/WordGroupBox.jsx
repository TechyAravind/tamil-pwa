import MorphemeChip from './MorphemeChip'
import useSequentialCombine from '../hooks/useSequentialCombine'

/**
 * WordGroupBox — one சீர்/word rendered as a bordered box container.
 *
 * Inside the box, the individual morphemes that make up this word are
 * shown side by side (exactly like today), each with its own tappable
 * meaning popup (unchanged MorphemeChip behaviour).
 *
 * A new interaction sits on top of that: the user can tap the "+"
 * connector between two morphemes, strictly left → right, to fuse them.
 * Only the next connector in sequence is active; later ones are dimmed
 * until their turn comes. Once every connector has been tapped, the box
 * collapses into a single chip showing the combined word — tapping /
 * hovering that chip shows the combined word's own meaning (which is
 * usually different from "meaning A + meaning B").
 *
 * Double-tap (touch) or double-click (mouse) on the combined chip — or
 * the small ↺ reset button next to it — splits the box back down to its
 * individual morphemes, exactly as it was before combining.
 */
export default function WordGroupBox({ group, morphemes, verbAnalysisMap }) {
  // Only the real (non-separator) morphemes count as "units" to combine.
  const units = morphemes.filter((m) => !m.is_separator)
  const connectorCount = Math.max(units.length - 1, 0)

  const { combineStep, fullyCombined, advance, reset, registerTapForDoubleTap } =
    useSequentialCombine(connectorCount)

  // Support both double-click (mouse) and double-tap (touch) on the combined chip.
  const handleCombinedActivate = registerTapForDoubleTap

  const boxClasses = `
    inline-flex items-end gap-0 px-2 py-1.5 mr-2 mb-2 rounded-xl border-2
    transition-colors
    ${fullyCombined ? 'border-primary/60 bg-primary/5' : 'border-gray-300 bg-white/60'}
  `

  // ── Fully combined: render as a single interactive chip ────────────────
  if (fullyCombined) {
    const combinedMorpheme = {
      id: `${group.id}-combined`,
      display_form: group.combined_display_form,
      word_meaning: group.combined_meaning,
      is_separator: false
    }

    return (
      <span className={boxClasses}>
        <span
          onClick={handleCombinedActivate}
          onDoubleClick={reset}
          title="இரு முறை அழுத்தி/சொடுக்கி பிரிக்கவும்"
        >
          <MorphemeChip morpheme={combinedMorpheme} mode="meaning" />
        </span>
        {connectorCount > 0 && (
          <button
            type="button"
            onClick={reset}
            aria-label="சொற்களைப் பிரி"
            className="ml-1 mb-2 w-6 h-6 flex items-center justify-center rounded-full
                       text-gray-400 hover:text-primary hover:bg-primary/10 transition-colors text-sm"
          >
            ↺
          </button>
        )}
      </span>
    )
  }

  // ── Still splitting: render each unit + connector buttons in order ─────
  return (
    <span className={boxClasses}>
      {units.map((unit, i) => (
        <span key={unit.id} className="inline-flex items-end">
          <MorphemeChip
            morpheme={unit}
            verbAnalysis={unit.is_verb ? verbAnalysisMap[unit.id] : null}
            mode="meaning"
          />
          {i < connectorCount && (
            <button
              type="button"
              disabled={i !== combineStep}
              onClick={() => advance(i)}
              aria-label="இணை"
              className={`mx-0.5 mb-2 w-6 h-6 rounded-full text-sm font-bold transition-all
                ${i === combineStep
                  ? 'bg-primary text-white hover:bg-primary/90 active:scale-90 animate-pulse cursor-pointer'
                  : 'bg-gray-100 text-gray-300 cursor-default'}
              `}
            >
              +
            </button>
          )}
        </span>
      ))}
    </span>
  )
}
