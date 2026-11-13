{**
 * Quince: rabaty ilościowe w panelu zakupu.
 *
 * W panelu stoi jeden wiersz z hasłem i progami, a pełna tabela czeka
 * w szufladzie.
 *
 * W szufladzie każdy próg jest przyciskiem: klik ustawia tę ilość w liczniku.
 * Rdzeń podaje progi, ale nie mówi, przy którym klient właśnie jest, więc próg
 * osiągnięty bieżącą ilością podświetla skrypt, a wiersz w panelu przechodzi
 * wtedy z zachęty w potwierdzenie.
 *
 * Klasa `js-product-discounts` zostaje na korzeniu: po niej rdzeń podmienia
 * blok po zmianie wariantu. Znacznik `hidden` też jest jego: produkt bez
 * progów ma zostawić puste miejsce, a nie znikającą sekcję.
 *
 * Zachowanie szuflady: assets/js/islands/buybox.js
 * Projekt: makieta strony produktu, szuflada „progi".
 *}

<section class="q-tier js-product-discounts"
  {if !$product.show_price || !$product.quantity_discounts|count} hidden{/if}>

  {if $product.quantity_discounts}
    {* Progi w jednym wierszu, bo razem są odpowiedzią na jedno pytanie.
       Kropka rozdziela je bez rysowania kresek. Ten sam napis wraca do
       znacznika, bo skrypt przywraca go po zejściu poniżej progu. *}
    {capture name='qProgiOpis'}{strip}
      {foreach from=$product.quantity_discounts item=qProg name=qProgi}
        {if !$smarty.foreach.qProgi.first} · {/if}
        {l s='from %qty% pcs.' sprintf=['%qty%' => $qProg.quantity] d='Shop.Theme.Catalog'} {$qProg.discount}
      {/foreach}
    {/strip}{/capture}

    <button class="q-tier__panel" type="button" data-q-tier-open
            data-q-tier-hit="{l s='You have the price from %qty% pcs.' sprintf=['%qty%' => '#'] d='Shop.Theme.Catalog'}"
            data-q-tier-hit-note="{l s='%price% per item, see the other thresholds' sprintf=['%price%' => '#'] d='Shop.Theme.Catalog'}">
      <span class="q-tier__icon" aria-hidden="true">
        <svg width="17" height="17" viewBox="0 0 16 16" fill="currentColor"><path d="M6 4.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0m-1 0a.5.5 0 1 0-1 0 .5.5 0 0 0 1 0"/><path d="M2 1h4.586a1 1 0 0 1 .707.293l7 7a1 1 0 0 1 0 1.414l-4.586 4.586a1 1 0 0 1-1.414 0l-7-7A1 1 0 0 1 1 6.586V2a1 1 0 0 1 1-1m0 5.586 7 7L13.586 9l-7-7H2z"/></svg>
      </span>

      <span>
        <span class="q-tier__tagline" data-q-tier-tagline
              data-q-tier-base="{l s='Buy more, pay less' d='Shop.Theme.Catalog'}">{l s='Buy more, pay less' d='Shop.Theme.Catalog'}</span>

        <span class="q-tier__tiers" data-q-tier-tiers
              data-q-tier-base="{$smarty.capture.qProgiOpis|trim}">{$smarty.capture.qProgiOpis|trim}</span>
      </span>

      <svg class="q-tier__chev" width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/></svg>
    </button>

    <dialog class="q-modal q-modal--drawer" data-q-tier-drawer aria-labelledby="q-tier-title">
      <div class="q-modal__head">
        <h2 class="q-modal__title" id="q-tier-title">{l s='Price depends on quantity' d='Shop.Theme.Catalog'}</h2>

        <button class="q-modal__close" type="button" data-q-tier-close
                aria-label="{l s='Close' d='Shop.Theme.Global'}">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
        </button>
      </div>

      <div class="q-modal__body">
        <p class="q-tier__lead">{l s='The more items in one order, the lower the price per item. Click a threshold to set that quantity.' d='Shop.Theme.Catalog'}</p>

        {assign var=qPierwszyProg value=$product.quantity_discounts[0].quantity}

        {* Wiersz bez rabatu: cena, od której klient zaczyna. Bez niego zestawienie
           zaczyna się od trzeciej sztuki i nie widać, ile kosztuje jedna. *}
        <button class="q-tiers__row" type="button" data-q-tier-row data-quantity="1">
          <span>
            {if $qPierwszyProg > 2}
              {l s='%from%-%to% pcs.' sprintf=['%from%' => 1, '%to%' => $qPierwszyProg - 1] d='Shop.Theme.Catalog'}
            {else}
              {l s='%qty% pcs.' sprintf=['%qty%' => 1] d='Shop.Theme.Catalog'}
            {/if}
          </span>
          <span class="q-tiers__price">{$product.price}</span>
          <span class="q-tiers__savings"></span>
        </button>

        {foreach from=$product.quantity_discounts item=qProg}
          <button class="q-tiers__row" type="button" data-q-tier-row
                  data-quantity="{$qProg.quantity|intval}">
            <span>
              {if $qProg.nextQuantity > 0}
                {l s='%from%-%to% pcs.' sprintf=['%from%' => $qProg.quantity, '%to%' => $qProg.nextQuantity - 1] d='Shop.Theme.Catalog'}
              {else}
                {l s='%from% and more' sprintf=['%from%' => $qProg.quantity] d='Shop.Theme.Catalog'}
              {/if}
            </span>

            {* Cena za sztukę zawsze, niezależnie od ustawienia sklepu „pokazuj
               ceny rabatów ilościowych": to ona jest powodem, dla którego ktoś
               bierze więcej. Rdzeń liczy ją przy każdym progu. *}
            <span class="q-tiers__price">{$qProg.discounted_unit_price}</span>

            <span class="q-tiers__savings">
              {if $qProg.reduction_type == 'percentage'}
                &minus;{$qProg.real_value|string_format:"%g"}%
              {else}
                {assign var=qZysk value=$qProg.initial_price_raw - $qProg.discounted_unit_price_raw}
                &minus;{$qZysk|qprice}
              {/if}
            </span>
          </button>
        {/foreach}

        {* Zdanie o bieżącym wyborze wypisuje skrypt: ilość zna dopiero licznik
           w panelu, a ta sama szuflada obsługuje każdą jej wartość. *}
        <p class="q-tiers__status" data-q-tier-status
           data-q-tier-status-template="{l s='Selected quantity: %qty% pcs., price %price% per item' sprintf=['%qty%' => '#q', '%price%' => '#c'] d='Shop.Theme.Catalog'}"></p>
      </div>
    </dialog>
  {/if}
</section>
