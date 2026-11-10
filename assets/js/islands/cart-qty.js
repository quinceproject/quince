/* ===================================================================
   Quince — ilość i usuwanie pozycji na stronie koszyka

   Te same zaczepy (`data-q-cart-qty`, `data-q-cart-url`, `data-q-cart-input`,
   `data-q-cart-remove`, `data-q-cart-line`) i ten sam sposób wysyłki, co
   w szufladzie koszyka (`cart-drawer.js`): `op=up/down` + `qty=<różnica>`
   w ciele POST, potem `prestashop.emit('updateCart', ...)`, żeby rdzeń
   podmienił kwoty i stopkę tak samo, jak po własnej akcji.
   =================================================================== */

(function () {
    'use strict';

    var sklep = window.prestashop = window.prestashop || {};

    function zmienIlosc(kontrolka, ile) {
        var pole = kontrolka.closest('.q-qty').querySelector('[data-q-cart-input]');
        var teraz = parseInt(pole.getAttribute('data-quantity'), 10) || 1;
        var roznica = ile - teraz;

        if (roznica === 0) return;

        wyslij(kontrolka, pole.getAttribute('data-q-cart-url'), {
            op: roznica > 0 ? 'up' : 'down',
            qty: String(Math.abs(roznica)),
        }, 'update-quantity');
    }

    function wyslij(kontrolka, adres, pola, akcja) {
        var pozycja = kontrolka.closest('[data-q-cart-line]');
        if (!pozycja) return;

        var dane = new URLSearchParams();
        Object.keys(pola).forEach(function (klucz) { dane.append(klucz, pola[klucz]); });
        dane.append('ajax', '1');
        dane.append('action', 'update');
        if (sklep.static_token) dane.append('token', sklep.static_token);

        pozycja.setAttribute('aria-busy', 'true');

        fetch(adres, {
            method: 'POST',
            body: dane,
            credentials: 'same-origin',
            headers: { Accept: 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
        })
            .then(function (odpowiedz) { return odpowiedz.json(); })
            .then(function (wynik) {
                if (wynik.hasError && typeof Quince !== 'undefined' && typeof Quince.toast === 'function') {
                    Quince.toast((wynik.errors || []).join(' '), 'danger');
                }

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
            });
    }

    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-q-cart-qty]');
        if (przycisk) {
            var pole = przycisk.closest('.q-qty').querySelector('[data-q-cart-input]');
            var teraz = parseInt(pole.getAttribute('data-quantity'), 10) || 1;
            var krok = przycisk.getAttribute('data-q-cart-qty') === '+' ? 1 : -1;

            if (teraz + krok < 1) return;

            zmienIlosc(przycisk, teraz + krok);
            return;
        }

        var usun = zdarzenie.target.closest('[data-q-cart-remove]');
        if (usun) {
            wyslij(usun, usun.getAttribute('data-q-cart-remove'), {}, 'delete-from-cart');
        }
    });

    document.addEventListener('change', function (zdarzenie) {
        var pole = zdarzenie.target.closest('[data-q-cart-input]');
        if (!pole) return;

        var ile = parseInt(pole.value, 10);
        if (!(ile >= 1)) {
            pole.value = pole.getAttribute('data-quantity');
            return;
        }

        zmienIlosc(pole, ile);
    });
}());
