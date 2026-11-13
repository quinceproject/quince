{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{block name='step'}
  {$previous_step = null}
  {$next_step = null}
  {$step_number = 0}
  {if isset($checkout_steps)}
    {foreach from=$checkout_steps item="step" key="index"}
      {if $step.identifier == $identifier}
        {$step_number = $index + 1}
        {if isset($checkout_steps[$index - 1])}
          {$previous_step = $checkout_steps[$index - 1]}
        {/if}
        {if isset($checkout_steps[$index + 1])}
          {$next_step = $checkout_steps[$index + 1]}
        {/if}
        {break}
      {/if}
    {/foreach}
  {/if}

  {* Karta kroku z makiety. Nazwy rdzenia (`step`, `tab-pane`, `collapse`,
     `js-current-step`, `show`) zostają obok nazw motywu: po nich kasa
     przełącza kroki i wie, który jest otwarty. *}
  <section
    id="{$identifier}"
    class="{[
      'step' => true,
      'tab-pane' => true,
      'collapse' => true,
      'q-step' => true,
      'q-step--current' => $step_is_current,
      'q-step--done' => $step_is_complete && !$step_is_current,
      'q-step--upcoming' => !$step_is_reachable && !$step_is_current,
      'step--current' => $step_is_current,
      'step--reachable' => $step_is_reachable,
      'step--complete' => $step_is_complete && !$step_is_current,
      'js-current-step' => $step_is_current,
      'active' => $step_is_current,
      'show' => $step_is_current
    ]|classnames}" role="tabpanel">

    {* Trzy warianty nagłówka (zwykły, otwarty, ukończony) stoją w DOM-ie
       naraz, chowane atrybutem `hidden`, a nie wycinane Smarty `{if}`-em:
       „Wstecz" przełącza krok wyłącznie w JS (`checkout-nav.js`), bez
       przeładowania strony, więc gdyby wariant nie istniał w HTML-u, JS nie
       miałby czego odkryć (po powrocie do wcześniejszego kroku brakowałoby
       „Change" i „Zaloguj się"). *}
    <div class="step__title js-step-title q-step__head">
      <p class="page-title-section q-step__title" data-q-step-title-plain{if $step_is_current || $step_is_complete} hidden{/if}>{$step_number}. {$title}</p>

      <h1 class="page-title-section q-step__title" data-q-step-title-open{if !$step_is_current} hidden{/if}>{$step_number}. {$title}</h1>

      <p class="page-title-section q-step__title" data-q-step-title-done{if !($step_is_complete && !$step_is_current)} hidden{/if}>
        <span class="q-step__done-badge" aria-hidden="true">
          <svg width="15" height="15" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m3 8 3.5 3.5L13 5"/></svg>
        </span>
        {$title}
      </p>

      {* Krok ukończony: zamiast czynności przy nazwie stoi „Zmień". Ten sam
         mechanizm co „Wstecz" (`js-back` + `data-step`), bo robi dokładnie to
         samo, wraca do tego kroku. Dla kroku bieżącego zostaje czynność
         właściwa temu krokowi, np. „Masz już konto? Zaloguj się". *}
      <button type="button" class="q-linkbtn js-back" data-step="{$identifier}" data-q-step-change{if !($step_is_complete && !$step_is_current)} hidden{/if}>
        {l s='Change' d='Shop.Theme.Actions'}
      </button>

      <span data-q-step-aside{if $step_is_complete && !$step_is_current} hidden{/if}>
        {block name='step_title_aside'}{/block}
      </span>
    </div>

    {* Krok ukończony pokazuje jedno zdanie zamiast pól: to, co klient już
       wybrał. Pełny formularz zostaje pod spodem w DOM-ie (kasa go chowa tą
       samą regułą co kroki nieaktualne), więc „Zmień" wraca do wypełnionych
       pól, a nie do pustych. *}
    <p class="q-step__summary" data-q-step-summary{if !($step_is_complete && !$step_is_current)} hidden{/if}>
      {block name='step_summary'}{/block}
    </p>

    <div class="step__content q-step__body">
      {block name='step_content'}DUMMY STEP CONTENT{/block}
    </div>
  </section>
{/block}
