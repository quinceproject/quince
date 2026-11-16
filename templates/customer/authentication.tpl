{**
 * Quince: logowanie.
 *
 * Projekt: quince/makiety/logowanie.html. Karta z formularzem po lewej,
 * korzyści z konta po prawej (customer/_partials/auth-side.tpl). Bez bloku
 * logowania przez Google i Facebook: sklep nie ma takiego modułu.
 *
 * Formularz jest formularzem rdzenia: te same pola, ta sama akcja, ten sam
 * ukryty `back`. Komunikaty strony pokazuje motyw jako dymki
 * (_partials/notifications.tpl), błąd formularza stoi w karcie.
 *
 * Klasy: assets/css/components/auth.css
 *}
{extends file=$layout}

{* Okruszki idą do środka strony, jak w koszyku. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  <main class="q-container q-auth">
    {include file='_partials/breadcrumb.tpl'}

    <div class="q-auth__layout">

      <section class="q-auth__card">
        <header class="q-auth__head">
          <h1 class="q-section-title q-auth__title">{l s='Sign in' d='Shop.Theme.Customeraccount'}</h1>
          <p class="q-auth__lead">{l s='Sign in to your account to manage your orders and use everything the shop offers.' d='Shop.Theme.Customeraccount'}</p>
        </header>

        {block name='login_form_container'}
          {render file='customer/_partials/auth-login-form.tpl' ui=$login_form}
        {/block}

        {* Miejsce dla modułów pod formularzem, tak jak w szablonie rdzenia. *}
        {block name='display_after_login_form'}
          {hook h='displayCustomerLoginFormAfter'}
        {/block}

        <footer class="q-auth__foot">
          {l s='No account yet?' d='Shop.Theme.Customeraccount'}
          <a href="{$urls.pages.register}" data-link-action="display-register-form">{l s='Sign up' d='Shop.Theme.Customeraccount'}</a>
        </footer>
      </section>

      {include file='customer/_partials/auth-side.tpl' qStrona='login'}

    </div>
  </main>
{/block}
