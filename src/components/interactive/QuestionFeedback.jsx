import RichText from './RichText'
import { ui } from '../../utils/ipLang'

// Shared footer for every question type: correct/incorrect banner,
// Show/Hide explanation toggle (with "Common mistake" callout),
// and the Next button that advances the lesson stepper.
export default function QuestionFeedback({
  submitted, correct, explanationText, commonMistake,
  showExplanation, setShowExplanation, onNext, gaveUp, nextLabel, lang = 'en',
}) {
  if (!submitted) return null
  const next = nextLabel || ui('next', lang)

  return (
    <div className="mt-4 space-y-3">
      <p className={`font-bold text-base ${gaveUp ? 'text-gray-500' : correct ? 'text-green-600' : 'text-red-600'}`}>
        {gaveUp ? ui('hereIsAnswer', lang) : correct ? ui('correct', lang) : ui('incorrect', lang)}
      </p>

      <div className="flex gap-2">
        {explanationText && (
          <button
            onClick={() => setShowExplanation((s) => !s)}
            className="text-sm font-semibold text-[#8E44AD] border border-[#8E44AD]/40
                       rounded-lg px-3 py-1.5 hover:bg-[#8E44AD]/5 transition-colors min-h-[36px]"
          >
            {showExplanation ? ui('hideExplanation', lang) : ui('showExplanation', lang)}
          </button>
        )}
        <button
          onClick={onNext}
          className="ml-auto bg-[#8E44AD] text-white text-sm font-bold px-5 py-1.5
                     rounded-lg hover:bg-[#9B59B6] active:scale-95 transition-all min-h-[36px]"
        >
          {next}
        </button>
      </div>

      {showExplanation && explanationText && (
        <div className="bg-gray-50 border border-gray-200 rounded-xl p-4 space-y-2">
          <p className="font-bold text-sm text-gray-800">{ui('solution', lang)}</p>
          <p className="text-sm text-gray-700 leading-relaxed"><RichText text={explanationText} /></p>
          {commonMistake && (
            <div className="border-l-4 border-amber-400 bg-amber-50 pl-3 pr-2 py-2 rounded-r-lg">
              <p className="text-xs text-amber-800 leading-relaxed">
                <span className="font-bold">{ui('commonMistake', lang)}</span>
                <RichText text={commonMistake} />
              </p>
            </div>
          )}
        </div>
      )}
    </div>
  )
}
