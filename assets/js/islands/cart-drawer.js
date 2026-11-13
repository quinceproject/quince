/**
 * Quince: szuflada koszyka
 *
 * Treść szuflady to widżet ps_shoppingcart. Moduł koszyka po każdym zdarzeniu
 * `updateCart` sam pobiera widżet na nowo i podmienia element `.blockcart`,
 * a po dodaniu produktu woła `prestashop.blockcart.showModal()` z potwierdzeniem.
 * Motyw dokłada trzy rzeczy:
 *
 * 1. `showModal` otwiera szufladę z komunikatem „dodano" zamiast okna na środku.
 *    Musi być ustawione, zanim moduł koszyka odczyta je w swoim DOM-ready,
 *    dlatego stoi na najwyższym poziomie pliku, a nie w wyspie.
 * 2. Przycisk koszyka w nagłówku otwiera szufladę. Bez skryptu prowadzi na
 *    stronę koszyka.
 * 3. Zmiana ilości i usunięcie pozycji. Wysyłamy je do kontrolera koszyka tak,
 *    jak robi to strona koszyka, i ogłaszamy `updateCart`: odświeżą się wtedy
 *    szuflada, licznik w nagłówku i strona koszyka, jeśli akurat jest otwarta.
 *
 * Zdarzenia są podpięte do samego okna, a nie do przycisków w nim: treść
 * podmienia się po każdej zmianie i przyciski z poprzedniej wersji znikają.
 *
 * Projekt: makieta strony produktu, szuflada koszyka.
 */
