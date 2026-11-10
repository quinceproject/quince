{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file=$layout}

{block name='head' append}
  <meta property="og:type" content="product">
  <meta content="{$product.url}">

  {if $product.cover}
    <meta property="og:image" content="{$product.cover.large.url}">
  {/if}

  {if $product.show_price}
    <meta property="product:pretax_price:amount" content="{$product.price_tax_exc}">
    <meta property="product:pretax_price:currency" content="{$currency.iso_code}">
    <meta property="product:price:amount" content="{$product.price_amount}">
    <meta property="product:price:currency" content="{$currency.iso_code}">
  {/if}
  {if isset($product.weight) && ($product.weight != 0)}
  <meta property="product:weight:value" content="{$product.weight}">
  <meta property="product:weight:units" content="{$product.weight_unit}">
  {/if}
{/block}

{block name='head_microdata_special'}
  {include file='_partials/microdata/product-jsonld.tpl'}
{/block}

{* Okruszki idą do środka kontenera strony produktu, więc miejsce z układu
   zostaje puste — inaczej ścieżka renderuje się dwa razy, raz poza kontenerem. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  {* Strefy przychodzą z silnika jako listy identyfikatorów w kolejności. Szablon
     nie wie, co w nich stoi ani gdzie — układ, kolejność i proporcje są
     ustawieniem sklepu.

     Siatka ma dwa tory: lewy i panel zakupu. Układy różni zawartość lewego toru,
     nie liczba torów.

     Klasy `product-container` i `js-product-container` zostają, bo szuka ich
     skrypt produktu PrestaShopa. *}
  {assign var=qPdp value=$modules.quince_engine.product}

  <div class="q-container q-pdp product-container js-product-container"
       data-ps-ref="product-container"
       style="--q-pdp-glowna: {$qPdp.split.main}fr; --q-pdp-panel: {$qPdp.split.panel}fr">

    {include file='_partials/breadcrumb.tpl'}

    <div class="q-pdp__grid">

      {if $qPdp.layout == 'three'}
        {* Lewy tor: karta z tytułem przez całą szerokość, pod nim galeria
           i opis obok siebie. *}
        <div class="q-pdp__main">
          <div class="q-pdp__intro">
            {foreach from=$qPdp.zones.naglowek item=qEl}
              {include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}
            {/foreach}
          </div>

          <div class="q-pdp__gallery">
            {foreach from=$qPdp.zones.galeria item=qEl}
              {include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}
            {/foreach}
          </div>

          <div class="q-pdp__info">
            {* Slot jak w panelu zakupu: odstęp między blokami ustawia opakowanie,
               a nie sam blok. Kolejność elementów przestawia się z panelu sklepu,
               więc blok z własnym marginesem raz stałby dobrze, a raz źle.
               Opakowanie powstaje dopiero wtedy, gdy element cokolwiek wypisał. *}
            {foreach from=$qPdp.zones.opis item=qEl}
              {capture name='qSlotOpis'}{include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}{/capture}
              {if trim($smarty.capture.qSlotOpis) !== ''}
                <div class="q-pdp__slot q-pdp__slot--{$qEl.id|escape:'html':'UTF-8'}"{if $qEl.id == 'availability' || $qEl.id == 'buy_now' || $qEl.id == 'brand_sku'} data-q-variant="{$qEl.id|escape:'html':'UTF-8'}"{/if}>
                  {$smarty.capture.qSlotOpis nofilter}
                </div>
              {/if}
            {/foreach}
          </div>

          {* Pas pod galerią i opisem, na szerokość obu kolumn. Silnik nie stawia
             tu nic własnego — miejsce jest po to, żeby sklep wpiął w nie hooka
             ze swoją treścią, więc opakowanie powstaje dopiero wtedy, gdy coś
             się w nim wypisało. Pusta strefa nie ma zostawiać odstępu. *}
          {if $qPdp.zones.stopka}
            {capture name='qStopka'}
              {foreach from=$qPdp.zones.stopka item=qEl}
                {include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}
              {/foreach}
            {/capture}

            {if trim($smarty.capture.qStopka) !== ''}
              <div class="q-pdp__outro">{$smarty.capture.qStopka nofilter}</div>
            {/if}
          {/if}
        </div>
      {else}
        {* Lewy tor: sama galeria. Reszta karty — nazwa, opis, kody — wchodzi
           do panelu zakupu, więc stref `naglowek` i `opis` w tym układzie nie ma. *}
        <div class="q-pdp__gallery">
          {foreach from=$qPdp.zones.galeria item=qEl}
            {include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}
          {/foreach}
        </div>
      {/if}

      <div class="q-pdp__aside" data-ps-ref="product-right" tabindex="-1">
        {* Cała strefa siedzi w formularzu, nie tylko przyciski: sklep ustawia
           kolejność elementów, więc pole ilości i warianty mogą wylądować
           w każdym miejscu strefy, a muszą trafić do tego samego wysłania.

           `product-actions` na opakowaniu, nie na formularzu — skrypt PrestaShopa
           szuka formularza WEWNĄTRZ elementu z tą klasą. *}
        <div class="q-buy product-actions js-product-actions">
          {* Pas promocji stoi PRZED formularzem, na samej górze panelu, bo jest
             górną krawędzią całego panelu zakupu: wychodzi poza jego wcięcie na
             pełną szerokość i przejmuje jego górne rogi. Wewnątrz formularza
             byłby zwykłym blokiem między innymi blokami.

             Element jest w katalogu przypięty do początku strefy, więc sklep
             może go wyłączyć, ale nie przestawić w środek. *}
          {foreach from=$qPdp.zones.zakup item=qEl}
            {if $qEl.id == 'promo_bar'}
              {include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}
            {/if}
          {/foreach}

          {* Reszta panelu w osobnym pudełku, bo przy pasie to ONO niesie białą
             powierzchnię: wjeżdża na pas o wysokość zakładki i pokazuje na nim
             swoje górne rogi. Bez pasa pudełko nie ma żadnego wyglądu i cały
             panel wygląda tak jak wcześniej. *}
          <div class="q-buy__karta">
            <form action="{$urls.pages.cart}" method="post" id="add-to-cart-or-refresh">
              <input type="hidden" name="token" value="{$static_token}">
              <input type="hidden" name="id_product" value="{$product.id}" id="product_page_product_id">
              <input type="hidden" name="id_customization" value="{$product.id_customization}" id="product_customization_id" class="js-product-customization-id">

              {* Składniki zestawu niesie element „section_pack_items" w strefie
                 zakupu: wiersz z podglądem i szuflada z listą. Blok zostaje pusty,
                 żeby motyw potomny mógł go dalej rozszerzać. *}
              {block name='product_pack'}{/block}

              {* Panel idzie wierszami, nie elementami: sklep może postawić dwa
                 elementy obok siebie (para „Pobierz ofertę" i „Zapytaj
                 specjalistę") i wtedy wiersz dzieli się na dwa tory. Wiersz
                 z jednym elementem wygląda tak jak wcześniej. *}
              {foreach from=$qPdp.rows.zakup item=qWiersz}
                {capture name='qWierszPanelu'}
                  {foreach from=$qWiersz item=qEl}
                    {if $qEl.id != 'promo_bar'}
                      {* Opakowanie powstaje dopiero wtedy, gdy element cokolwiek wypisał.
                         Element jeszcze niezbudowany nie renderuje nic, a puste opakowanie
                         i tak zabierało odstęp — panel zakupu rozjeżdżał się o wysokość
                         rzeczy, których na stronie nie ma. *}
                      {capture name='qSlot'}{include file='catalog/_partials/pdp-element.tpl' qEl=$qEl qStrefa='zakup'}{/capture}
                      {* `data-q-variant` znaczy bloki zależne od wariantu, których rdzeń
                         po zmianie wariantu nie odświeża. Podmienia je wariant.js. *}
                      {if trim($smarty.capture.qSlot) !== ''}
                        <div class="q-buy__slot q-buy__slot--{$qEl.id|escape:'html':'UTF-8'}"{if $qEl.id == 'availability' || $qEl.id == 'buy_now' || $qEl.id == 'brand_sku'} data-q-variant="{$qEl.id|escape:'html':'UTF-8'}"{/if}>
                          {$smarty.capture.qSlot nofilter}
                        </div>
                      {/if}
                    {/if}
                  {/foreach}
                {/capture}

                {if trim($smarty.capture.qWierszPanelu) !== ''}
                  {if $qWiersz|@count > 1}
                    <div class="q-buy__row">{$smarty.capture.qWierszPanelu nofilter}</div>
                  {else}
                    {$smarty.capture.qWierszPanelu nofilter}
                  {/if}
                {/if}
              {/foreach}

              {block name='product_out_of_stock'}
                {hook h='actionProductOutOfStock' product=$product}
              {/block}

              {block name='product_refresh'}{/block}
            </form>
          </div>
        </div>
      </div>

      {if $qPdp.zones.zapewnienia}
        <div class="q-pdp__reas">
          {foreach from=$qPdp.zones.zapewnienia item=qEl}
            {include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}
          {/foreach}
        </div>
      {/if}

      {* Zakładki dokładane przez moduły nie stoją tu osobno: niesie je element
         „section_modules" w strefie sekcji, więc trafiają tam, gdzie sklep go
         postawi, i znikają razem z jego wyłączeniem. *}
      {if $qPdp.zones.sekcje}
        <div class="q-accordion q-pdp__sections">
          {foreach from=$qPdp.zones.sekcje item=qEl}
            {include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}
          {/foreach}
        </div>
      {/if}
    </div>

    {* Zestawy: pod siatką karty, na pełną szerokość kontenera. Opakowanie
       powstaje dopiero wtedy, gdy któryś element coś wypisał: produkt, który
       nie wchodzi w żaden zestaw, nie może zostawiać pustego odstępu. *}
    {if $qPdp.zones.zestawy}
      {capture name='qZestawyStrefa'}
        {foreach from=$qPdp.zones.zestawy item=qEl}
          {include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}
        {/foreach}
      {/capture}

      {if trim($smarty.capture.qZestawyStrefa) !== ''}
        <div class="q-pdp__zestawy">{$smarty.capture.qZestawyStrefa nofilter}</div>
      {/if}
    {/if}

    {* Zajawki: oferta obok tego produktu. Silnik nazywa te strefe `zajawki` —
       wczesniej stalo tu `dol`, ktorego w silniku nie ma, wiec blok nie
       renderowal sie nigdy i zostawial ostrzezenie o brakujacym kluczu. *}
    {* Warstwa z panelem zakupu na telefonie. Musi stać w tym kontenerze: rdzeń
       odświeża bloki panelu po zmianie wariantu tylko w obrębie
       `.product-container`, a panel pożyczony do warstwy obok kontenera zostawał
       ze starym wariantem i starą ceną. Na wierzch wynosi ją `showModal()`. *}
    {include file='catalog/_partials/product-buy-sheet.tpl'}

    {if $qPdp.zones.zajawki}
      <div class="q-pdp__dol">
        {foreach from=$qPdp.zones.zajawki item=qEl}
          {include file='catalog/_partials/pdp-element.tpl' qEl=$qEl}
        {/foreach}
      </div>
    {/if}
  </div>

  {* Pasek zakupu na telefonie. Poza siatką strony, bo leży NA treści przy
     dolnej krawędzi okna, a nie w kolumnie. Na szerokim ekranie styl go nie
     pokazuje. Warstwa, którą otwiera, stoi wyżej, w kontenerze produktu. *}
  {include file='catalog/_partials/product-mobile-bar.tpl'}

  {* Moduły wpięte pod stopkę produktu. Bez ostatnio oglądanych i bez produktów
     z tej samej kategorii: te niesie strefa karuzel, więc stoją tam, gdzie
     postawi je panel sklepu, a stąd wyszłyby drugi raz na samym końcu strony.

     Bez natywnego „Klienci kupili również", gdy działa nasz cross-selling:
     jego dobór zaczyna się od tej samej historii zamówień, więc obie sekcje
     pokazywałyby te same produkty jedna pod drugą. *}
  {assign var=qBezStopki value='ps_viewedproduct,ps_categoryproducts'}
  {if $modules.quince_crossselling.active|default:false}
    {assign var=qBezStopki value='ps_viewedproduct,ps_categoryproducts,ps_crossselling'}
  {/if}

  {block name='product_footer'}
    {hook h='displayFooterProduct' excl=$qBezStopki product=$product category=$category}
  {/block}

  {block name='page_footer_container'}
    {block name='page_footer'}
    {/block}
  {/block}
{/block}
