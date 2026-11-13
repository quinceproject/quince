/* ===================================================================
   Quince: pas zapowiedzi

   Wyspa: działa tylko wtedy, gdy slajder jest na stronie. Bez JavaScriptu
   taśma zostaje zwykłym pasem przewijanym palcem i kółkiem. To nie jest
   awaria, tylko brak udogodnienia. Dlatego przechodzenie opiera się na
   przewijaniu kontenera, a nie na przestawianiu elementów: wtedy jedno
   i drugie pokazuje to samo.

   Samo przechodzenie zatrzymuje się, kiedy wskaźnik stoi nad pasem albo gdy
   ognisko klawiatury jest w środku. Zapowiedź, którą ktoś właśnie czyta, nie
   ma mu uciekać.
   =================================================================== */

(function () {
    'use strict';

    function setup(slider) {
        var track = slider.querySelector('[data-q-slider-track]');

        if (!track) {
            return;
        }

        var slides = track.querySelectorAll('.q-slider__slide');

        if (slides.length < 2) {
            return;
        }

        var dots = slider.querySelectorAll('[data-q-slider-dot]');
        var prev = slider.querySelector('[data-q-slider-prev]');
        var next = slider.querySelector('[data-q-slider-next]');

        var autoplay = slider.dataset.autoplay === '1';
        var interval = Math.max(2, parseInt(slider.dataset.interval, 10) || 6) * 1000;
        var timer = null;
        var stoi = false;

        /* Który slajd stoi w kadrze. Liczymy z położenia taśmy, a nie z licznika
           u siebie: po przewinięciu palcem licznik rozjechałby się z tym, co widać. */
        function biezacy() {
            return Math.round(track.scrollLeft / track.clientWidth);
        }

        function idzDo(numer) {
            var ile = slides.length;
            var cel = ((numer % ile) + ile) % ile;

            track.scrollTo({ left: cel * track.clientWidth, behavior: 'smooth' });
        }

        function odswiezKropki() {
            var teraz = biezacy();

            dots.forEach(function (dot, i) {
                dot.classList.toggle('is-active', i === teraz);
                dot.setAttribute('aria-current', i === teraz ? 'true' : 'false');
            });
        }

        function ruszaj() {
            if (!autoplay || timer) {
                return;
            }

            timer = window.setInterval(function () {
                if (!stoi) {
                    idzDo(biezacy() + 1);
                }
            }, interval);
        }

        function stop() {
            if (timer) {
                window.clearInterval(timer);
                timer = null;
            }
        }

        if (prev) {
            prev.addEventListener('click', function () { idzDo(biezacy() - 1); });
        }

        if (next) {
            next.addEventListener('click', function () { idzDo(biezacy() + 1); });
        }

        dots.forEach(function (dot, i) {
            dot.addEventListener('click', function () { idzDo(i); });
        });

        track.addEventListener('scroll', function () {
            window.requestAnimationFrame(odswiezKropki);
        }, { passive: true });

        /* Pas zatrzymuje się pod wskaźnikiem i przy ognisku klawiatury. */
        ['mouseenter', 'focusin'].forEach(function (zdarzenie) {
            slider.addEventListener(zdarzenie, function () { stoi = true; });
        });

        ['mouseleave', 'focusout'].forEach(function (zdarzenie) {
            slider.addEventListener(zdarzenie, function () { stoi = false; });
        });

        /* Poza oknem przeglądarki nie ma po co przewijać: licznik i tak
           chodziłby, a odwiedzający zobaczyłby skok po powrocie. */
        document.addEventListener('visibilitychange', function () {
            if (document.hidden) {
                stop();
            } else {
                ruszaj();
            }
        });

        /* Zmiana szerokości okna zmienia szerokość kadru, więc położenie taśmy
           przestaje wskazywać ten sam slajd. Ustawiamy ją na nowo. */
        window.addEventListener('resize', function () {
            track.scrollTo({ left: biezacy() * track.clientWidth });
        });

        odswiezKropki();
        ruszaj();
    }

    function start() {
        document.querySelectorAll('[data-q-slider]').forEach(setup);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }
})();
