{**
 * Quince — ulubione i drugie wezwanie pod wierszem zakupu.
 *
 * Wiersz ma zawsze ten sam kształt: serce o stałej szerokości po lewej,
 * przycisk biorący resztę wiersza po prawej. Zmienia się tylko to, co ten
 * przycisk robi.
 *
 * Przy produkcie do kupienia jest to „Kup teraz": prowadzi prosto do kasy, więc
 * jest wypełniony atramentem — ma wyglądać na przycisk równie realny co
 * „Do koszyka", tylko o innym ciężarze. Kontur czytał się jak akcja poboczna.
 *
 * Przy produkcie, którego nie da się zamówić, w to samo miejsce wchodzi prośba
 * o wiadomość i bierze barwę marki, bo zostaje jedynym działaniem na karcie.
 * Wiersz zakupu wtedy nie powstaje, więc klient nie ma czym kliknąć obok.
 *
 * Serce NIE stoi na wariantach `q-btn` i to jest decyzja: warianty przycisku
 * ustawiają barwę napisu z warstwy nadpisań, a warstwa bije swoistość, więc
 * reguła stanu `aria-pressed` nie miałaby szans i serce po dodaniu do ulubionych
 * zostawałoby szare.
 *
 * Zachowanie: assets/js/islands/wishlist.js (serce), islands/buybox.js („Kup
 * teraz") oraz islands/notify.js (szuflada zapisu).
 *
 * Zmienne: $qUlubione, $qKupTeraz, $qPowiadom — włączniki z panelu.
 *}

{assign var=qMaUlubione value=($qUlubione && isset($modules.quince_engine.header.wishlist) && $modules.quince_engine.header.wishlist.visible)}
{assign var=qMaKupTeraz value=($qKupTeraz && $product.add_to_cart_url)}
{assign var=qMaPowiadom value=(($qPowiadom|default:true) && !$product.add_to_cart_url && !$configuration.is_catalog)}

{if $qMaUlubione || $qMaKupTeraz || $qMaPowiadom || ($qWybierz|default:'')}
  <div class="q-buy__buy-row">
    {if $qMaUlubione}
      <button type="button"
              class="q-buy__wish"
              data-q-wish
              data-q-wish-produkt="{$product.id|intval}"
              data-q-wish-wariant="{$product.id_product_attribute|intval}"
              aria-pressed="false"
              aria-label="{l s='Add %product_name% to your saved products' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}">
        {* Dwa rysunki, po jednym na stan: pusty i wypełniony. Wypełnienia obrysu
           nie da się zrobić stylem, bo to inny kształt, a nie inna barwa. *}
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
          <path class="q-buy__wish-outline" d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143q.09.083.176.171a3 3 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15"/>
          <path class="q-buy__wish-filled" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314"/>
        </svg>

        {* Podpis zostaje w drzewie, ale nie na ekranie: to on jest nazwą przycisku
           dla czytnika ekranu. *}
        <span class="q-buy__wish-label">{l s='Add to wishlist' d='Shop.Theme.Actions'}</span>
      </button>
    {/if}

    {if $qMaKupTeraz}
      <button class="q-btn q-btn--secondary q-btn--atrament"
              type="submit"
              data-button-action="add-to-cart"
              data-q-buy-now="{$urls.pages.order}">
        <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M11.251.068a.5.5 0 0 1 .227.58L9.677 6.5H13a.5.5 0 0 1 .364.843l-8 8.5a.5.5 0 0 1-.842-.49L6.323 9.5H3a.5.5 0 0 1-.364-.843l8-8.5a.5.5 0 0 1 .615-.09zM4.157 8.5H7a.5.5 0 0 1 .478.647L6.11 13.59l5.732-6.09H9a.5.5 0 0 1-.478-.647L9.89 2.41z"/></svg>
        <span class="q-btn__label">{l s='Buy now' d='Shop.Theme.Actions'}</span>
      </button>
    {elseif $qWybierz|default:''}
      {* Szybki podgląd produktu z wersjami: zamiast zakupu prowadzimy na kartę,
         bo „Do koszyka" dorzuciłoby wersję domyślną bez wiedzy klienta. Przycisk
         stoi w TYM wierszu, obok serca, a nie pod nim: układ wiersza zakupu jest
         jeden i taki sam w obu widokach. *}
      <a class="q-btn q-btn--primary" href="{$qWybierz}">
        <span class="q-btn__label">{l s='Choose options' d='Shop.Theme.Actions'}</span>
      </a>

    {elseif $qMaPowiadom}
      <button class="q-btn q-btn--primary" type="button" data-q-notify-open>
        <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2M8 1.918l-.797.161A4 4 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4 4 0 0 0-3.203-3.92zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5 5 0 0 1 13 6c0 .88.32 4.2 1.22 6"/></svg>
        {* Krótki napis własny, nie zdanie modułu powiadomień: „Powiadom mnie,
           kiedy będzie dostępny" nie mieści się obok serca na telefonie. *}
        <span class="q-btn__label">{l s='Notify when available' d='Shop.Theme.Actions'}</span>
      </button>
    {/if}
  </div>

  {if $qMaPowiadom}
    {include file='catalog/_partials/product-notify.tpl'}
  {/if}
{/if}
