{**
 * Quince — wybrane zawężenia jako pigułki.
 *
 * Klient widzi, co odciął, i zdejmuje to jednym kliknięciem, bez wracania do
 * panelu filtrów.
 *
 * Kontrakt z rdzeniem: `js-active-search-filters` na pojemniku i `js-search-link`
 * na odnośnikach — po nich podpina się zawężanie bez przeładowania strony.
 *
 * Czyszczenie wszystkiego stoi TUTAJ, a nie w panelu filtrów: tu widać, co się
 * kasuje. Panel ma ten przycisk ukryty, bo dwa wejścia do jednej czynności,
 * w dwóch stylach, to nie wybór, tylko niezdecydowanie.
 *
 * Klasy: components/listing.css
 *}
<section id="js-active-search-filters" class="q-listing__pills{if !$activeFilters|count} q-listing__pills--empty{/if}">
  {block name='active_filters_title'}
    <span class="visually-hidden">{l s='Active filters' d='Shop.Theme.Global'}</span>
  {/block}

  {foreach from=$activeFilters item="filter"}
    {block name='active_filters_item'}
        {* Sama wartość, bez nazwy grupy: w makiecie pigułka to „JALTEST", a nie
           „Marka: JALTEST". Nazwa grupy stoi przy filtrze, z którego pigułka
           powstała, a tu liczy się zwięzłość — wierszy bywa kilka. *}
      <span class="q-chip">
        {$filter.label}

        <a class="q-chip__x js-search-link" href="{$filter.nextEncodedFacetsURL}" rel="nofollow"
           aria-label="{l s='Remove' d='Shop.Theme.Actions'} {$filter.facetLabel}: {$filter.label}">
          <svg width="12" height="12" viewBox="0 0 16 16" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>
        </a>
      </span>
    {/block}
  {/foreach}

  {if $activeFilters|count}
    {* Ze znakiem „×", tak jak pigułki obok: bez niego sam napis czytał się jak
       podpis wiersza i nikt nie brał go za coś, w co się klika. *}
    <button class="q-btn q-btn--link q-btn--sm q-listing__clear js-search-filters-clear-all" type="button"
            data-search-url="{$clear_all_link}">
      <svg width="12" height="12" viewBox="0 0 16 16" fill="none" stroke="currentColor"
           stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>
      {l s='Clear all' d='Shop.Theme.Actions'}
    </button>
  {/if}
</section>
