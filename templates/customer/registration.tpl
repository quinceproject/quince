{**
 * Quince: rejestracja.
 *
 * Projekt: quince/makiety/rejestracja.html. Karta z formularzem po lewej,
 * korzyści z konta po prawej (customer/_partials/auth-side.tpl). Bez bloku
 * rejestracji przez Google i Facebook: sklep nie ma takiego modułu.
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
          <h1 class="q-section-title q-auth__title">{l s='Open an account' d='Shop.Theme.Customeraccount'}</h1>
          <p class="q-auth__lead">{l s='Create an account to track your orders, save products and buy faster.' d='Shop.Theme.Customeraccount'}</p>
        </header>

        {block name='register_form_container'}
          {$hook_create_account_top nofilter}
          {render file='customer/_partials/auth-register-form.tpl' ui=$register_form mode='register'}
        {/block}

        <footer class="q-auth__foot">
          {l s='Already have an account?' d='Shop.Theme.Customeraccount'}
          <a href="{$urls.pages.authentication}">{l s='Sign in' d='Shop.Theme.Customeraccount'}</a>
        </footer>
      </section>

      {include file='customer/_partials/auth-side.tpl' qStrona='register'}

    </div>
  </main>
{/block}
