{**
 * Quince: jeden element strony produktu.
 *
 * Strefy renderują listę identyfikatorów, którą przysyła silnik; ten plik jest
 * jedynym miejscem, gdzie identyfikator zamienia się w treść. Dzięki temu
 * przestawienie elementu w panelu nie wymaga zmiany w żadnym szablonie, a
 * dołożenie nowego elementu to jedna gałąź tutaj.
 *
 * Identyfikator bez gałęzi nie renderuje nic i nie przerywa strony.
 *
 * Zmienne: $qEl, element z katalogu silnika: `id`, `label`, `on` oraz `options`
 * (włączniki szczegółów, np. `omnibus` przy cenie). Rozgałęziamy się po `id`.
 * $qStrefa: nazwa strefy, w której element stoi. Większości jest obojętna;
 * dostępność zmienia po niej układ, bo w wąskiej kolumnie zakupu idzie jedną
 * linijką zamiast tabelą.
 *}

{assign var=qId value=$qEl.id}

{* Miejsce wstawione przez sklep, a nie element silnika: identyfikator ma postać
   `hook:<nazwa>`, a treść przynosi moduł podpięty pod ten hook. Nazwa idzie
   z ustawień, więc gałąź jest jedna dla wszystkich hooków, jakie sklep doda.
   Produkt jedzie w parametrach, bo bez niego moduł na karcie produktu nie wie,
   o czym ma mówić. *}
{if $qEl.hook}
  {hook h=$qEl.hook product=$product}

{elseif $qId == 'gallery'}
  {include file='catalog/_partials/product-cover-thumbnails.tpl'
    qWideo=$qEl.options.video|default:true
    qFilmPierwszy=$qEl.options.video_first|default:false}

{elseif $qId == 'badges'}
  {include file='catalog/_partials/product-flags.tpl' qBadgesClass='q-pdp__badges'}

{elseif $qId == 'name'}
  <h1 class="q-pdp__name">{$product.name}</h1>

{elseif $qId == 'rating'}
  {include file='catalog/_partials/product-rating.tpl'}

{elseif $qId == 'brand_sku'}
  {include file='catalog/_partials/product-brand-codes.tpl'
    qMarka=$qEl.options.brand|default:true
    qLogo=$qEl.options.logo|default:false
    qSku=$qEl.options.sku|default:true
    qEan=$qEl.options.ean|default:false
    qMpn=$qEl.options.mpn|default:false
    qStan=$qEl.options.condition|default:false}

{elseif $qId == 'key_features'}
  {include file='catalog/_partials/product-key-features.tpl'
    qLink=$qEl.options.link|default:true
    qIle=$qEl.options.ile|default:5}

{elseif $qId == 'short_description'}
  {if $product.description_short}
    <div class="q-pdp__short rich-text">{$product.description_short nofilter}</div>
  {/if}

{elseif $qId == 'promo_bar'}
  {include file='catalog/_partials/product-promo-bar.tpl' qDni=$qEl.options.days|default:365}

{elseif $qId == 'price'}
  {include file='catalog/_partials/product-prices.tpl'}

  {* Nota o najniższej cenie: własny wiersz POD blokiem ceny.
     Włącznik stoi przy elemencie ceny w mapie strony produktu, a treść przynosi
     moduł historii cen. Bez niego nie ma czego liczyć i wiersz nie powstaje. *}
  {if $qEl.options.omnibus}
    {hook h='displayQuinceOmnibus' product=$product}
  {/if}

{elseif $qId == 'variants'}
  {include file='catalog/_partials/product-variants.tpl'}

{elseif $qId == 'tier_prices'}
  {include file='catalog/_partials/product-discounts.tpl'}

{elseif $qId == 'section_pack_items'}
  {* Składniki zestawu: wiersz w panelu zakupu i szuflada z pełną listą.
     Tylko na karcie produktu, który sam jest zestawem. *}
  {include file='catalog/_partials/product-pack-items.tpl'
    qMiniatura=$qEl.options.thumbnail|default:true
    qNumer=$qEl.options.sku|default:true
    qIlosc=$qEl.options.in_pack|default:true
    qCena=$qEl.options.price|default:true
    qStan=$qEl.options.availability|default:true
    qOdnosnik=$qEl.options.item_link|default:true
    qOsobno=$qEl.options.buy|default:false}

{elseif $qId == 'customization'}
  {if $product.is_customizable && count($product.customizations.fields)}
    {include file='catalog/_partials/product-customization.tpl' customizations=$product.customizations}
  {/if}

