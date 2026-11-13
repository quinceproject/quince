{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * Szkielet całej kasy jednostronicowej. Sekcje renderuje moduł, nowe tutaj
 * jest tylko to, czego moduł nie przewiduje: zgoda na newsletter i oferty
 * partnerów (tylko gość) oraz przeniesienie zgody na regulamin
 * i przycisku zamówienia do kolumny. Robi to `checkout-summary.js`, ten sam
 * skrypt, co w kasie krokowej, po węźle `#conditions-to-approve` i po
 * `#opc-payment-confirmation-wrap` (OPC ma własny id tego węzła, patrz
 * niżej przy jego znaczniku).
 *}

<form id="opc-form" class="one-page-checkout" method="POST" action="{$urls.pages.order}" data-ps-action="form-validation">
  {include file='_partials/form-errors.tpl' errors=$errors['']}
  {include file='_partials/form-errors.tpl' errors=$validation_error_messages|default:[]}

  <div class="js-opc-contact-section">
    {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/contact-section.tpl'}
  </div>

  <div class="js-opc-addresses-section">
    {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/addresses-section.tpl'}
  </div>

  {if !$is_virtual_cart}
    {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/delivery-section.tpl'
      delivery_options=$delivery_options
      delivery_option=$delivery_option
      id_address_delivery=$cart.id_address_delivery|intval
      hookDisplayBeforeCarrier=$hookDisplayBeforeCarrier|default:null
      hookDisplayAfterCarrier=$hookDisplayAfterCarrier|default:null
      delivery_message=$delivery_message|default:''
      recyclablePackAllowed=$recyclablePackAllowed|default:false
      recyclable=$recyclable|default:false
      gift=$gift|default:[]
    }
  {/if}
</form>

{* Płatność poza głównym formularzem (tak jak w module), żeby nie
   zagnieżdżać formularza płatności w formularzu kasy. *}
{include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/payment-section.tpl'
  payment_options=$payment_options|default:[]
  is_free=$is_free|default:false
  selected_payment_module=$selected_payment_module|default:''
  selected_payment_selection_key=$selected_payment_selection_key|default:''
}

{* Stopka: zgoda na regulamin, newsletter/oferty partnerów (gość) i przycisk
   zamówienia. Na szerokim ekranie `checkout-summary.js` przenosi te dwa
   węzły (`#conditions-to-approve`, `#opc-payment-confirmation-wrap`) do
   kolumny zamówienia, więc `data-q-pay-source` chowa ten pasek, gdy
   opustoszeje. *}
<div class="one-page-checkout__footer" data-q-pay-source>
  {if $conditions_to_approve|count}
    <form id="conditions-to-approve" class="js-conditions-to-approve" method="GET">
      {foreach from=$conditions_to_approve item="condition" key="condition_name"}
        <label class="q-choice" for="conditions_to_approve[{$condition_name}]">
          <input id="conditions_to_approve[{$condition_name}]"
                 name="conditions_to_approve[{$condition_name}]"
                 required
                 type="checkbox"
                 value="1"
                 class="q-choice__input"
          >
          <span class="js-terms q-choice__label">{$condition nofilter}</span>
        </label>
      {/foreach}

      {* Newsletter i oferty partnerów: prawdziwy, opcjonalny wybór, więc
         zostają checkboxami. Stoją tutaj, w stopce kolumny, i tylko dla
         gościa: klient zalogowany ustawia to na koncie. Najpierw newsletter,
         potem oferty partnerów. *}
      {if !$customer.is_logged}
        <div class="q-checkout2__optins">
          {foreach from=$additionalCustomerFields|default:[] item="field"}
            {if $field.name == 'newsletter'}
              {form_field field=$field}
            {/if}
          {/foreach}

          {if isset($contactFields['optin'])}
            {form_field field=$contactFields['optin']}
          {/if}
        </div>
      {/if}
    </form>
  {/if}

  {* Id inny niż w kasie krokowej (tam `#payment-confirmation`) naumyślnie:
     rdzeń (`themes/_core/js/checkout-payment.js`, dołączony globalnie,
     na każdej stronie kasy) zarządza przyciskiem WYŁĄCZNIE przez ten id
     (`prestashop.selectors.checkout.confirmationSelector`), bez sprawdzania,
     na którym wariancie kasy stoi. Ten sam id tutaj daje dwa niezależne
     skrypty na jednym przycisku: `opc-submit.js` liczy stan poprawnie,
     a rdzeń chwilę po nim nadpisuje `disabled` swoją logiką
     (`getSelectedOption()`, liczoną pod kasę krokową), więc przycisk
     zostaje zablokowany, mimo że krok jest kompletny.
     Własny id tutaj czyni OPC niewidzialnym dla tego skryptu rdzenia;
     `checkout-summary.js` i tak przenosi węzeł do kolumny, bo szuka
     obu wariantów id (patrz tam). *}
  <div id="opc-payment-confirmation-wrap">
    <div id="opc-payment-confirmation" class="js-opc-payment-confirmation">
      <button class="q-btn q-btn--primary q-btn--lg q-ordersum__pay" type="button" id="opc-pay-button" disabled>
        <span class="spinner-border spinner-border-sm me-2 d-none" aria-hidden="true" data-opc-pay-spinner></span>
        {l s='Order with an obligation to pay' d='Modules.Onepagecheckout.Shop'} <span id="opc-pay-amount">{$cart.totals.total.value}</span>
      </button>
    </div>

    {* Zgoda na politykę prywatności (`psgdpr`) i klauzula informacyjna
       (`ps_dataprivacy`), pod przyciskiem. Ani jedna,
       ani druga nie jest zgodą do zaznaczenia: przetwarzanie danych do
       realizacji zamówienia nie jest wyborem klienta (RODO art. 6 ust. 1
       lit. b). Treść zostaje widoczna i dalej edytowalna w natywnych
       ekranach ustawień tych modułów; nic tu nie jest dopisane na sztywno.
       W środku `#opc-payment-confirmation-wrap`, bo tylko ten węzeł (i
       `#conditions-to-approve`) `checkout-summary.js` przenosi do kolumny
       zamówienia na szerokim ekranie. *}
    {* `additionalCustomerFields` to płaskie tablice (nie obiekty `FormField`)
       kluczowane `modul_nazwaPola`.
       `name`/`label` to klucze tablicy, nie metody. Kolejność w bloku
       ustalona z nazwy, nie z kolejności w tablicy: najpierw `psgdpr`
       (zgoda na politykę prywatności), potem `customer_privacy` (klauzula). *}
    {assign var="psgdprLabel" value=""}
    {assign var="customerPrivacyLabel" value=""}
    {foreach from=$additionalCustomerFields|default:[] item="field"}
      {if $field.name == 'psgdpr'}
        {assign var="psgdprLabel" value=$field.label}
      {elseif $field.name == 'customer_privacy'}
        {assign var="customerPrivacyLabel" value=$field.label}
      {/if}
    {/foreach}
    {if $psgdprLabel|default:'' || $customerPrivacyLabel|default:''}
      <div class="q-ordersum__clause">
        {if $psgdprLabel|default:''}<p>{$psgdprLabel nofilter}</p>{/if}
        {if $customerPrivacyLabel|default:''}<p>{$customerPrivacyLabel nofilter}</p>{/if}
      </div>
    {/if}
  </div>

  {hook h='displayPaymentByBinaries'}
</div>
