// Two bodies before a perfectly inelastic collision (m1 moving at u1
// toward stationary m2), and stuck together afterward moving with one
// common velocity v -- kinetic energy is lost, momentum is not.
export default function InelasticCollisionDiagram() {
  return (
    <svg viewBox="0 0 480 240" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="240" y="26" textAnchor="middle" fill="#fff" fontSize="16" fontWeight="700">
        Perfectly Inelastic Collision — Before &amp; After
      </text>

      <text x="30" y="65" fill="#888" fontSize="13" fontWeight="700">Before</text>
      <line x1="20" y1="90" x2="460" y2="90" stroke="#444" strokeWidth="1.5" />
      <rect x="90" y="65" width="45" height="35" fill="#5DADE2" fillOpacity="0.3" stroke="#5DADE2" strokeWidth="2" />
      <text x="112" y="88" textAnchor="middle" fill="#5DADE2" fontSize="12" fontWeight="700">m1</text>
      <line x1="65" y1="82" x2="90" y2="82" stroke="#F3C623" strokeWidth="3" markerEnd="url(#ic1)" />
      <text x="50" y="72" fill="#F3C623" fontSize="12">u1</text>

      <rect x="260" y="70" width="35" height="28" fill="#7CD992" fillOpacity="0.3" stroke="#7CD992" strokeWidth="2" />
      <text x="277" y="88" textAnchor="middle" fill="#7CD992" fontSize="11" fontWeight="700">m2</text>
      <text x="255" y="60" fill="#888" fontSize="11">(at rest)</text>

      <text x="30" y="150" fill="#888" fontSize="13" fontWeight="700">After</text>
      <line x1="20" y1="175" x2="460" y2="175" stroke="#444" strokeWidth="1.5" />
      <rect x="150" y="150" width="90" height="35" fill="#C77DFF" fillOpacity="0.25" stroke="#C77DFF" strokeWidth="2.5" />
      <text x="195" y="172" textAnchor="middle" fill="#C77DFF" fontSize="12" fontWeight="700">m1 + m2 (stuck together)</text>
      <line x1="240" y1="168" x2="270" y2="168" stroke="#F3C623" strokeWidth="3" markerEnd="url(#ic1)" />
      <text x="248" y="158" fill="#F3C623" fontSize="12">v</text>

      <text x="240" y="215" textAnchor="middle" fill="#888" fontSize="12">
        Momentum is conserved -- kinetic energy is NOT (lost as heat/sound/deformation)
      </text>

      <defs>
        <marker id="ic1" markerWidth="7" markerHeight="7" refX="5" refY="3.5" orient="auto"><path d="M0,0 L7,3.5 L0,7 Z" fill="#F3C623" /></marker>
      </defs>
    </svg>
  )
}
