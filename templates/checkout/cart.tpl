{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file=$layout}

{* Okruszki idą do środka strony, jak na każdej innej podstronie. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  <main class="q-container q-cart">
    {include file='_partials/breadcrumb.tpl'}

    <div class="q-cart__head">
      <h1 class="q-section-title q-cart__title">{l s='Shopping Cart' d='Shop.Theme.Checkout'}</h1>
      <span class="q-cart__count">{l s='%count% products' sprintf=['%count%' => $cart.products_count] d='Shop.Theme.Checkout'}</span>
    </div>

    {* Podział szerokości ten sam, co na stronie produktu i w kasie:
       ustawienie panelu zakupu rządzi też tą kolumną. *}
    {assign var=qPdp value=$modules.quince_engine.product|default:null}
    <div class="q-cart__layout"{if $qPdp && isset($qPdp.split)} style="--q-pdp-glowna: {$qPdp.split.main}fr; --q-pdp-panel: {$qPdp.split.panel}fr"{/if}>

      {* ══ lewa kolumna: zawartość koszyka ══════════════════════════════ *}
      <div class="q-cart__main">
        {block name='cart_update_alert'}
          <div class="js-cart-update-alert" data-ps-data="{l s='has been removed from the cart.' d='Shop.Theme.Actions' js=1}" data-ps-data-close="{l s='Close' d='Shop.Theme.Actions' js=1}" aria-atomic="true"></div>
        {/block}

        {block name='hook_shopping_cart_extra'}
          {hook h='displayShoppingCartFooter'}
        {/block}

        {block name='cart_overview'}
          {include file='checkout/_partials/cart-detailed.tpl' cart=$cart}
        {/block}

        {block name='continue_shopping'}
          <div class="q-cart__actions">
            <a class="q-cart__continue" href="{$urls.pages.index}">
              <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M13 8H3M7 4 3 8l4 4"/></svg>
              {l s='Continue shopping' d='Shop.Theme.Actions'}
            </a>
          </div>
        {/block}

        {* Dokupka: krótka lista pod pozycjami (patrz `quince_crossselling`,
           PLACEMENT_CART). Karuzela rdzenia (`displayCrossSellingShoppingCart`)
           celowo nie stoi na tej stronie — ta sama lista pokazana drugi raz
           niżej była zbędnym powtórzeniem. *}
        {block name='hook_cart_suggest'}
          {hook h='displayQuinceCartSuggest'}
        {/block}

        {* Miejsce na dowolny hook pod dokupką — ten sam mechanizm, co hook
           pod „Order details" na potwierdzeniu zamówienia (`CheckoutSettings`):
           sklep sam wpisuje nazwę w ustawieniach Cart, a tu tylko ją wywołujemy.
           Margines ten sam, co nad dokupką (`.q-cart__suggest`), żeby odstęp
           od sąsiada wyglądał tak samo niezależnie od tego, który z nich
           akurat coś pokazuje. *}
        {block name='hook_cart_below_suggest'}
          {if $modules.quince_engine.cart.belowSuggestHook|default:''}
            {capture name='cartBelowSuggestHook'}
              {hook h=$modules.quince_engine.cart.belowSuggestHook}
            {/capture}
            {if trim($smarty.capture.cartBelowSuggestHook) !== ''}
              <div class="q-cart__below-suggest">{$smarty.capture.cartBelowSuggestHook nofilter}</div>
            {/if}
          {/if}
        {/block}
      </div>

      {* ══ prawa kolumna: podsumowanie ══════════════════════════════════
         Własny, zawsze otwarty `.q-ordersum` — nie ten z kasy, który się
         zwija i pokazuje miniaturki po zwinięciu. Na stronie koszyka
         pozycje są już widoczne w lewej kolumnie, więc nie ma czego
         zwijać ani powtarzać. *}
      <aside class="q-cart__side" aria-label="{l s='Order summary' d='Shop.Theme.Checkout'}">
        {block name='cart_summary'}
          {block name='cart_totals'}
            {include file='checkout/_partials/cart-detailed-totals.tpl' cart=$cart}
          {/block}
        {/block}

        {block name='cart_below_summary'}
          {hook h='displayCartBelowSummary'}
        {/block}

        {if $modules.quince_engine.cart.showReassurance|default:true}
          {block name='hook_reassurance'}
            {hook h='displayReassurance'}
          {/block}
        {/if}
      </aside>
    </div>
  </main>
{/block}
