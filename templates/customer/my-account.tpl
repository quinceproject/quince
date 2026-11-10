{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file='customer/page.tpl'}

{* Własny nagłówek zamiast generycznego `page-title-section.tpl` (zwykłe
   `<h1>{$title}</h1>`, współdzielone z markami, dostawcami i krokami kasy):
   tu obok tytułu stoi linijka powitania, a to już nie jest ten sam komponent. *}
{block name='page_header_container'}
  <div class="q-account-header">
    <p class="q-account-header__welcome">
      {l s='Welcome, %firstname%!' d='Shop.Theme.Customeraccount' sprintf=['%firstname%' => $customer.firstname]}
    </p>
    <h1 class="q-account-header__title" tabindex="-1">{l s='My account' d='Shop.Theme.Customeraccount'}</h1>
  </div>
{/block}

{* Jesteśmy już na panelu klienta — link „Wróć do konta" prowadziłby donikąd. *}
{block name='account_link'}{/block}

{block name='page_content'}
  {block name='display_customer_account_top'}
    {hook h='displayCustomerAccountTop'}
  {/block}

  {assign var='qAccount' value=$modules.quince_engine.account|default:null}

  {block name='account_stats'}
    <div class="q-account-stats">
      <div class="q-account-stat q-card">
        <div class="q-account-stat__icon">
          <svg width="20" height="20" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M1.92.506a.5.5 0 0 1 .434.14L3 1.293l.646-.647a.5.5 0 0 1 .708 0L5 1.293l.646-.647a.5.5 0 0 1 .708 0L7 1.293l.646-.647a.5.5 0 0 1 .708 0L9 1.293l.646-.647a.5.5 0 0 1 .708 0l.646.647.646-.647a.5.5 0 0 1 .708 0l.646.647.646-.647a.5.5 0 0 1 .801.13l.5 1A.5.5 0 0 1 15 2v12a.5.5 0 0 1-.053.224l-.5 1a.5.5 0 0 1-.8.13L13 14.707l-.646.647a.5.5 0 0 1-.708 0L11 14.707l-.646.647a.5.5 0 0 1-.708 0L9 14.707l-.646.647a.5.5 0 0 1-.708 0L7 14.707l-.646.647a.5.5 0 0 1-.708 0L5 14.707l-.646.647a.5.5 0 0 1-.708 0L3 14.707l-.646.647a.5.5 0 0 1-.801-.13l-.5-1A.5.5 0 0 1 1 14V2a.5.5 0 0 1 .053-.224l.5-1a.5.5 0 0 1 .367-.27m.217 1.338L2 2.118v11.764l.137.274.51-.51a.5.5 0 0 1 .707 0l.646.647.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.509.509.137-.274V2.118l-.137-.274-.51.51a.5.5 0 0 1-.707 0L12 1.707l-.646.647a.5.5 0 0 1-.708 0L10 1.707l-.646.647a.5.5 0 0 1-.708 0L8 1.707l-.646.647a.5.5 0 0 1-.708 0L6 1.707l-.646.647a.5.5 0 0 1-.708 0L4 1.707l-.646.647a.5.5 0 0 1-.708 0z"/><path d="M3 4.5a.5.5 0 0 1 .5-.5h6a.5.5 0 1 1 0 1h-6a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 1 1 0 1h-6a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 1 1 0 1h-6a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5m8-6a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5"/></svg>
        </div>
        <div class="q-account-stat__body">
          <div class="q-account-stat__value">{$qAccount.ordersCount|default:0}</div>
          <div class="q-account-stat__label">{l s='Orders' d='Shop.Theme.Customeraccount'}</div>
        </div>
      </div>
      <div class="q-account-stat q-card">
        <div class="q-account-stat__icon">
          <svg width="20" height="20" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6"/></svg>
        </div>
        <div class="q-account-stat__body">
          <div class="q-account-stat__value">{$customer.addresses|default:[]|count}</div>
          <div class="q-account-stat__label">{l s='Addresses' d='Shop.Theme.Customeraccount'}</div>
        </div>
      </div>
      <div class="q-account-stat q-card">
        <div class="q-account-stat__icon">
          <svg width="20" height="20" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M4 4.85v.9h1v-.9zm7 0v.9h1v-.9zm-7 1.8v.9h1v-.9zm7 0v.9h1v-.9zm-7 1.8v.9h1v-.9zm7 0v.9h1v-.9zm-7 1.8v.9h1v-.9zm7 0v.9h1v-.9z"/><path d="M1.5 3A1.5 1.5 0 0 0 0 4.5V6a.5.5 0 0 0 .5.5 1.5 1.5 0 1 1 0 3 .5.5 0 0 0-.5.5v1.5A1.5 1.5 0 0 0 1.5 13h13a1.5 1.5 0 0 0 1.5-1.5V10a.5.5 0 0 0-.5-.5 1.5 1.5 0 0 1 0-3A.5.5 0 0 0 16 6V4.5A1.5 1.5 0 0 0 14.5 3zM1 4.5a.5.5 0 0 1 .5-.5h13a.5.5 0 0 1 .5.5v1.05a2.5 2.5 0 0 0 0 4.9v1.05a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-1.05a2.5 2.5 0 0 0 0-4.9z"/></svg>
        </div>
        <div class="q-account-stat__body">
          <div class="q-account-stat__value">{$qAccount.activeVouchersCount|default:0}</div>
          <div class="q-account-stat__label">{l s='Active vouchers' d='Shop.Theme.Customeraccount'}</div>
        </div>
      </div>
    </div>
  {/block}

  {block name='account_cards'}
    <div class="q-account-cards">
      {if !$configuration.is_catalog}
        <a class="q-account-card q-card" id="history_main_link" href="{$urls.pages.history}">
          <span class="q-account-card__icon"><svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M1.92.506a.5.5 0 0 1 .434.14L3 1.293l.646-.647a.5.5 0 0 1 .708 0L5 1.293l.646-.647a.5.5 0 0 1 .708 0L7 1.293l.646-.647a.5.5 0 0 1 .708 0L9 1.293l.646-.647a.5.5 0 0 1 .708 0l.646.647.646-.647a.5.5 0 0 1 .708 0l.646.647.646-.647a.5.5 0 0 1 .801.13l.5 1A.5.5 0 0 1 15 2v12a.5.5 0 0 1-.053.224l-.5 1a.5.5 0 0 1-.8.13L13 14.707l-.646.647a.5.5 0 0 1-.708 0L11 14.707l-.646.647a.5.5 0 0 1-.708 0L9 14.707l-.646.647a.5.5 0 0 1-.708 0L7 14.707l-.646.647a.5.5 0 0 1-.708 0L5 14.707l-.646.647a.5.5 0 0 1-.708 0L3 14.707l-.646.647a.5.5 0 0 1-.801-.13l-.5-1A.5.5 0 0 1 1 14V2a.5.5 0 0 1 .053-.224l.5-1a.5.5 0 0 1 .367-.27m.217 1.338L2 2.118v11.764l.137.274.51-.51a.5.5 0 0 1 .707 0l.646.647.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.646.646.646-.646a.5.5 0 0 1 .708 0l.509.509.137-.274V2.118l-.137-.274-.51.51a.5.5 0 0 1-.707 0L12 1.707l-.646.647a.5.5 0 0 1-.708 0L10 1.707l-.646.647a.5.5 0 0 1-.708 0L8 1.707l-.646.647a.5.5 0 0 1-.708 0L6 1.707l-.646.647a.5.5 0 0 1-.708 0L4 1.707l-.646.647a.5.5 0 0 1-.708 0z"/><path d="M3 4.5a.5.5 0 0 1 .5-.5h6a.5.5 0 1 1 0 1h-6a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 1 1 0 1h-6a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 1 1 0 1h-6a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5m8-6a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 0 1h-1a.5.5 0 0 1-.5-.5"/></svg></span>
          <span class="q-account-card__body">
            <h2 class="q-account-card__title">{l s='Order history and details' d='Shop.Theme.Customeraccount'}</h2>
            <p class="q-account-card__desc">{l s='Order history, package tracking' d='Shop.Theme.Customeraccount'}</p>
          </span>
        </a>
      {/if}

      <a class="q-account-card q-card" id="identity_main_link" href="{$urls.pages.identity}">
        <span class="q-account-card__icon"><svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/></svg></span>
        <span class="q-account-card__body">
          <h2 class="q-account-card__title">{l s='Information' d='Shop.Theme.Customeraccount'}</h2>
          <p class="q-account-card__desc">{l s='Name, e-mail, password' d='Shop.Theme.Customeraccount'}</p>
        </span>
      </a>

      {if $customer.addresses|count}
        <a class="q-account-card q-card" id="addresses_main_link" href="{$urls.pages.addresses}">
          <span class="q-account-card__icon"><svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6"/></svg></span>
          <span class="q-account-card__body">
            <h2 class="q-account-card__title">{l s='Addresses' d='Shop.Theme.Customeraccount'}</h2>
            <p class="q-account-card__desc">{l s='Shipping and billing addresses' d='Shop.Theme.Customeraccount'}</p>
          </span>
        </a>
      {else}
        <a class="q-account-card q-card" id="address_main_link" href="{$urls.pages.address}">
          <span class="q-account-card__icon"><svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M12.166 8.94c-.524 1.062-1.234 2.12-1.96 3.07A32 32 0 0 1 8 14.58a32 32 0 0 1-2.206-2.57c-.726-.95-1.436-2.008-1.96-3.07C3.304 7.867 3 6.862 3 6a5 5 0 0 1 10 0c0 .862-.305 1.867-.834 2.94M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10"/><path d="M8 8a2 2 0 1 1 0-4 2 2 0 0 1 0 4m0 1a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/></svg></span>
          <span class="q-account-card__body">
            <h2 class="q-account-card__title">{l s='Add first address' d='Shop.Theme.Customeraccount'}</h2>
            <p class="q-account-card__desc">{l s='Shipping and billing addresses' d='Shop.Theme.Customeraccount'}</p>
          </span>
        </a>
      {/if}

      {if $configuration.voucher_enabled && !$configuration.is_catalog}
        <a class="q-account-card q-card" id="discounts_main_link" href="{$urls.pages.discount}">
          <span class="q-account-card__icon"><svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M4 4.85v.9h1v-.9zm7 0v.9h1v-.9zm-7 1.8v.9h1v-.9zm7 0v.9h1v-.9zm-7 1.8v.9h1v-.9zm7 0v.9h1v-.9zm-7 1.8v.9h1v-.9zm7 0v.9h1v-.9z"/><path d="M1.5 3A1.5 1.5 0 0 0 0 4.5V6a.5.5 0 0 0 .5.5 1.5 1.5 0 1 1 0 3 .5.5 0 0 0-.5.5v1.5A1.5 1.5 0 0 0 1.5 13h13a1.5 1.5 0 0 0 1.5-1.5V10a.5.5 0 0 0-.5-.5 1.5 1.5 0 0 1 0-3A.5.5 0 0 0 16 6V4.5A1.5 1.5 0 0 0 14.5 3zM1 4.5a.5.5 0 0 1 .5-.5h13a.5.5 0 0 1 .5.5v1.05a2.5 2.5 0 0 0 0 4.9v1.05a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-1.05a2.5 2.5 0 0 0 0-4.9z"/></svg></span>
          <span class="q-account-card__body">
            <h2 class="q-account-card__title">{l s='Vouchers' d='Shop.Theme.Customeraccount'}</h2>
            <p class="q-account-card__desc">{l s='Your discount codes' d='Shop.Theme.Customeraccount'}</p>
          </span>
        </a>
      {/if}

      {if $configuration.return_enabled && !$configuration.is_catalog}
        <a class="q-account-card q-card" id="returns_main_link" href="{$urls.pages.order_follow}">
          <span class="q-account-card__icon"><svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M6.598 5.013a.144.144 0 0 1 .202.134V6.3a.5.5 0 0 0 .5.5c.667 0 2.013.005 3.3.822.984.624 1.99 1.76 2.595 3.876-1.02-.983-2.185-1.516-3.205-1.799a8.7 8.7 0 0 0-1.921-.306 7 7 0 0 0-.798.008h-.013l-.005.001h-.001L7.3 9.9l-.05-.498a.5.5 0 0 0-.45.498v1.153c0 .108-.11.176-.202.134L2.614 8.254l-.042-.028a.147.147 0 0 1 0-.252l.042-.028zM7.8 10.386q.103 0 .223.006c.434.02 1.034.086 1.7.271 1.326.368 2.896 1.202 3.94 3.08a.5.5 0 0 0 .933-.305c-.464-3.71-1.886-5.662-3.46-6.66-1.245-.79-2.527-.942-3.336-.971v-.66a1.144 1.144 0 0 0-1.767-.96l-3.994 2.94a1.147 1.147 0 0 0 0 1.946l3.994 2.94a1.144 1.144 0 0 0 1.767-.96z"/></svg></span>
          <span class="q-account-card__body">
            <h2 class="q-account-card__title">{l s='Merchandise returns' d='Shop.Theme.Customeraccount'}</h2>
            <p class="q-account-card__desc">{l s='Report a product return' d='Shop.Theme.Customeraccount'}</p>
          </span>
        </a>
      {/if}

      {if !$configuration.is_catalog}
        <a class="q-account-card q-card" id="order_slips_main_link" href="{$urls.pages.order_slip}">
          <span class="q-account-card__icon"><svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M5 4a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1zm-.5 2.5A.5.5 0 0 1 5 6h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1-.5-.5M5 8a.5.5 0 0 0 0 1h6a.5.5 0 0 0 0-1zm0 2a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1z"/><path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2zm10-1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1"/></svg></span>
          <span class="q-account-card__body">
            <h2 class="q-account-card__title">{l s='Credit slips' d='Shop.Theme.Customeraccount'}</h2>
            <p class="q-account-card__desc">{l s='Downloadable credit slip documents' d='Shop.Theme.Customeraccount'}</p>
          </span>
        </a>
      {/if}

      {block name='display_customer_account'}
        {hook h='displayCustomerAccount'}
      {/block}
    </div>
  {/block}

  {if !$configuration.is_catalog && $qAccount.recentOrders|default:[]|count}
    {block name='account_recent_orders'}
      {* Nagłówek przed kartą, nie w jej pasku — ten sam zabieg co przy
         nagłówkach sekcji w danych osobowych. *}
      <div class="q-account-section__header q-account-section__header--standalone">
        <h2 class="q-account-section__title">{l s='Recent orders' d='Shop.Theme.Customeraccount'}</h2>
        <a class="q-btn q-btn--secondary q-btn--sm" href="{$urls.pages.history}">
          {l s='View all' d='Shop.Theme.Customeraccount'}
          <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m6 4 4 4-4 4"/></svg>
        </a>
      </div>

      <div class="q-account-section q-card">
        {* Ta sama tabela co `customer/history.tpl` — 1:1, desktop i mobile,
           żeby nie utrzymywać dwóch różnych stylów tej samej listy
           zamówień. Tylko źródło danych inne: kilka ostatnich zamiast
           wszystkich. *}
        <div class="q-order-table-wrap">
          <table class="q-order-table">
            <thead>
              <tr>
                <th scope="col">{l s='Order reference' d='Shop.Theme.Checkout'}</th>
                <th scope="col">{l s='Date' d='Shop.Theme.Checkout'}</th>
                <th scope="col">{l s='Products' d='Shop.Theme.Customeraccount'}</th>
                <th scope="col">{l s='Total price' d='Shop.Theme.Checkout'}</th>
                <th scope="col">{l s='Status' d='Shop.Theme.Checkout'}</th>
                <th scope="col">{l s='Payment' d='Shop.Theme.Checkout'}</th>
                <th scope="col"><span class="visually-hidden">{l s='Actions' d='Shop.Theme.Checkout'}</span></th>
              </tr>
            </thead>
            <tbody>
              {foreach from=$qAccount.recentOrders item=qRow}
                {assign var='order' value=$qRow.order}
                {assign var='qTone' value=$qRow.statusTone}
                <tr>
                  <td class="q-order-table__cell--ref" data-label="{l s='Order reference' d='Shop.Theme.Checkout'}">
                    <span class="q-order-table__ref">
                      <a href="{$order.details.details_url}">{$order.details.reference}</a>
                    </span>
                  </td>
                  <td class="q-order-table__cell--date" data-label="{l s='Date' d='Shop.Theme.Checkout'}">{$order.details.order_date}</td>
                  <td class="q-order-table__cell--products" data-label="{l s='Products' d='Shop.Theme.Customeraccount'}">{$order.products|count}</td>
                  <td class="q-order-table__cell--price" data-label="{l s='Total price' d='Shop.Theme.Checkout'}"><strong>{$order.totals.total.value}</strong></td>
                  <td class="q-order-table__cell--status" data-label="{l s='Status' d='Shop.Theme.Checkout'}">
                    <span class="q-recent-order__status{if $qTone} q-recent-order__status--{$qTone}{/if}">
                      {if $qTone}<span class="q-recent-order__status-dot"></span>{/if}
                      {$order.history.current.ostate_name}
                    </span>
                  </td>
                  <td class="q-order-table__cell--payment" data-label="{l s='Payment' d='Shop.Theme.Checkout'}">{$order.details.payment}</td>
                  <td class="q-order-table__cell--actions" data-label="">
                    <a class="btn btn-outline-primary btn-sm" href="{$order.details.details_url}" data-link-action="view-order-details">
                      {l s='Details' d='Shop.Theme.Customeraccount'}
                    </a>
                  </td>
                </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      </div>
    {/block}
  {/if}
{/block}
