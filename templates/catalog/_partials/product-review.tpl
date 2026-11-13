{**
 * Quince: jedna opinia o produkcie.
 *
 * Osobny plik, bo rysują z niego dwa miejsca: pierwsza porcja wypisana przez
 * serwer i każda kolejna doładowana przyciskiem. Nie rysować opinii drugi raz
 * w JavaScripcie.
 *
 * Opinia jest jednym obiektem, nie zbiorem wierszy: nagłówek z inicjałami
 * otwiera wpis, ocena stoi w osobnej linii pod nazwiskiem, a stopka rozdziela
 * informację, ilu osobom opinia pomogła, i przycisk, którym się to zgłasza.
 *
 * Zmienne: $qOpinia: jedna pozycja z `Quince\Engine\Product\Reviews`,
 * $qPrzydatnosc: czy sklep zbiera głosy „przydatne".
 *}

<article class="q-review" data-q-review="{$qOpinia.id|intval}">
  <header class="q-review__head">
    <span class="q-review__avatar" aria-hidden="true">{$qOpinia.initials}</span>

    <span class="q-review__author">{$qOpinia.author}</span>

    <time class="q-review__date" datetime="{$qOpinia.dateIso}">{$qOpinia.date}</time>
  </header>

  <div class="q-review__body">
    {* Ocena w osobnej linii pod nazwiskiem, nie zepchnięta na prawą krawędź:
       przy szerokiej karcie gwiazdki lądowały pół ekranu od opinii, której
       dotyczą. *}
    <p class="q-review__stars q-rating">
      <span class="q-rating__stars" aria-hidden="true">
        {foreach from=$qOpinia.stars item=qStan}
          <span{if $qStan == 'full'} class="q-rating__star--filled"{/if}>&#9733;</span>
        {/foreach}
      </span>

      <span class="visually-hidden">
        {l s='Rated %grade% out of 5' sprintf=['%grade%' => $qOpinia.grade] d='Shop.Theme.Catalog'}
      </span>

      <data class="q-review__value" value="{$qOpinia.grade|intval}" aria-hidden="true">{$qOpinia.grade|intval}/5</data>
    </p>

    {if $qOpinia.title}
      <p class="q-review__title">{$qOpinia.title}</p>
    {/if}

    <p class="q-review__text">{$qOpinia.content|escape:'html':'UTF-8'|nl2br nofilter}</p>

    {* Stopka: po lewej informacja, po prawej działanie. Wcześniej jeden przycisk
       robił za jedno i drugie, więc licznik wyglądał na klikalny, a przycisk na
       etykietę. *}
    {if $qPrzydatnosc|default:false}
      <footer class="q-review__foot">
        <span class="q-review__helpful-count" data-q-review-helpful-count
              data-count="{$qOpinia.useful|intval}"
              {if $qOpinia.useful < 1}hidden{/if}>
          {l s='Helpful to %count% people' sprintf=['%count%' => $qOpinia.useful] d='Shop.Theme.Catalog'}
        </span>

        <button class="q-review__helpful-btn" type="button" data-q-review-helpful>
          {l s='This helped me' d='Shop.Theme.Actions'}
        </button>
      </footer>
    {/if}
  </div>
</article>
