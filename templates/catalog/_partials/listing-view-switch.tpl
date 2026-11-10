{**
 * Quince — przełącznik widoku listy.
 *
 * Siatka albo lista. Wybór zostaje u klienta, w jego przeglądarce, bo to jego
 * nawyk czytania, a nie ustawienie sklepu: część klientów porównuje zajawki
 * obok siebie, część czyta je jedna pod drugą z dłuższym opisem.
 *
 * Klasa siatki zmienia się na `.q-grid--list`; obsługę przejmuje skrypt
 * listingu.
 *}
{assign var=qWidok value=$modules.quince_engine.listing.view|default:'grid'}

<div class="q-listing__view" role="group" aria-label="{l s='Display' d='Shop.Theme.Global'}">
  <button class="q-listing__view-btn{if $qWidok != 'list'} is-active{/if}" type="button" data-q-view="grid"
          aria-pressed="{if $qWidok != 'list'}true{else}false{/if}" title="{l s='Grid' d='Shop.Theme.Global'}">
    <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M1.5 1.5h5v5h-5zM9.5 1.5h5v5h-5zM1.5 9.5h5v5h-5zM9.5 9.5h5v5h-5z"/></svg>
    <span class="visually-hidden">{l s='Grid' d='Shop.Theme.Global'}</span>
  </button>

  <button class="q-listing__view-btn{if $qWidok == 'list'} is-active{/if}" type="button" data-q-view="list"
          aria-pressed="{if $qWidok == 'list'}true{else}false{/if}" title="{l s='List' d='Shop.Theme.Global'}">
    <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M1.5 2.5h13v2h-13zM1.5 7h13v2h-13zM1.5 11.5h13v2h-13z"/></svg>
    <span class="visually-hidden">{l s='List' d='Shop.Theme.Global'}</span>
  </button>
</div>
