{**
 * Quince — panel zawężeń.
 *
 * Renderuje go rdzeń albo ps_facetedsearch, zależnie od tego, który przejął
 * wyszukiwanie. Silnik decyduje wyłącznie o tym, GDZIE ten kawałek stanie:
 * w szufladzie, w kolumnie obok listy albo w pasie nad listą.
 *
 * Kontrakt z rdzeniem, którego nie wolno ruszyć:
 *   `js-search-filters` na pojemniku, `data-search-url` na polu wyboru
 *   i `js-search-link` na odnośniku. Po nich podpina się zawężanie listy bez
 *   przeładowania strony.
 *
 * Odnośnik pod nazwą, mimo że klika się w całe pole: bez JavaScriptu zawężenia
 * muszą działać jak zwykłe przejścia między stronami.
 *
 * Klasy: components/listing.css
 *}
{if $facets|count}
  {* Liczba zawężeń wybranych przez klienta. Rdzeń nie podaje jej gotowej przy
     renderowaniu tego kawałka, więc liczymy z samych filtrów. *}
  {assign var=qActive value=0}
  {foreach from=$facets item="qFacet"}
    {foreach from=$qFacet.filters item="qFilter"}
      {if $qFilter.active}{assign var=qActive value=$qActive + 1}{/if}
    {/foreach}
  {/foreach}

  <div id="search-filters" class="q-filters js-search-filters">

    {block name='facets_title'}
      {* Nazwa niesie liczbę zawężeń, tak samo jak przycisk „Filtry" w belce. *}
      <div class="q-filters__head">
        <p class="q-filters__title">
          {l s='Filters' d='Shop.Theme.Actions'}
          {if $qActive}
            <span class="q-filters__count">{$qActive}</span>
          {/if}
        </p>
      </div>
    {/block}

    {* Czyszczenia nie ma w panelu: ta sama czynność stoi przy pigułkach
       zawężeń, czyli tam, gdzie widać, co się kasuje. Blok zostaje pusty,
       bo rdzeń go woła. *}
    {block name='facets_clearall_button'}{/block}

    <div class="q-filters__groups">
      {foreach from=$facets item="facet"}
        {if !$facet.displayed}
          {continue}
        {/if}

        {* Grupy stoją OTWARTE, tak jak w makiecie: zawężanie jest tym, po co
           klient tu przyszedł, a zwinięta grupa każe mu najpierw zgadnąć, co
           jest w środku. Znacznik `details` zostaje, bo klient może ją zamknąć,
           gdy lista wartości jest długa. *}
        <details class="q-filter" open>
          <summary class="q-filter__head">
            {$facet.label}
            <svg class="q-filter__chev" width="14" height="14" viewBox="0 0 16 16" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                 aria-hidden="true"><path d="m4 6 4 4 4-4"/></svg>
          </summary>

          <div class="q-filter__body">
            {assign var=qFacetId value=10|mt_rand:100000}

            {foreach from=$facet.filters key=filter_key item="filter"}
              {if !$filter.displayed}
                {continue}
              {/if}

              <label class="q-filter__item{if $filter.active} is-active{/if}"
                     for="facet_input_{$qFacetId}_{$filter_key}">
                <input
                  class="q-choice__input"
                  id="facet_input_{$qFacetId}_{$filter_key}"
                  data-search-url="{$filter.nextEncodedFacetsURL}"
                  type="{if $facet.multipleSelectionAllowed}checkbox{else}radio{/if}"
                  {if !$facet.multipleSelectionAllowed}name="facet_{$qFacetId}"{/if}
                  {if $filter.active}checked{/if}>

                {if isset($filter.properties.texture)}
                  <span class="q-filter__swatch" style="background-image:url({$filter.properties.texture})"></span>
                {elseif isset($filter.properties.color)}
                  <span class="q-filter__swatch" style="background-color:{$filter.properties.color}"></span>
                {/if}

                <a class="q-filter__name js-search-link" href="{$filter.nextEncodedFacetsURL}" rel="nofollow">
                  {$filter.label}
                </a>

                {if $filter.magnitude}
                  <span class="q-filter__count">{$filter.magnitude}</span>
                {/if}
              </label>
            {/foreach}
          </div>
        </details>
      {/foreach}
    </div>
  </div>
{/if}
