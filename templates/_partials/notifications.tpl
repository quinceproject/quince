{**
 * Powiadomienia PrestaShopa jako toasty przy prawej górnej krawędzi.
 *
 * Renderowane po stronie serwera, nie dorzucane skryptem: komunikat po
 * przekierowaniu ma być widoczny także wtedy, gdy JavaScript nie wstanie.
 * Wyspa dokłada tylko zamykanie i samoznikanie.
 *
 * Błąd i ostrzeżenie dostają `role="alert"`: czytnik ekranu przerywa wtedy
 * to, co czyta. Sukces i informacja idą przez `aria-live="polite"` na
 * opakowaniu, więc doczekają końca zdania.
 *}
{if isset($notifications) && ($notifications.error || $notifications.warning || $notifications.success || $notifications.info)}
  <div class="q-toasts" data-q-toasts aria-live="polite">
    {foreach from=['danger' => $notifications.error, 'warning' => $notifications.warning, 'success' => $notifications.success, 'info' => $notifications.info] key=qTyp item=qKomunikaty}
      {if $qKomunikaty}
        <div class="q-toast q-toast--{$qTyp}" data-q-toast data-q-typ="{$qTyp}"
             {if $qTyp == 'danger' || $qTyp == 'warning'}role="alert"{/if}>
          <svg class="q-toast__icon" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
            {if $qTyp == 'success'}
              <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
              <path d="m10.97 4.97-.02.022-3.473 4.425-2.093-2.094a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05"/>
            {elseif $qTyp == 'warning'}
              <path d="M7.938 2.016A.13.13 0 0 1 8.002 2a.13.13 0 0 1 .063.016.15.15 0 0 1 .054.057l6.857 11.667c.036.06.035.124.002.183a.2.2 0 0 1-.054.06.1.1 0 0 1-.066.017H1.146a.1.1 0 0 1-.066-.017.2.2 0 0 1-.054-.06.18.18 0 0 1 .002-.183L7.884 2.073a.15.15 0 0 1 .054-.057m1.044-.45a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767z"/>
              <path d="M7.002 12a1 1 0 1 1 2 0 1 1 0 0 1-2 0M7.1 5.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0z"/>
            {elseif $qTyp == 'danger'}
              <path d="M4.54.146A.5.5 0 0 1 4.893 0h6.214a.5.5 0 0 1 .353.146l4.394 4.394a.5.5 0 0 1 .146.353v6.214a.5.5 0 0 1-.146.353l-4.394 4.394a.5.5 0 0 1-.353.146H4.893a.5.5 0 0 1-.353-.146L.146 11.46A.5.5 0 0 1 0 11.107V4.893a.5.5 0 0 1 .146-.353zM5.1 1 1 5.1v5.8L5.1 15h5.8l4.1-4.1V5.1L10.9 1z"/>
              <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0M7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0z"/>
            {else}
              <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
              <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/>
            {/if}
          </svg>

          <div class="q-toast__body">
            {if $qKomunikaty|count > 1}
              <ul>
                {foreach $qKomunikaty as $qTresc}
                  <li>{$qTresc nofilter}</li>
                {/foreach}
              </ul>
            {else}
              {$qKomunikaty.0 nofilter}
            {/if}
          </div>

          <button class="q-toast__close" type="button" data-q-toast-zamknij
                  aria-label="{l s='Close' d='Shop.Theme.Global'}">
            <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
              <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
            </svg>
          </button>
        </div>
      {/if}
    {/foreach}
  </div>
{/if}
