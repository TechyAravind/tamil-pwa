// A "double incline" / tent shape: a particle starts at the peak A and
// can slide down either the gentler slope to B (30°) or the steeper
// slope to C (45°). Both surfaces are smooth (frictionless).
export default function DoubleInclineDiagram() {
  return (
    <svg viewBox="0 0 480 260" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="240" y="30" textAnchor="middle" fill="#fff" fontSize="18" fontWeight="700">
        Double Incline — Same Particle, Two Paths
      </text>

      {/* Ground */}
      <line x1="30" y1="210" x2="450" y2="210" stroke="#555" strokeWidth="2" />

      {/* Tent shape: B (bottom-left) - A (peak) - C (bottom-right) */}
      <polygon points="90,210 240,80 390,210" fill="#2a2a35" stroke="#888" strokeWidth="2" />

      {/* Peak label A */}
      <circle cx="240" cy="80" r="6" fill="#C77DFF" />
      <text x="240" y="65" textAnchor="middle" fill="#C77DFF" fontSize="15" fontWeight="700">A</text>

      {/* B vertex + 30° angle */}
      <circle cx="90" cy="210" r="5" fill="#5DADE2" />
      <text x="70" y="230" fill="#5DADE2" fontSize="14" fontWeight="700">B</text>
      <text x="115" y="200" fill="#5DADE2" fontSize="13">30°</text>

      {/* C vertex + 45° angle */}
      <circle cx="390" cy="210" r="5" fill="#F3C623" />
      <text x="395" y="230" fill="#F3C623" fontSize="14" fontWeight="700">C</text>
      <text x="345" y="200" fill="#F3C623" fontSize="13">45°</text>

      {/* Ball sliding down the AC (steeper) path, animated */}
      <circle r="8" fill="#7CD992">
        <animateMotion dur="2.5s" repeatCount="indefinite" path="M240,80 L390,210" />
      </circle>
      <text x="330" y="120" fill="#7CD992" fontSize="12">steeper → faster</text>
    </svg>
  )
}
