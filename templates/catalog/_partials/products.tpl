{**
 * Quince: pojemnik listy produktów.
 *
 * Identyfikator `js-product-list` jest wymagany przez rdzeń: po nim podmieniana
 * jest lista przy zawężaniu filtrami.
 *
 * Pusta lista ma swój stan TUTAJ, a nie w szablonie strony. Ten sam plik rdzeń
 * renderuje drugi raz, gdy odsyła zawężoną listę bez przeładowania strony.
 * Stan pustej listy piętro wyżej nie pokazałby się po zawężeniu.
 *
 * Stronicowania tu nie ma. Jest elementem strefy „Pod listą", więc sklep może
 * je wyłączyć albo przesunąć, a druga kopia w tym miejscu renderowałaby je
 * dwa razy.
 *}
<div id="js-product-list">
  {if $listing.products|count}
    {include file='catalog/_partials/productlist.tpl' products=$listing.products}
  {else}
    {include file='catalog/_partials/listing-empty.tpl'}
  {/if}
</div>
