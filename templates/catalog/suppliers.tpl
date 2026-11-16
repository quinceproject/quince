{**
 * Quince: lista wszystkich dostawców.
 *
 * Ten sam układ co lista marek (catalog/brands.tpl, projekt:
 * quince/makiety/marki-lista.html): okruszki i tytuł jak na listingu, dostawcy
 * jako rząd kwadratowych kafelków podkategorii (`q-subcats`), pokazany
 * w całości (`is-whole`).
 *
 * Strona istnieje tylko wtedy, gdy sklep włączy wyświetlanie dostawców.
 *
 * Klasy: assets/css/components/listing.css
 *}
{extends file=$layout}

{* Okruszki idą do środka strony, jak na listingu. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  <div class="q-container q-listing">
    {include file='_partials/breadcrumb.tpl'}

    {block name='supplier_header'}
      <h1 class="q-listing__title">{l s='Suppliers' d='Shop.Theme.Catalog'}</h1>
    {/block}

    {block name='supplier_miniature'}
      {if $suppliers}
        <nav class="q-subcats is-whole q-brands" aria-label="{l s='Suppliers' d='Shop.Theme.Catalog'}">
          {foreach from=$suppliers item=supplier}
            {include file='catalog/_partials/miniatures/supplier.tpl' supplier=$supplier}
          {/foreach}
        </nav>
      {/if}
    {/block}
  </div>
{/block}
