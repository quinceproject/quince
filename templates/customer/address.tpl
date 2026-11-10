{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends 'customer/page.tpl'}

{* Własny nagłówek zamiast domyślnego `page-title-section.tpl` — ten sam
   powód co w pozostałych podstronach konta: makieta stawia link powrotu
   NAD tytułem. Ta strona nie ma własnej makiety (formularz adresu), więc
   nagłówek i karta biorą dokładnie ten sam układ, co reszta konta. *}
{block name='page_header_container'}
  <div class="q-order-header">
    <a class="q-order-back" href="{$urls.pages.addresses}">
      <svg class="q-order-back__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 13 6 8l5-5"/></svg>
      {l s='Your addresses' d='Shop.Theme.Customeraccount'}
    </a>
    <h1 class="q-order-header__title" tabindex="-1">
      {if $editing}
        {l s='Update your address' d='Shop.Theme.Customeraccount'}
      {else}
        {l s='New address' d='Shop.Theme.Customeraccount'}
      {/if}
    </h1>
  </div>
{/block}

{block name='page_content'}
  <div class="address-form q-account-section q-card q-card__body">
    {render template='customer/_partials/address-form.tpl' ui=$address_form}
  </div>
{/block}
