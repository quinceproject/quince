/**
 * Quince: karuzela zajawek produktu.
 *
 * Taśma przewija się sama: palcem, kółkiem myszy i klawiaturą, bo to zwykłe
 * przewijanie w poziomie. Skrypt dokłada tylko dwie rzeczy, których CSS nie
 * umie: przesunięcie o jedną kartę po kliknięciu strzałki i wygaszenie strzałki
 * na krańcu taśmy.
 *
 * Bez tego pliku karuzela nadal działa, tylko strzałki nic nie robią.
 *
 * Projekt: makieta strony produktu, sekcje karuzel.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    Quince.register('[data-q-carousel]', function (karuzela) {
        var tasma = karuzela.querySelector('[data-q-carousel-track]');
        var wstecz = karuzela.querySelector('[data-q-carousel-prev]');
        var dalej = karuzela.querySelector('[data-q-carousel-next]');

        if (!tasma) {
            return;
        }

        function odswiez() {
            var zapas = tasma.scrollWidth - tasma.clientWidth;

            if (wstecz) {
                wstecz.disabled = tasma.scrollLeft <= 1;
            }

            if (dalej) {
                dalej.disabled = tasma.scrollLeft >= zapas - 1;
            }
        }

        /* Krok to szerokość jednej karty z przerwą, a nie cała szerokość taśmy:
           przy skoku o pełny ekran karta, na którą klient właśnie patrzył,
           znika bez śladu i nie wiadomo, co się przesunęło. */
        function przesun(kierunek) {
            var karta = tasma.querySelector('.q-carousel__item');
            var przerwa = parseFloat(window.getComputedStyle(tasma).columnGap) || 0;
            var krok = karta ? karta.getBoundingClientRect().width + przerwa : tasma.clientWidth;

            tasma.scrollBy({ left: krok * kierunek, behavior: 'smooth' });
        }

        if (wstecz) {
            wstecz.addEventListener('click', function () {
                przesun(-1);
            });
        }

        if (dalej) {
            dalej.addEventListener('click', function () {
                przesun(1);
            });
        }

        tasma.addEventListener('scroll', odswiez, { passive: true });

        // Szerokość karty zmienia się z szerokością okna, więc kraniec taśmy
        // wypada wtedy gdzie indziej.
        var czeka = false;

        window.addEventListener('resize', function () {
            if (czeka) {
                return;
            }

            czeka = true;
            window.requestAnimationFrame(function () {
                czeka = false;
                odswiez();
            });
        });

        odswiez();
    });
})();
