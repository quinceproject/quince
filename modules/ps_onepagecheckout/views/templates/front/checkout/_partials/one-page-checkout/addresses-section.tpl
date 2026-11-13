{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * Adres dostawy + opcjonalny adres rozliczeniowy: wbudowany mechanizm
 * modułu (`#opc-use-same-address`, `#opc-billing-section`), tylko
 * ostylowany. W module panel rozliczeniowy jest OSOBNĄ, ponumerowaną
 * sekcją (`one-page-checkout__section`) obok sekcji dostawy; tu stoi jako
 * szary panel WEWNĄTRZ tej samej karty, bez numeracji. Identyfikatory
 * zostają, bo JS modułu (`opc-address.bundle.js`) szuka ich po `id`,
 * nie po miejscu w drzewie ani klasie.
 *}

{include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/address-modal.tpl'
modal_id='modal-delivery'
formFields=$deliveryFields
fieldRows=$deliveryFieldRows
title_new={l s='New delivery address' d='Modules.Onepagecheckout.Shop'}
title_edit={l s='Edit delivery address' d='Modules.Onepagecheckout.Shop'}
address_type='delivery'
prefix=''
}

{include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/address-modal.tpl'
modal_id='modal-invoice'
formFields=$invoiceFields
fieldRows=$invoiceFieldRows
title_new={l s='New billing address' d='Modules.Onepagecheckout.Shop'}
title_edit={l s='Edit billing address' d='Modules.Onepagecheckout.Shop'}
address_type='invoice'
prefix='invoice_'
}

{include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/delete-address-modal.tpl'}

{assign var="_addresses_count" value=$customer.addresses|count}
{assign var="_delivery_selected_address" value=$deliveryFields.id_address_delivery.value|default:($cart.id_address_delivery|default:0)}
{assign var="_billing_selected_address" value=$invoiceMetaFields.id_address_invoice.value|default:($cart.id_address_invoice|default:0)}
{assign var=qFirma value=(!empty($deliveryFields.company.value) || !empty($deliveryFields.vat_number.value))}

<template id="opc-delivery-address-loader">
  {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/opc-loader.tpl'
    message={l s='Loading addresses...' d='Modules.Onepagecheckout.Shop'}
  }
</template>

<template id="opc-delivery-address-error">
  {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/opc-error.tpl'
    message={l s='An error occurred while loading addresses. Please try again.' d='Modules.Onepagecheckout.Shop'}
    retry_label={l s='Retry' d='Modules.Onepagecheckout.Shop'}
    retry_action='retry-addresses'
  }
</template>

<template id="opc-billing-address-loader">
  {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/opc-loader.tpl'
    message={l s='Loading addresses...' d='Modules.Onepagecheckout.Shop'}
  }
</template>

<template id="opc-billing-address-error">
  {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/opc-error.tpl'
    message={l s='An error occurred while loading addresses. Please try again.' d='Modules.Onepagecheckout.Shop'}
    retry_label={l s='Retry' d='Modules.Onepagecheckout.Shop'}
    retry_action='retry-addresses'
  }
</template>

<section class="one-page-checkout__section">
  <h2
    class="one-page-checkout__title"
    data-q-role-heading
    data-text-priv="{if $is_virtual_cart}{l s='Billing address' d='Modules.Onepagecheckout.Shop'}{else}{l s='Delivery address' d='Modules.Onepagecheckout.Shop'}{/if}"
    data-text-firm="{l s='Company details (for invoice)' d='Shop.Theme.Checkout'}"
  >
    {if $qFirma}
      {l s='Company details (for invoice)' d='Shop.Theme.Checkout'}
    {elseif $is_virtual_cart}
      {l s='Billing address' d='Modules.Onepagecheckout.Shop'}
    {else}
      {l s='Delivery address' d='Modules.Onepagecheckout.Shop'}
    {/if}
  </h2>

  <section id="opc-delivery-address" class="form-fields">
    <div id="opc-delivery-address-content">
        <div id="opc-delivery-address-content-list" class="{if $_addresses_count <= 0}d-none{/if}">
          {if $_addresses_count > 0}
          {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/address-list.tpl'
            prefix=''
            selected_address=$_delivery_selected_address
          }
          {/if}
        </div>

      <div id="opc-delivery-address-fields" class="{if $_addresses_count > 0}d-none{/if}">
        {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/address-fields.tpl'
          formFields=$deliveryFields
          fieldRows=$deliveryFieldRows
          prefix=''
        }
      </div>
    </div>

    {if !$is_virtual_cart}
      <label class="q-choice" for="opc-use-same-address">
        <input class="q-choice__input" type="checkbox" id="opc-use-same-address" name="use_same_address" value="1" {if $useSameAddressField.value}checked{/if}>
        <span
          class="q-choice__label"
          data-q-other-label
          data-text-priv="{l s='Use this address for invoice too' d='Modules.Onepagecheckout.Shop'}"
          data-text-firm="{l s='Use this address for delivery too' d='Shop.Theme.Checkout'}"
        >{if $qFirma}{l s='Use this address for delivery too' d='Shop.Theme.Checkout'}{else}{l s='Use this address for invoice too' d='Modules.Onepagecheckout.Shop'}{/if}</span>
      </label>
    {/if}

    {if !$is_virtual_cart}
      <section class="q-checkout2__sub-box" id="opc-billing-section" style="display: none;">
        <h3
          class="q-checkout2__h3"
          data-q-other-heading
          data-text-priv="{l s='Billing address' d='Modules.Onepagecheckout.Shop'}"
          data-text-firm="{l s='Shipping Address' d='Shop.Theme.Checkout'}"
        >{if $qFirma}{l s='Shipping Address' d='Shop.Theme.Checkout'}{else}{l s='Billing address' d='Modules.Onepagecheckout.Shop'}{/if}</h3>

        <div id="opc-billing-address-content">
            <div id="opc-billing-address-content-list" class="{if $_addresses_count <= 1}d-none{/if}">
              {if $_addresses_count > 1}
              {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/address-list.tpl'
                prefix='invoice_'
                selected_address=$_billing_selected_address
              }
              {/if}
            </div>

          <div id="opc-billing-address-fields" class="{if $_addresses_count > 1}d-none{/if}">
            {if isset($invoiceMetaFields.id_address_invoice)}
              <input type="hidden" name="{$invoiceMetaFields.id_address_invoice.name}" value="{$invoiceMetaFields.id_address_invoice.value}">
            {/if}

            {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/address-fields.tpl'
              formFields=$invoiceFields
              fieldRows=$invoiceFieldRows
              prefix='invoice_'
            }
          </div>
        </div>
      </section>
    {/if}
  </section>
</section>

{capture name="address_selector_bottom"}{hook h='displayAddressSelectorBottom'}{/capture}
{if $smarty.capture.address_selector_bottom}
  {block name='address_selector_bottom'}
    <div class="address-selector-bottom mt-3">
      {$smarty.capture.address_selector_bottom nofilter}
    </div>
  {/block}
{/if}
