/**
 * Słowniki na karcie produktu: wyszukiwanie w tabeli, licznik pozycji i strony.
 *
 * Znaczniki przynosi moduł `quince_dictionaries`, zachowanie jest tutaj. Pole
 * dostaje tylko tabela dłuższa niż 10 wierszy (decyduje moduł).
 *
 * Krótka tabela przychodzi w całości i szukamy w przeglądarce. Długa (moduł daje
 * jej `data-q-dict-url`) przychodzi tylko pierwszą stroną: kolejne strony i wyniki
 * wyszukiwania w całej tabeli dociągamy z serwera, a pod tabelą rysujemy
 * stronicowanie motywu (`q-pagination`, to samo co pod listą produktów).
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
        return tekst.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/ł/g, 'l');
    }

    /**
     * Numery stron do pokazania: wszystkie przy kilku, inaczej pierwsza, ostatnia
     * i sąsiedzi bieżącej, z wielokropkiem (`null`) w miejscu przeskoku.
     */
    function numeryStron(biezaca, wszystkie) {
        if (wszystkie <= 7) {
            return Array.apply(null, { length: wszystkie }).map(function (_, i) { return i + 1; });
        }

        var wynik = [1];
        var od = Math.max(2, biezaca - 1);
        var doStrony = Math.min(wszystkie - 1, biezaca + 1);

        if (od > 2) {
            wynik.push(null);
        }

        for (var i = od; i <= doStrony; i++) {
            wynik.push(i);
        }

        if (doStrony < wszystkie - 1) {
            wynik.push(null);
        }

        wynik.push(wszystkie);

        return wynik;
    }

    Quince.register('[data-q-dict]', function (korzen) {
        var pole = korzen.querySelector('[data-q-dict-search]');
        var tabela = korzen.querySelector('[data-q-dict-table]');
        var pusto = korzen.querySelector('[data-q-dict-empty]');

        if (!pole || !tabela) {
            return;
        }

        var cialo = tabela.querySelector('tbody');
        var liczniki = Array.prototype.slice.call(korzen.querySelectorAll('[data-q-dict-count]'));
        var wzorLicznika = korzen.getAttribute('data-msg-of') || '%name%: %shown% / %total%';
        var wzorPusto = korzen.getAttribute('data-msg-empty') || '';
        var wyczysc = korzen.querySelector('[data-q-dict-clear]');
        var adres = korzen.getAttribute('data-q-dict-url') || '';
        var nawigacja = korzen.querySelector('[data-q-dict-pages]');

        function pokazLiczniki(szukane, widoczne) {
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
        }

        function pokazPusto(razem, fraza) {
            tabela.hidden = razem === 0;

            if (pusto) {
                pusto.hidden = razem !== 0;
                pusto.textContent = razem === 0 ? wzorPusto.replace('%query%', fraza) : '';
            }
        }

        if (wyczysc) {
            wyczysc.addEventListener('click', function () {
                pole.value = '';
                pole.dispatchEvent(new Event('input'));
                pole.focus();
            });
        }

        // --- Krótka tabela: wszystko jest już na stronie. ---

        if (adres === '') {
            var wiersze = Array.prototype.slice.call(cialo.querySelectorAll('tr'));
            var teksty = wiersze.map(function (wiersz) { return bezZnakow(wiersz.textContent); });

            pole.addEventListener('input', function () {
                if (wyczysc) {
                    wyczysc.hidden = pole.value === '';
                }

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

                pokazLiczniki(szukane, widoczne);
                pokazPusto(razem, fraza);
            });

            return;
        }

        // --- Długa tabela: strony i wyszukiwanie z serwera. ---

        var biezaca = 1;
        var stron = parseInt(korzen.getAttribute('data-pages') || '1', 10);
        var fraza = '';
        var zapytanie = 0;
        var zwloka = null;

        function rysujStrony() {
            if (!nawigacja) {
                return;
            }

            nawigacja.textContent = '';
            nawigacja.hidden = stron <= 1;
            nawigacja.setAttribute('aria-label', korzen.getAttribute('data-msg-pages') || '');

            if (stron <= 1) {
                return;
            }

            numeryStron(biezaca, stron).forEach(function (numer) {
                if (numer === null) {
                    var przerwa = document.createElement('span');
                    przerwa.className = 'q-pagination__gap';
                    przerwa.setAttribute('aria-hidden', 'true');
                    przerwa.textContent = '…';
                    nawigacja.appendChild(przerwa);

                    return;
                }

                var przycisk = document.createElement('button');
                przycisk.type = 'button';
                przycisk.className = 'q-pagination__page' + (numer === biezaca ? ' is-active' : '');
                przycisk.textContent = String(numer);
                przycisk.setAttribute('data-page', String(numer));
                przycisk.setAttribute('aria-label', (korzen.getAttribute('data-msg-page') || '%page%').replace('%page%', String(numer)));

                if (numer === biezaca) {
                    przycisk.setAttribute('aria-current', 'page');
                }

                nawigacja.appendChild(przycisk);
            });

            if (biezaca < stron) {
                var dalej = document.createElement('button');
                dalej.type = 'button';
                dalej.className = 'q-pagination__next';
                dalej.setAttribute('data-page', String(biezaca + 1));
                dalej.setAttribute('aria-label', korzen.getAttribute('data-msg-next-label') || '');
                dalej.appendChild(document.createTextNode(korzen.getAttribute('data-msg-next') || '›'));
                dalej.insertAdjacentHTML('beforeend', ' <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>');
                nawigacja.appendChild(dalej);
            }
        }

        function rysujWiersze(wiersze) {
            var nowe = document.createDocumentFragment();

            wiersze.forEach(function (wiersz) {
                var tr = document.createElement('tr');
                tr.setAttribute('data-dictionary', wiersz.dictionary || '');

                (wiersz.values || []).forEach(function (wartosc) {
                    var td = document.createElement('td');
                    td.textContent = wartosc;
                    tr.appendChild(td);
                });

                nowe.appendChild(tr);
            });

            cialo.textContent = '';
            cialo.appendChild(nowe);
        }

        function wczytaj(strona, przewin) {
            var numer = ++zapytanie;
            var url = new URL(adres, window.location.href);

            url.searchParams.set('page', String(strona));
            url.searchParams.set('q', fraza);
            korzen.setAttribute('aria-busy', 'true');

            fetch(url.toString(), { credentials: 'same-origin', headers: { Accept: 'application/json' } })
                .then(function (odpowiedz) { return odpowiedz.json(); })
                .then(function (dane) {
                    // Odpowiedź na starsze zapytanie przyszła po nowszym: pomijamy.
                    if (numer !== zapytanie || !dane || !dane.ok) {
                        return;
                    }

                    biezaca = dane.page;
                    stron = dane.pages;
                    rysujWiersze(dane.rows || []);
                    rysujStrony();
                    pokazLiczniki(bezZnakow(fraza), dane.counts || {});
                    pokazPusto(dane.total, fraza);

                    if (przewin) {
                        korzen.scrollIntoView({ block: 'start', behavior: 'smooth' });
                    }
                })
                .catch(function () {})
                .then(function () {
                    if (numer === zapytanie) {
                        korzen.removeAttribute('aria-busy');
                    }
                });
        }

        if (nawigacja) {
            nawigacja.addEventListener('click', function (zdarzenie) {
                var cel = zdarzenie.target.closest('[data-page]');

                if (cel) {
                    wczytaj(parseInt(cel.getAttribute('data-page'), 10), true);
                }
            });
        }

        pole.addEventListener('input', function () {
            if (wyczysc) {
                wyczysc.hidden = pole.value === '';
            }

            fraza = pole.value.trim();
            clearTimeout(zwloka);
            // Pytamy serwer dopiero po krótkiej przerwie w pisaniu, nie po każdej literze.
            zwloka = setTimeout(function () { wczytaj(1, false); }, 250);
        });

        rysujStrony();
    });
})();
