{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

<a
  class="account-menu__link account-menu__link--emailalerts{if $urls.current_url === $link->getModuleLink(ps_emailalerts, 'account')} account-menu__link--active{/if}"
  href="{$link->getModuleLink(ps_emailalerts, 'account')}"
  {if $urls.current_url === $link->getModuleLink(ps_emailalerts, 'account')}aria-current="page"{/if}
>
  <svg class="account-menu__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2M8 1.918l-.797.161A4 4 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4 4 0 0 0-3.203-3.92zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5 5 0 0 1 13 6c0 .88.32 4.2 1.22 6"/></svg>
  <span class="account-menu__text">
    {l s='My alerts' d='Shop.Theme.Catalog'}
    <small class="account-menu__desc">{l s='Product availability notifications' d='Shop.Theme.Customeraccount'}</small>
  </span>
</a>
