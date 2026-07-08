import { motion } from 'framer-motion'

const COMBINE_THRESHOLD = -34

export default function DraggableCombineUnit({ children, onCombine, active, onDragStateChange }) {
  if (!active) return children

  return (
    <motion.span
      className="inline-flex relative"
      style={{ touchAction: 'pan-y' }}
      drag="x"
      dragConstraints={{ left: -50, right: 8 }}
      dragElastic={0.25}
      dragSnapToOrigin
      whileDrag={{ scale: 1.1, zIndex: 30 }}
      onDragStart={() => onDragStateChange?.(true)}
      onDragEnd={(_e, info) => {
        onDragStateChange?.(false)
        if (info.offset.x <= COMBINE_THRESHOLD) onCombine()
      }}
    >
      <span
        className="absolute -left-4 top-1/2 -translate-y-1/2 text-primary/70 text-xs
                   pointer-events-none animate-pulse select-none"
        aria-hidden="true"
      >
        ⟵
      </span>
      {children}
    </motion.span>
  )
}
