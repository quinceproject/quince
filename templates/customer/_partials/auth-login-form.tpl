{**
 * Quince: formularz na stronie logowania.
 *
 * Projekt: quince/makiety/logowanie.html. E-mail i hasło obok siebie, pod
 * nimi odnośnik do przypomnienia hasła, przycisk po prawej.
 *
 * Osobny plik, a nie zmiana `login-form.tpl`: tamten dziedziczy logowanie
 * w kasie (checkout/_partials/login-form.tpl), które ma własny układ.
 *
 * Pola rysuje `{form_field}` rdzenia (_partials/form-fields.tpl), więc nazwy,
 * walidacja i ukryte pole `back` zostają takie, jak w PrestaShopie. Pola
 * spoza pary (np. dołożone przez moduł) idą pod nią, przez całą szerokość.
 *}
{block name='login_form'}
  <form id="login-form" class="q-auth__form" action="{block name='login_form_actionurl'}{$action}{/block}" method="post" data-ps-action="form-validation">

    {block name='login_form_errors'}
      {if $errors['']|count}
        <div class="q-alert q-alert--danger" role="alert">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0M7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0z"/></svg>
          <span>
            {foreach $errors[''] as $qBlad}{$qBlad}{if !$qBlad@last}<br>{/if}{/foreach}
          </span>
        </div>
      {/if}
    {/block}

    {block name='login_form_fields'}
      <div class="q-auth__pair">
        {foreach from=$formFields item="field"}
          {if $field.name === 'email' || $field.name === 'password'}
            {block name='form_field'}
              {form_field field=$field}
            {/block}
          {/if}
        {/foreach}
      </div>

      {foreach from=$formFields item="field"}
        {if $field.name !== 'email' && $field.name !== 'password'}
          {form_field field=$field}
        {/if}
      {/foreach}
    {/block}

    {block name='login_form_footer'}
      <input type="hidden" name="submitLogin" value="1" tabindex="-1">

      <a class="q-auth__forgot" href="{$urls.pages.password}" rel="nofollow">
        {l s='I forgot my password' d='Shop.Theme.Customeraccount'}
      </a>

      <div class="q-auth__actions">
        {block name='form_buttons'}
          <button id="submit-login" class="q-btn q-btn--primary q-btn--lg" data-link-action="sign-in" type="submit" data-ps-action="form-validation-submit">
            {l s='Sign in' d='Shop.Theme.Actions'}
            <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
          </button>
        {/block}
      </div>
    {/block}
  </form>
{/block}
