/**
 * Quince — licznik do końca promocji.
 *
 * Jeden mechanizm dla wszystkich miejsc, w których stoi zegar: pasa promocji
 * nad panelem zakupu, kafelka produktu na listingu i w karuzeli oraz słupka
 * z ceną zestawu.
 *
 * Chwila końca stoi w znaczniku jako liczba sekund, policzona po stronie
 * serwera: przeglądarka klienta bywa przestawiona o godziny, a promocja kończy
 * się wtedy, kiedy kończy ją sklep.
 *
 * Odświeżanie co minutę, bo najmniejszy człon licznika to minuta. Sekundowy
 * krok kosztowałby sześćdziesiąt razy więcej przerysowań i nie pokazałby
 * niczego nowego.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    Quince.register('[data-q-countdown]', function (pole) {
        var koniec = parseInt(pole.getAttribute('data-q-countdown'), 10) * 1000;
        var dni = pole.querySelector('[data-q-countdown-days]');
        var godz = pole.querySelector('[data-q-countdown-hours]');
        var min = pole.querySelector('[data-q-countdown-minutes]');

        if (!koniec || !dni || !godz || !min) {
            return;
        }

        function odswiez() {
            var zostalo = koniec - Date.now();

            /* Po czasie licznik znika, a nie pokazuje samych zer: wyzerowany
               czyta się jak zepsuty, a nie jak koniec promocji. W panelu zakupu
               znika cały pas, bo bez licznika nie niesie już żadnej treści. */
            if (zostalo <= 0) {
                var pas = pole.closest('.q-buy__pas');

                if (pas) {
                    pas.remove();
                } else {
                    pole.hidden = true;
                }

                return;
            }

            var minuty = Math.floor(zostalo / 60000);

            dni.textContent = String(Math.floor(minuty / 1440));
            godz.textContent = dwie(Math.floor(minuty / 60) % 24);
            min.textContent = dwie(minuty % 60);

            window.setTimeout(odswiez, 60000);
        }

        odswiez();
    });

    /** Liczba zawsze na dwóch znakach, żeby licznik nie skakał w poziomie. */
    function dwie(n) {
        return n < 10 ? '0' + n : String(n);
    }
})();
