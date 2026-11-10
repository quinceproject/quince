{**
 * Quince — belka nad listą produktów.
 *
 * Pasek narzędzi, panel filtrów w wariancie „pas nad listą" i pigułki wybranych
 * zawężeń. Co w pasku stoi i w jakiej kolejności, mówi strefa `toolbar`
 * z ustawień silnika.
 *
 * Plik jest renderowany DWA RAZY tą samą treścią: raz w stronie, przez
 * `product-list.tpl`, i raz osobno, gdy rdzeń odsyła zawężoną listę bez
 * przeładowania strony (`rendered_products_top`). Dlatego wszystko, czego
 * potrzebuje, liczy sobie sam z `$listing` i z ustawień silnika — w drugim
 * przypadku nie ma wokół niego żadnego szablonu, który by mu to podał.
 *
 * Identyfikator `js-product-list-top` jest wymagany przez rdzeń: po nim
 * podmieniany jest ten kawałek strony.
 *
 * Klasy: components/listing.css
 *}
{assign var=qList value=$modules.quince_engine.listing}

{* Liczba zawężeń wybranych przez klienta. Rdzeń podaje gotowy HTML pigułek,
   ale nie ich liczbę — dolicza ją silnik w hooku `filterProductSearch`. *}
{assign var=qActiveFilters value=$listing.quince_active_filters|default:0}

{* Bez modułu filtrów nie ma czego stawiać w pasie. *}
{assign var=qHasFilters value=(!empty($listing.rendered_facets))}

{* Smarty nie ma operatora warunkowego w `{assign}` — stąd rozpisany `if`. *}
{if $qHasFilters}
  {assign var=qFilters value=$qList.filters}
{else}
  {assign var=qFilters value='drawer'}
{/if}

{* Pasek przy pustej liście.

   Bez produktów nie ma czego liczyć, sortować ani przełączać, więc pasek nie
   ma po co stać. Jeden wyjątek: listę wyzerowało zawężenie. Wtedy pasek zostaje
   razem z pigułkami, bo to jedyne miejsce, w którym klient może je zdjąć —
   schowanie go zamykałoby go w ślepym zaułku z pustą listą i bez wyjścia. *}
{assign var=qMaProdukty value=($listing.products|default:[]|@count > 0)}

<div id="js-product-list-top">
  {if $qMaProdukty || $qActiveFilters > 0}
  <div class="q-listing__bar">
    <div class="q-toolbar">
      {* Pigułki zawężeń idą pod pasek, nie do niego: to osobny wiersz tego
         samego bloku, a między nimi a paskiem wchodzi jeszcze pas filtrów,
         jeśli sklep wybrał ten wariant. *}
      {foreach from=$qList.zones.toolbar item=qEl}
        {if $qEl.id != 'active_filters'}
          {include file='catalog/_partials/listing-element.tpl' qEl=$qEl}
        {/if}
      {/foreach}
    </div>

    {if $qFilters == 'bar'}
      <aside class="q-listing__filters" id="q-filters"
             aria-label="{l s='Filters' d='Shop.Theme.Actions'}">
        {foreach from=$qList.zones.filters item=qEl}
          {include file='catalog/_partials/listing-element.tpl' qEl=$qEl}
        {/foreach}

        {* Stopka tylko w pasie: w kolumnie panel nie ma czego zamykać.
           Czynność stoi po prawej, tam gdzie kończy się czytanie panelu,
           a niesie wynik — zamknięcie pasa jest skutkiem wyboru, więc liczba
           mówi, co się wybrało. *}
        <div class="q-filters__foot">
          <button class="q-btn q-btn--primary" type="button" data-q-filters-open>
            {l s='Show %product_count% products' d='Shop.Theme.Actions' sprintf=['%product_count%' => $listing.pagination.total_items]}
          </button>
        </div>
      </aside>
    {/if}

    {foreach from=$qList.zones.toolbar item=qEl}
      {if $qEl.id == 'active_filters'}
        {include file='catalog/_partials/listing-element.tpl' qEl=$qEl}
      {/if}
    {/foreach}
  </div>
  {/if}
</div>
