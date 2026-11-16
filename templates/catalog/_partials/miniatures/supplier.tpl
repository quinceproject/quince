{**
 * Quince: kafelek dostawcy na liście dostawców.
 *
 * Ten sam kafelek co marka (miniatures/brand.tpl): logo, nazwa, liczba
 * produktów. Dostawca bez wgranego logo pokazuje samą nazwę i liczbę.
 *}
{block name='supplier_miniature_item'}
  {assign var=qLogo value=null}
  {if $supplier.image && !empty($supplier.image.bySize.small_default.url)}
    {assign var=qLogo value=$supplier.image.bySize.small_default}
  {/if}
  <a class="q-subcats__item" href="{$supplier.url}" title="{$supplier.name}">
    {if $qLogo}
      <img class="q-subcats__image" loading="lazy" decoding="async"
           src="{$qLogo.url}" alt=""
           width="{$qLogo.width}" height="{$qLogo.height}">
    {/if}
    <span class="q-subcats__name">{$supplier.name}</span>
    {* Odmiana liczby jak w miniatures/brand.tpl (tam opis, dlaczego
       w szablonie, a nie przez `|` w tłumaczeniu). *}
    {assign var=qIle value=$supplier.nb_products|intval}
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
