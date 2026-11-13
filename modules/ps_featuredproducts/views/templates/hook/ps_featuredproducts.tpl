{**
 * Quince: nadpisanie modułu ps_featuredproducts.
 *
 * Produkty polecane na stronie głównej, w tej samej karuzeli, co zajawki pod
 * kartą produktu. Odnośnik do pełnej listy wchodzi do nagłówka sekcji: pod
 * taśmą stał jako przycisk konturowy i ważył tyle, co zakup.
 *}

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$products
  qId='featured'
  qKontener=true
  qTytul={l s='Featured products' d='Shop.Theme.Catalog'}
  qWiecej=$allProductsLink
  qWiecejNapis={l s='All featured products' d='Shop.Theme.Catalog'}}