{elseif $qId == 'add_to_cart'}
  {include file='catalog/_partials/product-add-to-cart.tpl'}

{elseif $qId == 'buy_now'}
  {include file='catalog/_partials/product-buy-now.tpl'
    qUlubione=$qEl.options.wishlist|default:true
    qKupTeraz=$qEl.options.buy_now|default:true
    qPowiadom=$qEl.options.notify|default:true}

{elseif $qId == 'availability'}
  {include file='catalog/_partials/product-availability.tpl'
    qStan=$qEl.options.stock|default:true
    qWysylka=$qEl.options.shipping|default:true
    qIlosc=$qEl.options.quantity|default:false
    qZwarty=(($qStrefa|default:'') == 'zakup')}

{elseif $qId == 'offer'}
  {* Przycisk i szuflada oferty PDF. Treść przynosi moduł `quince_offers`;
     bez niego hook nie ma nadawcy i element nie renderuje nic. *}
  {hook h='displayQuinceOffer' product=$product}

{elseif $qId == 'ask_expert'}
  {* Osobę dobiera moduł kontaktów po kategorii produktu; bez przypisanej osoby
     nie wypisuje nic i element znika razem z przyciskiem. *}
  {hook h='displayQuinceExpert' product=$product}

{elseif $qId == 'reassurance'}
  {hook h='displayReassurance'}

{elseif $qId == 'section_description'}
  {if $product.description}
    {include file='catalog/_partials/pdp-section.tpl'
      qId='opis'
      qTytul={l s='Description' d='Shop.Theme.Catalog'}
      qOtwarta=true}
  {/if}

{elseif $qId == 'section_spec'}
  {* Dwa włączniki, jedna zakładka: pola produktu i tabela cech to dwa źródła
     danych, ale dla kupującego jedno pytanie. *}
  {include file='catalog/_partials/product-details.tpl'
    qPola=$qEl.options.fields|default:true
    qLogo=$qEl.options.logo|default:true
    qCechy=$qEl.options.features|default:true}

{elseif $qId == 'section_dictionaries'}
  {* Słowniki katalogowe: dopasowanie do pojazdów, numery OEM, kody silnika.
     Treść przynosi moduł `quince_dictionaries`; produkt bez powiązań nie
     wypisuje nic i wtedy sekcji nie ma. *}
  {capture name='qSlowniki'}{hook h='displayQuinceDictionaries' product=$product}{/capture}

  {if trim($smarty.capture.qSlowniki) !== ''}
    {include file='catalog/_partials/pdp-section.tpl'
      qId='slowniki'
      qTytul={l s='Fitment and codes' d='Shop.Theme.Catalog'}
      qTresc=$smarty.capture.qSlowniki}
  {/if}

{elseif $qId == 'section_safety'}
  {* Bezpieczeństwo produktu i podmiot odpowiedzialny (GPSR). Treść przynosi
     moduł `quince_gpsr`; produkt bez danych nie wypisuje nic i wtedy sekcji
     nie ma. *}
  {capture name='qBezpieczenstwo'}{hook h='displayQuinceGpsr' product=$product}{/capture}

  {if trim($smarty.capture.qBezpieczenstwo) !== ''}
    {include file='catalog/_partials/pdp-section.tpl'
      qId='bezpieczenstwo'
      qTytul={l s='Product safety' d='Shop.Theme.Catalog'}
      qTresc=$smarty.capture.qBezpieczenstwo}
  {/if}

{elseif $qId == 'section_reviews'}
  {* Sekcja stoi także wtedy, gdy opinii nie ma: pusta mówi „bądź pierwszy",
     a jej brak kazałby szukać opinii tam, gdzie ich nigdy nie było. Znika
     dopiero bez modułu opinii, bo wtedy sklep ich w ogóle nie zbiera. *}
  {if $modules.quince_engine.rating|default:null}
    {include file='catalog/_partials/pdp-section.tpl'
      qId='opinie'
      qTytul={l s='Reviews' d='Shop.Theme.Catalog'}
      qLiczba=$modules.quince_engine.rating.count}
  {/if}

{elseif $qId == 'section_faq'}
  {* Sekcja stoi także bez ani jednego pytania: pusta zaprasza do zadania
     pierwszego. Znika dopiero bez modułu pytań, bo wtedy sklep ich nie zbiera. *}
  {if $modules.quince_qa|default:null}
    {include file='catalog/_partials/pdp-section.tpl'
      qId='pytania'
      qTytul={l s='Questions and answers' d='Shop.Theme.Catalog'}
      qLiczba=$modules.quince_qa.count}
  {/if}

