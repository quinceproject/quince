{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Okno w naszej szufladzie, nie w mechanizmie Vue modułu — ten sam standard
   co `create.tpl`. Dziś tylko usunięcie całej listy (strona `lists.tpl`) —
   usunięcie pojedynczego produktu z listy to inny widok (`products-list.tpl`),
   jeszcze nieostylowany, więc ten modal go na razie nie obsługuje. Prowadzi
   go w całości `assets/js/islands/wishlist-lists.js`. *}
<div class="wishlist-delete" data-url="{$url}">
  <dialog class="q-modal q-modal--drawer" data-q-wishlist-delete aria-labelledby="q-wishlist-delete-title">
    <div class="q-modal__head">
      <h2 class="q-modal__title" id="q-wishlist-delete-title">
        {l s='Delete wishlist' d='Modules.Blockwishlist.Shop'}
      </h2>

      <button class="q-modal__close" type="button" data-q-wishlist-delete-close
              aria-label="{l s='Close' d='Shop.Theme.Actions'}">
        <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
      </button>
    </div>

    {* Bez zdania potwierdzenia — nie ma go nigdzie w tłumaczeniach modułu
       (sprawdzone), a wymyślać własnego nie wolno. Tytuł okna i czerwony
       przycisk już mówią, o co chodzi; nazwa listy daje kontekst, który. *}
    <div class="q-modal__body">
      <p><strong data-q-wishlist-delete-name></strong></p>
    </div>

    <div class="q-modal__foot">
      <button type="button" class="q-btn q-btn--destructive" data-q-wishlist-delete-submit>
        {l s='Delete' d='Modules.Blockwishlist.Shop'}
      </button>
      <button type="button" class="q-btn q-btn--secondary" data-q-wishlist-delete-close>
        {l s='Cancel' d='Modules.Blockwishlist.Shop'}
      </button>
    </div>
  </dialog>
</div>
