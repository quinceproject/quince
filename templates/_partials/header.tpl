{**
 * Quince — nagłówek
 *
 * Znak firmowy, wyszukiwanie i akcje klienta. Projekt: widok nagłówka.
 *
 * Wszystko, co widać, przychodzi gotowe w `$modules.quince_engine.header` — ikony
 * jako kod SVG, teksty rozwiązane dla bieżącego języka, wybory sprowadzone do
 * wartości logicznych. W szablonie nie ma obliczeń ani decyzji.
 *
 * Kolejność w kodzie jest stała: znak firmowy, wyszukiwanie, akcje. Tą kolejnością
 * idzie tabulator i czytnik ekranu; o miejscu na ekranie decyduje siatka w arkuszu.
 *
 * Czego tu nie ma: hooka displayTop. Silnik decyduje, co stoi w nagłówku, więc
 * moduły nie wstawiają się tu same — wyszukiwarka, koszyk i konto są nasze.
 *
 * Klasy: assets/css/components/header.css
 *}

{capture name="header_banner"}{hook h='displayBanner'}{/capture}
{block name='header_banner'}
  {if !empty($smarty.capture.header_banner)}
    <div class="header-banner">
      {$smarty.capture.header_banner nofilter}
    </div>
  {/if}
{/block}

{* Sekcja górna: kontakt, godziny, język i waluta. *}
{block name='header_nav'}
  {include file='_partials/topbar.tpl'}
{/block}

