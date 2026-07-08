import { useState, useRef, useCallback } from 'react'

/**
 * useSequentialCombine — shared state machine for the "tap the + connector,
 * left to right, one at a time" interaction used across சொல் பொருள்,
 * இலக்கணக்குறிப்பு and இலக்கணம் (சந்தி) tabs.
 *
 * connectorCount = number of junctions between the units in a word group
 * (i.e. units.length - 1).
 *
 * combineStep tracks how many junctions have been merged so far, 0..connectorCount.
 * Only the connector at index === combineStep may be tapped (enforces order).
 * Double-tap / double-click anywhere the caller wires it up resets to 0.
 */
export default function useSequentialCombine(connectorCount) {
  const [combineStep, setCombineStep] = useState(0)
  const lastTapRef = useRef(0)

  const fullyCombined = combineStep >= connectorCount

  const advance = useCallback((connectorIndex) => {
    setCombineStep((s) => (connectorIndex === s ? s + 1 : s))
  }, [])

  const reset = useCallback(() => setCombineStep(0), [])

  // Call from onClick to detect a double-tap/double-click (within 350ms)
  // without interfering with a single tap's own handling.
  const registerTapForDoubleTap = useCallback(() => {
    const now = Date.now()
    if (now - lastTapRef.current < 350) {
      reset()
      lastTapRef.current = 0
    } else {
      lastTapRef.current = now
    }
  }, [reset])

  return { combineStep, fullyCombined, advance, reset, registerTapForDoubleTap }
}
