{**
 * Quince — wybór wariantu w panelu zakupu.
 *
 * Kafelki zamiast pól wyboru: przy pięciu opcjach w rzędzie klient ma zobaczyć
 * wybraną, a nie jej szukać. Wybrany kafelek jest wypełniony barwą marki,
 * niedostępny — przekreślony.
 *
 * Rodzaj grupy ustawia sklep w katalogu i to on decyduje o kontrolce:
 *   `radio` i `color` → kafelki, przy barwie z kropką w tej barwie,
 *   `select`         → lista rozwijana, bo tak sklep zapisał tę grupę.
 *
 * Pod kafelkiem siedzi zwykłe pole wyboru z nazwą `group[<id>]`. To ono niesie
 * wybór do formularza i to na jego zmianie PrestaShop przeładowuje cenę,
 * dostępność i zdjęcia — kafelek jest tylko jego etykietą.
 *
 * Klasa `js-product-variants` zostaje na korzeniu: po niej rdzeń podmienia blok
 * po zmianie wariantu i po niej rozpoznaje pola wewnątrz.
 *}

{if isset($groups) && $groups}
  <div class="q-variants js-product-variants">
    {foreach from=$groups key=qIdGrupy item=qGrupa}
      {if !empty($qGrupa.attributes)}
        {assign var=qIdListy value="group_{$qIdGrupy}_{$product.id}"}
        {assign var=qIdEtykiety value="legend_{$qIdGrupy}_{$product.id}"}

        <fieldset class="q-variants__group">
          {* Nazwa grupy i wybrana wartość w jednym wierszu: „Rozmiar: M" czyta
             się jak zdanie, a dwie linijki obok siebie jak dwie sprawy. *}
          <legend class="q-variants__label" id="{$qIdEtykiety}">
            {$qGrupa.name}:
            <span>
              {foreach from=$qGrupa.attributes item=qWariant}
                {if $qWariant.selected}{$qWariant.name}{/if}
              {/foreach}
            </span>
          </legend>

          {if $qGrupa.group_type == 'select'}
            <select class="form-select"
                    id="input_{$qIdGrupy}_{$product.id}"
                    aria-labelledby="{$qIdEtykiety}"
                    data-product-attribute="{$qIdGrupy}"
                    name="group[{$qIdGrupy}]">
              {foreach from=$qGrupa.attributes key=qIdWariantu item=qWariant}
                <option value="{$qIdWariantu}"{if $qWariant.selected} selected{/if}>{$qWariant.name}</option>
              {/foreach}
            </select>
          {else}
            <div class="q-variants__list" id="{$qIdListy}" role="radiogroup" aria-labelledby="{$qIdEtykiety}">
              {foreach from=$qGrupa.attributes key=qIdWariantu item=qWariant}
                <label class="q-variant{if $qWariant.selected} is-active{/if}"
                       {if !$qWariant.selected && isset($qWariant.available) && !$qWariant.available}
                         title="{l s='Currently unavailable' d='Shop.Theme.Catalog'}"
                       {/if}>
                  <input class="visually-hidden"
                         type="radio"
                         name="group[{$qIdGrupy}]"
                         value="{$qIdWariantu}"
                         data-product-attribute="{$qIdGrupy}"
                         {if $qWariant.selected} checked{/if}>

                  {* Kropka w barwie wariantu tylko przy grupie barw. Makieta jej
                     nie ma, bo nie pokazuje produktu w kolorach, a nazwa sama
                     („Grafit", „Antracyt") nie mówi, jak to wygląda. *}
                  {if $qGrupa.group_type == 'color' && ($qWariant.html_color_code || $qWariant.texture)}
                    <span class="q-variant__dot" aria-hidden="true"
                          style="{if $qWariant.texture}background-image:url({$qWariant.texture}){else}background-color:{$qWariant.html_color_code}{/if}"></span>
                  {/if}

                  <span class="q-variant__name">{$qWariant.name}</span>
                </label>
              {/foreach}
            </div>
          {/if}
        </fieldset>
      {/if}
    {/foreach}
  </div>
{/if}
