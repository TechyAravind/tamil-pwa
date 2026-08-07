// Two-panel comparison: in each observer's own reference frame, THEY sit
// fixed at the grid origin and the other person is the one who moves.
function Panel({ title, fixedLabel, fixedColor, movingLabel, movingColor, x }) {
  return (
    <g transform={`translate(${x},0)`}>
      <rect x="0" y="0" width="320" height="240" rx="14" fill="#0b0b12" stroke="#2a2a35" />
      <text x="160" y="28" textAnchor="middle" fill="#fff" fontSize="15" fontWeight="700">{title}</text>

      {/* grid */}
      {[60, 110, 160, 210, 260].map((gx) => (
        <line key={gx} x1={gx} y1="50" x2={gx} y2="210" stroke="#23232e" strokeWidth="1" />
      ))}
      <line x1="20" y1="130" x2="300" y2="130" stroke="#3a3a46" strokeWidth="1.5" />

      {/* fixed observer, stays at origin */}
      <circle cx="160" cy="130" r="10" fill={fixedColor} />
      <text x="160" y="160" textAnchor="middle" fill={fixedColor} fontSize="12" fontWeight="700">{fixedLabel}</text>
      <text x="160" y="176" textAnchor="middle" fill="#888" fontSize="10">fixed at origin</text>

      {/* moving observer, slides across the grid */}
      <circle cx="160" cy="130" r="9" fill={movingColor}>
        <animate attributeName="cx" values="90;250;90" dur="4s" repeatCount="indefinite" />
      </circle>
      <text x="160" y="70" textAnchor="middle" fill={movingColor} fontSize="12" fontWeight="700">
        {movingLabel}
        <animate attributeName="x" values="90;250;90" dur="4s" repeatCount="indefinite" />
      </text>
    </g>
  )
}

export default function ReferenceFrameDiagram() {
  return (
    <svg viewBox="0 0 680 260" className="w-full h-auto rounded-xl">
      <Panel title="Alice's Frame" fixedLabel="Alice" fixedColor="#5DADE2" movingLabel="Bob" movingColor="#E74C3C" x={20} />
      <Panel title="Bob's Frame" fixedLabel="Bob" fixedColor="#E74C3C" movingLabel="Alice" movingColor="#5DADE2" x={360} />
    </svg>
  )
}
