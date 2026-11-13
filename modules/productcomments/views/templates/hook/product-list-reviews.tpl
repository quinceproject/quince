{**
 * Quince: ocena na zajawce produktu.
 *
 * Gwiazdki i ocena liczbowa z liczbą opinii w nawiasie:
 * „4,8 (47)".
 *
 * Wartości przychodzą GOTOWE z silnika, policzone jednym zapytaniem dla całej
 * strony listingu (hook `filterProductSearch`). Moduł opinii dociąga je
 * skryptem, co miało trzy wady: ocena pojawiała się z opóźnieniem i lista
 * podskakiwała, średnia nie trafiała do kodu strony, więc nie widziała jej
 * wyszukiwarka, a przy włączonym sklejaniu plików skrypt modułu w ogóle nie
 * dojeżdżał do przeglądarki.
 *
 * Dwie warstwy gwiazdek: szara na spodzie i złota na wierzchu, przycięta do
 * ułamka oceny. Dzięki temu 4,4 wygląda inaczej niż 4,8, czego sama liczba
 * obok nie pokazuje. Obie warstwy mają te same znaczniki, więc nie ma jak się
 * rozjechać.
 *
 * Produkt bez opinii nie renderuje nic: pusty wiersz na zajawce byłby gorszy
 * niż jego brak.
 *}

{assign var=qOcena value=$listing.quince_ratings[$product.id_product]|default:null}

{if $qOcena && $qOcena.ile > 0}
  {capture assign='qGwiazdki'}{section name=g start=0 loop=5}<svg class="q-pcard__star" viewBox="0 0 16 16" aria-hidden="true"><path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z"/></svg>{/section}{/capture}

  <div class="q-pcard__rating">
    <span class="q-pcard__stars"
          role="img" aria-label="{l s='Rated %grade% out of 5' d='Shop.Theme.Catalog' sprintf=['%grade%' => $qOcena.srednia]}">
      <span class="q-pcard__stars-empty">{$qGwiazdki nofilter}</span>
      <span class="q-pcard__stars-full" style="inline-size: {($qOcena.srednia / 5 * 100)|string_format:"%.2f"}%">{$qGwiazdki nofilter}</span>
    </span>

    <span class="q-pcard__rating-count">
      {$qOcena.srednia|string_format:"%.1f"|replace:'.':','} ({$qOcena.ile})
    </span>
  </div>
{/if}
