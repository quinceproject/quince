{**
 * Quince: zachęta obok formularza logowania i rejestracji.
 *
 * Projekt: quince/makiety/logowanie.html i rejestracja.html.
 *
 * Wywołanie:
 *   qStrona  'login' albo 'register'
 *
 * Korzyści przychodzą z silnika (Quince Engine → Logowanie i rejestracja),
 * osobno dla każdej strony. Tytuł i opis są zwykłym tekstem (silnik zdejmuje
 * znaczniki przy zapisie) i idą przez zwykłe `{$...}`, które Smarty w sklepie
 * escapuje sam. Bez `nofilter` i bez drugiego `|htmlspecialchars`, bo to
 * kodowałoby tekst podwójnie (`&quot;` zamiast cudzysłowu). Ikona to SVG
 * z plików silnika, nie z formularza panelu.
 *}
{assign var=qAuth value=$modules.quince_engine.auth|default:null}
{assign var=qKorzysci value=[]}
{if $qAuth && isset($qAuth[$qStrona])}{assign var=qKorzysci value=$qAuth[$qStrona]}{/if}

<aside class="q-auth__side" aria-label="{l s='Account benefits' d='Shop.Theme.Customeraccount'}">
  {if $qStrona == 'login'}
    <h2 class="q-auth__side-title">{l s='No account yet?' d='Shop.Theme.Customeraccount'}</h2>
    <p class="q-auth__side-lead">{l s='Join a community of professionals and use everything the shop offers.' d='Shop.Theme.Customeraccount'}</p>
  {else}
    <h2 class="q-auth__side-title">{l s='Already have an account?' d='Shop.Theme.Customeraccount'}</h2>
    <p class="q-auth__side-lead">{l s='Sign in to continue shopping and use your saved details.' d='Shop.Theme.Customeraccount'}</p>
  {/if}

  {if $qKorzysci}
    <ul class="q-auth__benefits">
      {foreach from=$qKorzysci item=qKorzysc}
        <li class="q-auth__benefit">
          <span class="q-auth__benefit-icon">
            {if $qKorzysc.icon}
              <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">{$qKorzysc.icon nofilter}</svg>
            {/if}
          </span>
          <div>
            <strong class="q-auth__benefit-title">{$qKorzysc.title}</strong>
            {if $qKorzysc.text}
              <p class="q-auth__benefit-text">{$qKorzysc.text}</p>
            {/if}
          </div>
        </li>
      {/foreach}
    </ul>
  {/if}

  {if $qStrona == 'login'}
    <a class="q-btn q-btn--secondary q-btn--lg" href="{$urls.pages.register}" data-link-action="display-register-form">
      {l s='Open an account' d='Shop.Theme.Customeraccount'}
      <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
    </a>
  {else}
    <a class="q-btn q-btn--secondary q-btn--lg" href="{$urls.pages.authentication}">
      {l s='Sign in' d='Shop.Theme.Actions'}
      <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
    </a>
  {/if}
</aside>
