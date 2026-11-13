{**
 * Quince: pas promocji nad panelem zakupu.
 *
 * Pas jest zegarem odliczającym do końca promocji i niczym innym. Stoi
 * wyłącznie wtedy, gdy promocja MA termin: bez terminu nie ma czego odliczać,
 * a to, że trwa promocja, mówi już cena przekreślona, plakietka z procentem
 * i pigułka oszczędności.
 *
 * Próg dni mówi, jak daleko przed końcem pas ma się pojawić. Sklep ustawia
 * go w panelu, przy elemencie pasa.
 *
 * Termin bierzemy z ceny promocyjnej produktu, więc ustawia go sklep
 * w katalogu i nic nie trzeba dopisywać osobno.
 *
 * Zmienne: $qDni: próg dni z panelu.
 * Zachowanie licznika: assets/js/islands/buybox.js
 *}

{if $product.has_discount && isset($product.specific_prices.to)}
  {assign var=qDoKonca value=$product.specific_prices.to|qdays}

  {if $qDoKonca >= 0 && $qDoKonca <= ($qDni|default:7)}
    <div class="q-buy__pas">
      <span class="q-buy__pas-napis">{l s='Promotion ends in' d='Shop.Theme.Catalog'}</span>

      <span class="q-countdown" data-q-countdown="{$product.specific_prices.to|qstamp}">
        <svg class="q-countdown__icon" viewBox="0 0 16 16" fill="none" stroke="currentColor"
             stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="8" cy="8" r="6.3"/><path d="M8 4.4V8l2.6 1.5"/></svg>

        <span class="q-countdown__segment">
          <b data-q-countdown-days>0</b><i>{l s='days' d='Shop.Theme.Global'}</i>
        </span>

        <span class="q-countdown__segment">
          <b data-q-countdown-hours>00</b><i>{l s='hrs' d='Shop.Theme.Global'}</i>
        </span>

        <span class="q-countdown__segment">
          <b data-q-countdown-minutes>00</b><i>{l s='min' d='Shop.Theme.Global'}</i>
        </span>
      </span>
    </div>
  {/if}
{/if}
