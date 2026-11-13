{**
 * Okruszki.
 *
 * Ostatnia pozycja nie jest odnośnikiem: nie prowadzi nigdzie, bo klient już
 * na niej stoi. Separator rysuje CSS, nie szablon: to dekoracja, a czytnik
 * ekranu ma odczytać samą ścieżkę.
 *
 * Projekt: makieta strony produktu.
 *}
<nav class="q-breadcrumb" data-depth="{$breadcrumb.count}"
     aria-label="{l s='Breadcrumb' d='Shop.Theme.Global'}">
  {block name='breadcrumb_list'}
    <ol class="q-breadcrumb__list">
      {block name='breadcrumb_items'}
        {foreach from=$breadcrumb.links item=pozycja name=okruszki}
          {block name='breadcrumb_item'}
            <li class="q-breadcrumb__item">
              {if $smarty.foreach.okruszki.last}
                <span class="q-breadcrumb__current" aria-current="page">{$pozycja.title}</span>
              {else}
                <a class="q-breadcrumb__link" href="{$pozycja.url}">{$pozycja.title}</a>
              {/if}
            </li>
          {/block}
        {/foreach}
      {/block}
    </ol>
  {/block}
</nav>
