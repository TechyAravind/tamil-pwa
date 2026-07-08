import { useState } from 'react'
import useSequentialCombine from '../hooks/useSequentialCombine'
import SandhiRulePopup from './SandhiRulePopup'

/**
 * SandhiGroupBox — the new இலக்கணம் tab's box: same left-to-right
 * tap-to-combine interaction as the other two tabs, but here the point
 * where two morphemes join stays visible and tappable *after* combining
 * too — pressing it opens the புணர்ச்சி விதி (combination rule) for that
 * junction. If a new letter was introduced by the combination, it is
 * shown highlighted right at the join.
 *
 * Unlike the meaning/grammar boxes, this one never collapses into a
 * single flat chip — every junction must stay reachable so its rule can
 * always be inspected, per the spec ("every combination must possess the
 * ability to showcase the correct principles of combination").
 */
export default function SandhiGroupBox({ group, morphemes, rulesForGroup }) {
  const units = morphemes.filter((m) => !m.is_separator)
  const connectorCount = Math.max(units.length - 1, 0)

  const { combineStep, advance, reset } = useSequentialCombine(connectorCount)
  const [openConnectorIndex, setOpenConnectorIndex] = useState(null)

  const boxClasses = `
    inline-flex items-end gap-0 px-2 py-1.5 mr-2 mb-2 rounded-xl border-2
    transition-colors border-gray-300 bg-white/60
  `

  const unitClasses = `
    inline-flex items-center px-2 py-1 min-h-[44px] font-tamil text-base
    font-medium text-gray-900 select-none
  `

  return (
    <span className={boxClasses} onDoubleClick={reset}>
      {units.map((unit, i) => {
        const rule = rulesForGroup?.[i]
        return (
          <span key={unit.id} className="inline-flex items-end">
            <span className={unitClasses}>{unit.display_form}</span>

            {i < connectorCount && i < combineStep && (
              // ── Already-merged junction: stays tappable forever ──────
              <button
                type="button"
                onClick={() => setOpenConnectorIndex(i)}
                aria-label="புணர்ச்சி விதி காட்டு"
                className="mx-0.5 mb-2 flex items-center gap-0.5 px-1.5 h-6 rounded-full
                           bg-amber-100 hover:bg-amber-200 active:scale-90 transition-all cursor-pointer"
              >
                {rule?.changed_letter ? (
                  <span className="font-tamil font-bold text-amber-700 text-sm">
                    {rule.changed_letter}
                  </span>
                ) : (
                  <span className="w-1.5 h-1.5 rounded-full bg-amber-500" />
                )}
              </button>
            )}

            {i < connectorCount && i === combineStep && (
              // ── Next connector in sequence: tap to combine ───────────
              <button
                type="button"
                onClick={() => advance(i)}
                aria-label="இணை"
                className="mx-0.5 mb-2 w-6 h-6 rounded-full text-sm font-bold transition-all
                           bg-primary text-white hover:bg-primary/90 active:scale-90
                           animate-pulse cursor-pointer"
              >
                +
              </button>
            )}

            {i < connectorCount && i > combineStep && (
              // ── Not reachable yet: combine left → right, in order ────
              <button
                type="button"
                disabled
                aria-label="இணை"
                className="mx-0.5 mb-2 w-6 h-6 rounded-full text-sm font-bold
                           bg-gray-100 text-gray-300 cursor-default"
              >
                +
              </button>
            )}
          </span>
        )
      })}

      {openConnectorIndex !== null && (
        <SandhiRulePopup
          rule={rulesForGroup?.[openConnectorIndex] || null}
          onClose={() => setOpenConnectorIndex(null)}
        />
      )}
    </span>
  )
}
