{**
 * Quince — panel zawężeń modułu filtrów.
 *
 * Ten sam wygląd co `catalog/_partials/facets.tpl` w motywie. Dwa pliki, bo
 * zawężenia renderuje albo rdzeń, albo ten moduł, zależnie od tego, który
 * przejął wyszukiwanie — a sklep ma widzieć jedno i to samo.
 *
 * Grupa to `<details>`: zwijanie ma działać bez JavaScriptu, a znacznik
 * przeglądarki zna sam. Harmonijka Bootstrapa, którą to zastąpiło, wymagała
 * jego skryptu i klas, których w tym motywie nie ma.
 *
 * KONTRAKT ZE SKRYPTEM LISTINGU, którego nie wolno ruszyć:
 *   `#search-filters`, `data-search-url` na polu wyboru, `js-search-link`
 *   na odnośniku, `js-search-filters-clear-all` na czyszczeniu, a przy zakresie
 *   ceny `data-q-range` i atrybuty `data-slider-*`. Po nich skrypt składa adres
 *   zawężenia i podmienia listę bez przeładowania strony.
 *
 * Klasy: components/listing.css
 *}
{if $displayedFacets|count}
  <div id="search-filters" class="q-filters" role="region"
       aria-label="{l s='Product filters' d='Shop.Theme.Global'}">

    {block name='facets_title'}
      {* Nazwa niesie liczbę zawężeń, tak samo jak przycisk „Filtry" w belce:
         w kolumnie panel widać cały czas, więc to jedyne miejsce, w którym
         klient sprawdza, ile odciął, bez schodzenia do pigułek. *}
      <div class="q-filters__head">
        <p class="q-filters__title">
          {l s='Filters' d='Shop.Theme.Actions'}
          {if $activeFilters|count}
            <span class="q-filters__count">{$activeFilters|count}</span>
          {/if}
        </p>
      </div>
    {/block}

    {* Czyszczenia nie ma w panelu: ta sama czynność stoi przy pigułkach
       zawężeń, czyli tam, gdzie widać, co się kasuje. Dwa wejścia do jednej
       czynności, w dwóch stylach, to nie wybór, tylko niezdecydowanie.
       Blok zostaje pusty, bo rdzeń go woła. *}
    {block name='facets_clearall_button'}{/block}

    <div class="q-filters__groups">
      {foreach from=$displayedFacets item="facet" name="facets"}
        {assign var=qFacetId value=10|mt_rand:100000}

        {* Grupy stoją OTWARTE, tak jak w makiecie: zawężanie jest tym, po co
           klient tu przyszedł, a zwinięta grupa każe mu najpierw zgadnąć, co
           jest w środku. Znacznik `details` zostaje, bo klient może ją zamknąć,
           gdy lista wartości jest długa. *}
        <details class="q-filter" open
                 data-type="{$facet.type}" data-name="{$facet.label}">
          <summary class="q-filter__head">
            {$facet.label}
            <svg class="q-filter__chev" width="14" height="14" viewBox="0 0 16 16" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                 aria-hidden="true"><path d="m4 6 4 4 4-4"/></svg>
          </summary>

          <div class="q-filter__body" id="facet_{$qFacetId}">

            {if in_array($facet.widgetType, ['radio', 'checkbox'])}
              {block name='facet_item_other'}
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

                    {* Próbka barwy albo tekstury zamiast samej nazwy: „Grafit"
                       nic nie mówi, dopóki się go nie zobaczy. *}
                    {if isset($filter.properties.texture)}
                      <span class="q-filter__swatch" style="background-image:url({$filter.properties.texture})"></span>
                    {elseif isset($filter.properties.color)}
                      <span class="q-filter__swatch" style="background-color:{$filter.properties.color}"></span>
                    {/if}

                    <a class="q-filter__name js-search-link" href="{$filter.nextEncodedFacetsURL}"
                       rel="nofollow" tabindex="-1">{$filter.label}</a>

                    {if $filter.magnitude && $show_quantities}
                      <span class="q-filter__count">{$filter.magnitude}<span class="visually-hidden"> {if $filter.magnitude == 1}{l s='result' d='Shop.Theme.Global'}{else}{l s='results' d='Shop.Theme.Global'}{/if}</span></span>
                    {/if}
                  </label>
                {/foreach}
              {/block}

            {elseif $facet.widgetType == 'dropdown'}
              {block name='facet_item_dropdown'}
                {* Lista rozwijana wygląda tu jak wszędzie indziej w sklepie:
                   ten sam komponent co sortowanie nad listą. *}
                <div class="q-select" data-q-select>
                  <button class="q-select__button" type="button" data-q-select-button
                          aria-expanded="false" aria-haspopup="listbox" aria-label="{$facet.label}">
                    <span data-q-select-label>
                      {assign var=qFound value=false}
                      {foreach from=$facet.filters item="filter"}
                        {if $filter.active}{$filter.label}{assign var=qFound value=true}{/if}
                      {/foreach}
                      {if !$qFound}{l s='(no filter)' d='Shop.Theme.Global'}{/if}
                    </span>
                    <svg class="q-select__chev" width="12" height="12" viewBox="0 0 16 16" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                         aria-hidden="true"><path d="m4 6 4 4 4-4"/></svg>
                  </button>

                  <div class="q-dropdown q-dropdown--attached" role="listbox"
                       aria-label="{$facet.label}" data-q-select-list hidden>
                    {foreach from=$facet.filters item="filter"}
                      {if !$filter.displayed}
                        {continue}
                      {/if}

                      <a class="q-dropdown__option js-search-link" role="option" rel="nofollow"
                         href="{$filter.nextEncodedFacetsURL}" data-q-select-option
                         aria-selected="{if $filter.active}true{else}false{/if}">
                        {$filter.label}
                        {if $filter.magnitude && $show_quantities} ({$filter.magnitude}){/if}
                      </a>
                    {/foreach}
                  </div>
                </div>
              {/block}

            {elseif $facet.widgetType == 'slider'}
              {block name='facet_item_slider'}
                {* Dwa pola liczbowe i myślnik między nimi, tak jak w makiecie
                   — nie suwak. Suwak modułu rysuje jQuery UI, którego ten motyw
                   nie ładuje, więc w kolumnie zostawała pusta grupa „Cena".
                   Pola działają też bez myszy i bez JavaScriptu: klient wpisuje
                   kwotę z klawiatury, a zakres czyta wprost z liczb.

                   Atrybuty `data-slider-*` zostają: po nich skrypt listingu
                   składa adres zawężenia, dokładnie tak jak robił to suwak. *}
                {foreach from=$facet.filters item="filter"}
                  <div class="q-range" data-q-range
                       data-slider-min="{$facet.properties.min}"
                       data-slider-max="{$facet.properties.max}"
                       data-slider-unit="{$facet.properties.unit}"
                       data-slider-label="{$facet.label}"
                       data-slider-encoded-url="{$filter.nextEncodedFacetsURL}">
                    <input class="q-field" type="number" inputmode="numeric" data-q-range-from
                           min="{$facet.properties.min}" max="{$facet.properties.max}"
                           placeholder="{l s='from' d='Shop.Theme.Global'}"
                           value="{if is_array($filter.value)}{$filter.value[0]}{/if}"
                           aria-label="{l s='%label% from' d='Shop.Theme.Global' sprintf=['%label%' => $facet.label]}">

                    <span class="q-range__sep" aria-hidden="true">&mdash;</span>

                    <input class="q-field" type="number" inputmode="numeric" data-q-range-to
                           min="{$facet.properties.min}" max="{$facet.properties.max}"
                           placeholder="{l s='to' d='Shop.Theme.Global'}"
                           value="{if is_array($filter.value)}{$filter.value[1]}{/if}"
                           aria-label="{l s='%label% to' d='Shop.Theme.Global' sprintf=['%label%' => $facet.label]}">
                  </div>
                {/foreach}
              {/block}
            {/if}

          </div>
        </details>
      {/foreach}
    </div>
  </div>
{/if}
