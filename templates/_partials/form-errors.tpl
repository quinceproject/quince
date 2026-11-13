{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{if $errors|count}
  {* Błąd pola stoi pod tym polem, jednym zdaniem.
     Rdzeń rysuje tu ramkę alertu z przyciskiem zamknięcia; przy polu, które
     ma już czerwoną ramkę, drugie pudełko powtarza to samo i rozbija rząd. *}
  {block name='form_errors'}
    <div class="q-fld-err" role="alert">
      {foreach $errors as $error}
        <span>{$error|nl2br nofilter}</span>
      {/foreach}
    </div>
  {/block}
{/if}
