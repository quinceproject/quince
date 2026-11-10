{**
 * Quince — jeden element listingu.
 *
 * Strefy renderują listę identyfikatorów, którą przysyła silnik; ten plik jest
 * jedynym miejscem, gdzie identyfikator zamienia się w treść. Przestawienie
 * elementu w panelu nie wymaga zmiany w żadnym szablonie, a dołożenie nowego
 * elementu to jedna gałąź tutaj. Tak samo działa `pdp-element.tpl` na karcie
 * produktu.
 *
 * Jeden zestaw gałęzi obsługuje siedem stron z listą produktów: kategorię,
 * markę, dostawcę, wyszukiwarkę, nowości, promocje i bestsellery. Element,
 * który na danej stronie nie ma czego pokazać — podkategorie poza kategorią,
 * opis poza kategorią i marką — nie renderuje nic i nie przerywa strony.
 *
 * Zmienne: $qEl — element z katalogu silnika: `id`, `hook`, `options`.
 *}

{assign var=qId value=$qEl.id}

{* Miejsce wstawione przez sklep, a nie element silnika: identyfikator ma postać
   `hook:<nazwa>`, a treść przynosi moduł podpięty pod ten hook.

   Treść w pojemniku, a nie surowo: bez niego nie ma czego złapać odstępem od
   tego, co stoi wyżej, a odstęp w tym motywie niesie element STOJĄCY NIŻEJ, bo
   każdy z nich sklep może wyłączyć. Przy okazji hook, który nic nie zwróci, nie
   zostawia po sobie pustego wiersza. Ten sam pojemnik co przy „Modułach nad
   listą”: dla strony to jest ta sama rzecz, czyli cudza treść w naszej stronie. *}
{if $qEl.hook}
  {capture assign='qHookHtml'}{hook h=$qEl.hook}{/capture}
  {if $qHookHtml|trim}
    <div class="q-listing__modules">{$qHookHtml nofilter}</div>
  {/if}

{elseif $qId == 'breadcrumb'}
  {include file='_partials/breadcrumb.tpl'}

{elseif $qId == 'title'}
  {* Tytuł bierze się z kontrolera: nazwa kategorii, marki albo dostawcy siedzi
     już w `listing.label`. Wyjątkiem jest wyszukiwarka, gdzie tytuł niesie samą
     odpowiedź: czy coś znaleziono i dla jakiej frazy. Ta treść stała dotąd
     w `search.tpl` i nadpisywała cały blok nagłówka, przez co ustawienia stref
     nie działały na wynikach wyszukiwania. *}
  {if isset($search_string)}
    {* Tytuł mówi, na jakiej stronie klient jest, a nie jaki jest wynik.
       O wyniku mówi komunikat pod nim i przy zerze trafień trzy zdania pod rząd
       powtarzałyby to samo. *}
    {if !$search_string}
      {assign var=qTytul value={l s='Nothing to search for' d='Shop.Theme.Catalog'}}
    {else}
      {assign var=qTytul value={l s='Search results for "%search_term%"' sprintf=['%search_term%' => $search_string] d='Shop.Theme.Catalog'}}
    {/if}
  {* Nazwa strony przed etykietą listingu. `listing.label` to zdanie rdzenia
     w rodzaju „Kategoria: Clothes" albo „Lista produktów marki X" — dobre jako
     opis wyniku wyszukiwania, ale nie jako nagłówek strony, na której klient
     już wie, gdzie jest. *}
  {elseif isset($category.name)}
    {assign var=qTytul value=$category.name}
  {elseif isset($manufacturer.name)}
    {assign var=qTytul value=$manufacturer.name}
  {elseif isset($supplier.name)}
    {assign var=qTytul value=$supplier.name}
  {else}
    {assign var=qTytul value=$listing.label}
  {/if}

  <h1 class="q-listing__title">{$qTytul}</h1>

{elseif $qId == 'description'}
  {* Opis pokazujemy albo tylko na pierwszej stronie, albo na każdej. Rdzeń
     zna tylko pierwszy wariant, ale opis kategorii bywa też zapleczem dla
     wyszukiwarek i wtedy ma stać wszędzie.

     Źródło zależy od strony: kategoria, marka i dostawca mają własny opis,
     a nowości czy promocje nie mają żadnego. *}
  {if !$qEl.options.first_page|default:true
      || $listing.pagination.items_shown_from == 1
      || $modules.quince_engine.listing.pagination|default:'pages' == 'more'}
    {assign var=qOpis value=''}
    {if isset($category.description)}{assign var=qOpis value=$category.description}
    {elseif isset($manufacturer.short_description)}{assign var=qOpis value=$manufacturer.short_description}
    {elseif isset($supplier.description)}{assign var=qOpis value=$supplier.description}
    {/if}

    {if $qOpis}
      <div class="q-listing__intro q-prose rich-text">{$qOpis nofilter}</div>
    {/if}
  {/if}

{elseif $qId == 'cover'}
  {if !empty($category.cover.large.url)}
    <div class="q-listing__cover">
      <picture>
        {if isset($category.cover.large.sources.avif)}
          <source srcset="{$category.cover.large.sources.avif}" type="image/avif">
        {/if}
        {if isset($category.cover.large.sources.webp)}
          <source srcset="{$category.cover.large.sources.webp}" type="image/webp">
        {/if}
        <img src="{$category.cover.large.url}"
             alt="{$category.cover.legend|default:$category.name}"
             width="{$category.cover.large.width}"
             height="{$category.cover.large.height}"
             fetchpriority="high">
      </picture>
    </div>
  {/if}

