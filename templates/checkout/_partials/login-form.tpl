{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file='customer/_partials/login-form.tpl'}

{block name='form_buttons'}
  {* W szufladzie przycisk nazywa się tym, co robi: „Zaloguj się". „Dalej"
     znaczy tu co innego niż na krokach kasy i myliłoby się z przejściem
     do następnego kroku. Pełna szerokość, bo to jedyna czynność w szufladzie. *}
  <button
    class="q-btn q-btn--primary q-btn--lg q-btn--block"
    name="continue"
    data-link-action="sign-in"
    type="submit"
    value="1"
    data-ps-action="form-validation-submit"
  >
    {l s='Sign in' d='Shop.Theme.Actions'}
  </button>
{/block}
