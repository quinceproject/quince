/**
 * Quince — pole wyboru z własną listą.
 *
 * Nakładka na listę pozycji: otwieranie, wybór, klawiatura. Sama nie decyduje,
 * co się dzieje po wyborze — pozycje są odnośnikami albo przyciskami i robią
 * swoje. Dzięki temu bez JavaScriptu wszystko dalej działa, tylko lista stoi
 * rozwinięta.
 *
 * Nasłuchy siedzą na dokumencie, a nie na polach: rdzeń PrestaShopa podmienia
 * kawałki listingu przy zawężaniu, więc pole sortowania po każdej zmianie
 * filtrów jest nowym węzłem i wcześniejsze nasłuchy zniknęłyby razem ze starym.
 */
(function () {
    'use strict';

    function pole(wezel) {
        return wezel.closest('[data-q-select]');
    }

    function lista(p) {
        return p.querySelector('[data-q-select-list]');
    }

    function przycisk(p) {
        return p.querySelector('[data-q-select-button]');
    }

    function opcje(p) {
        return [].slice.call(p.querySelectorAll('[data-q-select-option]'));
    }

    function zamknij(p, wracamNaPrzycisk) {
        var l = lista(p);
        var b = przycisk(p);

        if (!l || !b) {
            return;
        }

        l.hidden = true;
        b.setAttribute('aria-expanded', 'false');

        if (wracamNaPrzycisk) {
            b.focus();
        }
    }

    function otworz(p) {
        var l = lista(p);
        var b = przycisk(p);

        if (!l || !b) {
            return;
        }

        /* Inne otwarte pole zamykamy: dwie rozwinięte listy naraz zasłaniają
           się nawzajem. */
        document.querySelectorAll('[data-q-select]').forEach(function (inne) {
            if (inne !== p) {
                zamknij(inne, false);
            }
        });

        l.hidden = false;
        b.setAttribute('aria-expanded', 'true');

        var wybrana = opcje(p).filter(function (o) {
            return o.getAttribute('aria-selected') === 'true';
        })[0];

        (wybrana || opcje(p)[0] || b).focus();
    }

    document.addEventListener('click', function (zdarzenie) {
        var b = zdarzenie.target.closest('[data-q-select-button]');

        if (b) {
            var p = pole(b);

            if (p) {
                if (lista(p) && lista(p).hidden) {
                    otworz(p);
                } else {
                    zamknij(p, true);
                }
            }

            return;
        }

        /* Kliknięcie poza polem zamyka — najczęstszy odruch wyjścia. */
        document.querySelectorAll('[data-q-select]').forEach(function (p) {
            if (!p.contains(zdarzenie.target)) {
                zamknij(p, false);
            }
        });
    });

    document.addEventListener('keydown', function (zdarzenie) {
        var cel = zdarzenie.target;
        var p = cel.closest ? cel.closest('[data-q-select]') : null;

        if (!p) {
            return;
        }

        var wszystkie = opcje(p);
        var i = wszystkie.indexOf(cel);

        if (cel.closest('[data-q-select-button]')) {
            if (zdarzenie.key === 'ArrowDown' || zdarzenie.key === 'Enter' || zdarzenie.key === ' ') {
                zdarzenie.preventDefault();

                if (lista(p) && lista(p).hidden) {
                    otworz(p);
                }
            }

            return;
        }

        if (i === -1) {
            return;
        }

        if (zdarzenie.key === 'ArrowDown') {
            zdarzenie.preventDefault();
            (wszystkie[i + 1] || wszystkie[0]).focus();
        } else if (zdarzenie.key === 'ArrowUp') {
            zdarzenie.preventDefault();
            (wszystkie[i - 1] || wszystkie[wszystkie.length - 1]).focus();
        } else if (zdarzenie.key === 'Escape') {
            zamknij(p, true);
        }
    });
}());
