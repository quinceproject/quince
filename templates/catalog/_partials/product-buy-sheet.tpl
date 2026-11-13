{**
 * Quince: warstwa z panelem zakupu na telefonie.
 *
 * Skrypt PRZENOSI do niej panel zakupu na czas otwarcia i oddaje go kolumnie
 * przy zamknięciu. Przenoszony jest ten sam węzeł, nie kopia: wybrany wariant,
 * wpisana personalizacja i ustawiona ilość muszą być jedne, niezależnie od
 * tego, czy klient patrzy na nie w warstwie, czy w kolumnie. Dwie kopie
 * znaczyłyby dwa niezależne stany.
 *
 * Warstwa stoi WEWNĄTRZ `.product-container`, choć rysuje się nad całą stroną.
 * PrestaShop po zmianie wariantu podmienia bloki panelu tylko w obrębie tego
 * kontenera; warstwa postawiona obok niego zostawia w panelu stary wariant,
 * starą cenę i stary stan przycisku. Położenie w kodzie nie zmienia wyglądu,
 * bo `dialog` otwarty przez `showModal()` idzie na wierzch niezależnie od tego,
 * gdzie stoi.
 *
 * Zachowanie: assets/js/islands/buybox.js
 *}

{if !$configuration.is_catalog && $product.show_price}
  <dialog class="q-modal q-modal--sheet" id="q-sheet-buybox" data-q-sheet
          aria-labelledby="q-sheet-title">

    {* Ta sama krawędź co u paska: półkolista nisza z kołem w barwie marki.
       Pasek i warstwa to dwa stany jednej rzeczy, więc mają ten sam znak.
       Krzyżyka nie ma: koło ze strzałką JEST zamknięciem. Zamyka też Escape
       i kliknięcie w tło. *}
    <span class="q-sheet__nisza">
      <span class="q-sheet__luk">
        <button class="q-sheet__chwyt" type="button" data-q-sheet-close
                aria-label="{l s='Hide the price and product options' d='Shop.Theme.Actions'}">
          <svg viewBox="0 0 16 16" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m4 6 4 4 4-4"/></svg>
        </button>
      </span>
    </span>

    <div class="q-sheet__head">
      {if $product.cover}
        <img class="q-sheet__thumb" src="{$product.cover.small.url}" alt="" width="80" height="80" loading="lazy">
      {/if}

      <h2 class="q-sheet__title" id="q-sheet-title">{$product.name}</h2>
    </div>

    <div class="q-sheet__body" data-q-sheet-body></div>
  </dialog>
{/if}
