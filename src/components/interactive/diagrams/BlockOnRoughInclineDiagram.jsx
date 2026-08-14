// A block resting on a rough (frictional) incline: weight mg straight
// down, normal force N perpendicular to the slope, and friction f
// acting up the slope, opposing the block's tendency to slide down.
export default function BlockOnRoughInclineDiagram() {
  return (
    <svg viewBox="0 0 480 280" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="240" y="28" textAnchor="middle" fill="#fff" fontSize="17" fontWeight="700">
        Block on a Rough Incline
      </text>

      {/* Incline (right angle at bottom-left, slope up to the left) */}
      <polygon points="60,230 420,230 420,70" fill="#2a2a35" stroke="#888" strokeWidth="2" />
      <text x="385" y="130" fill="#F3C623" fontSize="14">θ</text>

      {/* Block sitting on the slope */}
      <g transform="translate(260,150) rotate(-31)">
        <rect x="-30" y="-24" width="60" height="24" fill="#7CD992" fillOpacity="0.3" stroke="#7CD992" strokeWidth="2.5" />
        <text x="0" y="-6" textAnchor="middle" fill="#7CD992" fontSize="13" fontWeight="700">m</text>
      </g>

      {/* mg: straight down */}
      <line x1="260" y1="150" x2="260" y2="245" stroke="#E74C3C" strokeWidth="4" markerEnd="url(#a1)" />
      <text x="268" y="240" fill="#E74C3C" fontSize="14" fontWeight="700">mg</text>

      {/* N: perpendicular to slope, pointing away from surface */}
      <line x1="260" y1="150" x2="210" y2="55" stroke="#5DADE2" strokeWidth="4" markerEnd="url(#a2)" />
      <text x="175" y="55" fill="#5DADE2" fontSize="14" fontWeight="700">N</text>

      {/* f: friction, up the slope */}
      <line x1="260" y1="150" x2="185" y2="180" stroke="#C77DFF" strokeWidth="4" markerEnd="url(#a3)" />
      <text x="140" y="195" fill="#C77DFF" fontSize="14" fontWeight="700">f</text>

      <defs>
        <marker id="a1" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#E74C3C" /></marker>
        <marker id="a2" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#5DADE2" /></marker>
        <marker id="a3" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#C77DFF" /></marker>
      </defs>
    </svg>
  )
}
