// Two bodies before and after a 1D elastic collision: masses m1, m2
// approach with velocities u1, u2, then separate with velocities v1,
// v2 -- both momentum and kinetic energy are conserved.
export default function ElasticCollisionDiagram() {
  return (
    <svg viewBox="0 0 480 240" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="240" y="26" textAnchor="middle" fill="#fff" fontSize="16" fontWeight="700">
        Elastic Collision — Before &amp; After
      </text>

      <text x="30" y="65" fill="#888" fontSize="13" fontWeight="700">Before</text>
      <line x1="20" y1="90" x2="460" y2="90" stroke="#444" strokeWidth="1.5" />
      <rect x="90" y="65" width="45" height="35" fill="#5DADE2" fillOpacity="0.3" stroke="#5DADE2" strokeWidth="2" />
      <text x="112" y="88" textAnchor="middle" fill="#5DADE2" fontSize="12" fontWeight="700">m1</text>
      <line x1="70" y1="82" x2="90" y2="82" stroke="#F3C623" strokeWidth="3" markerEnd="url(#ec1)" />
      <text x="60" y="72" fill="#F3C623" fontSize="12">u1</text>

      <rect x="260" y="70" width="35" height="28" fill="#7CD992" fillOpacity="0.3" stroke="#7CD992" strokeWidth="2" />
      <text x="277" y="88" textAnchor="middle" fill="#7CD992" fontSize="11" fontWeight="700">m2</text>
      <line x1="240" y1="84" x2="260" y2="84" stroke="#F3C623" strokeWidth="3" markerEnd="url(#ec1)" />
      <text x="230" y="74" fill="#F3C623" fontSize="12">u2</text>

      <text x="30" y="145" fill="#888" fontSize="13" fontWeight="700">After</text>
      <line x1="20" y1="170" x2="460" y2="170" stroke="#444" strokeWidth="1.5" />
      <rect x="70" y="145" width="45" height="35" fill="#5DADE2" fillOpacity="0.3" stroke="#5DADE2" strokeWidth="2" />
      <text x="92" y="168" textAnchor="middle" fill="#5DADE2" fontSize="12" fontWeight="700">m1</text>
      <line x1="50" y1="162" x2="70" y2="162" stroke="#C77DFF" strokeWidth="3" markerEnd="url(#ec2)" />
      <text x="35" y="152" fill="#C77DFF" fontSize="12">v1</text>

      <rect x="300" y="150" width="35" height="28" fill="#7CD992" fillOpacity="0.3" stroke="#7CD992" strokeWidth="2" />
      <text x="317" y="168" textAnchor="middle" fill="#7CD992" fontSize="11" fontWeight="700">m2</text>
      <line x1="280" y1="164" x2="300" y2="164" stroke="#C77DFF" strokeWidth="3" markerEnd="url(#ec2)" />
      <text x="265" y="154" fill="#C77DFF" fontSize="12">v2</text>

      <text x="240" y="215" textAnchor="middle" fill="#888" fontSize="12">
        Momentum AND kinetic energy are both conserved
      </text>

      <defs>
        <marker id="ec1" markerWidth="7" markerHeight="7" refX="5" refY="3.5" orient="auto"><path d="M0,0 L7,3.5 L0,7 Z" fill="#F3C623" /></marker>
        <marker id="ec2" markerWidth="7" markerHeight="7" refX="5" refY="3.5" orient="auto"><path d="M0,0 L7,3.5 L0,7 Z" fill="#C77DFF" /></marker>
      </defs>
    </svg>
  )
}
