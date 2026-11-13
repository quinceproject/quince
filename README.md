# Quince

**A storefront theme for PrestaShop 9.2, set up from the back office with Quince Engine.**

Quince draws the shop. What it shows and how it looks (colours, typography, the
header, menu and footer, the home page, the product page, product lists, the cart
and the checkout) is set in [Quince Engine](https://github.com/quinceproject/quince_engine),
without editing templates. The theme reads those settings and renders them.

> Quince is a free, open-source theme (OSL-3.0). There is nothing to buy.
> If it saves you time, you can support development, see
> [Supporting the project](#supporting-the-project).

---

## Features

- **Every page of the shop.** Home, category, brand, supplier, search and other
  product lists, product page, cart, checkout step by step and on one page, order
  confirmation, customer account, CMS pages, contact, sitemap, stores and error pages.
- **Set up in the back office, not in code.** Quince Engine writes the colours,
  shades, spacing, typography and the arrangement of each page as CSS variables and
  settings; the theme uses them. Changing the brand colour or moving an element on
  the product page does not need a developer.
- **No Bootstrap.** The theme has its own stylesheets on design tokens, so the pages
  carry only what they use.
- **Scripts only where needed.** Each interactive part (search suggestions, main
  menu, cart drawer, quick view, product gallery, variant switching, countdowns,
  mobile bar, toasts, form checks) is a small script that runs only when its part is
  on the page.
- **Company or private buyer.** The checkout asks how the customer buys, shows the
  company fields when needed, and saves a second address (delivery or invoice) in the
  same step. With Quince Engine it can fill the company details from the EU VIES
  register.
- **Native modules styled.** The theme ships templates for the PrestaShop modules it
  works with: main menu, search, cart, customer sign-in, language and currency
  selectors, link lists, contact details, newsletter, product comments, wishlist,
  email alerts, faceted search, reassurance, one page checkout, GDPR and others.
- **Quince modules styled.** Blog, cross-selling, product sections, slider, questions
  and answers, contact experts, offers, omnibus price note, product safety (GPSR) and
  the others have their places in the templates.
- **Fonts from the shop's own server.** Inter, Lexend and Nunito Sans are bundled,
  so a visitor's browser does not contact another server for them.
- **Multilingual.** English base. The theme's own texts have a Polish translation;
  the rest comes from PrestaShop's language packs.

## Requirements

| Requirement | Version |
|-------------|---------|
| PrestaShop  | 9.2 (tested on 9.2.0) |
| PHP         | 8.4 (tested), 8.1 or newer required |
| [Quince Engine](https://github.com/quinceproject/quince_engine) | required |

Quince Engine holds the settings the theme renders. Without it the pages have no
colours, no layout settings and no arrangement. Install the engine first.

The theme also expects the usual PrestaShop modules on their hooks (main menu,
search, shopping cart, customer sign-in, language and currency selectors, link
list, contact info, featured products). They come with PrestaShop.

## Installation

The release ZIP is ready to import. Nothing needs to be built.

**From the back office**

1. Download the latest **`quince.zip`** from the
   [**Releases**](https://github.com/quinceproject/quince/releases) page.
2. In the back office go to **Design → Theme & Logo → Add new theme**, choose
   **Import from your computer** and pick the ZIP.
3. Click **Use this theme** under Quince.

**By copying the files to the server**

1. Unpack the release ZIP into a folder called `quince`.
2. Upload that folder to the `themes/` directory of the shop, for example by FTP.
3. In **Design → Theme & Logo** click **Use this theme** under Quince.

**From Quince Engine**

With Quince Engine installed, **Quince project → Quince modules** installs and updates
the theme from the Quince release list. Then click **Use this theme** under Quince in
**Design → Theme & Logo**.

**With Composer**

A PrestaShop shop ships without a `composer.json` of its own, so Quince packages are
installed from a separate folder next to the shop. The one-time setup of that folder is
described in the [Quince Engine README](https://github.com/quinceproject/quince_engine#installation).
Then, from that folder:

```sh
composer require "quinceproject/theme:*"
```

Composer puts the theme in `themes/quince`. Click **Use this theme** under Quince in
**Design → Theme & Logo**.

> ⚠️ Prefer the release ZIP over the green **Code → Download ZIP** button. That
> archive has the repository files in a subfolder and also carries the repository's
> own files, so PrestaShop's import does not accept it as it is.

## Configuration

Open **Quince project → Quince Engine** in the back office menu. The engine's screens
set up the theme: Design (colours, shades, typography, shape and grid), Sections (top
bar, header, main menu, footer) and Pages (home page, product page, product card,
product lists, cart, checkout).

## License

Code: [Open Software License 3.0 (OSL-3.0)](LICENSE.md). It is a reciprocal licence:
whoever modifies and distributes this theme has to publish the changes under the same
licence and keep the original copyright and author notices.

Quince is based on [PrestaShop Hummingbird](https://github.com/PrestaShop/hummingbird)
(AFL-3.0) by PrestaShop Team and Contributors: the structure of the templates comes
from it. The templates of PrestaShop modules, the bundled fonts and images keep their
own licences, listed in [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

**The name "Quince" is not covered by the code licence.** A fork may use the code; it
may not use the name.

© 2026 Marcin Gajewski

## Supporting the project

Quince is a free download and there is nothing to buy. If it is useful to you, you can
support its development by buying me a coffee:

**[buymeacoffee.com/marcingajewski](https://buymeacoffee.com/marcingajewski)**
