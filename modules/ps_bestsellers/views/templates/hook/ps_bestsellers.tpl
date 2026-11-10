{**
 * Quince — nadpisanie modułu ps_bestsellers.
 *
 * Bestsellery na stronie głównej, w tej samej karuzeli, co pozostałe zajawki.
 *}

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$products
  qId='bestsellers'
  qKontener=true
  qTytul={l s='Best sellers' d='Shop.Theme.Catalog'}
  qWiecej=$allBestSellers
  qWiecejNapis={l s='All best sellers' d='Shop.Theme.Catalog'}}
