{**
 * Miniatury filmów w pasie galerii.
 *
 * Osobny plik, bo pas rysuje się w dwóch miejscach: przed zdjęciami albo po
 * nich, zależnie od ustawienia „film pierwszy" w panelu. Powtórzenie tego
 * samego bloku dwa razy w jednym szablonie kończyłoby się poprawką w jednym
 * miejscu i zapomnianą w drugim.
 *
 * Plakat Vimeo dociąga skrypt galerii: adres da się poznać dopiero po pytaniu
 * do ich usługi, a nie chcemy takiego pytania przy każdym wejściu na kartę.
 *}
{foreach from=$qFilmy|default:[] item=qFilm name=filmyMini}
  <button class="q-gallery__thumb q-gallery__thumb--video"
          type="button"
          data-q-thumbnail
          data-q-type="video"
          data-q-film="{$smarty.foreach.filmyMini.index}"
          data-q-poster="{$qFilm.plakat}"
          data-q-provider="{$qFilm.dostawca}"
          data-q-url="{$qFilm.adres}"
          aria-label="{l s='Film %number%' sprintf=['%number%' => $smarty.foreach.filmyMini.iteration] d='Shop.Theme.Catalog'}">
    {if $qFilm.plakat}
      <img src="{$qFilm.plakat}" loading="lazy" decoding="async" alt="">
    {/if}

    <span class="q-gallery__thumb-play" aria-hidden="true">
      <svg viewBox="0 0 16 16" fill="currentColor">
        <path d="M10.804 8 5 4.633v6.734zm.792-.696a.802.802 0 0 1 0 1.392l-6.363 3.692C4.713 12.69 4 12.345 4 11.692V4.308c0-.653.713-.998 1.233-.696z"/>
      </svg>
    </span>
  </button>
{/foreach}
