# Changelog

All notable changes to this theme are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the versioning follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.8] - 2026-11-16

### Changed

- Account menu in the header, for a customer who is not signed in: under "Welcome!"
  one sentence says why to sign in ("Sign in to track your orders and buy faster").

### Fixed

- Category menu (column layout): the department list scrolls only vertically. A
  department name longer than the column no longer adds a horizontal scrollbar.

## [0.1.7] - 2026-11-16

### Added

- Sign-in and registration pages in the Quince design: the form in a card on the
  left, account benefits on the right (set in **Quince Engine → Sign-in and
  registration**, needs Quince Engine 0.10.0). Email and password, first and last
  name side by side, consents grouped, the button on the right. The forms stay
  PrestaShop's own: the same fields, action, `back` field and the engine's form
  guard. The sign-in form in the checkout and the account details form are not
  changed.
- Polish translations for the new texts. "Social title" now reads "Zwrot
  grzecznościowy" instead of the core's "Nazwa kontaktu".

### Fixed

- Category menu: the open panel is as wide as the menu bar and starts under the
  Categories button. Before, on a screen wider than the page it was narrower and
  shifted inwards.
- Category menu (column layout): the panel ends above the bottom of the screen, with
  a gap, and the department list and the subcategories scroll inside it.
- Customer Reassurance icons take the theme colour. The module's own icon colour
  setting (blue by default) no longer shows through.

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
