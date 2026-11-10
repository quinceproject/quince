{**
 * Quince — wybór języka
 *
 * Mały select w pasie: na przycisku i na liście stoi sam kod języka.
 * Pełne nazwy nic tu nie wnoszą — kto szuka „EN", rozpozna „EN", a lista
 * na dwie pozycje nie ma prawa być szersza od tego, co pokazuje.
 *
 * Pozycje są odnośnikami, nie przyciskami: zmiana języka to przejście pod inny
 * adres. Działa otwarcie w nowej karcie i przełączenie bez JavaScriptu.
 *
 * Klasy: assets/css/components/picker.css (przycisk), dropdown.css (lista)
 *}

{if isset($languages) && $languages|count > 1}
  <div id="_desktop_ps_languageselector" class="q-picker" data-q-picker>
    <button class="q-picker__button" type="button" data-q-picker-button
            aria-expanded="false" aria-haspopup="true"
            aria-label="{l s='Change language' d='Shop.Theme.Global'}">
      {$current_language.iso_code|upper}
      <svg class="q-picker__chev" viewBox="0 0 16 16" fill="none" stroke="currentColor"
           stroke-width="2" aria-hidden="true"><path d="m4 6 4 4 4-4"/></svg>
    </button>

    <div class="q-dropdown q-dropdown--end" data-q-dropdown hidden>
      {foreach from=$languages item=language}
        <a class="q-dropdown__option" href="{url entity='language' id=$language.id_lang}"
           {if $language.id_lang == $current_language.id_lang}aria-current="true"{/if}
           title="{$language.name_simple}">{$language.iso_code|upper}</a>
      {/foreach}
    </div>
  </div>
{/if}
