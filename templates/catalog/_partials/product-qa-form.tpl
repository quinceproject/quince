{**
 * Quince: szuflada „zadaj pytanie".
 *
 * Ten sam kształt, co szuflada oferty i kontaktu ze specjalistą.
 *
 * Zalogowany nie podaje imienia ani adresu: sklep je zna.
 *
 * Zmienne: $qIntro: zdanie wstępu ustawione w panelu, może być puste.
 *}

<dialog class="q-modal q-modal--drawer" data-q-qa-form aria-labelledby="q-qa-form-title">
  <div class="q-modal__head">
    <h2 class="q-modal__title" id="q-qa-form-title">
      {l s='Ask a question' d='Shop.Theme.Actions'}
    </h2>

    <button class="q-modal__close" type="button" data-q-qa-close
            aria-label="{l s='Close' d='Shop.Theme.Actions'}">
      <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
    </button>
  </div>

  <div class="q-modal__body">
    <div data-q-qa-fields>
      {if $qIntro}
        <p class="q-qa__intro">{$qIntro}</p>
      {/if}

      {if !$customer.is_logged}
        <div class="q-float q-qa__field">
          <label class="form-label required" for="q-qa-name">
            {l s='Your name' d='Shop.Theme.Catalog'}
          </label>
          <input class="q-field form-control" type="text" id="q-qa-name"
                 name="name" placeholder=" " autocomplete="name" data-q-qa-name>
        </div>

        <div class="q-float q-qa__field">
          <label class="form-label required" for="q-qa-email">
            {l s='Your email address' d='Shop.Theme.Catalog'}
          </label>
          <input class="q-field form-control" type="email" id="q-qa-email"
                 name="email" placeholder=" " autocomplete="email" data-q-qa-email>
        </div>
      {/if}

      <div class="q-float q-qa__field">
        <label class="form-label required" for="q-qa-question">
          {l s='Your question' d='Shop.Theme.Catalog'}
        </label>
        <textarea class="q-field form-control" id="q-qa-question" rows="5"
                  name="question" placeholder=" " data-q-qa-question></textarea>
      </div>

      <p class="q-qa__hint" data-q-qa-hint aria-live="polite" hidden></p>

      {* Cztery zapory silnika: znacznik strony, nazwa formularza, pułapka
         i czas wypełnienia. Piąta, zewnętrzna, dochodzi z modułem oceny. *}
      <div data-q-qa-guard>
        {include file='_partials/form-guard.tpl' form_id='quince_qa'}
      </div>
    </div>

    {* Po wysłaniu formularz znika, zostaje potwierdzenie. Nie obiecujemy, że
       pytanie jest już widoczne: na karcie pokazują się tylko te z odpowiedzią. *}
    <div class="q-qa__done" data-q-qa-done hidden>
      <svg class="q-qa__done-icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
        <path d="m10.97 4.97-.02.022-3.473 4.425-2.093-2.094a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05"/>
      </svg>

      <h3 class="q-qa__done-title">{l s='The question is on its way' d='Shop.Theme.Catalog'}</h3>
      <p class="q-qa__done-text" data-q-qa-done-text></p>
    </div>
  </div>

  <div class="q-modal__foot">
    <button class="q-btn q-btn--primary q-btn--lg q-btn--block" type="button" data-q-qa-send>
      {l s='Send the question' d='Shop.Theme.Actions'}
    </button>

    <button class="q-btn q-btn--primary q-btn--lg q-btn--block" type="button" data-q-qa-done-close hidden>
      {l s='Close' d='Shop.Theme.Actions'}
    </button>
  </div>
</dialog>
