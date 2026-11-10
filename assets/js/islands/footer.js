/* ===================================================================
   Quince — składanie sekcji stopki na wąskich ekranach

   Cztery kolumny odnośników ustawione jedna pod drugą dają na telefonie
   bardzo długi ogon strony: klient przewija kilka ekranów samych linków,
   zanim dojedzie do końca. Na wąskim ekranie zwijamy więc każdą sekcję do
   samej nazwy i rozwijamy tę, którą klient wskaże.

   Bez JavaScriptu stopka zostaje rozwinięta w całości — dłuższa, ale w pełni
   czytelna i klikalna. Zwijanie jest udogodnieniem, nie warunkiem działania.

   Sekcją jest kolumna, jeśli sprzedawca nadał jej nazwę; jeśli nie, sekcją
   staje się każdy blok modułu z własnym nagłówkiem. Dzięki temu nazwa nie
   dubluje się z nagłówkiem bloku, który pod nią stoi.

   Kolumna z danymi firmy nie składa się nigdy: adres i telefon to jedyne
   rzeczy w stopce, których klient szuka od razu.
   =================================================================== */

(function () {
    'use strict';

    var PROG = '(max-width: 767px)';

    // Nagłówki, jakimi opisują się bloki: własne szablony motywu oraz to,
    // czym posługują się moduły PrestaShopa.
    var NAGLOWKI = 'h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6,'
        + ' .block-title, .footer-block__title';

    /** Nagłówek sekcji, o ile stoi bezpośrednio w niej, a nie w jej wnętrzu. */
    function tytulSekcji(element) {
        var dzieci = element.children;

        for (var i = 0; i < dzieci.length; i++) {
            if (dzieci[i].matches(NAGLOWKI)) {
                return dzieci[i];
            }
        }

        return null;
    }

    /**
     * Zawartość sekcji trafia do jednego pojemnika: bez niego nie ma czego
     * animować, bo rodzeństwa nagłówka jest kilka i każde ma własną wysokość.
     */
    function zbudujSekcje(element, tytul) {
        var fold = document.createElement('div');
        fold.className = 'q-footer__fold';

        while (tytul.nextSibling) {
            fold.appendChild(tytul.nextSibling);
        }

        if (!fold.childNodes.length) {
            return null;
        }

        element.appendChild(fold);
        element.classList.add('q-footer__sect');
        tytul.classList.add('q-footer__sect-trigger');

        return { element: element, tytul: tytul, fold: fold };
    }

    /** Sekcje stopki w kolejności, w jakiej stoją na stronie. */
    function znajdzSekcje(stopka) {
        var out = [];

        stopka.querySelectorAll('.q-footer__col').forEach(function (kolumna) {
            // Dane firmy zostają otwarte — po to tu są.
            if (kolumna.classList.contains('q-footer__col--wide')) {
                return;
            }

            var tytul = tytulSekcji(kolumna);

            if (tytul) {
                var sekcja = zbudujSekcje(kolumna, tytul);

                if (sekcja) {
                    out.push(sekcja);
                }

                return;
            }

            // Kolumna bez własnej nazwy: składa się każdy blok osobno.
            var nav = kolumna.querySelector('.q-footer__nav');

            if (!nav) {
                return;
            }

            Array.prototype.forEach.call(nav.children, function (blok) {
                var naglowek = blok.matches(NAGLOWKI) ? null : blok.querySelector(NAGLOWKI);

                if (!naglowek || naglowek.parentNode !== blok) {
                    return;
                }

                var sekcja = zbudujSekcje(blok, naglowek);

                if (sekcja) {
                    out.push(sekcja);
                }
            });
        });

        return out;
    }

    function otworz(sekcja) {
        sekcja.element.classList.add('is-open');
        sekcja.tytul.setAttribute('aria-expanded', 'true');
        // Wysokość mierzona, a nie z góry przyjęta: lista ośmiu odnośników
        // i lista dwóch nie mieszczą się w tej samej liczbie.
        sekcja.fold.style.maxHeight = sekcja.fold.scrollHeight + 'px';
    }

    function zamknij(sekcja) {
        sekcja.element.classList.remove('is-open');
        sekcja.tytul.setAttribute('aria-expanded', 'false');
        sekcja.fold.style.maxHeight = '';
    }

    function setup(stopka) {
        var sekcje = znajdzSekcje(stopka);

        if (!sekcje.length) {
            return;
        }

        var media = window.matchMedia(PROG);

        sekcje.forEach(function (sekcja) {
            sekcja.tytul.addEventListener('click', function () {
                if (!media.matches) {
                    return;
                }

                if (sekcja.element.classList.contains('is-open')) {
                    zamknij(sekcja);
                } else {
                    otworz(sekcja);
                }
            });

            // Nagłówek nie jest przyciskiem w znaczniku, bo na szerokim ekranie
            // niczego nie przełącza. Rolę i obsługę klawiatury dostaje wtedy,
            // kiedy zaczyna działać.
            sekcja.tytul.addEventListener('keydown', function (e) {
                if (!media.matches || (e.key !== 'Enter' && e.key !== ' ')) {
                    return;
                }

                e.preventDefault();
                sekcja.tytul.click();
            });
        });

        function przelacz() {
            if (media.matches) {
                stopka.classList.add('q-footer--folded');

                sekcje.forEach(function (sekcja) {
                    sekcja.tytul.setAttribute('role', 'button');
                    sekcja.tytul.setAttribute('tabindex', '0');
                    sekcja.tytul.setAttribute('aria-expanded', 'false');
                    sekcja.fold.style.maxHeight = '';
                    sekcja.element.classList.remove('is-open');
                });

                return;
            }

            // Szeroki ekran: stopka wraca do czterech kolumn, więc nagłówek
            // przestaje być przyciskiem, a treść przestaje mieć limit wysokości.
            stopka.classList.remove('q-footer--folded');

            sekcje.forEach(function (sekcja) {
                sekcja.tytul.removeAttribute('role');
                sekcja.tytul.removeAttribute('tabindex');
                sekcja.tytul.removeAttribute('aria-expanded');
                sekcja.fold.style.maxHeight = '';
                sekcja.element.classList.remove('is-open');
            });
        }

        przelacz();

        if (typeof media.addEventListener === 'function') {
            media.addEventListener('change', przelacz);
        } else if (typeof media.addListener === 'function') {
            media.addListener(przelacz);
        }
    }

    /**
     * Powrót na górę strony. Przycisk czeka schowany, aż będzie po co wracać —
     * pokazany od pierwszego piksela przewinięcia zasłaniałby treść bez powodu.
     */
    function powrot(przycisk) {
        var czeka = false;

        function sprawdz() {
            czeka = false;
            przycisk.classList.toggle('is-shown', window.scrollY > 300);
        }

        window.addEventListener('scroll', function () {
            if (czeka) {
                return;
            }

            // Sprawdzenie raz na klatkę: zdarzenie przewijania potrafi paść
            // kilkadziesiąt razy na sekundę, a klasa zmienia się najwyżej raz.
            czeka = true;
            window.requestAnimationFrame(sprawdz);
        }, { passive: true });

        przycisk.addEventListener('click', function () {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });

        sprawdz();
    }

    if (window.Quince && typeof window.Quince.register === 'function') {
        window.Quince.register('[data-q-footer]', setup);
        window.Quince.register('[data-q-totop]', powrot);
    }
})();
