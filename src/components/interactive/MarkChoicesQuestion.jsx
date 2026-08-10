import { useState } from 'react'
import QuestionFeedback from './QuestionFeedback'
import RichText from './RichText'
import { ui } from '../../utils/ipLang'

// Multi-select variant of MCQ: "mark all choices that apply" — checkboxes
// instead of single-pick buttons. data: { options: [...], correct_indices: [0,2] }
export default function MarkChoicesQuestion({ question, onNext, nextLabel, lang = 'en' }) {
  const { correct_indices } = question.data
  const options = (lang === 'ta' && question.data_ta?.options) || question.data.options
  const [picked, setPicked] = useState([])
  const [submitted, setSubmitted] = useState(false)
  const [showExplanation, setShowExplanation] = useState(false)
  const [gaveUp, setGaveUp] = useState(false)

  const toggle = (i) => {
    if (submitted) return
    setPicked((p) => (p.includes(i) ? p.filter((x) => x !== i) : [...p, i]))
  }

  const dontKnow = () => {
    setGaveUp(true)
    setPicked([...correct_indices])
    setSubmitted(true)
    setShowExplanation(true)
  }

  const sameSet = (a, b) => a.length === b.length && [...a].sort().every((v, i) => v === [...b].sort()[i])
  const correct = sameSet(picked, correct_indices)
  const submit = () => { if (picked.length > 0) setSubmitted(true) }

  return (
    <div className="card">
      <p className="text-base text-gray-800 leading-relaxed mb-1">
        <RichText text={(lang === 'ta' && question.prompt_text_ta) || question.prompt_text} />
      </p>
      <p className="text-xs text-gray-400 mb-4">
        {lang === 'ta' ? 'பொருந்தும் அனைத்தையும் தேர்ந்தெடு.' : 'Select all that apply.'}
      </p>

      <div className="space-y-2.5">
        {options.map((opt, i) => {
          const isPicked = picked.includes(i)
          let style = isPicked ? 'bg-[#8E44AD]/10 border-[#8E44AD]' : 'bg-white border-gray-200 hover:border-[#8E44AD]'
          if (submitted) {
            const shouldBePicked = correct_indices.includes(i)
            if (shouldBePicked && isPicked) style = 'bg-green-50 border-green-400'
            else if (shouldBePicked && !isPicked) style = 'bg-amber-50 border-amber-400'
            else if (!shouldBePicked && isPicked) style = 'bg-red-50 border-red-400'
            else style = 'bg-white border-gray-100 opacity-60'
          }
          return (
            <button
              key={i}
              onClick={() => toggle(i)}
              disabled={submitted}
              className={`w-full text-left flex items-center gap-3 px-4 py-3 rounded-xl border
                          transition-colors min-h-[52px] ${style}`}
            >
              <span className={`w-6 h-6 rounded-md border-2 flex items-center justify-center shrink-0 text-xs font-bold
                                ${isPicked ? 'bg-[#8E44AD] border-[#8E44AD] text-white' : 'border-gray-300 text-transparent'}`}>
                ✓
              </span>
              <span className="text-sm text-gray-800"><RichText text={opt} /></span>
            </button>
          )
        })}
      </div>

      {!submitted && (
        <div className="flex items-center gap-3 mt-4">
          <button
            onClick={submit} disabled={picked.length === 0}
            className="bg-[#8E44AD] text-white text-sm font-bold px-5 py-2 rounded-lg
                       disabled:opacity-40 hover:bg-[#9B59B6] active:scale-95 transition-all min-h-[40px]"
          >
            {ui('submit', lang)}
          </button>
          <button onClick={dontKnow} className="text-xs text-gray-400 hover:text-gray-600 underline">
            {ui('dontKnow', lang)}
          </button>
        </div>
      )}

      <QuestionFeedback
        submitted={submitted} correct={correct} gaveUp={gaveUp}
        explanationText={(lang === 'ta' && question.explanation_text_ta) || question.explanation_text}
        commonMistake={(lang === 'ta' && question.common_mistake_ta) || question.common_mistake}
        correctAnswerNode={
          <>
            {correct_indices.map((idx, i) => (
              <span key={i}>{i > 0 && ', '}<RichText text={options[idx]} /></span>
            ))}
          </>
        }
        takeawayFact={(lang === 'ta' && question.takeaway_fact_ta) || question.takeaway_fact}
        showExplanation={showExplanation} setShowExplanation={setShowExplanation}
        onNext={onNext} nextLabel={nextLabel} lang={lang}
      />
    </div>
  )
}
