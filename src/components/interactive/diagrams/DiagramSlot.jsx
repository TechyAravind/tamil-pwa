import RampAnglesDiagram from './RampAnglesDiagram'
import ReferenceFrameDiagram from './ReferenceFrameDiagram'
import InertialVsNonInertialDiagram from './InertialVsNonInertialDiagram'
import ForceVsNoForceDiagram from './ForceVsNoForceDiagram'

const DIAGRAMS = {
  ramp_angles: RampAnglesDiagram,
  reference_frame: ReferenceFrameDiagram,
  inertial_vs_noninertial: InertialVsNonInertialDiagram,
  force_vs_noforce: ForceVsNoForceDiagram,
}

// Maps a step's `diagram_key` (a plain string column) to a built-in
// inline SVG illustration. Returns null for unknown/empty keys so a
// step can safely omit a diagram.
export default function DiagramSlot({ diagramKey }) {
  const Diagram = DIAGRAMS[diagramKey]
  if (!Diagram) return null
  return (
    <div className="my-4 rounded-xl overflow-hidden border border-gray-800/10">
      <Diagram />
    </div>
  )
}
