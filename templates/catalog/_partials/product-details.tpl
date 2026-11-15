{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{**
 * Szczegóły produktu: JEDNA pozycja akordeonu, dwa źródła w środku.
 *
 * Pola produktu (marka, referencja, dostępność, kody) i tabela cech z katalogu
 * to dwa różne źródła w PrestaShopie, pokazane razem w jednej tabeli
 * (nazwa i wartość w dwóch kolumnach).
 *
 * Zmienne: $qPola, $qLogo, $qCechy: włączniki spod elementu `section_spec`
 * w mapie. `$qLogo` rozstrzyga to samo, co przełącznik przy marce w kolumnie
 * opisu: znak firmowy albo sama nazwa.
 *}

{* Opakowanie zostaje, bo czyta je skrypt produktu PrestaShopa. *}
<div class="js-product-details q-pdp__details" data-product="{$product.embedded_attributes|json_encode}">
  <details class="q-accordion__item" id="q-section-details"{if !$product.description} open{/if}>
    <summary class="q-accordion__header">
      <h2 class="q-accordion__title">{l s='Product Details' d='Shop.Theme.Catalog'}</h2>
      <svg class="q-accordion__icon" width="16" height="16" viewBox="0 0 16 16"
           fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
    </summary>

    <div class="q-accordion__body">
      {* Pojemnik z własnym przewijaniem: na telefonie tabela ma się przewinąć
         w swoim polu, a nie rozepchnąć strony. *}
      <div class="q-table-wrap">
        <table class="q-spectable">
          <tbody>
            {if $qPola|default:true}
              {block name='product_manufacturer'}
                {if isset($product_manufacturer->id) && $product_manufacturer->active}
                  <tr class="details__item--manufacturer">
                    <th scope="row">{l s='Brand' d='Shop.Theme.Catalog'}</th>
                    <td>
                      {if $qLogo|default:true && isset($product_manufacturer.image.bySize.small_default.url)}
                        <a href="{$product_manufacturer->url}">
                          <img src="{$product_manufacturer.image.bySize.small_default.url}"
                            class="img-fluid details__manufacturer-logo"
                            alt="{$product_manufacturer->name}"
                            loading="lazy"
                            width="{$product_manufacturer.image.bySize.small_default.width}"
                            height="{$product_manufacturer.image.bySize.small_default.height}"
                            aria-label="{l s='Brand: %brand_name%' sprintf=['%brand_name%' => $product_manufacturer->name] d='Shop.Theme.Catalog'}"
                          >
                        </a>
                      {else}
                        <a href="{$product_manufacturer->url}">{$product_manufacturer->name}</a>
                      {/if}
                    </td>
                  </tr>
                {/if}
              {/block}

              {block name='product_reference'}
                {if !empty($product.reference_to_display)}
                  <tr class="details__item--reference">
                    <th scope="row">{l s='Reference' d='Shop.Theme.Catalog'}</th>
                    <td>{$product.reference_to_display}</td>
                  </tr>
                {/if}
              {/block}

              {block name='product_quantities'}
                {if $product.show_quantities}
                  <tr class="details__item--quantities">
                    <th scope="row">{l s='In stock' d='Shop.Theme.Catalog'}</th>
                    <td data-stock="{$product.quantity}" data-allow-oosp="{$product.allow_oosp}">
                      {$product.quantity} {$product.quantity_label}
                    </td>
                  </tr>
                {/if}
              {/block}

              {block name='product_availability_date'}
                {if $product.availability_date}
                  <tr class="details__item--availability-date">
                    <th scope="row">{l s='Availability date' d='Shop.Theme.Catalog'}</th>
                    <td>{$product.availability_date}</td>
                  </tr>
                {/if}
              {/block}

              {block name='product_condition'}
                {if $product.condition}
                  <tr class="details__item--condition">
                    <th scope="row">{l s='Condition' d='Shop.Theme.Catalog'}</th>
                    <td>{$product.condition.label}</td>
                  </tr>
                {/if}
              {/block}

              {block name='product_specific_references'}
                {if !empty($product.specific_references)}
                  {foreach from=$product.specific_references item=reference key=key}
                    <tr class="details__item--{$key|classname}">
                      <th scope="row">{$key}</th>
                      <td>{$reference}</td>
                    </tr>
                  {/foreach}
                {/if}
              {/block}
            {/if}

            {block name='product_features'}
              {if $qCechy|default:true && $product.grouped_features}
                {* Cechy z katalogu jadą w tej samej tabeli, bez nagłówka nad nimi:
                   to dalszy ciąg tej samej odpowiedzi, a drugi nagłówek w środku
                   zakładki czytałby się jak nowa sekcja. *}
                {foreach from=$product.grouped_features item=feature}
                  <tr class="details__item--feature">
                    <th scope="row">{$feature.name}</th>
                    <td>{$feature.value|htmlspecialchars|nl2br nofilter}</td>
                  </tr>
                {/foreach}
              {/if}
            {/block}
          </tbody>
        </table>
      </div>
    </div>
  </details>
</div>
