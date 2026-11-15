{**
 * Quince: cechy podstawowe produktu
 *
 * Krótka lista „nazwa: wartość" pod opisem skróconym.
 *
 * Kolejność podaje silnik w `$modules.quince_engine.features`: to lista nazw
 * cech ustawiona przez moduł rankingu, który liczy, które cechy naprawdę
 * odróżniają produkty w tej kategorii. Gdy modułu nie ma, lista jest pusta
 * i bierzemy cechy w kolejności katalogu.
 *
 * To NIE jest tabela specyfikacji, choć pokazuje to samo w tej samej postaci.
 * Tam struktura bywa dowolna, więc rysuje siatkę; tutaj jest znana z góry
 * (po lewej nazwa, po prawej wartość), więc struktury nie trzeba obrysowywać.
 *
 * Zmienne: $qLink:    włącznik odnośnika „Pełna specyfikacja",
 *          $qIle:     ile wierszy pokazujemy (ustawienie elementu w panelu),
 *          $qWiersze: same wiersze, bez własnego zestawienia i bez odnośnika.
 *                     Zajawka w widoku listy wkłada je do JEDNEGO zestawienia
 *                     razem z marką i kodami, żeby podział na kolumny wypadał
 *                     w połowie wierszy.
 *}

{if $product.grouped_features}
  {assign var=qIle value=$qIle|default:5}
  {* Kolejność cech. Na karcie produktu silnik podaje ją w zmiennych strony,
     bo produkt jest jeden. Zajawka na listingu przysyła ją w `qKolejnosc`,
     bo każdy produkt na liście może stać w innej kategorii i mieć własny
     ranking. *}
  {if !isset($qKolejnosc)}
    {assign var=qKolejnosc value=$modules.quince_engine.features|default:[]}
  {/if}

  {* Gdy kategoria ma ranking, pokazujemy WYŁĄCZNIE cechy z niego. Dopychanie
     listy do limitu resztą z katalogu wracałoby dokładnie tym, co ranking
     odrzucił: cechą o jednej wartości u wszystkich i numerem katalogowym.

     Bez rankingu (brak modułu albo kategoria nieprzeliczona) bierzemy cechy
     w kolejności katalogu. *}
  {assign var=qCechy value=[]}
  {if $qKolejnosc}
    {foreach from=$qKolejnosc item=qNazwa}
      {foreach from=$product.grouped_features item=qC}
        {if $qC.name == $qNazwa}{append var=qCechy value=$qC}{/if}
      {/foreach}
    {/foreach}
  {else}
    {assign var=qCechy value=$product.grouped_features}
  {/if}

  {* Ile wierszy naprawdę wypiszemy: krótsza z dwóch liczb, bo ranking bywa
     krótszy od limitu. Smarty nie ma wyrażenia warunkowego w `assign`, stąd `if`. *}
  {assign var=qPokazane value=$qCechy|count}
  {if $qPokazane > $qIle}{assign var=qPokazane value=$qIle}{/if}

  {capture assign='qWierszeHtml'}
    {foreach from=$qCechy item=qCecha name=cechy}
      {if $smarty.foreach.cechy.iteration <= $qPokazane}
        <div class="q-facts__row">
          <dt class="q-facts__key">{$qCecha.name}</dt>
          <dd class="q-facts__val">{$qCecha.value|htmlspecialchars|nl2br nofilter}</dd>
        </div>
      {/if}
    {/foreach}
  {/capture}

  {if $qWiersze|default:false}
    {$qWierszeHtml nofilter}
  {else}
  <div class="q-facts">
    <dl class="q-facts__list">{$qWierszeHtml nofilter}</dl>

    {* Odnośnik prowadzi do zakładki ze szczegółami, więc pojawia się wtedy,
       gdy jest tam co pokazać ponad to, co już widać. Porównujemy z liczbą
       WYPISANYCH wierszy, a nie z ustawionym limitem: przy rankingu cech lista
       bywa krótsza od limitu, a w specyfikacji i tak zostaje reszta cech. *}
    {if $qLink|default:true && $product.grouped_features|count > $qPokazane}
      <a class="q-facts__more" href="#q-section-details" data-q-do-sekcji>
        <span>
          {l s='Full specification' d='Shop.Theme.Catalog'}
          <svg class="q-facts__chev" viewBox="0 0 16 16" fill="currentColor"
               aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
        </span>
      </a>
    {elseif $qCechy}
      {* Nie ma czego pokazać dalej, ale kreska zostaje: zamyka listę cech
         i oddziela ją od tego, co pod nią, tak samo jak przy odnośniku.
         Bez niej blok kończył się w powietrzu. *}
      <div class="q-facts__kreska" aria-hidden="true"></div>
    {/if}
  </div>
  {/if}
{/if}
