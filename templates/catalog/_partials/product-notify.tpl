{**
 * Quince: zapis na powiadomienie o dostępności.
 *
 * Szuflada, nie formularz w kolumnie: w wierszu zakupu stoi przycisk, treść
 * wchodzi po kliknięciu.
 *
 * Hook zostaje w szufladzie, a nie jest z niej wyjęty: wypisują się w nim także
 * inne moduły sklepu i one mają się gdzie pokazać.
 *
 * Osobny plik, bo szuflada należy do wiersza zakupu, ale otwiera ją też karta
 * z innego miejsca: jeden zapis znaczników na obie drogi.
 *
 * Zachowanie: assets/js/islands/notify.js
 *}

<dialog class="q-modal q-modal--drawer" data-q-notify
        aria-label="{l s='Notify me when available' d='Modules.Emailalerts.Shop'}">
  <div class="q-modal__head">
    {* Ikona wewnątrz tytułu i w barwie marki, tak jak w makiecie szuflad:
       nagłówek mówi jednym znakiem, o co chodzi, zanim ktoś przeczyta zdanie. *}
    <h2 class="q-modal__title">
      <svg class="q-modal__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
        <path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2M8 1.918l-.797.161A4 4 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4 4 0 0 0-3.203-3.92zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5 5 0 0 1 13 6c0 .88.32 4.2 1.22 6"/>
      </svg>
      {l s='Notify me when available' d='Modules.Emailalerts.Shop'}
    </h2>

    <button class="q-modal__close" type="button" data-q-notify-close
            aria-label="{l s='Close' d='Shop.Theme.Actions'}">
      <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
    </button>
  </div>

  <div class="q-modal__body" tabindex="-1" autofocus>
    {include file='catalog/_partials/product-additional-info.tpl'}
  </div>
</dialog>
