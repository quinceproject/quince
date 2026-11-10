{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends 'customer/page.tpl'}

{* Własny nagłówek zamiast domyślnego `page-title-section.tpl` — ten sam
   powód co w `order-detail.tpl`: makieta stawia link powrotu NAD tytułem,
   domyślny układ bloków w `page.tpl` rysuje je w odwrotnej kolejności. *}
{block name='page_header_container'}
  <div class="q-order-header">
    <a class="q-order-back" href="{$urls.pages.my_account}">
      <svg class="q-order-back__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 13 6 8l5-5"/></svg>
      {l s='Back to your account' d='Shop.Theme.Customeraccount'}
    </a>
    <h1 class="q-order-header__title" tabindex="-1">{l s='Order history' d='Shop.Theme.Customeraccount'}</h1>
  </div>
{/block}

{block name='page_content'}
  {if $orders}
    <div class="q-account-section q-card">
      <div class="q-order-table-wrap">
        <table class="q-order-table" aria-describedby="order_history_description">
          <caption class="visually-hidden" id="order_history_description">
            {l s='Here are the orders you\'ve placed since your account was created.' d='Shop.Theme.Customeraccount'}
          </caption>
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
            {foreach from=$orders item=order}
              {assign var='qTone' value=$order.history.current.id_order_state|qstatustone}
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

    <p class="q-order-hint">
      <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/></svg>
      {l s='To reorder the same products, open the order details and click "Reorder".' d='Shop.Theme.Customeraccount'}
    </p>
  {else}
    <div class="alert alert-info" role="alert">{l s='You have not placed any orders.' d='Shop.Notifications.Warning'}</div>
  {/if}
{/block}
