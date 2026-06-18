import { useState } from 'react'
import MorphemeChip from './MorphemeChip'

/**
 * A single accordion poem line.
 * When expanded, shows morpheme chips in the selected tab mode.
 * mode: 'meaning' | 'grammar'
 */
export default function PoemLineAccordion({ line, verbAnalysisMap, mode }) {
  const [open, setOpen] = useState(false)

  // Sort morphemes by position
  const morphemes = [...(line.morphemes || [])].sort((a, b) => a.position - b.position)

  return (
    <div className="border border-cream-dark rounded-xl overflow-hidden mb-3">
      {/* Line trigger */}
      <button
        onClick={() => setOpen((v) => !v)}
        className="w-full text-left px-4 py-4 flex items-center gap-3
                   bg-white hover:bg-cream active:bg-cream-dark transition-colors min-h-[56px]"
      >
        <span className={`text-primary transition-transform duration-200 text-sm ${open ? 'rotate-90' : ''}`}>
          ▶
        </span>
        <span className="flex-1 text-lg font-medium text-gray-800">{line.raw_text}</span>
      </button>

      {/* Expanded morpheme panel */}
      {open && (
        <div className="bg-cream-dark/40 px-4 py-4 border-t border-cream-dark">
          {morphemes.length === 0 ? (
            <p className="text-gray-400 text-sm text-center py-2">
              சொல் பகுப்பு சேர்க்கப்படவில்லை
            </p>
          ) : (
            <div className="flex flex-wrap gap-2 items-end">
              {morphemes.map((m) => (
                <MorphemeChip
                  key={m.id}
                  morpheme={m}
                  verbAnalysis={m.is_verb ? verbAnalysisMap[m.id] : null}
                  mode={mode}
                />
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  )
}
