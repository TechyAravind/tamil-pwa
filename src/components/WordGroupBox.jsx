import { useState } from 'react'
import { motion } from 'framer-motion'
import MorphemeChip from './MorphemeChip'
import DraggableCombineUnit from './DraggableCombineUnit'
import useSequentialCombine from '../hooks/useSequentialCombine'

export default function WordGroupBox({ group, morphemes, verbAnalysisMap, rulesForGroup }) {
  const units = morphemes.filter((m) => !m.is_separator)
  const connectorCount = Math.max(units.length - 1, 0)

  const { combineStep, fullyCombined, advance, reset, registerTapForDoubleTap } =
    useSequentialCombine(connectorCount)

  const [dragging, setDragging] = useState(false)

  const handleCombinedActivate = registerTapForDoubleTap

  // A solo (never-splitable) word has connectorCount === 0, so it is
  // trivially "fullyCombined" from the very first render. That must NOT get
  // the primary-highlighted "just combined" look — only a word the user
  // actually merged through the connectors should. This keeps solo-word
  // boxes visually identical (neutral grey/cream box) to un-combined
  // splitable-word boxes, per the reference mockup.
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
      id: `${group.id}-combined`,
      display_form: group.combined_display_form,
      word_meaning: group.combined_meaning,
      is_separator: false
    }

    return (
      <motion.span layout transition={{ duration: 0.3 }} className={boxClasses}>
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
      </motion.span>
    )
  }

  // ── Staged merging ──────────────────────────────────────────────────────
  // Once the first `combineStep` connectors have been tapped (left to
  // right), fold those units into a single intermediate chip (using the
  // சந்தி rule's after_form when one exists for that connector, e.g.
  // வியர்த்தவர் + கு -> வியர்த்தவர்க்கு) before the next connector to
  // எல்லாம் can be tapped. This keeps multi-word combination happening one
  // junction at a time, showing the real intermediate word at each step
  // instead of jumping straight from raw morphemes to the fully combined
  // word.
  let displayUnits = units
  if (combineStep > 0) {
    const merged = { ...units[0] }
    for (let i = 0; i < combineStep; i++) {
      const rule = rulesForGroup?.[i]
      const nextUnit = units[i + 1]
      merged.display_form = rule?.after_form || `${merged.display_form}${nextUnit.display_form}`
      merged.word_meaning = rule?.rule_text || merged.word_meaning
      merged.is_verb = false
      merged.id = `${merged.id}+${nextUnit.id}`
    }
    displayUnits = [merged, ...units.slice(combineStep + 1)]
  }

  return (
    <motion.span layout transition={{ duration: 0.3 }} className={boxClasses}>
      {displayUnits.map((unit, di) => {
        const chip = (
          <MorphemeChip
            morpheme={unit}
            verbAnalysis={unit.is_verb ? verbAnalysisMap[unit.id] : null}
            mode="meaning"
          />
        )
        // Only the unit immediately after the merged span may be dragged
        // in next (there is exactly one "next" unit at any given step).
        const isDraggable = di === 1
        // Map the display slot back to its real connector index in the
        // original (unmerged) unit list: connectorIndexAfter(di) = combineStep + di
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
