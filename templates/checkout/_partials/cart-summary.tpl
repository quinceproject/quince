{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Kolumna zamówienia z prototypu checkoutu.
   Zwijana głowa, ciało z pozycjami i kwotami, a kwota do zapłaty POZA
   ciałem — po zwinięciu klient dalej widzi, ile płaci.

   `js-cart` i `data-refresh-url` zostają: rdzeń po tych zaczepach
   przerysowuje kwoty po zmianie przewoźnika. *}
<div id="js-checkout-summary" class="js-cart" data-refresh-url="{$urls.pages.cart}?ajax=1&action=refresh">

  {block name='cart_summary_head'}
    <button class="q-ordersum__head" type="button" data-q-sum-toggle
            aria-controls="q-ordersum-body" aria-expanded="true">
      <b>{l s='Your order' d='Shop.Theme.Checkout'}</b>

      {* Miniatury widoczne dopiero po zwinięciu kolumny. *}
      <span class="q-ordersum__mini" aria-hidden="true">
        {foreach from=$cart.products item=product name=mini}
          {if $smarty.foreach.mini.index < 3}
            <i{if $product.default_image} style="background-image:url({$product.default_image.small.url})"{/if}></i>
          {/if}
        {/foreach}
      </span>

      <svg class="q-ordersum__chev" width="20" height="20" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2.5" aria-hidden="true"><path d="M6 9l6 6 6-6"/></svg>
    </button>
  {/block}

  <div class="q-ordersum__body" id="q-ordersum-body">
    {block name='cart_summary_top_row'}
      <div class="q-ordersum__top">
        <b>{l s='Products (%count%)' sprintf=['%count%' => $cart.products_count] d='Shop.Theme.Checkout'}</b>
        <a href="{$urls.pages.cart}?action=show">{l s='Edit in cart' d='Shop.Theme.Checkout'}</a>
      </div>
    {/block}

    {block name='hook_checkout_summary_top'}
      {include file='checkout/_partials/cart-summary-top.tpl' cart=$cart}
    {/block}

    {block name='cart_summary_products'}
      {include file='checkout/_partials/cart-summary-products.tpl' cart=$cart}
    {/block}

    {block name='cart_summary_voucher'}
      {include file='checkout/_partials/cart-voucher.tpl'}
    {/block}

    {block name='cart_summary_subtotals'}
      {include file='checkout/_partials/cart-summary-subtotals.tpl' cart=$cart}
    {/block}
  </div>

  {block name='cart_summary_totals'}
    {include file='checkout/_partials/cart-summary-totals.tpl' cart=$cart}
  {/block}
</div>
