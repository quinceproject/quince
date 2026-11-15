/**
 * Słowniki na karcie produktu: wyszukiwanie w tabeli i licznik pozycji.
 *
 * Znaczniki przynosi moduł `quince_dictionaries`, zachowanie jest tutaj. Pole
 * dostaje tylko tabela dłuższa niż 10 wierszy (decyduje moduł).
 *
 * Szukamy po wszystkich kolumnach, bez rozróżniania wielkości liter i polskich
 * znaków: „ciagnik" znajduje „ciągnik". Licznik każdego słownika pokazuje wtedy
 * „Pojazdy: 12 z 90", a bez wyników tabela znika i zostaje komunikat.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    function bezZnakow(tekst) {
        return tekst.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');
    }

    Quince.register('[data-q-dict]', function (korzen) {
        var pole = korzen.querySelector('[data-q-dict-search]');
        var tabela = korzen.querySelector('[data-q-dict-table]');
        var pusto = korzen.querySelector('[data-q-dict-empty]');

        if (!pole || !tabela) {
            return;
        }

        var wiersze = Array.prototype.slice.call(tabela.querySelectorAll('tbody tr'));
        var teksty = wiersze.map(function (wiersz) { return bezZnakow(wiersz.textContent); });
        var liczniki = Array.prototype.slice.call(korzen.querySelectorAll('[data-q-dict-count]'));
        var wzorLicznika = korzen.getAttribute('data-msg-of') || '%name%: %shown% / %total%';
        var wzorPusto = korzen.getAttribute('data-msg-empty') || '';

        pole.addEventListener('input', function () {
            var fraza = pole.value.trim();
            var szukane = bezZnakow(fraza);
            var widoczne = {};
            var razem = 0;

            wiersze.forEach(function (wiersz, i) {
                var pasuje = szukane === '' || teksty[i].indexOf(szukane) !== -1;
                var slownik = wiersz.getAttribute('data-dictionary') || '';

                wiersz.hidden = !pasuje;

                if (pasuje) {
                    widoczne[slownik] = (widoczne[slownik] || 0) + 1;
                    razem++;
                }
            });

            liczniki.forEach(function (licznik) {
                var nazwa = licznik.getAttribute('data-name') || '';
                var wszystkie = licznik.getAttribute('data-total') || '0';

                licznik.textContent = szukane === ''
                    ? nazwa + ': ' + wszystkie
                    : wzorLicznika
                        .replace('%name%', nazwa)
                        .replace('%shown%', String(widoczne[licznik.getAttribute('data-dictionary') || ''] || 0))
                        .replace('%total%', wszystkie);
            });

            tabela.hidden = razem === 0;

            if (pusto) {
                pusto.hidden = razem !== 0;
                pusto.textContent = razem === 0 ? wzorPusto.replace('%query%', fraza) : '';
            }
        });
    });
})();
