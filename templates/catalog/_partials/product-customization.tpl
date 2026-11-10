{**
 * Quince — personalizacja produktu w panelu zakupu.
 *
 * Jedyny blok panelu z własnym tłem, i to jest decyzja: to formularz do
 * wypełnienia, a nie informacja do przeczytania, a PrestaShop bez niego nie
 * pozwoli dodać produktu do koszyka. Tło mówi „tu masz coś zrobić".
 *
 * Wgrywanie pliku na etykiecie, nie na gołym `input type=file`: przeglądarka
 * rysuje własny przycisk z własnym napisem, którego nie da się ostylować ani
 * przetłumaczyć.
 *
 * Klasa `js-product-customization` zostaje: po niej rdzeń podmienia blok po
 * zmianie wariantu.
 *
 * Zachowanie pola pliku: assets/js/islands/buybox.js
 *}

{if !$configuration.is_catalog}
  <section class="q-personalizacja js-product-customization">
    <div class="q-personalizacja__title">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/><path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5z"/></svg>
      {l s='Product customization' d='Shop.Theme.Catalog'}
    </div>

    <form method="post" action="{$product.url}" enctype="multipart/form-data">
      {foreach from=$customizations.fields item=qPole name=qPola}
        <div class="q-field-group{if !$smarty.foreach.qPola.first} q-personalizacja__next{/if}">
          <label class="q-field-label" for="field-{$qPole.id_customization_field}">
            {$qPole.label}
            {if $qPole.required}<span class="q-field-label__required">*</span>{/if}
          </label>

          {if $qPole.type === 'text'}
            <textarea class="q-field"
                      id="field-{$qPole.id_customization_field}"
                      name="{$qPole.input_name}"
                      maxlength="250"
                      placeholder="{l s='Your message here' d='Shop.Forms.Help'}"
                      {if $qPole.required} required{/if}></textarea>

            <span class="q-field-help">
              {l s='250 char. max' d='Shop.Forms.Help'}
              {if !$qPole.required} · {l s='Optional' d='Shop.Forms.Help'}{/if}
            </span>

            {if $qPole.text !== ''}
              <p class="q-personalizacja__saved">
                <b>{l s='Your customization:' d='Shop.Theme.Catalog'}</b> {$qPole.text}
              </p>
            {/if}

          {elseif $qPole.type === 'image'}
            <span class="q-field-help">
              {l s='.png .jpg .gif' d='Shop.Forms.Help'}
              {if !$qPole.required} · {l s='Optional' d='Shop.Forms.Help'}{/if}
            </span>

            <label class="q-upload" for="field-{$qPole.id_customization_field}" data-q-upload>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5"/><path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708z"/></svg>

              <span data-q-upload-name>{l s='Choose a file' d='Shop.Theme.Actions'}</span>

              <input type="file"
                     id="field-{$qPole.id_customization_field}"
                     name="{$qPole.input_name}"
                     hidden
                     {if $qPole.required} required{/if}>
            </label>

            {if $qPole.is_customized}
              <div class="q-personalizacja__image">
                <img src="{$qPole.image.small.url}" alt="" loading="lazy">

                <a href="{$qPole.remove_image_url}" rel="nofollow" role="button">
                  {l s='Remove image' d='Shop.Theme.Actions'}
                </a>
              </div>
            {/if}
          {/if}
        </div>
      {/foreach}

      <div class="q-personalizacja__save">
        <button class="q-btn q-btn--secondary q-btn--sm" type="submit" name="submitCustomizedData">
          <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M12.736 3.97a.733.733 0 0 1 1.047 0c.286.289.29.756.01 1.05L7.88 12.01a.733.733 0 0 1-1.065.02L3.217 8.384a.757.757 0 0 1 0-1.06.733.733 0 0 1 1.047 0l3.052 3.093 5.4-6.425z"/></svg>
          <span class="q-btn__label">{l s='Save customization' d='Shop.Theme.Actions'}</span>
        </button>
      </div>
    </form>
  </section>
{/if}
