{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file='customer/page.tpl'}

{* Aplikacja Vue modułu rysuje całą treść sama (w tym własny `<h1>`) wprost
   w `.wishlist-container`. Nasz nagłówek daje tylko link powrotu, tak jak
   na pozostałych podstronach konta, bez duplikowania tytułu. *}
{block name='page_header_container'}
  <div class="q-order-header">
    <a class="q-order-back" href="{$urls.pages.my_account}">
      <svg class="q-order-back__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 13 6 8l5-5"/></svg>
      {l s='Back to your account' d='Shop.Theme.Customeraccount'}
    </a>
  </div>
{/block}

{block name='page_content_container'}
  <div
    class="wishlist-container"
    data-url="{$url}"
    data-title="{$wishlistsTitlePage}"
    data-empty-text="{l s='No wishlist found.' d='Modules.Blockwishlist.Shop'}"
    data-rename-text="{l s='Rename' d='Modules.Blockwishlist.Shop'}"
    data-share-text="{l s='Share' d='Modules.Blockwishlist.Shop'}"
    data-add-text="{$newWishlistCTA}"
  ></div>

  {* Rdzeń dołącza tylko modal udostępniania i zmiany nazwy; modali tworzenia
     i usuwania listy `lists.tpl` modułu nie dołącza, choć JS modułu na nie
     czeka. Jeden adres bazowy dla wszystkich czterech: nasz JS sam dokłada
     właściwy parametr `action` przy każdym wywołaniu, więc
     `$renameUrl`/`$shareUrl` nie są potrzebne. *}
  {include file="module:blockwishlist/views/templates/components/modals/create.tpl" url=$url}
  {include file="module:blockwishlist/views/templates/components/modals/rename.tpl" url=$url}
  {include file="module:blockwishlist/views/templates/components/modals/share.tpl" url=$url}
  {include file="module:blockwishlist/views/templates/components/modals/delete.tpl" url=$url}
{/block}

{* Stopka modułu dubluje link powrotu do konta (ten sam cel co
   `.q-order-back` w nagłówku) i link do strony głównej (dostępny w logo
   nagłówka), więc blok zostaje pusty. *}
{block name='page_footer_container'}{/block}
