import katex from 'katex'

// Renders text that may contain:
//  - inline LaTeX segments delimited by $...$
//  - a whole line wrapped in $$...$$ -> rendered as a centered,
//    larger "block" equation on its own line (the "Presentation
//    model" formatting: formulas get their own neatly-aligned line)
//  - a line starting with "- " -> rendered as a bulleted list item
//  - plain newlines as separate paragraph blocks
// Used everywhere lesson/question copy is shown.

function renderInline(line, keyPrefix) {
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

function renderBlockEquation(latex, key) {
  try {
    const html = katex.renderToString(latex, { throwOnError: false, output: 'html', displayMode: true })
    return (
      <span key={key} className="block text-center my-3" dangerouslySetInnerHTML={{ __html: html }} />
    )
  } catch {
    return <span key={key} className="block text-center my-3">{latex}</span>
  }
}

export default function RichText({ text, className = '' }) {
  if (!text) return null
  const lines = String(text).split('\n')

  // Single-line, non-block, non-bullet text (the common case for option
  // labels, table cells, correct-answer sentences, etc.) renders with no
  // block wrapper at all, so it stays truly inline when embedded mid-sentence.
  if (lines.length === 1 && !lines[0].trim().startsWith('- ') && !lines[0].trim().match(/^\$\$(.+)\$\$$/)) {
    return <span className={className}>{renderInline(lines[0], 'single')}</span>
  }

  return (
    <span className={className}>
      {lines.map((line, li) => {
        const blockMatch = line.trim().match(/^\$\$(.+)\$\$$/)
        if (blockMatch) {
          return renderBlockEquation(blockMatch[1], li)
        }
        if (line.trim().startsWith('- ')) {
          return (
            <span key={li} className="flex gap-2 mb-1.5 last:mb-0">
              <span className="text-[#8E44AD] shrink-0">•</span>
              <span className="flex-1">{renderInline(line.trim().slice(2), li)}</span>
            </span>
          )
        }
        return (
          <span key={li} className={li < lines.length - 1 ? 'block mb-2 last:mb-0' : 'block'}>
            {line === '' ? ' ' : renderInline(line, li)}
          </span>
        )
      })}
    </span>
  )
}
