import RampAnglesDiagram from './RampAnglesDiagram'
import ReferenceFrameDiagram from './ReferenceFrameDiagram'
import InertialVsNonInertialDiagram from './InertialVsNonInertialDiagram'
import ForceVsNoForceDiagram from './ForceVsNoForceDiagram'
import BlockAgainstWallDiagram from './BlockAgainstWallDiagram'
import DoubleInclineDiagram from './DoubleInclineDiagram'
import TwoBlocksForceDiagram from './TwoBlocksForceDiagram'
import BlockOnRoughInclineDiagram from './BlockOnRoughInclineDiagram'
import ForceComponentsDiagram from './ForceComponentsDiagram'

const DIAGRAMS = {
  ramp_angles: RampAnglesDiagram,
  reference_frame: ReferenceFrameDiagram,
  inertial_vs_noninertial: InertialVsNonInertialDiagram,
  force_vs_noforce: ForceVsNoForceDiagram,
  block_against_wall: BlockAgainstWallDiagram,
  double_incline: DoubleInclineDiagram,
  two_blocks_force: TwoBlocksForceDiagram,
  block_on_rough_incline: BlockOnRoughInclineDiagram,
  force_components: ForceComponentsDiagram,
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
