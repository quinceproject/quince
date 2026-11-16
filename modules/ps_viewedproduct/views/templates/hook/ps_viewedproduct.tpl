{**
 * Quince: nadpisanie modułu ps_viewedproduct.
 *
 * Moduł daje listę ostatnio oglądanych produktów, motyw daje jej wygląd: tę
 * samą karuzelę, co akcesoria pod kartą produktu.
 *
 * Na karcie produktu blok stoi tam, gdzie postawi go panel sklepu (element
 * „Recently viewed" w strefie zajawek), a nie na końcu strony. Dlatego
 * szablon produktu wyłącza ten moduł ze zbiorczego hooka stopki.
 *
 * Włączniki czytamy z mapy silnika, a nie z parametrów: moduł renderuje się
 * hookiem i nie wie nic o elemencie, który go postawił.
 *}

{assign var=qOpcje value=$modules.quince_engine.product.options.recently_viewed|default:[]}

{* Tytuł ustawiony w panelu strony produktu ma pierwszeństwo; pusty zostawia
   tytuł domyślny. *}
{* Przez assign, nie capture: capture zakodowałby tekst, a karuzela koduje go
   jeszcze raz przy wypisaniu. *}
{if $qOpcje.title[$language.id]|default:'' != ''}
  {assign var=qTytulOgladanych value=$qOpcje.title[$language.id]}
{else}
  {capture name='qTytulOgladanych'}{l s='Recently viewed' d='Shop.Theme.Catalog'}{/capture}
  {assign var=qTytulOgladanych value=$smarty.capture.qTytulOgladanych}
{/if}

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$products
  qId='viewed'
  qIkona='clock'
  qIle=$qOpcje.count|default:8
  qStrzalki=$qOpcje.nav|default:true
  qTytul=$qTytulOgladanych}
