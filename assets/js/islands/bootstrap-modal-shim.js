/* ===================================================================
   Quince — zamiennik okna modalnego Bootstrapa

   Kilka szablonów przychodzących z rdzenia i z modułów (personalizacja
   produktu, zwrot zamówienia, adres w kasie jednostronicowej) rysuje okno
   znacznikami Bootstrapa (`data-bs-toggle="modal"`, `data-bs-dismiss="modal"`,
   czasem wprost `window.bootstrap.Modal`), bo tak wygląda ich oryginalny
   szablon. Quince nie ładuje JS Bootstrapa — ma własne okno na `<dialog>`
   (`.q-modal`, patrz `checkout-login.js` dla tej samej obsługi w szufladzie
   logowania). Zamiast przerabiać każdy szablon, podstawiamy pod te same
   zaczepy nasz mechanizm: okno samo musi być w znacznikach `<dialog
   class="q-modal">`, a tu tylko dopinamy otwieranie, zamykanie i obiekt
   `window.bootstrap.Modal`, którego niektóre moduły (np. ps_onepagecheckout)
   wprost sprawdzają przed użyciem jQuery.

   Wyspa: bez JavaScriptu przycisk nic nie robi. To nie jest awaria okna —
   samo okno w znacznikach `<dialog>` i tak nie ma jak się otworzyć bez JS,
   tak samo jak żadne inne okno w motywie.
   =================================================================== */

(function () {
    'use strict';

    var wyzwalacze = new WeakMap();

    function otworz(okno, wyzwalacz) {
        if (!okno || typeof okno.showModal !== 'function') return;
        if (okno.open) return;

        if (wyzwalacz) wyzwalacze.set(okno, wyzwalacz);
        okno.showModal();

        var pole = okno.querySelector('input:not([type="hidden"]):not([disabled]), select, textarea');
        if (pole) pole.focus();
    }

    function zamknij(okno) {
        if (!okno || typeof okno.close !== 'function') return;
        if (!okno.open) return;
        okno.close();
    }

    function setup(okno) {
        if (okno.dataset.qModalGotowe) return;
        okno.dataset.qModalGotowe = '1';

        /* Kliknięcie w tło: przy <dialog> zdarzenie z ::backdrop przychodzi
           na samym oknie, więc rozpoznaje się je po celu kliknięcia —
           ten sam wzorzec, co w szufladzie logowania. */
        okno.addEventListener('click', function (zdarzenie) {
            if (zdarzenie.target === okno) zamknij(okno);
        });

        okno.addEventListener('close', function () {
            var wyzwalacz = wyzwalacze.get(okno);
            if (wyzwalacz) {
                wyzwalacz.focus();
                wyzwalacze.delete(okno);
            }
        });
    }

    function start() {
        document.querySelectorAll('dialog.q-modal').forEach(setup);
    }

    /* Otwieranie: `data-bs-toggle="modal" data-bs-target="#id"`, albo
       `href="#id"` tam, gdzie szablon moduł nie dał osobnego atrybutu celu. */
    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-bs-toggle="modal"]');
        if (!przycisk) return;

        var cel = przycisk.getAttribute('data-bs-target') || przycisk.getAttribute('href');
        if (!cel || cel.charAt(0) !== '#') return;

        var okno = document.querySelector(cel);
        if (!okno || !okno.matches('dialog.q-modal')) return;

        zdarzenie.preventDefault();
        setup(okno);
        otworz(okno, przycisk);
    });

    /* Zamykanie: `data-bs-dismiss="modal"` wewnątrz otwartego okna. */
    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-bs-dismiss="modal"]');
        if (!przycisk) return;

        var okno = przycisk.closest('dialog.q-modal');
        if (!okno) return;

        zdarzenie.preventDefault();
        zamknij(okno);
    });

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }

    if (window.prestashop && typeof prestashop.on === 'function') {
        prestashop.on('changedCheckoutStep', start);
    }

    /* Obiekt zgodny z API Bootstrapa 5, na tyle, ile moduły faktycznie
       wywołują: `getOrCreateInstance(el).show()` i `getInstance(el).hide()`.
       Część szablonów (np. ps_onepagecheckout) sprawdza `window.bootstrap`
       przed sięgnięciem po wtyczkę jQuery — ten obiekt wygrywa tę kontrolę
       i JS modułu dalej nie szuka Bootstrapa. */
    var instancje = new WeakMap();

    function Modal(okno) {
        this.okno = okno;
        setup(okno);
    }

    Modal.prototype.show = function () { otworz(this.okno); };
    Modal.prototype.hide = function () { zamknij(this.okno); };
    Modal.prototype.toggle = function () {
        if (this.okno.open) this.hide(); else this.show();
    };

    Modal.getInstance = function (okno) {
        return instancje.get(okno) || null;
    };

    Modal.getOrCreateInstance = function (okno) {
        var instancja = instancje.get(okno);
        if (!instancja) {
            instancja = new Modal(okno);
            instancje.set(okno, instancja);
        }
        return instancja;
    };

    window.bootstrap = window.bootstrap || {};
    if (!window.bootstrap.Modal) window.bootstrap.Modal = Modal;
}());
