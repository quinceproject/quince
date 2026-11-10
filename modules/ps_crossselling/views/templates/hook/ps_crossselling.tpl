{**
 * Quince — nadpisanie modułu ps_crossselling.
 *
 * Produkty kupowane razem z oglądanym. Moduł daje listę, motyw daje jej wygląd:
 * tę samą karuzelę, co pozostałe zajawki.
 *}

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$products
  qId='crossselling'
  qKontener=true
  qTytul={l s='Clients also bought' d='Shop.Theme.Catalog'}}
