const plugin = require("tailwindcss/plugin");

function withOpacityValue(variable) {
  return ({ opacityValue }) => {
    if (opacityValue === undefined) {
      return `rgb(var(${variable}))`;
    }
    return `rgb(var(${variable}) / ${opacityValue})`;
  };
}

module.exports = {
  mode: "jit",
  content: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  safelist: [
    'tile-dark',
    'tile-light'
  ],
  theme: {
    extend: {
      colors: require("daisyui/colors"),
    },
  },
  variants: {
    extend: {},
  },
  plugins: [require("daisyui")],
  theme: {
    extend: {
      colors: {
        "light-square": withOpacityValue("--color-light-square"),
        "dark-square": withOpacityValue("--color-dark-square"),
        "light-square-highlight": withOpacityValue(
          "--color-light-square-highlight"
        ),
        "dark-square-highlight": withOpacityValue(
          "--color-dark-square-highlight"
        ),
      },
      width: {
        "1/8": "12.5%",
      },
      height: {
        "1/8": "12.5%",
      },
      padding: {
        full: "100%",
      },
    },
  },
  daisyui: {
    styled: true,
    themes: true,
    rtl: false
  },
};
