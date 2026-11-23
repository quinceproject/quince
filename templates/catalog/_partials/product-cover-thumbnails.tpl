{**
 * Galeria produktu: kadr, licznik, pas miniatur, kropki i podgląd na wierzchu.
 *
 * Zdjęcie jest jedno, a miniatura podmienia jego źródło. Nie ma karuzeli
 * przesuwającej kadry obok siebie, więc szerokość kadru nie zależy od liczby
 * zdjęć. Bez JavaScriptu widać pierwsze zdjęcie i komplet miniatur.
 *
 * Rozmiary bierzemy skrótami rdzenia (`small`, `medium`, `large`), nie nazwami
 * presetów, więc motyw nie zależy wtedy od tego, jakie typy obrazów ma sklep.
 *
 * Projekt: makieta strony produktu.
 *}
{* Filmy przychodzą z silnika już rozebrane na dostawcę, identyfikator i plakat.
   Szablon nie zna adresów YouTube'a ani Vimeo: to sprawa silnika. *}
{assign var=qFilmy value=$qFilmy|default:[]}
{if !($qWideo|default:true)}{assign var=qFilmy value=[]}{/if}

{if $product.images|@count > 0}
  {assign var=qOkladka value=$product.default_image|default:$product.images[0]}

  <div class="q-gallery" data-q-gallery>
    <div class="q-gallery__frame" data-q-frame>
      {* Formaty, które sklep generuje (Wygląd → Ustawienia obrazów), idą jako
         źródła `<picture>`; JPEG zostaje dla przeglądarki, która ich nie zna.
         Przy zmianie zdjęcia skrypt galerii podmienia źródła razem z `src`. *}
      <picture class="q-gallery__picture">
        {if isset($qOkladka.large.sources.avif)}
          <source type="image/avif" srcset="{$qOkladka.large.sources.avif}">
        {/if}
        {if isset($qOkladka.large.sources.webp)}
          <source type="image/webp" srcset="{$qOkladka.large.sources.webp}">
        {/if}
        <img class="q-gallery__img"
             data-q-photo
             src="{$qOkladka.large.url}"
             width="{$qOkladka.large.width}"
             height="{$qOkladka.large.height}"
             alt="{$qOkladka.legend}"
             fetchpriority="high"
             decoding="async">
      </picture>

      {* Licznik jest ukryty przed czytnikiem ekranu: tę samą informację niosą
         etykiety miniatur i ich stan `aria-current`. *}
      {* Licznik obejmuje wszystkie media: zdjęcia i filmy stoją w jednym pasie
         i klient przechodzi między nimi tak samo. *}
      <span class="q-gallery__counter" data-q-counter aria-hidden="true">1 / {$product.images|@count + $qFilmy|@count}</span>

      {if $qFilmy}
        {* Zapowiedź filmu, nie odtwarzacz: plakat i przycisk. Ramka dostawcy
           wchodzi dopiero po kliknięciu, bo osadzony odtwarzacz ciągnie kilkaset
           kilobajtów przy każdym wejściu na kartę, a filmu nie włączy większość
           kupujących. *}
        <div class="q-gallery__video" data-q-video hidden>
          <img class="q-gallery__poster" data-q-poster src="" alt="" loading="lazy" decoding="async">

          <button class="q-gallery__play" type="button" data-q-play>
            <svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
              <path d="M10.804 8 5 4.633v6.734zm.792-.696a.802.802 0 0 1 0 1.392l-6.363 3.692C4.713 12.69 4 12.345 4 11.692V4.308c0-.653.713-.998 1.233-.696z"/>
            </svg>
            {l s='Watch the film' d='Shop.Theme.Catalog'}
          </button>

          <div class="q-gallery__embed" data-q-slot></div>
        </div>

        {* Ramki stoją w szablonach, a nie powstają w skrypcie: moduł zgód
           przepisuje adresy ramek w wysyłanym kodzie strony, więc ramka zbudowana
           dopiero w przeglądarce ominęłaby zgodę odwiedzającego. Tak przychodzi
           tu gotowa, zablokowana albo nie, a skrypt tylko ją wstawia. *}
        {foreach from=$qFilmy item=qFilm name=filmy}
          <template data-q-video-frame="{$smarty.foreach.filmy.index}">
            <iframe
              src="{if $qFilm.dostawca == 'youtube'}https://www.youtube-nocookie.com/embed/{$qFilm.id}?autoplay=1&rel=0{else}https://player.vimeo.com/video/{$qFilm.id}?autoplay=1{/if}"
              title="{l s='Product film' d='Shop.Theme.Catalog'}"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              referrerpolicy="strict-origin-when-cross-origin"
              allowfullscreen loading="lazy"></iframe>
          </template>
        {/foreach}
      {/if}

      <button class="q-gallery__zoom" type="button" data-q-zoom
              aria-label="{l s='Zoom' d='Shop.Theme.Actions'}"
              title="{l s='Zoom' d='Shop.Theme.Actions'}">
        <svg width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
          <path fill-rule="evenodd" d="M6.5 12a5.5 5.5 0 1 0 0-11 5.5 5.5 0 0 0 0 11M13 6.5a6.5 6.5 0 1 1-13 0 6.5 6.5 0 0 1 13 0"/>
          <path d="M10.344 11.742q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1 6.5 6.5 0 0 1-1.398 1.4z"/>
          <path fill-rule="evenodd" d="M6.5 3a.5.5 0 0 1 .5.5V6h2.5a.5.5 0 0 1 0 1H7v2.5a.5.5 0 0 1-1 0V7H3.5a.5.5 0 0 1 0-1H6V3.5a.5.5 0 0 1 .5-.5"/>
        </svg>
      </button>
    </div>

    {if $product.images|@count > 1 || $qFilmy}
      <div class="q-gallery__thumbs">
        {if $qFilmPierwszy|default:false}{include file='catalog/_partials/gallery-video-thumbs.tpl' qFilmy=$qFilmy}{/if}

        {foreach from=$product.images item=zdjecie name=miniatury}
          <button class="q-gallery__thumb{if $zdjecie.id_image == $qOkladka.id_image} is-active{/if}"
                  type="button"
                  data-q-thumbnail
                  data-q-large="{$zdjecie.large.url}"
                  {if isset($zdjecie.large.sources.webp)}data-q-large-webp="{$zdjecie.large.sources.webp}"{/if}
                  {if isset($zdjecie.large.sources.avif)}data-q-large-avif="{$zdjecie.large.sources.avif}"{/if}
                  data-q-width="{$zdjecie.large.width}"
                  data-q-height="{$zdjecie.large.height}"
                  data-q-caption="{$zdjecie.legend}"
                  {if $zdjecie.id_image == $qOkladka.id_image}aria-current="true"{/if}
                  aria-label="{l s='Picture %number%' sprintf=['%number%' => $smarty.foreach.miniatury.iteration] d='Shop.Theme.Catalog'}">
            <picture class="q-gallery__picture">
              {if isset($zdjecie.small.sources.avif)}
                <source type="image/avif" srcset="{$zdjecie.small.sources.avif}">
              {/if}
              {if isset($zdjecie.small.sources.webp)}
                <source type="image/webp" srcset="{$zdjecie.small.sources.webp}">
              {/if}
              <img src="{$zdjecie.small.url}"
                   width="{$zdjecie.small.width}"
                   height="{$zdjecie.small.height}"
                   loading="lazy" decoding="async" alt="">
            </picture>
          </button>
        {/foreach}

        {if !($qFilmPierwszy|default:false)}{include file='catalog/_partials/gallery-video-thumbs.tpl' qFilmy=$qFilmy}{/if}
      </div>

      {* Nie `tablist`: nie ma tu paneli ani `role="tab"`, więc wzorzec zakładek
         nie domknąłby się. Zwykła grupa przycisków ze stanem przez `aria-current`. *}
      <div class="q-gallery__dots" role="group"
           aria-label="{l s='Product images' d='Shop.Theme.Catalog'}">
        {foreach from=$product.images item=zdjecie name=kropki}
          <button class="q-gallery__dot{if $zdjecie.id_image == $qOkladka.id_image} is-active{/if}"
                  type="button" data-q-dot
                  {if $zdjecie.id_image == $qOkladka.id_image}aria-current="true"{/if}
                  aria-label="{l s='Picture %number%' sprintf=['%number%' => $smarty.foreach.kropki.iteration] d='Shop.Theme.Catalog'}"></button>
        {/foreach}
      </div>
    {/if}
  </div>

  {* Podgląd zdjęcia na wierzchu. Ten sam `<dialog>` co szuflady, więc pułapka
     ogniska, Escape i tło są przeglądarki, nie nasze. *}
  <dialog class="q-modal q-modal--lightbox" data-q-lightbox
          aria-label="{l s='Product images' d='Shop.Theme.Catalog'}">
    <button class="q-lightbox__close" type="button" data-q-lightbox-close
            aria-label="{l s='Close' d='Shop.Theme.Global'}">
      <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
        <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
      </svg>
    </button>

    {* Scena: strzałka, kadr, strzałka. Kadr bierze całą wolną wysokość, a pasek
       miniatur pod spodem ma swoją. *}
    <figure class="q-lightbox__stage">
      <button class="q-lightbox__nav" type="button" data-q-lightbox-prev
              aria-label="{l s='Previous' d='Shop.Theme.Actions'}">
        <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
          <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
        </svg>
      </button>

      <div class="q-lightbox__frame">
        <picture class="q-gallery__picture">
          <img class="q-lightbox__img" data-q-lightbox-img src="" alt="" decoding="async">
        </picture>

        {if $qFilmy}
          {* Film w podglądzie na tej samej zasadzie co w kadrze: plakat
             i przycisk, ramka dopiero po kliknięciu. Bez tego miniatura filmu
             w pasku podglądu prowadziła do pustego obrazka. *}
          <div class="q-lightbox__video" data-q-lightbox-video hidden>
            <img class="q-lightbox__poster" data-q-lightbox-poster src="" alt="" decoding="async">

            <button class="q-gallery__play" type="button" data-q-lightbox-play>
              <svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
                <path d="M10.804 8 5 4.633v6.734zm.792-.696a.802.802 0 0 1 0 1.392l-6.363 3.692C4.713 12.69 4 12.345 4 11.692V4.308c0-.653.713-.998 1.233-.696z"/>
              </svg>
              {l s='Watch the film' d='Shop.Theme.Catalog'}
            </button>

            <div class="q-lightbox__embed" data-q-lightbox-slot></div>
          </div>
        {/if}
      </div>

      <button class="q-lightbox__nav" type="button" data-q-lightbox-next
              aria-label="{l s='Next' d='Shop.Theme.Actions'}">
        <svg width="22" height="22" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
          <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708"/>
        </svg>
      </button>
    </figure>

    <figcaption class="q-lightbox__caption" data-q-lightbox-caption hidden></figcaption>

    {* Pasek miniatur buduje skrypt z miniatur galerii (jedno źródło prawdy):
       dziesiąte zdjęcie pojawi się w obu miejscach bez dopisywania czegokolwiek. *}
    <div class="q-lightbox__thumbs" data-q-lightbox-thumbs></div>
  </dialog>

{else}
  {assign var=qBrak value=$urls.no_picture_image}

  <div class="q-gallery">
    <div class="q-gallery__frame">
      <img class="q-gallery__img"
           src="{$qBrak.large.url}"
           width="{$qBrak.large.width}"
           height="{$qBrak.large.height}"
           alt="{$product.name}">
    </div>
  </div>
{/if}
