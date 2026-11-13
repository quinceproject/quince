{extends file='customer/_partials/address-form.tpl'}

{block name='form_field'}
  {if $field.name eq "alias" and $customer.is_guest}
    {* we don't ask for alias here if customer is not registered *}
  {elseif $type === "delivery" && ($field.name eq "firstname" or $field.name eq "lastname")}
    {* Imię i nazwisko już mamy z kroku 1. Rdzeń dopisuje je sam przy
       zapisie (`CheckoutAddressesStep::handleRequest`), więc tu ich nie
       pytamy ponownie. *}
  {else}
    {$smarty.block.parent}
  {/if}
{/block}

{block name="address_form_url"}
    <form
      method="POST"
      action="{url entity='order' params=['id_address' => $id_address]}"
      data-id-address="{$id_address}"
      data-refresh-url="{url entity='order' params=['ajax' => 1, 'action' => 'addressForm']}"
    >
{/block}

{* Nagłówek nad polami: „Adres dostawy" dla osoby prywatnej, „Dane firmy
   (do faktury)" dla firmy. Ten sam formularz renderuje się rdzeniowi
   zawsze jako „delivery", więc tylko ten nagłówek (i rola po zapisie,
   patrz override `CheckoutAddressesStep`) mówi, czym naprawdę jest.
   Klasa `q-checkout2__h3`, nie `h3`: ta druga to duży tytuł strony. *}
{block name='quince_role_heading'}
  {if $type === "delivery"}
    <h3
      class="q-checkout2__h3"
      data-q-role-heading
      data-text-priv="{l s='Shipping Address' d='Shop.Theme.Checkout'}"
      data-text-firm="{l s='Company details (for invoice)' d='Shop.Theme.Checkout'}"
    >{if $qFirma}{l s='Company details (for invoice)' d='Shop.Theme.Checkout'}{else}{l s='Shipping Address' d='Shop.Theme.Checkout'}{/if}</h3>
  {/if}
{/block}

{block name='form_fields' append}
  <input type="hidden" name="saveAddress" value="{$type}">
  {if $type === "delivery"}
    {* Rdzeniowi mówimy zawsze „ten sam adres dla obu ról": niech zapisze
       i przejdzie dalej normalnie. Role nadpisuje override kroku, po fakcie,
       na podstawie `quince_buyer` i `quince_other` poniżej. *}
    <input type="hidden" name="use_same_address" value="1">

    <label class="q-choice" for="quince_other">
      <input class="q-choice__input" name="quince_other" id="quince_other" type="checkbox" value="1" data-q-other-toggle>
      <span
        class="q-choice__label"
        data-q-other-label
        data-text-priv="{l s='Invoice with different details' d='Shop.Theme.Checkout'}"
        data-text-firm="{l s='Deliver to a different address' d='Shop.Theme.Checkout'}"
      >{if $qFirma}{l s='Deliver to a different address' d='Shop.Theme.Checkout'}{else}{l s='Invoice with different details' d='Shop.Theme.Checkout'}{/if}</span>
    </label>

    <div class="q-checkout2__sub-box" data-q-other-panel hidden>
      <h3
        class="q-checkout2__h3"
        data-q-other-heading
        data-text-priv="{l s='Invoice details' d='Shop.Theme.Checkout'}"
        data-text-firm="{l s='Shipping Address' d='Shop.Theme.Checkout'}"
      >{if $qFirma}{l s='Shipping Address' d='Shop.Theme.Checkout'}{else}{l s='Invoice details' d='Shop.Theme.Checkout'}{/if}</h3>

      <div class="mb-3 q-float q-float--stale">
        <label class="form-label" for="field-other_id_country">{l s='Country' d='Shop.Forms.Labels'}</label>
        <select class="form-select" name="other_id_country" id="field-other_id_country">
          <option value disabled selected>{l s='-- please choose --' d='Shop.Forms.Labels'}</option>
          {foreach from=$formFields.id_country.availableValues|default:[] item="etykieta" key="wartosc"}
            <option value="{$wartosc}"{if $wartosc eq $formFields.id_country.value} selected{/if}>{$etykieta}</option>
          {/foreach}
        </select>
      </div>

      <div class="q-checkout2__row q-checkout2__row--2">
        <div class="mb-3 q-float">
          <label class="form-label" for="field-other_firstname">{l s='First name' d='Shop.Forms.Labels'}</label>
          <input class="form-control" type="text" name="other_firstname" id="field-other_firstname" placeholder=" " required>
        </div>
        <div class="mb-3 q-float">
          <label class="form-label" for="field-other_lastname">{l s='Last name' d='Shop.Forms.Labels'}</label>
          <input class="form-control" type="text" name="other_lastname" id="field-other_lastname" placeholder=" " required>
        </div>
      </div>

      <div class="q-checkout2__row q-checkout2__row--2">
        <div class="mb-3 q-float">
          <label class="form-label" for="field-other_address1">{l s='Address' d='Shop.Forms.Labels'}</label>
          <input class="form-control" type="text" name="other_address1" id="field-other_address1" placeholder=" " required>
        </div>
        <div class="mb-3 q-float">
          <label class="form-label" for="field-other_address2">{l s='Address Complement' d='Shop.Forms.Labels'}</label>
          <input class="form-control" type="text" name="other_address2" id="field-other_address2" placeholder=" ">
        </div>
      </div>

      <div class="q-checkout2__row q-checkout2__row--2">
        <div class="mb-3 q-float">
          <label class="form-label" for="field-other_postcode">{l s='Zip/Postal Code' d='Shop.Forms.Labels'}</label>
          <input class="form-control" type="text" name="other_postcode" id="field-other_postcode" placeholder=" " required>
        </div>
        <div class="mb-3 q-float">
          <label class="form-label" for="field-other_city">{l s='City' d='Shop.Forms.Labels'}</label>
          <input class="form-control" type="text" name="other_city" id="field-other_city" placeholder=" " required>
        </div>
      </div>

      {* Telefon tylko wtedy, gdy ten drugi adres jest adresem dostawy
         (firma + inny adres): kurier musi mieć jak zadzwonić. Dla osoby
         prywatnej drugi adres jest fakturą, telefon zostaje przy adresie
         dostawy u góry. *}
      <div class="mb-3 q-float" data-q-other-phone-row{if !$qFirma} hidden{/if}>
        <label class="form-label" for="field-other_phone">{l s='Phone' d='Shop.Forms.Labels'}</label>
        <input class="form-control" type="tel" name="other_phone" id="field-other_phone" placeholder=" ">
      </div>
    </div>
  {/if}
{/block}

