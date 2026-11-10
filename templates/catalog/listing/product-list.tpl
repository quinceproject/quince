{**
 * Quince — strona z listą produktów.
 *
 * Jeden szablon na siedem stron: kategorię, markę, dostawcę, wyszukiwarkę,
 * nowości, promocje i bestsellery. Wszystkie rozszerzają ten plik i różnią się
 * wyłącznie nagłówkiem, więc układ ustawia się raz, na jednym ekranie panelu.
 *
 * Strefy przychodzą z silnika jako listy identyfikatorów w kolejności. Szablon
 * nie wie, co w nich stoi — od identyfikatora do treści prowadzi wyłącznie
 * `catalog/_partials/listing-element.tpl`.
 *
 * Identyfikatory `js-product-list-*` i nazwy bloków Smarty zostają: po nich
 * rdzeń i moduł filtrów podmieniają kawałki strony przy zawężaniu listy.
 *}
{extends file=$layout}

{block name='head_microdata_special'}
  {include file='_partials/microdata/product-list-jsonld.tpl' listing=$listing}
{/block}

{* Okruszki stoją wewnątrz kontenera listingu, jako element strefy, więc miejsce
   z układu zostaje puste — inaczej ścieżka renderowałaby się dwa razy. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  {assign var=qList value=$modules.quince_engine.listing}

  {* Liczba zawężeń wybranych przez klienta. Rdzeń podaje gotowy HTML pigułek,
     ale nie ich liczbę — dolicza ją silnik w hooku `filterProductSearch`. *}
  {assign var=qActiveFilters value=$listing.quince_active_filters|default:0}

  {* Czy filtry w ogóle są. Bez modułu filtrów nie ma czego stawiać w kolumnie
     ani w pasie, więc układ wraca do pełnej szerokości niezależnie od tego, co
     sklep wybrał w panelu. *}
  {assign var=qHasFilters value=(!empty($listing.rendered_facets))}

  {* Smarty nie ma operatora warunkowego w `{assign}` — stąd rozpisany `if`. *}
  {if $qHasFilters}
    {assign var=qFilters value=$qList.filters}
  {else}
    {assign var=qFilters value='drawer'}
  {/if}

  <div class="q-container q-listing" data-filters="{$qFilters}"
       data-views="{$qList.views|default:'both'}">

    {* Zdjęcie kategorii stoi OBOK tytułu i opisu, nie nad nimi, więc te trzy
       elementy wchodzą do jednego bloku o dwóch kolumnach.

       Blok otwiera się na PIERWSZYM z tekstów nagłówka, a nie tam, gdzie
       w liście stoi zdjęcie: zdjęcie należy do tytułu i przeciągnięcie go
       w panelu pod baner nie ma jak zmienić tego, że rysuje się obok nazwy.
       W liście elementów zostaje po to, żeby dało się je włączyć, wyłączyć
       i ustawić, gdzie ma być widoczne.

       Blok zamyka się na pierwszym elemencie, który do nagłówka tekstowego nie
       należy, więc reszta strefy wraca na pełną szerokość. Bez zdjęcia blok
       w ogóle się nie pojawia i strefa wygląda tak, jak przed dołożeniem tego
       elementu. *}
    {block name='product_list_header'}
      {assign var=qCover value=false}
      {foreach from=$qList.zones.header item=qEl}
        {if $qEl.id == 'cover' && !empty($category.cover.large.url)}
          {assign var=qCover value=$qEl}
        {/if}
      {/foreach}

      {capture assign='qHeadClass'}q-listing__head{if !$qList.options.cover.desktop|default:true} q-listing__head--no-desktop{/if}{if !$qList.options.cover.mobile|default:true} q-listing__head--no-mobile{/if}{/capture}

      <div id="js-product-list-header">
        {assign var=qHead value=false}
        {assign var=qHeadDone value=false}

        {foreach from=$qList.zones.header item=qEl}
          {if $qEl.id == 'cover'}
            {* Zdjęcie renderuje się razem z tekstem, w bloku poniżej. *}

          {elseif $qCover && !$qHeadDone && ($qEl.id == 'title' || $qEl.id == 'description')}
            {if !$qHead}
              <div class="{$qHeadClass}">
                {include file='catalog/_partials/listing-element.tpl' qEl=$qCover}
                <div class="q-listing__head-text">
              {assign var=qHead value=true}
            {/if}
            {include file='catalog/_partials/listing-element.tpl' qEl=$qEl}

          {else}
            {if $qHead}
                </div>
              </div>
              {assign var=qHead value=false}
              {assign var=qHeadDone value=true}
            {/if}
            {include file='catalog/_partials/listing-element.tpl' qEl=$qEl}
          {/if}
        {/foreach}

        {if $qHead}
            </div>
          </div>
          {assign var=qHead value=false}
          {assign var=qHeadDone value=true}
        {/if}

        {* Zdjęcie włączone, ale tytuł i opis zgaszone: nie ma go z czym zestawić,
           więc staje samo, w tej samej szerokości kolumny. *}
        {if $qCover && !$qHeadDone}
          <div class="{$qHeadClass}">
            {include file='catalog/_partials/listing-element.tpl' qEl=$qCover}
            <div class="q-listing__head-text"></div>
          </div>
        {/if}
      </div>
    {/block}

    {* `--q-listing-cols` to liczba kolumn, która zostaje ZAJAWKOM, czyli już po
       oddaniu jednej filtrom. Liczy ją silnik, bo zna i ustawienie siatki,
       i wybrany wariant filtrów. Arkusz wylicza z niej szerokość kolumny
       filtrów i przestawia siatkę w treści. *}
    <div class="q-listing__layout" style="--q-listing-cols: {$qList.columns}">

      {* Kolumna filtrów zabiera jedną komórkę siatki zajawek, nie własną
         szerokość: inaczej ta sama zajawka byłaby na kategorii węższa niż
         w karuzeli modułu. Szerokość liczy `listing.css` z `--q-kolumny`. *}
      {if $qFilters == 'column'}
        <aside class="q-listing__filters" id="q-filters"
               aria-label="{l s='Filters' d='Shop.Theme.Actions'}">
          {foreach from=$qList.zones.filters item=qEl}
            {include file='catalog/_partials/listing-element.tpl' qEl=$qEl}
          {/foreach}
        </aside>
      {/if}

      <div class="q-listing__content">
        <section id="products">
          {* Belka jest w osobnym pliku, bo rdzeń renderuje ją drugi raz sama,
             gdy odsyła zawężoną listę bez przeładowania strony. Dwie kopie
             znaczników rozjechałyby się przy pierwszej zmianie.

             Stoi TAKŻE przy pustej liście. Pusto najczęściej robi się od
             zawężeń, a to w belce stoją pigułki i „Wyczyść wszystko" — bez niej
             klient, który zawęził za mocno, nie ma czym tego cofnąć. Tak samo
             wygląda lista zawężona bez przeładowania strony: rdzeń odsyła belkę
             niezależnie od tego, czy coś znalazł. *}
          {block name='product_list_top'}
            {include file='catalog/_partials/products-top.tpl' listing=$listing}
          {/block}

          {* Pigułki rdzenia stoją już w belce. Blok zostaje pusty, bo rdzeń
             go wymaga, a druga kopia dublowałaby zawężenia. *}
          {block name='product_list_active_filters'}{/block}

          {* Widok domyślny ustawia sklep, ale wybór klienta go przykrywa:
             skrypt listingu czyta zapis z przeglądarki i przestawia klasę.
             Klasa jest tu od razu, żeby pierwsze wejście nie migało siatką
             przed przeskoczeniem na listę.

             Pustą listę obsługuje ten sam plik, bo to on wraca przy zawężaniu
             bez przeładowania strony. *}
          {block name='product_list'}
            {include file='catalog/_partials/products.tpl' listing=$listing}
          {/block}

          {block name='product_list_bottom'}
            {include file='catalog/_partials/products-bottom.tpl' listing=$listing}
          {/block}
        </section>

        {block name='product_list_footer'}
          <div id="js-product-list-footer">
            {foreach from=$qList.zones.footer item=qEl}
              {include file='catalog/_partials/listing-element.tpl' qEl=$qEl}
            {/foreach}
          </div>
        {/block}
      </div>
    </div>
  </div>

  {* Szuflada filtrów. Na wąskim ekranie przyjmuje panel niezależnie od tego,
     który wariant wybrał sklep: kolumna zabiera wtedy pół ekranu, a pas nad
     listą spycha produkty poniżej krawędzi. Pusta w znacznikach — panel
     wjeżdża tu przeniesieniem węzła, więc filtry są w kodzie strony raz.
     Tak samo robi to rdzeń z `#_desktop_faceted`. *}
  {if $qHasFilters}
    <dialog class="q-modal q-modal--drawer q-modal--drawer-start" id="q-filters-drawer" data-q-filters-drawer>
      <div class="q-modal__head">
        <h2 class="q-modal__title">{l s='Filters' d='Shop.Theme.Actions'}</h2>
        <button class="q-modal__close" type="button" data-q-filters-close
                aria-label="{l s='Close' d='Shop.Theme.Actions'}">
          <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
        </button>
      </div>

      {* Przy wariancie „szuflada" panel renderuje się od razu tutaj, bo nie ma
         go gdzie indziej. Przy dwóch pozostałych wariantach to miejsce zostaje
         puste na szerokim ekranie, a poniżej 992 px wjeżdża tu panel z treści
         — przeniesieniem węzła, nie drugą kopią znaczników. *}
      <div class="q-modal__body" data-q-filters-host tabindex="-1" autofocus>
        {if $qFilters == 'drawer'}
          <div class="q-listing__filters" id="q-filters">
            {foreach from=$qList.zones.filters item=qEl}
              {include file='catalog/_partials/listing-element.tpl' qEl=$qEl}
            {/foreach}
          </div>
        {/if}
      </div>

      {* Przycisk niesie wynik zawężenia, a nie samo „Zamknij": zamknięcie
         szuflady jest skutkiem wyboru, a liczba mówi, co się wybrało.

         Szuflada stoi poza kawałkami strony, które rdzeń podmienia przy
         zawężaniu, więc liczbę przestawia skrypt listingu. Stąd `data-q-total`:
         skrypt nie zna napisu w żadnym języku, zna tylko liczbę, którą ma
         w nim znaleźć i zamienić. *}
      <div class="q-modal__foot">
        <button class="q-btn q-btn--primary q-btn--lg q-btn--block" type="button"
                data-q-filters-close data-q-total="{$listing.pagination.total_items}">
          {l s='Show %product_count% products' d='Shop.Theme.Actions' sprintf=['%product_count%' => $listing.pagination.total_items]}
        </button>
      </div>
    </dialog>
  {/if}
{/block}
