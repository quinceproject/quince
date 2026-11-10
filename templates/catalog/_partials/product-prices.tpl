{**
 * Quince — blok ceny w panelu zakupu.
 *
 * Cztery wiersze, po jednej sprawie na wiersz: cena netto, cena do zapłaty,
 * obniżka, drobny druk. Rdzeń stawiał cenę przed obniżką dwa razy — raz obok
 * ceny bieżącej, raz jako „Zamiast" — a wielkość obniżki także dwa razy, jako
 * procent i jako kwotę. Cztery liczby w jednej płatwie kazały czytać blok od
 * nowa, żeby ustalić, która jest ta do zapłaty.
 *
 * Włączniki szczegółów czytamy z ustawień silnika, a NIE z parametrów wywołania:
 * PrestaShop po zmianie wariantu renderuje ten plik osobno, bez strefy dookoła,
 * więc parametry z `pdp-element.tpl` wtedy nie dochodzą.
 *
 * Klasa `js-product-prices` zostaje na korzeniu: po niej rdzeń podmienia blok
 * po zmianie wariantu.
 *}

{assign var=qOpcje value=$modules.quince_engine.product.options.price|default:[]}

{if $product.show_price}
  <div class="q-price js-product-prices">

    {* Netto NAD brutto: klient firmowy szuka najpierw netto, a detaliczny i tak
       zatrzyma wzrok na większej liczbie poniżej.

       Wiersz stoi tylko wtedy, gdy niesie inną liczbę niż cena poniżej: sklep
       pokazujący ceny bez podatku ma już netto jako cenę główną, a produkt
       ze stawką zerową ma obie kwoty równe. W obu przypadkach wiersz powtarzałby
       to samo dwa razy. *}
    {if $qOpcje.net|default:true && $configuration.taxes_enabled
        && $configuration.display_prices_tax_incl
        && $product.price_tax_exc < $product.price_amount}
      <span class="q-buy__net">
        <data value="{$product.price_tax_exc}">{$product.price_tax_exc|qprice}</data>
        {l s='net' d='Shop.Theme.Catalog'}
      </span>
    {/if}

    <div class="q-buy__price-row">
      {capture name='qCenaModulu'}{hook h='displayProductPriceBlock' product=$product type='custom_price' hook_origin='product_sheet'}{/capture}

      {if trim($smarty.capture.qCenaModulu) !== ''}
        {$smarty.capture.qCenaModulu nofilter}
      {else}
        <span class="q-price__current{if $product.has_discount} q-price__current--promo{/if}">
          <span class="visually-hidden">{l s='Price:' d='Shop.Theme.Catalog'}</span>
          <data value="{$product.price_amount}">{$product.price}</data>
        </span>
      {/if}

      {if $qOpcje.tax_label|default:true && $configuration.display_taxes_label}
        <span class="q-buy__gross-note">{$product.labels.tax_long}</span>
      {/if}

      {hook h='displayProductPriceBlock' product=$product type='price'}
      {hook h='displayProductPriceBlock' product=$product type='after_price'}
    </div>

    {* Cały wiersz obniżki pod jednym warunkiem: od ile, o ile w procentach,
       o ile w złotych. Razem są odpowiedzią na jedno pytanie, a każda z tych
       liczb osobno kazała szukać punktu odniesienia gdzie indziej w bloku. *}
    {if $product.has_discount}
      <div class="q-buy__promo-row">
        {hook h='displayProductPriceBlock' product=$product type='old_price'}

        <span class="q-price__old">
          <span class="visually-hidden">{l s='Regular price:' d='Shop.Theme.Catalog'}</span>
          <data value="{$product.regular_price_amount}">{$product.regular_price}</data>
        </span>

        {* Plakietka tylko przy obniżce procentowej. Przy obniżce kwotowej rdzeń
           liczy procent z kwoty rabatu i wychodzi z tego liczba bez sensu. *}
        {if $qOpcje.discount|default:true && $product.discount_type === 'percentage'}
          <span class="q-badge q-badge--discount">{$product.discount_percentage}</span>
        {/if}

        {* Kwota zysku zostaje mimo procentu obok: przy 21 849 zł „−15%" trzeba
           przeliczyć, żeby wiedzieć, o czym mowa, a „3 858 zł" mówi to wprost. *}
        <span class="q-buy__savings-pill">
          {l s='You save %amount%' sprintf=['%amount%' => $product.discount_amount] d='Shop.Theme.Catalog'}
        </span>
      </div>
    {/if}

    {* Drobny druk pod ceną: cena za jednostkę miary, cena zestawu, ekotaksa.
       Makieta ich nie pokazuje, bo dotyczą części katalogu, ale sklep, który
       je prowadzi, musi je wypisać obok ceny. *}
    {if $qOpcje.unit|default:true && $displayUnitPrice|default:false}
      <span class="q-price__note">
        {l s='(%unit_price%)' sprintf=['%unit_price%' => $product.unit_price_full] d='Shop.Theme.Catalog'}
      </span>
    {/if}

    {if $displayPackPrice|default:false}
      <span class="q-price__note">
        {l s='Instead of %price%' sprintf=['%price%' => $noPackPrice] d='Shop.Theme.Catalog'}
      </span>
    {/if}

    {if $qOpcje.ecotax|default:false && $product.ecotax.amount > 0}
      <span class="q-price__note">
        {l s='Including %amount% for ecotax' sprintf=['%amount%' => $product.ecotax.value] d='Shop.Theme.Catalog'}
        {if $product.has_discount}{l s='(not impacted by the discount)' d='Shop.Theme.Catalog'}{/if}
      </span>
    {/if}

    {hook h='displayProductPriceBlock' product=$product type='weight' hook_origin='product_sheet'}
  </div>
{/if}
