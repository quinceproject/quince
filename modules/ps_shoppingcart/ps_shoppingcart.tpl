{**
 * Szuflada koszyka: nagłówek z liczbą sztuk, pasek darmowej dostawy, pozycje,
 * dokupka i stopka z sumą.
 *
 * To szablon widżetu ps_shoppingcart, a nie osobny plik motywu: moduł koszyka
 * po każdej zmianie koszyka pobiera widżet na nowo i podmienia na stronie
 * element `.blockcart`. Szuflada odświeża się więc tą samą drogą, którą moduł
 * odświeża podgląd koszyka w każdym motywie. Okno, w którym widżet stoi,
 * rysuje `_partials/cart-drawer.tpl`.
 *
 * Dwa opakowania, bo moduł koszyka bierze z odpowiedzi `.blockcart` szukane
 * WEWNĄTRZ niej: element `.blockcart` na samej górze szablonu nie zostałby
 * znaleziony i moduł zastąpiłby treść szuflady niczym.
 *
 * Komunikat „dodano do koszyka" nie stoi tutaj: przychodzi z `modal.tpl`
 * tylko po dodaniu produktu i skrypt wstawia go w `data-q-cart-alert`.
 *
 * Projekt: makieta strony produktu, szuflada koszyka.
 * Wygląd: assets/css/components/cart-drawer.css
 *}

