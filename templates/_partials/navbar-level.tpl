{**
 * Quince — poziom kaskady
 *
 * Wywołuje sam siebie dla każdego poziomu w głąb. Głębokość ograniczył już
 * silnik, budując drzewo — szablon idzie po tym, co dostał, i nie ma jak
 * zejść głębiej, niż sklep sobie ustawił.
 *
 * Pozycja i wysuwany poziom są RODZEŃSTWEM, nie zagnieżdżeniem: odnośnik nie
 * może zawierać innych odnośników, a przeglądarka taką strukturę rozrywa przy
 * wczytywaniu i wysypuje całą kaskadę płasko, jeden poziom pod drugim.
 * Wiersz obejmujący oba jest jednocześnie punktem odniesienia dla wysunięcia.
 *
 * Klasy: assets/css/components/navbar.css
 *}

<div class="q-nav__level">
  {foreach from=$items item=item}
    {if $item.children}
      <div class="q-nav__level-row" data-q-nav-branch>
        <a class="q-nav__level-item" href="{$item.url}">
          {$item.name}
          <svg class="q-nav__cat-arrow" viewBox="0 0 16 16" fill="currentColor"
               aria-hidden="true"><path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/></svg>
        </a>

        <div class="q-nav__flyout" hidden>
          {include file='_partials/navbar-level.tpl' items=$item.children}
        </div>
      </div>
    {else}
      <div class="q-nav__level-row">
        <a class="q-nav__level-item" href="{$item.url}">{$item.name}</a>
      </div>
    {/if}
  {/foreach}
</div>
