{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{**
 * Quince: produkty jednej listy życzeń.
 *
 * Kontroler dziedziczy po `ProductListingFrontController`, tym samym, po którym
 * dziedziczy kategoria, marka i reszta siedmiu stron z listą produktów. Stąd
 * `$listing` ma tu dokładnie ten sam kształt (produkty, sortowanie, stronicowanie,
 * fasety) i zajawki renderują się tym samym partialem, co wszędzie indziej.
 *
 * Bez systemu stref z `catalog/listing/product-list.tpl`: strefy konfiguruje
 * sklep w panelu dla siedmiu stron kategorii/marki/wyszukiwarki i nie ma wśród
 * nich wishlisty, więc naginanie tamtego ustawienia do tej strony byłoby
 * zachowaniem, którego nikt nie wybrał. Pasek nad listą składa się tu wprost,
 * z tych samych elementów co tam: liczba produktów, sortowanie, przełącznik
 * widoku.
 *
 * Bez panelu filtrów: dostawca wyszukiwania wishlisty nie zwraca fasetów,
 * więc `$listing.rendered_facets` jest tu zawsze puste.
 *
 * Boczny pasek konta (sidebar) celowo pominięty: jego szerokość jest
 * proporcją (1/4 siatki `.q-account`), nie ma żadnego związku z formułą,
 * która liczy szerokość zajawki z `--q-listing-cols`, a makiety na ten widok
 * nie ma. Ta sama zajawka ma wyglądać tak samo jak na każdym innym listingu.
 *}
{extends file='page.tpl'}

{* Goły `page.tpl` rysuje okruszki bez `.q-container` (ma go dopiero treść pod
   spodem), więc bez tego nadpisania stały przy lewej krawędzi okna, nie nad
   resztą strony. Ten sam problem i to samo lekarstwo co w `customer/page.tpl`. *}
{block name='breadcrumb'}
  <div class="q-container q-account__crumbs">
    {include file='_partials/breadcrumb.tpl'}
  </div>
{/block}

{block name='page_content_container'}
  {assign var=qList value=$modules.quince_engine.listing}

  {* Bez `.q-container`: strona już stoi w jednej warstwie wcięcia z ambientu
     layoutu (`.columns-container.container` z `#center-column`), tak samo
     jak okruszki wyżej. Druga, własna warstwa dokładałaby wcięcie po raz
     drugi i rozjeżdżała siatkę względem okruszków o całą jego szerokość. *}
  <div class="q-listing" data-filters="drawer" data-views="{$qList.views|default:'both'}">

    <h1 class="q-listing__title">{$wishlistName}</h1>

    <div class="q-listing__layout" style="--q-listing-cols: {$qList.columns}">
      <div class="q-listing__content">
        <section id="products">
          <div id="js-product-list-top">
            {if $listing.products|default:[]|@count > 0}
              <div class="q-listing__bar">
                <div class="q-toolbar">
                  <span class="q-listing__count">
                    <b>{$listing.pagination.total_items}</b> {l s='products' d='Shop.Theme.Catalog'}
                  </span>

                  {include file='catalog/_partials/sort-orders.tpl' sort_orders=$listing.sort_orders}

                  {if $qList.views|default:'both' == 'both'}
                    {include file='catalog/_partials/listing-view-switch.tpl'}
                  {/if}
                </div>
              </div>
            {/if}
          </div>

          <div id="js-product-list">
            {if $listing.products|count}
              {include file='catalog/_partials/productlist.tpl' products=$listing.products}
            {else}
              {include file='catalog/_partials/listing-empty.tpl'}
            {/if}
          </div>

          <div id="js-product-list-bottom"></div>
        </section>

        <div id="js-product-list-footer">
          {if $modules.quince_engine.listing.pagination|default:'pages' == 'more'}
            {include file='catalog/_partials/listing-more.tpl' pagination=$listing.pagination}
          {else}
            {include file='_partials/pagination.tpl' pagination=$listing.pagination}
          {/if}
        </div>

        <div class="wishlist-products__back">
          <a class="q-btn q-btn--secondary" href="{$wishlistsLink}">
            {l s='Return to wishlists' d='Modules.Blockwishlist.Shop'}
          </a>
        </div>
      </div>
    </div>
  </div>
{/block}

{block name='page_footer_container'}{/block}
