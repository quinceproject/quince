{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='step'}
  {* Krok, do którego klient jeszcze nie doszedł. Rdzeń chowa go klasą
     `d-none`; w prototypie zostaje widoczny jako sama przygaszona nazwa
     z numerem, żeby klient widział, ile jeszcze przed nim. Klasa `d-none`
     zostaje w znacznikach, bo rdzeń po niej poznaje stan kroku. *}
  <section class="step step--unreachable d-none q-step q-step--upcoming" id="{$identifier}">
    <div class="step__title js-step-title q-step__head">
      <p class="page-title-section q-step__title">{$position}. {$title}</p>
    </div>
  </section>
{/block}
