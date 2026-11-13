{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file='customer/page.tpl'}

{* Własny nagłówek zamiast domyślnego `page-title-section.tpl`, jak
   w pozostałych podstronach konta: link powrotu NAD tytułem. Układ jak
   w reszcie konta (nagłówek, karta, `.grid-table` ostylowany przy
   podglądzie zamówienia). *}
{block name='page_header_container'}
  <div class="q-order-header">
    <a class="q-order-back" href="{$urls.pages.my_account}">
      <svg class="q-order-back__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 13 6 8l5-5"/></svg>
      {l s='Back to your account' d='Shop.Theme.Customeraccount'}
    </a>
    <h1 class="q-order-header__title" tabindex="-1">{l s='Your vouchers' d='Shop.Theme.Customeraccount'}</h1>
    <p class="visually-hidden">{l s='View and manage your available vouchers and discount codes for use on your next purchase.' d='Shop.Theme.Customeraccount'}</p>
  </div>
{/block}

{block name='page_content'}
  {if $cart_rules}
    <div class="q-account-section q-card">
    <div class="grid-table" role="table" aria-label="{l s='Your vouchers' d='Shop.Theme.Customeraccount'}">
      <div class="grid-table__inner grid-table__inner--7" role="rowgroup">
        <div class="grid-table__header" role="row">
          <span class="grid-table__cell" role="columnheader">{l s='Code' d='Shop.Theme.Checkout'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Name' d='Shop.Theme.Checkout'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Quantity' d='Shop.Theme.Checkout'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Value' d='Shop.Theme.Checkout'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Minimum' d='Shop.Theme.Checkout'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Cumulative' d='Shop.Theme.Checkout'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Expiration date' d='Shop.Theme.Checkout'}</span>
        </div>

        {foreach from=$cart_rules item=cart_rule}
          <div class="grid-table__row" role="row">
            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Code' d='Shop.Theme.Checkout'}">
              <strong>{$cart_rule.code}</strong>
            </span>

            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Name' d='Shop.Theme.Checkout'}">
              <small class="text-secondary">{$cart_rule.name}</small>
            </span>

            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Quantity' d='Shop.Theme.Checkout'}">{$cart_rule.quantity_for_user}</span>

            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Value' d='Shop.Theme.Checkout'}">
              <strong>{$cart_rule.value}</strong>
            </span>

            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Minimum' d='Shop.Theme.Checkout'}">{$cart_rule.voucher_minimal}</span>

            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Cumulative' d='Shop.Theme.Checkout'}">{$cart_rule.voucher_cumulable}</span>

            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Expiration date' d='Shop.Theme.Checkout'}">
              <small class="text-secondary">{$cart_rule.voucher_date}</small>
            </span>
          </div>
        {/foreach}
      </div>
    </div>
    </div>
  {else}
    <div class="alert alert-info" role="alert">
      <svg class="q-alert__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/></svg>
      <span class="q-alert__body">{l s='You do not have any vouchers.' d='Shop.Notifications.Warning'}</span>
    </div>
  {/if}
{/block}
