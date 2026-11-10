{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends 'customer/page.tpl'}

{* Własny nagłówek zamiast domyślnego `page-title-section.tpl` — ten sam
   powód co w `history.tpl`/`order-detail.tpl`: makieta stawia link powrotu
   NAD tytułem. *}
{block name='page_header_container'}
  <div class="q-order-header">
    <a class="q-order-back" href="{$urls.pages.my_account}">
      <svg class="q-order-back__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 13 6 8l5-5"/></svg>
      {l s='Back to your account' d='Shop.Theme.Customeraccount'}
    </a>
    <h1 class="q-order-header__title" tabindex="-1">{l s='Your addresses' d='Shop.Theme.Customeraccount'}</h1>
    <p class="visually-hidden">{l s='Manage your addresses for billing and delivery to streamline your future orders.' d='Shop.Theme.Customeraccount'}</p>
  </div>
{/block}

{block name='page_content'}
  <div class="addresses">
    <div class="addresses__list">
      {foreach $customer.addresses as $address}
        {block name='customer_address'}
          {include file='customer/_partials/block-address.tpl' address=$address}
        {/block}
      {/foreach}

      <a
        class="address-card address-card--add-address q-card"
        href="{$urls.pages.address}"
        data-link-action="add-address"
        role="button"
      >
        <svg class="address-card__add-icon" width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2"/></svg>
        <span class="address-card__add-text">{l s='Add new address' d='Shop.Theme.Actions'}</span>
      </a>
    </div>
  </div>
{/block}
