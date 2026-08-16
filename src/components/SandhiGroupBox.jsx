import { useState } from 'react'
import useSequentialCombine from '../hooks/useSequentialCombine'
import DraggableCombineUnit from './DraggableCombineUnit'
import SandhiRulePopup from './SandhiRulePopup'

// Mnemonic pill colour, keyed by the exact tag string (matches the நன்னூல்
// புணர்ச்சி sutra chart categories). Falls back to blue for any tag that
// doesn't match one of these (e.g. a future addition to the chart).
// Keyed by ROOT-level label only — the box shows just the top-level
// classification (உ | உ, உ | மெ, மெ | உ, பூ | மெய்); the full root-to-leaf
// breadcrumb (இ ஈ ஐ | உயிர், கு சு து பு | உயிர், etc.) only appears once
// the student taps through to the rule popup.
const MNEMONIC_COLOR = {
  'உ | உ':      'bg-blue-100 text-blue-700',
  'உ | மெ':     'bg-purple-100 text-purple-700',
  'மெ | உ':     'bg-blue-100 text-blue-700',
  'பூ | மெய்':  'bg-pink-100 text-pink-700',
}

// Every leaf mnemonic_tag mapped to its ROOT classification, hard-coded
// here so the box-level pill works immediately from mnemonic_tag alone —
// it does NOT depend on the mnemonic_hierarchy column being populated
// (that column only matters for the full breadcrumb shown inside the rule
// popup). இ ஈ ஐ | உயிர், கு சு து பு | உயிர், etc. all collapse to
// "உ | உ" here; உ | மெ, மெ | உ, பூ | மெய் are their own roots.
const ROOT_OF_TAG = {
  'இ ஈ ஐ | உயிர்':                       'உ | உ',
  'அ, ஆ, ஊ, எ, ஒ, ஓ ஔ | உயிர்':          'உ | உ',
  'ஏ | உயிர்':                            'உ | உ',
  'உ | உயிர்':                            'உ | உ',
  'கு சு து பு | உயிர்':                  'உ | உ',
  'டு று | உயிர்':                        'உ | உ',
  'நெடில் தொடர்க் குற்றியலுகரம் | உயிர்':  'உ | உ',
  'உயிர்த்தொடர்க் குற்றியலுகரம் | உயிர்':  'உ | உ',
  'நெடில்/உயிர்த் தொடர் | உயிர்':          'உ | உ', // pre-split tag, just in case
  'மு | உயிர்':                           'உ | உ',
  'உ | மெ':                               'உ | மெ',
  'மெ | உ':                               'மெ | உ',
  'பூ | மெய்':                            'பூ | மெய்',
}
const DEFAULT_PILL_COLOR = 'bg-blue-100 text-blue-700'

/**
 * SandhiGroupBox — சொற்களின் புணர்ச்சி tab.
 *
 * Every morpheme in the group is always shown as its own separate tile
 * (unlike WordGroupBox/GrammarGroupBox, tiles never visually merge here).
 * Only the connector between two tiles changes state as the student
 * progresses:
 *
 *  - "Base Merge" (morpheme.is_sandhi_junction === false) — a subtle static
 *    "·" divider, not tappable, no rule shown. Used for connectors whose
 *    stored rule is just the generic placeholder ("இணைந்த சொல் வடிவம்") or
 *    an explicit not-yet-a-full-word verb-building step — i.e. not a real
 *    documented sandhi phenomenon.
 *
 *  - "Active Junction" (default, is_sandhi_junction !== false) — an
 *    interactive round button. Tapping/dragging it in order (left to
 *    right, ONE AT A TIME AMONG ACTIVE JUNCTIONS ONLY — base merges do not
 *    consume a step) reveals the rule, and once passed becomes a small
 *    amber badge (showing the changed_letter if any) that re-opens the
 *    rule popup on tap. A colour-coded mnemonic pill floats above any
 *    active/passed junction that has a mnemonic_tag.
 *
 * IMPORTANT indexing note: rulesForGroup is keyed by the RAW connector
 * index (0-based across ALL gaps between morphemes, exactly matching
 * sandhi_rules.connector_index in the database) — base merges included.
 * The sequential "one at a time" gating (useSequentialCombine), however,
 * only counts ACTIVE junctions, so a base merge never blocks or consumes
 * a step. This means the hook's combineStep lives in a different, smaller
 * index space than the raw connector index — activeConnectorIndices maps
 * between the two.
 */
