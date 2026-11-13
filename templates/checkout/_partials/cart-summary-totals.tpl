{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Kwota do zapłaty stoi POZA zwijanym ciałem kolumny: po zwinięciu klient
   ma dalej widzieć, ile płaci. Dopóki przewoźnik nie jest wybrany, dopisek
   pod napisem mówi, że w kwocie nie ma jeszcze dostawy.

   Dwa źródła prawdy, z tego samego powodu co w `cart-summary-subtotals.tpl`:
   `$checkout_steps` istnieje tylko w krokowej, OPC rozpoznaje przewoźnika
   po niepustym `$delivery_option`. *}
{assign var=qDostawaZnana value=false}
{if isset($checkout_steps)}
  {foreach from=$checkout_steps item="k"}
    {if $k.identifier === 'checkout-delivery-step' && $k.is_complete}{assign var=qDostawaZnana value=true}{/if}
  {/foreach}
{elseif isset($delivery_option) && $delivery_option !== ''}
  {assign var=qDostawaZnana value=true}
{/if}

<div class="q-ordersum__grand js-cart-summary-totals">
  <b>
    {$cart.totals.total.label}
    {if !$qDostawaZnana}
      <small>{l s='without the shipping cost' d='Shop.Theme.Checkout'}</small>
    {/if}
  </b>
  <span class="q-ordersum__grand-value">{$cart.totals.total.value}</span>
</div>
