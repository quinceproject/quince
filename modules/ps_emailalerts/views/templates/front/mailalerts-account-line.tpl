{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
<li class="ps-emailalerts__product" data-ps-ref="emailalerts-product"> 
  <a href="{$mailAlert.link}" class="ps-emailalerts__product-image-link" rel="nofollow">
    <img class="ps-emailalerts__product-image img-fluid" src="{$mailAlert.cover_url}" alt="{$mailAlert.name}" loading="lazy">
  </a>

  <div class="ps-emailalerts__product-content">
    <a href="{$mailAlert.link}">
      <span class="ps-emailalerts__product-name">{$mailAlert.name}</span>
    </a>

    {if $mailAlert.attributes_small}
      <span class="ps-emailalerts__product-attributes">
        {l s='Attributes: %attributes%' sprintf=['%attributes%' => $mailAlert.attributes_small] d='Modules.Emailalerts.Shop'}
      </span>
    {/if}

    {capture name='deleteData'}{strip}{ldelim}
      "id_product": "{$mailAlert.id_product|intval}",
      "id_product_attribute": "{$mailAlert.id_product_attribute|intval}",
      "url": "{url entity='module' name='ps_emailalerts' controller='actions' params=['process' => 'remove']}"
    {rdelim}{/strip}{/capture}

    <button type="button"
      aria-label="{l s='Delete %productName% mail alert' sprintf=['%productName%' => $mailAlert.name] d='Modules.Emailalerts.Shop'}"
      class="link-danger ps-emailalerts__product-delete"
      data-ps-action="emailalerts-delete"
      data-ps-data="{$smarty.capture.deleteData}"
    >
      <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/><path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"/></svg>
      {l s='Delete' d='Modules.Emailalerts.Shop'}
    </button>
  </div>
</li>
