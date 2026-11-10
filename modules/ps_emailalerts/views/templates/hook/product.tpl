{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *
 * Quince: znaczniki modułu przepisane na klasy motywu. Moduł rysuje formularz
 * klasami Bootstrapa (`form-control`, `btn btn-primary`), których ten motyw nie
 * zna, więc pole i przycisk stały na karcie produktu bez żadnego stylu.
 * Zachowanie zostaje modułu: atrybuty `data-ps-*` czyta jego własny skrypt.
 *}

<div class="ps-emailalerts ps-emailalerts--product"
  data-ps-ref="emailalerts"
  data-ps-component="gdpr"
  data-url="{url entity='module' name='ps_emailalerts' controller='actions' params=['process' => 'add']}"
  data-q-notify-failure="{l s='The request could not be sent. Please try again in a moment.' d='Shop.Notifications.Error'}"
  data-q-notify-empty="{l s='Enter your email address.' d='Shop.Forms.Errors'}"
  data-q-notify-invalid="{l s='This is not a valid email address.' d='Shop.Forms.Errors'}">
  {if empty($has_notification)}
    <div class="ps-emailalerts__content" data-ps-ref="emailalerts-content">
      <p class="q-alerts__title">
        {l s='Notify me when available' d='Modules.Emailalerts.Shop'}
      </p>

      {if isset($email) AND $email}
        <p class="q-alerts__note">
          {l s='Interested in this product? Drop us an email and we will let you know when it\'s available for order.' d='Modules.Emailalerts.Shop'}
        </p>

        {* Pływająca etykieta jak w formularzach motywu: napis siada w pustym polu,
           a przy pisaniu wchodzi w górną kreskę i tam zostaje. Stąd `form-control`
           (po tej klasie pytają reguły stanu) i pusty placeholder: to on decyduje
           o `:placeholder-shown`, a napis pola niesie etykieta. Etykieta zamiast
           `aria-label`, bo widzi ją i klient, i czytnik ekranu. *}
        {* Pole bez `required`. To ten atrybut kazał przeglądarce pilnować pustego
           pola i to on wywoływał czarny dymek „Wypełnij to pole", którego nie da
           się ani ostylować, ani przesunąć. Pustego pola pilnujemy sami i piszemy
           o tym pod polem. Rodzaj pola zostaje `email`, bo od niego zależy
           klawiatura na telefonie i to, co podpowiada przeglądarka. *}
        <div class="q-float q-alerts__field">
          <label class="form-label" for="emailalerts-email">
            {l s='Your email address' d='Modules.Emailalerts.Shop'}
          </label>
          <input class="q-field form-control q-alerts__input"
            type="email"
            id="emailalerts-email"
            name="email"
            data-ps-ref="emailalerts-email"
            placeholder=" "
            autocomplete="email"
          >
          <p class="q-alerts__hint" data-ps-ref="emailalerts-hint" aria-live="polite" hidden></p>
        </div>
      {else}
        <p class="q-alerts__note">
          {l s='Interested in this product? Click below and we will let you know when it\'s available for order.' d='Modules.Emailalerts.Shop'}
        </p>
      {/if}

      {* Zapory silnika i zapis dostawcy oceny. Blok nie jest formularzem, więc
         pola strażnika dokłada do wysyłki skrypt (powiadomienie.js). *}
      <div data-q-notify-guard>
        {include file='_partials/form-guard.tpl' form_id='notify'}
      </div>

      {capture name='subscribeData'}{strip}{ldelim}
        "id_product": "{$product.id_product|intval}",
        "id_product_attribute": "{$product.id_product_attribute|intval}"
      {rdelim}{/strip}{/capture}

      <button data-ps-action="emailalerts-subscribe"
        data-ps-ref="gdpr-submit"
        data-ps-data="{$smarty.capture.subscribeData}"
        class="q-btn q-btn--primary q-alerts__submit"
        rel="nofollow"
        role="button"
      >
        {l s='Notify me when available' d='Modules.Emailalerts.Shop'}
      </button>

      {if !empty($id_module)}
        {capture name='gdprContent'}{hook h='displayGDPRConsent' id_module=$id_module}{/capture}

        {if $smarty.capture.gdprContent}
          <div class="q-alerts__consent">
            {$smarty.capture.gdprContent nofilter}
          </div>
        {/if}
      {/if}
    </div>

    {* Komunikat po wysłaniu i komunikat walidacji trafiają tutaj. Puste pole
       chowa atrybut `hidden`, żeby nie zostawiać po sobie odstępu w siatce. *}
    <div class="q-alerts__message" data-ps-target="emailalerts-alerts" aria-live="assertive" hidden></div>
  {else}
    <div class="q-alert q-alert--info" role="alert">
      {l s='You will be notified when this product is available.' d='Modules.Emailalerts.Shop'}
    </div>
  {/if}
</div>
