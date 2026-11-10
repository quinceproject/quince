{**
 * Quince: składniki zestawu w panelu zakupu.
 *
 * Na karcie produktu, który sam jest zestawem. W panelu stoi jeden wiersz:
 * ile pozycji i jakie, z podglądem miniatur. Pełna lista czeka w szerokiej
 * szufladzie, tak jak progi rabatowe: wiersz odpowiada na pytanie „co dostanę",
 * a szuflada służy sprawdzaniu.
 *
 * Dane podaje rdzeń: `$packItems` (składniki), `$displayPackPrice`
 * i `$noPackPrice` (suma składników kupowanych osobno).
 *
 * Zmienne: włączniki kolumn z panelu ($qMiniatura, $qNumer, $qIlosc, $qCena,
 * $qStan, $qOdnosnik) oraz $qOsobno, czyli zaznaczanie składników i dodanie
 * ich do koszyka osobno.
 * Zachowanie: assets/js/islands/buybox.js
 * Projekt: makieta strony produktu, przełącznik „produkt jest zestawem".
 *}

{if $packItems|default:[]}
  {assign var=qIle value=$packItems|count}

  <div class="q-packlist">
    <button class="q-packlist__panel" type="button" data-q-pack-open>
      <span class="q-packlist__thumbs" aria-hidden="true">
        {foreach from=$packItems item=qSkladnik name=qPodglad}
          {if $smarty.foreach.qPodglad.iteration > 3}{break}{/if}
          <img src="{if $qSkladnik.default_image}{$qSkladnik.default_image.small.url}{else}{$urls.no_picture_image.bySize.small_default.url}{/if}"
               width="98" height="98" alt="" loading="lazy">
        {/foreach}
      </span>

      <span class="q-packlist__text">
        <span class="q-packlist__title">
          {if $qIle == 1}
            {l s='1 product in this pack' d='Shop.Theme.Catalog'}
          {else}
            {l s='%count% products in this pack' sprintf=['%count%' => $qIle] d='Shop.Theme.Catalog'}
          {/if}
        </span>
        <span class="q-packlist__names">{strip}
          {foreach from=$packItems item=qSkladnik name=qNazwy}
            {if !$smarty.foreach.qNazwy.first}, {/if}{$qSkladnik.name}
          {/foreach}
        {/strip}</span>
      </span>

      <svg class="q-packlist__chev" width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/></svg>
    </button>

    <dialog class="q-modal q-modal--drawer q-modal--wide" data-q-pack-drawer aria-labelledby="q-pack-title"
            data-q-pack-cart="{$urls.pages.cart}" data-q-pack-token="{$static_token}"
            data-q-pack-error="{l s='Some products could not be added to the cart.' d='Shop.Theme.Catalog'}">
      <div class="q-modal__head">
        <h2 class="q-modal__title" id="q-pack-title">
          <svg class="q-modal__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2 5.5 8 2l6 3.5v5L8 14l-6-3.5zM8 3.6 4 5.9v4.2l4 2.3 4-2.3V5.9z"/></svg>
          {l s='Pack contents' d='Shop.Theme.Catalog'} ({$qIle})
        </h2>

        <button class="q-modal__close" type="button" data-q-pack-close
                aria-label="{l s='Close' d='Shop.Theme.Global'}">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/></svg>
        </button>
      </div>

      {* Pasek zaznaczania stoi POZA przewijaną listą: przy długim zestawie
         klient zaznacza pozycje na dole, a przycisk ma być wtedy nadal widoczny. *}
      {if $qOsobno}
        <div class="q-packlist__toolbar">
          <label class="q-choice">
            <input class="q-choice__input" type="checkbox" data-q-pack-all>
            <span class="q-choice__label">{l s='Select all' d='Shop.Theme.Actions'}</span>
          </label>

          {* Napis licznika raz, ze znakiem `#` w miejscu liczby: skrypt podmienia
             go przy każdym zaznaczeniu. Liczba nie idzie wprost do tłumacza, bo
             ten przy zerze oddawał samą cyfrę bez napisu. *}
          {capture name='qWybrane'}{l s='Selected: %count%' sprintf=['%count%' => '#'] d='Shop.Theme.Catalog'}{/capture}
          <span class="q-packlist__count"
                data-q-pack-count="{$smarty.capture.qWybrane}">{$smarty.capture.qWybrane|replace:'#':'0'}</span>

          <button class="q-btn q-btn--primary q-btn--sm" type="button" data-q-pack-add disabled>
            {l s='Add selected to cart' d='Shop.Theme.Actions'}
          </button>
        </div>
      {/if}

      <div class="q-modal__body">
        <table class="q-packlist__table">
          <thead>
            <tr>
              {if $qOsobno}<th scope="col" aria-label="{l s='Select' d='Shop.Theme.Actions'}"></th>{/if}
              <th scope="col"{if $qMiniatura} colspan="2"{/if}>{l s='Product' d='Shop.Theme.Catalog'}</th>
              {if $qCena}<th scope="col" class="q-packlist__num">{l s='Price' d='Shop.Theme.Catalog'}</th>{/if}
              {if $qIlosc}<th scope="col" class="q-packlist__num">{l s='In pack' d='Shop.Theme.Catalog'}</th>{/if}
            </tr>
          </thead>

          <tbody>
            {foreach from=$packItems item=qSkladnik}
              {* Składnika, którego rdzeń nie pozwala dodać do koszyka, nie da się
                 kupić osobno, ale w zestawie nadal jest: wiersz zostaje. *}
              {assign var=qMozna value=!empty($qSkladnik.add_to_cart_url)}

              {if $qSkladnik.availability == 'in_stock' || $qSkladnik.availability == 'available'}
                {assign var=qKlasaStanu value='q-stock--in'}
              {elseif $qSkladnik.availability == 'last_remaining_items'}
                {assign var=qKlasaStanu value='q-stock--low'}
              {else}
                {assign var=qKlasaStanu value='q-stock--out'}
              {/if}

              <tr class="q-packlist__row{if !$qMozna} is-out{/if}">
                {if $qOsobno}
                  <td class="q-packlist__check">
                    <label class="q-choice">
                      <input class="q-choice__input" type="checkbox" data-q-pack-item
                             value="{$qSkladnik.id_product|intval}"
                             data-id-product-attribute="{$qSkladnik.id_product_attribute|intval}"
                             data-qty="{if $qSkladnik.minimal_quantity > 1}{$qSkladnik.minimal_quantity|intval}{else}1{/if}"
                             aria-label="{l s='Select %name%' sprintf=['%name%' => $qSkladnik.name] d='Shop.Theme.Actions'}"
                             {if !$qMozna}disabled{/if}>
                    </label>
                  </td>
                {/if}

                {if $qMiniatura}
                  <td class="q-packlist__img">
                    <img src="{if $qSkladnik.default_image}{$qSkladnik.default_image.small.url}{else}{$urls.no_picture_image.bySize.small_default.url}{/if}"
                         width="98" height="98" alt="" loading="lazy">
                  </td>
                {/if}

                <td class="q-packlist__product">
                  {if $qOdnosnik}
                    <a class="q-packlist__name" href="{$qSkladnik.url}">{$qSkladnik.name}</a>
                  {else}
                    <span class="q-packlist__name">{$qSkladnik.name}</span>
                  {/if}

                  {if ($qNumer && $qSkladnik.reference) || ($qStan && $qSkladnik.availability_message)}
                    <span class="q-packlist__meta">
                      {if $qNumer && $qSkladnik.reference}<span>{$qSkladnik.reference}</span>{/if}
                      {if $qStan && $qSkladnik.availability_message}
                        <span class="q-stock {$qKlasaStanu}"><span class="q-stock__dot" aria-hidden="true"></span>{$qSkladnik.availability_message}</span>
                      {/if}
                    </span>
                  {/if}
                </td>

                {if $qCena}
                  <td class="q-packlist__price">{if $qSkladnik.show_price}{$qSkladnik.price}{/if}</td>
                {/if}

                {if $qIlosc}
                  <td class="q-packlist__qty">&times; {$qSkladnik.pack_quantity|intval}</td>
                {/if}
              </tr>
            {/foreach}
          </tbody>
        </table>
      </div>

      <div class="q-modal__foot">
        {* Suma składników kupowanych osobno przy cenie zestawu: to powód, dla
           którego ktoś bierze zestaw. Rdzeń podaje ją tylko wtedy, gdy zestaw
           jest tańszy od swoich składników. *}
        {if $displayPackPrice|default:false && $product.show_price}
          {assign var=qOszczednosc value=$product.nopackprice - $product.price_amount}

          <div class="q-packlist__summary">
            <span>{l s='Bought separately' d='Shop.Theme.Catalog'} <s>{$noPackPrice}</s></span>
            <span>{l s='Pack price' d='Shop.Theme.Catalog'} <strong>{$product.price}</strong></span>
            <span class="q-packlist__save">{l s='You save %amount%' sprintf=['%amount%' => $qOszczednosc|qprice] d='Shop.Theme.Catalog'}</span>
          </div>
        {/if}

        <button class="q-btn q-btn--primary q-btn--lg" type="button" data-q-pack-close>
          {l s='Back to purchase' d='Shop.Theme.Actions'}
        </button>
      </div>
    </dialog>
  </div>
{/if}