(function () {
    'use strict';

    var sklep = window.prestashop = window.prestashop || {};

    function szuflada() {
        return document.querySelector('[data-q-cart-drawer]');
    }

    /**
     * Otwarcie szuflady. Komunikat przychodzi tylko po dodaniu produktu;
     * otwarcie z nagłówka go czyści, bo nie ma czego potwierdzać.
     */
    function otworz(okno, komunikat) {
        var miejsce = okno.querySelector('[data-q-cart-alert]');

        if (miejsce) {
            miejsce.innerHTML = komunikat || '';
        }

        if (!okno.open) {
            okno.showModal();
        }

        // Każde otwarcie od góry: po dodaniu produktu komunikat i pasek
        // dostawy stoją na początku listy.
        var tresc = okno.querySelector('.q-modal__body');

        if (tresc) {
            tresc.scrollTop = 0;
        }
    }

    sklep.blockcart = sklep.blockcart || {};
    sklep.blockcart.showModal = function (komunikat) {
        var okno = szuflada();

        if (okno && typeof okno.showModal === 'function') {
            otworz(okno, komunikat);
        }
    };

    Quince.register('[data-q-cart-drawer]', function (okno) {
        if (typeof okno.showModal !== 'function') {
            return;
        }

        var wyzwalacz = null;
        var ognisko = null;

        document.addEventListener('click', function (zdarzenie) {
            var przycisk = zdarzenie.target.closest('[data-q-cart-open]');

            if (!przycisk) {
                return;
            }

            zdarzenie.preventDefault();
            wyzwalacz = przycisk;
            otworz(okno, '');
        });

        // Kliknięcie w tło: przy <dialog> zdarzenie z ::backdrop przychodzi na
        // samym oknie, więc rozpoznaje się je po celu kliknięcia.
        okno.addEventListener('click', function (zdarzenie) {
            if (zdarzenie.target === okno || zdarzenie.target.closest('[data-q-cart-close]')) {
                okno.close();

                return;
            }

            var zmiana = zdarzenie.target.closest('[data-q-cart-qty]');

            if (zmiana) {
                var pole = zmiana.parentNode.querySelector('[data-q-cart-input]');
                var teraz = parseInt(pole.getAttribute('data-quantity'), 10) || 1;
                var krok = zmiana.getAttribute('data-q-cart-qty') === '+' ? 1 : -1;

                // Zejście poniżej jednej sztuki to usunięcie, a do tego jest
                // osobny przycisk. Minus przy jednej sztuce nic nie robi.
                if (teraz + krok < 1) {
                    return;
                }

                zmienIlosc(zmiana, teraz + krok, 'qty' + zmiana.getAttribute('data-q-cart-qty'));

                return;
            }

            var usun = zdarzenie.target.closest('[data-q-cart-remove]');

            if (usun) {
                wyslij(usun, usun.getAttribute('data-q-cart-remove'), {}, 'delete-from-cart', null);
            }
        });

        // Wpisana ilość idzie do sklepu dopiero po zatwierdzeniu pola, a nie
        // przy każdej cyfrze: „12" nie może po drodze zamówić jednej sztuki.
        okno.addEventListener('change', function (zdarzenie) {
            var pole = zdarzenie.target.closest('[data-q-cart-input]');

            if (!pole) {
                return;
            }

            var ile = parseInt(pole.value, 10);

            if (!(ile >= 1)) {
                pole.value = pole.getAttribute('data-quantity');

                return;
            }

            zmienIlosc(pole, ile, 'input');
        });

        okno.addEventListener('close', function () {
            if (wyzwalacz && document.contains(wyzwalacz)) {
                wyzwalacz.focus();
            }

            wyzwalacz = null;
        });

        // Po podmianie treści ognisko wraca na tę samą kontrolkę tej samej
        // pozycji. Bez tego osoba na klawiaturze po każdym „+" lądowałaby na
        // początku strony, poza szufladą. Gdy kontrolki już nie ma (pozycja
        // usunięta, przycisk dokupki zniknął razem z podpowiedzią), ognisko
        // idzie na zamknięcie szuflady.
        new MutationObserver(function () {
            if (!okno.open || (!ognisko && okno.contains(document.activeElement))) {
                return;
            }

            var cel = null;
            var pozycja = ognisko && okno.querySelector('[data-q-cart-line="' + ognisko.pozycja + '"]');

            if (pozycja) {
                cel = ognisko.kontrolka === 'input'
                    ? pozycja.querySelector('[data-q-cart-input]')
                    : pozycja.querySelector('[data-q-cart-qty="' + ognisko.kontrolka.slice(3) + '"]');
            }

            (cel || okno.querySelector('[data-q-cart-close]')).focus();
            ognisko = null;
        }).observe(okno.querySelector('[data-q-cart-content]') || okno, { childList: true });

        function zmienIlosc(kontrolka, ile, nazwa) {
            var pole = kontrolka.closest('.q-qty').querySelector('[data-q-cart-input]');
            var teraz = parseInt(pole.getAttribute('data-quantity'), 10) || 1;
            var roznica = ile - teraz;

            if (roznica === 0) {
                return;
            }

            wyslij(kontrolka, pole.getAttribute('data-q-cart-url'), {
                op: roznica > 0 ? 'up' : 'down',
                qty: String(Math.abs(roznica)),
            }, 'update-quantity', nazwa);
        }

        function wyslij(kontrolka, adres, pola, akcja, nazwa) {
            var pozycja = kontrolka.closest('[data-q-cart-line]');
            var dane = new URLSearchParams();

            Object.keys(pola).forEach(function (klucz) {
                dane.append(klucz, pola[klucz]);
            });

            dane.append('ajax', '1');
            dane.append('action', 'update');

            if (sklep.static_token) {
                dane.append('token', sklep.static_token);
            }

            pozycja.setAttribute('aria-busy', 'true');
            ognisko = nazwa ? { pozycja: pozycja.getAttribute('data-q-cart-line'), kontrolka: nazwa } : null;

            fetch(adres, {
                method: 'POST',
                body: dane,
                credentials: 'same-origin',
                headers: { Accept: 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
            })
                .then(function (odpowiedz) {
                    return odpowiedz.json();
                })
                .then(function (wynik) {
                    if (wynik.hasError && typeof Quince.toast === 'function') {
                        Quince.toast((wynik.errors || []).join(' '), 'danger');
                    }

                    // Także po odmowie: szuflada ma pokazać ilość, którą sklep
                    // naprawdę zapisał, a nie tę wpisaną w pole.
                    if (typeof sklep.emit === 'function') {
                        sklep.emit('updateCart', {
                            reason: {
                                idProduct: pozycja.getAttribute('data-id-product'),
                                idProductAttribute: pozycja.getAttribute('data-id-product-attribute'),
                                idCustomization: pozycja.getAttribute('data-id-customization'),
                                linkAction: akcja,
                                cart: wynik.cart,
                            },
                            resp: wynik,
                        });
                    }
                })
                .catch(function () {
                    pozycja.removeAttribute('aria-busy');
                    ognisko = null;
                });
        }
    });
})();
