/**
 * SandhiRulePopup — the "drop down tab" shown when the user presses the
 * connecting point between two combined morphemes in the இலக்கணம்
 * (புணர்ச்சி) tab. Rendered as a bottom sheet so it works the same way
 * on touch and desktop, without needing to anchor to a tiny inline marker.
 */
export default function SandhiRulePopup({ rule, onClose }) {
  return (
    <>
      <div className="fixed inset-0 z-40 bg-black/20" onPointerDown={onClose} />

      <div
        className="fixed left-0 right-0 bottom-0 z-50 bg-white rounded-t-2xl shadow-2xl
                   border-t border-gray-100 p-5 max-w-2xl mx-auto animate-fade-in"
      >
        <div className="flex items-start justify-between mb-3">
          <p className="text-xs text-gold font-bold uppercase tracking-widest">
            புணர்ச்சி விதி
          </p>
          <button
            onPointerDown={(e) => { e.stopPropagation(); onClose() }}
            className="w-7 h-7 flex items-center justify-center rounded-full bg-gray-100
                       hover:bg-gray-200 active:bg-gray-300 text-gray-500 hover:text-gray-800
                       text-sm font-bold transition-colors -mt-1"
            aria-label="மூடு"
          >
            ✕
          </button>
        </div>

        {rule ? (
          <div className="space-y-3">
            {(rule.before_form || rule.after_form) && (
              <p className="font-tamil text-lg font-bold text-primary">
                {rule.before_form} {rule.before_form && rule.after_form ? '→' : ''} {rule.after_form}
              </p>
            )}

            <p className="font-tamil text-base text-gray-800 leading-relaxed">
              {rule.rule_text}
            </p>

            {rule.changed_letter && (
              <p className="font-tamil text-sm text-gray-500">
                புதிதாகச் சேர்க்கப்பட்ட எழுத்து:{' '}
                <span className="font-bold text-amber-600 bg-amber-50 px-2 py-0.5 rounded">
                  {rule.changed_letter}
                </span>
              </p>
            )}
          </div>
        ) : (
          <p className="font-tamil text-gray-400 text-sm py-2">
            இந்த இணைப்புக்கான விதி விரைவில் சேர்க்கப்படும்.
          </p>
        )}
      </div>
    </>
  )
}
