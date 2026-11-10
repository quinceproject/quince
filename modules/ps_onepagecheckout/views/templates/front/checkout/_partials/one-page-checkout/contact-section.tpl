{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{**
 * Sekcja 1: tylko e-mail. Imię, nazwisko i adres klient podaje w sekcji 2
 * (makieta kasy, wariant „One page"). Pole zgody na newsletter
 * i dodatkowe pola konta stoją w stopce formularza, nie tutaj — tam, gdzie
 * jest prawdziwy przycisk zamówienia (patrz `steps/one-page-checkout.tpl`).
 * Zakładanie konta podczas zakupu to funkcja wyłącznie kasy krokowej; gość
 * w OPC dostaje tę propozycję dopiero na stronie potwierdzenia zamówienia.
 *}

{hook h='displayPersonalInformationTop' customer=$customer}

{$isGuestCheckoutEnabled = $configuration.is_guest_checkout_enabled}

{if !$customer.is_logged}
  <section class="one-page-checkout__section">
    {* To samo miejsce i ten sam wzorzec, co w kasie krokowej
       (`checkout/_partials/steps/personal-information.tpl`, blok
       `step_title_aside`): przy nazwie sekcji, nie pod nią, i rozbite na
       pytanie + link (`.q-checkout2__aside`, `.q-linkbtn`), nie jeden ciąg
       tekstu. Ta sama domena tłumaczenia dla obu kawałków, żeby skorzystać
       z tłumaczenia, które krokowa już ma — nie nowy, osobny napis. *}
    <div class="one-page-checkout__head">
      <h2 class="one-page-checkout__title">{l s='Contact information' d='Modules.Onepagecheckout.Shop'}</h2>

      <span class="q-checkout2__aside">
        {l s='Already have an account?' d='Shop.Theme.Checkout'}
        <a class="q-linkbtn" href="{$opc_urls.authentication}">
          {l s='Sign in' d='Shop.Theme.Actions'}
        </a>
      </span>
    </div>

    {if $isGuestCheckoutEnabled}
      {if isset($contactFields['email'])}
        <div class="one-page-checkout__field">
          {form_field field=$contactFields['email']}
        </div>
      {/if}
    {/if}

    {* Zgoda RODO (`psgdpr`) i klauzula (`ps_dataprivacy`) muszą fizycznie
       stać w TEJ sekcji — stąd czyta je wbudowany skrypt rdzenia
       (`opc-guest-init.bundle.js`): bez choć jednego zaznaczonego
       checkboxa `required` tutaj moduł nigdy nie zakłada konta gościa,
       nawet przy poprawnym e-mailu (sprawdzone: `jQuery.post` do
       `guestinit` nigdy się nie wywoływał bez tego pola).

       Treść klauzul zostaje tam, gdzie była — pod przyciskiem zamówienia
       (`steps/one-page-checkout.tpl`, `$psgdprLabel`/`$customerPrivacyLabel`).
       To pole tutaj niczego nie pokazuje: stoi zaznaczone i ukryte wizualnie,
       bo przetwarzanie danych do realizacji zamówienia nie jest wyborem
       klienta (RODO art. 6 ust. 1 lit. b) — ten sam wybór projektu
       co w krokowym (`checkout/_partials/customer-form.tpl`), tam jako
       `type="hidden"`. Tu musi być `checkbox`, bo tylko taki typ skrypt
       rdzenia rozpoznaje; efekt końcowy (wysłana wartość „1") jest ten sam. *}
    {if $isGuestCheckoutEnabled}
      {foreach from=$additionalCustomerFields|default:[] item="qConsentField"}
        {if $qConsentField.name == 'psgdpr' || $qConsentField.name == 'customer_privacy'}
          <input
            class="visually-hidden"
            type="checkbox"
            name="{$qConsentField.name}"
            value="1"
            checked
            required
            aria-hidden="true"
            tabindex="-1"
          >
        {/if}
      {/foreach}
    {/if}
  </section>
{else}
  <section class="one-page-checkout__section">
    <h2 class="one-page-checkout__title">{l s='Contact information' d='Modules.Onepagecheckout.Shop'}</h2>
    {include file='module:ps_onepagecheckout/views/templates/front/checkout/_partials/one-page-checkout/connected-account-info.tpl'}
  </section>
{/if}
