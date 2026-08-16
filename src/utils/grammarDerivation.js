// Short forms used in the class-combination formula (பெயர் + இடை, உரி + பெயர்)
export const POS_SHORT = {
  'பெயர்ச்சொல்': 'பெயர்',
  'வினைச்சொல்':  'வினை',
  'இடைச்சொல்':   'இடை',
  'உரிச்சொல்':   'உரி'
}

/**
 * buildDerivationSummary — auto-assembles the "கட (பகுதி) + ந் (சந்தி மெய்)
 * + த் (இறந்தகால இடைநிலை) + உ (வினையெச்ச விகுதி) = வினையெச்சம்" formula
 * shown in the combined-word சொல்வகை popup, from data already stored on
 * the morphemes (structural_role / role_category, falling back to a short
 * word-class tag when a piece is itself a real word) and sandhi_rules —
 * nothing is hand-typed per word, so it can never drift out of sync.
 *
 * @param {Array} units          ordered non-separator morphemes of the group
 * @param {Object} rulesForGroup { [connectorIndex]: sandhiRuleRow } or undefined
 * @param {string} finalLabel    combined_grammar_note || combined_grammatical_label
 * @returns {string|null}        null when there's nothing to show (solo word,
 *                                or no role/class data yet for any piece)
 */
export function buildDerivationSummary(units, rulesForGroup, finalLabel) {
  if (!units || units.length < 2) return null

  const roleOf = (u) => u.structural_role || u.role_category || (u.grammatical_label ? POS_SHORT[u.grammatical_label] || u.grammatical_label : null)
  const hasAnyRole = units.some(roleOf)
  if (!hasAnyRole) return null

  const parts = units.map((u, i) => {
    const role = roleOf(u)
    let label = u.display_form
    // A changed_letter on the connector BEFORE this unit (i-1) means this
    // piece is a mutated/sandhi form of something else — note that inline,
    // e.g. "ந் (சந்தி மெய் — த் இன் திரிபு)".
    const incomingRule = i > 0 ? rulesForGroup?.[i - 1] : null
    const sandhiNote = incomingRule?.changed_letter ? ' — சந்தி' : ''
    return role ? `${label} (${role}${sandhiNote})` : label
  })

  const formula = parts.join(' + ')
  return finalLabel ? `${formula} = ${finalLabel}` : formula
}

/**
 * buildClassCombination — "பெயர் + இடை" (காலையில்) / "உரி + பெயர்"
 * (கடிநகர்) — only shown when EVERY piece in the group is itself a real
 * word with its own பெ/வி/இ/உ class (a word-compound / case-construction),
 * as opposed to a verb's internal பகுதி+இடைநிலை+விகுதி morphology.
 *
 * @param {Array} units  ordered non-separator morphemes of the group
 * @returns {string|null}
 */
export function buildClassCombination(units) {
  if (!units || units.length < 2) return null
  const labels = units.map((u) => u.grammatical_label)
  if (labels.some((l) => !l)) return null
  return labels.map((l) => POS_SHORT[l] || l).join(' + ')
}
