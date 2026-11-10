{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='customer_form'}
  {block name='customer_form_errors'}
    {include file='_partials/form-errors.tpl' errors=$errors['']}
  {/block}

<form 
  action="{block name='customer_form_actionurl'}{$action}{/block}" 
  class="js-customer-form" 
  id="customer-form" 
  method="post" 
  data-ps-action="form-validation"
  aria-label="{l s='Your personal information' d='Shop.Theme.Customeraccount'}"
>
  {block "form_fields"}
    {if $page.page_name === 'identity'}
      {* Dane osobowe: jeden formularz, jeden zapis (rdzeń zapisuje wszystkie
         pola naraz — dwa osobne submity ryzykowałyby wyzerowanie reszty
         danych przy samej zmianie hasła), ale trzy wizualne sekcje jak
         w makiecie. Każdy przebieg filtruje te same `$formFields`, więc
         pole dopisane hookiem (np. zgoda modułu) trafia do „Preferencji"
         bez znajomości jego nazwy z góry. *}
      {assign var=qPodstawowe value=['id_gender', 'firstname', 'lastname', 'email', 'birthday', 'company', 'siret']}
      {assign var=qHaslo value=['password', 'new_password']}
      {assign var=qNazwy value=[]}
      {foreach from=$formFields item="f"}{append var=qNazwy value=$f.name}{/foreach}
      {assign var=qOtwarty value=false}

      <div class="q-identity-group">
        <h2 class="q-identity-heading">{l s='Basic information' d='Shop.Theme.Customeraccount'}</h2>
        <section class="q-account-section q-card q-identity-section">
          <div class="q-identity-fields q-card__body">
            {* E-mail pierwszy: to on decyduje, czy klient ma u nas konto, i na
               niego idzie potwierdzenie zamówienia — ten sam porządek, co
               w pozostałych kontekstach tego formularza (niżej). *}
            {foreach from=$formFields item="field"}
              {if $field.name === 'email'}{form_field field=$field}{/if}
            {/foreach}

            {foreach from=$formFields item="field"}
              {if !in_array($field.name, $qPodstawowe)}{continue}{/if}
              {if $field.name === 'email'}{continue}{/if}
              {if $field.name === 'firstname' && !$qOtwarty && in_array('lastname', $qNazwy)}
                <div class="q-checkout2__row q-checkout2__row--firstname">
                {assign var=qOtwarty value=true}
              {/if}

              {form_field field=$field}

              {if $qOtwarty && $field.name === 'lastname'}
                </div>
                {assign var=qOtwarty value=false}
              {/if}
            {/foreach}
            {if $qOtwarty}</div>{/if}
          </div>
        </section>
      </div>

      {if in_array('password', $qNazwy) || in_array('new_password', $qNazwy)}
        <div class="q-identity-group">
          <h2 class="q-identity-heading">{l s='Password' d='Shop.Forms.Labels'}</h2>
          <section class="q-account-section q-card q-identity-section">
            <div class="q-identity-fields q-card__body">
              {foreach from=$formFields item="field"}
                {if !in_array($field.name, $qHaslo)}{continue}{/if}
                {if $field.name === 'new_password'}
                  <div data-ps-ref="password-field">
                    {form_field field=$field}
                  </div>
                {else}
                  {form_field field=$field}
                {/if}
              {/foreach}
            </div>
          </section>
        </div>
      {/if}

      {assign var=qResztaIstnieje value=false}
      {foreach from=$formFields item="field"}
        {if !in_array($field.name, $qPodstawowe) && !in_array($field.name, $qHaslo)}
          {assign var=qResztaIstnieje value=true}
        {/if}
      {/foreach}

      {if $qResztaIstnieje || $hook_create_account_form}
        <div class="q-identity-group">
          <h2 class="q-identity-heading">{l s='Preferences' d='Shop.Theme.Customeraccount'}</h2>
          <section class="q-account-section q-card q-identity-section">
            <div class="q-identity-fields q-card__body">
              {foreach from=$formFields item="field"}
                {if in_array($field.name, $qPodstawowe) || in_array($field.name, $qHaslo)}{continue}{/if}
                {form_field field=$field}
              {/foreach}
              {$hook_create_account_form nofilter}
            </div>
          </section>
        </div>
      {/if}
    {else}
      <section>
        {* Imię z nazwiskiem w jednym wierszu: razem tworzą jedną daną. Para
           otwiera się na pierwszym polu i zamyka na drugim, a gdy drugiego nie ma
           w formularzu, wiersz się nie otwiera. *}
        {assign var=qNazwy value=[]}
        {foreach from=$formFields item="f"}{append var=qNazwy value=$f.name}{/foreach}
        {assign var=qOtwarty value=false}

        {* E-mail pierwszy: to on decyduje, czy klient ma u nas konto, i na niego
           idzie potwierdzenie zamówienia. Rdzeń stawia go za imieniem
           i nazwiskiem, bo buduje formularz z polą encji, nie z kolejności
           pytań. *}
        {foreach from=$formFields item="field"}
          {if $field.name === 'email'}
            {block "form_field_email"}{form_field field=$field}{/block}
          {/if}
        {/foreach}

        {foreach from=$formFields item="field"}
          {if $field.name === 'email'}{continue}{/if}
          {if $field.name === 'firstname' && !$qOtwarty && in_array('lastname', $qNazwy)}
            <div class="q-checkout2__row q-checkout2__row--firstname">
            {assign var=qOtwarty value=true}
          {/if}

          {block "form_field"}
            {if $field.type === "password"}
              <div data-ps-ref="password-field">
                {form_field field=$field}
              </div>
            {else}
              {form_field field=$field}
            {/if}
          {/block}

          {if $qOtwarty && $field.name === 'lastname'}
            </div>
            {assign var=qOtwarty value=false}
          {/if}
        {/foreach}
        {if $qOtwarty}</div>{/if}
        {$hook_create_account_form nofilter}
      </section>
    {/if}
  {/block}

  {block name='customer_form_footer'}
    {* Zapory silnika tylko przy zakładaniu konta. Ten sam formularz służy do
       edycji danych w koncie i do danych w kasie, a tam pisze klient, który
       już jest w sklepie. *}
    {if $page.page_name == 'registration'}
      {include file='_partials/form-guard.tpl' form_id='register'}
    {/if}

    <input type="hidden" name="submitCreate" value="1">

    <footer class="buttons-wrapper buttons-wrapper--end">
      {block "form_buttons"}
        <button class="btn btn-primary form-control-submit" data-link-action="save-customer" type="submit" data-ps-action="form-validation-submit">
        {if isset($mode) && $mode === "register"}
          {l s='Create account' d='Shop.Theme.Actions'}
        {else}
          {l s='Save' d='Shop.Theme.Actions'}
        {/if}
        </button>
      {/block}
    </footer>
  {/block}
</form>
{/block}
