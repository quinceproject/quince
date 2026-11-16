{**
 * Quince: kafelek marki na liście marek.
 *
 * Ten sam kafelek co podkategoria (`q-subcats__item`): logo, nazwa, a pod nią
 * liczba produktów. Marka bez wgranego logo pokazuje samą nazwę i liczbę:
 * rdzeń podaje wtedy `image` jako null, a dawny szablon rysował obrazek
 * z pustym adresem.
 *}
{block name='brand_miniature_item'}
  {assign var=qLogo value=null}
  {if $brand.image && !empty($brand.image.bySize.small_default.url)}
    {assign var=qLogo value=$brand.image.bySize.small_default}
  {/if}
  <a class="q-subcats__item" href="{$brand.url}" title="{$brand.name}">
    {if $qLogo}
      <img class="q-subcats__image" loading="lazy" decoding="async"
           src="{$qLogo.url}" alt=""
           width="{$qLogo.width}" height="{$qLogo.height}">
    {/if}
    <span class="q-subcats__name">{$brand.name}</span>
    {* Liczba z odmianą. Formę wybieramy tutaj, a nie przez `|` w tłumaczeniu:
       PrestaShop podaje język jako `pl-PL`, a reguła odmiany w Symfony
       rozpoznaje go tylko jako `pl_PL`, więc zawsze brała pierwszą formę.
       Polski ma trzy formy (produkt, produkty, produktów); forma „kilka”
       (końcówka 2-4, bez 12-14) jest liczona tylko dla polskiego, inne języki
       dostają zwykłe dwie. *}
    {assign var=qIle value=$brand.nb_products|intval}
    {assign var=qJedn value=$qIle % 10}
    {assign var=qDzies value=$qIle % 100}
    <span class="q-subcats__count">
      {if $qIle == 0}
        {l s='No products' d='Shop.Theme.Catalog'}
      {elseif $qIle == 1}
        {l s='%count% product' sprintf=['%count%' => $qIle] d='Shop.Theme.Catalog'}
      {elseif $language.iso_code == 'pl' && $qJedn >= 2 && $qJedn <= 4 && ($qDzies < 12 || $qDzies > 14)}
        {l s='%count% products (a few)' sprintf=['%count%' => $qIle] d='Shop.Theme.Catalog'}
      {else}
        {l s='%count% products' sprintf=['%count%' => $qIle] d='Shop.Theme.Catalog'}
      {/if}
    </span>
  </a>
{/block}
