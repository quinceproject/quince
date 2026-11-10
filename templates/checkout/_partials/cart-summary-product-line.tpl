{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{block name='cart_summary_product_line'}
  <div class="q-ordersum__item">
    {if $product.default_image}
      <img class="q-ordersum__thumb" src="{$product.default_image.small.url}"
           width="{$product.default_image.small.width}" height="{$product.default_image.small.height}"
           loading="lazy" alt="">
    {else}
      <span class="q-ordersum__thumb"></span>
    {/if}

    <div class="q-ordersum__nm">
      {$product.name}
      <small>
        {l s='%quantity% pcs.' sprintf=['%quantity%' => $product.quantity] d='Shop.Theme.Checkout'}
        {if !empty($product.attributes)}
          · {foreach from=$product.attributes item="value" name="attrs"}{$value}{if !$smarty.foreach.attrs.last}, {/if}{/foreach}
        {/if}
      </small>
    </div>

    <div class="q-ordersum__pr">{$product.total}</div>
  </div>
{/block}
