{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Okno w naszej szufladzie, nie w mechanizmie Vue modułu — ten sam standard
   co `create.tpl`. Link jest już znany (dane listy po stronie klienta), więc
   nie ma tu żadnego zapytania do serwera — tylko pole do odczytu i kopiowanie.
   Prowadzi je w całości `assets/js/islands/wishlist-lists.js`. *}
<div class="wishlist-share" data-url="{$url}">
  <dialog class="q-modal q-modal--drawer" data-q-wishlist-share aria-labelledby="q-wishlist-share-title">
    <div class="q-modal__head">
      <h2 class="q-modal__title" id="q-wishlist-share-title">
        {l s='Share wishlist' d='Modules.Blockwishlist.Shop'}
      </h2>

      <button class="q-modal__close" type="button" data-q-wishlist-share-close
              aria-label="{l s='Close' d='Shop.Theme.Actions'}">
        <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
      </button>
    </div>

    <div class="q-modal__body">
      <div class="q-float">
        <label class="form-label" for="q-wishlist-share-input">
          {l s='Share link' d='Modules.Blockwishlist.Shop'}
        </label>
        <input type="text" class="q-field form-control" id="q-wishlist-share-input"
               placeholder=" " readonly data-q-wishlist-share-input>
      </div>
    </div>

    <div class="q-modal__foot">
      <button type="button" class="q-btn q-btn--primary" data-q-wishlist-share-copy>
        {l s='Copy text' d='Modules.Blockwishlist.Shop'}
      </button>
      <button type="button" class="q-btn q-btn--secondary" data-q-wishlist-share-close>
        {l s='Cancel' d='Modules.Blockwishlist.Shop'}
      </button>
    </div>
  </dialog>
</div>
