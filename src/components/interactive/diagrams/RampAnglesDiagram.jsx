// Galileo's inclined-plane experiment (TN textbook Figure 3.1): as the
// second ramp's angle drops toward zero, the ball travels farther to
// reach the same height, until it never stops on a flat surface.
export default function RampAnglesDiagram() {
  return (
    <svg viewBox="0 0 720 300" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="360" y="34" textAnchor="middle" fill="#fff" fontSize="20" fontWeight="700">
        Same Height, Falling Angle
      </text>

      {/* Ramp 1 (left, steep launch ramp) — shared by all three scenarios */}
      <line x1="40" y1="230" x2="150" y2="120" stroke="#F3EAF7" strokeWidth="4" />
      <circle cx="150" cy="120" r="8" fill="#E8B4E0" />

      {/* Scenario A: same angle -> reaches same height h */}
      <line x1="180" y1="230" x2="290" y2="120" stroke="#8E44AD" strokeWidth="4" />
      <circle cx="255" cy="153" r="7" fill="#C77DFF">
        <animate attributeName="cx" values="180;255;180" dur="3s" repeatCount="indefinite" />
        <animate attributeName="cy" values="230;153;230" dur="3s" repeatCount="indefinite" />
      </circle>
      <text x="235" y="255" fill="#C77DFF" fontSize="13" textAnchor="middle">angle = same → reaches h</text>

      {/* Scenario B: shallower angle -> travels farther for same h */}
      <line x1="330" y1="230" x2="560" y2="150" stroke="#8E44AD" strokeWidth="4" />
      <circle cx="480" cy="176" r="7" fill="#C77DFF">
        <animate attributeName="cx" values="330;560;330" dur="3.6s" repeatCount="indefinite" />
        <animate attributeName="cy" values="230;150;230" dur="3.6s" repeatCount="indefinite" />
      </circle>
      <text x="445" y="255" fill="#C77DFF" fontSize="13" textAnchor="middle">angle ↓ → travels farther for same h</text>

      {/* Scenario C: angle = 0, ball never stops */}
      <line x1="600" y1="230" x2="700" y2="230" stroke="#F3C623" strokeWidth="4" />
      <circle cx="620" cy="230" r="7" fill="#F3C623">
        <animate attributeName="cx" values="600;700;600" dur="1.6s" repeatCount="indefinite" />
      </circle>
      <text x="650" y="255" fill="#F3C623" fontSize="13" textAnchor="middle">angle = 0 → never stops</text>

      <line x1="0" y1="230" x2="720" y2="230" stroke="#333" strokeWidth="2" />
    </svg>
  )
}
