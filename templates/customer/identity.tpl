{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends 'customer/page.tpl'}

{* Własny nagłówek zamiast domyślnego `page-title-section.tpl` — ten sam
   powód co w pozostałych podstronach konta: makieta stawia link powrotu
   NAD tytułem. *}
{block name='page_header_container'}
  <div class="q-order-header">
    <a class="q-order-back" href="{$urls.pages.my_account}">
      <svg class="q-order-back__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 13 6 8l5-5"/></svg>
      {l s='Back to your account' d='Shop.Theme.Customeraccount'}
    </a>
    <h1 class="q-order-header__title" tabindex="-1">{l s='Your personal information' d='Shop.Theme.Customeraccount'}</h1>
    <p class="visually-hidden">{l s='Update your personal information to keep your account details up to date.' d='Shop.Theme.Customeraccount'}</p>
  </div>
{/block}

{block name='page_content'}
  <div class="q-account-stack">
    {render file='customer/_partials/customer-form.tpl' ui=$customer_form}
  </div>
{/block}
