{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * Pola jednej sekcji adresu (dostawa albo faktura), wiersze gotowe z PHP
 * (`AddressFieldRows`): kolejność i parowanie liczy moduł z formatu adresu
 * wybranego kraju, szablon tylko wypisuje.
 *
 * Przełącznik „Kupuję jako" stoi tylko przy WBUDOWANYM formularzu adresu
 * dostawy, nie w oknie modalnym „Dodaj adres". Ten sam plik renderuje
 * oba (`address-modal-fields.tpl` dołącza ten szablon ponownie), a modal
 * zawsze niesie własny `id_prefix`, wbudowany formularz nigdy. Po tym
 * jedynym się rozróżnia: `quince_engine` czyta `quince_buyer` bez
 * przedrostka, dwa radiogrupy o tej samej nazwie w jednym formularzu
 * wykluczałyby się nawzajem. *}

{assign var="_prefix" value=$prefix|default:''}
{assign var="_id_prefix" value=$id_prefix|default:''}
{assign var="_state_placeholder" value=$state_placeholder|default:false}

{if $_prefix === '' && $_id_prefix === ''}
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

{* Nazwa adresu nie ma sensu, dopóki formularz stoi wbudowany w krok, nie
   w oknie modalnym „Dodaj adres": tam adres trafia na listę zapisanych
   i nazwa pomaga go rozpoznać przy kolejnym zamówieniu, tu zapisuje się
   wprost jako adres dostawy/faktury tego zamówienia. Ten sam podział co
   przy przełączniku „Kupuję jako" wyżej. $customer.is_guest nie jest tu
   dostępne (inny zasięg niż w `contact-section.tpl`), więc nie polegamy na nim. *}
{assign var="_alias_key" value="{$_prefix}alias"}
{assign var="_postcode_key" value="{$_prefix}postcode"}

{* Panel drugiego adresu (wbudowany, prefiks "invoice_") nigdy nie pyta
   o NIP ani nazwę firmy, tak samo jak w krokowym, gdzie ten panel jest
   ręcznie budowanym formularzem bez tych pól. Bez tego osoba prywatna,
   która odznaczy „ten sam adres", widzi VAT number przy własnym adresie
   do faktury. *}
{assign var="_hide_company_fields" value=($_prefix === 'invoice_' && $_id_prefix === '')}

{* NIP z nazwą firmy w jednym wierszu, tak jak w krokowym
   (`customer/_partials/address-form.tpl`, para `vat_number => company`).
   PHP modułu (`AddressFieldRows`) tej pary nie łączy, bo liczy wiersze
   z formatu adresu kraju, który o NIP-ie nic nie wie. Łączymy ją tutaj,
   w dwóch przejściach: najpierw szukamy pola firmy, potem przy NIP-ie
   renderujemy oba naraz i pole firmy pomijamy w jego własnym miejscu. *}
{assign var="_vat_key" value="{$_prefix}vat_number"}
{assign var="_company_key" value="{$_prefix}company"}
{assign var="_company_field" value=null}
{if !$_hide_company_fields}
  {foreach from=$fieldRows|default:[] item="_scanrow"}
    {if ($_scanrow|count) == 1 && $_scanrow[0].name === $_company_key}
      {assign var="_company_field" value=$_scanrow[0]}
    {/if}
  {/foreach}
{/if}

{foreach from=$fieldRows|default:[] item="_row"}
  {if ($_row|count) == 1 && $_row[0].name === $_alias_key && $_id_prefix === ''}
    {* pomijamy *}
  {elseif ($_row|count) == 1 && $_hide_company_fields && ($_row[0].name === $_vat_key || $_row[0].name === $_company_key)}
    {* pomijamy, patrz $_hide_company_fields wyżej *}
  {elseif ($_row|count) == 1 && $_company_field && $_row[0].name === $_company_key}
    {* pomijamy, dołączone wyżej do wiersza z NIP-em *}
  {elseif ($_row|count) == 1 && $_company_field && $_row[0].name === $_vat_key}
    {* Nie generyczny `.opc-form-fields-row--2` (pół na pół): pole NIP-u ma
       w środku przycisk „Fetch details", a 50/50 ściska sam numer. Ten sam
       układ co w krokowym, `.q-checkout2__row--vat_number`: 20rem na NIP
       z przyciskiem, reszta na nazwę firmy. *}
    <div class="q-checkout2__row q-checkout2__row--vat_number">
      {form_field field=$_row[0]}
      {form_field field=$_company_field}
    </div>
  {elseif ($_row|count) > 1 && $_row[0].name === $_postcode_key}
    {* Kod pocztowy krótszy niż miasto, ten sam układ co w krokowym
       (`.q-checkout2__row--postcode`): wąska stała kolumna na kod, reszta
       na miasto. Generyczny `.opc-form-fields-row--2` dzieli pół na pół. *}
    <div class="q-checkout2__row q-checkout2__row--postcode">
      {foreach from=$_row item="_field"}
        {form_field field=$_field}
      {/foreach}
    </div>
  {elseif ($_row|count) > 1}
    {include file='module:ps_onepagecheckout/views/templates/front/_partials/form-fields-row.tpl'
      fields=$_row
    }
  {else}
    {form_field field=$_row[0]}
  {/if}
{/foreach}

{* Countries whose format has no state field at all: the modals keep an inert select in the DOM so
   the section always posts a state value. *}
{assign var="_state_key" value="{$_prefix}id_state"}
{if $_state_placeholder && !isset($formFields[$_state_key])}
  <div class="form-group mb-3 state-field-wrapper" style="display: none;">
    <label class="form-label" for="{$_id_prefix}field-id_state">
      {l s='State' d='Modules.Onepagecheckout.Shop'}
    </label>
    <select class="form-select" name="{$_prefix}id_state" id="{$_id_prefix}field-id_state">
      <option value="">{l s='-- please choose --' d='Modules.Onepagecheckout.Shop'}</option>
    </select>
  </div>
{/if}
