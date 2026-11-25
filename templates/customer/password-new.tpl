{**
 * Quince: odzyskiwanie hasła, krok 2 (nowe hasło z linku w mailu).
 *
 * Ta sama karta co w kroku 1 (customer/password-email.tpl). Nowe hasło
 * i potwierdzenie stoją obok siebie, podgląd hasła jest w polu, jak na stronie
 * logowania (_partials/form-fields.tpl, wyspa password-toggle.js).
 *
 * Formularz jest formularzem rdzenia: te same pola `passwd` i `confirmation`
 * oraz te same ukryte tokeny.
 *
 * Klasy: assets/css/components/auth.css
 *}
{extends file=$layout}

{* Okruszki idą do środka strony, jak na stronie logowania. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  <main class="q-container q-auth">
    {include file='_partials/breadcrumb.tpl'}

    <section class="q-auth__card">
      <header class="q-auth__head">
        <h1 class="q-section-title q-auth__title">{l s='Reset your password' d='Shop.Theme.Customeraccount'}</h1>
        <p class="q-auth__lead">
          {l
            s='Email address: %email%'
            d='Shop.Theme.Customeraccount'
            sprintf=['%email%' => stripslashes($customer_email)]
          }
        </p>
      </header>

      <form action="{$urls.pages.password}" class="q-auth__form renew-password" method="post" data-ps-action="form-validation">
        {if count($errors)}
          <div class="q-alert q-alert--danger" role="alert">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0M7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0z"/></svg>
            <span>
              {foreach $errors as $qBlad}{$qBlad}{if !$qBlad@last}<br>{/if}{/foreach}
            </span>
          </div>
        {/if}

        <div class="q-auth__pair">
          {assign var=qNapisNowe value={l s='New password' d='Shop.Forms.Labels'}}
          {assign var=qNapisPowtorz value={l s='Confirmation' d='Shop.Forms.Labels'}}
          {foreach from=[['passwd', 'field-password', $qNapisNowe], ['confirmation', 'field-confirmation-passwd', $qNapisPowtorz]] item=qPole}
            <div class="mb-3 q-float q-float--action q-float--eye">
              <label class="form-label required" for="{$qPole[1]}">{$qPole[2]}</label>
              <input
                class="form-control"
                id="{$qPole[1]}"
                type="password"
                data-validate="isPasswd"
                name="{$qPole[0]}"
                value=""
                placeholder=" "
                autocomplete="new-password"
                spellcheck="false"
                required
              >
              <button
                class="q-float__action q-float__eye"
                type="button"
                hidden
                data-q-eye
                data-text-show="{l s='Show password' d='Shop.Theme.Actions'}"
                data-text-hide="{l s='Hide password' d='Shop.Theme.Actions'}"
                aria-label="{l s='Show password' d='Shop.Theme.Actions'}"
                aria-controls="{$qPole[1]}"
              >
                <svg class="q-float__eye-on" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5s3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5s-3.879-1.168-5.168-2.457A13 13 0 0 1 1.172 8z"/><path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/></svg>
                <svg class="q-float__eye-off" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M13.359 11.238C15.06 9.72 16 8 16 8s-3-5.5-8-5.5a7 7 0 0 0-2.79.588l.77.771A6 6 0 0 1 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755q-.247.248-.517.486z"/><path d="M11.297 9.176a3.5 3.5 0 0 0-4.474-4.474l.823.823a2.5 2.5 0 0 1 2.829 2.829zm-2.943 1.299.822.822a3.5 3.5 0 0 1-4.474-4.474l.823.823a2.5 2.5 0 0 0 2.829 2.829"/><path d="M3.35 5.47q-.27.24-.518.487A13 13 0 0 0 1.172 8l.195.288c.335.48.83 1.12 1.465 1.755C4.121 11.332 5.881 12.5 8 12.5c.716 0 1.39-.133 2.02-.36l.77.772A7 7 0 0 1 8 13.5C3 13.5 0 8 0 8s.939-1.721 2.641-3.238l.708.709z"/><path d="m13.646 14.354-12-12 .708-.708 12 12z"/></svg>
              </button>
            </div>
          {/foreach}
        </div>

        <input type="hidden" name="token" id="token" value="{$customer_token}">
        <input type="hidden" name="id_customer" id="id_customer" value="{$id_customer}">
        <input type="hidden" name="reset_token" id="reset_token" value="{$reset_token}">

        <div class="q-auth__actions">
          <button class="q-btn q-btn--primary q-btn--lg" type="submit" name="submit" data-ps-action="form-validation-submit">
            {l s='Change Password' d='Shop.Theme.Actions'}
            <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
          </button>
        </div>
      </form>

      <footer class="q-auth__foot">
        <a id="back-to-login" href="{$urls.pages.authentication}">{l s='Back to login' d='Shop.Theme.Actions'}</a>
      </footer>
    </section>
  </main>
{/block}
