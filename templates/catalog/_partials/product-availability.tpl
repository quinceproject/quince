{**
 * Quince: dostępność i wysyłka.
 *
 * Ten sam kształt co cechy i kody: nazwa po lewej, wartość po prawej. To są
 * fakty tego samego rodzaju, więc nie zasługują na osobny wzór na tej samej
 * karcie. Wcześniej stan był pigułką, a termin wiersz tekstu z ikoną.
 *
 * Barwa zostaje na kropce i na słowie stanu, bo stan rozpoznaje się rzutem oka.
 * Ale niesie go TAKŻE słowo: „Chwilowo niedostępny" znaczy to samo bez patrzenia
 * na kolor.
 *
 * Pod spodem zostaje hook PrestaShopa, w którym moduły sklepu dokładają swoje
 * bloki. Zapis na powiadomienie o dostępności nie stoi już tutaj: należy do
 * wiersza zakupu, bo jest działaniem, a stan magazynu jest faktem.
 *
 * Projekt: makieta strony produktu.
 *
 * W panelu zakupu ta sama treść idzie jedną zwartą linijką, nie tabelą:
 * panel ma 362 px, a forma „nazwa po lewej, wartość po prawej" zjada tam dwa
 * wiersze na to, co mieści się w jednym. Treść jest ta sama, zmienia się układ.
 *
 * Zmienne: $qStan, $qWysylka, $qIlosc — włączniki z panelu; $qZwarty — czy element
 * stoi w kolumnie zakupu.
 *}

{assign var=qDostepnosc value=$product.availability|default:''}

{* Nazwy stanów przychodzą z rdzenia: `in_stock` przy towarze na stanie,
   `last_remaining_items` przy końcówce, a przy braku `out_of_stock`,
   `unavailable` albo `discontinued`. Sprawdzone na sklepie, bo w kodzie
   presentera bywa też `available`. *}
{if $qDostepnosc == 'in_stock' || $qDostepnosc == 'available'}
  {assign var=qKlasaStanu value='q-stock--in'}
{elseif $qDostepnosc == 'last_remaining_items'}
  {assign var=qKlasaStanu value='q-stock--low'}
{else}
  {assign var=qKlasaStanu value='q-stock--out'}
{/if}

{assign var=qMaStan value=(($qStan|default:true) && $product.availability_message)}
{assign var=qMaWysylke value=(($qWysylka|default:true) && $product.delivery_information)}
{assign var=qMaIlosc value=(($qIlosc|default:false) && $product.quantity > 0 && ($qDostepnosc == 'in_stock' || $qDostepnosc == 'available'))}

{if ($qMaStan || $qMaWysylke || $qMaIlosc) && ($qZwarty|default:false)}
  {* Jeden wiersz: stan, ile sztuk, termin wysyłki. Kropki rozdzielające rysuje
     styl, więc wyłączenie którejkolwiek części nie zostawia wiszącego znaku. *}
  <p class="q-stock-line">
    {if $qMaStan}
      <span class="q-stock {$qKlasaStanu}">
        <span class="q-stock__dot" aria-hidden="true"></span>{$product.availability_message}
      </span>
    {/if}

    {if $qMaIlosc}
      <span class="q-stock-line__qty">
        {l s='%count% pcs.' sprintf=['%count%' => $product.quantity] d='Shop.Theme.Catalog'}
      </span>
    {/if}

    {* Sam tekst z ustawień sklepu, bez dopisywanej nazwy. Całość wpisuje
       sprzedawca w informacjach o produktach — globalnie albo przy produkcie —
       więc to on decyduje, czy termin ma brzmieć „W 24 godziny", czy „Wysyłka
       w 24 godziny". Nasza etykieta by mu to tylko dublowała. *}
    {if $qMaWysylke}
      <span class="q-stock-line__ship">{$product.delivery_information}</span>
    {/if}
  </p>

{elseif $qMaStan || $qMaWysylke || $qMaIlosc}
  <div class="q-facts q-facts--stock">
    <dl class="q-facts__list">
      {if $qMaStan}
        <div class="q-facts__row">
          <dt class="q-facts__key">{l s='Availability' d='Shop.Theme.Catalog'}</dt>
          {* Sam stan, bez zaproszenia do zapisu. Zapis na powiadomienie należy
             do wiersza zakupu: to jest działanie, a stan jest faktem. Wcześniej
             stały obok siebie dwa wejścia w to samo, w dwóch różnych miejscach
             karty. *}
          <dd class="q-facts__val">
            <span class="q-stock {$qKlasaStanu}">
              <span class="q-stock__dot" aria-hidden="true"></span>{$product.availability_message}
            </span>
          </dd>
        </div>
      {/if}

      {if $qMaIlosc}
        <div class="q-facts__row">
          <dt class="q-facts__key">{l s='In stock' d='Shop.Theme.Catalog'}</dt>
          <dd class="q-facts__val">{$product.quantity}</dd>
        </div>
      {/if}

      {if $qMaWysylke}
        <div class="q-facts__row">
          <dt class="q-facts__key">{l s='Shipping' d='Shop.Theme.Checkout'}</dt>
          <dd class="q-facts__val">{$product.delivery_information}</dd>
        </div>
      {/if}
    </dl>
  </div>
{/if}

{* Zapis na powiadomienie przeniosł się do wiersza zakupu razem z przyciskiem:
   szuflada stoi tam, gdzie stoi jej wyzwalacz, a stan magazynu jest faktem,
   nie działaniem. Tutaj zostaje sam hook PrestaShopa — wypisują się w nim
   także inne moduły sklepu i one mają się gdzie pokazać.

   Przy produkcie niedostępnym hook jedzie w szufladzie przy przycisku, więc
   tutaj wypada: dwa razy ten sam formularz na jednej karcie to dwa razy ten sam
   zapis. *}
{if $qKlasaStanu != 'q-stock--out'}
  {include file='catalog/_partials/product-additional-info.tpl'}
{/if}
