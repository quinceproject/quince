{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{extends file=$layout}

{* Układ obu kolumn (`layout-both-columns.tpl`) rysuje okruszki bez
   `.q-container` (treść pod spodem ma go przez `#center-column`). Na pełnej
   szerokości strony bez tego opakowania okruszki stoją przy lewej krawędzi
   okna, nie nad sidebarem.

   Odstęp od paska menu: to samo rozwiązanie co na potwierdzeniu zamówienia (`.order-confirmation__crumbs`): goły layout
   nie daje okruszkom żadnego górnego marginesu, bo na innych stronach
   dostają go przez wspólny kontener z resztą treści, a tu stoją osobno. *}
{block name='breadcrumb'}
  <div class="q-container q-account__crumbs">
    {include file='_partials/breadcrumb.tpl'}
  </div>
{/block}

{block name='content'}
  <div class="q-account{if !($customer.is_logged && !$customer.is_guest)} q-account--no-nav{/if}">
    {**
     * Used for the account menu in the guest tracking page, the account don't have to be shown
     *}
    {if $customer.is_logged && !$customer.is_guest}
      <div class="q-account__nav">
        {include file='components/account-menu.tpl'}
      </div>
    {/if}

    <div class="q-account__content">
      {block name='page_header_container'}
        {block name='page_title'}
          <div class="page-header">
            {include file='components/page-title-section.tpl' title={$smarty.block.child}}
          </div>
        {/block}

        {block name='account_link'}
          <a class="btn btn-outline-tertiary account-menu__back" href="{$urls.pages.my_account}">
            <i class="material-icons" aria-hidden="true">&#xE5C4;</i>
            {l s='Back to your account' d='Shop.Theme.Customeraccount'}
          </a>
        {/block}
      {/block}

      {block name='page_content_container'}
        <section id="content" class="page-content page-content--customer">
          {block name='page_content_top'}{/block}

          {block name='page_content'}{/block}
        </section>
      {/block}

      {block name='page_footer_container'}
          {block name='page_footer'}
            {block name='my_account_links'}
            {/block}
          {/block}
      {/block}
    </div>
  </div>
{/block}
