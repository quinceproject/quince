{**
 * Quince — ocena produktu pod jego nazwą
 *
 * Jeden wiersz: gwiazdki, średnia i odnośnik do opinii. Makieta stawia tu
 * wyłącznie ocenę — producent i numer katalogowy zeszły do kolumny opisu,
 * a EAN i MPN do specyfikacji.
 *
 * Bez ani jednej opinii zostaje samo zaproszenie do napisania pierwszej: pusta
 * skala pięciu szarych gwiazdek mówiłaby „oceniony na zero".
 *
 * Dane liczy silnik (Quince\Engine\Product\Rating) z tabel modułu opinii.
 * Bez tego modułu `$qOcena` jest puste i nie renderuje się nic.
 *}

{assign var=qOcena value=$modules.quince_engine.rating|default:null}

{if $qOcena}
  <div class="q-pdp__meta">
    {if $qOcena.count > 0}
      {* Całość jest jednym odnośnikiem, nie samą liczbą w nawiasie: gwiazdki
         wyglądają na klikalne i klient w nie celuje, więc mają prowadzić tam,
         gdzie prowadzi napis obok. Wyspa otwiera sekcję przed skokiem. *}
      <a class="q-pdp__meta-item q-rating q-rating--link"
         href="#q-section-opinie" data-q-do-sekcji>
        <span class="q-rating__stars" aria-hidden="true">
          {foreach from=$qOcena.stars item=qStan}
            <span{if $qStan == 'full'} class="q-rating__star--filled"{elseif $qStan == 'half'} class="q-rating__star--half"{/if}>&#9733;</span>
          {/foreach}
        </span>

        {* Czytnik ekranu dostaje liczbę, a nie pięć znaków gwiazdki. *}
        <span class="visually-hidden">
          {l s='Rated %grade% out of 5' sprintf=['%grade%' => $qOcena.average] d='Shop.Theme.Catalog'}
        </span>

        {* `aria-hidden`, bo zdanie wyżej mówi już czytnikowi to samo. Bez tego
           odczyt brzmiał „oceniony na 4,5 na 5, 4,5, 2 opinie". *}
        <span class="q-rating__value" aria-hidden="true">{$qOcena.averageText}</span>

        {* Liczba opinii w nawiasie: obok średniej stały dwie liczby bez niczego
           pomiędzy i czytało się to jak jedna. *}
        <span class="q-rating__count">
          ({l s='%count% reviews' sprintf=['%count%' => $qOcena.count] d='Shop.Theme.Catalog'})
        </span>
      </a>
    {else}
      <span class="q-pdp__meta-item">
        <a href="#q-section-opinie" data-q-do-sekcji>{l s='Write the first review' d='Shop.Theme.Catalog'}</a>
      </span>
    {/if}
  </div>
{/if}
