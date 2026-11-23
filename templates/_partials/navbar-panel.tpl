{**
 * Quince: rozwinięcie nawigacji
 *
 * Jeden materiał, trzy układy. Wywoływany z navbar.tpl:
 *   qn       ustawienia nawigacji
 *   branches gałęzie do pokazania
 *
 * Klasy: assets/css/components/navbar.css
 *}

{assign var=qPanelClass value="q-nav__panel"}

{* ── kaskada ──
   Zamiast całego drzewa naraz jedna wąska kolumna, a kolejne poziomy wysuwają
   się w prawo po najechaniu. Dla głębokiego katalogu: klient czyta kilkanaście
   nazw zamiast stu i schodzi w dół jedną ścieżką. *}
{if $qn.panel == 'cascade'}
  <div class="{$qPanelClass} q-nav__panel--cascade" data-q-nav-panel hidden>
    <div class="q-nav__panel-inner">
      {include file='_partials/navbar-level.tpl' items=$branches}
    </div>
  </div>

{* ── kafelki ──
   Dla płaskiego katalogu: obrazek i nazwa zamiast listy, bo przy kilkunastu
   kategoriach wybiera się wzrokiem, nie czytaniem. Jednopoziomowe z założenia:
   kafelek jest zajawką kategorii, a nie węzłem drzewa. *}
{elseif $qn.panel == 'tiles'}
  <div class="{$qPanelClass}" data-q-nav-panel hidden>
    <div class="q-nav__panel-inner">
      <div class="q-nav__tiles" style="grid-template-columns:repeat({$qn.tile_columns},1fr)">
        {foreach from=$branches item=branch}
          {foreach from=$branch.children item=child}
            <a class="q-nav__tile" href="{$child.url}">
              {if $child.image && $qn.tile_icon_mode}
                <span class="q-nav__tile-img q-nav__tile-img--maska" role="img" aria-label="{$child.name}"
                      style="mask-image:url({$child.image});-webkit-mask-image:url({$child.image})"></span>
              {elseif $child.image}
                <img class="q-nav__tile-img" src="{$child.image}" alt="{$child.name}" loading="lazy">
              {/if}
              {$child.name}
            </a>
          {/foreach}
          {if !$branch.children}
            <a class="q-nav__tile" href="{$branch.url}">
              {if $branch.image && $qn.tile_icon_mode}
                <span class="q-nav__tile-img q-nav__tile-img--maska" role="img" aria-label="{$branch.name}"
                      style="mask-image:url({$branch.image});-webkit-mask-image:url({$branch.image})"></span>
              {elseif $branch.image}
                <img class="q-nav__tile-img" src="{$branch.image}" alt="{$branch.name}" loading="lazy">
              {/if}
              {$branch.name}
            </a>
          {/if}
        {/foreach}
      </div>
    </div>
  </div>

{* ── kolumny ──
   Działy po lewej, zawartość wybranego po prawej. Domyślny układ: pokazuje
   całą szerokość katalogu bez zmuszania do wchodzenia w kolejne poziomy. *}
{else}
  {* Modyfikator --columns włącza siatkę: kolumna działów po lewej, zawartość
     po prawej. Bez niego panel układa wszystko jedno pod drugim. *}
  <div class="{$qPanelClass} q-nav__panel--columns" data-q-nav-panel hidden>
    <div class="q-nav__panel-inner">
      <div class="q-nav__cats">
        {* Dział bez podkategorii jest zwykłym odnośnikiem: nie dostaje znacznika
           przełączania, bo nie ma czego pokazać po prawej. Najechanie na niego
           zostawia widok bez zmian, zamiast czyścić go do pustej kolumny. *}
        {foreach from=$branches item=branch name=cats}
          <a class="q-nav__cat{if $smarty.foreach.cats.first && $branch.children} is-current{/if}"
             href="{$branch.url}"{if $branch.children} data-q-nav-cat="{$branch.id}"{/if}>
            {if $branch.icon}
              <svg class="q-nav__cat-ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                {$branch.icon nofilter}
              </svg>
            {/if}
            {$branch.name}
            {if $branch.children}
              <svg class="q-nav__cat-arrow" viewBox="0 0 16 16" fill="currentColor"
                   aria-hidden="true"><path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/></svg>
            {/if}
          </a>
        {/foreach}
      </div>

      {foreach from=$branches item=branch name=subs}
        {if !$branch.children}{continue}{/if}
        <div class="q-nav__section" data-q-nav-subs="{$branch.id}"{if !$smarty.foreach.subs.first} hidden{/if}>
          {* Nazwa działu nad jego zawartością: panel zajmuje pół ekranu i bez niej
             klient traci z oczu to, w co najechał. *}
          <div class="q-nav__section-title">
            {if $branch.icon}
              <svg class="q-nav__cat-ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                {$branch.icon nofilter}
              </svg>
            {/if}
            <a href="{$branch.url}">{$branch.name}</a>
          </div>

          {* `column-count` to górna granica; navbar.js zmniejsza ją, gdy
             podkategorie mieszczą się w mniejszej liczbie kolumn. *}
          <div class="q-nav__subs" style="column-count:{$qn.columns}" data-q-nav-cols="{$qn.columns}">
          {* Podkategoria z własnymi dziećmi jest nagłówkiem grupy i zbiera je pod
             sobą. Bez dzieci jest zwykłą pozycją, bo nagłówek, pod którym nic nie
             stoi, wygląda jak napis, w który nie da się kliknąć. *}
          {foreach from=$branch.children item=child}
            {if $child.children}
              {* Nagłówek i jego pozycje w jednym bloku, dzięki temu przeglądarka
                 nie przetnie grupy między kolumnami. *}
              <div class="q-nav__group-block">
                <div class="q-nav__group-title">
                  <a href="{$child.url}">{$child.name}</a>
                </div>
                {foreach from=$child.children item=grand}
                  <a class="q-nav__sub" href="{$grand.url}">{$grand.name}</a>
                {/foreach}
              </div>
            {else}
              <a class="q-nav__sub" href="{$child.url}">{$child.name}</a>
            {/if}
          {/foreach}
          </div>
        </div>
      {/foreach}
    </div>
  </div>
{/if}
