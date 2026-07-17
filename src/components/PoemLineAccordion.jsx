import { useState } from 'react'
import MorphemeChip from './MorphemeChip'
import WordGroupBox from './WordGroupBox'
import GrammarGroupBox from './GrammarGroupBox'
import SandhiGroupBox from './SandhiGroupBox'

export default function PoemLineAccordion({
  line, verbAnalysisMap, groupVerbAnalysisMap, sandhiRulesMap, mode
}) {
  const rulesForGroup = (id) => sandhiRulesMap?.[id]
  const [open, setOpen] = useState(false)

  const morphemes = [...(line.morphemes || [])].sort((a, b) => a.position - b.position)
  const groups = [...(line.word_groups || [])].sort((a, b) => a.position - b.position)

  const morphemesByGroup = {}
  for (const m of morphemes) {
    if (!m.word_group_id) continue
    ;(morphemesByGroup[m.word_group_id] ||= []).push(m)
  }
  const ungroupedMorphemes = morphemes.filter((m) => !m.word_group_id)

  const renderGroup = (group, groupMorphemes, soloMorpheme) => {
    if (mode === 'meaning') {
      return (
        <WordGroupBox
          key={group.id}
          group={group}
          morphemes={groupMorphemes}
          verbAnalysisMap={verbAnalysisMap}
          rulesForGroup={rulesForGroup(group.id)}
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
          soloAnalysis={soloMorpheme?.is_verb ? verbAnalysisMap?.[soloMorpheme.id] : null}
          rulesForGroup={rulesForGroup(group.id)}
        />
      )
    }
    if (soloMorpheme) return null
    return (
      <SandhiGroupBox
        key={group.id}
        group={group}
        morphemes={groupMorphemes}
        rulesForGroup={sandhiRulesMap?.[group.id]}
      />
    )
  }

  const items = [
    ...groups.map((g) => ({
      position: g.position,
      node: renderGroup(g, morphemesByGroup[g.id] || [])
    })),
    ...ungroupedMorphemes.map((m) => {
      if (m.is_separator) {
        return {
          position: m.position,
          node: (
            <span key={m.id} className="inline-flex items-end pb-2 px-1 text-gray-400 font-bold text-sm mb-2">
              +
            </span>
          )
        }
      }
      const soloGroup = {
        id: `solo-${m.id}`,
        position: m.position,
        combined_display_form: m.display_form,
        combined_meaning: m.word_meaning,
        combined_grammatical_label: m.grammatical_label,
        combined_is_verb: m.is_verb
      }
      return { position: m.position, node: renderGroup(soloGroup, [m], m) }
    })
  ].sort((a, b) => a.position - b.position)

  return (
    <div className="border border-cream-dark rounded-xl overflow-hidden mb-3">
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
          ) : (
            <div className="flex flex-wrap items-end">
              {items.map((item) => item.node)}
            </div>
          )}
        </div>
      )}
    </div>
  )
}
