{**
 * Quince: karuzela zajawek produktu.
 *
 * Przewijana taśma, nie siatka: pod kartą produktu i na stronie głównej stoi
 * obok siebie kilka takich sekcji i siatka rozciągałaby każdą z nich na kilka
 * rzędów kart. Taśma pokazuje tyle zajawek, ile listing kategorii, a resztę
 * przewija w bok.
 *
 * Jeden komponent na wszystkie miejsca: akcesoria, ostatnio oglądane, produkty
 * z tej samej kategorii, polecane, nowości, bestsellery, promocje i „klienci
 * kupili również". Ten sam produkt ma mieć wszędzie ten sam wygląd.
 *
 * Karta jest tą samą zajawką, co na listingu (`miniatures/product.tpl`).
 *
 * Zmienne: $qProdukty (lista zajawek), $qTytul (napis nagłówka), $qIkona
 * (`accessories`, `clock` albo nic), $qIkonaSvg (gotowy znacznik ikony
 * z biblioteki silnika, ma pierwszeństwo przed $qIkona), $qId (człon
 * identyfikatora nagłówka),
 * $qWiecej i $qWiecejNapis (odnośnik do pełnej listy), $qKontener (opakowanie
 * w pojemnik strony, dla bloków stojących poza kartą produktu), $qPodtytul
 * (zdanie pod nagłówkiem, np. ile brakuje do darmowej dostawy) oraz włączniki
 * z panelu: $qIle (ile zajawek), $qStrzalki.
 *
 * Tytuł stoi zawsze. Kilka karuzel pod kartą bez tytułów to kilka takich samych
 * rzędów kart, których ani klient, ani sklep nie odróżni.
 * Zachowanie strzałek: assets/js/islands/carousel.js
 * Projekt: makieta strony produktu, sekcje karuzel.
 *}

{if $qProdukty|default:[]}
  {if $qKontener|default:false}<div class="q-container">{/if}

  <section class="q-carousel" data-q-carousel aria-labelledby="q-carousel-{$qId}">
    {* Nagłówek, odnośnik do pełnej listy i strzałki idą w jednym rzędzie.

       `qNaglowek` pozwala go zgasić: karuzela bywa jedną z kilku kolumn
       sekcji, a wtedy nagłówek niesie sekcja i drugi, pusty, zostawiałby nad
       taśmą pas pustego miejsca. *}
    {if $qNaglowek|default:true}
      <div class="q-carousel__head">
        <h2 class="q-carousel__title" id="q-carousel-{$qId}">
          {* Ikona wybrana w panelu przychodzi gotowym znacznikiem: biblioteka
             ikon siedzi w silniku, a motyw nie ma jak jej odpytać ze Smarty.
             Dwie poniższe zostają dla miejsc, które same wskazują ikonę nazwą. *}
          {if $qIkonaSvg|default:''}
            <svg class="q-section-title__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">{$qIkonaSvg nofilter}</svg>
          {elseif $qIkona|default:'' == 'accessories'}
            <svg class="q-section-title__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M6 1.5a2.5 2.5 0 0 0-2.4 3.2L1.5 6.8V9h2.2l2.1-2.1A2.5 2.5 0 0 0 9 4.5l-1.6 1.6-1.5-1.5L7.5 3A2.5 2.5 0 0 0 6 1.5m4.5 6.4L8.4 10l4.1 4.1a1.5 1.5 0 0 0 2.1-2.1z"/></svg>
          {elseif $qIkona|default:'' == 'clock'}
            <svg class="q-section-title__ico" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 1a7 7 0 1 0 6.9 8.2l-1.5-.3A5.5 5.5 0 1 1 8 2.5V5l3.5-2.5L8 0z"/></svg>
          {/if}
          {* Napis prowadzi tam, co odnośnik obok. Na telefonie odnośnik znika
             i wtedy nagłówek jest jedynym wyjściem do pełnej listy. *}
          {if $qWiecej|default:''}
            <a class="q-carousel__title-link" href="{$qWiecej}">{$qTytul}</a>
          {else}
            {$qTytul}
          {/if}
        </h2>

        <div class="q-carousel__actions">
          {* Odnośnik do pełnej listy: moduły sklepu mają go od zawsze, tylko
             stał pod taśmą jako przycisk i ważył tyle, co zakup. W nagłówku
             jest tym, czym jest: wyjściem dalej. *}
          {if $qWiecej|default:''}
            <a class="q-carousel__link" href="{$qWiecej}">
              {$qWiecejNapis|default:{l s='See all' d='Shop.Theme.Actions'}}
              <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
            </a>
          {/if}

          {* Strzałki tylko na szerokim ekranie: na telefonie taśmę przesuwa się
             palcem, a przyciski zabierały miejsce nagłówkowi. Chowa je arkusz. *}
          {if $qStrzalki|default:true}
            <div class="q-carousel__nav">
              <button class="q-carousel__arrow" type="button" data-q-carousel-prev
                      aria-label="{l s='Previous' d='Shop.Theme.Global'}">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M10 3.5 5.5 8l4.5 4.5"/></svg>
              </button>

              <button class="q-carousel__arrow" type="button" data-q-carousel-next
                      aria-label="{l s='Next' d='Shop.Theme.Global'}">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6 3.5 10.5 8 6 12.5"/></svg>
              </button>
            </div>
          {/if}
        </div>
      </div>
    {/if}

    {if $qPodtytul|default:''}
      <p class="q-carousel__note">{$qPodtytul}</p>
    {/if}

    <div class="q-carousel__track" data-q-carousel-track>
      {* Sklep ustawia, ile zajawek wchodzi na taśmę. Reszta wypada, zamiast
         jechać w nieskończoność: taśma bez końca zamienia się w drugi listing. *}
      {foreach from=$qProdukty item=qProdukt key=qPozycja name=qTasma}
        {if $smarty.foreach.qTasma.iteration > ($qIle|default:8)}{break}{/if}

        <div class="q-carousel__item">
          {include file='catalog/_partials/miniatures/product.tpl' product=$qProdukt position=$qPozycja}
        </div>
      {/foreach}
    </div>
  </section>

  {if $qKontener|default:false}</div>{/if}
{/if}
