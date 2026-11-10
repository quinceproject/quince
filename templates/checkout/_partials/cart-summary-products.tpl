{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{* Pozycje wypisane wprost, bez akordeonu: w kasie klient potwierdza, co
   kupuje, więc lista nie ma prawa być schowana za drugim kliknięciem. *}
<div class="js-cart-summary-products">
  {foreach from=$cart.products item=product}
    {include file='checkout/_partials/cart-summary-product-line.tpl' product=$product}
  {/foreach}
</div>
