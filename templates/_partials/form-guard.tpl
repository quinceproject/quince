{**
 * Quince: pola strażnika formularzy.
 *
 * Wstawiane wewnątrz każdego formularza, który ma być chroniony:
 *
 *     {include file='_partials/form-guard.tpl' form_id='contact'}
 *
 * Trzy pola: znacznik strony, nazwa formularza (do limitu powtórzeń) i pułapka.
 * Pułapka wygląda jak zwykłe pole adresu strony. Bot wypełnia wszystko, co
 * znajdzie, człowiek jej nie zobaczy i nie dojdzie do niej klawiszem Tab.
 *
 * Pod polami stoi miejsce na zapis dostawcy oceny (np. „chronione przez
 * reCAPTCHA"). Wypisuje go moduł dostawcy i tylko wtedy, gdy ocena działa.
 * Formularz, w którym pola strażnika stoją daleko od przycisku wysyłki, podaje
 * `notice=false` i wstawia hook `displayQuinceFormNotice` sam, przy przycisku.
 *
 * Obsługa po stronie sklepu: Quince\Engine\Form\FormGuard
 *}
{assign var=qg value=$modules.quince_engine.formGuard}

<input type="hidden" name="{$qg.fieldToken}" value="{$qg.token|escape:'html':'UTF-8'}">
<input type="hidden" name="{$qg.fieldForm}" value="{$form_id|escape:'html':'UTF-8'}">

<div class="q-formtrap" aria-hidden="true">
  <label for="{$qg.fieldTrap}-{$form_id|escape:'html':'UTF-8'}">{l s='Leave this field empty' d='Shop.Forms.Label'}</label>
  <input type="text" id="{$qg.fieldTrap}-{$form_id|escape:'html':'UTF-8'}"
         name="{$qg.fieldTrap}" value="" autocomplete="off" tabindex="-1">
</div>

{if $notice|default:true}
  {hook h='displayQuinceFormNotice' form_id=$form_id}
{/if}
