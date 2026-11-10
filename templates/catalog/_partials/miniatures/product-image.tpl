{**
 * Quince — zdjęcie w zajawce produktu
 *
 * Opieramy się na typach obrazu, które PrestaShop tworzy przy instalacji
 * (home_default, medium_default, large_default), a nie na własnych typach motywu.
 * Powód jest praktyczny: motyw ma działać zaraz po wgraniu, a dołożenie nowego
 * typu wymaga przegenerowania wszystkich miniatur w sklepie — przy kilku tysiącach
 * produktów to godziny pracy serwera i puste obrazki w międzyczasie.
 *
 * Każdy rozmiar sprawdzamy przed użyciem: sprzedawca może usunąć albo przemianować
 * typ obrazu w Design → Image Settings i szablon nie ma prawa się wtedy wysypać.
 *
 * Proporcję kontenera trzyma token --q-pcard-media-ratio, liczony przez silnik
 * z ps_image_type — karty w rzędzie mają równą wysokość niezależnie od zdjęć.
 *
 * width i height na <img> są obowiązkowe: bez nich przeglądarka nie rezerwuje
 * miejsca i strona skacze w trakcie wczytywania.
 *
 * `qSizes` mówi przeglądarce, jak szeroka BĘDZIE zajawka, żeby dobrała plik pod
 * ten rozmiar. Wartość domyślna opisuje zajawkę w siatce listingu: przy pięciu
 * w rzędzie ma ona około 300 px, a nie ćwierć szerokości okna. Miejsce, w którym
 * zajawka jest szersza albo węższa, podaje własną wartość.
 *}

{block name='product_miniature_image'}
  {if $product.cover}
    {assign var=cover value=$product.cover.bySize}

    <picture>
      {if isset($cover.medium_default.sources.avif)}
        <source
          srcset="{$cover.home_default.sources.avif} {$cover.home_default.width}w,
                  {$cover.medium_default.sources.avif} {$cover.medium_default.width}w"
          sizes="{$qSizes|default:'(min-width: 1200px) 300px, (min-width: 992px) 25vw, (min-width: 576px) 50vw, 100vw'}"
          type="image/avif">
      {/if}

      {if isset($cover.medium_default.sources.webp)}
        <source
          srcset="{$cover.home_default.sources.webp} {$cover.home_default.width}w,
                  {$cover.medium_default.sources.webp} {$cover.medium_default.width}w"
          sizes="{$qSizes|default:'(min-width: 1200px) 300px, (min-width: 992px) 25vw, (min-width: 576px) 50vw, 100vw'}"
          type="image/webp">
      {/if}

      <img
        class="q-pcard__image"
        {if isset($cover.medium_default.url)}
          srcset="{$cover.home_default.url} {$cover.home_default.width}w, {$cover.medium_default.url} {$cover.medium_default.width}w"
          sizes="{$qSizes|default:'(min-width: 1200px) 300px, (min-width: 992px) 25vw, (min-width: 576px) 50vw, 100vw'}"
        {/if}
        src="{$cover.home_default.url}"
        width="{$cover.home_default.width}"
        height="{$cover.home_default.height}"
        loading="lazy"
        alt="{$product.cover.legend|escape:'html':'UTF-8'}"
        data-full-size-image-url="{if isset($cover.large_default.url)}{$cover.large_default.url}{else}{$cover.home_default.url}{/if}">
    </picture>
  {else}
    {* Produkt bez zdjęcia — jeden z zadeklarowanych stanów brzegowych.
       Zastępnik zajmuje dokładnie tyle samo miejsca, więc rząd kart się nie rozjeżdża. *}
    <img
      class="q-pcard__image"
      src="{$urls.no_picture_image.bySize.home_default.url}"
      width="{$urls.no_picture_image.bySize.home_default.width}"
      height="{$urls.no_picture_image.bySize.home_default.height}"
      loading="lazy"
      alt="{l s='No image available' d='Shop.Theme.Catalog'}">
  {/if}
{/block}
