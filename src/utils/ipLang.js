// Bilingual helpers for the Interactive Physics engine.
// `pick` falls back to the English value whenever a Tamil field is
// missing, so lessons without translations yet still work fine when
// the student switches the toggle.
export function pick(lang, en, ta) {
  if (lang === 'ta' && ta) return ta
  return en
}

// Fixed UI-chrome strings (step labels, buttons, banners) — not lesson
// content, so these are hand-translated once here rather than per-row.
export const UI_STRINGS = {
  stepLabel: {
    motivation: { en: 'Hook', ta: 'கவனஈர்ப்பு' },
    explanation: { en: 'Explanation', ta: 'விளக்கம்' },
    example: { en: 'Example', ta: 'உதாரணம்' },
    question: { en: 'Question', ta: 'கேள்வி' },
  },
  next: { en: 'Next →', ta: 'அடுத்து →' },
  finish: { en: 'Finish Lesson', ta: 'பாடத்தை முடி' },
  submit: { en: 'Submit', ta: 'சமர்ப்பி' },
  submitAnswers: { en: 'Submit Answers', ta: 'பதில்களை சமர்ப்பி' },
  dontKnow: { en: "I don't know", ta: 'எனக்குத் தெரியாது' },
  correct: { en: 'Correct!', ta: 'சரி!' },
  incorrect: { en: 'Not quite.', ta: 'சரியில்லை.' },
  hereIsAnswer: { en: 'Here’s the answer:', ta: 'இதோ பதில்:' },
  correctAnswerLabel: { en: 'Correct answer:', ta: 'சரியான பதில்:' },
  takeaway: { en: 'Takeaway:', ta: 'முக்கிய கருத்து:' },
  showExplanation: { en: 'Show explanation', ta: 'விளக்கத்தைக் காட்டு' },
  hideExplanation: { en: 'Hide explanation', ta: 'விளக்கத்தை மறை' },
  solution: { en: 'Solution', ta: 'தீர்வு' },
  commonMistake: { en: 'Common mistake: ', ta: 'பொதுவான தவறு: ' },
  selectEllipsis: { en: '— select —', ta: '— தேர்ந்தெடு —' },
  clearMatches: { en: 'Clear matches', ta: 'பொருத்தங்களை அழி' },
  dragToMatch: { en: 'Drag a line from the right to its match on the left.', ta: 'வலதுபுறத்திலிருந்து இடதுபுறம் உள்ள சரியான பொருத்தத்திற்கு ஒரு கோட்டை இழுக்கவும்.' },
  langToggle: { en: 'தமிழ்', ta: 'English' }, // shows the OTHER language's name, as a switch button
}

export function ui(key, lang) {
  const entry = UI_STRINGS[key]
  if (!entry) return ''
  return lang === 'ta' ? entry.ta : entry.en
}
