{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
<section class="contact-form q-account-section q-card q-card__body">
  <form class="form-validation" action="{$urls.pages.contact}" method="post" {if $contact.allow_file_upload}enctype="multipart/form-data"{/if}  data-ps-action="form-validation">

    {* Zapis o ochronie formularza stoi przy przycisku wysyłki, niżej. *}
    {include file='_partials/form-guard.tpl' form_id='contact' notice=false}

    {if $notifications}
      <div class="alert {if $notifications.nw_error}alert-danger{else}alert-success{/if}" role="alert" tabindex="0">
        <ul class="mb-0">
          {foreach $notifications.messages as $notif}
            <li>{$notif}</li>
          {/foreach}
        </ul>
      </div>
    {/if}

    {if !$notifications || $notifications.nw_error}
      <section class="form-fields">
        <h2 class="q-section-title">{l s='Contact us' d='Shop.Theme.Global'}</h2>

        {if $contact.contacts|count === 1}
          {assign var=firstContact value=current($contact.contacts)}
          <input type="hidden" name="id_contact" value="{$firstContact.id_contact|escape:'htmlall':'UTF-8'}"/>
        {else}
          <div class="q-float q-float--stale">
            <label class="form-label" for="contact-us-subject-select">
              {l s='Subject' d='Shop.Forms.Labels'}
            </label>
            <select id="contact-us-subject-select" name="id_contact" class="form-select">
              {foreach from=$contact.contacts item=contact_elt}
                <option value="{$contact_elt.id_contact|escape:'htmlall':'UTF-8'}">{$contact_elt.name|escape:'htmlall':'UTF-8'}</option>
              {/foreach}
            </select>
          </div>
        {/if}

        <div class="q-float">
          <label class="form-label required" for="contact-us-email-input">
            {l s='Email address' d='Shop.Forms.Labels'}
          </label>
          <input
            id="contact-us-email-input"
            class="form-control"
            name="from"
            type="email"
            value="{$contact.email}"
            placeholder=" "
            autocomplete="email"
            required
          >
        </div>

        {if $contact.orders}
          <div class="q-float q-float--stale">
            <label class="form-label" for="contact-us-id-order-select">
              {l s='Order reference' d='Shop.Forms.Labels'}
            </label>
            <select id="contact-us-id-order-select" name="id_order" class="form-select">
              <option value="">{l s='Select reference' d='Shop.Forms.Help'}</option>
              {foreach from=$contact.orders item=order}
                <option value="{$order.id_order}">{$order.reference}</option>
              {/foreach}
            </select>
            <span class="form-text">{l s='optional' d='Shop.Forms.Help'}</span>
          </div>
        {/if}

        {if $contact.allow_file_upload}
          <div class="mb-3">
            <label class="form-label" for="contact-us-attachment-input">
              {l s='Attachment' d='Shop.Forms.Labels'}
            </label>

            <label class="q-upload" for="contact-us-attachment-input" data-q-upload>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5"/><path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708z"/></svg>
              <span data-q-upload-name>{l s='Choose a file' d='Shop.Theme.Actions'}</span>
              <input
                id="contact-us-attachment-input"
                type="file"
                name="fileUpload"
                hidden
              >
            </label>

            <span class="form-text">{l s='optional' d='Shop.Forms.Help'}</span>
          </div>
        {/if}

        <div class="q-float q-float--multiline">
          <label class="form-label required" for="contact-us-message-textarea">
            {l s='Message' d='Shop.Forms.Labels'}
          </label>
          <textarea
            id="contact-us-message-textarea"
            class="form-control"
            name="message"
            placeholder=" "
            required
            rows="5"
          >{if $contact.message}{$contact.message}{/if}</textarea>
        </div>

        {if isset($id_module)}
          <div class="mb-3">
            {hook h='displayGDPRConsent' id_module=$id_module}
          </div>
        {/if}

      </section>

      {hook h='displayQuinceFormNotice' form_id='contact'}

      <footer class="buttons-wrapper buttons-wrapper--end">
        <input type="hidden" name="url" value="" />
        <input type="hidden" name="token" value="{$token}" />
        <button
          class="btn btn-primary"
          type="submit"
          name="submitMessage"
          data-ps-action="form-validation-submit"
        >
          {l s='Send your message' d='Shop.Theme.Actions'}
        </button>
      </footer>
    {/if}

  </form>
</section>
