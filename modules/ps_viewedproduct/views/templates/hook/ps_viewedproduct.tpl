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

{include file='catalog/_partials/product-carousel.tpl'
  qProdukty=$products
  qId='viewed'
  qIkona='clock'
  qIle=$qOpcje.count|default:8
  qStrzalki=$qOpcje.nav|default:true
  qTytul={l s='Recently viewed' d='Shop.Theme.Catalog'}}
