{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='cart_detailed_actions'}
  {$disableCheckout = false}

  {foreach $cart.products as $product}
      {if isset($product.availability) && $product.availability == 'unavailable' }
          {$disableCheckout = true}
      {/if}
  {/foreach}

  <div class="js-cart-detailed-actions">
    {if $cart.minimalPurchaseRequired}
      <p class="q-ordersum__tax">{$cart.minimalPurchaseRequired}</p>
      <button type="button" class="q-btn q-btn--primary q-btn--lg q-cart__checkout" disabled>{l s='Proceed to checkout' d='Shop.Theme.Actions'}</button>
    {elseif empty($cart.products) || $disableCheckout === true}
      <button type="button" class="q-btn q-btn--primary q-btn--lg q-cart__checkout" disabled>{l s='Proceed to checkout' d='Shop.Theme.Actions'}</button>
    {else}
      <a href="{$urls.pages.order}" class="q-btn q-btn--primary q-btn--lg q-cart__checkout">
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 1a2 2 0 0 0-2 2v4a2 2 0 1 0 4 0V3a2 2 0 0 0-2-2M3 7a5 5 0 0 0 10 0h-1a4 4 0 0 1-8 0z"/><path d="M4 6.5V7a4 4 0 0 0 8 0v-.5h1.5A1.5 1.5 0 0 1 15 8v5.5a1.5 1.5 0 0 1-1.5 1.5h-11A1.5 1.5 0 0 1 1 13.5V8a1.5 1.5 0 0 1 1.5-1.5z"/></svg>
        {l s='Proceed to checkout' d='Shop.Theme.Actions'}
      </a>

      {hook h='displayExpressCheckout'}
    {/if}
  </div>
{/block}
