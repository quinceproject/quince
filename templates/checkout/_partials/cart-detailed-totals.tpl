{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Kolumna podsumowania na stronie koszyka. Ten sam `.q-ordersum`, co
   w kasie, ale zawsze otwarty: bez przycisku rozwijania, bez miniaturek
   i bez listy produktów, bo ta stoi już w lewej kolumnie. *}
{block name='cart_detailed_totals'}
  {* Korzeń niesie klasy komponentu I zaczep AJAX rdzenia (`js-cart-detailed-totals`):
     po zmianie ilości rdzeń podmienia ten węzeł w całości odpowiedzią
     z tego samego szablonu, więc musi umieć znaleźć go po tej klasie. *}
  <div class="q-ordersum q-ordersum--open js-cart-detailed-totals">
    <div class="q-ordersum__head">
      <b>{l s='Order summary' d='Shop.Theme.Checkout'}</b>
    </div>

    <div class="q-ordersum__body">
      <div class="q-ordersum__tot">
        {foreach from=$cart.subtotals item="subtotal"}
          {if $subtotal && $subtotal.value|count_characters > 0 && $subtotal.type !== 'tax'}
            <div class="q-ordersum__tr">
              <span>{if $subtotal.type === 'products'}{$cart.summary_string}{else}{$subtotal.label}{/if}</span>
              <span>{if $subtotal.type === 'discount'}-&nbsp;{/if}{$subtotal.value}</span>
            </div>
          {/if}
        {/foreach}
      </div>
    </div>

    {block name='cart_summary_total'}
      <div class="q-ordersum__grand">
        {if !$configuration.display_prices_tax_incl && $configuration.taxes_enabled}
          <span><b>{$cart.totals.total.label}&nbsp;{$cart.labels.tax_short}</b></span>
          <span class="q-ordersum__grand-value">{$cart.totals.total.value}</span>
        {else}
          <span><b>{$cart.totals.total.label}&nbsp;{if $configuration.taxes_enabled}{$cart.labels.tax_short}{/if}</b></span>
          <span class="q-ordersum__grand-value">{$cart.totals.total.value}</span>
        {/if}
      </div>

      {if $cart.subtotals.tax}
        <p class="q-ordersum__tax">
          {l s='%label%:' sprintf=['%label%' => $cart.subtotals.tax.label] d='Shop.Theme.Global'} {$cart.subtotals.tax.value}
        </p>
      {/if}
    {/block}

    <div class="q-ordersum__foot">
      {block name='cart_voucher'}
        {include file='checkout/_partials/cart-voucher.tpl'}
      {/block}

      {block name='cart_actions'}
        {include file='checkout/_partials/cart-detailed-actions.tpl' cart=$cart}
      {/block}
    </div>
  </div>
{/block}
