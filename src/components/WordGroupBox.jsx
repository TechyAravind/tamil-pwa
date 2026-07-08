import { useState } from 'react'
import MorphemeChip from './MorphemeChip'
import DraggableCombineUnit from './DraggableCombineUnit'
import useSequentialCombine from '../hooks/useSequentialCombine'

export default function WordGroupBox({ group, morphemes, verbAnalysisMap }) {
  const units = morphemes.filter((m) => !m.is_separator)
  const connectorCount = Math.max(units.length - 1, 0)

  const { combineStep, fullyCombined, advance, reset, registerTapForDoubleTap } =
    useSequentialCombine(connectorCount)

  const [dragging, setDragging] = useState(false)

  const handleCombinedActivate = registerTapForDoubleTap

  const boxClasses = `
    inline-flex items-end gap-0 px-2 py-1.5 mr-2 mb-2 rounded-xl border-2
    transition-colors
    ${fullyCombined ? 'border-primary/60 bg-primary/5'
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

  return (
    <span className={boxClasses}>
      {units.map((unit, i) => {
        const chip = (
          <MorphemeChip
            morpheme={unit}
            verbAnalysis={unit.is_verb ? verbAnalysisMap[unit.id] : null}
            mode="meaning"
          />
        )
        const isDraggable = i === combineStep + 1

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
        )
      })}
    </span>
  )
}
