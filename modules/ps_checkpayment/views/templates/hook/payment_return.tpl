{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

<h2>{l s='Payment information' d='Shop.Theme.Checkout'}</h2>
<p class="q-checkout2__sub">{l s='Pay by Check' d='Modules.Checkpayment.Shop'}</p>

{if $status === 'ok'}
  <p class="q-checkout2__sub">
    {l s='You have chosen payment by check.' d='Modules.Checkpayment.Shop'}<br/>
    {l s='Your check must include following details:' d='Modules.Checkpayment.Shop'}
  </p>

  <dl class="q-checkout2__bank">
    <dt>{l s='Payment amount' d='Modules.Checkpayment.Shop'}</dt>
    <dd>{$total_to_pay}</dd>
    <dt>{l s='Payable to the order of' d='Modules.Checkpayment.Shop'}</dt>
    <dd>{if $checkName}{$checkName}{else}___________{/if}</dd>
    <dt>{l s='Mail to' d='Modules.Checkpayment.Shop'}</dt>
    <dd>{if $checkAddress}{$checkAddress nofilter}{else}___________{/if}</dd>
  </dl>

  <p class="q-checkout2__sub">
    {if !isset($reference)}
      {l s='Do not forget to insert your order number #%d.' sprintf=[$id_order] d='Modules.Checkpayment.Shop'}<br aria-hidden="true">
    {else}
      {l s='Do not forget to insert your order reference %s.' sprintf=[$reference] d='Modules.Checkpayment.Shop'}<br aria-hidden="true">
    {/if}
    {l s='An email has been sent to you with this information.' d='Modules.Checkpayment.Shop'}<br aria-hidden="true">
    {l s='Your order will be sent as soon as we receive your payment.' d='Modules.Checkpayment.Shop'}
  </p>

  <p class="q-checkout2__sub">
    {l s='For any questions or for further information, please contact our' d='Modules.Checkpayment.Shop'}
    <a href="{$link->getPageLink('contact', true)|escape:'html'}">{l s='customer service department.' d='Modules.Checkpayment.Shop'}</a>
  </p>
{else}
  <div class="q-checkout2__pending" role="alert">
    {l s='We have noticed that there is a problem with your order. If you think this is an error, you can contact our' d='Modules.Checkpayment.Shop'}
    <a href="{$link->getPageLink('contact', true)|escape:'html'}">{l s='customer service department.' d='Modules.Checkpayment.Shop'}</a>
  </div>
{/if}
