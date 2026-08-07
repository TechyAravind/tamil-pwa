import { useState } from 'react'
import QuestionFeedback from './QuestionFeedback'
import RichText from './RichText'
import { ui } from '../../utils/ipLang'

export default function McqQuestion({ question, onNext, nextLabel, lang = 'en' }) {
  const { correct_index } = question.data
  const options = (lang === 'ta' && question.data_ta?.options) || question.data.options
  const [picked, setPicked] = useState(null)
  const [submitted, setSubmitted] = useState(false)
  const [showExplanation, setShowExplanation] = useState(false)
  const [gaveUp, setGaveUp] = useState(false)

  const pick = (i) => {
    if (submitted) return
    setPicked(i)
    setSubmitted(true)
  }

  const dontKnow = () => {
    setGaveUp(true)
    setPicked(correct_index)
    setSubmitted(true)
    setShowExplanation(true)
  }

  const correct = picked === correct_index

  return (
    <div className="card">
      <p className="text-base text-gray-800 leading-relaxed mb-4">
        <RichText text={(lang === 'ta' && question.prompt_text_ta) || question.prompt_text} />
      </p>

      <div className="space-y-2.5">
        {options.map((opt, i) => {
          let style = 'bg-white border-gray-200 hover:border-[#8E44AD]'
          if (submitted) {
            if (i === correct_index) style = 'bg-green-50 border-green-400'
            else if (i === picked) style = 'bg-red-50 border-red-400'
            else style = 'bg-white border-gray-100 opacity-60'
          }
          return (
            <button
              key={i}
              onClick={() => pick(i)}
              disabled={submitted}
              className={`w-full text-left flex items-center gap-3 px-4 py-3 rounded-xl border
                          transition-colors min-h-[52px] ${style}`}
            >
              <span className="w-7 h-7 rounded-full border border-gray-300 flex items-center justify-center
                               text-xs font-bold text-gray-500 shrink-0">
                {String.fromCharCode(65 + i)}
              </span>
              <span className="text-sm text-gray-800"><RichText text={opt} /></span>
            </button>
          )
        })}
      </div>

      {!submitted && (
        <button onClick={dontKnow} className="mt-3 text-xs text-gray-400 hover:text-gray-600 underline">
          {ui('dontKnow', lang)}
        </button>
      )}

      <QuestionFeedback
        submitted={submitted} correct={correct} gaveUp={gaveUp}
        explanationText={(lang === 'ta' && question.explanation_text_ta) || question.explanation_text}
        commonMistake={(lang === 'ta' && question.common_mistake_ta) || question.common_mistake}
        showExplanation={showExplanation} setShowExplanation={setShowExplanation}
        onNext={onNext} nextLabel={nextLabel} lang={lang}
      />
    </div>
  )
}
