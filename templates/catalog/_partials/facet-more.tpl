{**
 * Quince: przycisk „Pokaż więcej” pod długą grupą filtra.
 *
 * Wołany z obu szablonów zawężeń (rdzeń i ps_facetedsearch), gdy grupa ma
 * schowane wartości. Rozwijanie robi wyspa listingu (listing.js) przez
 * `data-q-filter-more`; bez skryptu klient zawęża dalej przez odnośniki
 * widocznych wartości, a zaznaczone wartości nigdy się nie chowają.
 *
 *   qPoza  liczba schowanych wartości
 *
 * Klasy: components/listing.css
 *}
<button class="q-filter__more" type="button" data-q-filter-more aria-expanded="false">
  <span>
    <span data-q-filter-more-show>{l s='Show more' d='Shop.Theme.Actions'} ({$qPoza})</span>
    <span data-q-filter-more-hide hidden>{l s='Show less' d='Shop.Theme.Actions'}</span>
    <svg class="q-filter__more-chev" viewBox="0 0 16 16" fill="currentColor"
         aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
  </span>
</button>