<div class="q-cart-drawer" data-q-cart-content>
<div class="blockcart q-cart-drawer__content" data-refresh-url="{$refresh_url}">
  <div class="q-modal__head">
    <h2 class="q-modal__title" id="q-cart-drawer-title">
      {l s='Cart' d='Shop.Theme.Checkout'} <span>({$cart.products_count})</span>
    </h2>
    <button class="q-modal__close" type="button" data-q-cart-close aria-label="{l s='Close' d='Shop.Theme.Global'}">
      <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor"
           stroke-width="1.8" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>
    </button>
  </div>

  <div class="q-modal__body">
    <div data-q-cart-alert></div>

    {if $cart.products}
      {assign var=qDostawa value=$cart|qfreeshipping}
      {if $qDostawa}
        {* Po przekroczeniu progu pasek zostaje pełny, a zdanie mówi, że dostawa
           jest za darmo. Znikający pasek wyglądałby jak błąd. *}
        <div class="q-shipping">
          {if $qDostawa.reached}
            <span class="q-shipping__label">{l s='You get free delivery' d='Shop.Theme.Checkout'}</span>
          {else}
            {capture name='qBrak'}<b>{$qDostawa.missing_formatted}</b>{/capture}
            <span class="q-shipping__label">{l s='You are %amount% away from free delivery' sprintf=['%amount%' => $smarty.capture.qBrak] d='Shop.Theme.Checkout'}</span>
          {/if}
          <span class="q-shipping__track"><span class="q-shipping__fill" style="inline-size:{$qDostawa.percent|intval}%"></span></span>
        </div>
      {/if}

      <div data-q-cart-lines>
        {foreach from=$cart.products item=qPozycja}
          <div class="q-cartline"
               data-q-cart-line="{$qPozycja.id_product|intval}-{$qPozycja.id_product_attribute|intval}-{$qPozycja.id_customization|intval}"
               data-id-product="{$qPozycja.id_product|intval}"
               data-id-product-attribute="{$qPozycja.id_product_attribute|intval}"
               data-id-customization="{$qPozycja.id_customization|intval}">
            <span class="q-cartline__media">
              <img src="{if $qPozycja.cover}{$qPozycja.cover.bySize.cart_default.url}{else}{$urls.no_picture_image.bySize.cart_default.url}{/if}"
                   alt="" width="125" height="125" loading="lazy" decoding="async">
            </span>

            <div>
              <a class="q-cartline__name" href="{$qPozycja.url}">{$qPozycja.name}</a>
              <div class="q-cartline__row">
                {if $qPozycja.is_gift}
                  <span>{$qPozycja.quantity}&nbsp;&times;</span>
                {else}
                  <div class="q-qty">
                    <button class="q-qty__btn" type="button" data-q-cart-qty="-"
                            data-q-cart-url="{$qPozycja.update_quantity_url}"
                            aria-label="{l s='Decrease quantity of %product_name%' sprintf=['%product_name%' => $qPozycja.name] d='Shop.Theme.Actions'}">&minus;</button>
                    <input class="q-qty__input" type="number" value="{$qPozycja.quantity|intval}" min="1"
                           data-q-cart-input data-q-cart-url="{$qPozycja.update_quantity_url}" data-quantity="{$qPozycja.quantity|intval}"
                           aria-label="{l s='Change quantity of %product_name%' sprintf=['%product_name%' => $qPozycja.name] d='Shop.Theme.Actions'}">
                    <button class="q-qty__btn" type="button" data-q-cart-qty="+"
                            data-q-cart-url="{$qPozycja.update_quantity_url}"
                            aria-label="{l s='Increase quantity of %product_name%' sprintf=['%product_name%' => $qPozycja.name] d='Shop.Theme.Actions'}">+</button>
                  </div>
                {/if}
                <span class="q-cartline__price">{$qPozycja.price}</span>
              </div>
            </div>

            {if !$qPozycja.is_gift}
              <button class="q-cartline__remove" type="button" data-q-cart-remove="{$qPozycja.remove_from_cart_url}"
                      aria-label="{l s='Remove %product_name% from cart' sprintf=['%product_name%' => $qPozycja.name] d='Shop.Theme.Actions'}">
                <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor"
                     stroke-width="1.8" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>
              </button>
            {/if}
          </div>
        {/foreach}
      </div>

      {hook h='displayQuinceCartUpsell'}

      {* Hook z ustawień koszyka w silniku, pod dokupką: ten sam mechanizm co
         `hook_cart_below_suggest` na stronie koszyka. *}
      {if $modules.quince_engine.cart.drawerHook|default:''}
        {capture name='qDrawerHook'}{hook h=$modules.quince_engine.cart.drawerHook}{/capture}
        {if trim($smarty.capture.qDrawerHook) !== ''}
          <div class="q-drawer__below-suggest">{$smarty.capture.qDrawerHook nofilter}</div>
        {/if}
      {/if}
    {else}
      <div class="q-drawer__empty">
        <svg width="40" height="40" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
          <path d="M5 3a3 3 0 0 1 6 0h2.2l.7 10.1A1.9 1.9 0 0 1 12 15H4a1.9 1.9 0 0 1-1.9-1.9L2.8 3zm1 0h4a2 2 0 0 0-4 0"/>
        </svg>
        <p>{l s='Your cart is empty' d='Shop.Theme.Checkout'}</p>
        <button class="q-btn q-btn--primary q-btn--sm" type="button" data-q-cart-close>{l s='Browse products' d='Shop.Theme.Actions'}</button>
      </div>
    {/if}
  </div>

  {if $cart.products}
    <div class="q-modal__foot">
      <div class="q-modal__summary">
        <div class="q-drawer__row q-drawer__row--sum">
          <span>{l s='Subtotal' d='Shop.Theme.Checkout'}</span><span>{$cart.subtotals.products.value}</span>
        </div>
        <div class="q-drawer__row q-drawer__row--muted">
          <span>{l s='Shipping' d='Shop.Theme.Checkout'}</span><span>{l s='Calculated at checkout' d='Shop.Theme.Checkout'}</span>
        </div>
      </div>
      <div class="q-drawer__foot-actions">
        <a class="q-btn q-btn--primary q-btn--lg q-btn--block" href="{$urls.pages.order}">
          <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
            <path d="M8 1a3 3 0 0 0-3 3v2H4v8h8V6h-1V4a3 3 0 0 0-3-3m2 5H6V4a2 2 0 1 1 4 0z"/>
          </svg>
          <span class="q-btn__label">{l s='Proceed to checkout' d='Shop.Theme.Actions'}</span>
        </a>
        <a class="q-drawer__link" href="{$cart_url}">{l s='View cart' d='Shop.Theme.Actions'}</a>
      </div>
    </div>
  {/if}
</div>
</div>
