/* ===================================================================
   Quince: warstwa JavaScript

   Architektura wysp: strona przychodzi z serwera jako gotowy HTML i działa
   bez ani jednej linijki skryptu. JavaScript dokłada się tylko tam, gdzie
   potrzebna jest interakcja, której nie da się zrobić inaczej.

   Wyłączony JS nie psuje sklepu. Roboty (także te od modeli językowych,
   które nie czekają na hydrację) widzą pełną treść.

   Zero zależności. Bez jQuery, bez Bootstrapa. PrestaShop ładuje jQuery
   globalnie dla własnych modułów i my z tego nie korzystamy.
   =================================================================== */

/* -------------------------------------------------------------------
   Szyna zdarzeń PrestaShopa

   Rdzeń i moduły rozmawiają ze sklepem przez `prestashop.on()`
   i `prestashop.emit()`: odświeżenie koszyka, podmiana wariantu, lista
   życzeń. Sam obiekt `prestashop` wypisuje PrestaShop w nagłówku, ale jako
   zwykły zbiór danych: bez `on` i bez `emit`. Te dwie metody dokłada motyw
   i żaden motyw ich za nas nie doda.

   Bez tego bloku każde wywołanie kończy się „prestashop.on is not a function"
   i przestaje działać wszystko, co nasłuchuje: odświeżanie ceny po zmianie
   wariantu, licznik koszyka, serduszko listy życzeń.

   Osobny, synchroniczny blok NA POCZĄTKU pliku, a nie metoda wewnątrz wysp:
   rdzeń woła `emit` już w uchwycie DOM-ready, więc szyna musi istnieć wcześniej
   niż cokolwiek, co jej używa.

   Obiekt uzupełniamy, a nie tworzymy od nowa: dane sklepu wypisane
   w nagłówku muszą zostać na miejscu.
   ------------------------------------------------------------------- */

(function () {
    'use strict';

    var ps = window.prestashop = window.prestashop || {};

    // Motyw dołożony obok innego, który już to zrobił, nie kasuje jego słuchaczy.
    if (typeof ps.on === 'function' && typeof ps.emit === 'function') {
        return;
    }

    var sluchacze = {};

    ps.on = function (nazwa, uchwyt) {
        if (typeof uchwyt === 'function') {
            (sluchacze[nazwa] = sluchacze[nazwa] || []).push(uchwyt);
        }

        return ps;
    };

    ps.once = function (nazwa, uchwyt) {
        var raz = function (dane) {
            ps.off(nazwa, raz);
            uchwyt(dane);
        };

        return ps.on(nazwa, raz);
    };

    ps.off = function (nazwa, uchwyt) {
        if (!sluchacze[nazwa]) {
            return ps;
        }

        if (uchwyt === undefined) {
            delete sluchacze[nazwa];

            return ps;
        }

        sluchacze[nazwa] = sluchacze[nazwa].filter(function (fn) {
            return fn !== uchwyt;
        });

        return ps;
    };

    ps.emit = function (nazwa, dane) {
        // Kopia listy: uchwyt, który w trakcie wywołania wypina sam siebie,
        // przesunąłby indeksy i kolejny słuchacz zostałby pominięty.
        (sluchacze[nazwa] || []).slice().forEach(function (uchwyt) {
            try {
                uchwyt(dane);
            } catch (e) {
                // Awaria jednego słuchacza nie może zatrzymać pozostałych,
                // inaczej błąd w module gasi odświeżanie koszyka w motywie.
                if (window.console) {
                    console.error('[Quince] słuchacz zdarzenia ' + nazwa + ':', e);
                }
            }
        });

        return ps;
    };
})();

(function () {
    'use strict';

    /**
     * Rejestr wysp. Każda to para: selektor i funkcja uruchamiana dla każdego
     * pasującego elementu. Wyspa dostaje swój element i nic więcej. Nie zna
     * reszty strony, więc jej awaria nie unieruchamia pozostałych.
     *
     * Lista, nie mapa po selektorze: jeden element bywa obsługiwany przez kilka
     * wysp naraz. Zakres wyszukiwarki jest jednocześnie `[data-q-picker]`
     * (otwieranie listy) i `[data-q-scope]` (wybór pozycji), a dwie wyspy potrafią
     * też dzielić ten sam selektor. Mapa po selektorze cicho gubiłaby tę drugą.
     */
    var islands = [];

    /**
     * @param {string}   selector element, na którym wyspa ma działać
     * @param {Function} setup    wywoływane raz na element
     */
    function register(selector, setup) {
        islands.push({
            selector: selector,
            setup: setup,
            // Ślad po elementach już obsłużonych, osobny dla każdej wyspy.
            // Wspólny znacznik na elemencie znaczyłby „ktoś tu już był" i druga
            // wyspa na tym samym elemencie nigdy by się nie podpięła.
            ready: new WeakSet(),
        });
    }

    function hydrate(root) {
        islands.forEach(function (island) {
            (root || document).querySelectorAll(island.selector).forEach(function (el) {
                // Element mógł już zostać obsłużony, gdy fragment strony wrócił
                // z AJAX-a. Drugie uruchomienie podpięłoby zdarzenia dwa razy.
                if (island.ready.has(el)) {
                    return;
                }
                island.ready.add(el);

                try {
                    island.setup(el);
                } catch (e) {
                    // Awaria jednej wyspy nie może zatrzymać pozostałych.
                    if (window.console) {
                        console.error('[Quince] wyspa ' + island.selector + ':', e);
                    }
                }
            });
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        hydrate(document);
    });

    /**
     * PrestaShop podmienia fragmenty strony przez AJAX: listing po zmianie
     * filtrów, koszyk po dodaniu produktu. Nowy HTML nie ma podpiętych zdarzeń,
     * więc po każdej takiej podmianie wyspy trzeba uruchomić ponownie.
     */
    if (window.prestashop && typeof window.prestashop.on === 'function') {
        ['updatedProductList', 'updateCart', 'updatedProduct'].forEach(function (event) {
            window.prestashop.on(event, function () {
                hydrate(document);
            });
        });
    }

    /**
     * Dostawcy oceny formularzy (reCAPTCHA i podobne).
     *
     * Formularz wysłany zwykłym przyciskiem dostawca obsługuje sam, na zdarzeniu
     * `submit`. Szuflady wysyłają jednak swoje formularze w tle i tego zdarzenia
     * nie ma. Bez dodatkowego kroku pole dostawcy nie trafiłoby do zgłoszenia,
     * a sklep z włączoną oceną by je odrzucił. Szuflada woła `prepareForm(dane)` tuż przed wysyłką
     * i czeka, aż każdy dostawca dopisze swoje pola.
     *
     * Dostawca dostaje dane wysyłki (`URLSearchParams`) i może zwrócić obietnicę.
     * Jego awaria nie zatrzymuje wysyłki: zgłoszenie idzie bez jego pola, a o tym,
     * czy je przyjąć, i tak rozstrzyga sklep.
     */
    var dostawcy = [];

    function addFormProvider(dostawca) {
        if (typeof dostawca === 'function') {
            dostawcy.push(dostawca);
        }
    }

    function prepareForm(dane) {
        return dostawcy.reduce(function (kolejka, dostawca) {
            return kolejka.then(function () {
                return dostawca(dane);
            }).catch(function () {});
        }, Promise.resolve()).then(function () {
            return dane;
        });
    }

    window.Quince = {
        register: register,
        hydrate: hydrate,
        addFormProvider: addFormProvider,
        prepareForm: prepareForm,
    };
})();
