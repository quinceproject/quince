{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * Quince — strona CMS.
 *
 * Ten sam problem i to samo lekarstwo co na kategorii CMS: goły `page.tpl`
 * nie daje okruszkom odstępu, a treść z edytora reagowała na `rich-text`,
 * którego nasz arkusz w ogóle nie zna — nagłówki z edytora wychodziły
 * gołym stylem przeglądarki, bez normalizacji rozmiaru i bez odstępu od
 * tytułu strony.
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
