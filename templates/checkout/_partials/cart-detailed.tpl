{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='cart_detailed_product'}
  <div class="cart__overview cart-overview js-cart"
    data-refresh-url="{url entity='cart' params=['ajax' => true, 'action' => 'refresh']}"
    tabindex="-1"
  >
    {if $cart.products}
      {* Ten sam pasek, co w szufladzie koszyka: ten sam modyfikator danych
         (`|qfreeshipping`), ta sama treść, tylko inne opakowanie wizualne. *}
      {assign var=qDostawa value=$cart|qfreeshipping}
      {if $qDostawa}
        <div class="q-shipping q-cart__shipping{if $qDostawa.reached} q-shipping--done{/if}">
          {if $qDostawa.reached}
            <span class="q-shipping__label">{l s='You get free delivery' d='Shop.Theme.Checkout'}</span>
          {else}
            {capture name='qBrak'}<b>{$qDostawa.missing_formatted}</b>{/capture}
            <span class="q-shipping__label">{l s='You are %amount% away from free delivery' sprintf=['%amount%' => $smarty.capture.qBrak] d='Shop.Theme.Checkout'}</span>
          {/if}
          <span class="q-shipping__track"><span class="q-shipping__fill" style="inline-size:{$qDostawa.percent|intval}%"></span></span>
        </div>
      {/if}

      <ul class="q-cart__lines js-cart-list" role="list" aria-label="{l s='Products in cart' d='Shop.Theme.Checkout'}">
        {foreach from=$cart.products item=product}
          {block name='cart_detailed_product_line'}
            {include file='checkout/_partials/cart-detailed-product-line.tpl' product=$product}
          {/block}
        {/foreach}
      </ul>
    {else}
      <p class="q-cart__empty">{l s='There are no more items in your cart' d='Shop.Theme.Checkout'}</p>
    {/if}
  </div>
{/block}
