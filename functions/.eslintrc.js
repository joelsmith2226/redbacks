module.exports = {
  "root": true,
  "env": {
    "es6": true,
    "node": true,
  },
  "extends": [
    "eslint:recommended",
    "google",
  ],
  "rules": {
    "quotes": ["error", "double"],
    "no-restricted-imports": ["error", "import1", "import2"],
  },

  "parserOptions": {
    "sourceType": "module",
  },

};
