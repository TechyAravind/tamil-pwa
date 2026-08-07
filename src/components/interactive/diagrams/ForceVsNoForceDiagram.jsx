// A puck sliding on frictionless ice: Aristotle predicts it slows and
// stops without a force; Newton's First Law predicts constant velocity.
export default function ForceVsNoForceDiagram() {
  return (
    <svg viewBox="0 0 640 220" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="320" y="30" textAnchor="middle" fill="#fff" fontSize="16" fontWeight="700">
        No Horizontal Force — Two Predictions
      </text>

      <line x1="20" y1="100" x2="620" y2="100" stroke="#333" strokeWidth="2" />

      {/* Aristotle's prediction: slows and stops */}
      <circle cx="60" cy="90" r="9" fill="#E74C3C">
        <animate attributeName="cx" values="60;220;220;60" keyTimes="0;0.5;1;1" dur="3s" repeatCount="indefinite" />
      </circle>
      <text x="320" y="90" fill="#E74C3C" fontSize="12" textAnchor="end">Aristotle: slows, stops</text>

      {/* Newton's prediction: constant velocity, keeps going */}
      <circle cx="60" cy="150" r="9" fill="#7CD992">
        <animate attributeName="cx" values="60;600;60" dur="3s" repeatCount="indefinite" />
      </circle>
      <line x1="20" y1="150" x2="620" y2="150" stroke="#333" strokeWidth="2" />
      <text x="600" y="140" fill="#7CD992" fontSize="12" textAnchor="end">Newton: constant velocity</text>
    </svg>
  )
}
