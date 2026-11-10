{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends "customer/_partials/customer-form.tpl"}

{* Podpowiedzi rdzenia pod polami, w rodzaju „Only letters and the dot (.)
   character", opisują regułę walidacji, a nie to, co klient ma zrobić.
   W kasie ich nie pokazujemy: komunikat pojawia się dopiero wtedy, gdy pole
   naprawdę jest błędne, i mówi wprost, co poprawić. *}
{block "form_field"}
  {* Kasa pyta o to, czego potrzebuje do wysłania zamówienia: e-mail, imię
     i nazwisko. Zwrot grzecznościowy i data urodzenia to dane do profilu
     klienta, nie do przesyłki — pytamy o nie w koncie, nie przy zakupie.
     Każde dodatkowe pole w kasie to kolejny powód, żeby jej nie dokończyć. *}
  {if in_array($field.name, ['id_gender', 'birthday'])}

  {elseif $field.name === 'optin'}
    {* „Chcę dostawać oferty partnerów" stoi w prototypie PO newsletterze, nie
       przed nim — moduły dokładają oba pola hookami w odwrotnej kolejności.
       Przechwytujemy to pole tutaj i oddajemy je dopiero przy polu
       newslettera, zamiast przestawiać kolejność wykonania hooków. *}
    {capture name="qOptin"}{$smarty.block.parent}{/capture}
    {$qOptinHtml = $smarty.capture.qOptin}

  {elseif $field.name === 'newsletter'}
    {$smarty.block.parent}
    {if isset($qOptinHtml)}{$qOptinHtml nofilter}{/if}

  {elseif $field.name === 'customer_privacy'}
    {* Notka `ps_dataprivacy` ma stać zawsze bezpośrednio przy zgodzie
       `psgdpr` — obie mówią o tym samym (przetwarzaniu danych), więc nie mogą
       rozjechać się po formularzu zależnie od przypadkowej kolejności
       wykonania hooków dwóch różnych modułów. Przechwytujemy JEJ TREŚĆ
       i oddajemy dopiero przy polu `psgdpr`, niezależnie od tego, które
       z nich rdzeń przetworzy jako pierwsze — ale ukryte pole formularza
       zostaje tutaj, na swoim miejscu: pole jest wymagane, więc bez niego
       formularz nie przejdzie walidacji serwera. *}
    <input type="hidden" name="{$field.name}" value="1">
    {capture name="qPrywatnoscKlauzula"}{$field.label nofilter}{/capture}
    {$qPrywatnoscKlauzulaHtml = $smarty.capture.qPrywatnoscKlauzula}

  {elseif $field.name === 'psgdpr'}
    {* Przetworzenie danych z tego formularza jest warunkiem złożenia
       zamówienia — bez adresu i e-maila nic się nie wyśle. Klient nie ma tu
       realnego wyboru, więc podstawą nie jest zgoda (wymagająca aktywnego
       kliknięcia), tylko wykonanie umowy: wystarczy jasna informacja, nie
       checkbox. Pole jedzie zaznaczone i ukryte — tak samo jak
       `customer_privacy` wyżej — a klient dostaje samą klauzulę, tę samą,
       którą zapisuje `GDPRLog` przy zgodach klikanych ręcznie.

       Decyzja usera, nie domyślne zachowanie modułu: panel psgdpr nie
       rozróżnia kasy od rejestracji, więc to rozróżnienie robi ten plik —
       i tylko ten plik. Standalone `/rejestracja` korzysta z osobnego
       szablonu bez tego nadpisania, więc tam `psgdpr` zostaje prawdziwym,
       klikanym checkboksem. *}
    <input type="hidden" name="{$field.name}" value="1">

    {if isset($qPrywatnoscKlauzulaHtml)}
      <p class="q-checkout2__notice">{$qPrywatnoscKlauzulaHtml nofilter}</p>
    {/if}

    {* Treść zgody, razem z linkiem do polityki prywatności, sklep wpisuje
       w panelu psgdpr, osobno dla każdego języka. Wyświetlamy ją bez zmian. *}
    <p class="q-checkout2__notice">{$field.label nofilter}</p>

  {elseif $field.name === 'password' and $guest_allowed}
    {* Konto zakłada się jednym hasłem i jest to wybór, nie wymóg: pole hasła
       wychodzi dopiero po zaznaczeniu. Puste hasło znaczy zamówienie jako
       gość, a tak działa rdzeń przy włączonych zamówieniach gości. *}
    <div class="mb-3">
      <label class="q-choice" for="password-form__check">
        <input class="js-password-form__check q-choice__input" id="password-form__check" type="checkbox" name="password-form__check">
        <span class="q-choice__label">
          {l s='Create an account' d='Shop.Theme.Checkout'} <span class="q-opt">{l s='(optional)' d='Shop.Theme.Checkout'}</span>
          <small>{l s='Just a password. You get your order history and invoices in one place.' d='Shop.Theme.Checkout'}</small>
        </span>
      </label>

      <div class="js-password-form__input-wrapper d-none mt-3">
        {$smarty.block.parent}
      </div>
    </div>

  {else}
    {$smarty.block.parent}
  {/if}
{/block}

{block "form_buttons"}
  {* Pola strażnika (token, pułapka) bez zapisu: zapis o ochronie stoi osobno,
     nad stopką strony (`checkout.tpl`) — to nie jest zgoda, więc nie siedzi
     przy polu z checkboxami wyżej. *}
  {include file='_partials/form-guard.tpl' form_id='checkout' notice=false}

  {* Przycisk przejścia dalej przy prawej krawędzi, jak w pozostałych krokach. *}
  <div class="buttons-wrapper">
    <button
      class="btn btn-primary"
      name="continue"
      data-link-action="register-new-customer"
      type="submit"
      value="1"
      data-ps-action="form-validation-submit"
    >
      {l s='Continue' d='Shop.Theme.Actions'}
    </button>
  </div>
{/block}