export default function SandhiGroupBox({ group, morphemes, rulesForGroup }) {
  const units = morphemes.filter((m) => !m.is_separator)
  const connectorCount = Math.max(units.length - 1, 0)

  // Raw connector indices (0..connectorCount-1) that are real Active
  // Junctions — i.e. NOT explicitly flagged as a base merge on the
  // morpheme immediately before that gap.
  const activeConnectorIndices = []
  for (let i = 0; i < connectorCount; i++) {
    if (units[i]?.is_sandhi_junction !== false) activeConnectorIndices.push(i)
  }

  const { combineStep, advance, reset } = useSequentialCombine(activeConnectorIndices.length)
  const [openConnectorIndex, setOpenConnectorIndex] = useState(null)
  const [dragging, setDragging] = useState(false)

  // The raw connector index of the currently-active junction (the one the
  // student can tap/drag right now), if any are left.
  const currentActiveRawIndex = activeConnectorIndices[combineStep]

  const boxClasses = `
    flex flex-wrap items-end gap-0 px-2 py-1.5 mr-2 mb-2 rounded-xl border-2
    transition-colors ${dragging ? 'border-primary bg-primary/5' : 'border-orange-100 bg-orange-50/50'}
  `

  const unitClasses = `
    inline-flex items-center px-2 py-1 min-h-[44px] font-tamil text-base
    font-medium text-gray-900 select-none
  `

  return (
    <span className={boxClasses} onDoubleClick={reset}>
      {units.map((unit, i) => {
        const tile = <span className={unitClasses}>{unit.display_form}</span>
        const isBaseMerge = i < connectorCount && unit.is_sandhi_junction === false

        // Position of this raw connector within the active-only sequence
        // (used to compare against combineStep, which lives in that space).
        const activePos = activeConnectorIndices.indexOf(i)
        const isActiveJunction = i < connectorCount && !isBaseMerge
        const isPassed = isActiveJunction && activePos < combineStep
        const isActiveNow = isActiveJunction && activePos === combineStep
        const rule = isActiveJunction ? rulesForGroup?.[i] : null

        // Only the unit immediately after the CURRENT active junction may
        // be dragged in (matches the tap-to-advance target).
        const isDraggable = i === (currentActiveRawIndex ?? -2) + 1

        return (
          <span key={unit.id} className="inline-flex items-end">
            {isDraggable ? (
              <DraggableCombineUnit
                active
                onCombine={() => advance(combineStep)}
                onDragStateChange={setDragging}
              >
                {tile}
              </DraggableCombineUnit>
            ) : tile}

            {isBaseMerge && (
              <span className="text-gray-300 font-bold mx-1 mb-2 select-none" aria-hidden="true">
                ·
              </span>
            )}

            {isActiveJunction && (() => {
              // Root-level label only (உ | உ / உ | மெ / மெ | உ / பூ | மெய்).
              // Computed from the hard-coded ROOT_OF_TAG map keyed off
              // mnemonic_tag FIRST — this works immediately regardless of
              // whether mnemonic_hierarchy has been populated in the
              // database yet. mnemonic_hierarchy[0] is only used as a
              // secondary fallback (e.g. a future category not yet added
              // to ROOT_OF_TAG), and the leaf tag itself is the last resort.
              const rootLabel =
                ROOT_OF_TAG[rule?.mnemonic_tag]
                || rule?.mnemonic_hierarchy?.[0]
                || rule?.mnemonic_tag
              return (
              <div className="relative flex flex-col items-center justify-center mx-1">
                {(isActiveNow || isPassed) && rootLabel && (
                  <span
                    className={`absolute -top-6 text-[10px] font-bold px-2 py-0.5 rounded-full
                                shadow-sm whitespace-nowrap font-tamil
                                ${MNEMONIC_COLOR[rootLabel] || DEFAULT_PILL_COLOR}`}
                  >
                    {rootLabel}
                  </span>
                )}

                <button
                  type="button"
                  onClick={() => (isPassed ? setOpenConnectorIndex(i) : isActiveNow && advance(combineStep))}
                  disabled={!isPassed && !isActiveNow}
                  aria-label={isPassed ? 'புணர்ச்சி விதி காட்டு' : 'இணை'}
                  className={`mb-2 w-8 h-8 rounded-full flex items-center justify-center
                              text-sm font-bold transition-all duration-300
                    ${isPassed
                      ? 'bg-amber-100 text-amber-800 border-2 border-amber-300 hover:scale-105 cursor-pointer'
                      : isActiveNow
                      ? 'bg-primary text-white animate-pulse shadow-md cursor-pointer hover:bg-primary/90 active:scale-90'
                      : 'bg-gray-100 text-gray-300 cursor-not-allowed'}`}
                >
                  {isPassed
                    ? (rule?.changed_letter || <span className="w-1.5 h-1.5 bg-amber-600 rounded-full" />)
                    : '+'}
                </button>
              </div>
              )
            })()}
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
