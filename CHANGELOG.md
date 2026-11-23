# Changelog

All notable changes to this theme are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the versioning follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.22] - 2026-11-23

### Changed

- Search suggestions: the list has the shadow of the category menu panel, which opens
  from the header over the page in the same way. With the light shadow of an ordinary
  list it blended into the page under it.

## [0.1.21] - 2026-11-23

### Fixed

- Product gallery: the picture on the page comes from the `medium_default` image type
  (square, the size of the frame) and only the zoom loads `large_default`. Before, the
  page used `large_default` too, so with that type keeping the picture's own
  proportions a tall picture ran out of the square frame.
- Subcategory tiles: the pictures and names of the folded tiles no longer show over
  the bottom of the first row.
- Product lists, list view: the availability label takes only the room it needs, so
  "Last items in stock" stays on one line. The labels of availability and shipping
  keep one column.

### Changed

- Product lists, list view: the picture keeps a margin from the frame on every side,
  the same as the text next to it. Pictures cropped to the product touched the left
  edge of the card.

## [0.1.20] - 2026-11-23

### Changed

- Product gallery on a phone: the strip of thumbnails, as on a computer, instead of
  dots. The dots were too small to tap. Quick view keeps the dots.
- Product lists on a phone: products always stand as tiles and the grid/list switch is
  not shown. The list view, chosen by the customer or set as the shop default, comes
  back on a wider screen.
- Subcategory tiles on a phone: four in a row (two per column of products), as on a
  computer. Before, two wide tiles filled the row.

### Added

- Product gallery on a phone: swiping the picture left or right shows the next or the
  previous one. A vertical swipe scrolls the page, a tap still opens the zoom.

### Fixed

- Subcategory tiles: the folded rows no longer show slivers of the hidden tiles under
  the first row.
- Search suggestions on a phone: the list lines up with the page content under the
  header, with the same margin on both sides. Before, it started at the field, after
  the menu button, and a long product name pushed it off the right edge of the screen.
- Product gallery: the chosen thumbnail moves to the middle of the strip, so the next
  thumbnails come into view. Before, clicking the last visible thumbnail left the
  strip where it was and it was not clear whether more pictures followed.

## [0.1.19] - 2026-11-23

### Changed

- Product gallery, its zoom window and quick view load the picture formats the shop
  generates (**Design → Image settings**): WebP, and AVIF when it is on, with JPEG
  for a browser without them. Before, they always loaded JPEG, two to three times
  heavier than WebP.

## [0.1.18] - 2026-11-23

### Fixed

- Product list filters: an open group that ends with "Show more" is closed by the lines
  of the button only, without the separator of the next group right under them. The
  lines take the separator colour.

## [0.1.17] - 2026-11-23

### Added

- Product list filters: a long filter group shows its first values and a "Show more"
  button with the number of hidden values; "Show less" folds it again. The number of
  values is set in **Quince Engine → Product lists → Filters** (10 by default). A
  selected value always stays in view, and a group that would hide only one or two
  values shows them all. An opened group stays open after narrowing the list. Needs
  Quince Engine 0.10.8.

### Changed

- Category menu, columns layout: subcategories fill a column from top to bottom, down
  to the height of the department list, before the next column starts, up to the
  number of columns set in Quince Engine. Before, two subcategories stood one per
  column and read like a row.

## [0.1.16] - 2026-11-22

### Fixed

- Category menu, cascade layout, opened from the header after scrolling: the panel is
  as wide as the categories button and the subcategories slide out next to it. Before,
  it stretched across the whole screen and the subcategories were off the edge.

## [0.1.15] - 2026-11-22

### Fixed

- Product lists, list view: features stand in the left column, and brand, reference,
  EAN and MPN in the right one. Before, one list was split in half by rows, so on a
  product with few features the brand moved to the left column.

## [0.1.14] - 2026-11-22

### Added

- Subcategory tiles: a subcategory without its own thumbnail shows its category image,
  as set by the switch in **Quince Engine → Product lists → Subcategories**. The
  thumbnail still comes first.

## [0.1.13] - 2026-11-21

### Added

- Product page, dictionaries: a table longer than 100 rows shows the shop pagination
  under it and loads the next pages without reloading; the search field searches the
  whole table. Needs Quince Dictionaries 0.3.2.

### Fixed

- Mobile menu: the logo in the panel heading keeps its proportions. A wide logo on a
  narrow screen was squeezed.

### Changed

- Mobile menu: the panel heading takes the colours of the header after scrolling, and
  the logo in it the same version as there (the separate logo file, or the same
  colour treatment).

## [0.1.12] - 2026-11-17

### Fixed

- Product cards follow **Quince Engine → Product card**: every switch of the tile and
  the row works (badges and their kinds, quick view, favourites, promotion countdown,
  brand, rating, lowest price note, and in the row the description, number of
  features, codes, availability and shipping time). Before, the cards showed
  everything whatever the screen said. Badge kinds need Quince Engine 0.10.4.

## [0.1.11] - 2026-11-17

### Changed

- Image sizes in `theme.yml` match the places that show them, up to a 1920 px page
  and double-density screens: small 200, cart 250, home 450, medium 800, large
  1600, category 300 (all square). They apply to a new install of the theme; an
  existing shop keeps its sizes until they are changed and the thumbnails are
  regenerated.
- Product cards offer the browser three picture widths (home, medium, large) and
  tell it how wide the card is, from the page width and the number of columns set
  in Quince Engine (page width needs Quince Engine 0.10.3). Before, the browser assumed a 300 px card on every large screen
  and could only pick between two small files.

- Product details tab: two tables in one tab. First the features from the catalogue
  under "Specification", then brand, reference, stock, condition and codes under
  "Product information". Before, both were mixed in one table.
- Specification tables run the full width of the tab, with the same margin on the
  left and on the right. Before, they stopped at 44rem.

### Fixed

- Product cards show the whole picture, as in the category design. Before, the
  picture was cropped to fill the frame and tall or wide products lost their ends.
- Product cards, list view: the picture frame keeps its square (16rem, 12rem on
  a medium screen, 7.5rem on a phone) and sits in the middle of the row. Before,
  a tall picture stretched the whole row.
- Product cards: a tall picture no longer runs below the square frame. The frame
  cut off its bottom.
- Questions and answers with no questions yet: the button sits right under the
  sentence, as in reviews. Before, it stood lower, in a separate row.

## [0.1.10] - 2026-11-16

### Fixed

- Product gallery: zoom on a product with one picture opens the picture. Before,
  the window opened empty.

## [0.1.9] - 2026-11-16

### Added

- Brands page in the Quince design: breadcrumb and title as on a product list,
  brands as square tiles (the same tiles as subcategories) with the logo, the name
  and the number of products. A brand without a logo shows the name only.
- Suppliers page in the same design as the brands page (shown when the shop
  displays suppliers).
- Brand page: the cover element shows the brand logo, as a category page shows
  the category image. The image of a category or a brand sits in a square card.
- Brand page: the long description of the brand shows at the bottom of the page.

### Fixed

- Product lists with the load-more button: quick view and the wishlist heart work
  on the products added by the button. Before, only the first page had them.
- Wishlist heart for a customer who is not signed in: it opens the sign-in page.
  On some pages it went to `/undefined`.
- Availability: the coloured dot sits level with the text. On the product page
  it sat a few pixels lower.
- Product card: badges on the image stand in one row and wrap only when they do
  not fit the width of the image. Before, each badge took its own row.

### Changed

- "Ask an expert" drawer: the form checks every field the shop marks as required
  and sends the phone number (Quince Contacts 0.5.0).

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
