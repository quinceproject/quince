/**
 * Quince: pas nawigacji
 *
 * Trzy zachowania, po jednym na każdy sposób pokazania katalogu:
 *
 * 1. Rozwinięcie panelu kliknięciem, nie najechaniem. Panel katalogu zajmuje
 *    pół ekranu i otwierany kursorem wyskakuje ludziom, którzy tylko przesuwali
 *    myszą nad paskiem.
 *
 * 2. Wybór działu w układzie kolumnowym: najechanie przełącza prawą stronę.
 *    Tu najechanie jest w porządku: panel już jest otwarty, więc nic nie
 *    wyskakuje, a klient przegląda działy bez klikania w każdy.
 *
 * 3. Kaskada: kolejne poziomy wysuwają się w prawo. Zamknięcie jest opóźnione,
 *    bo przejście kursorem po skosie do wysuniętej kolumny prowadzi nad sąsiednimi
 *    pozycjami; bez zwłoki kaskada zamyka się w drodze do celu i jest nie do obsługi.
 *
 * Projekt: widok paska nawigacji.
 */
(function () {
    'use strict';

    /** Ile czasu kaskada czeka, zanim zamknie gałąź opuszczoną kursorem. */
    var ZWLOKA = 220;

    /* Panel z katalogiem na telefonie. Rozwijanie poziomów robi sam znacznik
       <details>, więc skrypt odpowiada wyłącznie za otwarcie i zamknięcie okna. */
    Quince.register('[data-q-navmob]', function (panel) {
        document.querySelectorAll('[data-q-navmob-open]').forEach(function (button) {
            button.addEventListener('click', function () {
                if (typeof panel.showModal === 'function') {
                    panel.showModal();
                }
            });
        });

        panel.querySelectorAll('[data-q-navmob-close]').forEach(function (button) {
            button.addEventListener('click', function () {
                panel.close();
            });
        });

        // Kliknięcie w tło zamyka: na telefonie to najczęstszy odruch wyjścia.
        panel.addEventListener('click', function (event) {
            if (event.target === panel) {
                panel.close();
            }
        });
    });

    Quince.register('[data-q-nav]', function (nav) {

        // ── 1. rozwinięcie panelu ─────────────────────────────────────────
        var grupy = nav.querySelectorAll('[data-q-nav-item]');

        function zamknij(grupa) {
            var panel = grupa.querySelector('[data-q-nav-panel]');
            var button = grupa.querySelector('[data-q-nav-button]');

            if (panel) {
                panel.hidden = true;
            }

            if (button) {
                button.setAttribute('aria-expanded', 'false');
            }
        }

        /* Górna krawędź otwartego panelu, z której CSS liczy jego największą
           wysokość (do dołu ekranu minus odstęp). Mierzona po narysowaniu, bo
           dopiero wtedy panel ma położenie; przy panelu schowanym byłoby zero. */
        function zmierzGore(panel) {
            window.requestAnimationFrame(function () {
                if (!panel.hidden) {
                    panel.style.setProperty('--q-nav-panel-top', Math.round(panel.getBoundingClientRect().top) + 'px');
                }
            });
        }

        window.addEventListener('resize', function () {
            nav.querySelectorAll('[data-q-nav-panel]').forEach(zmierzGore);
        });

        grupy.forEach(function (grupa) {
            var button = grupa.querySelector('[data-q-nav-button]');
            var panel = grupa.querySelector('[data-q-nav-panel]');

            if (!button || !panel) {
                return;
            }

            button.addEventListener('click', function (event) {
                event.preventDefault();
                event.stopPropagation();

                var otwieramy = panel.hidden;
                grupy.forEach(zamknij);

                if (otwieramy) {
                    panel.hidden = false;
                    button.setAttribute('aria-expanded', 'true');
                    zmierzGore(panel);
                }
            });
        });

        document.addEventListener('click', function (event) {
            if (!nav.contains(event.target)) {
                grupy.forEach(zamknij);
            }
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                grupy.forEach(zamknij);
            }
        });

        // ── 2. wybór działu w układzie kolumnowym ─────────────────────────
        nav.querySelectorAll('[data-q-nav-cat]').forEach(function (cat) {
            cat.addEventListener('mouseenter', function () {
                var panel = cat.closest('[data-q-nav-panel]');

                if (!panel) {
                    return;
                }

                panel.querySelectorAll('[data-q-nav-cat]').forEach(function (other) {
                    other.classList.toggle('is-current', other === cat);
                });

                var wybrany = cat.getAttribute('data-q-nav-cat');

                panel.querySelectorAll('[data-q-nav-subs]').forEach(function (subs) {
                    subs.hidden = subs.getAttribute('data-q-nav-subs') !== wybrany;
                });
            });
        });

        // ── 3. kaskada ────────────────────────────────────────────────────
        nav.querySelectorAll('[data-q-nav-branch]').forEach(function (item) {
            var flyout = item.querySelector('.q-nav__flyout');

            if (!flyout) {
                return;
            }

            var licznik = null;

            item.addEventListener('mouseenter', function () {
                window.clearTimeout(licznik);

                // Rodzeństwo zamyka się od razu: dwie wysunięte kolumny na tym
                // samym poziomie nachodzą na siebie.
                var poziom = item.parentElement;

                if (poziom) {
                    poziom.querySelectorAll(':scope > [data-q-nav-branch]').forEach(function (other) {
                        if (other !== item) {
                            other.classList.remove('is-open');
                            var inny = other.querySelector('.q-nav__flyout');

                            if (inny) {
                                inny.hidden = true;
                            }
                        }
                    });
                }

                item.classList.add('is-open');
                flyout.hidden = false;
            });

            item.addEventListener('mouseleave', function () {
                licznik = window.setTimeout(function () {
                    item.classList.remove('is-open');
                    flyout.hidden = true;
                }, ZWLOKA);
            });
        });

        // ── 4. zwijanie pasa ──────────────────────────────────────────────
        zwijanie(nav);
    });

    /**
     * Zwijanie pasa, gdy pozycje przestają się mieścić w rzędzie.
     *
     * Rozstrzyga pomiar, a nie szerokość ekranu: liczba i długość pozycji zależą
     * od sklepu i od języka, więc żaden stały próg nie trafia. Za dużo pozycji
     * rozpycha całą stronę w bok na tablecie.
     *
     * Pomiar zawsze na PRAWDZIWYM pasie: zdejmujemy klasę, czytamy, czy treść
     * wystaje, i od razu stawiamy klasę z powrotem. Wszystko w jednym kroku,
     * zanim przeglądarka cokolwiek narysuje, więc nic nie miga, a przełącznik nie
     * skacze na granicy, bo za każdym razem mierzy to samo.
     *
     * Zwijamy tylko wtedy, gdy na stronie jest hamburger. Rysuje się razem
     * z wyszukiwarką; sklep bez niej zostałby po zwinięciu bez nawigacji.
     */
    function zwijanie(nav) {
        var rzad = nav.querySelector('.q-nav__inner');
        var korzen = document.documentElement;

        if (!rzad || !document.querySelector('[data-q-navmob-open]')) {
            return;
        }

        var czeka = false;

        function sprawdz() {
            czeka = false;
            korzen.classList.remove('is-nav-collapsed');

            // Pas schowany regułą telefonu ma zerową szerokość i nic nie wystaje,
            // więc wtedy klasa po prostu nie wraca, a telefonem rządzi styl.
            var wystaje = rzad.scrollWidth > rzad.clientWidth + 1;

            korzen.classList.toggle('is-nav-collapsed', wystaje);
        }

        function zaplanuj() {
            if (czeka) {
                return;
            }

            czeka = true;
            window.requestAnimationFrame(sprawdz);
        }

        sprawdz();
        window.addEventListener('resize', zaplanuj);

        // Powtórka po dojechaniu krojów pisma: pierwszy pomiar wypada na piśmie
        // zastępczym, o innych szerokościach znaków.
        if (document.fonts && document.fonts.ready) {
            document.fonts.ready.then(sprawdz);
        }
    }

    /* 4. Katalog w przyklejonym nagłówku.
     *
     * Nagłówek zostaje przy górnej krawędzi, a pas menu odjeżdża razem ze stroną
     * i zabiera ze sobą jedyne dojście do katalogu. Przejmuje je przycisk w
     * nagłówku i otwiera DOKŁADNIE TEN SAM panel, bo drugi w kodzie strony
     * podwajałby cały katalog.
     *
     * Rozpoznanie stanu idzie obserwatorem przecięcia, nie nasłuchem przewijania:
     * wartownik stoi tuż za pasem menu, a linia odcięcia leży na dolnej krawędzi
     * nagłówka. Kiedy wartownik wychodzi nad nią, katalogu już nie widać.
     */
    Quince.register('[data-q-header]', function (naglowek) {
        var przycisk = naglowek.querySelector('[data-q-cats]');
        var grupa = document.querySelector('[data-q-nav-item]');
        var wartownik = document.querySelector('[data-q-stuck]');

        if (!przycisk || !grupa || !wartownik || !window.IntersectionObserver) {
            return;
        }

        var panel = grupa.querySelector('[data-q-nav-panel]');
        var przyciskPasa = grupa.querySelector('[data-q-nav-button]');

        if (!panel) {
            return;
        }

        var korzen = document.documentElement;

        /* Wysokość nagłówka idzie do tokenu przy :root, a nie przy nagłówku:
           panel siedzi w pasie menu, czyli poza nagłówkiem, więc wartość
           ustawiona na nagłówku nigdy by do niego nie doszła. */
        function zmierzNaglowek() {
            var wysokosc = Math.round(naglowek.getBoundingClientRect().height);
            korzen.style.setProperty('--q-header-h', wysokosc + 'px');

            return wysokosc;
        }

        /* Mierzone przy otwarciu, nie z góry: dopóki przycisk jest schowany, jego
           położenie to zero, a kaskada zaczepiona na zerze wychodzi poza ekran. */
        function zmierzPrzycisk() {
            korzen.style.setProperty('--q-cats-x', Math.round(przycisk.getBoundingClientRect().left) + 'px');
        }

        function zamknij() {
            panel.hidden = true;
            panel.classList.remove('is-floating');
            przycisk.setAttribute('aria-expanded', 'false');

            if (przyciskPasa) {
                przyciskPasa.setAttribute('aria-expanded', 'false');
            }
        }

        przycisk.addEventListener('click', function (zdarzenie) {
            // Bez zatrzymania kliknięcie doszłoby do dokumentu, a tam pas menu
            // zamyka panel przy każdym kliknięciu poza sobą, a przycisk stoi poza.
            zdarzenie.preventDefault();
            zdarzenie.stopPropagation();

            if (panel.classList.contains('is-floating')) {
                zamknij();

                return;
            }

            zmierzNaglowek();
            zmierzPrzycisk();
            panel.hidden = false;
            panel.classList.add('is-floating');
            przycisk.setAttribute('aria-expanded', 'true');
        });

        // Ten sam panel otwarty z pasa menu wraca na swoje miejsce.
        if (przyciskPasa) {
            przyciskPasa.addEventListener('click', function () {
                panel.classList.remove('is-floating');
                przycisk.setAttribute('aria-expanded', 'false');
            });
        }

        document.addEventListener('click', function (zdarzenie) {
            if (!panel.contains(zdarzenie.target)) {
                zamknij();
            }
        });

        document.addEventListener('keydown', function (zdarzenie) {
            if (zdarzenie.key === 'Escape') {
                zamknij();
            }
        });

        /* Linia odcięcia zależy od wysokości nagłówka, a ta zmienia się razem
           z ustawieniem znaku firmowego i z progiem szerokości ekranu. Dlatego
           obserwator jest przestawiany, a nie zakładany raz na zawsze. */
        var obserwator = null;

        function pilnuj() {
            var wysokosc = zmierzNaglowek();

            if (obserwator) {
                obserwator.disconnect();
            }

            obserwator = new IntersectionObserver(function (wpisy) {
                var przyklejony = !wpisy[0].isIntersecting;

                if (naglowek.classList.contains('is-stuck') === przyklejony) {
                    return;
                }

                naglowek.classList.toggle('is-stuck', przyklejony);

                // Przejście w każdą stronę zamyka katalog: przycisk, spod którego
                // panel wyszedł, właśnie zniknął z ekranu. Panel zostałby otwarty
                // bez widocznego powodu, a przy powrocie zaczepiony w złym miejscu.
                zamknij();
            }, { rootMargin: '-' + wysokosc + 'px 0px 0px 0px', threshold: 0 });

            obserwator.observe(wartownik);
        }

        pilnuj();

        if (window.ResizeObserver) {
            new ResizeObserver(pilnuj).observe(naglowek);
        } else {
            window.addEventListener('resize', pilnuj);
        }
    });
})();
