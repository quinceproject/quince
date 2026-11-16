# Changelog

All notable changes to this theme are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the versioning follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.6] - 2026-11-16

### Fixed

- 219 theme texts had no Polish translation and showed in English on a Polish shop,
  among them the product page tabs (Reviews, Questions and answers, Product safety),
  "Full specification", "Buy now", "Write the first review" and the carousel titles.
- Product gallery: the frame of the selected thumbnail and the hover frame are drawn
  over the picture. Before, a picture filling the whole thumbnail hid the top and the
  bottom of the frame.

## [0.1.5] - 2026-11-16

### Added

- Product page: spare parts, spare parts for, set items and in sets carousels (Quince
  Engine 0.9.0 and Quince Cross-selling 0.3.1).
- Product page carousels use the titles set in **Quince Engine → Product page →
  Carousels**.
- Product page dictionaries: number of entries in each dictionary and a search field
  for tables with more than 10 rows, with the theme's clear button (Quince
  Dictionaries 0.3.0).

## [0.1.4] - 2026-11-15

### Security

- Product reviews, product questions and answers, and feature values are escaped
  before line breaks are added. On the shop front PrestaShop turns the `escape`
  modifier off, so these texts went out as raw HTML: a review with a script ran for
  every visitor of the product page once the review was approved. Update now.
- Structured data (JSON-LD) escapes `<` and `>`, so a `</script>` in catalogue data
  cannot close the tag.
- The reviews island reads error messages through `DOMParser` instead of `innerHTML`.

## [0.1.3] - 2026-11-15

### Added

- The cart drawer shows the hook set in Quince Engine 0.7.2 (**Cart → Hook in the cart
  drawer**), under the suggested products.

## [0.1.2] - 2026-11-13

### Added

- The stuck header shows a separate logo file when one is set in Quince Engine 0.7.0
  (**Header → Logo after scrolling → Separate file**).

## [0.1.1] - 2026-11-13

### Changed

- The theme preview in the back office shows the Quince logo instead of the default
  PrestaShop screenshot.
- The account button label read by screen readers separates the customer's name from
  "My account" with a comma.
- Code comments tidied up. No change in how the shop works.

## [0.1.0] - 2026-11-10

First public release.

### Added

- Storefront templates for every PrestaShop page: home, category and other product
  lists, product page, cart, checkout (step by step and one page), order
  confirmation, customer account, CMS pages, contact, sitemap, stores and error
  pages.
- Layout, colours, typography and page arrangement driven by Quince Engine through
  CSS variables. No Bootstrap.
- Header with search suggestions, main menu, cart drawer, quick view, product
  gallery, countdowns, mobile bar and toasts, each as a small script that runs only
  where its part is on the page.
- Company or private buyer in the checkout, with the second address in the same step.
- Templates for the native PrestaShop modules the theme styles, and for the Quince
  modules.
- Self-hosted fonts: Inter, Lexend and Nunito Sans.
- Polish translation of the theme's own texts.
