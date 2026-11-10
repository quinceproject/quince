{**
 * Quince: dokładanie produktów przyciskiem.
 *
 * Drugi rodzaj stronicowania, do wyboru w panelu obok ponumerowanych stron.
 * Zamiast przejść na kolejną stronę klient dokłada następną porcję do tej samej
 * listy.
 *
 * Przycisk jest ODNOŚNIKIEM do następnej strony, a nie samym przyciskiem:
 * bez JavaScriptu prowadzi tam, gdzie prowadziłoby stronicowanie, a wyszukiwarka
 * ma po czym zejść w głąb listy. Skrypt przechwytuje kliknięcie dopiero wtedy,
 * gdy jest czym przechwycić.
 *
 * Na końcu listy przycisk zostaje na miejscu, wyłączony. Znikający przycisk
 * zostawia klienta bez odpowiedzi, czy lista się skończyła, czy coś się zacięło.
 *
 * Blok zostaje w kodzie strony także wtedy, gdy lista mieści się na jednej
 * stronie, i jest wtedy schowany. Zawężenie listy podmienia u klienta samą
 * siatkę, nie tę strefę, więc bloku, który by tu nie powstał, skrypt nie
 * miałby jak przywrócić po zdjęciu zawężenia.
 *
 * Zdania licznika idą też w `data-tpl` z nietkniętymi znacznikami, żeby skrypt
 * przestawiał w nich liczby tymi samymi zdaniami, a nie drugimi, własnymi.
 *
 * Klasy: components/listing.css, components/button.css
 *}
{assign var=qNastepna value=''}
{foreach from=$pagination.pages|default:[] item=qStrona}
  {if $qStrona.type == 'next' && $qStrona.clickable}{assign var=qNastepna value=$qStrona.url}{/if}
{/foreach}

{assign var=qIleStron value=$pagination.pages_count|default:1}
{assign var=qLicznik value={l s='%shown% of %total% products' d='Shop.Theme.Catalog'}}
{assign var=qKoniec value={l s='All %total% products shown' d='Shop.Theme.Catalog'}}

<div class="q-more" data-q-more{if $qIleStron <= 1} hidden{/if}>
  <a class="q-btn q-btn--primary q-btn--lg q-more__btn"
     {if $qNastepna}href="{$qNastepna}" rel="next"{else}aria-disabled="true"{/if}
     data-q-more-link>
    <span class="q-btn__label">{l s='Show more products' d='Shop.Theme.Actions'}</span>
  </a>

  <p class="q-more__count" data-q-more-count
     data-tpl="{$qLicznik|escape:'html'}"
     data-tpl-end="{$qKoniec|escape:'html'}">
    {if $qNastepna}
      {$qLicznik|replace:'%shown%':$pagination.items_shown_to|replace:'%total%':$pagination.total_items}
    {else}
      {$qKoniec|replace:'%total%':$pagination.total_items}
    {/if}
  </p>
</div>
