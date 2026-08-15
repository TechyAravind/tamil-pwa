// A mass whirled in a vertical circle on a string. At the top, both
// gravity (mg) and tension (T2) point down (toward the centre). At
// the bottom, tension (T1) points up (toward the centre) while
// gravity still points down (away from the centre) -- this is why
// tension is always greatest at the bottom.
export default function VerticalCircleDiagram() {
  return (
    <svg viewBox="0 0 420 320" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="210" y="28" textAnchor="middle" fill="#fff" fontSize="17" fontWeight="700">
        Motion in a Vertical Circle
      </text>

      {/* Circle path */}
      <circle cx="210" cy="170" r="110" fill="none" stroke="#555" strokeWidth="2" strokeDasharray="5 4" />
      <circle cx="210" cy="170" r="3" fill="#888" />

      {/* Top point */}
      <circle cx="210" cy="60" r="9" fill="#7CD992" />
      <text x="225" y="45" fill="#7CD992" fontSize="13" fontWeight="700">Top</text>
      <line x1="210" y1="60" x2="210" y2="20" stroke="#E74C3C" strokeWidth="4" markerEnd="url(#vc1)" />
      <text x="218" y="30" fill="#E74C3C" fontSize="12">mg</text>
      <line x1="210" y1="60" x2="210" y2="100" stroke="#5DADE2" strokeWidth="4" markerEnd="url(#vc2)" />
      <text x="218" y="90" fill="#5DADE2" fontSize="12">T2</text>

      {/* Bottom point */}
      <circle cx="210" cy="280" r="9" fill="#F3C623" />
      <text x="225" y="300" fill="#F3C623" fontSize="13" fontWeight="700">Bottom</text>
      <line x1="210" y1="280" x2="210" y2="320" stroke="#E74C3C" strokeWidth="4" markerEnd="url(#vc1)" />
      <text x="218" y="310" fill="#E74C3C" fontSize="12">mg</text>
      <line x1="210" y1="280" x2="210" y2="240" stroke="#5DADE2" strokeWidth="4" markerEnd="url(#vc2)" />
      <text x="218" y="250" fill="#5DADE2" fontSize="12">T1</text>

      <text x="210" y="180" textAnchor="middle" fill="#C77DFF" fontSize="12">T1 &gt; T2</text>
      <text x="210" y="198" textAnchor="middle" fill="#888" fontSize="11">(bottom tension is always bigger)</text>

      <defs>
        <marker id="vc1" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#E74C3C" /></marker>
        <marker id="vc2" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#5DADE2" /></marker>
      </defs>
    </svg>
  )
}
