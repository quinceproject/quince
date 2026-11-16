{**
 * Quince: lista wszystkich marek.
 *
 * Projekt: quince/makiety/marki-lista.html. Okruszki i tytuł jak na listingu,
 * marki jako rząd kwadratowych kafelków, tych samych co podkategorie
 * (`q-subcats`), pokazany w całości (`is-whole`): bez przycisku
 * „Pokaż wszystkie”, bo to jest cała treść strony.
 *
 * Klasy: assets/css/components/listing.css
 *}
{extends file=$layout}

{* Okruszki idą do środka strony, jak na listingu. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  <div class="q-container q-listing">
    {include file='_partials/breadcrumb.tpl'}

    {block name='brand_header'}
      <h1 class="q-listing__title">{l s='Brands' d='Shop.Theme.Catalog'}</h1>
    {/block}

    {block name='brand_miniature'}
      {if $brands}
        <nav class="q-subcats is-whole q-brands" aria-label="{l s='Brands' d='Shop.Theme.Catalog'}">
          {foreach from=$brands item=brand}
            {include file='catalog/_partials/miniatures/brand.tpl' brand=$brand}
          {/foreach}
        </nav>
      {/if}
    {/block}
  </div>
{/block}
