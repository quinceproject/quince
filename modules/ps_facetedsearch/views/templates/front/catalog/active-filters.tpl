{**
 * Quince — wybrane zawężenia modułu filtrów.
 *
 * Ten sam wygląd co `catalog/_partials/active_filters.tpl` w motywie. Dwa
 * pliki, bo pigułki renderuje albo rdzeń, albo ten moduł, zależnie od tego,
 * który przejął wyszukiwanie.
 *
 * Kontrakt z modułem: `#js-active-search-filters` na pojemniku
 * i `js-search-link` na odnośnikach.
 *
 * Klasy: components/listing.css
 *}
<div id="js-active-search-filters" class="q-listing__pills{if !$activeFilters|count} q-listing__pills--empty{/if}">
  {if $activeFilters|count}
    {block name='active_filters_title'}
      <span class="visually-hidden">{l s='Active filters' d='Shop.Theme.Global'}</span>
    {/block}

    {foreach from=$activeFilters item="filter"}
      {block name='active_filters_item'}
        {* Sama wartość, bez nazwy grupy: w makiecie pigułka to „JALTEST", a nie
           „Marka: JALTEST". Nazwa grupy stoi przy filtrze, z którego pigułka
           powstała, a tu liczy się zwięzłość — wierszy bywa kilka. *}
        <a class="q-chip js-search-link" href="{$filter.nextEncodedFacetsURL}" rel="nofollow"
           aria-label="{l s='Remove %1$s filter: %2$s' d='Shop.Theme.Catalog' sprintf=[$filter.facetLabel|lower, $filter.label]}">
          {$filter.label}

          <span class="q-chip__x" aria-hidden="true">
            <svg width="12" height="12" viewBox="0 0 16 16" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round"><path d="M4 4l8 8M12 4l-8 8"/></svg>
          </span>
        </a>
      {/block}
    {/foreach}

    {* Ze znakiem „×", tak jak pigułki obok: bez niego sam napis czytał się jak
       podpis wiersza i nikt nie brał go za coś, w co się klika. *}
    <button class="q-btn q-btn--link q-btn--sm q-listing__clear js-search-filters-clear-all" type="button"
            data-search-url="{$clear_all_link}">
      <svg width="12" height="12" viewBox="0 0 16 16" fill="none" stroke="currentColor"
           stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>
      {l s='Clear all' d='Shop.Theme.Actions'}
    </button>
  {/if}
</div>
