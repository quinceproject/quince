{**
 * Jedna sekcja akordeonu na karcie produktu.
 *
 * Na `<details>`, nie na własnym mechanizmie: przeglądarka daje obsługę
 * klawiatury, ogłaszanie stanu w czytniku ekranu i otwieranie sekcji przy
 * szukaniu tekstu (Ctrl+F). Bez JavaScriptu sekcje dalej się rozwijają.
 *
 * Zmienne: $qId — człon identyfikatora, $qTytul — nagłówek, $qOtwarta — czy
 * rozwinięta na wejściu, $qLiczba — liczba przy nagłówku (opcjonalna). Treść
 * przychodzi z sekcji dopasowanej do $qId.
 *}
<details class="q-accordion__item" id="q-section-{$qId}"{if isset($qOtwarta) && $qOtwarta} open{/if}>
  <summary class="q-accordion__header">
    <h2 class="q-accordion__title">{$qTytul}</h2>

    {* Liczba przy nazwie sekcji: ile opinii, ile załączników. Stoi przed
       znakiem rozwinięcia, żeby nie odsuwała go od krawędzi. *}
    {if isset($qLiczba) && $qLiczba > 0}
      <span class="q-accordion__count">{$qLiczba|intval}</span>
    {/if}

    <svg class="q-accordion__icon" width="16" height="16" viewBox="0 0 16 16"
         fill="currentColor" aria-hidden="true"><path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"/></svg>
  </summary>

  <div class="q-accordion__body">
    {* Treść podana wprost: sekcja, której zawartość przynosi moduł przez hooka.
       Wypisujemy ją gotową, bo wywołanie hooka drugi raz po to, żeby sprawdzić,
       czy coś w ogóle wypisał, kosztowałoby drugie zapytanie do bazy. *}
    {if isset($qTresc)}
      {$qTresc nofilter}

    {elseif $qId == 'opis'}
      {* `q-prose` niesie skład treści wpisanej edytorem, `rich-text` zostaje,
         bo tak nazywa treść redakcyjną rdzeń i szablony modułów. *}
      <div class="q-prose rich-text">{$product.description nofilter}</div>

    {elseif $qId == 'opinie'}
      {include file='catalog/_partials/product-reviews.tpl'}

    {elseif $qId == 'pytania'}
      {include file='catalog/_partials/product-qa.tpl'}

    {elseif $qId == 'zalaczniki'}
      {* Cały wiersz jest odnośnikiem: klikalny jest znaczek, nazwa, rozmiar
         i strzałka. Wcześniej klikalny był sam napis na końcu wiersza. *}
      <div class="q-attach">
        {foreach from=$product.attachments item=zalacznik}
          {* Rozszerzenie z nazwy pliku, wielkimi literami. Plik bez kropki
             w nazwie zostaje bez znaczka, bo trzy przypadkowe litery mówiłyby
             mniej niż nic. *}
          {assign var=qTyp value=$zalacznik.file_name|regex_replace:'/^.*\.([A-Za-z0-9]{1,4})$/':'$1'|upper}

          <a class="q-attach__item"
             href="{url entity='attachment' params=['id_attachment' => $zalacznik.id_attachment]}"
             download
             aria-label="{l s='Download %attachment_name%' sprintf=['%attachment_name%' => $zalacznik.name] d='Shop.Theme.Actions'}">
            {if $qTyp != $zalacznik.file_name|upper}
              <span class="q-attach__ico" aria-hidden="true">{$qTyp}</span>
            {/if}

            <span class="q-attach__text">
              <span class="q-attach__name">{$zalacznik.name}</span>

              {if $zalacznik.description}
                <span class="q-attach__desc">{$zalacznik.description}</span>
              {/if}
            </span>

            <span class="q-attach__size">{$zalacznik.file_size_formatted}</span>

            <svg class="q-attach__dl" width="16" height="16" viewBox="0 0 16 16"
                 fill="currentColor" aria-hidden="true"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708z"/></svg>
          </a>
        {/foreach}
      </div>
    {/if}
  </div>
</details>
