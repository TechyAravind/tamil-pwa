// Ball hanging from a string inside a car: stays vertical at constant
// velocity (inertial frame), swings back when the car brakes (non-inertial).
function Car({ x, title, tilt, note, noteColor }) {
  return (
    <g transform={`translate(${x},0)`}>
      <rect x="0" y="0" width="300" height="230" rx="14" fill="#0b0b12" stroke="#2a2a35" />
      <text x="150" y="26" textAnchor="middle" fill="#fff" fontSize="14" fontWeight="700">{title}</text>

      {/* road */}
      <line x1="20" y1="190" x2="280" y2="190" stroke="#3a3a46" strokeWidth="3" />
      {/* car body */}
      <rect x="70" y="140" width="160" height="50" rx="10" fill="#4A235A" stroke="#8E44AD" />
      <circle cx="105" cy="192" r="12" fill="#222" stroke="#666" />
      <circle cx="195" cy="192" r="12" fill="#222" stroke="#666" />
      {/* string + ball, hangs from car ceiling */}
      <line x1="150" y1="145" x2={150 + tilt} y2="90" stroke="#F3EAF7" strokeWidth="2" />
      <circle cx={150 + tilt} cy="90" r="10" fill="#C77DFF" />

      <text x="150" y="215" textAnchor="middle" fill={noteColor} fontSize="12" fontWeight="600">{note}</text>
    </g>
  )
}

export default function InertialVsNonInertialDiagram() {
  return (
    <svg viewBox="0 0 640 230" className="w-full h-auto rounded-xl">
      <Car x={10} title="Constant velocity" tilt={0} note="ball hangs straight — inertial frame" noteColor="#7CD992" />
      <Car x={330} title="Sudden braking" tilt={-38} note="ball swings forward — non-inertial frame" noteColor="#F3C623" />
    </svg>
  )
}
