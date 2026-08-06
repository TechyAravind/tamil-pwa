import { useState } from 'react'
import QuestionFeedback from './QuestionFeedback'

export default function RankQuestion({ question, onNext, nextLabel }) {
  const { items, correct_order } = question.data
  const [picked, setPicked] = useState([])   // array of original indices, in chosen order
  const [submitted, setSubmitted] = useState(false)
  const [showExplanation, setShowExplanation] = useState(false)
  const [gaveUp, setGaveUp] = useState(false)

  const remaining = items.map((_, i) => i).filter((i) => !picked.includes(i))

  const pick = (i) => { if (!submitted) setPicked((p) => [...p, i]) }
  const removeLast = () => { if (!submitted) setPicked((p) => p.slice(0, -1)) }
  const clear = () => { if (!submitted) setPicked([]) }

  const allPicked = picked.length === items.length
  const allCorrect = allPicked && picked.every((v, i) => v === correct_order[i])

  const submit = () => { if (allPicked) setSubmitted(true) }

  const dontKnow = () => {
    setPicked(correct_order)
    setGaveUp(true)
    setSubmitted(true)
    setShowExplanation(true)
  }

  return (
    <div className="card">
      <p className="text-base text-gray-800 leading-relaxed mb-4 whitespace-pre-wrap">{question.prompt_text}</p>

      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">Greatest → Smallest</p>
      <div className="min-h-[52px] border-2 border-dashed border-gray-200 rounded-xl p-2 flex flex-wrap gap-2 mb-4">
        {picked.length === 0 && <span className="text-xs text-gray-300 px-2 py-2">Click items below in order…</span>}
        {picked.map((i, pos) => {
          const correctHere = submitted && i === correct_order[pos]
          const wrongHere = submitted && i !== correct_order[pos]
          return (
            <span key={pos}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-sm font-medium border
                         ${submitted ? (correctHere ? 'bg-green-50 border-green-400' : 'bg-red-50 border-red-400') : 'bg-[#8E44AD]/10 border-[#8E44AD]/40'}`}>
              <span className="text-[#8E44AD] font-bold">{pos + 1}.</span>
              {items[i]}
            </span>
          )
        })}
      </div>

      {!submitted && remaining.length > 0 && (
        <div className="flex flex-wrap gap-2 mb-4">
          {remaining.map((i) => (
            <button key={i} onClick={() => pick(i)}
              className="px-3 py-2 rounded-lg border border-gray-200 text-sm hover:border-[#8E44AD]
                         hover:bg-[#8E44AD]/5 transition-colors min-h-[40px]">
              {items[i]}
            </button>
          ))}
        </div>
      )}

      {!submitted && (
        <div className="flex items-center gap-3">
          <button onClick={removeLast} disabled={picked.length === 0} className="text-xs text-gray-400 hover:text-gray-600 underline disabled:opacity-30">
            Undo
          </button>
          <button onClick={clear} disabled={picked.length === 0} className="text-xs text-gray-400 hover:text-gray-600 underline disabled:opacity-30">
            Clear
          </button>
          <button
            onClick={submit} disabled={!allPicked}
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
