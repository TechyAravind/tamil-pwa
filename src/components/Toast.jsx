import { useEffect } from 'react'

/**
 * Simple toast notification.
 * Usage: <Toast message="Saved!" type="success" onClose={() => setToast(null)} />
 */
export default function Toast({ message, type = 'success', onClose }) {
  useEffect(() => {
    const t = setTimeout(onClose, 3000)
    return () => clearTimeout(t)
  }, [])

  const colors = {
    success: 'bg-green-600',
    error:   'bg-red-600'
  }

  return (
    <div className={`fixed bottom-6 right-6 z-50 ${colors[type]} text-white
                     px-5 py-3 rounded-xl shadow-lg animate-fade-in flex items-center gap-3`}>
      <span>{type === 'success' ? '✓' : '✕'}</span>
      <span>{message}</span>
      <button onClick={onClose} className="ml-2 text-white/70 hover:text-white">✕</button>
    </div>
  )
}
