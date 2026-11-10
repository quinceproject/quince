{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Odmiana pozycji koszyka z szuflady (`q-cartline`), szersza, z własną
   kolumną na cechy wariantu, stan magazynu, cenę jednostkową i kwotę.
   Nazwy stanów magazynowych — patrz `catalog/_partials/product-availability.tpl`. *}
{if $product.availability == 'in_stock' || $product.availability == 'available'}
  {assign var=qKlasaStanu value='q-stock--in'}
{elseif $product.availability == 'last_remaining_items'}
  {assign var=qKlasaStanu value='q-stock--low'}
{else}
  {assign var=qKlasaStanu value='q-stock--out'}
{/if}

<li class="product-line js-cart-item q-cartline q-cartline--page" role="listitem"
    data-q-cart-line="{$product.id_product|intval}-{$product.id_product_attribute|intval}-{$product.id_customization|intval}"
    data-id-product="{$product.id_product|intval}"
    data-id-product-attribute="{$product.id_product_attribute|intval}"
    data-id-customization="{$product.id_customization|intval}">
  <a class="q-cartline__media product-line__image product-line__item" href="{$product.url}"
     data-id_customization="{$product.id_customization|intval}">
    {if $product.default_image}
      <img src="{$product.default_image.small.url}" loading="lazy"
           width="{$product.default_image.small.width}" height="{$product.default_image.small.height}"
           alt="{$product.name|escape:'quotes'}">
    {else}
      <img src="{$urls.no_picture_image.small.url}" loading="lazy"
           width="{$urls.no_picture_image.small.width}" height="{$urls.no_picture_image.small.height}" alt="">
    {/if}
  </a>

  <div class="q-cartline__body product-line__content product-line__content-left">
    <a class="q-cartline__name product-line__title product-line__item" href="{$product.url}"
       data-id_customization="{$product.id_customization|intval}">
      {$product.name}
    </a>

    {if is_array($product.customizations) && $product.customizations|count}
      {include file='catalog/_partials/product-customization-modal.tpl' product=$product}
    {/if}

    {if $product.attributes|count}
      <dl class="q-cartline__attrs">
        {foreach from=$product.attributes key="attribute" item="value"}
          <div class="q-cartline__attr"><dt>{$attribute}</dt><dd>{$value}</dd></div>
        {/foreach}
      </dl>
    {/if}

    {if !empty($product.availability_message)}
      <p class="q-stock {$qKlasaStanu} q-cartline__stock"><span class="q-stock__dot"></span>{$product.availability_message}</p>
    {/if}

    {if !empty($product.delivery_information)}
      <p class="q-cartline__stock">{$product.delivery_information}</p>
    {/if}

    {hook h='displayCartExtraProductInfo' product=$product}
  </div>

  {if !empty($product.is_gift)}
    <span class="q-cartline__unit">
      <i class="material-icons" aria-hidden="true">&#xE8B1;</i>{$product.quantity} {l s='Gift(s)' d='Shop.Theme.Checkout'}
    </span>
  {else}
    <div class="q-cartline__unit">
      <span class="q-price">
        <span class="q-price__current{if $product.has_discount} q-price__current--promo{/if}">{$product.price}</span>
        {if $product.has_discount}<span class="q-price__old">{$product.regular_price}</span>{/if}
      </span>
      {if $product.has_discount}
        <span class="q-badge q-badge--discount">
          -{if $product.discount_type === 'percentage'}{$product.discount_percentage_absolute}{else}{$product.discount_to_display}{/if}
        </span>
      {/if}
    </div>

    {* Te same zaczepy, co w szufladzie koszyka (`data-q-cart-*`) — jeden
       skrypt (`cart-qty.js`) obsługuje obie. *}
    <div class="q-cartline__qty product-line__quantity-button quantity-button js-quantity-button">
      <div class="q-qty">
        <button class="q-qty__btn" type="button" data-q-cart-qty="-" data-q-cart-url="{$product.update_quantity_url}"
                aria-label="{l s='Decrease quantity of %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}">
          <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M2 8a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11A.5.5 0 0 1 2 8"/></svg>
        </button>

        <input class="q-qty__input"
               type="number" inputmode="numeric" pattern="[0-9]+"
               data-q-cart-input data-q-cart-url="{$product.update_quantity_url}"
               data-quantity="{$product.quantity|intval}"
               value="{$product.quantity}"
               min="{$product.minimal_quantity}"
               aria-label="{l s='Change quantity of %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}">

        <button class="q-qty__btn" type="button" data-q-cart-qty="+" data-q-cart-url="{$product.update_quantity_url}"
                aria-label="{l s='Increase quantity of %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}">
          <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2"/></svg>
        </button>
      </div>
    </div>

    <div class="q-cartline__total">{$product.total}</div>
  {/if}

  <div class="q-cartline__actions product-line__actions">
    {if empty($product.is_gift)}
      <button class="q-cartline__remove" type="button" data-q-cart-remove="{$product.remove_from_cart_url}"
         aria-label="{l s='Remove %productName% from cart' sprintf=['%productName%' => $product.name] d='Shop.Theme.Checkout'}"
      >
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/><path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4z"/></svg>
      </button>
    {/if}

    {block name='hook_cart_extra_product_actions'}
      {hook h='displayCartExtraProductActions' product=$product}
    {/block}
  </div>
</li>
