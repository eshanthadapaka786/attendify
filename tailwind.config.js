/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        yarn: {
          50: '#FAF8F5',
          100: '#F5EFE6',
          200: '#EBDDCF',
          300: '#DFC6B2',
          400: '#CCA88E',
          500: '#B88B6E',
          600: '#9E6E52',
          700: '#7E533E',
          800: '#5F3F30',
          900: '#3D281F',
        },
        terracotta: {
          50: '#FDF6F3',
          100: '#FAECE6',
          200: '#F5D7CB',
          300: '#EEB9A6',
          400: '#E29074',
          500: '#C86242',
          600: '#B25437',
          700: '#94422A',
          800: '#763523',
          900: '#5E2C1D',
        },
        sage: {
          50: '#F4F7F4',
          100: '#E6EDE7',
          200: '#CDDCCF',
          300: '#ABC2AE',
          400: '#84A489',
          500: '#5C7C64',
          600: '#4A6550',
          700: '#3C5141',
          800: '#314235',
          900: '#27352B',
        },
        amberwarm: {
          50: '#FDFBF7',
          100: '#FAF4E8',
          200: '#F4E5C7',
          300: '#ECD2A1',
          400: '#DFB86C',
          500: '#D08C36',
          600: '#B67127',
          700: '#93541E',
          800: '#77431C',
          900: '#60361A',
        },
        cream: {
          base: '#FAF7F2',
          card: '#FFFFFF',
          soft: '#F4EFEA',
          muted: '#ECE5DC',
          border: '#E4DDD4',
          borderStrong: '#D1C4B5',
        },
        espresso: {
          900: '#221B18',
          800: '#342B27',
          700: '#4C403A',
          600: '#685A52',
          500: '#87786E',
          400: '#A99B91',
        }
      },
      fontFamily: {
        serif: ['"Playfair Display"', 'Georgia', 'serif'],
        sans: ['"Plus Jakarta Sans"', 'Inter', 'system-ui', 'sans-serif'],
        mono: ['"JetBrains Mono"', 'monospace'],
      },
      boxShadow: {
        'soft-sm': '0 2px 6px -1px rgba(76, 64, 58, 0.06), 0 1px 4px -1px rgba(76, 64, 58, 0.04)',
        'soft-md': '0 6px 18px -3px rgba(76, 64, 58, 0.08), 0 3px 8px -2px rgba(76, 64, 58, 0.04)',
        'soft-lg': '0 14px 28px -4px rgba(76, 64, 58, 0.09), 0 6px 12px -3px rgba(76, 64, 58, 0.05)',
      }
    },
  },
  plugins: [],
}