{elseif $qId == 'section_modules'}
  {* Zakładki dokładane przez inne moduły (hook `displayProductExtraContent`).
     Jedna pozycja w panelu na wszystkie: stoją tam, gdzie sklep ją postawi
     w akordeonie, i znikają razem z jej wyłączeniem. Silnik nie zna ich
     z góry, więc nie przestawia się ich pojedynczo. *}
  {foreach from=$product.extraContent item=qDodatkowa key=qKlucz}
    <details class="q-accordion__item" id="q-section-module-{$qKlucz}"
             {foreach $qDodatkowa.attr as $qAtrybut => $qWartosc} {$qAtrybut}="{$qWartosc}"{/foreach}>
      <summary class="q-accordion__header">
        <h2 class="q-accordion__title">{$qDodatkowa.title}</h2>
        <svg class="q-accordion__icon" width="16" height="16" viewBox="0 0 16 16"
             fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
      </summary>

      <div class="q-accordion__body">{$qDodatkowa.content nofilter}</div>
    </details>
  {/foreach}

{elseif $qId == 'section_attachments'}
  {if $product.attachments}
    {include file='catalog/_partials/pdp-section.tpl'
      qId='zalaczniki'
      qTytul={l s='Download' d='Shop.Theme.Actions'}
      qLiczba=$product.attachments|@count}
  {/if}

{elseif $qId == 'bundles'}
  {* Zestawy, w których występuje ten produkt. Próg dni licznika promocji jest
     ten sam co przy pasie w panelu zakupu, bo to ten sam zegar. Czytany
     z mapy włączników, bo pas może być wyłączony, a próg nadal obowiązuje. *}
  {include file='catalog/_partials/product-bundles.tpl'
    qDni=$modules.quince_engine.product.options.promo_bar.days|default:365}

{elseif $qId == 'related'}
  {if $accessories}
    {include file='catalog/_partials/product-accessories.tpl'
      qIle=$qEl.options.count|default:8
      qStrzalki=$qEl.options.nav|default:true
      qTytulWlasny=$qEl.options.title[$language.id]|default:''}
  {/if}

{elseif $qId == 'spare_parts' || $qId == 'spare_parts_for' || $qId == 'set_items' || $qId == 'in_sets'}
  {* Części zamienne i elementy zestawu wpisane przy produkcie, w obie strony.
     Listy prowadzi moduł cross-sellingu (to nie są pakiety ani akcesoria
     PrestaShop), wygląd, liczbę kart i tytuł ustawia panel strony produktu.
     Bez modułu hook nie ma nadawcy i element nie renderuje nic. *}
  {hook h='displayQuinceProductList' product=$product
    qLista=$qId
    qIle=$qEl.options.count|default:8
    qStrzalki=$qEl.options.nav|default:true
    qTytul=$qEl.options.title[$language.id]|default:''}

{elseif $qId == 'cross_selling'}
  {* Produkty do dokupienia. Dobór należy do modułu cross-sellingu, wygląd,
     liczbę kart i tytuł ustawia panel strony produktu. Bez modułu hook nie
     ma nadawcy i element nie renderuje nic. *}
  {hook h='displayQuinceCrossSelling' product=$product
    qIle=$qEl.options.count|default:8
    qStrzalki=$qEl.options.nav|default:true
    qTytul=$qEl.options.title[$language.id]|default:''}

{elseif $qId == 'category_products'}
  {* Inne produkty z kategorii prowadzi moduł `ps_categoryproducts`, a motyw daje
     im wygląd karuzeli. Tak jak przy ostatnio oglądanych wołamy wyłącznie ten
     moduł, a stopka produktu go pomija. *}
  {hook h='displayFooterProduct' mod='ps_categoryproducts' product=$product category=$category}

{elseif $qId == 'recently_viewed'}
  {* Listę ostatnio oglądanych prowadzi moduł `ps_viewedproduct`, a motyw daje
     jej wygląd karuzeli. Wołamy wyłącznie ten jeden moduł, bo stopka produktu
     wypisuje z tego samego hooka wszystkie pozostałe. *}
  {hook h='displayFooterProduct' mod='ps_viewedproduct' product=$product category=$category}


{/if}
