// A block of mass m pressed against a vertical wall by a horizontal
// force F. Friction f (from the wall) acts upward, opposing the
// block's tendency to slide down under its own weight mg. Normal
// force N is the wall pushing back on the block, opposite to F.
export default function BlockAgainstWallDiagram() {
  return (
    <svg viewBox="0 0 480 280" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="240" y="30" textAnchor="middle" fill="#fff" fontSize="18" fontWeight="700">
        Block Held Against a Wall
      </text>

      {/* Wall (hatched) */}
      <rect x="60" y="60" width="14" height="180" fill="#2a2a35" stroke="#888" strokeWidth="2" />
      {Array.from({ length: 9 }).map((_, i) => (
        <line key={i} x1="60" y1={65 + i * 20} x2="74" y2={80 + i * 20} stroke="#555" strokeWidth="2" />
      ))}

      {/* Block */}
      <rect x="150" y="120" width="70" height="70" fill="#7CD992" fillOpacity="0.25" stroke="#7CD992" strokeWidth="2.5" rx="4" />
      <text x="185" y="160" textAnchor="middle" fill="#7CD992" fontSize="16" fontWeight="700">m</text>

      {/* F: applied horizontal force, pushing block into the wall */}
      <line x1="330" y1="155" x2="220" y2="155" stroke="#F3C623" strokeWidth="5" markerEnd="url(#arrowY)" />
      <text x="335" y="160" fill="#F3C623" fontSize="16" fontWeight="700">F</text>

      {/* N: wall pushing back on block (reaction to F) */}
      <line x1="150" y1="105" x2="90" y2="105" stroke="#5DADE2" strokeWidth="4" markerEnd="url(#arrowB)" />
      <text x="95" y="100" fill="#5DADE2" fontSize="14" fontWeight="700">N</text>

      {/* mg: weight, straight down */}
      <line x1="185" y1="190" x2="185" y2="250" stroke="#E74C3C" strokeWidth="4" markerEnd="url(#arrowR)" />
      <text x="192" y="245" fill="#E74C3C" fontSize="14" fontWeight="700">mg</text>

      {/* f: friction from wall, holding block up against gravity */}
      <line x1="160" y1="190" x2="160" y2="130" stroke="#C77DFF" strokeWidth="4" markerEnd="url(#arrowP)" />
      <text x="115" y="150" fill="#C77DFF" fontSize="14" fontWeight="700">f</text>

      <defs>
        <marker id="arrowY" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#F3C623" /></marker>
        <marker id="arrowB" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#5DADE2" /></marker>
        <marker id="arrowR" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#E74C3C" /></marker>
        <marker id="arrowP" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#C77DFF" /></marker>
      </defs>
    </svg>
  )
}
