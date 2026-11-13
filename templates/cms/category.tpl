{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * Quince: kategoria CMS.
 *
 * Zajawka strony: makieta zajawki strony CMS (wariant B). Strona CMS nie ma
 * pola na zdjęcie ani na ikonę, więc zajawka niesie wyłącznie typografię,
 * bez karty i bez ramki.
 *
 * Podkategorie: wariant C (karta, sam tytuł) z tej samej makiety. Odróżnia
 * „wejście głębiej" od „wejścia na treść" (strony, wariant B wyżej), bez
 * żadnej grafiki. Liczba kolumn ta sama, co w siatce
 * produktów (ustawienie sklepu), żeby kafelek miał tę samą szerokość
 * wszędzie w sklepie.
 *}
{extends file='page.tpl'}

{* Goły `page.tpl` rysuje okruszki bez `.q-container`; rozwiązanie jak
   w `customer/page.tpl` i na liście życzeń.
   `.q-cms-crumbs`, nie `.q-account__crumbs`: ta strona nie wczytuje
   `account.css`. *}
{block name='breadcrumb'}
  <div class="q-container q-cms-crumbs">
    {include file='_partials/breadcrumb.tpl'}
  </div>
{/block}

{* Bez `.q-container` tutaj: strona już stoi w jednej warstwie wcięcia
   z ambientu layoutu (`.columns-container.container` z `#center-column`),
   tak samo jak okruszki wyżej. Druga, własna warstwa dokładałaby wcięcie
   po raz drugi (tak samo na liście życzeń). *}
{block name='page_header_container'}
  <h1 class="q-listing__title">{$cms_category.name}</h1>
  {if $cms_category.description}
    <div class="q-listing__intro q-prose rich-text">{$cms_category.description nofilter}</div>
  {/if}
{/block}

{block name='page_content'}
  {block name='cms_sub_categories'}
    {if $sub_categories}
      <h2 class="q-section-title">{l s='Subcategories' d='Shop.Theme.Category'}</h2>
      <div class="q-cms-cards" style="--q-cms-cards-cols: {$modules.quince_engine.listing.columns}">
        {foreach from=$sub_categories item=sub_category}
          <a class="q-cms-cards__item" href="{$sub_category.link}">
            <h3 class="q-cms-cards__title">{$sub_category.name}</h3>
          </a>
        {/foreach}
      </div>
    {/if}
  {/block}

  {block name='cms_sub_pages'}
    {if $cms_pages}
      <h2 class="q-section-title">{l s='Pages' d='Shop.Theme.Catalog'}</h2>
      <div class="q-cms-list">
        {foreach from=$cms_pages item=cms_page}
          <a class="q-cms-list__item" href="{$cms_page.link}">
            <h3 class="q-cms-list__title">{$cms_page.meta_title}</h3>
            {if $cms_page.meta_description}
              <p class="q-cms-list__excerpt">{$cms_page.meta_description}</p>
            {/if}
          </a>
        {/foreach}
      </div>
    {/if}
  {/block}
{/block}
