{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

<dialog
  id="opc-delete-address-confirm-modal"
  class="q-modal"
  aria-labelledby="opc-delete-address-confirm-title"
>
  <div class="q-modal__head">
    <h2 class="q-modal__title" id="opc-delete-address-confirm-title">
      {l s='Delete this address?' d='Modules.Onepagecheckout.Shop'}
    </h2>
    <button
      type="button"
      class="q-modal__close"
      data-bs-dismiss="modal"
      aria-label="{l s='Close' d='Modules.Onepagecheckout.Shop'}"
    >
      <svg width="20" height="20" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>
    </button>
  </div>

  <div class="q-modal__body">
    <p>{l s='This action will remove the selected address from your checkout.' d='Modules.Onepagecheckout.Shop'}</p>
  </div>

  <div class="q-modal__foot">
    <button
      type="button"
      class="q-btn q-btn--secondary js-opc-delete-address-cancel"
      data-bs-dismiss="modal"
    >
      {l s='Cancel' d='Modules.Onepagecheckout.Shop'}
    </button>
    <button
      type="button"
      class="q-btn q-btn--destructive js-opc-delete-address-confirm"
    >
      {l s='Delete' d='Modules.Onepagecheckout.Shop'}
    </button>
  </div>
</dialog>
