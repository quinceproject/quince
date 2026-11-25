{**
 * Quince: odzyskiwanie hasła, potwierdzenie wysłania linku.
 *
 * Ta sama karta co w kroku 1 (customer/password-email.tpl): komunikat rdzenia
 * w karcie i powrót do logowania w jej stopce.
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
        <h1 class="q-section-title q-auth__title">{l s='Forgot your password?' d='Shop.Theme.Customeraccount'}</h1>
      </header>

      <div class="q-auth__form">
        {if count($successes)}
          <div class="q-alert q-alert--success" role="alert" tabindex="0">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg>
            <span>
              {foreach $successes as $qInfo}{$qInfo}{if !$qInfo@last}<br>{/if}{/foreach}
            </span>
          </div>
        {/if}
      </div>

      <footer class="q-auth__foot">
        <a id="back-to-login" href="{$urls.pages.authentication}">{l s='Back to login' d='Shop.Theme.Actions'}</a>
      </footer>
    </section>
  </main>
{/block}
