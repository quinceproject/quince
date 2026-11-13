{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='account_menu'}
  <aside class="q-account-nav q-card" data-q-account-nav>
    {* Widoczny tylko na telefonie (patrz account.css). Na szerokim ekranie
       lista stoi otwarta na stałe i ten przycisk nigdy się nie pokazuje.
       Etykieta startuje jako „Moje konto” i bez skryptu taka zostaje;
       `account-nav.js` podmienia ją na bieżącą pozycję z listy niżej.

       Klasy `q-select__button`/`q-select__chev` dają wygląd pola wyboru
       z formularzy (field.css): widoczne tło i ramka, żeby przycisk czytał
       się jako kontrolka, a nie kolejny wiersz treści. *}
    <button type="button" class="q-account-nav__trigger q-select__button" data-q-account-nav-trigger
            aria-expanded="false" aria-controls="q-account-nav-list">
      <span class="q-account-nav__trigger-label" data-q-account-nav-trigger-label>
        {l s='My account' d='Shop.Theme.Customeraccount'}
      </span>
      <svg class="q-select__chev" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m4 6 4 4 4-4"/></svg>
    </button>

    <nav aria-label="{l s='My account navigation sidebar' d='Shop.Theme.Customeraccount'}">
      <ul class="q-account-nav__list" id="q-account-nav-list">
        <li class="q-account-nav__item{if $urls.current_url === $urls.pages.my_account} is-active{/if}">
          <a
            id="my_account_link"
            href="{$urls.pages.my_account}"
            {if $urls.current_url === $urls.pages.my_account}aria-current="page"{/if}
          >
            <svg class="q-account-nav__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M4 2v2H2V2zm1 12v-2a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1m0-5V7a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1m0-5V2a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1m5 10v-2a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1m0-5V7a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1m0-5V2a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1M9 2v2H7V2zm5 0v2h-2V2zM4 7v2H2V7zm5 0v2H7V7zm5 0h-2v2h2zM4 12v2H2v-2zm5 0v2H7v-2zm5 0v2h-2v-2zM12 1a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zm-1 6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1zm1 4a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1z"/></svg>
            {l s='My account' d='Shop.Theme.Customeraccount'}
          </a>
        </li>

        <li class="q-account-nav__item{if $urls.current_url === $urls.pages.identity} is-active{/if}">
          <a
            id="identity_link"
            href="{$urls.pages.identity}"
            {if $urls.current_url === $urls.pages.identity}aria-current="page"{/if}
          >
            <svg class="q-account-nav__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/></svg>
            {l s='Information' d='Shop.Theme.Customeraccount'}
          </a>
        </li>

        {if $customer.addresses|count}
          <li class="q-account-nav__item{if $urls.current_url === $urls.pages.addresses} is-active{/if}">
            <a
              id="addresses_link"
              href="{$urls.pages.addresses}"
              {if $urls.current_url === $urls.pages.addresses}aria-current="page"{/if}
            >
              <svg class="q-account-nav__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6"/></svg>
              {l s='Addresses' d='Shop.Theme.Customeraccount'}
            </a>
          </li>
        {else}
          <li class="q-account-nav__item{if $urls.current_url === $urls.pages.address} is-active{/if}">
            <a
              id="address_link"
              href="{$urls.pages.address}"
              {if $urls.current_url === $urls.pages.address}aria-current="page"{/if}
            >
              <svg class="q-account-nav__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M12.166 8.94c-.524 1.062-1.234 2.12-1.96 3.07A32 32 0 0 1 8 14.58a32 32 0 0 1-2.206-2.57c-.726-.95-1.436-2.008-1.96-3.07C3.304 7.867 3 6.862 3 6a5 5 0 0 1 10 0c0 .862-.305 1.867-.834 2.94M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10"/><path d="M8 8a2 2 0 1 1 0-4 2 2 0 0 1 0 4m0 1a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/></svg>
              {l s='Add first address' d='Shop.Theme.Customeraccount'}
            </a>
          </li>
        {/if}

        {* Podgląd pojedynczego zamówienia (`order-detail`) jest podstroną
           historii, więc podświetla tę samą pozycję. *}
        {if !$configuration.is_catalog}
          <li class="q-account-nav__item{if $page.page_name === 'history' || $page.page_name === 'order-detail'} is-active{/if}">
            <a
              id="history_link"
              href="{$urls.pages.history}"
              {if $page.page_name === 'history'}aria-current="page"{/if}
            >
              <svg class="q-account-nav__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M1.92.506a.5.5 0 0 1 .434.14L3 1.293l.646-.647a.5.5 0 0 1 .708 0L5 1.293l.646-.647a.5.5 0 0 1 .708 0L7 1.293l.646-.647a.5.5 0 0 1 .708 0L9 1.293l.646-.647a.5.5 0 0 1 .708 0l.646.647.646-.647a.5.5 0 0 1 .708 0l.646.647.646-.647a.5.5 0 0 1 .801.13l.5 1A.5.5 0 0 1 15 2v12a.5.5 0 0 1-.053.224l-.5 1a.5.5 0 0 1-.8.13L13 14.707l-.646.647a.5.5 0 0 1-.708 0L11 14.707l-.646.647a.5.5 0 0 1-.708 0L9 14.707l-.646.647a.5.5 0 0 1-.708 0L7 14.707l-.646.647a.5.5 0 0 1-.708 0L5 14.707l-.646.647a.5.5 0 0 1-.708 0L3 14.707l-.646.647a.5.5 0 0 1-.801-.13l-.5-1A.5.5 0 0 1 1 14V2a.5.5 0 0 1 .053-.224l.5-1a.5.5 0 0 1 .367-.27m.217 1.338L2 2.118v11.764l.137.274.51-.51a.5.5 0 0 1 .707 0l.646.647.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.509.509.137-.274V2.118l-.137-.274-.51.51a.5.5 0 0 1-.707 0L12 1.707l-.646.647a.5.5 0 0 1-.708 0L10 1.707l-.646.647a.5.5 0 0 1-.708 0L8 1.707l-.646.647a.5.5 0 0 1-.708 0L6 1.707l-.646.647a.5.5 0 0 1-.708 0L4 1.707l-.646.647a.5.5 0 0 1-.708 0z"/><path d="M3 4.5a.5.5 0 0 1 .5-.5h6a.5.5 0 1 1 0 1h-6a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 1 1 0 1h-6a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 1 1 0 1h-6a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5m8-6a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5"/></svg>
              {l s='Order history and details' d='Shop.Theme.Customeraccount'}
            </a>
          </li>
        {/if}

        {if !$configuration.is_catalog}
          <li class="q-account-nav__item{if $urls.current_url === $urls.pages.order_slip} is-active{/if}">
            <a
              id="order-slips_link"
              href="{$urls.pages.order_slip}"
              {if $urls.current_url === $urls.pages.order_slip}aria-current="page"{/if}
            >
              <svg class="q-account-nav__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M5 4a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1zm-.5 2.5A.5.5 0 0 1 5 6h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1-.5-.5M5 8a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1zm0 2a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1z"/><path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2zm10-1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1"/></svg>
              {l s='Credit slips' d='Shop.Theme.Customeraccount'}
            </a>
          </li>
        {/if}

        {if $configuration.voucher_enabled && !$configuration.is_catalog}
          <li class="q-account-nav__item{if $urls.current_url === $urls.pages.discount} is-active{/if}">
            <a
              id="discounts_link"
              href="{$urls.pages.discount}"
              {if $urls.current_url === $urls.pages.discount}aria-current="page"{/if}
            >
              <svg class="q-account-nav__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M4 4.85v.9h1v-.9zm7 0v.9h1v-.9zm-7 1.8v.9h1v-.9zm7 0v.9h1v-.9zm-7 1.8v.9h1v-.9zm7 0v.9h1v-.9zm-7 1.8v.9h1v-.9zm7 0v.9h1v-.9z"/><path d="M1.5 3A1.5 1.5 0 0 0 0 4.5V6a.5.5 0 0 0 .5.5 1.5 1.5 0 1 1 0 3 .5.5 0 0 0-.5.5v1.5A1.5 1.5 0 0 0 1.5 13h13a1.5 1.5 0 0 0 1.5-1.5V10a.5.5 0 0 0-.5-.5 1.5 1.5 0 0 1 0-3A.5.5 0 0 0 16 6V4.5A1.5 1.5 0 0 0 14.5 3zM1 4.5a.5.5 0 0 1 .5-.5h13a.5.5 0 0 1 .5.5v1.05a2.5 2.5 0 0 0 0 4.9v1.05a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-1.05a2.5 2.5 0 0 0 0-4.9z"/></svg>
              {l s='Vouchers' d='Shop.Theme.Customeraccount'}
            </a>
          </li>
        {/if}

        {if $configuration.return_enabled && !$configuration.is_catalog}
          <li class="q-account-nav__item{if $urls.current_url === $urls.pages.order_follow} is-active{/if}">
            <a
              id="returns_link"
              href="{$urls.pages.order_follow}"
              {if $urls.current_url === $urls.pages.order_follow}aria-current="page"{/if}
            >
              <svg class="q-account-nav__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M6.598 5.013a.144.144 0 0 1 .202.134V6.3a.5.5 0 0 0 .5.5c.667 0 2.013.005 3.3.822.984.624 1.99 1.76 2.595 3.876-1.02-.983-2.185-1.516-3.205-1.799a8.7 8.7 0 0 0-1.921-.306 7 7 0 0 0-.798.008h-.013l-.005.001h-.001L7.3 9.9l-.05-.498a.5.5 0 0 0-.45.498v1.153c0 .108-.11.176-.202.134L2.614 8.254l-.042-.028a.147.147 0 0 1 0-.252l.042-.028zM7.8 10.386q.103 0 .223.006c.434.02 1.034.086 1.7.271 1.326.368 2.896 1.202 3.94 3.08a.5.5 0 0 0 .933-.305c-.464-3.71-1.886-5.662-3.46-6.66-1.245-.79-2.527-.942-3.336-.971v-.66a1.144 1.144 0 0 0-1.767-.96l-3.994 2.94a1.147 1.147 0 0 0 0 1.946l3.994 2.94a1.144 1.144 0 0 0 1.767-.96z"/></svg>
              {l s='Merchandise returns' d='Shop.Theme.Customeraccount'}
            </a>
          </li>
        {/if}

        {* Moduły (lista życzeń, RODO, powiadomienia e-mail) dokładają tu własne
           odnośniki jako surowe `<a>`, nie `<li>`. Jedno opakowanie na całość, żeby
           `<ul>` nie dostawało dzieci spoza `<li>`; klasa `q-account-nav__item`
           ubiera je tym samym wierszem co pozostałe pozycje (reguła celuje
           w `a`/`button` wewnątrz, nie w konkretną ich nazwę klasy), bez
           ruszania plików modułów. Pusta ikona modułów (`account-menu__icon`,
           bez treści: moduły liczą na czcionkę Material Icons, której motyw
           nie wczytuje) znika regułą niżej w arkuszu, żeby nie zostawiać
           pustego odstępu przed napisem. *}
        <li class="q-account-nav__item">
          {block name='display_customer_account'}
            {hook h='displayCustomerAccount'}
          {/block}
        </li>

        <li class="q-account-nav__item q-account-nav__item--logout">
          <a id="signout_link" href="{$urls.actions.logout}">
            <svg class="q-account-nav__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0z"/><path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"/></svg>
            {l s='Sign out' d='Shop.Theme.Actions'}
          </a>
        </li>
      </ul>
    </nav>
  </aside>
{/block}
