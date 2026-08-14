// Two blocks in contact on a smooth surface (mass 2m and mass m).
// Case 1: force F1 pushes from the left, through 2m into m.
// Case 2: force F2 pushes from the right, through m into 2m.
// The contact ("interface") force between the two blocks is what
// differs between the two cases, even though the blocks are the same.
export default function TwoBlocksForceDiagram() {
  return (
    <svg viewBox="0 0 480 260" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="240" y="28" textAnchor="middle" fill="#fff" fontSize="17" fontWeight="700">
        Same Two Blocks, Push From Either Side
      </text>

      {/* Case 1: F1 from the left */}
      <text x="40" y="70" fill="#F3C623" fontSize="13" fontWeight="700">Case 1</text>
      <line x1="30" y1="95" x2="380" y2="95" stroke="#444" strokeWidth="2" />
      <line x1="55" y1="90" x2="110" y2="90" stroke="#F3C623" strokeWidth="4" markerEnd="url(#arr1)" />
      <text x="55" y="80" fill="#F3C623" fontSize="13">F1</text>
      <rect x="110" y="60" width="60" height="35" fill="#5DADE2" fillOpacity="0.25" stroke="#5DADE2" strokeWidth="2" />
      <text x="140" y="82" textAnchor="middle" fill="#5DADE2" fontSize="14" fontWeight="700">2m</text>
      <rect x="170" y="68" width="40" height="27" fill="#7CD992" fillOpacity="0.25" stroke="#7CD992" strokeWidth="2" />
      <text x="190" y="86" textAnchor="middle" fill="#7CD992" fontSize="13" fontWeight="700">m</text>

      {/* Case 2: F2 from the right */}
      <text x="40" y="150" fill="#F3C623" fontSize="13" fontWeight="700">Case 2</text>
      <line x1="30" y1="175" x2="380" y2="175" stroke="#444" strokeWidth="2" />
      <rect x="150" y="148" width="60" height="35" fill="#5DADE2" fillOpacity="0.25" stroke="#5DADE2" strokeWidth="2" />
      <text x="180" y="170" textAnchor="middle" fill="#5DADE2" fontSize="14" fontWeight="700">2m</text>
      <rect x="210" y="156" width="40" height="27" fill="#7CD992" fillOpacity="0.25" stroke="#7CD992" strokeWidth="2" />
      <text x="230" y="174" textAnchor="middle" fill="#7CD992" fontSize="13" fontWeight="700">m</text>
      <line x1="320" y1="170" x2="255" y2="170" stroke="#F3C623" strokeWidth="4" markerEnd="url(#arr1)" />
      <text x="295" y="160" fill="#F3C623" fontSize="13">F2</text>

      <text x="240" y="220" textAnchor="middle" fill="#C77DFF" fontSize="13">
        Interface force between the blocks differs between the two cases
      </text>

      <defs>
        <marker id="arr1" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#F3C623" /></marker>
      </defs>
    </svg>
  )
}
