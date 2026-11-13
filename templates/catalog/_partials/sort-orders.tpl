{**
 * Quince: sortowanie listy.
 *
 * Pole wyboru motywu, a nie natywny `select`: natywna lista wygląda inaczej
 * w każdej przeglądarce i nie da się jej podpiąć pod tokeny.
 *
 * Pozycje są odnośnikami, nie przyciskami: bez JavaScriptu sortowanie ma
 * działać jak zwykłe przejście między stronami. Klasa `js-search-link` to
 * kontrakt z rdzeniem: po niej podpina się zmiana kolejności bez przeładowania.
 *
 * Klasy: components/field.css (q-select), components/dropdown.css
 *}
<div class="q-listing__sort">
  <span class="q-listing__sort-label">{l s='Sort:' d='Shop.Theme.Global'}</span>

  <div class="q-select" data-q-select>
    <button class="q-select__button" type="button" data-q-select-button
            aria-expanded="false" aria-haspopup="listbox"
            aria-label="{l s='Change sort order' d='Shop.Theme.Global'}">
      {capture assign='qSortSelected'}{if $listing.sort_selected}{$listing.sort_selected}{else}{l s='Choose' d='Shop.Theme.Actions'}{/if}{/capture}
      <span data-q-select-label title="{$qSortSelected|escape:'html':'UTF-8'}">{$qSortSelected}</span>
      <svg class="q-select__chev" width="12" height="12" viewBox="0 0 16 16" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
           aria-hidden="true"><path d="m4 6 4 4 4-4"/></svg>
    </button>

    <div class="q-dropdown q-dropdown--attached q-dropdown--end" role="listbox"
         aria-label="{l s='Sort by:' d='Shop.Theme.Global'}" data-q-select-list hidden>
      {foreach from=$listing.sort_orders item=sort_order}
        <a class="q-dropdown__option js-search-link" role="option" rel="nofollow"
           href="{$sort_order.url}" data-q-select-option
           aria-selected="{if $sort_order.current}true{else}false{/if}">{$sort_order.label}</a>
      {/foreach}
    </div>
  </div>
</div>
