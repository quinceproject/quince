{**
 * Quince: akcesoria i produkty powiązane pod kartą produktu.
 *
 * Dane przynosi rdzeń w `$accessories`. Wygląd i zachowanie niesie karuzela,
 * ta sama co przy ostatnio oglądanych. Włączniki przychodzą z panelu przez
 * `pdp-element.tpl`, razem z tytułem ustawionym w panelu (`qTytulWlasny`);
 * pusty zostawia tytuł domyślny.
 *}

{if $qTytulWlasny|default:'' != ''}
  {assign var=qTytulAkcesoriow value=$qTytulWlasny}
{else}
  {capture name='qTytulAkcesoriow'}{l s='Accessories and related products' d='Shop.Theme.Catalog'}{/capture}
  {assign var=qTytulAkcesoriow value=$smarty.capture.qTytulAkcesoriow}
{/if}

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$accessories
  qId='accessories'
  qIkona='accessories'
  qIle=$qIle|default:8
  qStrzalki=$qStrzalki|default:true
  qTytul=$qTytulAkcesoriow}
