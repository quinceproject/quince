{**
 * Quince — szybki podgląd produktu
 *
 * Przycisk otwierający okno z podglądem, bez opuszczania listingu. Pojawia się
 * na warstwie zdjęcia, więc ma własny wariant przycisku ikonowego.
 *
 * PrestaShop podpina zachowanie po klasie `js-quickview` i atrybucie
 * `data-ps-action` — obu nie wolno zmienić, bo to kontrakt z rdzeniem.
 *
 * Jeden przycisk zamiast dwóch: Hummingbird ma osobne warianty dla myszy
 * i dotyku, ale ten sam element obsługuje oba wejścia, a duplikat oznaczałby
 * dwa razy tę samą akcję w drzewie dostępności.
 *}

{block name='quick_view'}
  <button
    type="button"
    class="q-pcard__tool q-pcard__quickview js-quickview"
    data-ps-action="open-quickview"
    data-ps-ref="quickview-button"
    data-q-quickview-close="{l s='Close' d='Shop.Theme.Global'}"
    aria-label="{l s='Quick view %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}"
    title="{l s='Quick view' d='Shop.Theme.Actions'}">
    <svg width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
      <path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5s3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5s-3.879-1.168-5.168-2.457A13 13 0 0 1 1.172 8z"/>
      <path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/>
    </svg>
  </button>
{/block}
