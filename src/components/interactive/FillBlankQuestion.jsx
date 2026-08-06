import { useState } from 'react'
import QuestionFeedback from './QuestionFeedback'

function isNumericCorrect(userVal, correct) {
  const n = parseFloat(userVal)
  if (Number.isNaN(n)) return false
  const tolerance = Math.max(0.05, Math.abs(correct) * 0.02)
  return Math.abs(n - correct) <= tolerance
}

export default function FillBlankQuestion({ question, onNext, nextLabel }) {
  const { blanks } = question.data
  const [values, setValues] = useState(blanks.map(() => ''))
  const [submitted, setSubmitted] = useState(false)
  const [showExplanation, setShowExplanation] = useState(false)
  const [gaveUp, setGaveUp] = useState(false)

  const setValue = (i, v) => setValues((vals) => vals.map((x, idx) => (idx === i ? v : x)))

  const allFilled = values.every((v) => v !== '')

  const results = blanks.map((b, i) =>
    b.type === 'dropdown' ? values[i] === b.correct : isNumericCorrect(values[i], b.correct)
  )
  const allCorrect = results.every(Boolean)

  const submit = () => {
    if (!allFilled) return
    setSubmitted(true)
  }

  const dontKnow = () => {
    setGaveUp(true)
    setValues(blanks.map((b) => String(b.correct)))
    setSubmitted(true)
    setShowExplanation(true)
  }

  return (
    <div className="card">
      <p className="text-base text-gray-800 leading-relaxed mb-4 whitespace-pre-wrap">{question.prompt_text}</p>

      <div className="space-y-4">
        {blanks.map((b, i) => {
          const state = submitted ? (results[i] ? 'border-green-400 bg-green-50' : 'border-red-400 bg-red-50') : 'border-gray-300'
          return (
            <div key={i}>
              <label className="block text-xs font-semibold text-gray-500 mb-1">{b.label}</label>
              {b.type === 'dropdown' ? (
                <select
                  className={`w-full border rounded-lg px-3 py-2 text-sm focus:outline-none ${state}`}
                  value={values[i]} disabled={submitted}
                  onChange={(e) => setValue(i, e.target.value)}
                >
                  <option value="">— select —</option>
                  {b.choices.map((c) => <option key={c} value={c}>{c}</option>)}
                </select>
              ) : (
                <input
                  type="number" step="any"
                  className={`w-full border rounded-lg px-3 py-2 text-sm focus:outline-none ${state}`}
                  value={values[i]} disabled={submitted}
                  onChange={(e) => setValue(i, e.target.value)}
                  placeholder="Enter a number"
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
            Submit
          </button>
          <button onClick={dontKnow} className="text-xs text-gray-400 hover:text-gray-600 underline">
            I don't know
          </button>
        </div>
      ) : null}

      <QuestionFeedback
        submitted={submitted} correct={allCorrect} gaveUp={gaveUp}
        explanationText={question.explanation_text} commonMistake={question.common_mistake}
        showExplanation={showExplanation} setShowExplanation={setShowExplanation}
        onNext={onNext} nextLabel={nextLabel}
      />
    </div>
  )
}
