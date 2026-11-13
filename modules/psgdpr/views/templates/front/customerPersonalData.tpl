{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
 {extends file='customer/page.tpl'}

 {* Własny nagłówek, ten sam wzorzec co w pozostałych podstronach konta. *}
 {block name='page_header_container'}
   <div class="q-order-header">
     <a class="q-order-back" href="{$urls.pages.my_account}">
       <svg class="q-order-back__icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M11 13 6 8l5-5"/></svg>
       {l s='Back to your account' d='Shop.Theme.Customeraccount'}
     </a>
     <h1 class="q-order-header__title" tabindex="-1">{l s='GDPR - Personal data' d='ModulesPsgdprCustomeraccount'}</h1>
   </div>
 {/block}

 {block name='page_content'}
  <div class="q-account-stack">
    <div class="q-identity-group">
      <h2 class="q-identity-heading">{l s='Access to my data' mod='psgdpr'}</h2>
      <section class="q-account-section q-card">
        <div class="q-identity-fields q-card__body">
          <p>{l s='At any time, you have the right to retrieve the data you have provided to our site. Click on "Get my data" to automatically download a copy of your personal data on a pdf or csv file.' mod='psgdpr'}</p>
          <div class="q-gdpr-actions">
            <a id="exportDataToCsv" class="btn btn-outline-primary btn-sm" target="_blank" href="{$psgdpr_csv_controller|escape:'htmlall':'UTF-8'}">
              <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5"/><path fill-rule="evenodd" d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708z"/></svg>
              {l s='Get my data to CSV' mod='psgdpr'}
            </a>
            <a id="exportDataToPdf" class="btn btn-outline-primary btn-sm" target="_blank" href="{$psgdpr_pdf_controller|escape:'htmlall':'UTF-8'}">
              <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5"/><path fill-rule="evenodd" d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708z"/></svg>
              {l s='Get my data to PDF' mod='psgdpr'}
            </a>
          </div>
        </div>
      </section>
    </div>

    <div class="q-identity-group">
      <h2 class="q-identity-heading">{l s='Rectification & Erasure requests' mod='psgdpr'}</h2>
      <section class="q-account-section q-card">
        <div class="q-identity-fields q-card__body">
          <p>
            {l s='You have the right to modify all the personal information found in the "My Account" page. For any other request you might have regarding the rectification and/or erasure of your personal data, please contact us through our' mod='psgdpr'}
            <a href="{$psgdpr_contactUrl|escape:'htmlall':'UTF-8'}">{l s='contact page' mod='psgdpr'}</a>.
            {l s='We will review your request and reply as soon as possible.' mod='psgdpr'}
          </p>
        </div>
      </section>
    </div>
  </div>

 {literal}
 <script type="text/javascript">
     var psgdpr_front_controller = "{/literal}{$psgdpr_front_controller|escape:'htmlall':'UTF-8'}{literal}";
     var psgdpr_id_customer = "{/literal}{$psgdpr_front_controller|escape:'htmlall':'UTF-8'}{literal}";
     var psgdpr_ps_version = "{/literal}{$psgdpr_ps_version|escape:'htmlall':'UTF-8'}{literal}";
 </script>
 {/literal}
 {/block}
