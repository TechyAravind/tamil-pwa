import { useState } from 'react'
import MorphemeChip from './MorphemeChip'
import WordGroupBox from './WordGroupBox'
import GrammarGroupBox from './GrammarGroupBox'
import SandhiGroupBox from './SandhiGroupBox'

/**
 * A single accordion poem line.
 * When expanded, shows morpheme chips in the selected tab mode.
 *
 * mode: 'meaning'  -> சொல் பொருள்      (WordGroupBox,    falls back to flat chips)
 *       'grammar'  -> இலக்கணக்குறிப்பு (GrammarGroupBox, falls back to flat chips)
 *       'sandhi'   -> இலக்கணம்         (SandhiGroupBox,  needs word_groups; no fallback)
 */
export default function PoemLineAccordion({
  line, verbAnalysisMap, groupVerbAnalysisMap, sandhiRulesMap, mode
}) {
  const [open, setOpen] = useState(false)

  // Sort morphemes by position
  const morphemes = [...(line.morphemes || [])].sort((a, b) => a.position - b.position)

  // Word groups - box containers that club the morphemes belonging to one
  // சீர்/word together, with combine-to-view interactivity. Lines with no
  // groups yet fall back to the legacy flat chip layout (meaning/grammar
  // modes only), so existing content keeps working unchanged.
  const groups = [...(line.word_groups || [])].sort((a, b) => a.position - b.position)
  const useGroupedLayout = (mode === 'meaning' || mode === 'grammar' || mode === 'sandhi') && groups.length > 0

  const morphemesByGroup = {}
  if (useGroupedLayout) {
    for (const m of morphemes) {
      if (!m.word_group_id) continue
      ;(morphemesByGroup[m.word_group_id] ||= []).push(m)
    }
  }
  const ungroupedMorphemes = useGroupedLayout
    ? morphemes.filter((m) => !m.word_group_id)
    : morphemes

  const renderGroup = (group) => {
    const groupMorphemes = morphemesByGroup[group.id] || []
    if (mode === 'meaning') {
      return (
        <WordGroupBox
          key={group.id}
          group={group}
          morphemes={groupMorphemes}
          verbAnalysisMap={verbAnalysisMap}
        />
      )
    }
    if (mode === 'grammar') {
      return (
        <GrammarGroupBox
          key={group.id}
          group={group}
          morphemes={groupMorphemes}
          verbAnalysisMap={verbAnalysisMap}
          groupVerbAnalysisMap={groupVerbAnalysisMap || {}}
        />
      )
    }
    return (
      <SandhiGroupBox
        key={group.id}
        group={group}
        morphemes={groupMorphemes}
        rulesForGroup={sandhiRulesMap?.[group.id]}
      />
    )
  }

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
          {mode === 'sandhi' && groups.length === 0 ? (
            <p className="text-gray-400 text-sm text-center py-2 font-tamil">
              இந்த வரிக்கு புணர்ச்சி தரவு இன்னும் சேர்க்கப்படவில்லை
            </p>
          ) : morphemes.length === 0 ? (
            <p className="text-gray-400 text-sm text-center py-2">
              சொல் பகுப்பு சேர்க்கப்படவில்லை
            </p>
          ) : useGroupedLayout ? (
            <div className="flex flex-wrap items-end">
              {[
                ...groups.map((g) => ({ type: 'group', position: g.position, group: g })),
                ...ungroupedMorphemes.map((m) => ({ type: 'morpheme', position: m.position, morpheme: m }))
              ]
                .sort((a, b) => a.position - b.position)
                .map((item) =>
                  item.type === 'group' ? (
                    renderGroup(item.group)
                  ) : (
                    <span key={item.morpheme.id} className="mb-2">
                      <MorphemeChip
                        morpheme={item.morpheme}
                        verbAnalysis={item.morpheme.is_verb ? verbAnalysisMap[item.morpheme.id] : null}
                        mode={mode}
                      />
                    </span>
                  )
                )}
            </div>
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
