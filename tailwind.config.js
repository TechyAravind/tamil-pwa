/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      fontFamily: {
        tamil: ['"Noto Sans Tamil"', 'serif']
      },
      colors: {
        primary:  { DEFAULT: '#8B0000', light: '#A52020', dark: '#5C0000' },
        cream:    { DEFAULT: '#FFF8F0', dark: '#F5EDE0' },
        gold:     { DEFAULT: '#C8A84B', light: '#E0C870' },
        pos: {
          noun:   '#1A5276',  // பெயர்ச்சொல் — blue
          verb:   '#145A32',  // வினைச்சொல் — green
          particle: '#7D6608', // இடைச்சொல் — yellow-brown
          uri:    '#6E2F8B'   // உரிச்சொல் — purple
        }
      },
      animation: {
        'fade-in': 'fadeIn 0.15s ease-in',
        'slide-down': 'slideDown 0.2s ease'
      },
      keyframes: {
        fadeIn:    { from: { opacity: 0, transform: 'scale(0.95)' }, to: { opacity: 1, transform: 'scale(1)' } },
        slideDown: { from: { maxHeight: '0', opacity: 0 }, to: { maxHeight: '2000px', opacity: 1 } }
      }
    }
  },
  plugins: []
}
