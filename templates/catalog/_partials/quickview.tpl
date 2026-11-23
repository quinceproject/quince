{**
 * Quince: szybki podgląd produktu.
 *
 * Treść okna, które otwiera oko na zajawce. Rdzeń renderuje ten szablon
 * w odpowiedzi na `action=quickview` i oddaje go jako `quickview_html`;
 * szufladę dookoła buduje wyspa (`assets/js/islands/quickview.js`).
 *
 * Podgląd domyka zakup TYLKO przy produkcie bez wersji. Przy produkcie
 * z wersjami „Do koszyka" dorzuciłoby wersję domyślną, o czym klient by nie
 * wiedział, a wybierak wersji w oknie znaczyłby przeładowywanie ceny,
 * dostępności i terminu po każdym kliknięciu, czyli drugą kartę produktu.
 *
 * Kawałki są te same, co na karcie produktu: plakietki, ocena, pas promocji,
 * blok cen, dostępność, serce i „Kup teraz". Jeden komponent, jeden wygląd.
 *
 * Projekt: makieta strony produktu, szuflada „podglad".
 *}

{assign var=qWersje value=($product.attributes|default:[])|count}

<div class="q-quickview__gallery">
  <div class="q-quickview__frame">
    {include file='catalog/_partials/product-flags.tpl' qBadgesClass='q-quickview__badges'}

    {* Formaty sklepu jako źródła `<picture>`, jak w galerii karty produktu. *}
    <picture class="q-gallery__picture">
      {if $product.cover && isset($product.cover.bySize.large_default.sources.avif)}
        <source type="image/avif" srcset="{$product.cover.bySize.large_default.sources.avif}">
      {/if}
      {if $product.cover && isset($product.cover.bySize.large_default.sources.webp)}
        <source type="image/webp" srcset="{$product.cover.bySize.large_default.sources.webp}">
      {/if}
      <img class="q-quickview__photo" data-q-quickview-main
           src="{if $product.cover}{$product.cover.bySize.large_default.url}{else}{$urls.no_picture_image.bySize.large_default.url}{/if}"
           alt="{if $product.cover}{$product.cover.legend}{else}{$product.name}{/if}"
           width="800" height="800">
    </picture>
  </div>

  {* Pas miniatur: podgląd ma odpowiedzieć na „czy to na pewno to", a przy
     jednym zdjęciu z ośmiu odpowiada na to w jednej ósmej. Na telefonie pas
     zamieniają kropki, tak jak w galerii karty produktu. *}
  {if $product.images|count > 1}
    <div class="q-gallery__thumbs q-quickview__thumbnails">
      {foreach from=$product.images item=qFoto name=qFotki}
        <button class="q-gallery__thumb{if $smarty.foreach.qFotki.first} is-active{/if}" type="button"
                data-q-quickview-photo="{$qFoto.bySize.large_default.url}"
                {if isset($qFoto.bySize.large_default.sources.webp)}data-q-quickview-webp="{$qFoto.bySize.large_default.sources.webp}"{/if}
                {if isset($qFoto.bySize.large_default.sources.avif)}data-q-quickview-avif="{$qFoto.bySize.large_default.sources.avif}"{/if}
                aria-label="{l s='Photo %number%' sprintf=['%number%' => $smarty.foreach.qFotki.iteration] d='Shop.Theme.Global'}">
          <picture class="q-gallery__picture">
            {if isset($qFoto.bySize.small_default.sources.avif)}
              <source type="image/avif" srcset="{$qFoto.bySize.small_default.sources.avif}">
            {/if}
            {if isset($qFoto.bySize.small_default.sources.webp)}
              <source type="image/webp" srcset="{$qFoto.bySize.small_default.sources.webp}">
            {/if}
            <img src="{$qFoto.bySize.small_default.url}" alt="{$qFoto.legend}" loading="lazy" width="98" height="98">
          </picture>
        </button>
      {/foreach}
    </div>

    <div class="q-gallery__dots q-quickview__dots">
      {foreach from=$product.images item=qFoto name=qKropki}
        <button class="q-gallery__dot{if $smarty.foreach.qKropki.first} is-active{/if}" type="button"
                data-q-quickview-photo="{$qFoto.bySize.large_default.url}"
                {if isset($qFoto.bySize.large_default.sources.webp)}data-q-quickview-webp="{$qFoto.bySize.large_default.sources.webp}"{/if}
                {if isset($qFoto.bySize.large_default.sources.avif)}data-q-quickview-avif="{$qFoto.bySize.large_default.sources.avif}"{/if}
                aria-label="{l s='Photo %number%' sprintf=['%number%' => $smarty.foreach.qKropki.iteration] d='Shop.Theme.Global'}"></button>
      {/foreach}
    </div>
  {/if}
