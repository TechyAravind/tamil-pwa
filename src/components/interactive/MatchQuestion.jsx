import { useState, useRef, useCallback, useEffect } from 'react'
import QuestionFeedback from './QuestionFeedback'
import RichText from './RichText'
import { ui } from '../../utils/ipLang'

// Match-the-following, redone as a real drag interaction (per UIUX
// feedback: "draggable stick or line... not press this then press that").
// Right-side items are draggable anchors; left-side items are drop
// targets. Dragging a handle draws a live SVG line that follows the
// pointer, and it snaps into place when released over a left item.
export default function MatchQuestion({ question, onNext, nextLabel, lang = 'en' }) {
  const left  = (lang === 'ta' && question.data_ta?.left)  || question.data.left
  const right = (lang === 'ta' && question.data_ta?.right) || question.data.right
  const { correct_pairs } = question.data

  const [matches, setMatches] = useState({})    // leftIndex -> rightIndex
  const [dragging, setDragging] = useState(null) // { rightIndex, x, y } in container coords
  const [submitted, setSubmitted] = useState(false)
  const [showExplanation, setShowExplanation] = useState(false)
  const [gaveUp, setGaveUp] = useState(false)

  const containerRef = useRef(null)
  const leftRefs  = useRef([])
  const rightRefs = useRef([])

  const rightLetters = right.map((_, i) => String.fromCharCode(65 + i))
  const matchedRightOf = (li) => matches[li]
  const isRightUsed = (ri) => Object.values(matches).includes(ri)

  const relPoint = (clientX, clientY) => {
    const box = containerRef.current.getBoundingClientRect()
    return { x: clientX - box.left, y: clientY - box.top }
  }

  const centerOf = (el) => {
    const box = el.getBoundingClientRect()
    const c = containerRef.current.getBoundingClientRect()
    return { x: box.left - c.left + box.width / 2, y: box.top - c.top + box.height / 2 }
  }

  const startDrag = (ri) => (e) => {
    if (submitted) return
    e.preventDefault()
    e.currentTarget.setPointerCapture?.(e.pointerId)
    const p = relPoint(e.clientX, e.clientY)
    setDragging({ rightIndex: ri, x: p.x, y: p.y })
  }

  const onMove = useCallback((e) => {
    setDragging((d) => {
      if (!d) return d
      const p = relPoint(e.clientX, e.clientY)
      return { ...d, x: p.x, y: p.y }
    })
  }, [])

  const onUp = useCallback((e) => {
    setDragging((d) => {
      if (!d) return null
      // hit-test against each left drop zone
      for (let li = 0; li < leftRefs.current.length; li++) {
        const el = leftRefs.current[li]
        if (!el) continue
        const box = el.getBoundingClientRect()
        const pad = 10
        if (
          e.clientX >= box.left - pad && e.clientX <= box.right + pad &&
          e.clientY >= box.top - pad && e.clientY <= box.bottom + pad
        ) {
          setMatches((prev) => {
            const next = { ...prev }
            // a left item can only hold one match; a right anchor can only be used once
            Object.keys(next).forEach((k) => { if (next[k] === d.rightIndex) delete next[k] })
            next[li] = d.rightIndex
            return next
          })
          break
        }
      }
      return null
    })
  }, [])

  useEffect(() => {
    if (!dragging) return
    window.addEventListener('pointermove', onMove)
    window.addEventListener('pointerup', onUp)
    return () => {
      window.removeEventListener('pointermove', onMove)
      window.removeEventListener('pointerup', onUp)
    }
  }, [dragging, onMove, onUp])

  const clearMatches = () => setMatches({})
  const allMatched = Object.keys(matches).length === left.length

  const isPairCorrect = (li) => correct_pairs.some(([l, r]) => l === li && matches[li] === r)
  const allCorrect = left.every((_, li) => isPairCorrect(li))

  const submit = () => { if (allMatched) setSubmitted(true) }

  const dontKnow = () => {
    const map = {}
    correct_pairs.forEach(([l, r]) => { map[l] = r })
    setMatches(map)
    setGaveUp(true)
    setSubmitted(true)
    setShowExplanation(true)
  }

  // Compute SVG line endpoints on every render (cheap — small element counts).
  const [lines, setLines] = useState([])
  useEffect(() => {
    if (!containerRef.current) return
    const next = Object.entries(matches).map(([li, ri]) => {
      const lEl = leftRefs.current[Number(li)]
      const rEl = rightRefs.current[Number(ri)]
      if (!lEl || !rEl) return null
      return { li: Number(li), ri: Number(ri), a: centerOf(lEl), b: centerOf(rEl) }
    }).filter(Boolean)
    setLines(next)
  }, [matches, submitted])

  return (
    <div className="card">
      <p className="text-base text-gray-800 leading-relaxed mb-1">
        <RichText text={(lang === 'ta' && question.prompt_text_ta) || question.prompt_text} />
      </p>
      <p className="text-xs text-gray-400 mb-4">{ui('dragToMatch', lang)}</p>

      <div ref={containerRef} className="relative grid grid-cols-2 gap-x-10 gap-y-2">
        {/* live + locked-in lines */}
        <svg className="absolute inset-0 w-full h-full pointer-events-none" style={{ zIndex: 1 }}>
          {lines.map(({ li, a, b }) => (
            <line key={li}
              x1={a.x} y1={a.y} x2={b.x} y2={b.y}
              stroke={submitted ? (isPairCorrect(li) ? '#22c55e' : '#ef4444') : '#8E44AD'}
              strokeWidth="3" strokeLinecap="round"
            />
          ))}
          {dragging && rightRefs.current[dragging.rightIndex] && (() => {
            const b = centerOf(rightRefs.current[dragging.rightIndex])
            return <line x1={dragging.x} y1={dragging.y} x2={b.x} y2={b.y} stroke="#8E44AD" strokeWidth="3" strokeDasharray="6 4" strokeLinecap="round" />
          })()}
        </svg>

        <div className="space-y-2" style={{ position: 'relative', zIndex: 2 }}>
          {left.map((l, i) => {
            const ri = matchedRightOf(i)
            let style = 'bg-white border-gray-200'
            if (submitted) style = isPairCorrect(i) ? 'bg-green-50 border-green-400' : 'bg-red-50 border-red-400'
            else if (ri !== undefined) style = 'bg-[#8E44AD]/10 border-[#8E44AD]'
            return (
              <div key={i} ref={(el) => (leftRefs.current[i] = el)}
                className={`px-3 py-2.5 rounded-xl border text-sm min-h-[48px] flex items-center gap-2 transition-colors ${style}`}>
                <span className="flex-1"><RichText text={l} /></span>
                {ri !== undefined && (
                  <span className="w-6 h-6 rounded-full bg-[#8E44AD] text-white text-xs font-bold flex items-center justify-center shrink-0">
                    {rightLetters[ri]}
                  </span>
                )}
              </div>
            )
          })}
        </div>

        <div className="space-y-2" style={{ position: 'relative', zIndex: 2 }}>
          {right.map((r, j) => {
            const used = isRightUsed(j)
            return (
              <div key={j}
                ref={(el) => (rightRefs.current[j] = el)}
                onPointerDown={startDrag(j)}
                className={`px-3 py-2.5 rounded-xl border text-sm min-h-[48px] flex items-center gap-2 select-none
                            ${submitted ? 'border-gray-200 cursor-default' : 'border-gray-200 cursor-grab active:cursor-grabbing hover:border-[#8E44AD]'}
                            ${used && !submitted ? 'bg-[#8E44AD]/5' : 'bg-white'}`}
                style={{ touchAction: 'none' }}
              >
                <span className="w-6 h-6 rounded-full border-2 border-[#8E44AD] text-[#8E44AD] text-xs font-bold flex items-center justify-center shrink-0">
                  {rightLetters[j]}
                </span>
                <span className="flex-1"><RichText text={r} /></span>
              </div>
            )
          })}
        </div>
      </div>

      {!submitted && (
        <div className="flex items-center gap-3 mt-4">
          <button onClick={clearMatches} className="text-xs text-gray-400 hover:text-gray-600 underline">
            {ui('clearMatches', lang)}
          </button>
          <button
            onClick={submit} disabled={!allMatched}
            className="ml-auto bg-[#8E44AD] text-white text-sm font-bold px-5 py-2 rounded-lg
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
        submitted={submitted} correct={allCorrect} gaveUp={gaveUp}
        explanationText={(lang === 'ta' && question.explanation_text_ta) || question.explanation_text}
        commonMistake={(lang === 'ta' && question.common_mistake_ta) || question.common_mistake}
        correctAnswerNode={
          <>
            {correct_pairs.map(([l, r], i) => (
              <span key={i}>
                {i > 0 && '; '}
                <RichText text={left[l]} /> → <RichText text={right[r]} />
              </span>
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
