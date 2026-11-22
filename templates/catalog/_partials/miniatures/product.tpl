{**
 * Quince: zajawka produktu
 *
 * Używana wszędzie, gdzie sklep pokazuje produkt na liście: kategoria, wyniki
 * wyszukiwania, nowości, promocje, akcesoria, ostatnio oglądane.
 *
 * Kolejność treści z makiety: marka, nazwa, ocena, cena, nota o najniższej
 * cenie, przycisk zakupu. Marka stoi nad nazwą, bo w katalogu technicznym to
 * ona najczęściej rozstrzyga; ocena tuż nad ceną, bo to ostatnia rzecz, na
 * którą klient patrzy przed kwotą.
 *
 * Bloki do nadpisania: product_miniature_item, product_miniature_media,
 * product_miniature_body, product_brand, product_name, product_price,
 * product_actions.
 * Hooki: displayProductPriceBlock (before_price, custom_price, unit_price,
 * weight, old_price), displayProductListReviews.
 *
 * Klasy pochodzą z tokens.css, patrz components/product-card.css.
 * W szablonie nie ma logiki obliczeniowej: wszystko, co widać, przychodzi
 * gotowe z kontrolera.
 *}

{block name='product_miniature_item'}
  {* Ustawienia z Quince Engine → Karta produktu, osobno dla kafelka i rzędu.
     Elementy wspólne obu rodzajów gasi klasa na karcie (`card.classes`), bo
     widok listy przełącza się bez przeładowania strony. Elementy tylko rzędu
     szablon po prostu pomija. Bez silnika wszystko zostaje włączone. *}
  {assign var=qCard value=$modules.quince_engine.card|default:[]}
  {assign var=qKafel value=$qCard.tile|default:[]}
  {assign var=qRzad value=$qCard.row|default:[]}

  <article
    class="q-pcard product-miniature js-product-miniature{if !empty($qCard.classes)} {$qCard.classes}{/if}"
    data-id-product="{$product.id_product}"
    data-id-product-attribute="{$product.id_product_attribute}"
  >
    {block name='product_miniature_media'}
      <div class="q-pcard__media{if !$product.cover} q-pcard__media--empty{/if}">
        {* Plakietki na zdjęciu widać tylko w kafelku, więc decyduje kafelek. *}
        {if !isset($qKafel.badges) || $qKafel.badges}
          {include file='catalog/_partials/product-flags.tpl' qHiddenFlags=$qKafel.hidden_flags|default:[]}
        {/if}


        {* Odnośnik wypełnia kadr, ale nim nie jest: w kadrze stoją jeszcze
           przyciski, a przeglądarka wypycha przyciski poza odnośnik. *}
        <a href="{$product.url}"
           class="q-pcard__image-link"
           aria-label="{l s='View product %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Catalog'}">
          {include file='catalog/_partials/miniatures/product-image.tpl'}
        </a>

        {* Podgląd i ulubione stoją razem w słupku, nie osobno w rogach kadru. *}
        {include file='catalog/_partials/miniatures/product-tools.tpl'}
      </div>
    {/block}

    {block name='product_miniature_body'}
      <div class="q-pcard__body">
        {* Dalej idą cztery rzeczy, których w kafelku NIE WIDAĆ: gasi je arkusz.
           Są w znacznikach, bo widok listy pokazuje je z tych samych kart. *}
        {* Plakietki nad tytułem: w rzędzie kadr ma 256 px i słupek plakietek
           na zdjęciu zasłaniałby towar, więc schodzą do kolumny treści.

           Ta sama lista co na zdjęciu, tylko z inną klasą. Nie opakowywać jej
           w `q-pcard__badges`: arkusz gasi tę klasę w rzędzie. Bez warunku na
           obniżkę, bo plakietki niosą też nowość, pakiet i stan towaru, a lista,
           która nie ma czego pokazać, nie renderuje się wcale. *}
        {block name='product_topline'}
          {if !isset($qRzad.badges) || $qRzad.badges}
            {include file='catalog/_partials/product-flags.tpl' qBadgesClass='q-pcard__topline' qHiddenFlags=$qRzad.hidden_flags|default:[]}
          {/if}
        {/block}

        {block name='product_brand'}
          {if $product.manufacturer_name}
            <span class="q-pcard__brand">{$product.manufacturer_name}</span>
          {/if}
        {/block}

        {block name='product_name'}
          {* Nagłówek, nie sam odnośnik: na listingu nazwa produktu jest tytułem
             pozycji, więc czytnik ekranu ma po czym nawigować. Wygląd nazwy
             niesie odnośnik w środku, nie sam nagłówek. *}
          <h3 class="q-pcard__name-h">
            <a class="q-pcard__name" href="{$product.url}">{$product.name}</a>
          </h3>
        {/block}

        {block name='product_reviews'}
          {hook h='displayProductListReviews' product=$product}
        {/block}

        {block name='product_variants'}
          {if $product.main_variants}
            <div class="q-pcard__variants">
              {include file='catalog/_partials/variant-links.tpl' variants=$product.main_variants}
            </div>
          {/if}
        {/block}

        {* Opis i cechy: widok listy. W kafelku nie ma na nie miejsca. *}
        {block name='product_description'}
          {if $product.description_short && (!isset($qRzad.description) || $qRzad.description)}
            <p class="q-pcard__description">{$product.description_short|strip_tags|truncate:260:'…'}</p>
          {/if}
        {/block}

        {* Które cechy pokazujemy, decyduje ten sam ranking co w środkowej
           kolumnie karty produktu: moduł liczy, które cechy naprawdę odróżniają
           produkty w tej kategorii, i tylko one tu wchodzą. Branie pierwszych
           z katalogu wypisywałoby numer katalogowy i cechę o jednej wartości
           u wszystkich, czyli dokładnie to, co ranking odrzuca.

           Bez odnośnika „Pełna specyfikacja": on prowadzi do sekcji na karcie
           produktu, a stąd do tej karty prowadzi już nazwa. *}
        {block name='product_facts'}
          {* Dwie listy obok siebie: po lewej cechy, po prawej marka i kody.
             Każda ma swoją kolumnę na stałe, więc marka stoi w tym samym miejscu
             bez względu na to, ile cech ma produkt. *}
          {* Liczba cech z ekranu Karta produktu (rząd). Bez silnika sześć. *}
          {if isset($qRzad.features)}
            {assign var=qIleCech value=$qRzad.features|intval}
          {else}
            {assign var=qIleCech value=6}
          {/if}

          <div class="q-pcard__fakty">
          <dl class="q-facts__list q-pcard__fakty-cechy">
            {if $qIleCech > 0}
              {include file='catalog/_partials/product-key-features.tpl' qWiersze=true qKolejnosc=$product.id_product|qcechy
                qIle=$qIleCech}
            {/if}
          </dl>

          <dl class="q-facts__list q-pcard__fakty-kody">
            {if $product.manufacturer_name && (!isset($qRzad.brand) || $qRzad.brand)}
              <div class="q-facts__row">
                <dt class="q-facts__key">{l s='Brand' d='Shop.Theme.Catalog'}</dt>
                <dd class="q-facts__val">{$product.manufacturer_name}</dd>
              </div>
            {/if}

            {if $product.reference && (!isset($qRzad.code_reference) || $qRzad.code_reference)}
              <div class="q-facts__row">
                <dt class="q-facts__key">{l s='Reference' d='Shop.Theme.Catalog'}</dt>
                <dd class="q-facts__val">{$product.reference}</dd>
              </div>
            {/if}

            {if $product.ean13 && (!isset($qRzad.code_ean) || $qRzad.code_ean)}
              <div class="q-facts__row">
                <dt class="q-facts__key">{l s='EAN' d='Shop.Theme.Catalog'}</dt>
                <dd class="q-facts__val">{$product.ean13}</dd>
              </div>
            {/if}

            {if $product.mpn && (!isset($qRzad.code_mpn) || $qRzad.code_mpn)}
              <div class="q-facts__row">
                <dt class="q-facts__key">{l s='MPN' d='Shop.Theme.Catalog'}</dt>
                <dd class="q-facts__val">{$product.mpn}</dd>
              </div>
            {/if}
          </dl>
          </div>
        {/block}

        {* Pojemnik decyzji. W kafelku jest PRZEZROCZYSTY (`display: contents`),
           więc cena, nota i przycisk zachowują się tak, jakby go nie było.
           W rzędzie staje się słupkiem po prawej. Bez niego te elementy trafiają
           do osobnych rzędów siatki, których wysokość dyktuje kolumna treści,
           i między ceną, notą i przyciskiem powstają dziury. *}
        <div class="q-pcard__decyzja">

        {* Licznik do końca promocji. W kafelku leży na zdjęciu, tuż nad słupkiem
           narzędzi; w widoku listy jest szczytem słupka zakupu i bierze jego
           szerokość. Dlatego stoi TUTAJ, w pojemniku decyzji, a nie w kadrze:
           z kadru nie da się go przenieść na drugą stronę rzędu.

           Stoi tylko wtedy, gdy obniżka ma termin i ten termin jest blisko:
           próg dni ustawia sklep przy pasie promocji na karcie produktu, bo to
           ten sam zegar i ta sama decyzja. *}
        {if $product.has_discount && isset($product.specific_prices.to)}
          {assign var=qDoKonca value=$product.specific_prices.to|qdays}

          {if $qDoKonca >= 0 && $qDoKonca <= ($modules.quince_engine.product.options.promo_bar.days|default:365)}
            <div class="q-countdown q-pcard__countdown" data-q-countdown="{$product.specific_prices.to|qstamp}">
              <svg class="q-countdown__icon" viewBox="0 0 16 16" fill="none" stroke="currentColor"
                   stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="8" cy="8" r="6.3"/><path d="M8 4.4V8l2.6 1.5"/></svg>

              <span class="q-countdown__segment">
                <b data-q-countdown-days>0</b><i>{l s='days' d='Shop.Theme.Global'}</i>
              </span>

              <span class="q-countdown__segment">
                <b data-q-countdown-hours>00</b><i>{l s='hrs' d='Shop.Theme.Global'}</i>
              </span>

              <span class="q-countdown__segment">
                <b data-q-countdown-minutes>00</b><i>{l s='min' d='Shop.Theme.Global'}</i>
              </span>
            </div>
          {/if}
        {/if}

        {* Dostępność i termin wysyłki: widok listy. Stan rysuje ten sam
           komponent co panel zakupu na karcie produktu: kropka i podpis,
           nigdy sama barwa. Nazwy stanów przychodzą z rdzenia, więc mapowanie
           na klasę motywu jest tu takie samo jak tam. *}
        {block name='product_stock'}
          {assign var=qPokazStan value=($product.availability_message && (!isset($qRzad.availability) || $qRzad.availability))}
          {assign var=qPokazWysylke value=($product.delivery_information && (!isset($qRzad.shipping) || $qRzad.shipping))}

          {if $qPokazStan || $qPokazWysylke}
            {assign var=qDostepnosc value=$product.availability|default:''}

            {if $qDostepnosc == 'in_stock' || $qDostepnosc == 'available'}
              {assign var=qKlasaStanu value='q-stock--in'}
            {elseif $qDostepnosc == 'last_remaining_items'}
              {assign var=qKlasaStanu value='q-stock--low'}
            {else}
              {assign var=qKlasaStanu value='q-stock--out'}
            {/if}

            <dl class="q-facts__list q-pcard__stock">
              {if $qPokazStan}
                <div class="q-facts__row">
                  <dt class="q-facts__key">{l s='Availability' d='Shop.Theme.Catalog'}</dt>
                  <dd class="q-facts__val">
                    <span class="q-stock {$qKlasaStanu}">
                      <span class="q-stock__dot" aria-hidden="true"></span>{$product.availability_message}
                    </span>
                  </dd>
                </div>
              {/if}

              {if $qPokazWysylke}
                <div class="q-facts__row">
                  <dt class="q-facts__key">{l s='Shipping' d='Shop.Theme.Catalog'}</dt>
                  <dd class="q-facts__val">{$product.delivery_information}</dd>
                </div>
              {/if}
            </dl>
          {/if}
        {/block}

        {if $product.show_price}
          {block name='product_price'}
            {hook h='displayProductPriceBlock' product=$product type="before_price"}

            {* Cena odsunięta do dołu karty: przy różnej długości nazw kwoty
               w całym rzędzie zostają wyrównane. *}
            <div class="q-price q-pcard__price" aria-label="{l s='Price' d='Shop.Theme.Catalog'}">
              {capture name='custom_price'}{hook h='displayProductPriceBlock' product=$product type='custom_price' hook_origin='products_list'}{/capture}

              {if '' !== $smarty.capture.custom_price}
                {$smarty.capture.custom_price nofilter}
              {else}
                <span class="q-price__current{if $product.has_discount} q-price__current--promo{/if}">{$product.price}</span>
              {/if}

              {if $product.has_discount}
                {hook h='displayProductPriceBlock' product=$product type="old_price"}
                <span class="q-price__old" aria-label="{l s='Regular price' d='Shop.Theme.Catalog'}">{$product.regular_price}</span>
              {/if}

              {hook h='displayProductPriceBlock' product=$product type='unit_price'}
              {hook h='displayProductPriceBlock' product=$product type='weight'}
            </div>

            {* Nota o najniższej cenie stoi na KAŻDEJ karcie, także bez obniżki
               (wtedy pusta). To rezerwacja miejsca, nie treść: bez niej karta
               z obniżką jest o wiersz wyższa od sąsiadek, a że wszystkie mają
               wspólną wysokość, przycisk zjeżdża na niej niżej niż na pozostałych.

               Akapit rysuje motyw, tekst przynosi moduł historii cen. *}
            <p class="q-pcard__omnibus">{hook h='displayQuinceOmnibus' product=$product miejsce='karta'}</p>
          {/block}
        {/if}

        {block name='product_actions'}
          <div class="q-pcard__cart">
            {if $product.add_to_cart_url}
              <form class="q-pcard__form" action="{$urls.pages.cart}" method="post">
                <input type="hidden" value="{$product.id_product}" name="id_product">
                {if $product.id_product_attribute}
                  <input type="hidden" value="{$product.id_product_attribute}" name="id_product_attribute">
                {/if}
                <input type="hidden" name="token" value="{$static_token}">

                <button
                  type="submit"
                  class="q-btn q-btn--primary"
                  data-button-action="add-to-cart"
                  data-ps-ref="add-to-cart"
                  aria-label="{l s='Add to cart %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}"
                >
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 1a2.5 2.5 0 0 1 2.5 2.5V4h-5v-.5A2.5 2.5 0 0 1 8 1m3.5 3v-.5a3.5 3.5 0 1 0-7 0V4H1v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V4zM2 5h12v9a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1z"/></svg>
                  {* Krótszy napis niż na karcie produktu: w kafelku o szerokości
                     200 px pełne „Dodaj do koszyka" łamie się na dwa wiersze.
                     Ten sam napis niesie pasek zakupu na telefonie. *}
                  <span class="q-btn__label">{l s='To cart' d='Shop.Theme.Actions'}</span>
                </button>
              </form>
            {else}
              {* Produkt niedostępny do kupienia z listingu: wariantowy, na zamówienie
                 albo wyprzedany. Zamiast wyszarzonego przycisku prowadzimy na kartę,
                 gdzie klient zobaczy powód. *}
              <a href="{$product.url}" class="q-btn q-btn--secondary">
                {l s='See details' d='Shop.Theme.Actions'}
              </a>
            {/if}
          </div>
        {/block}

        </div><!-- /q-pcard__decyzja -->
      </div>
    {/block}
  </article>
{/block}
