{**
 * Quince — pasek zakupu na telefonie.
 *
 * Leży przy dolnej krawędzi i pokazuje się wtedy, gdy panelu zakupu NIE widać:
 * i przed dojechaniem do niego, i po minięciu. Niesie to, po co klient wraca
 * na górę: kwotę i przycisk.
 *
 * Schowany pasek nie znika całkiem — zostaje samo koło z uchwytem, wystające
 * ponad krawędź. Dzięki temu rozwinięcie panelu jest w zasięgu kciuka na każdej
 * wysokości strony, także wtedy, gdy pasek nie ma czego pokazywać, bo cenę
 * widać obok. Uchwyt otwiera warstwę z `product-buy-sheet.tpl`.
 *
 * Przycisk zakupu stoi poza formularzem, więc wiąże się z nim przez `form`:
 * to ten sam formularz, ten sam wysłany zestaw pól i ta sama obsługa rdzenia,
 * co przy przycisku w panelu.
 *
 * Zachowanie: assets/js/islands/buybox.js
 *}

{if !$configuration.is_catalog && $product.show_price}
  <div class="q-mobilebar" data-q-mobilebar>

    {* Kwota, a nie termin wysyłki: w chwili, gdy klient sięga po przycisk,
       rozstrzyga cena. Cena przed obniżką POD bieżącą, bo obok zabierałaby
       przyciskowi szerokość, której ten potrzebuje na każdym telefonie. *}
    <div class="q-mobilebar__price" data-q-variant="mobilebar-price">
      <span class="q-price__current{if $product.has_discount} q-price__current--promo{/if}">
        <data value="{$product.price_amount}">{$product.price}</data>
      </span>

      {if $product.has_discount}
        <span class="q-price__old"><data value="{$product.regular_price_amount}">{$product.regular_price}</data></span>
      {/if}
    </div>

    {* Uchwyt przy górnej krawędzi paska. Półokrągły, bo ma wyglądać jak języczek
       do pociągnięcia, a nie jak kolejny przycisk w rzędzie: pasek ma już jeden
       przycisk i drugi obok czytałby się jako równorzędny.

       Strzałka, nie ikona ustawień: w górę znaczy „wyciągnij to", obrócona w dół
       znaczy „schowaj". Pośrodku, bo prawy róg należy do przycisku zakupu. *}
    <span class="q-mobilebar__nisza">
      <span class="q-mobilebar__luk">
        <button class="q-mobilebar__uchwyt" type="button" data-q-sheet-toggle
                aria-expanded="false" aria-controls="q-sheet-buybox"
                aria-label="{l s='Show the price and product options' d='Shop.Theme.Actions'}">
          <svg class="q-mobilebar__chev" viewBox="0 0 16 16" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 10 8 6l4 4"/></svg>
        </button>
      </span>
    </span>

    {* Ten sam czasownik nosi ten sam znak co w panelu: torba przy zakupie,
       dzwonek przy powiadomieniu. *}
    {if $product.add_to_cart_url}
      <button class="q-btn q-btn--primary" type="submit" data-q-variant="mobilebar-action"
              form="add-to-cart-or-refresh"
              data-button-action="add-to-cart"
              title="{l s='Add to cart %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}">
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 1a2.5 2.5 0 0 1 2.5 2.5V4h-5v-.5A2.5 2.5 0 0 1 8 1m3.5 3v-.5a3.5 3.5 0 1 0-7 0V4H1v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V4zM2 5h12v9a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1z"/></svg>
        {* Krótszy napis niż w panelu: pasek dzieli szerokość na kwotę, uchwyt
           i przycisk, a „Dodaj do koszyka" nie mieści się w swojej trzeciej
           części na telefonie. *}
        <span class="q-btn__label">{l s='To cart' d='Shop.Theme.Actions'}</span>
      </button>
    {elseif $modules.quince_engine.product.options.buy_now.notify|default:true}
      <button class="q-btn q-btn--primary" type="button" data-q-variant="mobilebar-action" data-q-notify-open>
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2M8 1.918l-.797.161A4 4 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4 4 0 0 0-3.203-3.92zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5 5 0 0 1 13 6c0 .88.32 4.2 1.22 6"/></svg>
        <span class="q-btn__label">{l s='Notify me' d='Shop.Theme.Actions'}</span>
      </button>
    {/if}
  </div>
{/if}
