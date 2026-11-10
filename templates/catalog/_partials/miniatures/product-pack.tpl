{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{* Zdjęcie zestawu: okładka produktu, a gdy jej nie ma — zastępnik sklepu.
   Rozmiary bierzemy skrótami rdzenia (`small`, `medium`), nie nazwami presetów,
   więc motyw nie zależy od tego, jakie typy obrazów ma sklep. *}
{if $product.default_image}
  {assign var=qZdjecie value=$product.default_image}
{else}
  {* Nie `|default:` — PrestaShop oddaje tu `false`, a ten filtr podmienia tylko
     wartość nieustawioną albo pustą i `false` przepuszcza dalej. *}
  {assign var=qZdjecie value=$urls.no_picture_image}
{/if}


{block name='pack_miniature_item'}
  <article class="product-pack__item">
    <a href="{$product.url}"
      class="product-pack__link"
      aria-labelledby="pack-product-{$product.id_product}"
    >
      <span class="product-pack__image-wrapper">
        {if !empty($product.default_image)}
          <picture>
            {if isset($qZdjecie.small.sources.avif)}
              <source 
                srcset="
                  {$qZdjecie.small.sources.avif},
                  {$qZdjecie.medium.sources.avif} 2x"
                type="image/avif"
              >
            {/if}

            {if isset($qZdjecie.small.sources.webp)}
              <source 
                srcset="
                  {$qZdjecie.small.sources.webp},
                  {$qZdjecie.medium.sources.webp} 2x"
                type="image/webp"
              >
            {/if}

            <img
              class="product-pack__image img-fluid"
              srcset="
                {$qZdjecie.small.url},
                {$qZdjecie.medium.url} 2x"
              src="{$qZdjecie.small.url}"
              loading="lazy"
              width="{$qZdjecie.small.width}"
              height="{$qZdjecie.small.height}"
              alt="{$product.default_image.legend}"
              title="{$product.default_image.legend}"
            >
          </picture>
        {else}
          <picture>
            {if isset($qZdjecie.small.sources.avif)}
              <source 
                srcset="
                  {$qZdjecie.small.sources.avif},
                  {$qZdjecie.medium.sources.avif} 2x"
                type="image/avif"
              >
            {/if}

            {if isset($qZdjecie.small.sources.webp)}
              <source 
                srcset="
                  {$qZdjecie.small.sources.webp},
                  {$qZdjecie.medium.sources.webp} 2x"
                type="image/webp"
              >
            {/if}

            <img
              class="product-pack__image img-fluid"
              srcset="
                {$qZdjecie.small.url},
                {$qZdjecie.medium.url} 2x"
              src="{$qZdjecie.small.url}"
              width="{$qZdjecie.small.width}"
              height="{$qZdjecie.small.height}"
              loading="lazy"
            >
          </picture>
        {/if}
      </span>

      <span class="product-pack__name">
        {$product.name}
      </span>

      {if $showPackProductsPrice}
        <span class="product-pack__price">
          {$product.price}
        </span>
      {/if}

      <span class="product-pack__quantity">
        x{$product.pack_quantity}
      </span>

      <span id="pack-product-{$product.id_product}" class="visually-hidden">
        {l s='View product %product_name%, part of the pack.' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Catalog'} {l s='Quantity inside the pack: %quantity%.' sprintf=['%quantity%' => $product.pack_quantity] d='Shop.Theme.Catalog'} {if $showPackProductsPrice}{l s='Price: %price%.' sprintf=['%price%' => $product.price] d='Shop.Theme.Catalog'}{/if}
      </span>
    </a>
  </article>
{/block}
