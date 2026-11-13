/* ===================================================================
   Quince: szuflada logowania w kasie

   Klient, który ma konto, loguje się bez wychodzenia z kasy: szuflada
   dokłada się z boku i zostawia widoczne to, co już wypełnił. Rdzeń stawia
   logowanie jako drugą zakładkę obok zakupu i każe wybierać, zanim klient
   zobaczy formularz.

   Ta sama obsługa, co w szufladzie koszyka: `showModal()`, zamknięcie
   przyciskiem, klawiszem Escape i kliknięciem w tło, a po zamknięciu ognisko
   wraca na przycisk, który ją otworzył.

   Wyspa: bez JavaScriptu przycisk nic nie robi, a klient zamawia jako gość
   albo loguje się ze strony logowania. To nie jest awaria, tylko brak
   udogodnienia.
   =================================================================== */

(function () {
    'use strict';

    function setup(okno) {
        if (okno.dataset.qGotowe) return;
        okno.dataset.qGotowe = '1';

        var wyzwalacz = null;

        var zamknij = function () {
            if (typeof okno.close === 'function') okno.close();
        };

        document.addEventListener('click', function (zdarzenie) {
            var przycisk = zdarzenie.target.closest('[data-q-login-open]');
            if (!przycisk) return;

            zdarzenie.preventDefault();
            wyzwalacz = przycisk;

            if (typeof okno.showModal === 'function') {
                okno.showModal();
            } else {
                okno.setAttribute('open', '');
            }

            /* Ognisko na pierwszym polu: szuflada otwiera się po to, żeby
               klient od razu pisał, a nie szukał, gdzie zacząć. */
            var pole = okno.querySelector('input:not([type="hidden"])');
            if (pole) pole.focus();
        });

        /* Kliknięcie w tło: przy <dialog> zdarzenie z ::backdrop przychodzi na
           samym oknie, więc rozpoznaje się je po celu kliknięcia. */
        okno.addEventListener('click', function (zdarzenie) {
            if (zdarzenie.target === okno || zdarzenie.target.closest('[data-q-login-close]')) {
                zamknij();
            }
        });

        okno.addEventListener('close', function () {
            if (wyzwalacz) {
                wyzwalacz.focus();
                wyzwalacz = null;
            }
        });
    }

    function start() {
        document.querySelectorAll('[data-q-login-drawer]').forEach(setup);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }

    /* Kasa przerysowuje kroki po każdym przejściu dalej. */
    if (window.prestashop && typeof prestashop.on === 'function') {
        prestashop.on('changedCheckoutStep', start);
    }
}());
