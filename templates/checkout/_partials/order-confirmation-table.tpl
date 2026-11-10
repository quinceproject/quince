{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='order-confirmation-classes'}{/block}

{foreach from=$products item=product}
  <div class="q-ordersum__item">
    {if !empty($product.default_image)}
      <img class="q-ordersum__thumb" src="{$product.default_image.small.url}" loading="lazy"
           width="{$product.default_image.small.width}" height="{$product.default_image.small.height}"
           alt="{$product.default_image.legend}">
    {else}
      <img class="q-ordersum__thumb" src="{$urls.no_picture_image.small.url}" loading="lazy"
           width="{$urls.no_picture_image.small.width}" height="{$urls.no_picture_image.small.height}" alt="">
    {/if}

    <div class="q-ordersum__nm">
      {if $add_product_link}<a href="{$product.url}" target="_blank">{/if}
        {$product.name}
      {if $add_product_link}</a>{/if}
      <small>
        {if !empty($product.is_gift)}
          {$product.quantity} {l s='Gift(s)' d='Shop.Theme.Checkout'}
        {else}
          {if !empty($product.quantity) && $product.quantity > 1}{l s='x%quantity%' sprintf=['%quantity%' => $product.quantity] d='Shop.Theme.Global'}{/if}
          {if !empty($product.reference)}{l s='Reference:' d='Shop.Theme.Catalog'} {$product.reference}{/if}
        {/if}
      </small>
    </div>

    <div class="q-ordersum__pr">{if empty($product.is_gift)}{$product.total}{/if}</div>
  </div>
{/foreach}

{* Suma do zapłaty stoi poza tym blokiem, w `.q-ordersum__grand` — tu zostaje
   tylko rozbicie na składowe, tak jak w kolumnie kasy. *}
<div class="q-ordersum__tot">
  {foreach $subtotals as $subtotal}
    {if $subtotal !== null && $subtotal.type !== 'tax' && $subtotal.label !== null}
      <div class="q-ordersum__tr">
        <span>{$subtotal.label}</span>
        <span>{if 'discount' == $subtotal.type}-&nbsp;{/if}{$subtotal.value}</span>
      </div>
    {/if}
  {/foreach}

  {if $subtotals.tax !== null && $subtotals.tax.label !== null}
    <div class="q-ordersum__tr">
      <span>{l s='%label%:' sprintf=['%label%' => $subtotals.tax.label] d='Shop.Theme.Global'}</span>
      <span>{$subtotals.tax.value}</span>
    </div>
  {/if}
</div>
