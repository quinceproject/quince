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
    <h1 class="q-order-header__title" tabindex="-1">{l s='Merchandise returns' d='Shop.Theme.Customeraccount'}</h1>
    <p class="visually-hidden">{l s='Here is a list of pending merchandise returns.' d='Shop.Theme.Customeraccount'}</p>
  </div>
{/block}

{block name='page_content'}
  {if $ordersReturn && count($ordersReturn)}
    <div class="q-account-section q-card">
    <div class="grid-table" role="table" aria-label="{l s='Merchandise returns' d='Shop.Theme.Customeraccount'}">
      <div class="grid-table__inner grid-table__inner--5" role="rowgroup">
        <div class="grid-table__header" role="row">
          <span class="grid-table__cell" role="columnheader">{l s='Order' d='Shop.Theme.Customeraccount'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Return' d='Shop.Theme.Customeraccount'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Package status' d='Shop.Theme.Customeraccount'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Date issued' d='Shop.Theme.Customeraccount'}</span>
          <span class="grid-table__cell" role="columnheader">{l s='Returns details' d='Shop.Theme.Customeraccount'}</span>
        </div>

        {foreach from=$ordersReturn item=return}
          <div class="grid-table__row" role="row">
            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Order' d='Shop.Theme.Customeraccount'}">
              <a href="{$return.details_url}">
                <span class="visually-hidden">{l s='View order reference' d='Shop.Theme.Customeraccount'} </span>
                {$return.reference}
              </a>
            </span>
            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Return' d='Shop.Theme.Customeraccount'}">
              <a href="{$return.return_url}">
                <span class="visually-hidden">{l s='View return number' d='Shop.Theme.Customeraccount'} </span>
                {$return.return_number}
              </a>
            </span>
            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Package status' d='Shop.Theme.Customeraccount'}">
              {$return.state_name}
            </span>
            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Date issued' d='Shop.Theme.Customeraccount'}">
              <small class="text-secondary">
                {$return.return_date}
              </small>
            </span>
            <span class="grid-table__cell" role="cell" data-ps-label="{l s='Returns details' d='Shop.Theme.Customeraccount'}">
              {if $return.print_url}
                <a href="{$return.print_url}" aria-label="{l s='View returns details' d='Shop.Theme.Customeraccount'}">
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M14 4.5V11h-1V4.5h-2A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v9H2V2a2 2 0 0 1 2-2h5.5zm-3-3.5v2a.5.5 0 0 0 .5.5h2z"/><path d="M4.603 14.087a.81.81 0 0 1-.438-.42c-.195-.388-.13-.776.08-1.102.198-.307.526-.568.897-.787a7.7 7.7 0 0 1 1.482-.645 20 20 0 0 0 1.062-2.227 7.3 7.3 0 0 1-.43-1.295c-.086-.4-.119-.796-.046-1.136.075-.354.274-.672.65-.823.192-.077.4-.11.602-.077a.7.7 0 0 1 .477.365c.088.164.12.356.127.538.007.187-.012.395-.047.614-.084.51-.27 1.134-.52 1.794a11 11 0 0 0 .98 1.686 5.8 5.8 0 0 1 1.334.05c.364.066.734.195.96.465.12.144.193.32.2.518.007.192-.047.382-.138.563a1.04 1.04 0 0 1-.354.416.86.86 0 0 1-.51.138c-.331-.014-.654-.196-.933-.417a5.7 5.7 0 0 1-.911-.95 11.6 11.6 0 0 0-1.997.406 11.3 11.3 0 0 1-1.021 1.51c-.37.470-.78.858-1.218 1.056a1.13 1.13 0 0 1-.783.07zm1.379-1.901q-.25.115-.459.238c-.328.194-.541.383-.647.547-.094.145-.096.25-.04.361a.04.04 0 0 0 .01.016l.004.001q.01.004.026-.002c.079-.034.08-.034.08-.034.274-.098.634-.422 1.026-.925zm1.293-1.072c.265-.078.535-.147.804-.207a7.6 7.6 0 0 1-.497-.805 9 9 0 0 1-.307 1.012m1.629-1.605q-.078-.146-.158-.302c-.159.36-.318.715-.471 1.056q.306-.148.629-.754m-.619-2.252c.03.135.064.274.108.418l.047-.164c.028-.165.024-.280.003-.37a.3.3 0 0 0-.02-.056.4.4 0 0 0-.038.017c-.013.023-.032.063-.044.113-.016.067-.019.146-.002.252z"/></svg>
                </a>
              {else}
                --
              {/if}
            </span>
          </div>
        {/foreach}
      </div>
    </div>
    </div>
  {else}
    <div class="alert alert-info" role="alert" tabindex="0">
      <svg class="q-alert__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/></svg>
      <span class="q-alert__body">{l s='You have no merchandise return authorizations.' d='Shop.Notifications.Error'}</span>
    </div>
  {/if}
{/block}
