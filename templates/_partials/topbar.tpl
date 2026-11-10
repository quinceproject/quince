{**
 * Quince — topbar
 *
 * Pas informacyjny sklepu: kontakt, godziny, wybór języka, waluty i kraju.
 * Nad nim opcjonalny pasek komunikatu.
 *
 * Wszystko, co widać, przychodzi gotowe w `$quince.topbar` — treści rozwiązane dla
 * bieżącego języka, widoczność zamieniona na klasy. W szablonie nie ma obliczeń.
 *
 * Czego tu nie ma: logowania, koszyka, listy życzeń. To pas informacyjny sklepu,
 * nie panel klienta — tamto stoi w headerze.
 *
 * Klasy: assets/css/components/topbar.css
 *}

{* Dane wystawia quince_engine przez hook actionFrontControllerSetVariables.
   PrestaShop udostępnia je pod $modules.<nazwa modułu>. *}
{if isset($modules.quince_engine.topbar) && $modules.quince_engine.topbar.enabled}
  {assign var=topbar value=$modules.quince_engine.topbar}

  {block name='promobar'}
    {if $topbar.promo.visible}
      <div class="q-promobar" data-q-promobar>
        <div class="q-promobar__inner">
          {if $topbar.promo.link}
            <a class="q-promobar__text" href="{$topbar.promo.link}">{$topbar.promo.text}</a>
          {else}
            <span class="q-promobar__text">{$topbar.promo.text}</span>
          {/if}

          {if $topbar.promo.dismissible}
            <button type="button" class="q-promobar__close" data-q-promobar-close
                    aria-label="{l s='Close message' d='Shop.Theme.Global'}">
              <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
              </svg>
            </button>
          {/if}
        </div>
      </div>
    {/if}
  {/block}

  {block name='topbar'}
    <div class="q-topbar">
      <div class="q-topbar__inner">

        {block name='topbar_contact'}
          <div class="q-topbar__contact">
            {if $topbar.items.phone.visible}
              {* Numer jako odnośnik `tel:` — na telefonie od razu wybiera połączenie,
                 a w sprzedaży dla firm to najczęstsza droga kontaktu. *}
              <a class="q-topbar__item {$topbar.items.phone.classes}"
                 href="tel:{$topbar.items.phone.value|replace:' ':''}">
                {if $topbar.items.phone.icon}
                  <svg class="q-topbar__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                    {$topbar.items.phone.icon nofilter}
                  </svg>
                {/if}
                {$topbar.items.phone.value}
              </a>
            {/if}

            {if $topbar.items.email.visible}
              <a class="q-topbar__item {$topbar.items.email.classes}"
                 href="mailto:{$topbar.items.email.value}">
                {if $topbar.items.email.icon}
                  <svg class="q-topbar__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                    {$topbar.items.email.icon nofilter}
                  </svg>
                {/if}
                {$topbar.items.email.value}
              </a>
            {/if}

            {if $topbar.items.hours.visible}
              <span class="q-topbar__item q-topbar__item--hours {$topbar.items.hours.classes}">
                {if $topbar.items.hours.icon}
                  <svg class="q-topbar__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                    {$topbar.items.hours.icon nofilter}
                  </svg>
                {/if}
                {$topbar.items.hours.value}
              </span>
            {/if}
          </div>
        {/block}

        {block name='topbar_tools'}
          <div class="q-topbar__tools">
            {* Selecty dostarczają moduły PrestaShopa — własnych list nie budujemy,
               żeby nie dublować logiki rdzenia. Wołamy je po nazwie zamiast przez
               hook displayNav2, bo na tym haku siedzą też logowanie i koszyk,
               a te należą do headera, nie do pasa informacyjnego. *}
            {if $topbar.pickers.lang.visible}
              <span class="q-topbar__picker {$topbar.pickers.lang.classes}">
                {widget name='ps_languageselector'}
              </span>
            {/if}

            {if $topbar.pickers.currency.visible}
              <span class="q-topbar__picker {$topbar.pickers.currency.classes}">
                {widget name='ps_currencyselector'}
              </span>
            {/if}
          </div>
        {/block}

      </div>
    </div>
  {/block}
{/if}
