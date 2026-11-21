{**
 * Quince: menu na telefonie
 *
 * Panel wysuwany od lewej krawędzi z całym katalogiem. Ten sam materiał, co
 * w pasie na dużym ekranie; różni je wyłącznie układ.
 *
 * Poziomy rozwijają się znacznikiem <details>, a nie skryptem: przeglądarka
 * robi to sama, działa przed wczytaniem JavaScriptu i po jego awarii, a czytnik
 * ekranu zna ten znacznik bez dodatkowych opisów.
 *
 * Same poziomy rysuje `navbar-mobile-level.tpl`, który wywołuje sam siebie.
 * Dzięki temu telefon schodzi dokładnie tak głęboko, jak ustawiono w panelu.
 *
 * Klasy: assets/css/components/navbar.css
 *}

{if isset($modules.quince_engine.navigation) && $modules.quince_engine.navigation.enabled}
  {assign var=qn value=$modules.quince_engine.navigation}

  {* `autofocus` na samym oknie: bez niego przeglądarka przenosi ognisko na
     pierwszy przycisk w środku, czyli na zamknięcie, i rysuje wokół niego
     pierścień, jakby ktoś doszedł tam klawiaturą. *}
  <dialog class="q-modal q-modal--drawer q-modal--drawer-start" id="q-navmob" data-q-navmob>
    {* Nagłówek panelu w barwach przyklejonego nagłówka strony i z logo w jego
       wersji: osobny plik logo po przewinięciu, a bez niego ta sama obróbka
       (`--q-header-logo-stuck-filter`). *}
    <div class="q-modal__head q-navmob__head">
      {* Logo zamiast napisu: nazwa przycisku, który to menu otworzył, nic tu nie
         wnosi, a logo mówi, w czyim sklepie klient jest. *}
      <a class="q-navmob__logo{if isset($qh) && $qh.logo_stuck_src} q-navmob__logo--alt{/if}" href="{$urls.base_url}">
        {if isset($qh) && $qh.logo_stuck_src}
          <img src="{$qh.logo_stuck_src}" alt="{$shop.name}">
        {elseif $shop.logo_details}
          <img src="{$shop.logo_details.src}" alt="{$shop.name}"
               width="{$shop.logo_details.width}" height="{$shop.logo_details.height}">
        {else}
          {$shop.name}
        {/if}
      </a>
      <button class="q-modal__close" type="button" data-q-navmob-close
              aria-label="{l s='Close' d='Shop.Theme.Actions'}">
        <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
      </button>
    </div>

    <div class="q-modal__body q-navmob" tabindex="-1" autofocus>
      {* Poziomy renderuje szablon wywołujący sam siebie, tak samo jak
         w kaskadzie na dużym ekranie. Pętla rozpisana na stałą liczbę poziomów
         zignorowałaby ustawienie „poziomy menu" powyżej tej liczby. *}
      {if $qn.panel == 'tiles'}
        {* Kafelki: same działy główne, wybierane wzrokiem po zdjęciu. Kafelek
           prowadzi na stronę działu, a podkategorie pokazuje ta strona. *}
        <div class="q-navmob__tiles{if $qn.tile_mobile == 'grid'} q-navmob__tiles--grid{/if}">
          {foreach from=$qn.branches item=branch}
            <a class="q-navmob__tile" href="{$branch.url}">
              {if $branch.image && $qn.tile_icon_mode}
                {* Zdjęcie jako maska: kształt zostaje, barwę bierze z kafelka. *}
                <span class="q-navmob__tile-img q-navmob__tile-img--maska" role="img"
                      aria-label="{$branch.name}"
                      style="mask-image:url({$branch.image});-webkit-mask-image:url({$branch.image})"></span>
              {elseif $branch.image}
                <img class="q-navmob__tile-img" src="{$branch.image}" alt="{$branch.name}" loading="lazy">
              {elseif $branch.icon}
                <svg class="q-navmob__tile-ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                  {$branch.icon nofilter}
                </svg>
              {/if}
              <span class="q-navmob__tile-name">{$branch.name}</span>
            </a>
          {/foreach}
        </div>
      {else}
        {include file='_partials/navbar-mobile-level.tpl' items=$qn.branches poziom=0}
      {/if}

      {if $qn.links}
        <div class="q-navmob__sep"></div>

        {foreach from=$qn.links item=link}
          <a class="q-navmob__item{if $link.style != 'normal'} q-nav__item--{$link.style}{/if}"
             href="{$link.url}">
            {if $link.icon}
              <svg class="q-nav__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                {$link.icon nofilter}
              </svg>
            {/if}
            {$link.label}
          </a>
        {/foreach}
      {/if}
    </div>
  </dialog>
{/if}
