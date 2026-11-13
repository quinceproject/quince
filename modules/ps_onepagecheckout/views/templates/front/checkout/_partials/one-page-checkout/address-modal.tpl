{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * Okno dodania/edycji adresu na `<dialog class="q-modal">`, zamiast na
 * znacznikach Bootstrapa. Otwiera je i zamyka `bootstrap-modal-shim.js`.
 * Wszystkie zaczepy JS modułu (`id`, `data-title-*`, `.js-opc-address-modal-fields`,
 * `#submit-address-modal`, spinner) zostają bez zmian, zmienia się tylko
 * opakowanie wizualne.
 *}
<dialog
  id="{$modal_id}"
  class="q-modal q-modal--lg"
  aria-labelledby="{$modal_id}-title"
  data-title-new="{$title_new}"
  data-title-edit="{$title_edit}"
>
  <div class="q-modal__head">
    <h2 class="q-modal__title" id="{$modal_id}-title">{$title_new}</h2>
    <button type="button" class="q-modal__close" data-bs-dismiss="modal" aria-label="{l s='Close' d='Shop.Theme.Global'}">
      <svg width="20" height="20" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>
    </button>
  </div>

  <div class="q-modal__body">
    <input type="hidden" name="id_address" value="">
    <input type="hidden" name="token" value="{$token}">
    <input type="hidden" name="address_type" value="{$address_type}">

    {* Pola zależne od kraju, podmieniane w miejscu przez opc-address-modal.js. *}
    <div class="js-opc-address-modal-fields">
      {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/address-modal-fields.tpl'
        formFields=$formFields
        fieldRows=$fieldRows
        prefix=$prefix
        modal_id=$modal_id}
    </div>
  </div>

  <div class="q-modal__foot">
    <button
      id="submit-address-modal"
      type="button"
      class="q-btn q-btn--primary"
    >
      <span class="spinner-border spinner-border-sm me-2 d-none" aria-hidden="true" data-opc-address-save-spinner></span>
      {l s='Save' d='Modules.Onepagecheckout.Shop'}
    </button>
  </div>
</dialog>
