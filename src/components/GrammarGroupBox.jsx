import MorphemeChip from './MorphemeChip'
import useSequentialCombine from '../hooks/useSequentialCombine'

/**
 * GrammarGroupBox — the இலக்கணக்குறிப்பு tab's version of WordGroupBox.
 *
 * Same box + left-to-right tap-to-combine interaction as the சொல் பொருள்
 * tab, but chips show grammatical classification (பெ/வி/இ/உ) instead of
 * meanings, and the combined chip — if the whole word is itself a verb
 * form — shows the word's own பகுபத உறுப்பிலக்கணம் breakdown (looked up
 * by word_group_id, separate from the per-morpheme breakdowns).
 */
export default function GrammarGroupBox({ group, morphemes, verbAnalysisMap, groupVerbAnalysisMap }) {
  const units = morphemes.filter((m) => !m.is_separator)
  const connectorCount = Math.max(units.length - 1, 0)

  const { combineStep, fullyCombined, advance, reset, registerTapForDoubleTap } =
    useSequentialCombine(connectorCount)

  const boxClasses = `
    inline-flex items-end gap-0 px-2 py-1.5 mr-2 mb-2 rounded-xl border-2
    transition-colors
    ${fullyCombined ? 'border-primary/60 bg-primary/5' : 'border-gray-300 bg-white/60'}
  `

  if (fullyCombined) {
    const combinedMorpheme = {
      id: `${group.id}-combined-grammar`,
      display_form: group.combined_display_form,
      grammatical_label: group.combined_grammatical_label,
      is_verb: group.combined_is_verb,
      is_separator: false
    }

    return (
      <span className={boxClasses}>
        <span
          onClick={registerTapForDoubleTap}
          onDoubleClick={reset}
          title="இரு முறை அழுத்தி/சொடுக்கி பிரிக்கவும்"
        >
          <MorphemeChip
            morpheme={combinedMorpheme}
            mode="grammar"
            verbAnalysis={group.combined_is_verb ? groupVerbAnalysisMap[group.id] : null}
          />
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

  return (
    <span className={boxClasses}>
      {units.map((unit, i) => (
        <span key={unit.id} className="inline-flex items-end">
          <MorphemeChip
            morpheme={unit}
            verbAnalysis={unit.is_verb ? verbAnalysisMap[unit.id] : null}
            mode="grammar"
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
