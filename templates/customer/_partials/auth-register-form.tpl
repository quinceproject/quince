{**
 * Quince: formularz na stronie rejestracji.
 *
 * Projekt: quince/makiety/rejestracja.html. Kolejność: zwrot grzecznościowy,
 * imię z nazwiskiem w parze, e-mail, hasło z datą urodzenia w parze, reszta
 * pól, zgody pod kreską, przycisk po prawej.
 *
 * Osobny plik, a nie gałąź w `customer-form.tpl`: tamten służy też danym
 * w koncie klienta i kasie, a te mają własne układy.
 *
 * Wszystkie pola rysuje `{form_field}` rdzenia, więc nazwy, wymagalność
 * i walidacja zostają takie, jak w PrestaShopie. Pola dołożone przez moduły
 * (zgody RODO, newsletter) wchodzą do zgód, jeśli są polem wyboru, a inne
 * pod parę z hasłem. Zostaje też hook modułów i zapora formularza silnika.
 *}
{block name='customer_form'}
<form
  action="{block name='customer_form_actionurl'}{$action}{/block}"
  class="js-customer-form q-auth__form"
  id="customer-form"
  method="post"
  data-ps-action="form-validation"
  aria-label="{l s='Your personal information' d='Shop.Theme.Customeraccount'}"
>
  {block name='customer_form_errors'}
    {if $errors['']|count}
      <div class="q-alert q-alert--danger" role="alert">
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0M7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0z"/></svg>
        <span>
          {foreach $errors[''] as $qBlad}{$qBlad}{if !$qBlad@last}<br>{/if}{/foreach}
        </span>
      </div>
    {/if}
  {/block}

  {block "form_fields"}
    {* Nazwy pól w formularzu: para otwiera się tylko wtedy, gdy oba pola
       pary są w formularzu. Inaczej pole stoi samo, przez całą szerokość. *}
    {assign var=qNazwy value=[]}
    {foreach from=$formFields item="f"}{append var=qNazwy value=$f.name}{/foreach}
    {assign var=qUlozone value=['id_gender', 'firstname', 'lastname', 'email', 'password', 'birthday']}

    {foreach from=$formFields item="field"}
      {if $field.name === 'id_gender'}{form_field field=$field}{/if}
    {/foreach}

    {if in_array('firstname', $qNazwy) && in_array('lastname', $qNazwy)}
      <div class="q-auth__pair">
        {foreach from=$formFields item="field"}
          {if $field.name === 'firstname'}{form_field field=$field}{/if}
        {/foreach}
        {foreach from=$formFields item="field"}
          {if $field.name === 'lastname'}{form_field field=$field}{/if}
        {/foreach}
      </div>
    {else}
      {foreach from=$formFields item="field"}
        {if $field.name === 'firstname' || $field.name === 'lastname'}{form_field field=$field}{/if}
      {/foreach}
    {/if}

    {foreach from=$formFields item="field"}
      {if $field.name === 'email'}{form_field field=$field}{/if}
    {/foreach}

    {if in_array('password', $qNazwy) && in_array('birthday', $qNazwy)}
      <div class="q-auth__pair">
        {foreach from=$formFields item="field"}
          {if $field.name === 'password'}<div data-ps-ref="password-field">{form_field field=$field}</div>{/if}
        {/foreach}
        {foreach from=$formFields item="field"}
          {if $field.name === 'birthday'}{form_field field=$field}{/if}
        {/foreach}
      </div>
    {else}
      {foreach from=$formFields item="field"}
        {if $field.name === 'password'}<div data-ps-ref="password-field">{form_field field=$field}</div>{/if}
        {if $field.name === 'birthday'}{form_field field=$field}{/if}
      {/foreach}
    {/if}

    {* Reszta pól, które nie są zgodami: firma, NIP, pola modułów. *}
    {foreach from=$formFields item="field"}
      {if !in_array($field.name, $qUlozone) && $field.type !== 'checkbox'}{form_field field=$field}{/if}
    {/foreach}

    {* Zgody razem, pod kreską: to jedna partia decyzji. *}
    {assign var=qZgody value=false}
    {foreach from=$formFields item="field"}
      {if $field.type === 'checkbox'}{assign var=qZgody value=true}{/if}
    {/foreach}
    {if $qZgody}
      <div class="q-auth__consents">
        {foreach from=$formFields item="field"}
          {if $field.type === 'checkbox'}{form_field field=$field}{/if}
        {/foreach}
      </div>
    {/if}

    {$hook_create_account_form nofilter}
  {/block}

  {block name='customer_form_footer'}
    {* Zapora silnika przed automatycznym zakładaniem kont. *}
    {include file='_partials/form-guard.tpl' form_id='register'}

    <input type="hidden" name="submitCreate" value="1">

    <div class="q-auth__actions">
      {block "form_buttons"}
        <button class="q-btn q-btn--primary q-btn--lg form-control-submit" data-link-action="save-customer" type="submit" data-ps-action="form-validation-submit">
          {l s='Sign up' d='Shop.Theme.Customeraccount'}
          <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
        </button>
      {/block}
    </div>
  {/block}
</form>
{/block}
