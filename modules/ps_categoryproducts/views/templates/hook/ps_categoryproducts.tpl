{**
 * Quince: nadpisanie modułu ps_categoryproducts.
 *
 * Produkty z tej samej kategorii pod kartą produktu. Moduł daje listę, motyw
 * daje jej wygląd: tę samą karuzelę, co akcesoria i ostatnio oglądane.
 *
 * Na karcie produktu blok stoi tam, gdzie postawi go panel sklepu (element
 * „Products from the same category" w strefie karuzel), a nie na końcu
 * strony. Włączniki czytamy z mapy silnika, bo moduł renderuje się hookiem
 * i nie wie nic o elemencie, który go postawił.
 *
 * Tytuł składamy przed dołączeniem: w parametrze dołączenia nie da się postawić
 * warunku, a liczba pojedyncza i mnoga to dwa różne napisy do tłumaczenia.
 *}

{assign var=qOpcje value=$modules.quince_engine.product.options.category_products|default:[]}

{if $products|@count == 1}
  {capture name='qTytulKategorii'}{l s='%s other product in the same category' sprintf=[$products|@count] d='Shop.Theme.Catalog'}{/capture}
{else}
  {capture name='qTytulKategorii'}{l s='%s other products in the same category' sprintf=[$products|@count] d='Shop.Theme.Catalog'}{/capture}
{/if}

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$products
  qId='category'
  qIle=$qOpcje.count|default:8
  qStrzalki=$qOpcje.nav|default:true
  qTytul=$smarty.capture.qTytulKategorii}
