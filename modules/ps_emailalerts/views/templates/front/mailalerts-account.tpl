{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file='customer/page.tpl'}

{* Własny nagłówek — ten sam wzorzec co w pozostałych podstronach konta;
   ta strona nie ma własnej makiety. *}
{block name='page_header_container'}
  <div class="q-order-header">
    <a class="q-order-back" href="{$urls.pages.my_account}">
      <svg class="q-order-back__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 13 6 8l5-5"/></svg>
      {l s='Back to your account' d='Shop.Theme.Customeraccount'}
    </a>
    <h1 class="q-order-header__title" tabindex="-1">{l s='My alerts' d='Modules.Emailalerts.Shop'}</h1>
    <p class="visually-hidden">{l s='Manage your mail alerts to stay informed about product availability and updates.' d='Modules.Emailalerts.Shop'}</p>
  </div>
{/block}

{block name='page_content'}
  {if $mailAlerts}
    <div class="q-account-section q-card">
      <ul class="ps-emailalerts__product-list" data-ps-ref="emailalerts-product-list">
        {foreach from=$mailAlerts item=mailAlert}
          {include 'module:ps_emailalerts/views/templates/front/mailalerts-account-line.tpl' mailAlert=$mailAlert}
        {/foreach}
      </ul>
    </div>

    <div class="alert alert-info d-none" role="alert" data-ps-ref="emailalerts-account-no-alerts">
      <svg class="q-alert__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/></svg>
      <span class="q-alert__body">{l s='You do not have any mail alerts.' d='Modules.Emailalerts.Shop'}</span>
    </div>
  {else}
    <div class="alert alert-info" role="alert" data-ps-ref="emailalerts-account-no-alerts">
      <svg class="q-alert__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/></svg>
      <span class="q-alert__body">{l s='You do not have any mail alerts.' d='Modules.Emailalerts.Shop'}</span>
    </div>
  {/if}
{/block}
