module.exports = {
  content: ['./**/*.slim', './src/**/*.svg', './src/**/*.js', './src/**/*.svelte'],
  extractors: [
    {
      extensions: ['slim', 'html', 'svg', 'js', 'svelte'],
      extractor: class TailwindExtractor {
        static extract (content) {
          return content.match(/[A-Za-z0-9-_:\/]+/g) || []
        }
      },
    },
  ],
}
