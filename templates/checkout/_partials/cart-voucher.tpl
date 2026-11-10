{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{if $cart.vouchers.allowed}
  {block name='cart_voucher'}
    <div class="js-cart-voucher q-voucher-wrap" data-ps-ref="voucher-container" tabindex="-1">

      {if $cart.vouchers.added}
        {block name='cart_voucher_list'}
          {foreach from=$cart.vouchers.added item=voucher}
            <div class="q-ordersum__tr">
              <span>{$voucher.name}</span>
              <span>
                {$voucher.reduction_formatted}
                {if isset($voucher.code) && $voucher.code !== ''}
                  <a class="q-ordersum__voucher-off" href="{$voucher.delete_url}"
                     data-link-action="remove-voucher" data-ps-ref="voucher-remove-button"
                     aria-label="{l s='Remove voucher: %voucherName%' sprintf=['%voucherName%' => $voucher.name] d='Shop.Theme.Checkout'}">
                    <svg width="13" height="13" viewBox="0 0 16 16" fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>
                  </a>
                {/if}
              </span>
            </div>
          {/foreach}
        {/block}
      {/if}

      {* Pole kodu rozwija natywny `<details>` — bez JS, tak jak w projekcie
         koszyka. Ikona, tekst i szewron w `<summary>`; przeglądarka sama
         obsługuje rozwijanie i stan `[open]`. *}
      <details class="q-voucher" id="q-voucher-form">
        <summary class="q-voucher__toggle">
          <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2 2a1 1 0 0 0-1 1v4.586a1 1 0 0 0 .293.707l7 7a1 1 0 0 0 1.414 0l4.586-4.586a1 1 0 0 0 0-1.414l-7-7A1 1 0 0 0 6.586 2zm2.5 4a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3"/></svg>
          {l s='Have a promo code?' d='Shop.Theme.Checkout'}
          <svg class="q-voucher__chev" width="13" height="13" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m4 6 4 4 4-4"/></svg>
        </summary>

        {block name='cart_voucher_form'}
          <form class="q-voucher__form" action="{$urls.pages.cart}" method="post"
                data-link-action="add-voucher" data-ps-ref="voucher-form">
            <input type="hidden" name="token" value="{$static_token}">
            <input type="hidden" name="addDiscount" value="1">
            <input class="form-control js-voucher-input" type="text" name="discount_name"
                   placeholder="{l s='Enter your code' d='Shop.Theme.Checkout'}"
                   aria-label="{l s='Promo code' d='Shop.Theme.Checkout'}" required>
            <button class="q-btn q-btn--secondary" type="submit">{l s='Apply' d='Shop.Theme.Actions'}</button>
          </form>
        {/block}

        {block name='cart_voucher_notifications'}
          <div class="q-voucher__error js-error" role="alert" tabindex="-1"
               style="display: none;" data-ps-ref="voucher-error">
            <span class="js-error-text"></span>
          </div>
        {/block}
      </details>
    </div>
  {/block}
{/if}