{block name='header_bottom'}
  {if isset($modules.quince_engine.header)}
    {assign var=qh value=$modules.quince_engine.header}

    {* Zakresy wyszukiwania dostarcza moduł wskazany w ustawieniach, a nie silnik —
       dzięki temu każda nasza wyszukiwarka wystawia je tak samo, pod swoją nazwą. *}
    {assign var=qSearchProvider value=$qh.search.provider}
    {if $qh.search.scope && isset($modules.$qSearchProvider.scopes) && $modules.$qSearchProvider.scopes}
      {assign var=qScopes value=$modules.$qSearchProvider.scopes}
    {else}
      {assign var=qScopes value=[]}
    {/if}

    {* Podpowiedzi dostarcza ten sam moduł co zakresy — wyszukiwarka wbudowana
       ich nie ma, więc bez modułu formularz zostaje zwykłym formularzem. *}
    {if isset($modules.$qSearchProvider.suggest) && $modules.$qSearchProvider.suggest.enabled}
      {assign var=qSuggest value=$modules.$qSearchProvider.suggest}
    {else}
      {assign var=qSuggest value=false}
    {/if}

    <header class="q-header{if $qh.sticky} q-header--sticky{/if}{if $qh.sticky && $qh.scroll_icons} q-header--scroll-icons{/if}"
            style="--q-header-logo-h:{$qh.logo_height}px"{if $qh.sticky} data-q-header{/if}>
      <div class="q-header__inner">

        {* ── katalog w przyklejonym nagłówku ──
           Pas menu odjeżdża razem ze stroną i zabiera ze sobą jedyne dojście do
           katalogu; nagłówek, który zostaje, przejmuje je na siebie. Przycisk jest
           w kodzie zawsze, a pokazuje się dopiero wtedy, gdy pasa menu nie widać —
           dokłada go klasa `is-stuck`, nie skrypt budujący znacznik.

           Ikona i nazwa idą z ustawień nawigacji, bo to ten sam przycisk co w pasie
           menu, tylko w innym pasie. Sklep wybiera, ile z niego zostaje: całość,
           krótsza nazwa albo sama ikona. *}
        {if $qh.sticky && isset($modules.quince_engine.navigation) && $modules.quince_engine.navigation.enabled}
          {assign var=qnav value=$modules.quince_engine.navigation}
          <button class="q-header__cats q-header__cats--{$qnav.scroll.button}"
                  type="button" data-q-cats aria-expanded="false"
                  {if $qnav.scroll.button == 'icon'}aria-label="{if $qnav.trigger.text}{$qnav.trigger.text}{else}{l s='Categories' d='Shop.Theme.Catalog'}{/if}"{/if}>
            {if $qnav.trigger.icon}
              <svg class="q-header__cats-ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                {$qnav.trigger.icon nofilter}
              </svg>
            {/if}

            {if $qnav.scroll.button != 'icon'}
              <span class="q-header__cats-label">
                {if $qnav.scroll.button == 'short' && $qnav.scroll.text}{$qnav.scroll.text}
                {elseif $qnav.trigger.text}{$qnav.trigger.text}
                {else}{l s='Categories' d='Shop.Theme.Catalog'}{/if}
              </span>
              <svg class="q-header__cats-chev" width="10" height="10" viewBox="0 0 16 16"
                   fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
            {/if}
          </button>
        {/if}

        {* ── znak firmowy ── *}
        {if $page.page_name == 'index'}<h1 class="q-header__logo-h1">{/if}
          <a class="q-header__logo" href="{$urls.base_url}">
            {if $shop.logo_details}
              <img src="{$shop.logo_details.src}" alt="{$shop.name}"
                   width="{$shop.logo_details.width}" height="{$shop.logo_details.height}">
            {else}
              {$shop.name}
            {/if}
          </a>
        {if $page.page_name == 'index'}</h1>{/if}

        {* ── wyszukiwanie ──
           Formularz jest w osobnym kawałku, bo ten sam stoi na stronie bez
           wyników: klient poprawia tam frazę i musi dostać tę samą kontrolkę,
           z tym samym zakresem i podpowiedziami. *}
        {include file='_partials/search-form.tpl' qFormClass='q-header__search' qFormId='header'}


        {* ── akcje klienta ── *}
        <div class="q-header__actions">

          {* Miejsce na akcje z modułów — powiadomienia i co przyjdzie później.
             Bez modułu hook nic nie zwraca i rząd wygląda jak dotąd. Moduł rysuje
             własną treść klasami motywu, więc dziedziczy barwy pasa nagłówka. *}
          {if $qh.module_actions}{hook h='displayQuinceHeaderActions'}{/if}

          {if $qh.account.visible}
            {if $qh.account.dropdown}
              <div class="q-action-wrap" data-q-picker>
                {* Nazwa dla czytnika ekranu stoi w atrybucie, bo podpis obok ikony
                   bywa schowany: na wąskim ekranie zawsze, a w przyklejonym nagłówku
                   wtedy, gdy sklep zwęził akcje do ikon. Bez tego zostaje przycisk
                   bez nazwy. *}
                <button class="q-action" type="button" data-q-picker-button
                        aria-haspopup="true" aria-expanded="false"
                        aria-label="{if $customer.is_logged}{$customer.firstname} — {l s='My Account' d='Shop.Theme.Customeraccount'}{elseif $qh.account.label}{$qh.account.label}{else}{l s='Sign in' d='Shop.Theme.Actions'}{/if}">
                  {if $qh.account.icon}
                    <svg class="q-action__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                      {$qh.account.icon nofilter}
                    </svg>
                  {/if}
                  {if $qh.icon_labels}
                    <span class="q-action__label">
                      {if $customer.is_logged}{$customer.firstname}
                      {elseif $qh.account.label}{$qh.account.label}
                      {else}{l s='Sign in' d='Shop.Theme.Actions'}{/if}
                    </span>
                  {/if}
                  <svg width="10" height="10" viewBox="0 0 16 16" fill="currentColor"
                       aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
                </button>

                {* Panel w trzech strefach: powitanie w barwie marki, pozycje, przyciski.
                   Niezalogowany ma do zrobienia dokładnie dwie rzeczy, więc dostaje
                   dwa przyciski zamiast listy pięciu odnośników. *}
                <div class="q-dropdown q-dropdown--attached q-dropdown--panel" data-q-dropdown hidden>
                  {if $customer.is_logged}
                    <div class="q-dropdown__head">
                      {l s='Welcome back' d='Shop.Theme.Customeraccount'}, <strong>{$customer.firstname}</strong>
                    </div>
                    <a class="q-dropdown__option" href="{$urls.pages.my_account}">{l s='My Account' d='Shop.Theme.Customeraccount'}</a>
                    <a class="q-dropdown__option" href="{$urls.pages.history}">{l s='Orders' d='Shop.Theme.Customeraccount'}</a>
                    <a class="q-dropdown__option" href="{$urls.pages.addresses}">{l s='Addresses' d='Shop.Theme.Customeraccount'}</a>
                    <div class="q-dropdown__foot">
                      <a class="q-btn q-btn--secondary q-btn--sm" href="{$urls.actions.logout}">{l s='Sign out' d='Shop.Theme.Actions'}</a>
                    </div>
                  {else}
                    <div class="q-dropdown__head"><strong>{l s='Welcome' d='Shop.Theme.Global'}!</strong></div>

                    {* Śledzenie zamówienia bez logowania: klient, który kupił jako gość,
                       szuka swojej przesyłki właśnie tutaj, a nie w formularzu logowania. *}
                    <a class="q-dropdown__option" href="{$urls.pages.order_follow}">{l s='Order tracking' d='Shop.Theme.Customeraccount'}</a>

                    <div class="q-dropdown__foot">
                      <a class="q-btn q-btn--primary q-btn--sm" href="{$urls.pages.authentication}">{l s='Sign in' d='Shop.Theme.Actions'}</a>
                      <a class="q-btn q-btn--secondary q-btn--sm" href="{$urls.pages.register}">{l s='Create account' d='Shop.Theme.Actions'}</a>
                    </div>
                  {/if}
                </div>
              </div>
            {else}
              <a class="q-action" href="{if $customer.is_logged}{$urls.pages.my_account}{else}{$urls.pages.authentication}{/if}"
                 aria-label="{if $customer.is_logged}{$customer.firstname} — {l s='My Account' d='Shop.Theme.Customeraccount'}{elseif $qh.account.label}{$qh.account.label}{else}{l s='Sign in' d='Shop.Theme.Actions'}{/if}">
                {if $qh.account.icon}
                  <svg class="q-action__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                    {$qh.account.icon nofilter}
                  </svg>
                {/if}
                {if $qh.icon_labels}
                  <span class="q-action__label">
                    {if $customer.is_logged}{$customer.firstname}
                    {elseif $qh.account.label}{$qh.account.label}
                    {else}{l s='Sign in' d='Shop.Theme.Actions'}{/if}
                  </span>
                {/if}
              </a>
            {/if}
          {/if}

          {* Lista życzeń pojawia się razem z modułem, który ją prowadzi — bez niego
             silnik zwraca `visible = false`, więc ikona nie prowadzi donikąd. *}
          {if $qh.wishlist.visible}
            <a class="q-action" href="{$qh.wishlist.url}" aria-label="{l s='Saved products' d='Shop.Theme.Global'}">
              {if $qh.wishlist.icon}
                <svg class="q-action__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                  {$qh.wishlist.icon nofilter}
                </svg>
              {/if}
              {if $qh.icon_labels}
                <span class="q-action__label">{if $qh.wishlist.label}{$qh.wishlist.label}{else}{l s='Saved products' d='Shop.Theme.Global'}{/if}</span>
              {/if}
              <span class="q-action__count">{if $qh.wishlist.count}{$qh.wishlist.count}{/if}</span>
            </a>
          {/if}

          {if !$configuration.is_catalog}
            <a class="q-action q-action--cart" href="{$urls.pages.cart}?action=show"
               aria-label="{l s='Cart' d='Shop.Theme.Actions'}" data-q-cart data-q-cart-open>
              {if $qh.cart.icon}
                <svg class="q-action__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                  {$qh.cart.icon nofilter}
                </svg>
              {/if}
              {if $qh.icon_labels}
                <span class="q-action__label">
                  {if $qh.cart.total}<span data-q-cart-total>{$cart.totals.total.value}</span>
                  {elseif $qh.cart.label}{$qh.cart.label}
                  {else}{l s='Cart' d='Shop.Theme.Actions'}{/if}
                </span>
              {/if}
              <span class="q-action__count" data-q-cart-count>{if $cart.products_count}{$cart.products_count}{/if}</span>
            </a>
          {/if}
        </div>
      </div>

      {* ── wąski ekran ──
         Wyszukiwanie ma na telefonie własny wiersz w barwach pasa nawigacji: pole
         zmieszczone w wierszu ze znakiem firmowym byłoby węższe od wpisywanej frazy.
         Docelowo ten wiersz należy do pasa nawigacji i przeniesie się tam razem
         z nim — do tego czasu stoi tutaj, żeby telefon nie został bez szukania. *}
      {if $qh.search.enabled}
        <div class="q-header__mobile-search">
          {* Hamburger i pole prowadzą do tego samego — do katalogu — więc stoją
             razem. Przycisk otwiera panel z kategoriami wysuwany od lewej. *}
          {if isset($modules.quince_engine.navigation) && $modules.quince_engine.navigation.enabled}
            <button class="q-burger" type="button" data-q-navmob-open
                    aria-controls="q-navmob" aria-label="{l s='Menu' d='Shop.Theme.Global'}">
              <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5m0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5m0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5"/>
              </svg>
            </button>
          {/if}

          <form class="q-search" method="get" action="{$urls.pages.search}" role="search"
                {if $qSuggest}data-q-suggest
                data-q-suggest-url="{$qSuggest.url}"
                data-q-suggest-min="{$qSuggest.min_chars}"
                data-q-suggest-empty="{l s='Nothing matches that phrase' d='Shop.Theme.Catalog'}"
                data-q-suggest-all="{l s='Show all results' d='Shop.Theme.Actions'}"{/if}>
            <input class="q-search__input" type="search" name="s" value="{$smarty.get.s|default:''}"
                   placeholder="{if $qh.search.placeholder}{$qh.search.placeholder}{else}{l s='Search our catalog' d='Shop.Theme.Catalog'}{/if}"
                   aria-label="{l s='Search' d='Shop.Theme.Catalog'}">
            <button class="q-search__submit" type="submit" aria-label="{l s='Search' d='Shop.Theme.Catalog'}">
              {if $qh.search.icon}
                <svg width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                  {$qh.search.icon nofilter}
                </svg>
              {/if}
            </button>

            {if $qSuggest}
              <div class="q-dropdown q-dropdown--wide q-dropdown--attached q-dropdown--scroll q-suggest"
                   id="q-suggest-mobile" role="listbox" data-q-suggest-list hidden></div>
            {/if}
          </form>
        </div>
      {/if}
    </header>

  {else}
    {* Silnik wyłączony: zostaje znak firmowy i dojście do koszyka. Nagłówek bez
       ustawień jest ubogi, ale sklep nie przestaje być sklepem. *}
    <header class="q-header q-header--split">
      <div class="q-header__inner">
        <a class="q-header__logo" href="{$urls.base_url}">{$shop.name}</a>
        <div class="q-header__actions">
          <a class="q-action q-action--cart" href="{$urls.pages.cart}?action=show">
            {l s='Cart' d='Shop.Theme.Actions'}
            <span class="q-action__count">{if $cart.products_count}{$cart.products_count}{/if}</span>
          </a>
        </div>
      </div>
    </header>
  {/if}

  {* Pas nawigacji stoi pod nagłówkiem — osobny pas, bo należy do katalogu,
     a nie do znaku firmowego i akcji klienta. *}
  {block name='header_nav_main'}
    {include file='_partials/navbar.tpl'}
    {include file='_partials/navbar-mobile.tpl'}

    {* Wartownik: zero wysokości, stoi tuż za pasem menu. Po nim skrypt poznaje,
       że katalog schował się pod przyklejonym nagłówkiem — bez nasłuchu przewijania,
       który liczyłby się przy każdym piksielu. *}
    {if isset($qh) && $qh.sticky}<div data-q-stuck aria-hidden="true"></div>{/if}
  {/block}

  {capture name="nav_full_width"}{hook h='displayNavFullWidth'}{/capture}
  {if !empty($smarty.capture.nav_full_width)}
    <div class="header-nav-full-width">
      {$smarty.capture.nav_full_width nofilter}
    </div>
  {/if}
{/block}
