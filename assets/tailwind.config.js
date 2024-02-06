// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const fs = require("fs");
const path = require("path");
const defaultTheme = require("tailwindcss/defaultTheme");
const plugin = require("tailwindcss/plugin");

module.exports = {
  content: [
    "./scrypts/**/*.js",
    "../lib/shppd_web.ex",
    "../lib/shppd_web/**/*.*ex",
  ],

  theme: {
    extend: {
      colors: {
        brand: {
          50: "#fff8eb",
          100: "#feebc7",
          200: "#fdd68a",
          300: "#fcbb4d",
          400: "#fba123",
          500: "#f57e0b",
          600: "#d95a06",
          700: "#b43b09",
          800: "#922e0e",
          900: "#78270f",
          950: "#451103",
        },
      },
      fontFamily: {
        sans: ["InterVariable", ...defaultTheme.fontFamily.sans],
      },
    },
  },

  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", [
        ".phx-no-feedback&",
        ".phx-no-feedback &",
      ]),
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ]),
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ]),
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ]),
    ),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    plugin(function ({ matchComponents, theme }) {
      const iconsDir = path.join(__dirname, "./vendor/heroicons/optimized");
      const values = {};
      const icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
      ];

      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          const name = path.basename(file, ".svg") + suffix;
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
        });
      });

      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            const content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, "");

            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              "-webkit-mask": `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              "mask-repeat": "no-repeat",
              "background-color": "currentColor",
              "vertical-align": "middle",
              display: "inline-block",
              width: theme("spacing.5"),
              height: theme("spacing.5"),
            };
          },
        },
        { values },
      );
    }),
  ],
};
