{**
 * Quince: rząd podkategorii.
 *
 * Kafelek jest kwadratem. Kolumn jest dwa razy tyle co w siatce zajawek.
 *
 * Włączniki z panelu:
 *   `qImages`: czy w ogóle pokazujemy zdjęcia,
 *   `qIcons`:  zdjęcie jako maska malowana barwą motywu, dla sklepów,
 *              które mają do kategorii jednobarwne rysunki,
 *   `qHover`:  czy obramowanie zapala się po najechaniu,
 *   `qHook`:   czy wołamy hook `displaySubcategories` (nie na stronie
 *              bez wyników wyszukiwania),
 *   `qCenter`: rząd wyśrodkowany i zawsze w całości, bez przycisku
 *              „Pokaż wszystkie" (strona bez wyników).
 *
 * Hook `displaySubcategories` zostaje: moduł może dopisać własne pozycje albo
 * podstawić cały rząd, nawet gdy kategoria nie ma podkategorii w katalogu.
 *
 * Klasy: components/listing.css
 *}
{* Hook należy do strony kategorii. Rząd kafelków stoi też na stronie bez
   wyników wyszukiwania i tam go nie wołamy: moduł dopisujący własne pozycje
   do kategorii nie ma nic wspólnego z nieudanym szukaniem. *}
{if $qHook|default:true}
  {capture name='qSubcatHook'}{hook h='displaySubcategories' displaySubcategoryImages=$qImages|default:true}{/capture}
{/if}

{if !empty($subcategories) || !empty($smarty.capture.qSubcatHook)}
  <nav class="q-subcats{if $qIcons|default:false} q-subcats--icons{/if}{if !$qHover|default:true} q-subcats--no-hover{/if}{if $qCenter|default:false} q-subcats--center is-whole{/if}"
       {if $qCenter|default:false}style="--q-subcat-w-rzedzie: {$qPerRow|default:5}"{/if}
       aria-label="{l s='Subcategories' d='Shop.Theme.Catalog'}">

    {* Przycisk stoi PRZED kafelkami, choć widać go na końcu rzędu. Grid stawia
       go wtedy w ostatnim polu pierwszego wiersza z wyprzedzeniem, a kafelki
       opływają zajęte miejsce; gdyby szedł ostatni, wskoczyłby na kafelek.
       W stanie rozwiniętym wraca na koniec przez `order`.

       Domyślnie schowany: czy w ogóle jest potrzebny, wie dopiero skrypt, bo
       liczba kafelków w wierszu zależy od progu ekranu. *}
    {if $subcategories|count > 1 && !$qCenter|default:false}
      <button class="q-subcats__more" type="button" data-q-subcats-more hidden
              data-show="{l s='Show all' d='Shop.Theme.Actions'} ({$subcategories|count})"
              data-hide="{l s='Show less' d='Shop.Theme.Actions'}">
        {l s='Show all' d='Shop.Theme.Actions'} ({$subcategories|count})
      </button>
    {/if}

    {foreach from=$subcategories item="subcategory"}
      <a class="q-subcats__item" href="{$subcategory.url}" title="{$subcategory.name}">
        {if $qImages|default:true && !empty($subcategory.thumbnail.bySize.category_default.url)}
          {assign var=qThumb value=$subcategory.thumbnail.bySize.category_default}

          {* W trybie ikony obrazek jest maską, a nie treścią: barwę nadaje mu
             arkusz, więc element musi mieć adres także w `style`. *}
          <img class="q-subcats__image" loading="lazy" decoding="async"
               src="{$qThumb.url}" alt=""
               width="{$qThumb.width}" height="{$qThumb.height}"
               {if $qIcons|default:false}style="--q-subcat-mask: url({$qThumb.url})"{/if}>
        {/if}

        <span class="q-subcats__name">{$subcategory.name}</span>
      </a>
    {/foreach}

    {$smarty.capture.qSubcatHook nofilter}
  </nav>
{/if}
