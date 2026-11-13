{**
 * Quince: jedno pytanie o produkt razem z odpowiedzią sklepu.
 *
 * Osobny plik, bo rysują z niego dwa miejsca: pierwsza porcja wypisana przy
 * wydaniu strony i każda kolejna doładowana przyciskiem. Nie rysować pytania
 * drugi raz w JavaScripcie.
 *
 * Pytanie i odpowiedź to JEDEN wątek, nie dwa wiersze obok siebie. Nagłówek
 * z inicjałami trzyma pytanie razem, a odpowiedź stoi w oddzielnym bloku
 * z własnym tłem i kreską.
 *
 * Zmienne: $qPytanie: jedna pozycja z `Quince\Qa\Settings\QaPresenter`.
 *}

<article class="q-qa__thread" data-q-qa-item="{$qPytanie.id|intval}">
  <header class="q-qa__head">
    <span class="q-qa__avatar" aria-hidden="true">{$qPytanie.initials}</span>

    <span class="q-qa__author">{$qPytanie.author}</span>

    <time class="q-qa__date" datetime="{$qPytanie.dateIso}">{$qPytanie.date}</time>
  </header>

  <p class="q-qa__question">{$qPytanie.question|escape:'html':'UTF-8'|nl2br nofilter}</p>

  {* Blok odpowiedzi zaczyna się mikropodpisem: to on nazywa, czyj to głos,
     zanim ktokolwiek przeczyta treść. *}
  <div class="q-qa__answer">
    <p class="q-qa__answer-label">{l s='Answer from the shop' d='Shop.Theme.Catalog'}</p>

    <p class="q-qa__answer-text">{$qPytanie.answer|escape:'html':'UTF-8'|nl2br nofilter}</p>

    {if $qPytanie.answerAuthor}
      <p class="q-qa__answer-by">{$qPytanie.answerAuthor}</p>
    {/if}
  </div>
</article>
