/**
 * Quince: galeria produktu
 *
 * Przełączanie zdjęcia miniaturą i kropką, licznik, zanik na krawędziach pasa
 * miniatur oraz podgląd na wierzchu ze strzałkami, podpisem i własnym paskiem
 * miniatur.
 *
 * Bez tej wyspy strona pokazuje pierwsze zdjęcie i komplet miniatur, więc
 * produkt da się obejrzeć, tylko bez przełączania.
 *
 * Projekt: makieta strony produktu.
 */
(function () {
    'use strict';

    Quince.register('[data-q-gallery]', function (galeria) {
        var kadr = galeria.querySelector('[data-q-frame]');
        var zdjecie = galeria.querySelector('[data-q-photo]');
        var licznik = galeria.querySelector('[data-q-counter]');
        var pas = galeria.querySelector('.q-gallery__thumbs');
        var miniatury = [].slice.call(galeria.querySelectorAll('[data-q-thumbnail]'));
        var kropki = [].slice.call(galeria.querySelectorAll('[data-q-dot]'));

        if (!zdjecie || !kadr) {
            return;
        }

        var teraz = 0;

        /* Zanik przy tej krawędzi, za którą została jeszcze miniatura. Zapas 2 px,
           bo przewijanie bywa ułamkowe i porównanie na styk migotałoby. */
        function odswiezZanik() {
            if (!pas) {
                return;
            }

            var zapas = pas.scrollWidth - pas.clientWidth;

            pas.classList.toggle('has-left', pas.scrollLeft > 2);
            pas.classList.toggle('has-right', zapas > 2 && pas.scrollLeft < zapas - 2);
        }

        if (pas) {
            pas.addEventListener('scroll', odswiezZanik, { passive: true });
            window.addEventListener('resize', odswiezZanik);
            odswiezZanik();
        }

        function zaznacz(grupa, numer) {
            grupa.forEach(function (element, i) {
                var wybrany = i === numer;

                element.classList.toggle('is-active', wybrany);

                if (wybrany) {
                    element.setAttribute('aria-current', 'true');
                } else {
                    element.removeAttribute('aria-current');
                }
            });
        }

        /* -- filmy --
           Film jest kolejna pozycja tego samego pasa miniatur, a nie osobnym
           mechanizmem: klient przechodzi miedzy zdjeciem a filmem jednym
           klknieciem, tak samo jak miedzy zdjeciami. */

        var panelWideo = galeria.querySelector('[data-q-video]');
        var poster = galeria.querySelector('[data-q-poster]');
        var gniazdo = galeria.querySelector('[data-q-slot]');
        var przyciskGraj = galeria.querySelector('[data-q-play]');
        var powieksz = galeria.querySelector('[data-q-zoom]');
        var wybranyFilm = null;

        function czyFilm(mini) {
            return mini.getAttribute('data-q-type') === 'video';
        }

        /**
         * Plakat Vimeo. YouTube oddaje obrazek wprost z identyfikatora, Vimeo
         * dopiero po pytaniu, wiec pytamy raz i tylko wtedy, gdy taki film jest
         * w galerii. Brak odpowiedzi zostawia sam przycisk odtwarzania.
         */
        function dociagnijPlakat(mini) {
            if (mini.getAttribute('data-q-provider') !== 'vimeo' || mini.dataset.qFetched) {
                return;
            }

            mini.dataset.qFetched = '1';

            fetch('https://vimeo.com/api/oembed.json?url=' + encodeURIComponent(mini.getAttribute('data-q-url')))
                .then(function (o) { return o.ok ? o.json() : null; })
                .then(function (dane) {
                    if (!dane || !dane.thumbnail_url) {
                        return;
                    }

                    mini.setAttribute('data-q-poster', dane.thumbnail_url);

                    var obraz = mini.querySelector('img');
                    if (!obraz) {
                        obraz = document.createElement('img');
                        obraz.loading = 'lazy';
                        obraz.alt = '';
                        mini.insertBefore(obraz, mini.firstChild);
                    }
                    obraz.src = dane.thumbnail_url;

                    if (wybranyFilm === mini && poster) {
                        poster.src = dane.thumbnail_url;
                    }
                })
                .catch(function () { /* brak plakatu nie psuje odtwarzania */ });
        }

        /**
         * Wstawia ramke dostawcy.
         *
         * Ramka lezy gotowa w szablonie, bo modul zgod przepisuje adresy ramek
         * w kodzie strony: zbudowana dopiero tutaj ominelaby decyzje
         * odwiedzajacego. Gdy jest zablokowana, pytamy modul zgod i czekamy na
         * odpowiedz, zamiast pokazywac pusta ramke.
         */
        function wstawRamke(numer, doGniazda, panel) {
            if (!doGniazda) {
                return;
            }

            var wzor = galeria.querySelector('[data-q-video-frame="' + numer + '"]');
            if (!wzor) {
                return;
            }

            var ramka = wzor.content.firstElementChild.cloneNode(true);
            var kod = ramka.getAttribute('data-qc-code');
            var zgody = window.QuinceCMP;

            function pokazRamke() {
                doGniazda.innerHTML = '';

                if (ramka.hasAttribute('data-qc-src')) {
                    ramka.setAttribute('src', ramka.getAttribute('data-qc-src'));
                    ramka.removeAttribute('data-qc-src');
                }

                doGniazda.appendChild(ramka);

                if (panel) {
                    panel.classList.add('is-playing');
                }
            }

            if (!kod || !zgody || zgody.allowed(kod)) {
                pokazRamke();

                return;
            }

            zgody.whenAllowed(kod, pokazRamke);
            zgody.open();
        }

        function pokazFilm(mini) {
            wybranyFilm = mini;

            if (panelWideo) {
                panelWideo.hidden = false;
                panelWideo.classList.remove('is-playing');
            }

            if (gniazdo) {
                gniazdo.innerHTML = '';
            }

            if (poster) {
                poster.src = mini.getAttribute('data-q-poster') || '';
                poster.hidden = poster.src === '';
            }

            dociagnijPlakat(mini);

            zdjecie.hidden = true;
            galeria.classList.add('is-video');
        }

        function schowajFilm() {
            wybranyFilm = null;

            if (panelWideo) {
                panelWideo.hidden = true;
                panelWideo.classList.remove('is-playing');
            }

            if (gniazdo) {
                gniazdo.innerHTML = '';
            }

            zdjecie.hidden = false;
            galeria.classList.remove('is-video');
        }

        if (przyciskGraj) {
            przyciskGraj.addEventListener('click', function () {
                if (wybranyFilm) {
                    wstawRamke(wybranyFilm.getAttribute('data-q-film'), gniazdo, panelWideo);
                }
            });
        }

        function pokaz(numer) {
            if (!miniatury.length) {
                return;
            }

            teraz = (numer + miniatury.length) % miniatury.length;

            var mini = miniatury[teraz];

            zaznacz(miniatury, teraz);
            zaznacz(kropki, teraz);

            if (czyFilm(mini)) {
                pokazFilm(mini);
            } else {
                schowajFilm();

                zdjecie.setAttribute('src', mini.getAttribute('data-q-large'));
                zdjecie.setAttribute('width', mini.getAttribute('data-q-width'));
                zdjecie.setAttribute('height', mini.getAttribute('data-q-height'));
                zdjecie.setAttribute('alt', mini.getAttribute('data-q-caption') || '');
            }

            if (licznik) {
                // Licznik obejmuje wszystko, co jest w pasie: zdjęcia i filmy.
                // Osobne liczenie zdjęć dałoby „1 / 1" przy jednym zdjęciu
                // i jednym filmie, czyli mówiło, że nie ma nic dalej.
                licznik.textContent = (teraz + 1) + ' / ' + miniatury.length;
            }
        }

        // Film pierwszy w pasie: pokazujemy go od razu, tak jak pierwsze zdjecie.
        if (miniatury.length && czyFilm(miniatury[0])) {
            pokaz(0);
        }

        miniatury.forEach(function (mini, i) {
            mini.addEventListener('click', function () {
                pokaz(i);
            });
        });

        kropki.forEach(function (kropka, i) {
            kropka.addEventListener('click', function () {
                pokaz(i);
            });
        });

        /* ── podgląd na wierzchu ── */

        var podglad = document.querySelector('[data-q-lightbox]');

        if (!podglad || typeof podglad.showModal !== 'function') {
            return;
        }

        var duze = podglad.querySelector('[data-q-lightbox-img]');
        var podpis = podglad.querySelector('[data-q-lightbox-caption]');
        var pasekMini = podglad.querySelector('[data-q-lightbox-thumbs]');
        var wPodgladzie = 0;

        /* Spis zdjęć dla podglądu.

           Nie bierzemy go wprost z miniatur, bo miniatur bywa ZERO: PrestaShop
           pokazuje w galerii tylko zdjęcia przypisane do wybranego wariantu,
           a przy jednym zdjęciu na wariant pas miniatur w ogóle nie powstaje.
           Podgląd czytałby wtedy adres z niczego i otwierał się pusty: bez
           zdjęcia, bez miniatur i bez podpisu.

           Kadr istnieje zawsze, więc przy braku miniatur spis ma jedną pozycję
           zbudowaną z niego. */
        var zdjecia = miniatury.length
            ? miniatury.map(function (mini) {
                var mala = mini.querySelector('img');

                return {
                    duze: mini.getAttribute('data-q-large'),
                    podpis: (mini.getAttribute('data-q-caption') || '').trim(),
                    mala: mala ? mala.getAttribute('src') : '',

                    // Film idzie do podglądu tak samo jak zdjęcie: bez tego
                    // miniatura filmu w pasku podglądu prowadziłaby do pustego
                    // obrazka z nazwą produktu zamiast do filmu.
                    film: czyFilm(mini) ? mini.getAttribute('data-q-film') : null,
                    plakat: mini.getAttribute('data-q-poster') || '',
                };
            })
            : [{
                duze: zdjecie.getAttribute('src'),
                podpis: (zdjecie.getAttribute('alt') || '').trim(),
                mala: zdjecie.getAttribute('src'),
            }];

        /* Pasek miniatur i strzałki mają sens dopiero od dwóch zdjęć. Przy jednym
           zostaje samo zdjęcie. Strzałka wracająca do tego samego kadru jest
           obietnicą, że jest coś dalej. */
        var jestCoPrzelaczac = zdjecia.length > 1;

        if (pasekMini) {
            pasekMini.hidden = !jestCoPrzelaczac;
        }

        /* Miniatury podglądu budujemy ZE SPISU, a nie wpisujemy drugi raz
           w szablon. Jedno źródło prawdy: dziesiąte zdjęcie doda się w obu
           miejscach naraz. */
        zdjecia.forEach(function (dane, i) {
            var przycisk = document.createElement('button');

            przycisk.type = 'button';
            przycisk.className = 'q-lightbox__thumb';
            przycisk.setAttribute('aria-label', miniatury[i] ? (miniatury[i].getAttribute('aria-label') || '') : '');

            var obraz = document.createElement('img');

            obraz.src = dane.mala;
            obraz.alt = '';
            obraz.loading = 'lazy';

            przycisk.appendChild(obraz);
            przycisk.addEventListener('click', function () {
                pokazWPodgladzie(i);
            });

            pasekMini.appendChild(przycisk);
        });

        var miniPodgladu = [].slice.call(pasekMini.querySelectorAll('.q-lightbox__thumb'));
        var panelPodgladu = podglad.querySelector('[data-q-lightbox-video]');
        var plakatPodgladu = podglad.querySelector('[data-q-lightbox-poster]');
        var gniazdoPodgladu = podglad.querySelector('[data-q-lightbox-slot]');
        var grajPodgladu = podglad.querySelector('[data-q-lightbox-play]');

        if (grajPodgladu) {
            grajPodgladu.addEventListener('click', function () {
                var dane = zdjecia[wPodgladzie];

                if (dane && dane.film !== null && dane.film !== undefined) {
                    wstawRamke(dane.film, gniazdoPodgladu, panelPodgladu);
                }
            });
        }

        function pokazWPodgladzie(numer) {
            if (!zdjecia.length) {
                return;
            }

            wPodgladzie = (numer + zdjecia.length) % zdjecia.length;

            var dane = zdjecia[wPodgladzie];
            var opis = dane.podpis;

            if (panelPodgladu) {
                var toFilm = dane.film !== null && dane.film !== undefined;

                panelPodgladu.hidden = !toFilm;
                panelPodgladu.classList.remove('is-playing');
                duze.hidden = toFilm;

                if (gniazdoPodgladu) {
                    gniazdoPodgladu.innerHTML = '';
                }

                if (toFilm) {
                    if (plakatPodgladu) {
                        plakatPodgladu.src = dane.plakat;
                    }

                    zaznacz(miniPodgladu, wPodgladzie);

                    // Film też dostaje podpis: bez niego wiersz podpisu zapada
                    // się przy przejściu ze zdjęcia na film i strzałki po bokach
                    // przesuwają się o jego wysokość.
                    if (podpis) {
                        podpis.textContent = miniatury[wPodgladzie]
                            ? (miniatury[wPodgladzie].getAttribute('aria-label') || '')
                            : '';
                        podpis.hidden = false;
                    }

                    return;
                }
            }

            duze.setAttribute('src', dane.duze);

            // Bez podpisu zostaje nazwa produktu z kadru: pusty `alt` przy
            // zdjęciu, które jest jedyną treścią okna, nie mówi nic.
            duze.setAttribute('alt', opis || (zdjecie.getAttribute('alt') || ''));

            // Pusty podpis chowa wiersz zamiast zostawiać po nim puste miejsce:
            // w większości sklepów pole `legend` jest nieuzupełnione.
            if (podpis) {
                podpis.textContent = opis;
                podpis.hidden = opis === '';
            }

            zaznacz(miniPodgladu, wPodgladzie);
        }

        function otworzPodglad() {
            // Okno ma się otworzyć zawsze, nawet puste, gdy coś w wypełnianiu
            // go zawiedzie. Ciche „nic się nie dzieje" po kliknięciu jest
            // gorsze niż podgląd bez zdjęcia.
            try {
                pokazWPodgladzie(teraz);
            } catch (e) {
                if (window.console) {
                    console.error('[Quince] podgląd galerii:', e);
                }
            }

            podglad.showModal();
        }

        kadr.addEventListener('click', function () {
            // Przy filmie kadr nie prowadzi do podglądu: kliknięcie w obraz ma
            // włączyć film, a nie otworzyć okno; inaczej jedno z drugim wychodzi
            // naraz. Do okna prowadzi wtedy lupa, tak samo jak przy zdjęciu.
            if (galeria.classList.contains('is-video')) {
                return;
            }

            otworzPodglad();
        });

        if (powieksz) {
            powieksz.addEventListener('click', function (zdarzenie) {
                // Lupa działa też na filmie, a jej kliknięcie nie może wracać
                // do kadru: tam przy filmie nic się nie dzieje.
                zdarzenie.stopPropagation();
                otworzPodglad();
            });
        }

        /* Strzałki chowamy przy jednym zdjęciu: obrót po jednoelementowej liście
           wraca do tego samego kadru i wygląda jak zepsute przejście. */
        [].forEach.call(podglad.querySelectorAll('[data-q-lightbox-prev], [data-q-lightbox-next]'),
            function (strzalka) {
                strzalka.hidden = !jestCoPrzelaczac;
            });

        podglad.querySelector('[data-q-lightbox-prev]').addEventListener('click', function () {
            pokazWPodgladzie(wPodgladzie - 1);
        });

        podglad.querySelector('[data-q-lightbox-next]').addEventListener('click', function () {
            pokazWPodgladzie(wPodgladzie + 1);
        });

        podglad.addEventListener('close', function () {
            // Zamknięte okno nie może grać dalej w tle.
            if (gniazdoPodgladu) {
                gniazdoPodgladu.innerHTML = '';
            }

            if (panelPodgladu) {
                panelPodgladu.classList.remove('is-playing');
            }
        });

        podglad.querySelector('[data-q-lightbox-close]').addEventListener('click', function () {
            podglad.close();
        });

        podglad.addEventListener('keydown', function (zdarzenie) {
            if (zdarzenie.key === 'ArrowLeft') {
                pokazWPodgladzie(wPodgladzie - 1);
            }

            if (zdarzenie.key === 'ArrowRight') {
                pokazWPodgladzie(wPodgladzie + 1);
            }
        });

        // Kliknięcie w tło zamyka podgląd. `<dialog>` nie rozróżnia tła od treści,
        // więc sprawdzamy, czy punkt kliknięcia leży poza prostokątem okna.
        podglad.addEventListener('click', function (zdarzenie) {
            var r = podglad.getBoundingClientRect();

            if (zdarzenie.clientX < r.left || zdarzenie.clientX > r.right
                || zdarzenie.clientY < r.top || zdarzenie.clientY > r.bottom) {
                podglad.close();
            }
        });
    });
})();
