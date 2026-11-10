{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

<div id="ps_cashondelivery-displayOrderConfirmation">
  <h2>{l s='Payment information' d='Shop.Theme.Checkout'}</h2>
  <p class="q-checkout2__sub">{l s='Pay by Cash on Delivery' d='Modules.Cashondelivery.Shop'}</p>

  <p class="q-checkout2__sub">
    {l s='Your order on %s is complete.' sprintf=[$shop_name] d='Modules.Cashondelivery.Shop'}<br aria-hidden="true">
    {l s='You have chosen the cash on delivery method.' d='Modules.Cashondelivery.Shop'}<br aria-hidden="true">
    {l s='Your order will be sent very soon.' d='Modules.Cashondelivery.Shop'}
  </p>

  <p class="q-checkout2__sub">
    {l s='For any questions or for further information, please contact our' d='Modules.Cashondelivery.Shop'}
    <a href="{$contact_url}" rel="nofollow">{l s='customer support' d='Modules.Cashondelivery.Shop'}</a>.
  </p>
</div>
