{**
 * Quince: akcesoria i produkty powiązane pod kartą produktu.
 *
 * Dane przynosi rdzeń w `$accessories`. Wygląd i zachowanie niesie karuzela,
 * ta sama co przy ostatnio oglądanych. Włączniki przychodzą z panelu przez
 * `pdp-element.tpl`.
 *}

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$accessories
  qId='accessories'
  qIkona='accessories'
  qIle=$qIle|default:8
  qStrzalki=$qStrzalki|default:true
  qTytul={l s='Accessories and related products' d='Shop.Theme.Catalog'}}
