{**
 * Quince — nadpisanie modułu ps_newproducts.
 *
 * Nowości na stronie głównej, w tej samej karuzeli, co pozostałe zajawki.
 *}

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$products
  qId='new'
  qKontener=true
  qTytul={l s='Latest arrivals' d='Shop.Theme.Catalog'}
  qWiecej=$allNewProductsLink
  qWiecejNapis={l s='All new products' d='Shop.Theme.Catalog'}}
