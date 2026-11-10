{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file=$layout}

{block name='notifications'}
{/block}

{block name='breadcrumb'}
{/block}

{block name='content_columns'}

  {* Ta sama skrócona oprawa, co w kasie krokowej (`checkout/checkout.tpl`):
     bez menu i bez wyszukiwarki. Pasek kroków tu nie stoi — w jednej stronie
     nie ma kroków do pokazania, więc `.q-checkout-steps` zostaje pominięty. *}
  <header class="q-checkout-head">
    <div class="q-container q-checkout-head__in">
      <a class="q-checkout-head__logo" href="{$urls.base_url}">
        {if $shop.logo_details}
          <img src="{$shop.logo_details.src}" alt="{$shop.name}"
               width="{$shop.logo_details.width}" height="{$shop.logo_details.height}">
        {else}
          <b>{$shop.name}</b>
        {/if}
      </a>

      <div class="q-checkout-head__right">
        <a class="q-checkout-head__item q-checkout-head__item--contact" href="{$urls.pages.cart}?action=show">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 6l-6 6 6 6"></path></svg>
          {l s='Back to cart' d='Shop.Theme.Checkout'}
        </a>
      </div>
    </div>
  </header>

  <main class="q-container q-checkout2-page"
        data-q-msg-required="{l s='Required field' d='Shop.Forms.Errors'}"
        data-q-msg-format="{l s='Invalid format.' d='Shop.Forms.Errors'}">
    <h1 class="q-checkout2__title">{l s='Order' d='Shop.Theme.Checkout'}</h1>

    {block name='checkout_notifications'}
      {include file='_partials/notifications.tpl'}
    {/block}

    {* Przyciski portfeli nad formularzem — ten sam hook i te same klasy
       `.q-express-btn*`, co na stronie koszyka. Osobny wiersz, bo moduł
       pokazuje je tylko tutaj, nie w kasie krokowej. *}
    {capture name='qOpcExpress'}{hook h='displayExpressCheckout'}{/capture}
    {if trim($smarty.capture.qOpcExpress)}
      <div class="opc-express-checkout">
        <div class="opc-express-checkout__buttons">
          {$smarty.capture.qOpcExpress nofilter}
        </div>
        <div class="opc-express-checkout__separator" aria-hidden="true">
          <span>{l s='or' d='Modules.Onepagecheckout.Shop'}</span>
        </div>
      </div>
    {/if}

    {* Ten sam podział szerokości, co w kasie krokowej i na stronie
       produktu: ustawienie panelu zakupu rządzi też kolumną zamówienia. *}
    {assign var=qPdp value=$modules.quince_engine.product|default:null}
    <div class="q-checkout2"{if $qPdp && isset($qPdp.split)} style="--q-pdp-glowna: {$qPdp.split.main}fr; --q-pdp-panel: {$qPdp.split.panel}fr"{/if}>
      <div class="q-checkout2__form">
        {block name='checkout_process'}
          {render file='checkout/checkout-process.tpl' ui=$checkout_process}
        {/block}
      </div>

      {* Kolumna zamówienia: ta sama `.q-ordersum`, co wszędzie indziej.
         Zgoda, newsletter i prawdziwy przycisk zamówienia stoją w stopce
         formularza (`one-page-checkout.tpl`) — tylko ten szablon zna listę
         zgód i metodę płatności. Wyspa `checkout-summary.js` przenosi je
         tutaj tymi samymi węzłami DOM, co w kasie krokowej. *}
      <aside class="q-checkout__side" aria-label="{l s='Your order' d='Shop.Theme.Checkout'}">
        <div class="q-ordersum q-ordersum--open" data-q-sum>
          {block name='cart_summary'}
            {include file='checkout/_partials/cart-summary.tpl' cart=$cart}
          {/block}

          <div class="q-ordersum__foot" data-q-pay-slot></div>
        </div>
      </aside>
    </div>
  </main>

  {assign var=qf value=$modules.quince_engine.footer}
  <footer class="q-checkout-foot q-footer__bar">
    <div class="q-container q-footer__bar-inner">
      <span class="q-footer__bar-links">
        {foreach from=$qf.barLinks item=odnosnik}
          <a href="{$odnosnik.url|escape:'html':'UTF-8'}">{$odnosnik.label}</a>
        {/foreach}
      </span>

      <span class="q-footer__bar-text">
        {if $qf.copyright}{$qf.copyright}{else}&copy; {'now'|date_format:'%Y'} {$shop.name}{/if}
      </span>

      <span class="q-footer__pay">
        {foreach from=$qf.payments item=payment}<span>{$payment}</span>{/foreach}
      </span>
    </div>
  </footer>

  {* `checkout/_partials/modal-terms.tpl` pominięty jak w kasie krokowej:
     okno Bootstrapa bez załadowanego JS. Link do regulaminu w stopce
     formularza prowadzi wprost na stronę CMS, modala nie wywołuje nic. *}
{/block}
