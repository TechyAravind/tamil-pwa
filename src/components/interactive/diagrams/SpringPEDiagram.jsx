// A block attached to a spring on a frictionless horizontal surface,
// stretched by a distance x from its equilibrium position (x = 0) by
// an applied force Fa, developing a restoring spring force Fs.
export default function SpringPEDiagram() {
  return (
    <svg viewBox="0 0 480 220" className="w-full h-auto rounded-xl" style={{ background: '#0b0b12' }}>
      <text x="240" y="28" textAnchor="middle" fill="#fff" fontSize="17" fontWeight="700">
        Spring Stretched From Equilibrium
      </text>

      {/* Wall */}
      <rect x="40" y="80" width="14" height="70" fill="#2a2a35" stroke="#888" strokeWidth="2" />
      {Array.from({ length: 6 }).map((_, i) => (
        <line key={i} x1="40" y1={85 + i * 11} x2="54" y2={94 + i * 11} stroke="#555" strokeWidth="1.5" />
      ))}

      {/* Coiled spring (zig-zag) from wall to block */}
      <polyline
        points="54,115 75,95 95,135 115,95 135,135 155,95 175,135 195,95 215,115"
        fill="none" stroke="#8E44AD" strokeWidth="3"
      />

      {/* Block at stretched position */}
      <rect x="215" y="95" width="55" height="45" fill="#7CD992" fillOpacity="0.3" stroke="#7CD992" strokeWidth="2.5" />
      <text x="242" y="122" textAnchor="middle" fill="#7CD992" fontSize="14" fontWeight="700">m</text>

      {/* Equilibrium marker (x=0) */}
      <line x1="160" y1="70" x2="160" y2="170" stroke="#555" strokeWidth="1.5" strokeDasharray="4 3" />
      <text x="160" y="185" textAnchor="middle" fill="#888" fontSize="12">x = 0</text>

      {/* x measurement */}
      <line x1="160" y1="60" x2="242" y2="60" stroke="#F3C623" strokeWidth="2" markerEnd="url(#sx1)" markerStart="url(#sx2)" />
      <text x="200" y="50" textAnchor="middle" fill="#F3C623" fontSize="13">x</text>

      {/* Fa: applied force, pulling right */}
      <line x1="270" y1="117" x2="330" y2="117" stroke="#5DADE2" strokeWidth="4" markerEnd="url(#sx3)" />
      <text x="335" y="122" fill="#5DADE2" fontSize="14" fontWeight="700">Fa</text>

      {/* Fs: restoring spring force, pulling back left */}
      <line x1="215" y1="150" x2="175" y2="150" stroke="#E74C3C" strokeWidth="4" markerEnd="url(#sx4)" />
      <text x="140" y="155" fill="#E74C3C" fontSize="14" fontWeight="700">Fs = -kx</text>

      <defs>
        <marker id="sx1" markerWidth="6" markerHeight="6" refX="5" refY="3" orient="auto"><path d="M0,0 L6,3 L0,6 Z" fill="#F3C623" /></marker>
        <marker id="sx2" markerWidth="6" markerHeight="6" refX="1" refY="3" orient="auto-start-reverse"><path d="M0,0 L6,3 L0,6 Z" fill="#F3C623" /></marker>
        <marker id="sx3" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#5DADE2" /></marker>
        <marker id="sx4" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="#E74C3C" /></marker>
      </defs>
    </svg>
  )
}
