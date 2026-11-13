{**
 * Quince: treść sekcji pytań i odpowiedzi w akordeonie karty produktu.
 *
 * Pierwsza porcja wychodzi z serwera, więc widać ją bez JavaScriptu i czyta ją
 * wyszukiwarka. Przycisk dokłada kolejne w tym samym miejscu, a formularz
 * pytania otwiera się szufladą. Obsługuje je wyspa `islands/questions.js`.
 *
 * Dane przynosi moduł `quince_qa`. Na karcie stoją wyłącznie pytania
 * Z ODPOWIEDZIĄ: pytanie bez niej wygląda jak zignorowany klient.
 *}

{assign var=qQa value=$modules.quince_qa|default:null}

{if $qQa}
  <div class="q-qa"
       data-q-qa
       data-url="{$qQa.urlMore}"
       data-url-ask="{$qQa.url}"
       data-product="{$qQa.product|intval}"
       data-moderated="{if $qQa.moderated}1{else}0{/if}"
       data-msg-empty="{l s='Write your question first.' d='Shop.Theme.Catalog'}"
       data-msg-invalid="{l s='This is not a valid email address.' d='Shop.Theme.Catalog'}"
       data-msg-failure="{l s='The question could not be sent. Please try again in a moment.' d='Shop.Theme.Catalog'}"
       data-msg-moderated="{l s='We will answer it and publish the answer here.' d='Shop.Theme.Catalog'}"
       data-msg-sent="{l s='We will answer it as soon as we can.' d='Shop.Theme.Catalog'}">

    {if $qQa.items}
      <div class="q-qa__list" data-q-qa-list>
        {foreach from=$qQa.items item=qPytanie}
          {include file='catalog/_partials/product-qa-item.tpl' qPytanie=$qPytanie}
        {/foreach}
      </div>
    {else}
      <div class="q-empty">
        <p>{l s='No questions about this product yet.' d='Shop.Theme.Catalog'}</p>
      </div>
    {/if}

    <div class="q-qa__actions">
      {* Przycisk doładowania znika, gdy nie ma czego doładować: zostawiony
         obiecywałby więcej pytań, niż ich jest. *}
      {if $qQa.hasMore}
        <button class="q-btn q-btn--ghost q-btn--sm" type="button" data-q-qa-more>
          {l s='Show all questions' d='Shop.Theme.Actions'}
        </button>
      {/if}

      {* Przycisk pytania stoi tylko wtedy, gdy moduł na pewno przyjmie pytanie.
         Przy wyłączonych pytaniach od gości kończyłby się odmową, więc
         niezalogowany dostaje w tym miejscu drogę do konta. *}
      {if $qQa.canAsk}
        <button class="q-btn q-btn--secondary q-btn--sm" type="button" data-q-qa-open>
          {l s='Ask a question' d='Shop.Theme.Actions'}
        </button>
      {else}
        <a class="q-btn q-btn--secondary q-btn--sm"
           href="{$urls.pages.authentication}?back={$urls.current_url|urlencode}">
          {l s='Sign in to ask a question' d='Shop.Theme.Catalog'}
        </a>
      {/if}
    </div>

    {if $qQa.canAsk}
      {include file='catalog/_partials/product-qa-form.tpl' qIntro=$qQa.intro}
    {/if}
  </div>
{/if}
