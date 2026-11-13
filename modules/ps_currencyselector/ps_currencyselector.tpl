{**
 * Quince: wybór waluty
 *
 * Ten sam mały select co przy języku.
 *
 * Kod stoi przed znakiem, bo sam znak bywa niejednoznaczny: „$" to dolar
 * amerykański, kanadyjski i australijski naraz.
 *
 * Klasy: assets/css/components/picker.css (przycisk), dropdown.css (lista)
 *}

{if isset($currencies) && $currencies|count > 1}
  <div id="_desktop_ps_currencyselector" class="q-picker" data-q-picker>
    <button class="q-picker__button" type="button" data-q-picker-button
            aria-expanded="false" aria-haspopup="true"
            aria-label="{l s='Change currency' d='Shop.Theme.Global'}">
      {foreach from=$currencies item=currency}
        {if $currency.current}{$currency.iso_code}{if $currency.sign !== $currency.iso_code} {$currency.sign}{/if}{/if}
      {/foreach}
      <svg class="q-picker__chev" viewBox="0 0 16 16" fill="none" stroke="currentColor"
           stroke-width="2" aria-hidden="true"><path d="m4 6 4 4 4-4"/></svg>
    </button>

    <div class="q-dropdown q-dropdown--end" data-q-dropdown hidden>
      {foreach from=$currencies item=currency}
        <a class="q-dropdown__option" rel="nofollow" href="{$currency.url}"
           {if $currency.current}aria-current="true"{/if}>{$currency.iso_code}{if $currency.sign !== $currency.iso_code} {$currency.sign}{/if}</a>
      {/foreach}
    </div>
  </div>
{/if}
