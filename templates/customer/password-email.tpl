{**
 * Quince: odzyskiwanie hasła, krok 1 (adres e-mail).
 *
 * Układ jak na stronie logowania (customer/authentication.tpl): okruszki
 * w kontenerze i karta z formularzem, bez kolumny z korzyściami konta.
 * Pod formularzem powrót do logowania w stopce karty.
 *
 * Formularz jest formularzem rdzenia: ta sama akcja, to samo pole `email`
 * i ten sam przycisk `submit`.
 *
 * Klasy: assets/css/components/auth.css
 *}
{extends file=$layout}

{* Okruszki idą do środka strony, jak na stronie logowania. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  <main class="q-container q-auth">
    {include file='_partials/breadcrumb.tpl'}

    <div class="q-auth__narrow">
    <section class="q-auth__card">
      <header class="q-auth__head">
        <h1 class="q-section-title q-auth__title">{l s='Forgot your password?' d='Shop.Theme.Customeraccount'}</h1>
        <p class="q-auth__lead">{l s='Please enter the email address you used to register. You will receive a temporary link to reset your password.' d='Shop.Theme.Customeraccount'}</p>
      </header>

      <form action="{$urls.pages.password}" class="q-auth__form forgotten-password" method="post" data-ps-action="form-validation">
        {if count($errors)}
          <div class="q-alert q-alert--danger" role="alert">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0M7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0z"/></svg>
            <span>
              {foreach $errors as $qBlad}{$qBlad}{if !$qBlad@last}<br>{/if}{/foreach}
            </span>
          </div>
        {/if}

        <div class="mb-3 q-float">
          <label class="form-label required" for="email">{l s='Email address' d='Shop.Forms.Labels'}</label>
          <input
            class="form-control"
            type="email"
            name="email"
            id="email"
            placeholder=" "
            value="{if isset($smarty.post.email)}{stripslashes($smarty.post.email)|escape:'html':'UTF-8'}{/if}"
            autocomplete="username"
            required
          >
        </div>

        <div class="q-auth__actions q-auth__actions--plain">
          <button id="send-reset-link" class="q-btn q-btn--primary q-btn--lg" name="submit" type="submit" data-ps-action="form-validation-submit">
            {l s='Send reset link' d='Shop.Theme.Actions'}
            <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
          </button>
        </div>
      </form>

      <footer class="q-auth__foot">
        <a id="back-to-login" href="{$urls.pages.authentication}">{l s='Back to login' d='Shop.Theme.Actions'}</a>
      </footer>
    </section>
    </div>
  </main>
{/block}
