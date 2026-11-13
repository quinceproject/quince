/**
 * Quince: podpowiedzi w wyszukiwarce
 *
 * Lista produktów pod polem, w trakcie pisania. Wyspa siedzi na FORMULARZU, bo
 * to on zna adres wyszukiwania, wybrany zakres i pole tekstowe, a formularzy
 * wyszukiwania na stronie jest kilka (nagłówek, wiersz telefonu) i każdy ma mieć
 * własny stan zamiast jednego wspólnego na całą stronę.
 *
 * Trzy rzeczy, na których zwykle wykłada się taka lista:
 *
 * 1. Kolejność odpowiedzi. Zapytania idą co kilka znaków i wracają, kiedy chcą:
 *    odpowiedź na „kompu" potrafi przyjść po odpowiedzi na „komputer" i nadpisać
 *    dobrą listę złą. Dlatego każde nowe zapytanie przerywa poprzednie.
 *
 * 2. Klawiatura. Lista, po której nie da się zejść strzałką, jest dla części
 *    klientów niewidoczna. Stąd role ARIA, aria-activedescendant i obsługa
 *    strzałek, Entera i Escape.
 *
 * 3. Wstawianie danych. Nazwy produktów idą z bazy i trafiają wprost na stronę,
 *    więc budujemy węzły i przypisujemy `textContent`. Sklejanie HTML-a ze
 *    stringów byłoby dziurą, przez którą nazwa produktu wykonuje skrypt.
 */
