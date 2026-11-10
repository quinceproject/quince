{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='address_form'}
  <div class="js-address-form">
    {include file='_partials/form-errors.tpl' errors=$errors['']}

    {block name='address_form_url'}
    <form
      method="POST"
      action="{url entity='address' params=['id_address' => $id_address]}"
      data-id-address="{$id_address}"
      data-refresh-url="{url entity='address' params=['ajax' => 1, 'action' => 'addressForm', 'id_address' => $id_address]}"
      data-ps-action="form-validation"
    >
    {/block}

      {* Zakup na firmę to decyzja o tym, co klient dostanie: paragon albo
         fakturę VAT. Stoi na górze sekcji jako widoczny wybór, bo schowany
         pod polem wyboru między zgodami ginął.

         PrestaShop nie ma pola na ten wybór: niesie go `quince_buyer`, a przy
         edycji zapisanego adresu ustawia się na „firma", gdy adres ma nazwę
         firmy albo numer VAT. *}
      {block name='quince_buyer_type'}
        {* Konto klienta (strona „Moje adresy") nie pokazuje tego przełącznika:
           zapisany tu adres nie jest ani adresem dostawy, ani faktury z góry —
           o tym decyduje klient dopiero przy składaniu zamówienia. „Kupuję
           jako" ma sens tylko w kasie, gdzie naprawdę coś się kupuje i gdzie
           ten wybór steruje rolami adresów (patrz `CheckoutAddressesStep`
           override). Pola firmowe (NIP, nazwa) zostają na obu stronach —
           usuwamy tylko przełącznik, nie same pola. *}
        {if $page.page_name !== 'address'}
          {assign var=qFirma value=(!empty($formFields.company.value) || !empty($formFields.vat_number.value))}
          <div class="q-checkout2__buyer" data-q-buyer>
            <span class="q-checkout2__label" id="quince-buyer-label">{l s='I am buying as' d='Shop.Theme.Checkout'}</span>
            <div class="q-option q-checkout2__seg" role="radiogroup" aria-labelledby="quince-buyer-label">
              <label class="q-option__item" for="quince-buyer-priv">
                <input class="q-choice__input" type="radio" name="quince_buyer" id="quince-buyer-priv" value="priv"{if !$qFirma} checked{/if}>
                <span class="q-option__name">{l s='Private person' d='Shop.Theme.Checkout'}</span>
              </label>
              <label class="q-option__item" for="quince-buyer-firm">
                <input class="q-choice__input" type="radio" name="quince_buyer" id="quince-buyer-firm" value="firm"{if $qFirma} checked{/if}>
                <span class="q-option__name">{l s='Company' d='Shop.Theme.Checkout'}</span>
              </label>
            </div>
          </div>
        {/if}
      {/block}

      {block name='quince_role_heading'}{/block}

      {block name='address_form_fields'}
        <section class="form-fields">
          {* Pola, które razem tworzą jedną daną, stoją w jednym wierszu:
             imię z nazwiskiem, NIP z nazwą firmy, kod pocztowy z miastem,
             ulica z numerem lokalu. Reszta bierze całą szerokość.

             Parę otwiera pierwsze pole, zamyka drugie. Jeśli sprzedawca wyłączy
             jedno z nich w formacie adresu, drugie zostaje samo i wiersz się
             nie otworzy — dlatego sprawdzamy OBA przed otwarciem. *}
          {block name='form_fields'}
            {assign var=qPary value=[
              'firstname' => 'lastname',
              'vat_number' => 'company',
              'postcode' => 'city',
              'address1' => 'address2'
            ]}
            {assign var=qNazwy value=[]}
            {foreach from=$formFields item="f"}{append var=qNazwy value=$f.name}{/foreach}

            {assign var=qOtwarty value=false}
            {foreach from=$formFields item="field"}
              {assign var=qDrugi value=$qPary[$field.name]|default:''}

              {if $qDrugi && !$qOtwarty && in_array($qDrugi, $qNazwy)}
                <div class="q-checkout2__row q-checkout2__row--{$field.name}">
                {assign var=qOtwarty value=true}
              {/if}

              {block name='form_field'}
                {form_field field=$field}
              {/block}

              {if $qOtwarty && in_array($field.name, $qPary)}
                </div>
                {assign var=qOtwarty value=false}
              {/if}
            {/foreach}
            {if $qOtwarty}</div>{/if}
          {/block}
        </section>
      {/block}

      {block name='form_buttons'}
        <footer class="buttons-wrapper buttons-wrapper--end">
          <input type="hidden" name="submitAddress" value="1">
          <button class="btn btn-primary form-control-submit" type="submit" data-ps-action="form-validation-submit">
            {l s='Save' d='Shop.Theme.Actions'}
          </button>
        </footer>
      {/block}
    </form>
  </div>
{/block}