{elseif $qId == 'subcategories'}
  {include file='catalog/_partials/subcategories.tpl'
    subcategories=$subcategories|default:[]
    qImages=$qEl.options.images|default:true
    qIcons=$qEl.options.icons|default:false
    qHover=$qEl.options.hover|default:true}

{elseif $qId == 'hook_header'}
  {* Treść modułów w pojemniku, a nie surowo: bez niego nie ma czego złapać
     odstępem od tego, co stoi wyżej, a odstęp w tym motywie niesie element
     STOJĄCY NIŻEJ, bo każdy z nich sklep może wyłączyć. Przy okazji hook,
     który nic nie zwróci, nie zostawia po sobie pustego wiersza. *}
  {capture assign='qHookHtml'}{hook h='displayHeaderCategory'}{/capture}
  {if $qHookHtml|trim}
    <div class="q-listing__modules">{$qHookHtml nofilter}</div>
  {/if}

{elseif $qId == 'facets'}
  {* Filtry przychodzą gotowe: HTML robi rdzeń albo ps_facetedsearch, zależnie
     od tego, który z nich przejął wyszukiwanie. Silnik decyduje wyłącznie
     o miejscu, w którym ten kawałek stanie. *}
  {if !empty($listing.rendered_facets)}
    {$listing.rendered_facets nofilter}
  {/if}

{elseif $qId == 'filters_button'}
  {if !empty($listing.rendered_facets)}
    <button class="q-btn q-btn--secondary q-listing__filters-open" type="button"
            data-q-filters-open aria-expanded="false" aria-controls="q-filters">
      <svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M1.5 3h13v1.2l-5 4.8V14l-3-1.5V9L1.5 4.2z"/></svg>
      {l s='Filters' d='Shop.Theme.Actions'}
      {if $qEl.options.count|default:true && $qActiveFilters > 0}
        <span class="q-listing__filters-count">{$qActiveFilters}</span>
      {/if}
    </button>
  {/if}

{elseif $qId == 'count'}
  {* Sama liczba wytłuszczona, a po niej rzeczownik. Zdanie rdzenia („Jest 2
     produktów.") czyta się jak komunikat systemu, a nie jak etykieta w pasku
     narzędzi, i przy każdej liczbie wychodzi z niego inna odmiana.

     Przy pustej liście nie ma czego liczyć: „0 produktów" powtarza to, co
     mówi już komunikat pod paskiem. *}
  {if $listing.products|default:[]|@count > 0}
    <span class="q-listing__count">
      <b>{$listing.pagination.total_items}</b> {l s='products' d='Shop.Theme.Catalog'}
    </span>
  {/if}

{elseif $qId == 'sort'}
  {* Pustej listy nie ma po czym porządkować. *}
  {if $listing.products|default:[]|@count > 0}
    {block name='sort_by'}
      {include file='catalog/_partials/sort-orders.tpl' sort_orders=$listing.sort_orders}
    {/block}
  {/if}

{elseif $qId == 'view_switch'}
  {* Przełącznik ma sens tylko wtedy, gdy jest między czym przełączać. Przy
     jednym widoku sklep i tak wymusza ten jeden, więc przycisk byłby kontrolką,
     która nic nie zmienia. *}
  {if $modules.quince_engine.listing.views|default:'both' == 'both'
      && $listing.products|default:[]|@count > 0}
    {include file='catalog/_partials/listing-view-switch.tpl'}
  {/if}

{elseif $qId == 'active_filters'}
  {* Pigułki zawężeń renderuje rdzeń albo moduł filtrów, tak samo jak same
     filtry, i to one niosą klasę `q-listing__pills`.

     Bez własnej owijki: pojemnik z jednym schowanym dzieckiem nie jest pusty,
     więc reguła `:empty` go nie gasiła i pasek narzędzi miał drugi, pusty
     wiersz z wcięciem i kreską, mimo że żadnego zawężenia nie wybrano. *}
  {$listing.rendered_active_filters nofilter}

{elseif $qId == 'pagination'}
  {block name='pagination'}
    {if $modules.quince_engine.listing.pagination|default:'pages' == 'more'}
      {include file='catalog/_partials/listing-more.tpl' pagination=$listing.pagination}
    {else}
      {include file='_partials/pagination.tpl' pagination=$listing.pagination}
    {/if}
  {/block}

{elseif $qId == 'additional_description'}
  {if isset($category.additional_description) && $category.additional_description
      && (!$qEl.options.first_page|default:true
          || $listing.pagination.items_shown_from == 1
          || $modules.quince_engine.listing.pagination|default:'pages' == 'more')}
    <section class="q-listing__outro q-prose rich-text">{$category.additional_description nofilter}</section>
  {/if}

{elseif $qId == 'hook_footer'}
  {capture assign='qHookHtml'}{hook h='displayFooterCategory'}{/capture}
  {if $qHookHtml|trim}
    <div class="q-listing__modules">{$qHookHtml nofilter}</div>
  {/if}

{elseif $qId == 'section'}
  {* Rząd polecanych. Produkty przynosi moduł, więc silnik podaje mu to, czego
     sam ze swojego miejsca nie odczyta: listę, pod którą rząd stoi, oraz numer
     kategorii albo marki. Pola kontrolera, w których te numery siedzą, są
     chronione, a ten sam hook odpala się na siedmiu różnych stronach. *}
  {capture assign='qSekcjaHtml'}{hook h='displayQuinceListingSection'
    listing=$listing
    idCategory=$category.id|default:0
    idManufacturer=$manufacturer.id|default:0}{/capture}
  {if $qSekcjaHtml|trim}
    {$qSekcjaHtml nofilter}
  {/if}

{/if}