(function () {
    'use strict';

    /** Ile czekamy po ostatnim znaku, zanim pytamy serwer. */
    var ZWLOKA = 220;

    Quince.register('[data-q-suggest]', function (formularz) {
        var pole = formularz.querySelector('.q-search__input');
        var lista = formularz.querySelector('[data-q-suggest-list]');

        if (!pole || !lista) {
            return;
        }

        var adres = formularz.getAttribute('data-q-suggest-url');
        var prog = parseInt(formularz.getAttribute('data-q-suggest-min'), 10) || 3;
        var tekstPusty = formularz.getAttribute('data-q-suggest-empty') || '';
        var tekstWszystkie = formularz.getAttribute('data-q-suggest-all') || '';
        var zakres = formularz.querySelector('[data-q-scope-value]');

        var licznik = null;
        var przerywacz = null;
        var pozycje = [];
        var wybrana = -1;

        function zamknij() {
            lista.hidden = true;
            lista.textContent = '';
            pole.setAttribute('aria-expanded', 'false');
            pole.removeAttribute('aria-activedescendant');
            pozycje = [];
            wybrana = -1;
        }

        function zaznacz(nowa) {
            if (pozycje[wybrana]) {
                pozycje[wybrana].classList.remove('is-current');
                pozycje[wybrana].setAttribute('aria-selected', 'false');
            }

            wybrana = nowa;

            if (!pozycje[wybrana]) {
                pole.removeAttribute('aria-activedescendant');

                return;
            }

            pozycje[wybrana].classList.add('is-current');
            pozycje[wybrana].setAttribute('aria-selected', 'true');
            pole.setAttribute('aria-activedescendant', pozycje[wybrana].id);

            // Zaznaczenie strzałką musi być widoczne także wtedy, gdy lista jest
            // dłuższa niż jej okno. Inaczej klient przewija w ciemno.
            if (pozycje[wybrana].scrollIntoView) {
                pozycje[wybrana].scrollIntoView({ block: 'nearest' });
            }
        }

        /** Jeden wiersz: miniatura, nazwa, kategoria, cena. */
        function wiersz(produkt, numer) {
            var element = document.createElement('a');
            element.className = 'q-suggest__item';
            element.id = lista.id + '-' + numer;
            element.setAttribute('role', 'option');
            element.setAttribute('aria-selected', 'false');
            element.href = produkt.url;

            if (produkt.image) {
                var obraz = document.createElement('img');
                obraz.className = 'q-suggest__thumb';
                obraz.src = produkt.image;
                obraz.alt = '';
                obraz.loading = 'lazy';
                obraz.width = 48;
                obraz.height = 48;
                element.appendChild(obraz);
            }

            var tresc = document.createElement('span');
            tresc.className = 'q-suggest__body';

            var nazwa = document.createElement('span');
            nazwa.className = 'q-suggest__name';
            nazwa.textContent = produkt.name;
            tresc.appendChild(nazwa);

            if (produkt.category) {
                var kategoria = document.createElement('span');
                kategoria.className = 'q-suggest__cat';
                kategoria.textContent = produkt.category;
                tresc.appendChild(kategoria);
            }

            var cena = document.createElement('span');
            cena.className = 'q-suggest__price';

            var teraz = document.createElement('span');
            teraz.className = 'q-suggest__price-now';
            teraz.textContent = produkt.price;
            cena.appendChild(teraz);

            if (produkt.price_before) {
                var przed = document.createElement('span');
                przed.className = 'q-suggest__price-was';
                przed.textContent = produkt.price_before;
                cena.appendChild(przed);
                teraz.classList.add('is-reduced');
            }

            tresc.appendChild(cena);
            element.appendChild(tresc);

            return element;
        }

        function pokaz(produkty) {
            lista.textContent = '';
            pozycje = [];
            wybrana = -1;

            if (!produkty.length) {
                var pusto = document.createElement('div');
                pusto.className = 'q-suggest__empty';
                pusto.textContent = tekstPusty;
                lista.appendChild(pusto);
                lista.hidden = false;
                pole.setAttribute('aria-expanded', 'true');

                return;
            }

            produkty.forEach(function (produkt, numer) {
                var element = wiersz(produkt, numer);
                lista.appendChild(element);
                pozycje.push(element);
            });

            // Ostatnia pozycja prowadzi na stronę wyników: lista pokazuje kilka
            // trafień, a klient musi mieć dokąd pójść po resztę.
            if (tekstWszystkie) {
                var wszystkie = document.createElement('button');
                wszystkie.type = 'submit';
                wszystkie.className = 'q-suggest__all';
                wszystkie.id = lista.id + '-all';
                wszystkie.setAttribute('role', 'option');
                wszystkie.setAttribute('aria-selected', 'false');
                wszystkie.textContent = tekstWszystkie;
                lista.appendChild(wszystkie);
                pozycje.push(wszystkie);
            }

            lista.hidden = false;
            pole.setAttribute('aria-expanded', 'true');
        }

        function pytaj() {
            var fraza = pole.value.trim();

            if (fraza.length < prog || !adres) {
                zamknij();

                return;
            }

            if (przerywacz) {
                przerywacz.abort();
            }

            przerywacz = typeof AbortController === 'function' ? new AbortController() : null;

            var cel = new URL(adres, window.location.origin);
            cel.searchParams.set('q', fraza);

            if (zakres && zakres.value) {
                cel.searchParams.set('scope', zakres.value);
            }

            fetch(cel.toString(), {
                credentials: 'same-origin',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                signal: przerywacz ? przerywacz.signal : undefined
            })
                .then(function (odpowiedz) {
                    return odpowiedz.ok ? odpowiedz.json() : Promise.reject(odpowiedz.status);
                })
                .then(function (dane) {
                    // Fraza mogła się zmienić, zanim odpowiedź dojechała.
                    if (dane.query !== pole.value.trim()) {
                        return;
                    }

                    pokaz(dane.products || []);
                })
                .catch(function () {
                    // Przerwane zapytanie i awaria sieci kończą się tak samo:
                    // lista nie może zostać z wynikami dla innej frazy.
                    zamknij();
                });
        }

        pole.setAttribute('autocomplete', 'off');
        pole.setAttribute('role', 'combobox');
        pole.setAttribute('aria-expanded', 'false');
        pole.setAttribute('aria-autocomplete', 'list');
        pole.setAttribute('aria-controls', lista.id);

        pole.addEventListener('input', function () {
            window.clearTimeout(licznik);
            licznik = window.setTimeout(pytaj, ZWLOKA);
        });

        pole.addEventListener('keydown', function (zdarzenie) {
            if (zdarzenie.key === 'Escape') {
                zamknij();

                return;
            }

            if (lista.hidden || !pozycje.length) {
                return;
            }

            if (zdarzenie.key === 'ArrowDown') {
                zdarzenie.preventDefault();
                zaznacz(wybrana + 1 >= pozycje.length ? 0 : wybrana + 1);
            } else if (zdarzenie.key === 'ArrowUp') {
                zdarzenie.preventDefault();
                zaznacz(wybrana - 1 < 0 ? pozycje.length - 1 : wybrana - 1);
            } else if (zdarzenie.key === 'Enter' && pozycje[wybrana]) {
                // Enter bez zaznaczonej pozycji ma wysłać formularz. Tak działa
                // pole wyszukiwania wszędzie i nie ma powodu tego zmieniać.
                zdarzenie.preventDefault();
                pozycje[wybrana].click();
            }
        });

        // Zmiana zakresu przy wpisanej frazie zmienia wyniki, więc lista musi się
        // przeliczyć. Inaczej pokazuje odpowiedź na poprzednie pytanie.
        if (zakres) {
            formularz.addEventListener('click', function (zdarzenie) {
                if (zdarzenie.target.closest('[data-q-scope-option]')) {
                    window.setTimeout(pytaj, 0);
                }
            });
        }

        document.addEventListener('click', function (zdarzenie) {
            if (!formularz.contains(zdarzenie.target)) {
                zamknij();
            }
        });
    });
})();
