import { useState } from 'react'
import QuestionFeedback from './QuestionFeedback'

export default function MatchQuestion({ question, onNext, nextLabel }) {
  const { left, right, correct_pairs } = question.data
  const [matchMap, setMatchMap] = useState({})   // leftIndex -> rightIndex
  const [selectedLeft, setSelectedLeft] = useState(null)
  const [submitted, setSubmitted] = useState(false)
  const [showExplanation, setShowExplanation] = useState(false)
  const [gaveUp, setGaveUp] = useState(false)

  const rightLetters = right.map((_, i) => String.fromCharCode(65 + i))

  const clickLeft = (i) => {
    if (submitted) return
    setSelectedLeft(i)
  }

  const clickRight = (j) => {
    if (submitted || selectedLeft === null) return
    setMatchMap((prev) => {
      const next = { ...prev }
      // unlink any other left currently pointing at this right item
      Object.keys(next).forEach((k) => { if (next[k] === j) delete next[k] })
      next[selectedLeft] = j
      return next
    })
    setSelectedLeft(null)
  }

  const clearMatches = () => { setMatchMap({}); setSelectedLeft(null) }

  const allMatched = Object.keys(matchMap).length === left.length

  const isPairCorrect = (li) => correct_pairs.some(([l, r]) => l === li && matchMap[li] === r)
  const allCorrect = left.every((_, li) => isPairCorrect(li))

  const submit = () => { if (allMatched) setSubmitted(true) }

  const dontKnow = () => {
    const map = {}
    correct_pairs.forEach(([l, r]) => { map[l] = r })
    setMatchMap(map)
    setGaveUp(true)
    setSubmitted(true)
    setShowExplanation(true)
  }

  return (
    <div className="card">
      <p className="text-base text-gray-800 leading-relaxed mb-1 whitespace-pre-wrap">{question.prompt_text}</p>
      <p className="text-xs text-gray-400 mb-4">Click a left item, then click its matching right item.</p>

      <div className="grid grid-cols-2 gap-3">
        <div className="space-y-2">
          {left.map((l, i) => {
            const matchedTo = matchMap[i]
            let style = 'bg-white border-gray-200 hover:border-[#8E44AD]'
            if (selectedLeft === i) style = 'bg-[#8E44AD]/10 border-[#8E44AD]'
            if (submitted) style = isPairCorrect(i) ? 'bg-green-50 border-green-400' : 'bg-red-50 border-red-400'
            return (
              <button key={i} onClick={() => clickLeft(i)} disabled={submitted}
                className={`w-full text-left px-3 py-2.5 rounded-xl border text-sm transition-colors min-h-[48px] flex items-center gap-2 ${style}`}>
                <span className="flex-1">{l}</span>
                {matchedTo !== undefined && (
                  <span className="w-6 h-6 rounded-full bg-[#8E44AD] text-white text-xs font-bold flex items-center justify-center shrink-0">
                    {rightLetters[matchedTo]}
                  </span>
                )}
              </button>
            )
          })}
        </div>
        <div className="space-y-2">
          {right.map((r, j) => (
            <button key={j} onClick={() => clickRight(j)} disabled={submitted}
              className="w-full text-left px-3 py-2.5 rounded-xl border border-gray-200 text-sm
                         hover:border-[#8E44AD] transition-colors min-h-[48px] flex items-center gap-2">
              <span className="w-6 h-6 rounded-full border border-gray-300 text-xs font-bold flex items-center justify-center shrink-0">
                {rightLetters[j]}
              </span>
              <span>{r}</span>
            </button>
          ))}
        </div>
      </div>

      {!submitted && (
        <div className="flex items-center gap-3 mt-4">
          <button onClick={clearMatches} className="text-xs text-gray-400 hover:text-gray-600 underline">
            Clear matches
          </button>
          <button
            onClick={submit} disabled={!allMatched}
            className="ml-auto bg-[#8E44AD] text-white text-sm font-bold px-5 py-2 rounded-lg
                       disabled:opacity-40 hover:bg-[#9B59B6] active:scale-95 transition-all min-h-[40px]"
          >
            Submit
          </button>
          <button onClick={dontKnow} className="text-xs text-gray-400 hover:text-gray-600 underline">
            I don't know
          </button>
        </div>
      )}

      <QuestionFeedback
        submitted={submitted} correct={allCorrect} gaveUp={gaveUp}
        explanationText={question.explanation_text} commonMistake={question.common_mistake}
        showExplanation={showExplanation} setShowExplanation={setShowExplanation}
        onNext={onNext} nextLabel={nextLabel}
      />
    </div>
  )
}
