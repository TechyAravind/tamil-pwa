import { useState } from 'react'
import QuestionFeedback from './QuestionFeedback'
import RichText from './RichText'
import DiagramSlot from './diagrams/DiagramSlot'
import { ui } from '../../utils/ipLang'

function isNumericCorrect(userVal, correct) {
  const n = parseFloat(userVal)
  if (Number.isNaN(n)) return false
  const tolerance = Math.max(0.05, Math.abs(correct) * 0.02)
  return Math.abs(n - correct) <= tolerance
}

export default function FillBlankQuestion({ question, onNext, nextLabel, lang = 'en' }) {
  const blanksEn = question.data.blanks
  const blanksTa = question.data_ta?.blanks
  // `choices`/`correct` stay in English (used for comparison + as <option value>);
  // `displayLabel`/`displayChoices` are what's shown to the student and swap
  // with the language toggle. Choice arrays must stay index-aligned across languages.
  const blanks = blanksEn.map((b, i) => {
    const t = lang === 'ta' && blanksTa?.[i] ? blanksTa[i] : {}
    return { ...b, displayLabel: t.label || b.label, displayChoices: t.choices || b.choices }
  })
  const [values, setValues] = useState(blanksEn.map(() => ''))
  const [submitted, setSubmitted] = useState(false)
  const [showExplanation, setShowExplanation] = useState(false)
  const [gaveUp, setGaveUp] = useState(false)

  const setValue = (i, v) => setValues((vals) => vals.map((x, idx) => (idx === i ? v : x)))

  const allFilled = values.every((v) => v !== '')

  const results = blanksEn.map((b, i) =>
    b.type === 'dropdown' ? values[i] === b.correct : isNumericCorrect(values[i], b.correct)
  )
  const allCorrect = results.every(Boolean)

  const submit = () => {
    if (!allFilled) return
    setSubmitted(true)
  }

  const dontKnow = () => {
    setGaveUp(true)
    setValues(blanksEn.map((b) => String(b.correct)))
    setSubmitted(true)
    setShowExplanation(true)
  }

  return (
    <div className="card">
      <p className="text-base text-gray-800 leading-relaxed mb-4">
        <RichText text={(lang === 'ta' && question.prompt_text_ta) || question.prompt_text} />
      </p>

      <DiagramSlot diagramKey={question.diagram_key} />

      <div className="space-y-4">
        {blanks.map((b, i) => {
          const state = submitted ? (results[i] ? 'border-green-400 bg-green-50' : 'border-red-400 bg-red-50') : 'border-gray-300'
          return (
            <div key={i}>
              <label className="block text-xs font-semibold text-gray-500 mb-1"><RichText text={b.displayLabel} /></label>
              {b.type === 'dropdown' ? (
                <select
                  className={`w-full border rounded-lg px-3 py-2 text-sm focus:outline-none ${state}`}
                  value={values[i]} disabled={submitted}
                  onChange={(e) => setValue(i, e.target.value)}
                >
                  <option value="">{ui('selectEllipsis', lang)}</option>
                  {b.choices.map((c, ci) => (
                    <option key={c} value={c}>{b.displayChoices[ci]}</option>
                  ))}
                </select>
              ) : (
                <input
                  type="number" step="any"
                  className={`w-full border rounded-lg px-3 py-2 text-sm focus:outline-none ${state}`}
                  value={values[i]} disabled={submitted}
                  onChange={(e) => setValue(i, e.target.value)}
                  placeholder={lang === 'ta' ? 'எண்ணை உள்ளிடவும்' : 'Enter a number'}
                />
              )}
            </div>
          )
        })}
      </div>

      {!submitted ? (
        <div className="flex items-center gap-3 mt-4">
          <button
            onClick={submit} disabled={!allFilled}
            className="bg-[#8E44AD] text-white text-sm font-bold px-5 py-2 rounded-lg
                       disabled:opacity-40 hover:bg-[#9B59B6] active:scale-95 transition-all min-h-[40px]"
          >
            {ui('submit', lang)}
          </button>
          <button onClick={dontKnow} className="text-xs text-gray-400 hover:text-gray-600 underline">
            {ui('dontKnow', lang)}
          </button>
        </div>
      ) : null}

      <QuestionFeedback
        submitted={submitted} correct={allCorrect} gaveUp={gaveUp}
        explanationText={(lang === 'ta' && question.explanation_text_ta) || question.explanation_text}
        commonMistake={(lang === 'ta' && question.common_mistake_ta) || question.common_mistake}
        correctAnswerNode={
          <>
            {blanks.map((b, i) => {
              const displayCorrect = b.type === 'dropdown'
                ? (b.displayChoices[b.choices.indexOf(b.correct)] ?? b.correct)
                : b.correct
              return (
                <span key={i}>
                  {i > 0 && '; '}
                  <RichText text={b.displayLabel} />: <RichText text={String(displayCorrect)} />
                </span>
              )
            })}
          </>
        }
        takeawayFact={(lang === 'ta' && question.takeaway_fact_ta) || question.takeaway_fact}
        showExplanation={showExplanation} setShowExplanation={setShowExplanation}
        onNext={onNext} nextLabel={nextLabel} lang={lang}
      />
    </div>
  )
}
