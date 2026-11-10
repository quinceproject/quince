/* ===================================================================
   Quince — ulubione na karcie produktu

   Serce zapisuje produkt na liście klienta. Listy prowadzi moduł list
   życzeń: jego tabele, jego adresy działań. Nasza jest tylko warstwa
   widoczna — jego własna jest aplikacją Vue budującą przyciski
   w znacznikach motywu klasycznego, których Quince nie ma.

   Strona działa bez tego pliku: bez skryptu serce po prostu nic nie robi,
   a listy zostają dostępne ze strony konta.
   =================================================================== */

(function () {
    'use strict';

    var dane = window.quinceWishlist || {};

    /** Numer listy, na którą zapisujemy. Pobierany raz, przy pierwszym kliknięciu. */
    var idListy = null;

    /**
     * Zapisane produkty, żeby serca miały właściwy stan od razu po wejściu.
     * Listę publikuje moduł list życzeń pod nazwą `productsAlreadyTagged`.
     */
    function zapisane() {
        var lista = window.productsAlreadyTagged;

        return Array.isArray(lista) ? lista : [];
    }

    function jestZapisany(idProduktu, idWariantu) {
        return zapisane().some(function (wpis) {
            return Number(wpis.id_product) === Number(idProduktu)
                && Number(wpis.id_product_attribute) === Number(idWariantu);
        });
    }

    function wywolaj(akcja, parametry) {
        var adres = new URL(dane.adres, window.location.origin);
        adres.searchParams.set('action', akcja);
        adres.searchParams.set('ajax', '1');

        Object.keys(parametry).forEach(function (klucz) {
            adres.searchParams.set('params[' + klucz + ']', parametry[klucz]);
        });

        return fetch(adres, { credentials: 'same-origin' }).then(function (odpowiedz) {
            return odpowiedz.json();
        });
    }

    /**
     * Numer listy klienta.
     *
     * Moduł list zakłada listę domyślną sam, gdy klient nie ma żadnej — dzięki
     * temu nie wymyślamy tu własnej nazwy ani własnego momentu jej powstania.
     */
    function listaKlienta() {
        if (idListy !== null) {
            return Promise.resolve(idListy);
        }

        return wywolaj('getAllWishList', {}).then(function (wynik) {
            var listy = (wynik && wynik.wishlists) || [];

            if (listy.length === 0) {
                return null;
            }

            var domyslna = listy.find(function (l) { return Number(l.default) === 1; }) || listy[0];
            idListy = Number(domyslna.id_wishlist);

            return idListy;
        });
    }

    function ustawStan(przycisk, zapisany) {
        przycisk.setAttribute('aria-pressed', zapisany ? 'true' : 'false');
        przycisk.setAttribute('aria-label', zapisany ? dane.usun : dane.dodaj);
    }

    function przelacz(przycisk) {
        var idProduktu = przycisk.dataset.qWishProdukt;
        var idWariantu = przycisk.dataset.qWishWariant || '0';
        var zapisany = przycisk.getAttribute('aria-pressed') === 'true';

        przycisk.setAttribute('aria-busy', 'true');

        listaKlienta()
            .then(function (idList) {
                if (idList === null) {
                    return null;
                }

                return wywolaj(
                    zapisany ? 'deleteProductFromWishList' : 'addProductToWishList',
                    {
                        idWishList: idList,
                        id_product: idProduktu,
                        id_product_attribute: idWariantu,
                        quantity: 1,
                    }
                );
            })
            .then(function (wynik) {
                if (!wynik || wynik.success === false) {
                    // Odpowiedź „nie jesteś zalogowany" przychodzi tą samą drogą
                    // co każdy inny błąd, więc pytanie o konto stawiamy tutaj —
                    // po kliknięciu, nie przed nim.
                    window.location.href = dane.logowanie;

                    return;
                }

                ustawStan(przycisk, !zapisany);
                przycisk.removeAttribute('aria-busy');

                if (window.prestashop && typeof window.prestashop.emit === 'function') {
                    window.prestashop.emit('updateWishlist', {
                        id_product: idProduktu,
                        added: !zapisany,
                    });
                }
            })
            .catch(function () {
                przycisk.removeAttribute('aria-busy');
            });
    }

    function podepnij(przycisk) {
        ustawStan(
            przycisk,
            jestZapisany(przycisk.dataset.qWishProdukt, przycisk.dataset.qWishWariant || '0')
        );

        przycisk.addEventListener('click', function () {
            przelacz(przycisk);
        });
    }

    if (window.Quince && typeof window.Quince.register === 'function') {
        window.Quince.register('[data-q-wish]', podepnij);
    }
})();