</div>

<div class="q-quickview__head">
  <h3 class="q-quickview__name">{$product.name}</h3>

  {include file='catalog/_partials/product-rating.tpl'}

  {if $product.description_short}
    <div class="q-quickview__description rich-text">{$product.description_short nofilter}</div>
  {/if}
</div>

{* Ceny w ramce z nagłówkiem: pas promocji domyka moduł cen tak samo, jak
   domyka panel zakupu na karcie produktu. Bez obniżki ramka znika razem
   z pasem, bo bez nagłówka byłaby pudełkiem wokół dwóch kwot. *}
<div class="q-quickview__prices">
  {include file='catalog/_partials/product-promo-bar.tpl'
    qDni=$modules.quince_engine.product.options.promo_bar.days|default:365}

  <div class="q-quickview__prices-content">
    {include file='catalog/_partials/product-prices.tpl'}
  </div>
</div>

{* Dwa wiersze celowo: pierwszy mówi „co to jest", drugi „czy mogę to dostać".
   Z kodów zostaje samo SKU, tak jak na karcie produktu. *}
<div class="q-quickview__data">
  {if $product.manufacturer_name || $product.reference}
    <p class="q-quickview__row">
      {if $product.manufacturer_name}
        <span class="q-quickview__brand">{$product.manufacturer_name}</span>
      {/if}

      {if $product.manufacturer_name && $product.reference}
        <span class="q-quickview__dot" aria-hidden="true">&middot;</span>
      {/if}

      {if $product.reference}
        <span>{l s='SKU' d='Shop.Theme.Catalog'}: {$product.reference}</span>
      {/if}
    </p>
  {/if}

  {include file='catalog/_partials/product-availability.tpl' qZwarty=true}
</div>

{* Klasa `q-buy` daje licznikowi ilości i „Kup teraz" te same zachowania, co
   w panelu zakupu: obsługuje je ta sama wyspa. *}
<div class="q-quickview__actions q-buy">
  {if $qWersje > 0}
    {include file='catalog/_partials/product-buy-now.tpl'
      qUlubione=true qKupTeraz=false qPowiadom=false qWybierz=$product.url}

    <p class="q-quickview__select-info">
      {l s='This product comes in several versions, so price and availability depend on the one you choose.' d='Shop.Theme.Catalog'}
    </p>
  {else}
    <form action="{$urls.pages.cart}" method="post">
      <input type="hidden" name="token" value="{$static_token}">
      <input type="hidden" name="id_product" value="{$product.id_product|intval}">
      <input type="hidden" name="id_product_attribute" value="{$product.id_product_attribute|intval}">

      {if $product.add_to_cart_url}
        <div class="q-quickview__buy">
          <div class="q-qty">
            <button class="q-qty__btn" type="button" data-q-qty="-"
                    aria-label="{l s='Fewer' d='Shop.Theme.Actions'}">&minus;</button>

            <input class="q-qty__input" type="number" name="qty"
                   value="{$product.minimal_quantity|intval}" min="{$product.minimal_quantity|intval}"
                   aria-label="{l s='Quantity' d='Shop.Theme.Actions'}">

            <button class="q-qty__btn" type="button" data-q-qty="+"
                    aria-label="{l s='More' d='Shop.Theme.Actions'}">+</button>
          </div>

          <button class="q-btn q-btn--primary q-btn--lg" type="submit" data-button-action="add-to-cart">
            <svg class="q-btn__icon" width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 1a2.5 2.5 0 0 1 2.5 2.5V4h-5v-.5A2.5 2.5 0 0 1 8 1m3.5 3v-.5a3.5 3.5 0 1 0-7 0V4H1v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V4zM2 5h12v9a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1z"/></svg>
            <span class="q-btn__label">{l s='To cart' d='Shop.Theme.Actions'}</span>
          </button>
        </div>
      {/if}

      {include file='catalog/_partials/product-buy-now.tpl' qUlubione=true qKupTeraz=true qPowiadom=true}
    </form>
  {/if}
</div>

{* Stopkę szuflady buduje wyspa: przenosi ten blok pod treść, żeby został na
   widoku, gdy podgląd przewija się w środku. *}
<div class="q-quickview__footer" data-q-quickview-footer>
  <a class="q-btn q-btn--secondary q-btn--sm q-btn--block" href="{$product.url}">
    {l s='See the full product page' d='Shop.Theme.Actions'}
    <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
  </a>
</div>
