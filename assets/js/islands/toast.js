/**
 * Quince: powiadomienia
 *
 * Zamykanie i samoznikanie toastów wypisanych przez serwer oraz wspólne wejście
 * dla skryptów: `Quince.toast(tekst, rodzaj)`. Dzięki niemu dodanie do koszyka
 * czy dodanie do ulubionych mówi to samo i tak samo, co komunikat po
 * przekierowaniu, bez powielania znaczników w każdej wyspie.
 *
 * Sukces i informacja znikają same; błąd i ostrzeżenie zostają, dopóki klient
 * ich nie zamknie. Komunikat, przez który coś się nie udało, musi doczekać
 * przeczytania.
 */
(function () {
    'use strict';

    var ZNIKA_PO = 6000;
    var TRWANIE_ZNIKANIA = 200;

    var IKONY = {
        success: 'M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16m3.97-10.53a.75.75 0 0 0-1.07-.02L6.9 9.42 5.1 7.6a.75.75 0 1 0-1.06 1.06l2.35 2.35c.3.29.77.29 1.06 0l4.5-4.5a.75.75 0 0 0 .02-1.04',
        warning: 'M7.1 1.7a1 1 0 0 1 1.8 0l6 11.3A1 1 0 0 1 14 14.5H2a1 1 0 0 1-.9-1.5zM8 5a.75.75 0 0 0-.75.75v3.5a.75.75 0 0 0 1.5 0v-3.5A.75.75 0 0 0 8 5m0 7a1 1 0 1 0 0-2 1 1 0 0 0 0 2',
        danger: 'M5.5.5h5L15.5 5.5v5L10.5 15.5h-5L.5 10.5v-5zM8 4a.75.75 0 0 0-.75.75v3.5a.75.75 0 0 0 1.5 0v-3.5A.75.75 0 0 0 8 4m0 7a1 1 0 1 0 0-2 1 1 0 0 0 0 2',
        info: 'M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16M8 4a1 1 0 1 1 0 2 1 1 0 0 1 0-2m.75 3.75a.75.75 0 0 0-1.5 0v3.5a.75.75 0 0 0 1.5 0z',
    };

    function schowaj(toast) {
        if (toast.classList.contains('is-znika')) {
            return;
        }

        toast.classList.add('is-znika');

        window.setTimeout(function () {
            var pojemnik = toast.parentElement;

            toast.remove();

            // Puste pudełko zostaje w dokumencie, ale bez ani jednego toasta nie
            // ma czego pokazywać, a i tak nie łapie kliknięć.
            if (pojemnik && !pojemnik.children.length) {
                pojemnik.remove();
            }
        }, TRWANIE_ZNIKANIA);
    }

    function obsluz(toast) {
        var zamknij = toast.querySelector('[data-q-toast-zamknij]');

        if (zamknij) {
            zamknij.addEventListener('click', function () {
                schowaj(toast);
            });
        }

        var rodzaj = toast.getAttribute('data-q-typ');

        if (rodzaj !== 'success' && rodzaj !== 'info') {
            return;
        }

        var zegar = window.setTimeout(function () {
            schowaj(toast);
        }, ZNIKA_PO);

        // Kursor na komunikacie znaczy, że ktoś go właśnie czyta.
        toast.addEventListener('mouseenter', function () {
            window.clearTimeout(zegar);
        });
    }

    Quince.register('[data-q-toasts]', function (pojemnik) {
        [].slice.call(pojemnik.querySelectorAll('[data-q-toast]')).forEach(obsluz);
    });

    /**
     * Komunikat ze skryptu.
     *
     * @param {string} tekst  treść, już przetłumaczona
     * @param {string} rodzaj success | info | warning | danger
     */
    Quince.toast = function (tekst, rodzaj) {
        rodzaj = IKONY[rodzaj] ? rodzaj : 'info';

        var pojemnik = document.querySelector('[data-q-toasts]');

        if (!pojemnik) {
            pojemnik = document.createElement('div');
            pojemnik.className = 'q-toasts';
            pojemnik.setAttribute('data-q-toasts', '');
            pojemnik.setAttribute('aria-live', 'polite');
            document.body.appendChild(pojemnik);
        }

        var toast = document.createElement('div');

        toast.className = 'q-toast q-toast--' + rodzaj;
        toast.setAttribute('data-q-toast', '');
        toast.setAttribute('data-q-typ', rodzaj);

        if (rodzaj === 'danger' || rodzaj === 'warning') {
            toast.setAttribute('role', 'alert');
        }

        toast.innerHTML = '<svg class="q-toast__icon" width="18" height="18" viewBox="0 0 16 16"'
            + ' fill="currentColor" aria-hidden="true"><path d="' + IKONY[rodzaj] + '"/></svg>'
            + '<div class="q-toast__body"></div>'
            + '<button class="q-toast__close" type="button" data-q-toast-zamknij>'
            + '<svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor"'
            + ' stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M12 4 4 12M4 4l8 8"/></svg>'
            + '</button>';

        // Treść wstawiana jako tekst, nie jako znaczniki: komunikat bywa składany
        // z nazwy produktu, a ta pochodzi z katalogu sklepu.
        toast.querySelector('.q-toast__body').textContent = tekst;

        pojemnik.appendChild(toast);
        obsluz(toast);

        return toast;
    };
})();
