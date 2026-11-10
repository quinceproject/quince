{**
 * Quince: lista bez produktów.
 *
 * Dwa różne przypadki pod jednym adresem w kodzie, bo rdzeń renderuje to samo
 * miejsce w obu:
 *
 *  — KLIENT NIC NIE ZNALAZŁ. Wpisał frazę i dostał zero wyników. To nie jest
 *    stan pusty, tylko ślepy zaułek, z którego trzeba go wyprowadzić: stąd
 *    wskazówki, co zrobić inaczej, i rząd kategorii jako droga dalej. Treść
 *    pisze sklep w ustawieniach wyszukiwarki, bo tylko on wie, czego u niego
 *    szukają i gdzie to leży;
 *  — LISTA JEST PUSTA. Kategoria bez produktów, marka bez produktów, promocje
 *    w dzień bez promocji. Klient niczego nie zrobił źle, więc nie ma mu czego
 *    podpowiadać — zostaje zdanie i droga powrotna.
 *
 * Rozróżnia je `$search_string`: ustawia go wyłącznie kontroler wyszukiwarki.
 *
 * Kafelki kategorii rysuje ten sam kawałek motywu, co podkategorie na stronie
 * kategorii. Te same kategorie mają wyglądać wszędzie tak samo, a ikonizacja
 * zdjęć jest tam już zrobiona.
 *
 * Klasy: components/listing.css
 *}

{assign var=qSzukanie value=isset($search_string) && $search_string}
{assign var=qPusty value=null}

{* Lista pusta, bo zawezil ja filtr. Klikaniem klient tu nie trafi: faceted
   search pokazuje tylko opcje, ktore maja wyniki. Trafia starym adresem —
   zakladka, link z maila, wynik w wyszukiwarce — gdy produkty w miedzyczasie
   zniknely. Przy zerze wynikow modul filtrow nie oddaje ani panelu, ani pigulek,
   wiec bez tego odnosnika klient nie ma czym zdjac zawezenia. *}
{assign var=qZawezone value=$smarty.get.q|default:''}

{if $qZawezone}
  {assign var=qBezFiltrow value=$urls.current_url|regex_replace:'/\?.*$/':''}
  {if $qSzukanie}
    {assign var=qBezFiltrow value="`$qBezFiltrow`?s=`$search_string|urlencode`"}
  {/if}
{/if}

{if $qSzukanie && isset($modules.quince_engine.header.search.provider)}
  {assign var=qDostawca value=$modules.quince_engine.header.search.provider}
  {if isset($modules.$qDostawca.empty) && $modules.$qDostawca.empty.enabled}
    {assign var=qPusty value=$modules.$qDostawca.empty}
  {/if}
{/if}

<div class="q-listing__empty">

  {if $qSzukanie}
    {* Znak sam w sobie nic nie mówi, więc jest ozdobny i schowany przed
       czytnikiem ekranu. Niesie tylko tyle, że strona nie jest niedokończona. *}
    <svg class="q-listing__empty-icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
      <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
    </svg>

    <p class="q-listing__empty-title">{l s='No results found' d='Shop.Theme.Catalog'}</p>

    <p class="q-listing__empty-text">
      {l s='We could not find any products matching' d='Shop.Theme.Catalog'}
      <strong>&bdquo;{$search_string}&rdquo;</strong>
    </p>

    {if $qPusty && $qPusty.tips}
      <ul class="q-listing__empty-tips">
        {foreach from=$qPusty.tips item="qTip"}
          <li>{$qTip}</li>
        {/foreach}
      </ul>
    {/if}

    {* Ta sama kontrolka co w nagłówku: klient poprawia frazę tutaj, bo tutaj
       dostał odpowiedź. Odesłanie go oczami na górę strony to krok w tył. *}
    <div class="q-listing__empty-search">
      {include file='_partials/search-form.tpl' qFormClass='q-listing__empty-form' qFormId='empty'}
    </div>
  {elseif $qZawezone}
    <p class="q-listing__empty-title">{l s='No product matches the chosen filters' d='Shop.Theme.Catalog'}</p>
    <p class="q-listing__empty-text">{l s='Go back to the full list and narrow it down differently.' d='Shop.Theme.Catalog'}</p>

    <a class="q-btn q-btn--primary" href="{$qBezFiltrow}">
      {l s='Show all products' d='Shop.Theme.Actions'}
    </a>
  {else}
    <p class="q-listing__empty-title">{l s='No products available at the moment' d='Shop.Theme.Catalog'}</p>
    <p class="q-listing__empty-text">{l s='Stay tuned! More products will be shown here as they are added.' d='Shop.Theme.Catalog'}</p>

    <a class="q-btn q-btn--secondary" href="{$urls.pages.index}">
      {l s='Back to Home page' d='Shop.Theme.Catalog'}
    </a>
  {/if}
</div>

{* Kategorie poza pojemnikiem komunikatu: to już nie jest komunikat, tylko
   druga droga dla klienta. Kreska nad nimi oddziela jedno od drugiego. *}
{if $qPusty && $qPusty.categories}
  <section class="q-listing__empty-cats">
    {if $qPusty.cats_title}
      <h2 class="q-listing__empty-cats-title">{$qPusty.cats_title}</h2>
    {/if}

    {include file='catalog/_partials/subcategories.tpl'
      subcategories=$qPusty.categories
      qImages=true
      qIcons=$qPusty.icon_mode
      qHover=true
      qHook=false
      qCenter=true
      qPerRow=$qPusty.cats_per_row}
  </section>
{/if}
