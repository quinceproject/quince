{**
 * Quince — pas nawigacji
 *
 * Kategorie i odnośniki własne. Projekt: widok paska nawigacji.
 *
 * Wszystko przychodzi gotowe w `$modules.quince_engine.navigation`: gałęzie
 * kategorii z nazwami i adresami, odnośniki własne rozwiązane dla języka,
 * wybory sprowadzone do wartości logicznych. W szablonie nie ma zapytań do bazy
 * ani obliczeń.
 *
 * Kategorie stoją zawsze pod jednym przyciskiem; obok niego wyłącznie odnośniki
 * własne. O kształcie rozwinięcia — kolumny, kafelki albo kaskada — decyduje
 * ustawienie `panel`; treść jest we wszystkich przypadkach ta sama.
 *
 * Klasy: assets/css/components/navbar.css
 *}

{if isset($modules.quince_engine.navigation) && $modules.quince_engine.navigation.enabled}
  {assign var=qn value=$modules.quince_engine.navigation}

  <nav class="q-nav" data-q-nav>
    <div class="q-nav__inner">

      {* ── katalog pod przyciskiem ── *}
      <div class="q-nav__group" data-q-nav-item>
          <button class="q-nav__item q-nav__trigger" type="button" data-q-nav-button aria-expanded="false">
            {if $qn.trigger.icon}
              <svg class="q-nav__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                {$qn.trigger.icon nofilter}
              </svg>
            {/if}
            {if $qn.trigger.text}{$qn.trigger.text}{else}{l s='Categories' d='Shop.Theme.Catalog'}{/if}
            <svg class="q-nav__chev" width="10" height="10" viewBox="0 0 16 16"
                 fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
          </button>

        {include file='_partials/navbar-panel.tpl' qn=$qn branches=$qn.branches}
      </div>

      {* ── odnośniki własne ──
         Stoją po kategoriach, bo prowadzą poza katalog: promocje, szkolenia, blog.
         Odnośnik bez nazwy albo bez adresu nie dojdzie tutaj — odsiewa go silnik. *}
      {foreach from=$qn.links item=link}
        <a class="q-nav__item{if $link.style != 'normal'} q-nav__item--{$link.style}{/if}"
           href="{$link.url}">
          {if $link.icon}
            <svg class="q-nav__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
              {$link.icon nofilter}
            </svg>
          {/if}
          {$link.label}
        </a>
      {/foreach}
    </div>
  </nav>
{/if}
