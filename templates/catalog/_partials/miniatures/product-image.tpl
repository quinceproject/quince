{**
 * Quince: zdjęcie w zajawce produktu
 *
 * Opieramy się na typach obrazu, które PrestaShop tworzy przy instalacji
 * (home_default, medium_default, large_default), a nie na własnych typach motywu.
 * Motyw ma działać zaraz po wgraniu, a dołożenie nowego typu wymaga
 * przegenerowania wszystkich miniatur w sklepie.
 *
 * Każdy rozmiar sprawdzamy przed użyciem: sprzedawca może usunąć albo przemianować
 * typ obrazu w Design → Image Settings i szablon nie ma prawa się wtedy wysypać.
 *
 * Proporcję kontenera trzyma token --q-pcard-media-ratio, liczony przez silnik
 * z ps_image_type, więc karty w rzędzie mają równą wysokość niezależnie od zdjęć.
 *
 * width i height na <img> są obowiązkowe: bez nich przeglądarka nie rezerwuje
 * miejsca i strona skacze w trakcie wczytywania.
 *
 * `qSizes` mówi przeglądarce, jak szeroka BĘDZIE zajawka, żeby dobrała plik pod
 * ten rozmiar. Wartość domyślna liczy zajawkę w siatce listingu z szerokości
 * strony i liczby kolumn ustawionych w silniku. Miejsce, w którym zajawka jest
 * szersza albo węższa, podaje własną wartość.
 *}

{block name='product_miniature_image'}
  {if $product.cover}
    {assign var=cover value=$product.cover.bySize}

    {* Trzy szerokości pliku do wyboru (home 450, medium 800, large 1600 przy
       zestawie z theme.yml). Przeglądarka bierze najmniejszy plik, który przy
       gęstości ekranu pokryje szerokość karty. Typ, którego sklep nie ma, po
       prostu wypada z listy. *}
    {assign var=qTypy value=['home_default', 'medium_default', 'large_default']}
    {capture name='qSrcAvif'}{foreach from=$qTypy item=qTyp}{if isset($cover.$qTyp.sources.avif)}{$cover.$qTyp.sources.avif} {$cover.$qTyp.width}w, {/if}{/foreach}{/capture}
    {capture name='qSrcWebp'}{foreach from=$qTypy item=qTyp}{if isset($cover.$qTyp.sources.webp)}{$cover.$qTyp.sources.webp} {$cover.$qTyp.width}w, {/if}{/foreach}{/capture}
    {capture name='qSrcBase'}{foreach from=$qTypy item=qTyp}{if isset($cover.$qTyp.url)}{$cover.$qTyp.url} {$cover.$qTyp.width}w, {/if}{/foreach}{/capture}

    {* Szerokość karty w siatce: od 768 px strona dzielona na tyle kolumn, ile
       ustawiono w panelu (szerokość strony też z panelu, od 960 do 1920 px),
       od 576 px trzy karty, niżej dwie. Zmierzone na listingu. *}
    {assign var=qKol value=$modules.quince_engine.listing.columns|default:4}
    {assign var=qStrona value=$modules.quince_engine.listing.container|default:1200}
    {capture name='qSizesSiatka'}(min-width: 768px) calc(min(100vw, {$qStrona|intval}px) / {$qKol|intval}), (min-width: 576px) 33vw, 50vw{/capture}
    {assign var=qRozmiary value=$qSizes|default:$smarty.capture.qSizesSiatka}

    <picture>
      {if $smarty.capture.qSrcAvif}
        <source srcset="{$smarty.capture.qSrcAvif|trim:', '}" sizes="{$qRozmiary}" type="image/avif">
      {/if}

      {if $smarty.capture.qSrcWebp}
        <source srcset="{$smarty.capture.qSrcWebp|trim:', '}" sizes="{$qRozmiary}" type="image/webp">
      {/if}

      <img
        class="q-pcard__image"
        {if $smarty.capture.qSrcBase}
          srcset="{$smarty.capture.qSrcBase|trim:', '}"
          sizes="{$qRozmiary}"
        {/if}
        src="{$cover.home_default.url}"
        width="{$cover.home_default.width}"
        height="{$cover.home_default.height}"
        loading="lazy"
        alt="{$product.cover.legend|escape:'html':'UTF-8'}"
        data-full-size-image-url="{if isset($cover.large_default.url)}{$cover.large_default.url}{else}{$cover.home_default.url}{/if}">
    </picture>
  {else}
    {* Produkt bez zdjęcia. Zastępnik zajmuje dokładnie tyle samo miejsca, więc rząd kart się nie rozjeżdża. *}
    <img
      class="q-pcard__image"
      src="{$urls.no_picture_image.bySize.home_default.url}"
      width="{$urls.no_picture_image.bySize.home_default.width}"
      height="{$urls.no_picture_image.bySize.home_default.height}"
      loading="lazy"
      alt="{l s='No image available' d='Shop.Theme.Catalog'}">
  {/if}
{/block}
