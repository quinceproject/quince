{**
 * Quince — stronicowanie.
 *
 * Numery stron, wielokropek w miejscu przeskoku i przycisk „Następna" z nazwą,
 * a nie samą strzałką: strzałka obok numerów niczym się od nich nie różni,
 * a to jedyna pozycja, którą klient klika odruchowo.
 *
 * Bez podsumowania „Pokazano 1-12 z 30": liczbę produktów niesie już belka nad
 * listą i to samo zdanie dwa razy na jednej stronie niczego nie dodaje.
 *
 * Bez strzałki wstecz: do poprzedniej strony wraca się przyciskiem przeglądarki,
 * a rząd zaczyna się wtedy od numeru, a nie od pola, które na pierwszej stronie
 * i tak jest martwe.
 *
 * Kontrakt z rdzeniem: `js-pager-link` i `data-ps-data` — po nich podpina się
 * przejście między stronami bez przeładowania. Pozycje są odnośnikami, więc
 * bez JavaScriptu działają jak zwykłe przejścia.
 *
 * Klasy: components/pagination.css
 *}
{if $pagination.should_be_displayed}
  <nav class="q-pagination" aria-label="{l s='Products pagination' d='Shop.Theme.Catalog'}">
    {block name='pagination_page_list'}
      {foreach from=$pagination.pages item="page"}

        {if $page.type === 'spacer'}
          <span class="q-pagination__gap" aria-hidden="true">&hellip;</span>

        {elseif $page.type === 'next'}
          {if $page.clickable}
            <a class="q-pagination__next js-pager-link" href="{$page.url}" data-ps-data="{$page.url}"
               aria-label="{l s='Go to next page' d='Shop.Theme.Actions'}">
              {l s='Next page' d='Shop.Theme.Actions'}
              <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor"
                   stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                   aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
            </a>
          {/if}

        {elseif $page.type !== 'previous'}
          <a class="q-pagination__page{if $page.current} is-active{/if}{if $page.clickable} js-pager-link{/if}"
             href="{$page.url}" data-ps-data="{$page.url}"
             {if $page.current}aria-current="page"{/if}
             aria-label="{l s='Go to page %page%' sprintf=['%page%' => $page.page] d='Shop.Theme.Actions'}">{$page.page}</a>
        {/if}

      {/foreach}
    {/block}
  </nav>
{/if}
