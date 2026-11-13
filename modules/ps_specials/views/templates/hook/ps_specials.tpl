{**
 * Quince: nadpisanie modułu ps_specials.
 *
 * Promocje na stronie głównej, w tej samej karuzeli, co pozostałe zajawki.
 *}

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$products
  qId='specials'
  qKontener=true
  qTytul={l s='Special deals' d='Shop.Theme.Catalog'}
  qWiecej=$allSpecialProductsLink
  qWiecejNapis={l s='All discounts' d='Shop.Theme.Catalog'}}
