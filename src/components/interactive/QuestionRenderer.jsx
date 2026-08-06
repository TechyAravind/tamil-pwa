import McqQuestion from './McqQuestion'
import FillBlankQuestion from './FillBlankQuestion'
import MatchQuestion from './MatchQuestion'
import RankQuestion from './RankQuestion'

// Dispatches to the right question component based on question_type.
// graph_point is schema-ready but not yet built (flagged in the framework doc).
export default function QuestionRenderer({ question, onNext, nextLabel }) {
  switch (question.question_type) {
    case 'mcq':        return <McqQuestion question={question} onNext={onNext} nextLabel={nextLabel} />
    case 'fill_blank':  return <FillBlankQuestion question={question} onNext={onNext} nextLabel={nextLabel} />
    case 'match':       return <MatchQuestion question={question} onNext={onNext} nextLabel={nextLabel} />
    case 'rank':         return <RankQuestion question={question} onNext={onNext} nextLabel={nextLabel} />
    default:
      return (
        <div className="card text-center py-10 text-gray-400">
          This question type ({question.question_type}) isn't supported yet.
          <button onClick={onNext} className="block mx-auto mt-3 text-[#8E44AD] text-sm font-semibold underline">
            Skip →
          </button>
        </div>
      )
  }
}
