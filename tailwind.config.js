module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {
      colors: {
        'light-gray': '#cccccc',
        'primary-link': '#72c02c',
        'med-border': 'grey',
        'light-border': '#cccccc',
        'background': '#e8e8e8',
        'rentme-black': '#222222',
        'rentme-green': '#59C9A5',
        'rentme-green-secondary': '#51B796',
        'rentme-blue': '#3EA2F7',
        'rentme-blue-secondary': '#3893E2',
        'rentme-yellow': '#FEEA2F',
        'rentme-navy': '#152A4C',
      },
      fontFamily: {
        'sans': ['Rubik', 'Lucida', 'Verdana', 'sans-serif'],
      },
    },
  },
  plugins: [],
};