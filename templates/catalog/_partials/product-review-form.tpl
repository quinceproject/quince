{**
 * Quince — szuflada „napisz opinię".
 *
 * Moduł `productcomments` ma własne okno, ale otwiera je Bootstrapem, którego
 * motyw nie wgrywa. Formularz jest więc nasz, a wysyłka idzie do punktu
 * końcowego modułu: moderacja, kryteria i zapis zostają po jego stronie,
 * my odpowiadamy tylko za wygląd i obsługę.
 *
 * Ocena to zwykłe pola wyboru, nie skrypt: bez JavaScriptu klient nadal
 * zaznaczy gwiazdki, a czytnik ekranu ogłosi je jako grupę wyboru.
 *
 * Zmienne: $qKryteria — kryteria oceny z silnika (id i nazwa).
 *}

<dialog class="q-modal q-modal--drawer" data-q-review-form aria-labelledby="q-review-form-title">
  <div class="q-modal__head">
    <h2 class="q-modal__title" id="q-review-form-title">
      {l s='Write a review' d='Shop.Theme.Actions'}
    </h2>

    <button class="q-modal__close" type="button" data-q-review-close
            aria-label="{l s='Close' d='Shop.Theme.Actions'}">
      <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
    </button>
  </div>

  <div class="q-modal__body">
    <div data-q-review-fields>
      {foreach from=$qKryteria item=qKryterium}
        <fieldset class="q-stars" data-q-review-criterion="{$qKryterium.id|intval}">
          <legend class="form-label required">{$qKryterium.name}</legend>

          {* Gwiazdki od piątki do jedynki: przy takiej kolejności zaznaczenie
             podświetla sąsiadów po prawej samym selektorem, bez skryptu. *}
          <div class="q-stars__set">
            {for $qOcena=5 to 1 step -1}
              <input class="q-stars__input visually-hidden"
                     type="radio"
                     id="q-star-{$qKryterium.id|intval}-{$qOcena}"
                     name="criterion[{$qKryterium.id|intval}]"
                     value="{$qOcena}">
              <label class="q-stars__label"
                     for="q-star-{$qKryterium.id|intval}-{$qOcena}"
                     title="{l s='%grade% out of 5' sprintf=['%grade%' => $qOcena] d='Shop.Theme.Catalog'}">
                <span aria-hidden="true">&#9733;</span>
                <span class="visually-hidden">{l s='%grade% out of 5' sprintf=['%grade%' => $qOcena] d='Shop.Theme.Catalog'}</span>
              </label>
            {/for}
          </div>
        </fieldset>
      {/foreach}

      {* Nazwa podpisu tylko dla gościa: zalogowanemu podpisuje opinię moduł
         danymi z konta, więc pole pytałoby o coś, co sklep już wie. *}
      {if !$customer.is_logged}
        <div class="q-float q-review-form__field">
          <label class="form-label required" for="q-review-name">
            {l s='Your name' d='Shop.Theme.Catalog'}
          </label>
          <input class="q-field form-control" type="text" id="q-review-name"
                 name="customer_name" placeholder=" " autocomplete="name" data-q-review-name>
        </div>
      {/if}

      <div class="q-float q-review-form__field">
        <label class="form-label required" for="q-review-title">
          {l s='Review title' d='Shop.Theme.Catalog'}
        </label>
        <input class="q-field form-control" type="text" id="q-review-title"
               name="comment_title" placeholder=" " data-q-review-title>
      </div>

      <div class="q-float q-review-form__field">
        <label class="form-label required" for="q-review-content">
          {l s='Your review' d='Shop.Theme.Catalog'}
        </label>
        <textarea class="q-field form-control" id="q-review-content" rows="5"
                  name="comment_content" placeholder=" " data-q-review-content></textarea>
      </div>

      <p class="q-review-form__hint" data-q-review-hint aria-live="polite" hidden></p>

      {* Cztery zapory silnika, te same co przy pozostałych formularzach. *}
      <div data-q-review-guard>
        {include file='_partials/form-guard.tpl' form_id='quince_review'}
      </div>
    </div>

    {* Po wysłaniu formularz znika, zostaje potwierdzenie. Opinia zwykle czeka
       na moderację, więc mówimy o tym wprost, zamiast obiecywać, że jest już
       widoczna. *}
    <div class="q-review-form__done" data-q-review-done hidden>
      <svg class="q-review-form__done-icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
        <path d="m10.97 4.97-.02.022-3.473 4.425-2.093-2.094a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05"/>
      </svg>

      <h3 class="q-review-form__done-title">{l s='Thank you for your review' d='Shop.Theme.Catalog'}</h3>
      <p class="q-review-form__done-text" data-q-review-done-text></p>
    </div>
  </div>

  <div class="q-modal__foot">
    <button class="q-btn q-btn--primary q-btn--lg q-btn--block" type="button" data-q-review-send>
      {l s='Send review' d='Shop.Theme.Actions'}
    </button>

    <button class="q-btn q-btn--primary q-btn--lg q-btn--block" type="button" data-q-review-done-close hidden>
      {l s='Close' d='Shop.Theme.Actions'}
    </button>
  </div>
</dialog>
