// A force F applied to an object at angle theta above the horizontal,
// decomposed into its x-component (Fcos theta) and y-component
// (F sin theta), shown as dashed projection lines.
export default function ForceComponentsDiagram() {
  return (
    <svg viewBox="0 0 480 280" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="240" y="28" textAnchor="middle" fill="#fff" fontSize="17" fontWeight="700">
        Resolving a Force Into Components
      </text>

      {/* Axes */}
      <line x1="100" y1="220" x2="420" y2="220" stroke="#555" strokeWidth="2" />
      <line x1="100" y1="220" x2="100" y2="60" stroke="#555" strokeWidth="2" />
      <text x="425" y="225" fill="#888" fontSize="13">x</text>
      <text x="90" y="55" fill="#888" fontSize="13">y</text>

      {/* Object at origin */}
      <circle cx="100" cy="220" r="7" fill="#7CD992" />

      {/* F, at angle theta */}
      <line x1="100" y1="220" x2="320" y2="100" stroke="#F3C623" strokeWidth="4" markerEnd="url(#fa)" />
      <text x="300" y="90" fill="#F3C623" fontSize="15" fontWeight="700">F</text>
      <path d="M 150 220 A 50 50 0 0 0 170 178" fill="none" stroke="#C77DFF" strokeWidth="2" />
      <text x="165" y="205" fill="#C77DFF" fontSize="13">θ</text>

      {/* Fx component (dashed, along x) */}
      <line x1="100" y1="220" x2="320" y2="220" stroke="#5DADE2" strokeWidth="3" strokeDasharray="6 4" markerEnd="url(#fb)" />
      <text x="200" y="240" fill="#5DADE2" fontSize="13" fontWeight="700">F cos θ</text>

      {/* Fy component (dashed, along y) */}
      <line x1="320" y1="220" x2="320" y2="100" stroke="#E74C3C" strokeWidth="3" strokeDasharray="6 4" markerEnd="url(#fc)" />
      <text x="330" y="165" fill="#E74C3C" fontSize="13" fontWeight="700">F sin θ</text>

      <defs>
        <marker id="fa" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#F3C623" /></marker>
        <marker id="fb" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#5DADE2" /></marker>
        <marker id="fc" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#E74C3C" /></marker>
      </defs>
    </svg>
  )
}
