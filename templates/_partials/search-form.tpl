{**
 * Quince: pole wyszukiwania.
 *
 * Jeden formularz na dwa miejsca: pas nagłówka i strona bez wyników. Klient ma
 * tam poprawić frazę, więc musi dostać dokładnie tę samą kontrolkę, z tym samym
 * wyborem zakresu i tymi samymi podpowiedziami. Druga, przepisana kopia
 * rozjechałaby się z pierwszą przy pierwszej zmianie.
 *
 * Wszystko liczy sobie sam z `$modules`, bo na stronie bez wyników nie ma wokół
 * niego szablonu nagłówka, który by mu to podał.
 *
 * Zmienne wejściowe:
 *   `qFormClass`: klasa formularza, bo w nagłówku i pod listą ma inną szerokość,
 *   `qFormId`:    człon identyfikatora listy podpowiedzi; dwa pola na jednej
 *                  stronie nie mogą mieć tego samego `id`.
 *
 * Klasy: components/search.css
 *}

{if isset($modules.quince_engine.header)}
  {assign var=qhf value=$modules.quince_engine.header}

  {if $qhf.search.enabled}
    {assign var=qfProvider value=$qhf.search.provider}

    {if $qhf.search.scope && isset($modules.$qfProvider.scopes) && $modules.$qfProvider.scopes}
      {assign var=qfScopes value=$modules.$qfProvider.scopes}
    {else}
      {assign var=qfScopes value=[]}
    {/if}

    {if isset($modules.$qfProvider.suggest) && $modules.$qfProvider.suggest.enabled}
      {assign var=qfSuggest value=$modules.$qfProvider.suggest}
    {else}
      {assign var=qfSuggest value=false}
    {/if}

    <form class="{$qFormClass|default:'q-header__search'}" method="get" action="{$urls.pages.search}" role="search"
          {if $qfSuggest}data-q-suggest
          data-q-suggest-url="{$qfSuggest.url}"
          data-q-suggest-min="{$qfSuggest.min_chars}"
          data-q-suggest-empty="{l s='Nothing matches that phrase' d='Shop.Theme.Catalog'}"
          data-q-suggest-all="{l s='Show all results' d='Shop.Theme.Actions'}"{/if}>
      <div class="q-search">
        <input class="q-search__input" type="search" name="s" value="{$smarty.get.s|default:''}"
               placeholder="{if $qhf.search.placeholder}{$qhf.search.placeholder}{else}{l s='Search our catalog' d='Shop.Theme.Catalog'}{/if}"
               aria-label="{l s='Search' d='Shop.Theme.Catalog'}">

        {if $qfScopes}
          {assign var=qfScopeFirst value=$qfScopes[0]}
          <div class="q-search__scope-wrap" data-q-picker data-q-scope>
            <input type="hidden" name="q_scope" value="{$qfScopeFirst.key}" data-q-scope-value>
            <button class="q-search__scope" type="button" data-q-picker-button
                    aria-haspopup="true" aria-expanded="false">
              <span data-q-scope-label>{$qfScopeFirst.label}</span>
              <svg width="10" height="10" viewBox="0 0 16 16" fill="currentColor"
                   aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
            </button>

            <div class="q-dropdown q-dropdown--attached" data-q-dropdown hidden>
              {foreach from=$qfScopes item=scope}
                <button class="q-dropdown__option" type="button"
                        data-q-scope-option="{$scope.key}"
                        aria-current="{if $scope@first}true{else}false{/if}">{$scope.label}</button>
              {/foreach}
            </div>
          </div>
        {/if}

        <button class="q-search__submit" type="submit" aria-label="{l s='Search' d='Shop.Theme.Catalog'}">
          {if $qhf.search.icon}
            <svg width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
              {$qhf.search.icon nofilter}
            </svg>
          {/if}
        </button>

        {* Lista podpowiedzi stoi wewnątrz kontrolki, bo bierze jej szerokość
           i wysuwa się wprost spod niej. Wypełnia ją wyspa suggest.js. *}
        {if $qfSuggest}
          <div class="q-dropdown q-dropdown--wide q-dropdown--attached q-dropdown--scroll q-suggest"
               id="q-suggest-{$qFormId|default:'header'}" role="listbox" data-q-suggest-list hidden></div>
        {/if}
      </div>
    </form>
  {/if}
{/if}
