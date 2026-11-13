{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Okno w naszej szufladzie, nie w mechanizmie Vue modułu, jak w `create.tpl`. Otwieranie, wypełnienie i wysyłkę prowadzi w całości
   `assets/js/islands/wishlist-lists.js`. *}
<div class="wishlist-rename" data-url="{$url}">
  <dialog class="q-modal q-modal--drawer" data-q-wishlist-rename aria-labelledby="q-wishlist-rename-title">
    <div class="q-modal__head">
      <h2 class="q-modal__title" id="q-wishlist-rename-title">
        {l s='Rename wishlist' d='Modules.Blockwishlist.Shop'}
      </h2>

      <button class="q-modal__close" type="button" data-q-wishlist-rename-close
              aria-label="{l s='Close' d='Shop.Theme.Actions'}">
        <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
      </button>
    </div>

    <div class="q-modal__body">
      <div class="q-float">
        <label class="form-label" for="q-wishlist-rename-input">
          {l s='Wishlist name' d='Modules.Blockwishlist.Shop'}
        </label>
        <input type="text" class="q-field form-control" id="q-wishlist-rename-input"
               placeholder=" " data-q-wishlist-rename-input>
      </div>
    </div>

    <div class="q-modal__foot">
      <button type="button" class="q-btn q-btn--primary" data-q-wishlist-rename-submit>
        {l s='Rename wishlist' d='Modules.Blockwishlist.Shop'}
      </button>
      <button type="button" class="q-btn q-btn--secondary" data-q-wishlist-rename-close>
        {l s='Cancel' d='Modules.Blockwishlist.Shop'}
      </button>
    </div>
  </dialog>
</div>
