{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

<h2>{l s='Payment information' d='Shop.Theme.Checkout'}</h2>
<p class="q-checkout2__sub">{l s='Pay by Bank Wire' d='Modules.Wirepayment.Shop'}</p>

{if $status === 'ok'}
  <p class="q-checkout2__sub">
    {l s='You have chosen payment by bank transfer.' d='Modules.Wirepayment.Shop'}<br aria-hidden="true">
    {l s='Please send us a bank transfer with following details:' d='Modules.Wirepayment.Shop'}
  </p>

  <dl class="q-checkout2__bank">
    <dt>{l s='Amount' d='Modules.Wirepayment.Shop'}</dt>
    <dd>{$total}</dd>
    <dt>{l s='Name of account owner' d='Modules.Wirepayment.Shop'}</dt>
    <dd>{$bankwireOwner}</dd>
    <dt>{l s='Please include these details' d='Modules.Wirepayment.Shop'}</dt>
    <dd>{$bankwireDetails nofilter}</dd>
    <dt>{l s='Bank name' d='Modules.Wirepayment.Shop'}</dt>
    <dd>{$bankwireAddress nofilter}</dd>
  </dl>

  <p class="q-checkout2__sub">
    {l s='Please specify your order reference %s in the bankwire description.' sprintf=[$reference] d='Modules.Wirepayment.Shop'}<br aria-hidden="true">
    {l s='We\'ve also sent you this information by e-mail.' d='Modules.Wirepayment.Shop'}<br aria-hidden="true">
    {l s='Your order will be sent as soon as we receive payment.' d='Modules.Wirepayment.Shop'}
  </p>

  <p class="q-checkout2__sub">
    {l
      s='If you have questions, comments or concerns, please contact our [1]expert customer support team[/1].'
      d='Modules.Wirepayment.Shop' sprintf=['[1]' => "<a href='{$contact_url}'>", '[/1]' => '</a>']
    }
  </p>
{else}
  <div class="q-checkout2__pending" role="alert">
    {l
      s='We noticed a problem with your order. If you think this is an error, feel free to contact our [1]expert customer support team[/1].'
      d='Modules.Wirepayment.Shop' sprintf=['[1]' => "<a href='{$contact_url}'>", '[/1]' => '</a>']
    }
  </div>
{/if}
