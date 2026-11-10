{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Okno w naszej szufladzie (`.q-modal.q-modal--drawer`), nie w mechanizmie
   Vue modułu — ten sam standard co reszta sklepu: w całym projekcie nie ma
   ani jednego `.q-modal` bez `--drawer`, więc wyśrodkowany dialog byłby
   własnym, nowym wzorcem, nie powtórzeniem istniejącego. Pokazywanie,
   zamykanie i wysyłkę prowadzi w całości `assets/js/islands/wishlist-create.js`;
   Vue modułu się na tym elemencie nadal montuje, ale nie ma już żadnych
   własnych znaczników do przejęcia. *}
<div class="wishlist-create" data-url="{$url}">
  <dialog class="q-modal q-modal--drawer" data-q-wishlist-create aria-labelledby="q-wishlist-create-title">
    <div class="q-modal__head">
      <h2 class="q-modal__title" id="q-wishlist-create-title">
        {l s='Create wishlist' d='Modules.Blockwishlist.Shop'}
      </h2>

      <button class="q-modal__close" type="button" data-q-wishlist-create-close
              aria-label="{l s='Close' d='Shop.Theme.Actions'}">
        <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
      </button>
    </div>

    <div class="q-modal__body">
      <div class="q-float">
        <label class="form-label" for="q-wishlist-create-input">
          {l s='Wishlist name' d='Modules.Blockwishlist.Shop'}
        </label>
        <input type="text" class="q-field form-control" id="q-wishlist-create-input"
               placeholder=" " data-q-wishlist-create-input>
      </div>
    </div>

    {* Potwierdzenie pierwsze w znacznikach — w szufladzie stoi na górze
       stosu przycisków, tam gdzie kciuk sięga najłatwiej. *}
    <div class="q-modal__foot">
      <button type="button" class="q-btn q-btn--primary" data-q-wishlist-create-submit>
        {l s='Create wishlist' d='Modules.Blockwishlist.Shop'}
      </button>
      <button type="button" class="q-btn q-btn--secondary" data-q-wishlist-create-close>
        {l s='Cancel' d='Modules.Blockwishlist.Shop'}
      </button>
    </div>
  </dialog>
</div>
