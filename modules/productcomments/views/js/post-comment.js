/**
 * Skrypt okna „napisz opinię" modułu — celowo pusty.
 *
 * Moduł wgrywa go na każdej karcie produktu i zaraz na starcie sięga po
 * `productCommentMandatoryMessage`, zmienną, którą definiuje jego szablon
 * modala. Tego modala nie wypisujemy: formularz opinii jest w motywie, jako
 * szuflada przy sekcji opinii w akordeonie (`catalog/_partials/product-reviews.tpl`).
 * Skrypt wywracał się więc na niezdefiniowanej zmiennej przy każdym wejściu
 * na kartę produktu.
 *
 * Pusty plik zamiast wyrejestrowania `displayHeader`: tym samym hookiem moduł
 * wgrywa też `productListingComments.js` i wtyczkę gwiazdek, a te mają co robić.
 *
 * Tak samo wyciszone są jego szablony i arkusz — patrz sąsiednie pliki
 * w `themes/quince/modules/productcomments/`.
 */