{block name='form_buttons'}
  {if !$form_has_continue_button}
    <footer class="buttons-wrapper buttons-wrapper--end">
      <a class="q-linkbtn js-cancel-address" href="{url entity='order' params=['cancelAddress' => {$type}]}">{l s='Cancel' d='Shop.Theme.Actions'}</a>
      <button type="submit" class="btn btn-primary">{l s='Save' d='Shop.Theme.Actions'}</button>
    </footer>
  {else}
    {* Wstecz przy lewej krawędzi, Dalej przy prawej, w jednym rzędzie. Oba
       MUSZĄ stać w TYM formularzu: krok otwiera własny `<form>`, ale
       `address-form.tpl` zagnieżdża w nim drugi, a przeglądarka zamyka ten
       pierwszy (zewnętrzny) na pierwszym napotkanym `</form>`, czyli na tym
       tutaj. Rząd dobudowany w kroku, PO tym wywołaniu, lądował więc poza
       każdym formularzem i kliknięcie w niego nic nie wysyłało.

       `Wstecz` dostaje krok poprzedni przekazany wprost (`previous_step`):
       `{render}` buduje własny zakres zmiennych, inaczej niż `{include}`,
       i nie widzi zmiennych kroku bez tego. *}
    <footer class="buttons-wrapper buttons-wrapper--split">
      {if isset($previous_step)}
        <button class="q-linkbtn q-linkbtn--back js-back" type="button" data-step="{$previous_step.identifier}">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 6l-6 6 6 6"></path></svg>
          {l s='Back' d='Shop.Theme.Actions'}
        </button>
      {/if}

      {if $customer.addresses|count > 0}
        <a class="q-linkbtn js-cancel-address" href="{url entity='order' params=['cancelAddress' => {$type}]}">{l s='Cancel' d='Shop.Theme.Actions'}</a>
      {/if}

      <button type="submit" class="btn btn-primary continue" name="confirm-addresses" value="1">{l s='Continue' d='Shop.Theme.Actions'}</button>
    </footer>
  {/if}
{/block}
