import { useState } from 'react'
import { motion } from 'framer-motion'
import MorphemeChip from './MorphemeChip'
import DraggableCombineUnit from './DraggableCombineUnit'
import useSequentialCombine from '../hooks/useSequentialCombine'
import { buildDerivationSummary, buildClassCombination } from '../utils/grammarDerivation'

// small permanent corner dot on the container, colour-coded by the combined
// word's final part-of-speech — visible whether the box is expanded or
// combined, so the student always has an anchor for "what is this, ultimately".
const POS_DOT_COLOR = {
  'பெயர்ச்சொல்': 'bg-blue-400',
  'வினைச்சொல்':  'bg-green-400',
  'இடைச்சொல்':   'bg-yellow-400',
  'உரிச்சொல்':   'bg-purple-400'
}

// சொல் வகை tab — same box-in-box look and staged-combine interaction as
// the சொல் பொருள் tab (WordGroupBox). The only difference is what a tap on
// a chip shows: word classification (grammatical_label) instead of meaning,
// via mode="grammar" on MorphemeChip.
export default function GrammarGroupBox({ group, morphemes, verbAnalysisMap, groupVerbAnalysisMap, soloAnalysis, rulesForGroup }) {
  const units = morphemes.filter((m) => !m.is_separator)
  const connectorCount = Math.max(units.length - 1, 0)
  const dotColor = POS_DOT_COLOR[group.combined_grammatical_label]

  const { combineStep, fullyCombined, advance, reset, registerTapForDoubleTap } =
    useSequentialCombine(connectorCount)

  const [dragging, setDragging] = useState(false)

  const handleCombinedActivate = registerTapForDoubleTap

  // See WordGroupBox.jsx for rationale: a solo word (connectorCount === 0)
  // is trivially "fullyCombined" and must not get the primary-highlighted
  // "just combined" look — only keep that for words the user actually
  // merged through the connectors.
  const isActuallyCombined = fullyCombined && connectorCount > 0

  const boxClasses = `
    inline-flex items-end gap-0 px-2 py-1.5 mr-2 mb-2 rounded-xl border-2
    transition-colors
    ${isActuallyCombined ? 'border-primary/60 bg-primary/5'
      : dragging ? 'border-primary bg-primary/5'
      : 'border-gray-300 bg-white/60'}
  `

  if (fullyCombined) {
    const combinedMorpheme = {
      id: `${group.id}-combined-grammar`,
      display_form: group.combined_display_form,
      grammatical_label: group.combined_grammatical_label,
      is_verb: group.combined_is_verb,
      is_separator: false
    }
    const derivationSummary = connectorCount > 0
      ? buildDerivationSummary(units, rulesForGroup, group.combined_grammar_note || group.combined_grammatical_label)
      : null
    const classCombination = connectorCount > 0 ? buildClassCombination(units) : null

    return (
      <motion.span layout transition={{ duration: 0.3 }} className={`${boxClasses} relative`}>
        {dotColor && (
          <span
            className={`absolute -top-1.5 -right-1.5 w-3 h-3 rounded-full border-2 border-white ${dotColor}`}
            title={group.combined_grammatical_label}
            aria-hidden="true"
          />
        )}
        <span
          onClick={handleCombinedActivate}
          onDoubleClick={reset}
          title="இரு முறை அழுத்தி/சொடுக்கி பிரிக்கவும்"
        >
          <MorphemeChip
            morpheme={combinedMorpheme}
            mode="grammar"
            isGroupChip
            grammarNote={group.combined_grammar_note}
            classCombination={classCombination}
            derivationSummary={derivationSummary}
            verbAnalysis={group.combined_is_verb ? (soloAnalysis || groupVerbAnalysisMap?.[group.id]) : null}
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
      </motion.span>
    )
  }

  // ── Staged merging ──────────────────────────────────────────────────────
  // Same as WordGroupBox: fold the first `combineStep` connectors into one
  // intermediate chip before the next connector can be tapped. An
  // in-progress merged word is not a real morpheme, so it deliberately gets
  // NO grammatical_label / is_verb — it is not tappable (nothing to show).
  let displayUnits = units
  if (combineStep > 0) {
    const merged = { ...units[0] }
    for (let i = 0; i < combineStep; i++) {
      const rule = rulesForGroup?.[i]
      const nextUnit = units[i + 1]
      merged.display_form = rule?.after_form || `${merged.display_form}${nextUnit.display_form}`
      merged.grammatical_label = null
      merged.structural_role = null
      merged.role_category = null
      merged.is_verb = false
      merged.id = `${merged.id}+${nextUnit.id}`
    }
    displayUnits = [merged, ...units.slice(combineStep + 1)]
  }

  return (
    <motion.span layout transition={{ duration: 0.3 }} className={`${boxClasses} relative`}>
      {dotColor && (
        <span
          className={`absolute -top-1.5 -right-1.5 w-3 h-3 rounded-full border-2 border-white ${dotColor}`}
          title={group.combined_grammatical_label}
          aria-hidden="true"
        />
      )}
      {displayUnits.map((unit, di) => {
        const chip = (
          <MorphemeChip
            morpheme={unit}
            verbAnalysis={unit.is_verb ? verbAnalysisMap[unit.id] : null}
            mode="grammar"
            isGroupChip={false}
          />
        )
        const isDraggable = di === 1
        const connectorIndex = combineStep + di
        const hasConnector = connectorIndex < connectorCount

        return (
          <span key={unit.id} className="inline-flex items-end">
            {isDraggable ? (
              <DraggableCombineUnit
                active
                onCombine={() => advance(combineStep)}
                onDragStateChange={setDragging}
              >
                {chip}
              </DraggableCombineUnit>
            ) : chip}

            {hasConnector && (
              <button
                type="button"
                disabled={connectorIndex !== combineStep}
                onClick={() => advance(connectorIndex)}
                aria-label="இணை"
                className={`mx-0.5 mb-2 w-6 h-6 rounded-full text-sm font-bold transition-all
                  ${connectorIndex === combineStep
                    ? 'bg-primary text-white hover:bg-primary/90 active:scale-90 animate-pulse cursor-pointer'
                    : 'bg-gray-100 text-gray-300 cursor-default'}
                `}
              >
                +
              </button>
            )}
          </span>
        )
      })}
    </motion.span>
  )
}
