{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Ten sam komponent kolumny, co w kasie (`cart-summary.tpl`), tylko na
   danych zamówienia zamiast koszyka: nie ma już czego edytować ani płacić,
   więc nie ma tu stopki ani linku "Edytuj w koszyku". *}
<div id="js-order-confirmation-summary">
  <button class="q-ordersum__head" type="button" data-q-sum-toggle
          aria-controls="q-ordersum-body" aria-expanded="true">
    <b>{l s='Your order' d='Shop.Theme.Checkout'}</b>

    <span class="q-ordersum__mini" aria-hidden="true">
      {foreach from=$order.products item=product name=mini}
        {if $smarty.foreach.mini.index < 3}
          <i{if $product.default_image} style="background-image:url({$product.default_image.small.url})"{/if}></i>
        {/if}
      {/foreach}
    </span>

    <svg class="q-ordersum__chev" width="20" height="20" viewBox="0 0 24 24" fill="none"
         stroke="currentColor" stroke-width="2.5" aria-hidden="true"><path d="M6 9l6 6 6-6"/></svg>
  </button>

  <div class="q-ordersum__body" id="q-ordersum-body">
    <div class="q-ordersum__top">
      <b>{l s='Products (%count%)' sprintf=['%count%' => $order.products_count] d='Shop.Theme.Checkout'}</b>
    </div>

    {include file='checkout/_partials/order-confirmation-table.tpl'
      products=$order.products
      subtotals=$order.subtotals
      totals=$order.totals
      labels=$order.labels
      add_product_link=false
    }
  </div>

  <div class="q-ordersum__grand">
    <b>{$order.totals.total.label}</b>
    <span class="q-ordersum__grand-value">{$order.totals.total.value}</span>
  </div>
</div>
