{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Kwoty składowe. Nazwy bierze się z rdzenia, bo to on wie, czy sklep pokazuje
   ceny z podatkiem, czy bez.

   Koszt dostawy przed wyborem przewoźnika nie jest znany. Zero w tym miejscu
   obiecywałoby darmową przesyłkę, więc zamiast kwoty stoi zdanie, w którym
   kroku klient ją pozna.

   Dwa źródła prawdy, bo ten partial renderuje się w obu wariantach kasy:
   `$checkout_steps` istnieje tylko w krokowej (lista kroków z `is_complete`).
   OPC nie ma kroków w tym sensie. Tam sygnałem jest `$delivery_option`,
   który moduł wypełnia, gdy do adresu dostawy jest przypisany przewoźnik
   (pusty, dopóki adres nie jest kompletny; niepusty już przy domyślnie
   podstawionym przewoźniku). `isset()` na $checkout_steps jest konieczne:
   w OPC ta zmienna nie istnieje i Smarty zgłasza „Undefined array key". *}
{assign var=qDostawaZnana value=false}
{if isset($checkout_steps)}
  {foreach from=$checkout_steps item="k"}
    {if $k.identifier === 'checkout-delivery-step' && $k.is_complete}{assign var=qDostawaZnana value=true}{/if}
  {/foreach}
{elseif isset($delivery_option) && $delivery_option !== ''}
  {assign var=qDostawaZnana value=true}
{/if}

<!-- DEBUG2 {if isset($cart.id_carrier)}CARRIER_SET=[{$cart.id_carrier}]{else}CARRIER_NOTSET{/if} | {if isset($delivery_option)}DELOPT_SET=[{$delivery_option}]{else}DELOPT_NOTSET{/if} -->
<div class="q-ordersum__tot js-cart-summary-subtotals-container">
  {foreach from=$cart.subtotals item="subtotal"}
    {if $subtotal && $subtotal.value|count_characters > 0 && $subtotal.type !== 'tax'}
      <div class="q-ordersum__tr" id="cart-subtotal-{$subtotal.type}">
        <span>{$subtotal.label}</span>

        {if $subtotal.type === 'shipping' && !$qDostawaZnana}
          <span class="q-ordersum__later">{l s='you will choose it in step 3' d='Shop.Theme.Checkout'}</span>
        {else}
          <span>{if 'discount' === $subtotal.type}-&nbsp;{/if}{$subtotal.value}</span>
        {/if}
      </div>
    {/if}
  {/foreach}

  {if !empty($cart.subtotals.tax) && $cart.subtotals.tax.value|count_characters > 0}
    <div class="q-ordersum__tr">
      <span>{$cart.subtotals.tax.label}</span>
      <span>{$cart.subtotals.tax.value}</span>
    </div>
  {/if}
</div>
