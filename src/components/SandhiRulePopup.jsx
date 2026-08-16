import { motion, AnimatePresence } from 'framer-motion'

/**
 * SandhiRulePopup — the "drop down tab" shown when the user taps an
 * Active-Junction connector in the சொற்களின் புணர்ச்சி tab. Rendered as a
 * bottom sheet so it works the same way on touch and desktop.
 *
 * rule.rule_steps is a jsonb array of { condition, rule, result } — each
 * step renders as its own card with a small stagger animation. condition
 * is the step's own full label as stored (e.g. "விதி 1", "விதி 2") — it is
 * rendered verbatim, NOT prefixed with an auto "படி N:" counter, because
 * for a நூற்பா-backed rule the label IS "விதி N" already. rule is the
 * authoritative நூற்பா (traditional grammar sutra) or, where no sutra
 * applies, a plain descriptive sentence. result is the word-level
 * transformation shown under it (e.g. "காலை + ய் + இல் → காலைய் + இல்").
 */
export default function SandhiRulePopup({ rule, onClose }) {
  const steps = Array.isArray(rule?.rule_steps)
    ? rule.rule_steps
    : (typeof rule?.rule_steps === 'string' ? JSON.parse(rule.rule_steps) : [])

  return (
    <>
      <div className="fixed inset-0 z-40 bg-black/20" onPointerDown={onClose} />

      <div
        className="fixed left-0 right-0 bottom-0 z-50 bg-white rounded-t-2xl shadow-2xl
                   border-t border-gray-100 p-5 max-w-2xl mx-auto animate-fade-in
                   max-h-[80vh] overflow-y-auto"
      >
        <div className="flex items-start justify-between mb-4 pb-3 border-b border-gray-100 gap-3">
          <div className="min-w-0">
            <p className="text-xs text-gold font-bold uppercase tracking-widest mb-1">
              புணர்ச்சி விதி
            </p>
            {(rule?.before_form || rule?.after_form) && (
              <h3 className="text-xl font-tamil font-bold text-primary flex items-center gap-2 flex-wrap">
                {rule.before_form}
                {rule.before_form && rule.after_form && <span className="text-gray-400">➔</span>}
                {rule.after_form}
              </h3>
            )}
          </div>

          <div className="flex flex-col items-end gap-1.5 shrink-0">
            <button
              onPointerDown={(e) => { e.stopPropagation(); onClose() }}
              className="w-7 h-7 flex items-center justify-center rounded-full bg-gray-100
                         hover:bg-gray-200 active:bg-gray-300 text-gray-500 hover:text-gray-800
                         text-sm font-bold transition-colors mb-1"
              aria-label="மூடு"
            >
              ✕
            </button>

            {/* Full root-to-leaf classification chain, stacked one below
                another (e.g. உ | உ → உ | உயிர் → கு | உயிர் → கு சு து பு |
                உயிர்) — falls back to the single leaf tag if the row
                predates the hierarchy field. */}
            {(Array.isArray(rule?.mnemonic_hierarchy) ? rule.mnemonic_hierarchy
              : rule?.mnemonic_tag ? [rule.mnemonic_tag] : []
            ).map((level, i) => (
              <span
                key={i}
                className="bg-blue-50 text-blue-700 px-3 py-1 rounded-full text-xs font-bold
                           shadow-sm font-tamil whitespace-nowrap"
              >
                {level}
              </span>
            ))}
          </div>
        </div>

        {!rule ? (
          <p className="font-tamil text-gray-400 text-sm py-2">
            இந்த இணைப்புக்கான விதி விரைவில் சேர்க்கப்படும்.
          </p>
        ) : (
          <div className="space-y-3">
            <AnimatePresence>
              {steps.map((step, idx) => (
                <motion.div
                  key={idx}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: idx * 0.15 }}
                  className="bg-white border border-gray-100 p-4 rounded-lg shadow-sm flex flex-col gap-2"
                >
                  {step.condition && (
                    <p className="text-xs text-gray-500 font-tamil font-semibold">
                      {step.condition}
                    </p>
                  )}
                  {step.rule && (
                    <p className="text-base font-tamil font-medium text-gray-800 border-l-4 border-blue-400 pl-3">
                      {step.rule}
                    </p>
                  )}
                  {step.result && (
                    <p className="text-md font-tamil text-emerald-700 bg-emerald-50 self-start px-2 py-1 rounded">
                      ➔ {step.result}
                    </p>
                  )}
                </motion.div>
              ))}
            </AnimatePresence>

            {steps.length === 0 && (
              <p className="font-tamil text-gray-400 text-sm py-2">
                இந்த இணைப்புக்கான விதிப்படிகள் இன்னும் சேர்க்கப்படவில்லை.
              </p>
            )}
          </div>
        )}

        {rule?.changed_letter && (
          <div className="mt-5 pt-4 border-t border-gray-100 flex items-center gap-3">
            <span className="text-sm text-gray-600 font-tamil">புதிதாகச் சேர்க்கப்பட்ட எழுத்து:</span>
            <span className="w-8 h-8 flex items-center justify-center bg-amber-100 text-amber-800
                              font-bold rounded-full border border-amber-300 font-tamil">
              {rule.changed_letter}
            </span>
          </div>
        )}

        <button
          onClick={onClose}
          className="mt-5 w-full py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium
                     font-tamil rounded-lg transition-colors"
        >
          மூடு
        </button>
      </div>
    </>
  )
}
