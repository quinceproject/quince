{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{**
 * Quince: treść strony „nie znaleziono” (404 i 410).
 *
 * Makieta: prototyp strony 404. Ikony z zestawu silnika
 * (`modules/quince_engine/views/icons/house.svg`, `headset.svg`). Pole
 * szukania to ten sam partial co w nagłówku (`_partials/search-form.tpl`).
 *}
<section id="content" class="page-content page-content--not-found q-listing__empty">
  {block name='page_content'}
    {block name='error_content'}
      {if isset($errorContent)}
        {$errorContent nofilter}
      {else}
        <h1 class="q-listing__empty-title">{l s='The page you are looking for is no longer available' d='Shop.Theme.Catalog'}</h1>
        <p class="q-listing__empty-text">{l s='It can not be reached anymore. Can we still attract you into our shop?' d='Shop.Theme.Catalog'}</p>
      {/if}
    {/block}

    <div class="q-cms-notfound-actions">
      <a href="{$urls.pages.index}" class="q-btn q-btn--primary">
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5z"/></svg>
        {l s='Back to Home page' d='Shop.Theme.Catalog'}
      </a>

      <a href="{$urls.pages.contact}" class="q-btn q-btn--secondary">
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 1a5 5 0 0 0-5 5v1h1a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V6a6 6 0 1 1 12 0v6a2.5 2.5 0 0 1-2.5 2.5H9.366a1 1 0 0 1-.866.5h-1a1 1 0 1 1 0-2h1a1 1 0 0 1 .866.5H11.5A1.5 1.5 0 0 0 13 12h-1a1 1 0 0 1-1-1V8a1 1 0 0 1 1-1h1V6a5 5 0 0 0-5-5"/></svg>
        {l s='Contact us' d='Shop.Theme.Global'}
      </a>
    </div>

    <div class="q-cms-notfound-search">
      {include file='_partials/search-form.tpl' qFormClass='q-listing__empty-form' qFormId='notfound'}
    </div>

    {block name='hook_not_found'}
      {hook h='displayNotFound'}
    {/block}
  {/block}
</section>
