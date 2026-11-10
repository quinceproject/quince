{**
 * Quince: zestawy, w których występuje oglądany produkt.
 *
 * Każdy zestaw to rząd składników „to plus to" po lewej i słupek z ceną
 * zestawu po prawej. Dane liczy silnik (`Quince\Engine\Product\Bundles`):
 * rdzeń daje szablonowi najwyżej jeden zestaw i bez składników.
 *
 * Pas z licznikiem stoi na słupku tylko wtedy, gdy sam zestaw ma obniżkę
 * z datą końca. Oszczędność względem sumy składników jest stała i terminu
 * nie ma, więc licznika nie uruchamia.
 *
 * Zmienne: $qDni, próg dni licznika, ten sam co przy pasie w panelu zakupu.
 * Zachowanie: assets/js/islands/buybox.js („Kup zestaw teraz" i licznik).
 * Projekt: makieta strony produktu, sekcja zestawów.
 *}

{if $qZestawy|default:[]}
  <section class="q-bundles" data-q-bundles aria-labelledby="q-bundles-title">
    <h2 id="q-bundles-title" class="q-section-title">
      <svg class="q-section-title__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2 5.5 8 2l6 3.5v5L8 14l-6-3.5zM8 3.6 4 5.9v4.2l4 2.3 4-2.3V5.9z"/></svg>
      {l s='Available packs with this product' d='Shop.Theme.Catalog'}
    </h2>

    {foreach from=$qZestawy item=qZestaw}
      <div class="q-bundle">
        <div class="q-bundle__items">
          {foreach from=$qZestaw.items item=qSkladnik name=qSkladniki}
            {if !$smarty.foreach.qSkladniki.first}
              <div class="q-bundle__plus" aria-hidden="true"><svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2"/></svg></div>
            {/if}

            <div class="q-bundle__item{if $qSkladnik.current} q-bundle__item--current{/if}">
              <div class="q-bundle__thumb">
                {if $qSkladnik.current}
                  <span class="q-badge q-badge--bundle q-bundle__tag">{l s='This product' d='Shop.Theme.Catalog'}</span>
                {/if}
                <img loading="lazy" decoding="async" width="250" height="250" alt=""
                     src="{if $qSkladnik.image}{$qSkladnik.image}{else}{$urls.no_picture_image.bySize.home_default.url}{/if}">
              </div>

              <div class="q-bundle__name">{$qSkladnik.name}</div>

              {* Przy kilku sztukach w zestawie cena jednej bez liczby nie składa
                 się z ceną zestawu i suma wyglądałaby na błędną. *}
              {if $configuration.show_prices}
                <div class="q-bundle__price">{if $qSkladnik.quantity > 1}{$qSkladnik.quantity} × {/if}{$qSkladnik.price|qprice}</div>
              {/if}
            </div>
          {/foreach}
        </div>

        <div class="q-bundle__side">
          {if $configuration.show_prices && $qZestaw.end}
            {assign var=qDoKonca value=$qZestaw.end|qdays}

            {if $qDoKonca >= 0 && $qDoKonca <= ($qDni|default:365)}
              {* Bez ikony zegara: słupek jest wąski, a podpis mówi wprost,
                 czego dotyczy odliczanie. *}
              <div class="q-buy__pas q-bundle__pas">
                <span class="q-buy__pas-napis">{l s='Promotion ends in' d='Shop.Theme.Catalog'}</span>

                <span class="q-countdown" data-q-countdown="{$qZestaw.end|qstamp}">
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

          <div class="q-bundle__side-title">{$qZestaw.name}</div>

          {if $configuration.show_prices}
            <div class="q-bundle__total">
              <span class="q-bundle__total-label">{l s='Pack price' d='Shop.Theme.Catalog'}</span>
              <span class="q-bundle__total-price">{$qZestaw.price|qprice}</span>

              {if $qZestaw.save > 0}
                <span class="q-bundle__total-old">{$qZestaw.regular|qprice}</span>
                <span class="q-bundle__total-save">{l s='You save %amount%' sprintf=['%amount%' => $qZestaw.save|qprice] d='Shop.Theme.Catalog'}</span>
              {/if}
            </div>
          {/if}

          {* Dodanie do koszyka robi skrypt rdzenia, jak przy każdym przycisku
             `add-to-cart`: bierze formularz przycisku. Przejście do zamówienia
             dokłada `data-q-buy-now`. *}
          {if $qZestaw.orderable && !$configuration.is_catalog}
            <form class="q-bundle__form" action="{$urls.pages.cart}" method="post">
              <input type="hidden" name="token" value="{$static_token}">
              <input type="hidden" name="id_product" value="{$qZestaw.id}">
              <input type="hidden" name="qty" value="{$qZestaw.minimal}">

              <button class="q-btn q-btn--secondary q-btn--atrament q-btn--block" type="submit"
                      data-button-action="add-to-cart" data-q-buy-now="{$urls.pages.order}">
                <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M11.251.068a.5.5 0 0 1 .227.58L9.677 6.5H13a.5.5 0 0 1 .364.843l-8 8.5a.5.5 0 0 1-.842-.49L6.323 9.5H3a.5.5 0 0 1-.364-.843l8-8.5a.5.5 0 0 1 .615-.09z"/></svg>
                {l s='Buy the pack now' d='Shop.Theme.Actions'}
              </button>
            </form>
          {/if}

          <a class="q-bundle__more" href="{$qZestaw.url}">
            {l s='See pack details' d='Shop.Theme.Catalog'}
            <svg class="q-bundle__arrow" width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
          </a>
        </div>
      </div>
    {/foreach}
  </section>
{/if}
