{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * Quince: mapa strony.
 *
 * Jak na kategorii i stronie CMS: goły
 * `page.tpl` nie daje okruszkom odstępu od paska nawigacji.
 *}
{extends file='page.tpl'}

{block name='breadcrumb'}
  <div class="q-container q-cms-crumbs">
    {include file='_partials/breadcrumb.tpl'}
  </div>
{/block}

{block name='page_header_container'}
  <h1 class="q-listing__title">{l s='Sitemap' d='Shop.Theme.Global'}</h1>
{/block}

{block name='page_content'}
  <div class="q-sitemap">
    {foreach $sitemapUrls as $group}
      <div class="q-sitemap__group">
        <h2 class="q-sitemap__title">{$group.name}</h2>
        {include file='cms/_partials/sitemap-nested-list.tpl' links=$group.links}
      </div>
    {/foreach}
  </div>
{/block}
