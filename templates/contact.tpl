{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file='page.tpl'}

{* Ten sam problem i to samo lekarstwo co na stronach CMS: goły `page.tpl`
   nie daje okruszkom odstępu. *}
{block name='breadcrumb'}
  <div class="q-container q-cms-crumbs">
    {include file='_partials/breadcrumb.tpl'}
  </div>
{/block}

{block name='page_header_container'}{/block}

{if $layout === 'layouts/layout-left-column.tpl'}
  {block name='left_column'}
    <div id="left-column" class="wrapper__left-column">
      {hook h='displayContactLeftColumn'}
    </div>
  {/block}
{elseif $layout === 'layouts/layout-right-column.tpl'}
  {block name='right_column'}
    <div id="right-column" class="wrapper__right-column">
      {hook h='displayContactRightColumn'}
    </div>
  {/block}
{/if}

{block name='page_content'}
  {hook h='displayContactContent'}
{/block}
