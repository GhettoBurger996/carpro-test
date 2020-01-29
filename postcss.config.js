module.exports = {
  parser: 'postcss-scss',
  plugins: {
    'autoprefixer': {},
    'postcss-easy-import': {},
    'postcss-css-variables': {},
    'postcss-easy-media-query': {},
    'tailwindcss': 'tailwind.config.js',
    'postcss-nested': {},
    'postcss-fontpath': { checkFiles: true, ie8Fix: true },
    '@fullhuman/postcss-purgecss': process.env.NODE_ENV === 'production',
    'cssnano': process.env.NODE_ENV === 'production',
  },
}
