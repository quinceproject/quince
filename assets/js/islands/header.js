/**
 * Quince: nagłówek
 *
 * Dwie rzeczy, obie krótkie:
 *
 * 1. Zakres wyszukiwania. Otwieranie listy robi wyspa selecta (picker.js), tutaj
 *    zostaje sam wybór: zapisanie klucza w polu ukrytym i pokazanie nazwy na
 *    przycisku. Bez skryptu formularz nadal się wysyła, tylko z zakresem
 *    ustawionym na pierwszy z listy.
 *
 * 2. Licznik koszyka. Po dodaniu produktu przez AJAX PrestaShop rozgłasza
 *    `updateCart` razem z odpowiedzią serwera. Bez tego liczba w nagłówku
 *    zostawałaby stara aż do przeładowania strony, a to jest liczba, którą
 *    klient sprawdza właśnie po dodaniu.
 *
 * Projekt: widok nagłówka.
 */
(function () {
    'use strict';

    Quince.register('[data-q-scope]', function (scope) {
        var field = scope.querySelector('[data-q-scope-value]');
        var label = scope.querySelector('[data-q-scope-label]');
        var menu = scope.querySelector('[data-q-dropdown]');
        var button = scope.querySelector('[data-q-picker-button]');

        if (!field || !label || !menu || !button) {
            return;
        }

        /* Szerokość przycisku zablokowana na szerokości listy, czyli na jej
           najdłuższej pozycji. Bez tego wybór dłuższej nazwy zwęża pole
           wyszukiwania i kontrolka skacze pod kursorem, a lista wystaje poza
           przycisk, spod którego wychodzi.

           Mierzymy samą listę, nie przymierzamy nazw do przycisku: przycisk
           i pozycja listy mają inne odstępy wewnętrzne, więc ten sam napis daje
           w nich dwie różne szerokości i krawędzie i tak by się nie zeszły.

           Pomiar wymaga odsłonięcia listy, bo schowana nie ma wymiarów. Robimy to
           niewidocznie i w jednym takcie, więc przeglądarka nie zdąży jej
           narysować. */
        function zmierz() {
            // Otwartej listy nie mierzymy: zniknęłaby pod ręką osobie, która
            // właśnie z niej wybiera.
            if (!menu.hidden) {
                return;
            }

            menu.style.visibility = 'hidden';
            menu.hidden = false;

            var szerokosc = menu.offsetWidth;

            menu.hidden = true;
            menu.style.visibility = '';

            if (szerokosc > 0) {
                button.style.setProperty('--q-search-scope-w', szerokosc + 'px');
            }
        }

        zmierz();

        // Powtórka po dojechaniu krojów pisma. Pierwszy pomiar wypada, zanim
        // przeglądarka podmieni pismo zastępcze na nasze, a te mają inne
        // szerokości znaków. Bez powtórki przycisk zostaje na wymiarze
        // policzonym z cudzego pisma.
        if (document.fonts && document.fonts.ready) {
            document.fonts.ready.then(zmierz);
        }

        menu.addEventListener('click', function (event) {
            var option = event.target.closest('[data-q-scope-option]');

            if (!option) {
                return;
            }

            field.value = option.getAttribute('data-q-scope-option');
            label.textContent = option.textContent.trim();

            menu.querySelectorAll('[data-q-scope-option]').forEach(function (other) {
                other.setAttribute('aria-current', other === option ? 'true' : 'false');
            });

            // Zamknięcie i oddanie ogniska przyciskowi: wybór jest zrobiony,
            // a osoba na klawiaturze musi wiedzieć, gdzie wróciła.
            menu.hidden = true;

            if (button) {
                button.setAttribute('aria-expanded', 'false');
                button.focus();
            }
        });
    });

    Quince.register('[data-q-cart]', function (cart) {
        if (typeof prestashop === 'undefined' || !prestashop.on) {
            return;
        }

        var count = cart.querySelector('[data-q-cart-count]');
        var total = cart.querySelector('[data-q-cart-total]');

        prestashop.on('updateCart', function (event) {
            var data = event && event.resp && event.resp.cart;

            if (!data) {
                return;
            }

            if (count) {
                count.textContent = data.products_count > 0 ? data.products_count : '';
            }

            if (total && data.totals && data.totals.total) {
                total.textContent = data.totals.total.value;
            }
        });
    });
})();
