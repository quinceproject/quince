{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * Quince: strona CMS.
 *
 * Jak na kategorii CMS: goły `page.tpl` nie daje okruszkom odstępu. Treść
 * z edytora dostaje `q-prose`, bo arkusz motywu nie zna klasy `rich-text`
 * i bez tego nagłówki z edytora mają goły styl przeglądarki.
 *}
{extends file='page.tpl'}

{block name='breadcrumb'}
  <div class="q-container q-cms-crumbs">
    {include file='_partials/breadcrumb.tpl'}
  </div>
{/block}

{block name='page_header_container'}
  <h1 class="q-listing__title">{$cms.meta_title}</h1>
{/block}

{block name='page_content_container'}
  <section id="content" class="q-prose q-cms-content js-page-content-cms">
    {block name='cms_content'}
      {$cms.content nofilter}
    {/block}

    {block name='hook_cms_dispute_information'}
      {hook h='displayCMSDisputeInformation'}
    {/block}

    {block name='hook_cms_print_button'}
      {hook h='displayCMSPrintButton'}
    {/block}
  </section>
{/block}
