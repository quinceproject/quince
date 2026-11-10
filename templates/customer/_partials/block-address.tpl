{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{$componentName = 'address-card'}

{block name='address_block_item'}
  <article id="address-{$address.id}" class="{$componentName} q-card" data-id-address="{$address.id}">
    <div class="{$componentName}__container">
      <div class="{$componentName}__header">
        <span class="{$componentName}__alias">{$address.alias}</span>
      </div>

      <address class="{$componentName}__content">{$address.formatted nofilter}</address>

      {capture name='displayAdditionalCustomerAddressFields'}{hook h='displayAdditionalCustomerAddressFields' address=$address}{/capture}
      {if $smarty.capture.displayAdditionalCustomerAddressFields}
        <div class="{$componentName}__extra">
          {$smarty.capture.displayAdditionalCustomerAddressFields}
        </div>
      {/if}

      {block name='address_block_item_actions'}
        <div class="{$componentName}__actions">
          <a
            class="{$componentName}__edit link-body-emphasis"
            href="{url entity=address id=$address.id}"
            data-link-action="edit-address"
            aria-label="{l s='Edit address: %addressAlias%' sprintf=['%addressAlias%' => $address.alias|lower] d='Shop.Theme.Actions'}"
            role="button"
          >
            <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325"/></svg>
            {l s='Edit' d='Shop.Theme.Actions'}
          </a>

          <a
            class="{$componentName}__delete link-danger"
            href="{url entity=address id=$address.id params=['delete' => 1, 'token' => $token]}"
            data-link-action="delete-address"
            aria-label="{l s='Delete address: %addressAlias%' sprintf=['%addressAlias%' => $address.alias|lower] d='Shop.Theme.Actions'}"
            role="button"
          >
            <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/><path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"/></svg>
            {l s='Delete' d='Shop.Theme.Actions'}
          </a>
        </div>
      {/block}
    </div>
  </article>
{/block}
