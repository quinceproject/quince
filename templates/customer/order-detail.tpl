{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file='customer/page.tpl'}

{* Własny nagłówek zamiast domyślnego `page-title-section.tpl` — makieta
   stawia link powrotu NAD tytułem, a domyślny układ bloków w `page.tpl`
   rysuje je w odwrotnej kolejności (najpierw tytuł, potem `account_link`). *}
{block name='page_header_container'}
  <div class="q-order-header">
    <a class="q-order-back" href="{$urls.pages.history}">
      <svg class="q-order-back__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 13 6 8l5-5"/></svg>
      {l s='Order history' d='Shop.Theme.Customeraccount'}
    </a>
    <h1 class="q-order-header__title" tabindex="-1">
      {l s='Order %reference%' sprintf=['%reference%' => $order.details.reference] d='Shop.Theme.Customeraccount'}
    </h1>
  </div>
{/block}

{block name='page_content'}
  {block name='display_customer_account_top'}
    {hook h='displayCustomerAccountTop'}
  {/block}

  {assign var='qTone' value=$order.history.current.id_order_state|qstatustone}

  {block name='order_infos'}
    <div class="q-order-info q-card">
      <div class="q-order-info__item">
        <span class="q-order-info__label">{l s='Order reference' d='Shop.Theme.Checkout'}</span>
        <span class="q-order-info__value">{$order.details.reference}</span>
      </div>

      <div class="q-order-info__item">
        <span class="q-order-info__label">{l s='Date' d='Shop.Theme.Global'}</span>
        <span class="q-order-info__value">{$order.details.order_date}</span>
      </div>

      <div class="q-order-info__item">
        <span class="q-order-info__label">{l s='Payment' d='Shop.Theme.Checkout'}</span>
        <span class="q-order-info__value">{$order.details.payment}</span>
      </div>

      <div class="q-order-info__item">
        <span class="q-order-info__label">{l s='Status' d='Shop.Theme.Checkout'}</span>
        <span class="q-order-info__value">
          <span class="q-recent-order__status{if $qTone} q-recent-order__status--{$qTone}{/if}">
            {if $qTone}<span class="q-recent-order__status-dot"></span>{/if}
            {$order.history.current.ostate_name}
          </span>
        </span>
      </div>

      <div class="q-order-info__item q-order-info__item--amount">
        <span class="q-order-info__label">{l s='Total' d='Shop.Theme.Checkout'}</span>
        <span class="q-order-info__value q-order-info__value--lg">{$order.totals.total.value}</span>
      </div>
    </div>

    {if $order.details.invoice_url || $order.details.reorder_url}
      <div class="q-order-actions">
        {if $order.details.invoice_url}
          <a class="btn btn-outline-primary btn-sm" href="{$order.details.invoice_url}">
            <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M14 4.5V11h-1V4.5h-2A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v9H2V2a2 2 0 0 1 2-2h5.5zm-3-3.5v2a.5.5 0 0 0 .5.5h2z"/><path d="M4.603 14.087a.81.81 0 0 1-.438-.42c-.195-.388-.13-.776.08-1.102.198-.307.526-.568.897-.787a7.7 7.7 0 0 1 1.482-.645 20 20 0 0 0 1.062-2.227 7.3 7.3 0 0 1-.43-1.295c-.086-.4-.119-.796-.046-1.136.075-.354.274-.672.65-.823.192-.077.4-.11.602-.077a.7.7 0 0 1 .477.365c.088.164.12.356.127.538.007.187-.012.395-.047.614-.084.51-.27 1.134-.52 1.794a11 11 0 0 0 .98 1.686 5.8 5.8 0 0 1 1.334.05c.364.066.734.195.96.465.12.144.193.32.2.518.007.192-.047.382-.138.563a1.04 1.04 0 0 1-.354.416.86.86 0 0 1-.51.138c-.331-.014-.654-.196-.933-.417a5.7 5.7 0 0 1-.911-.95 11.6 11.6 0 0 0-1.997.406 11.3 11.3 0 0 1-1.021 1.51c-.37.470-.78.858-1.218 1.056a1.13 1.13 0 0 1-.783.07zm1.379-1.901q-.25.115-.459.238c-.328.194-.541.383-.647.547-.094.145-.096.25-.04.361a.04.04 0 0 0 .01.016l.004.001q.01.004.026-.002c.079-.034.08-.034.08-.034.274-.098.634-.422 1.026-.925zm1.293-1.072c.265-.078.535-.147.804-.207a7.6 7.6 0 0 1-.497-.805 9 9 0 0 1-.307 1.012m1.629-1.605q-.078-.146-.158-.302c-.159.36-.318.715-.471 1.056q.306-.148.629-.754m-.619-2.252c.03.135.064.274.108.418l.047-.164c.028-.165.024-.280.003-.37a.3.3 0 0 0-.02-.056.4.4 0 0 0-.038.017c-.013.023-.032.063-.044.113-.016.067-.019.146-.002.252z"/></svg>
            {l s='Download invoice' d='Shop.Theme.Customeraccount'}
          </a>
        {/if}

        {if $order.details.reorder_url}
          <a class="btn btn-primary btn-sm" href="{$order.details.reorder_url}">
            <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2z"/><path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466"/></svg>
            {l s='Reorder' d='Shop.Theme.Actions'}
          </a>
        {/if}
      </div>
    {/if}
  {/block}

  {capture name='displayOrderDetail'}{$HOOK_DISPLAYORDERDETAIL nofilter}{/capture}

  <div class="q-order-layout">
    <div class="q-order-layout__main">

      {block name='order_products'}
        <section class="q-account-section q-card">
          <div class="q-account-section__header">
            <h2 class="q-account-section__title">
              {l s='Products (%count%)' sprintf=['%count%' => $order.products|count] d='Shop.Theme.Customeraccount'}
            </h2>
          </div>

          <div class="q-order-products">
            {block name='order_detail'}
              {if $order.details.is_returnable}
                {if $order.shipments}
                  {include file='customer/_partials/order-detail-return-multishipment.tpl'}
                {else}
                  {include file='customer/_partials/order-detail-return.tpl'}
                {/if}
              {else}
                {if $order.shipments}
                  {include file='customer/_partials/order-detail-no-return-multishipment.tpl'}
                {else}
                  {include file='customer/_partials/order-detail-no-return.tpl'}
                {/if}
              {/if}
            {/block}
          </div>
        </section>
      {/block}

      {* Haki stron zamówienia (np. odstąpienie od umowy) stoją TUTAJ, zaraz
         za produktami/zwrotem, a nie po adresach: to ta sama rodzina decyzji
         co zwrot towaru i ma stać obok niego, nie oddzielona adresami. *}
      {if $smarty.capture.displayOrderDetail}
        <div class="q-order-hook">{$smarty.capture.displayOrderDetail nofilter}</div>
      {/if}

      {block name='order_addresses'}
        <div class="q-order-addresses">
          {if $order.addresses.delivery}
            <section class="q-account-section q-card">
              <div class="q-account-section__header">
                <h3 class="q-account-section__title">{l s='Delivery address' d='Shop.Theme.Customeraccount'}</h3>
              </div>
              <div class="q-order-address">{$order.addresses.delivery.formatted nofilter}</div>
            </section>
          {/if}

          <section class="q-account-section q-card">
            <div class="q-account-section__header">
              <h3 class="q-account-section__title">{l s='Invoice address' d='Shop.Theme.Customeraccount'}</h3>
            </div>
            <div class="q-order-address">{$order.addresses.invoice.formatted nofilter}</div>
          </section>
        </div>
      {/block}
    </div>

    <div class="q-order-layout__side">

      {block name='order_status'}
        <section class="q-account-section q-card">
          <div class="q-account-section__header">
            <h3 class="q-account-section__title">{l s='Order status' d='Shop.Theme.Customeraccount'}</h3>
          </div>

          <div class="q-order-timeline">
            {foreach from=$order.history item=qState}
              {assign var='qStateTone' value=$qState.id_order_state|qstatustone}
              <div class="q-order-timeline__item{if $qStateTone} q-order-timeline__item--{$qStateTone}{/if}">
                <span class="q-order-timeline__dot"></span>
                <div class="q-order-timeline__content">
                  <div class="q-order-timeline__title">{$qState.ostate_name}</div>
                  <div class="q-order-timeline__date">{$qState.history_date}</div>
                </div>
              </div>
            {/foreach}
          </div>
        </section>
      {/block}

      {block name='order_carriers'}
        {if $order.shipping}
          <section class="q-account-section q-card">
            <div class="q-account-section__header">
              <h3 class="q-account-section__title">{l s='Shipment tracking details' d='Shop.Theme.Customeraccount'}</h3>
            </div>

            <div class="q-order-track-list">
              {foreach from=$order.shipping item=qShip name=qShipping}
                {assign var='qTrackUrl' value=''}
                {if isset($qShip.carrier_tracking_url) && $qShip.carrier_tracking_url}
                  {assign var='qTrackUrl' value=$qShip.carrier_tracking_url}
                {elseif isset($qShip.url) && $qShip.url && $qShip.tracking_number}
                  {assign var='qTrackUrl' value=$qShip.url|replace:'@':$qShip.tracking_number}
                {/if}

                <div class="q-order-track{if !$smarty.foreach.qShipping.last} q-order-track--sep{/if}">
                  {if $qShip.carrier_name}
                    <div class="q-order-track__carrier">{$qShip.carrier_name}</div>
                  {/if}

                  {if $qShip.tracking_number}
                    <div class="q-order-track__number">
                      {l s='Tracking number' d='Shop.Theme.Checkout'}:
                      <span class="q-order-track__code">{$qShip.tracking_number}</span>
                    </div>
                  {/if}

                  {if $qTrackUrl}
                    <a class="btn btn-outline-primary btn-sm q-btn--block" href="{$qTrackUrl}" target="_blank" rel="noopener">
                      <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M8.636 3.5a.5.5 0 0 0-.5-.5H1.5A1.5 1.5 0 0 0 0 4.5v10A1.5 1.5 0 0 0 1.5 16h10a1.5 1.5 0 0 0 1.5-1.5V7.864a.5.5 0 0 0-1 0V14.5a.5.5 0 0 1-.5.5h-10a.5.5 0 0 1-.5-.5v-10a.5.5 0 0 1 .5-.5h6.636a.5.5 0 0 0 .5-.5"/><path fill-rule="evenodd" d="M16 .5a.5.5 0 0 0-.5-.5h-5a.5.5 0 0 0 0 1h3.793L6.146 9.146a.5.5 0 1 0 .708.708L15 1.707V5.5a.5.5 0 0 0 1 0z"/></svg>
                      {l s='Track with %carrier_name%' sprintf=['%carrier_name%' => $qShip.carrier_name] d='Shop.Theme.Customeraccount'}
                    </a>
                  {/if}
                </div>
              {/foreach}
            </div>
          </section>
        {/if}
      {/block}

      {block name='order_messages'}
        <section class="q-account-section q-card">
          <div class="q-account-section__header">
            <h3 class="q-account-section__title">{l s='Messages' d='Shop.Theme.Customeraccount'}</h3>
          </div>

          {if $order.messages}
            <div class="q-order-message-list">
              {foreach from=$order.messages item=qMessage}
                <div class="q-order-message">
                  <div class="q-order-message__meta">
                    <strong>{$qMessage.name}</strong> · {$qMessage.message_date}
                  </div>
                  <p class="q-order-message__text">{$qMessage.message nofilter}</p>
                </div>
              {/foreach}
            </div>
          {/if}

          <form class="q-order-message-form" action="{$urls.pages.order_detail}" method="post" data-ps-action="form-validation">
            {if $order.products|count > 1}
              <div class="q-order-message-form__row">
                <label class="visually-hidden" for="product_select_message">{l s='Product' d='Shop.Forms.Labels'}</label>
                <select name="id_product" class="form-select" id="product_select_message">
                  <option value="0">{l s='-- choose a product --' d='Shop.Forms.Labels'}</option>
                  {foreach from=$order.products item=qProduct}
                    <option value="{$qProduct.id_product}">{$qProduct.name}</option>
                  {/foreach}
                </select>
              </div>
            {/if}

            <label class="visually-hidden" for="message_text">{l s='Message' d='Shop.Forms.Labels'}</label>
            <textarea
              rows="2"
              name="msgText"
              id="message_text"
              class="form-control q-order-message-form__text"
              placeholder="{l s='Write a message to the seller...' d='Shop.Theme.Customeraccount'}"
              required
            ></textarea>

            <div class="q-order-message-form__actions">
              <input type="hidden" name="id_order" value="{$order.details.id}">
              <button type="submit" name="submitMessage" class="btn btn-primary btn-sm" data-ps-action="form-validation-submit">
                {l s='Send' d='Shop.Theme.Actions'}
              </button>
            </div>
          </form>
        </section>
      {/block}
    </div>
  </div>
{/block}
