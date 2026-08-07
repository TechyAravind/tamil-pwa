import katex from 'katex'

// Renders text that may contain inline LaTeX segments delimited by $...$
// (e.g. "The condition is $\\sum F_x = 0$ for equilibrium.") plus plain
// newlines as separate blocks. Used everywhere lesson/question copy is
// shown so authors can drop real equations into any content field.
function renderLine(line, keyPrefix) {
  const parts = line.split(/(\$[^$]+\$)/g)
  return parts.map((part, i) => {
    if (part.length > 1 && part.startsWith('$') && part.endsWith('$')) {
      const latex = part.slice(1, -1)
      try {
        const html = katex.renderToString(latex, { throwOnError: false, output: 'html' })
        return <span key={`${keyPrefix}-${i}`} dangerouslySetInnerHTML={{ __html: html }} />
      } catch {
        return <span key={`${keyPrefix}-${i}`}>{part}</span>
      }
    }
    return <span key={`${keyPrefix}-${i}`}>{part}</span>
  })
}

export default function RichText({ text, className = '' }) {
  if (!text) return null
  const lines = String(text).split('\n')
  return (
    <span className={className}>
      {lines.map((line, li) => (
        <span key={li} className={li < lines.length - 1 ? 'block mb-2 last:mb-0' : 'block'}>
          {line === '' ? ' ' : renderLine(line, li)}
        </span>
      ))}
    </span>
  )
}
