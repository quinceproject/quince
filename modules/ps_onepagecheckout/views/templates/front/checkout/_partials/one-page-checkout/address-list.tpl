{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * One Page Checkout - Address List
 *
 * Akcje przy adresie jako zwykłe, widoczne odnośniki (makieta kasy,
 * „Edytuj" przy prawej krawędzi), nie menu „..." Bootstrapa — Quince nie
 * ładuje jego JS, a dwie czynności nie potrzebują chowania pod menu.
 *}

<div class="d-flex flex-column mb-3">
  {assign var="_selected_address" value=$selected_address|intval}
  {assign var="_address_count" value=$customer.addresses|count}
  {foreach from=$customer.addresses item="address"}
    {assign var="_address_id" value=$address.id|default:$address.id_address|intval}
    {assign var="is_address_selected" value=$_address_id === $_selected_address || ($_selected_address === 0 && $_address_count === 1 && $address@first)}
    <div
      class="opc-address-item{if $is_address_selected} selected{/if}"
      role="button"
      data-id-address="{$_address_id}"
    >
      <div class="form-check mb-2">
        <input
          type="radio"
          class="form-check-input js-opc-address-radio"
          name="id_address_{if $prefix}invoice{else}delivery{/if}"
          id="opc-address-{if $prefix}invoice{else}delivery{/if}-{$_address_id}"
          value="{$_address_id}"
          {if $is_address_selected}checked{/if}
          aria-label="{l s='Select address: %alias%' sprintf=['%alias%' => $address.alias] d='Modules.Onepagecheckout.Shop'}"
          aria-describedby="opc-address-details-{$_address_id}"
        >
      </div>

      <div class="flex-grow-1">
        <label class="form-check-label {if $is_address_selected}fw-semibold{/if}" for="opc-address-{if $prefix}invoice{else}delivery{/if}-{$_address_id}">
          {$address.alias}
        </label>
        <p class="mb-2 text-muted small" id="opc-address-details-{$_address_id}">
          <span class="visually-hidden">{l s='Address details:' d='Modules.Onepagecheckout.Shop'}</span>
          {$address.firstname} {$address.lastname}<br>
          {$address.address1}{if $address.address2} {$address.address2}{/if}<br>
          {$address.postcode} {$address.city}
        </p>
      </div>

      <div class="opc-address-card__actions flex-shrink-0">
        <button
          type="button"
          class="q-linkbtn"
          data-bs-toggle="modal"
          data-bs-target="{if $prefix}#modal-invoice{else}#modal-delivery{/if}"
          data-type="edit"
          data-id_address="{$_address_id}"
          data-alias="{$address.alias|escape:'html':'UTF-8'}"
          data-firstname="{$address.firstname|escape:'html':'UTF-8'}"
          data-lastname="{$address.lastname|escape:'html':'UTF-8'}"
          data-company="{$address.company|escape:'html':'UTF-8'}"
          data-vat_number="{$address.vat_number|escape:'html':'UTF-8'}"
          data-address1="{$address.address1|escape:'html':'UTF-8'}"
          data-address2="{$address.address2|escape:'html':'UTF-8'}"
          data-city="{$address.city|escape:'html':'UTF-8'}"
          data-postcode="{$address.postcode|escape:'html':'UTF-8'}"
          data-id_state="{$address.id_state}"
          data-id_country="{$address.id_country}"
          data-phone="{$address.phone|escape:'html':'UTF-8'}"
          data-address="{$address|@json_encode|escape:'htmlall':'UTF-8'}"
        >
          {l s='Edit' d='Modules.Onepagecheckout.Shop'}
        </button>

        <button
          type="button"
          class="q-linkbtn q-linkbtn--danger js-delete-address"
          data-id-address="{$_address_id}"
          data-address-type="{if $prefix == 'invoice_'}invoice{else}delivery{/if}"
          data-confirm-message="{l s='Are you sure you want to delete this address?' d='Modules.Onepagecheckout.Shop'}"
        >
          {l s='Delete' d='Modules.Onepagecheckout.Shop'}
        </button>
      </div>
    </div>
  {/foreach}

  {if $customer.addresses|count > 0}
    <div
      class="opc-address-item opc-address-item--new"
      role="button"
      data-bs-toggle="modal"
      data-type="create"
      data-bs-target="{if $prefix == 'invoice_'}#modal-invoice{else}#modal-delivery{/if}"
    >
      <div class="form-check mb-2">
        <input
          type="radio"
          class="form-check-input js-opc-address-radio"
          name="id_address_{if $prefix == 'invoice_'}invoice{else}delivery{/if}"
          id="opc-new-{if $prefix == 'invoice_'}invoice{else}delivery{/if}-address"
          value="new_address"
        >
      </div>
      <div class="flex-grow-1">
        <label class="form-check-label" for="opc-new-{if $prefix == 'invoice_'}invoice{else}delivery{/if}-address">
          {l s='Use a different delivery address' d='Modules.Onepagecheckout.Shop'}
        </label>
      </div>
    </div>
  {/if}
</div>
