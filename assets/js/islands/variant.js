/**
 * Quince: bloki karty produktu po zmianie wariantu
 *
 * Po wyborze innego wariantu rdzeń pobiera świeże fragmenty strony i podmienia
 * tylko swoje: ceny, warianty, wiersz „Do koszyka", szczegóły i plakietki.
 * Bloki motywu, które też zależą od wariantu, zostałyby przy poprzednim:
 * dostępność mówiłaby „Dostępny" przy rozmiarze bez stanu, obok stałby „Kup teraz"
 * zamiast „Powiadom", a kod SKU i EAN należałby do innego wariantu.
 *
 * Te bloki mają w szablonie `data-q-variant`. Po odświeżeniu rdzenia pobieramy
 * stronę produktu z nowym wariantem i podmieniamy każdy oznaczony blok na jego
 * odpowiednik. Cała strona, a nie osobny fragment: blok wygląda wtedy dokładnie
 * tak, jak przy wejściu prosto na ten wariant, z ustawieniami panelu włącznie.
 *
 * Szybkie przeklikiwanie wariantów przerywa poprzednie pobranie, więc na stronę
 * trafia zawsze stan ostatnio wybranego.
 */
(function () {
    'use strict';

    var sklep = window.prestashop;

    if (!sklep || typeof sklep.on !== 'function' || typeof window.fetch !== 'function') {
        return;
    }

    var przerwij = null;

    // Szybki podgląd to inny produkt w oknie nad stroną. Jego bloki zostają
    // w spokoju, a zmiana wariantu w podglądzie nie dotyka strony pod spodem.
    // Warstwa z panelem zakupu na telefonie jest oknem, ale niesie panel TEJ
    // strony, więc jej bloki podmieniamy.
    function naStronie(element) {
        var okno = element.closest('dialog');

        return !okno || okno.hasAttribute('data-q-sheet');
    }

    sklep.on('updatedProduct', function (dane) {
        if (!dane || !dane.product_url || dane.is_quick_view) {
            return;
        }

        var bloki = Array.prototype.filter.call(document.querySelectorAll('[data-q-variant]'), naStronie);

        if (!bloki.length) {
            return;
        }

        var adres = new URL(dane.product_url, window.location.href);
        adres.hash = '';

        if (przerwij) {
            przerwij.abort();
        }

        przerwij = typeof AbortController === 'function' ? new AbortController() : null;

        fetch(adres.toString(), {
            credentials: 'same-origin',
            signal: przerwij ? przerwij.signal : undefined,
        })
            .then(function (odpowiedz) {
                return odpowiedz.ok ? odpowiedz.text() : '';
            })
            .then(function (html) {
                if (!html) {
                    return;
                }

                var nowa = new DOMParser().parseFromString(html, 'text/html');

                Array.prototype.filter.call(document.querySelectorAll('[data-q-variant]'), naStronie).forEach(function (stary) {
                    var klucz = stary.getAttribute('data-q-variant');
                    var swiezy = nowa.querySelector('[data-q-variant="' + klucz + '"]');

                    if (!swiezy) {
                        return;
                    }

                    var wstawiony = document.importNode(swiezy, true);
                    var rodzic = stary.parentNode;

                    stary.replaceWith(wstawiony);

                    if (window.Quince && typeof window.Quince.hydrate === 'function' && rodzic) {
                        window.Quince.hydrate(rodzic);
                    }
                });
            })
            .catch(function () {
                // Przerwane pobranie albo brak sieci: bloki zostają, jakie były,
                // a rdzeń i tak odświeżył cenę i przycisk zakupu.
            });
    });
})();
