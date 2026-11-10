{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='order_products_table'}
  <div class="grid-table grid-table--collapse mb-0" role="table" aria-label="{l s='Products details' d='Shop.Theme.Customeraccount'}">
    <div class="grid-table__inner grid-table__inner--4" role="rowgroup">
      <div class="grid-table__header" role="row">
        <span class="grid-table__cell" role="columnheader">{l s='Product' d='Shop.Theme.Catalog'}</span>
        <span class="grid-table__cell grid-table__cell--center" role="columnheader">{l s='Quantity' d='Shop.Theme.Catalog'}</span>
        <span class="grid-table__cell grid-table__cell--center" role="columnheader">{l s='Unit price' d='Shop.Theme.Catalog'}</span>
        <span class="grid-table__cell grid-table__cell--right" role="columnheader">{l s='Total price' d='Shop.Theme.Catalog'}</span>
      </div>

      {foreach $order->order_shipments['physical_products'] item=shipment}
        {foreach from=$shipment['products'] item=product}
          {assign var="is_last_product" value=($product@last && empty($order->order_shipments['virtual_products']))}

          {include 
            file='./order-detail-product-line-no-return.tpl' 
            product=$product 
            carrier_name=$shipment['carrier']['name']
            is_last_product=$is_last_product
          }
        {/foreach}
      {/foreach}

      {foreach $order->order_shipments['virtual_products'] item=product}
        {include file='./order-detail-product-line-no-return.tpl' product=$product is_last_product=$product@last}
      {/foreach}
    </div>
  </div>

  <div class="q-order-totals">
    {foreach $order.subtotals as $line}
      {if $line.value}
        <div class="q-order-totals__row">
          <span>{$line.label}</span>
          <span>{$line.value}</span>
        </div>
      {/if}
    {/foreach}

    <div class="q-order-totals__row q-order-totals__row--total">
      <span>{$order.totals.total.label}</span>
      <span>{$order.totals.total.value}</span>
    </div>
  </div>
{/block}
