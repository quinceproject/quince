{**
 * Quince — licznik ilości i przycisk zakupu.
 *
 * Licznik i przycisk stoją w jednym wierszu i mają tę samą wysokość. Wiersz umie
 * się zawinąć: element flexa domyślnie nie schodzi poniżej szerokości własnej
 * treści, a napis na przycisku nie łamie wierszy, więc na wąskim ekranie
 * przycisk schodzi POD licznik zamiast się zgniatać z uciętym napisem.
 *
 * Produktu, którego nie da się zamówić, ten blok nie obsługuje: licznik ilości
 * pytałby o coś, czego i tak nie można kupić. Prośba o wiadomość wchodzi wtedy
 * w wiersz ulubionych, w miejsce „Kup teraz" — `product-buy-now.tpl`.
 *
 * Wymagania rdzenia, których nie wolno ruszyć:
 *   `js-product-add-to-cart`  — po niej rdzeń podmienia blok po zmianie wariantu,
 *   `id="quantity_wanted"`    — po nim czyta ilość przy dodawaniu do koszyka,
 *   `data-button-action`      — po nim rozpoznaje przycisk zakupu.
 *
 * Dostępność wypisuje osobny element panelu (`product-availability.tpl`), więc
 * tutaj jej nie ma. Rdzeń trzymał obie rzeczy razem, przez co stan magazynu nie
 * dawał się przestawić ani wyłączyć bez przycisku zakupu.
 *
 * Zachowanie licznika: assets/js/islands/buybox.js
 *}

{if !$configuration.is_catalog}
  <div class="q-buy__actions product-add-to-cart js-product-add-to-cart">

    {* Produktu nie da się zamówić: licznik i koszyk nie mają czego obsłużyć,
       więc wiersz zakupu nie powstaje. Prośba o wiadomość wchodzi w wiersz
       ulubionych, w miejsce „Kup teraz" — patrz `product-buy-now.tpl`. *}
    {if $product.add_to_cart_url}
    <div class="q-buy__cta">
      <div class="q-qty">
        <button class="q-qty__btn" type="button" data-q-qty="-"
                aria-label="{l s='Decrease quantity of %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}">
          <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M2 8a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11A.5.5 0 0 1 2 8"/></svg>
        </button>

        <input class="q-qty__input js-quantity-wanted"
               id="quantity_wanted"
               name="qty"
               type="number"
               inputmode="numeric"
               value="{$product.quantity_wanted}"
               min="{$product.quantity_required}"
               aria-label="{l s='Change quantity of %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}">

        <button class="q-qty__btn" type="button" data-q-qty="+"
                aria-label="{l s='Increase quantity of %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}">
          <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2"/></svg>
        </button>
      </div>

      {* Klasa `add` jest wymogiem rdzenia: po zmianie wariantu podmienia on
         wewnątrz bloku dokładnie ten element, żeby przycisk wziął nowy stan
         dostępności. *}
      <button class="q-btn q-btn--primary q-btn--lg add"
              type="submit"
              data-button-action="add-to-cart"
              title="{l s='Add to cart %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}">
        <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 1a2.5 2.5 0 0 1 2.5 2.5V4h-5v-.5A2.5 2.5 0 0 1 8 1m3.5 3v-.5a3.5 3.5 0 1 0-7 0V4H1v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V4zM2 5h12v9a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1z"/></svg>
        <span class="q-btn__label">{l s='Add to cart' d='Shop.Theme.Actions'}</span>
      </button>
    </div>
    {/if}

    {* Minimalna ilość: zdanie pod wierszem zakupu, nie komunikat błędu. Klient
       jeszcze niczego nie zrobił źle. *}
    {if $modules.quince_engine.product.options.add_to_cart.minimal|default:true}
      <p class="q-buy__minimal product-minimal-quantity js-product-minimal-quantity"
         {if $product.minimal_quantity <= 1} hidden{/if}>
        {if $product.minimal_quantity > 1}
          {l s='The minimum purchase order quantity for the product is %quantity%.'
             sprintf=['%quantity%' => $product.minimal_quantity] d='Shop.Theme.Checkout'}
        {/if}
      </p>
    {/if}

    {* Miejsce modułów przy przycisku zakupu: raty, porównywarka, zapytanie
       o dostępność. *}
    {capture name='qDzialania'}{hook h='displayProductActions' product=$product}{/capture}
    {if trim($smarty.capture.qDzialania) !== ''}
      {$smarty.capture.qDzialania nofilter}
    {/if}
  </div>
{/if}
