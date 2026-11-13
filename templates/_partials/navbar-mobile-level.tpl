{**
 * Quince: poziom menu na telefonie
 *
 * Wywołuje sam siebie dla każdego poziomu w głąb, tak samo jak kaskada na dużym
 * ekranie (`navbar-level.tpl`). Głębokość ograniczył już silnik, budując drzewo.
 * Szablon idzie po tym, co dostał, i nie ma jak zejść głębiej, niż sklep sobie
 * ustawił. Dzięki temu ustawienie „poziomy menu" działa na telefonie i na
 * desktopie tak samo.
 *
 * Wcięcie niesie zmienna `--q-navmob-poziom`, a nie osobna klasa na poziom:
 * poziomów jest tyle, ile sklep ustawi.
 *
 * Klasy: assets/css/components/navbar.css
 *}

{foreach from=$items item=item}
  {if $item.children}
    {* Każdy poziom zwija się osobno: na ekranie zostaje tylko to, o co klient
       poprosił dotknięciem. Rozwinięcie całego działu naraz wysypuje przy
       większym katalogu kilkaset pozycji i klient traci miejsce, w którym był. *}
    <details class="q-navmob__branch" style="--q-navmob-poziom: {$poziom}">
      <summary class="q-navmob__item">
        {if $item.icon}
          <svg class="q-nav__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
            {$item.icon nofilter}
          </svg>
        {/if}
        {$item.name}

        {* Strzałka w osobnej kolumnie, oddzielonej pionową kreską: kciuk trafia
           w nazwę, żeby wejść do działu, albo w tę kolumnę, żeby go rozwinąć. *}
        <span class="q-navmob__expand">
          <svg class="q-navmob__chev" viewBox="0 0 16 16" fill="currentColor"
               aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
        </span>
      </summary>

      <div class="q-navmob__subs">
        {* Odnośnik do samej kategorii: bez niego da się wejść wyłącznie do jej
           podkategorii, a klient szukający wszystkiego z działu nie ma jak trafić. *}
        <a class="q-navmob__item q-navmob__item--all" href="{$item.url}"
           style="--q-navmob-poziom: {$poziom + 1}">
          {l s='All in' d='Shop.Theme.Catalog'} {$item.name}
        </a>

        {include file='_partials/navbar-mobile-level.tpl' items=$item.children poziom=$poziom + 1}
      </div>
    </details>
  {else}
    <a class="q-navmob__item" href="{$item.url}" style="--q-navmob-poziom: {$poziom}">
      {if $item.icon}
        <svg class="q-nav__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
          {$item.icon nofilter}
        </svg>
      {/if}
      {$item.name}
    </a>
  {/if}
{/foreach}
