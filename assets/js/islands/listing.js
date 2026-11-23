/**
 * Quince: strona z listą produktów.
 *
 * Cztery rzeczy, których nie da się zrobić samym HTML-em i CSS-em:
 *
 *  - ZAWĘŻANIE LISTY BEZ PRZEŁADOWANIA STRONY. Rdzeń robi tylko połowę roboty:
 *    `core.js` umie wysłać zapytanie po zdarzeniu `updateFacets` i rozgłasza
 *    wynik jako `updateProductList`, ale kto ma to zdarzenie nadać i co potem
 *    podmienić na stronie, wie wyłącznie motyw. Bez tego kliknięcie w pole
 *    wyboru filtra nie robi nic;
 *  - panel filtrów jedzie do szuflady na wąskim ekranie. Przeniesieniem węzła,
 *    a nie drugą kopią znaczników: dwie kopie tych samych pól wyboru znaczyłyby
 *    dwa różne stany zawężeń i dwa razy te same identyfikatory w kodzie strony.
 *    Tak samo robi to rdzeń PrestaShopa z `#_desktop_faceted`;
 *  - w wariancie „pas nad listą" przycisk filtrów rozwija panel zamiast
 *    otwierać szufladę;
 *  - przełącznik siatka/lista, którego wybór zostaje w przeglądarce klienta.
 *
 * Po zawężeniu listy podmieniane są kawałki strony, więc panel filtrów jest
 * wtedy nowym węzłem. Stąd ustawianie miejsca po każdej podmianie, a nie raz
 * przy wczytaniu strony.
 */
(function () {
    'use strict';

    var listing = document.querySelector('.q-listing');

    if (!listing) {
        return;
    }

    var PROG_WASKI = '(max-width: 991px)';
    var KLUCZ_WIDOKU = 'q-listing-view';

    var szuflada = document.getElementById('q-filters-drawer');
    var gniazdo = szuflada && szuflada.querySelector('[data-q-filters-host]');

    /** Gdzie panel filtrów stoi, gdy nie jest w szufladzie. */
    var dom = null;
    var kotwica = null;

    /** Czy pas filtrów nad listą jest rozwinięty. */
    var rozwiniety = false;

    function panel() {
        return listing.querySelector('.q-listing__filters')
            || (gniazdo && gniazdo.querySelector('.q-listing__filters'));
    }

    function wariant() {
        return listing.getAttribute('data-filters') || 'drawer';
    }

    function waski() {
        return window.matchMedia(PROG_WASKI).matches;
    }

    /**
     * Panel wjeżdża do szuflady na wąskim ekranie i wraca na swoje miejsce na
     * szerokim. Miejsce zapamiętujemy przy pierwszym przeniesieniu, bo po
     * powrocie musi stanąć tam, gdzie stał, a nie na końcu rodzica.
     */
    function ustawMiejsce() {
        var p = panel();

        if (!p || !gniazdo) {
            return;
        }

        if (waski() || wariant() === 'drawer') {
            if (p.parentElement !== gniazdo) {
                dom = p.parentElement;
                kotwica = p.nextElementSibling;
                gniazdo.appendChild(p);
            }

            return;
        }

        if (p.parentElement === gniazdo && dom) {
            dom.insertBefore(p, kotwica);
        }
    }

    function otworzSzuflade() {
        if (szuflada && typeof szuflada.showModal === 'function') {
            szuflada.showModal();
        }
    }

    listing.addEventListener('click', function (zdarzenie) {
        var cel = zdarzenie.target.closest('[data-q-filters-open], [data-q-view]');

        if (!cel) {
            return;
        }

        if (cel.hasAttribute('data-q-filters-open')) {
            /* W pasie nad listą przycisk rozwija panel w miejscu. Na wąskim
               ekranie pasa nie ma w żadnym wariancie, wtedy zawsze szuflada. */
            if (wariant() === 'bar' && !waski()) {
                var p = panel();

                if (p) {
                    rozwiniety = p.classList.toggle('is-open');
                    cel.setAttribute('aria-expanded', rozwiniety ? 'true' : 'false');
                }

                return;
            }

            otworzSzuflade();

            return;
        }

        ustawWidok(cel.getAttribute('data-q-view'));
    });

    if (szuflada) {
        szuflada.addEventListener('click', function (zdarzenie) {
            if (zdarzenie.target.closest('[data-q-filters-close]') || zdarzenie.target === szuflada) {
                szuflada.close();
            }
        });
    }

    /**
     * Siatka albo lista. Wybór zostaje u klienta, bo to jego nawyk czytania,
     * a nie ustawienie sklepu. Zapis w przeglądarce może być niedostępny
     * (w oknie prywatnym albo przy zablokowanych danych stron), więc widok ma
     * działać także wtedy, tylko bez pamiętania.
     */
    function ustawWidok(widok) {
        var siatka = listing.querySelector('.q-grid');

        if (!siatka) {
            return;
        }

        siatka.classList.toggle('q-grid--list', widok === 'list');

        listing.querySelectorAll('[data-q-view]').forEach(function (przycisk) {
            var aktywny = przycisk.getAttribute('data-q-view') === widok;

            przycisk.classList.toggle('is-active', aktywny);
            przycisk.setAttribute('aria-pressed', aktywny ? 'true' : 'false');
        });

        try {
            window.localStorage.setItem(KLUCZ_WIDOKU, widok);
        } catch (e) {
            /* zapis niedostępny: widok działa, tylko nie przeżyje odświeżenia */
        }
    }

    function przywrocWidok() {
        /* Sklep, który daje jeden widok, wymusza go: zapis z przeglądarki
           pochodzi wtedy z czasów, gdy widoki były dwa, i nie ma prawa go
           przykryć. */
        if (listing.getAttribute('data-views') !== 'both') {
            return;
        }

        var zapisany = null;

        try {
            zapisany = window.localStorage.getItem(KLUCZ_WIDOKU);
        } catch (e) {
            zapisany = null;
        }

        /* Brak zapisu znaczy, że ten klient jeszcze nie wybierał. Zostaje
           widok domyślny ustawiony przez sklep, który jest już w znacznikach.
           Zapis klienta przykrywa go w obie strony. */
        if (zapisany === 'list' || zapisany === 'grid') {
            ustawWidok(zapisany);
        }
    }

    /**
     * Rząd podkategorii: przycisk „Pokaż wszystkie" tylko wtedy, gdy kafelki
     * nie mieszczą się w jednym wierszu.
     *
     * Ile ich się mieści, czytamy z wyliczonego układu, a nie z własnego
     * rachunku: liczba kolumn zależy od progu ekranu i od tego, czy listing ma
     * kolumnę filtrów, a `grid-template-columns` zna już wynik. Przy jednym
     * wierszu przycisku nie ma wcale i nic nie jest przycinane.
     */
    function ustawPodkategorie() {
        listing.querySelectorAll('.q-subcats').forEach(function (rzad) {
            var wiecej = rzad.querySelector('[data-q-subcats-more]');

            if (!wiecej) {
                return;
            }

            var kolumny = window.getComputedStyle(rzad).gridTemplateColumns.split(' ').length;
            var kafelki = rzad.querySelectorAll('.q-subcats__item').length;

            /* Przycisk zabiera jedno pole, więc bez niego mieści się `kolumny`
               kafelków, a z nim o jeden mniej. */
            var mieszczaSie = kafelki <= kolumny;

            rzad.classList.toggle('is-whole', mieszczaSie);
            wiecej.hidden = mieszczaSie;

            if (mieszczaSie) {
                rzad.classList.remove('is-expanded');
                wiecej.textContent = wiecej.getAttribute('data-show');
            }
        });
    }

    /* Przełączanie rozwinięcia. */
    listing.addEventListener('click', function (zdarzenie) {
        var wiecej = zdarzenie.target.closest('[data-q-subcats-more]');

        if (!wiecej) {
            return;
        }

        var rzad = wiecej.closest('.q-subcats');

        if (!rzad) {
            return;
        }

        var rozwiniete = rzad.classList.toggle('is-expanded');

        wiecej.textContent = rozwiniete
            ? wiecej.getAttribute('data-hide')
            : wiecej.getAttribute('data-show');
    });

    /* --- zawężanie listy --- */

    /**
     * Adres zawężenia siedzi na polu wyboru, a nie na odnośniku: to pole zna
     * stan po kliknięciu, czyli zestaw zawężeń Z TYM filtrem albo BEZ niego.
     */
    function adresPola(el) {
        if (el.dataset.searchUrl !== undefined) {
            return el.dataset.searchUrl;
        }

        var rodzic = el.parentElement;

        return rodzic && rodzic.dataset.searchUrl !== undefined ? rodzic.dataset.searchUrl : null;
    }

    function zawez(adres) {
        if (adres && window.prestashop && typeof window.prestashop.emit === 'function') {
            window.prestashop.emit('updateFacets', adres);
        }
    }

    /**
     * Zakres w filtrach: dwa pola liczbowe zamiast suwaka.
     *
     * Adres składa się tak samo, jak składał go suwak modułu: do parametru `q`
     * dochodzi człon „nazwa-jednostka-od-do", oddzielony ukośnikiem od zawężeń,
     * które już tam stoją.
     */
    function adresZakresu(zakres, od, do_) {
        var czesci = (zakres.getAttribute('data-slider-encoded-url') || '').split('?');
        var parametry = new URLSearchParams(czesci[1] || '');
        var juz = parametry.get('q') || '';

        var czlon = [
            zakres.getAttribute('data-slider-label'),
            zakres.getAttribute('data-slider-unit'),
            od,
            do_
        ].join('-');

        parametry.set('q', juz ? juz + '/' + czlon : czlon);

        return czesci[0] + '?' + parametry.toString();
    }

    function zawezZakresem(pole) {
        var zakres = pole.closest('[data-q-range]');

        if (!zakres) {
            return;
        }

        var min = Number(zakres.getAttribute('data-slider-min'));
        var max = Number(zakres.getAttribute('data-slider-max'));
        var polaOd = zakres.querySelector('[data-q-range-from]');
        var polaDo = zakres.querySelector('[data-q-range-to]');

        /* Puste pole znaczy „bez ograniczenia z tej strony", czyli kraniec
           zakresu. Wpisana liczba spoza zakresu nie ma czego zawęzić, więc
           wraca do krańca zamiast dawać pustą listę. */
        var od = polaOd.value === '' ? min : Math.min(max, Math.max(min, Number(polaOd.value)));
        var do_ = polaDo.value === '' ? max : Math.min(max, Math.max(min, Number(polaDo.value)));

        if (od > do_) {
            var bufor = od;
            od = do_;
            do_ = bufor;
        }

        polaOd.value = od;
        polaDo.value = do_;

        zawez(adresZakresu(zakres, od, do_));
    }

    /**
     * Czy właśnie wciskane jest inne zawężenie.
     *
     * Pole zakresu oddaje swoją wartość, gdy traci ognisko, a traci je także
     * wtedy, gdy klient klika obok: w pole wyboru albo w „Wyczyść wszystko".
     * Bez tego kliknięcie w czyszczenie najpierw kasuje zawężenia, a zaraz
     * potem pole zakresu zakłada nowe z liczbą, którą klient właśnie porzucił.
     *
     * `pointerdown` wyprzedza i zmianę ogniska, i kliknięcie, więc w chwili
     * oddawania wartości wiadomo już, że klient sięgnął po co innego.
     */
    var wciskane = 0;

    document.addEventListener('pointerdown', function (zdarzenie) {
        var cel = zdarzenie.target.closest(
            '.js-search-filters-clear-all, .js-search-link, input[data-search-url]'
        );

        wciskane = cel ? Date.now() : 0;
    }, true);

    /* Nasłuch na dokumencie, a nie na panelu: panel bywa przenoszony do
       szuflady i podmieniany po każdym zawężeniu, więc nasłuch podpięty do
       niego przepadałby przy pierwszej zmianie. */
    document.addEventListener('change', function (zdarzenie) {
        var wZakresie = zdarzenie.target.closest('[data-q-range] input');

        if (wZakresie) {
            if (wciskane && Date.now() - wciskane < 500) {
                return;
            }

            zawezZakresem(wZakresie);

            return;
        }

        var pole = zdarzenie.target.closest('input[data-search-url]');

        if (pole) {
            zawez(adresPola(pole));
        }
    });

    document.addEventListener('click', function (zdarzenie) {
        var czysc = zdarzenie.target.closest('.js-search-filters-clear-all');

        if (czysc) {
            zdarzenie.preventDefault();
            zawez(adresPola(czysc));

            return;
        }

        /* Odnośnik przy nazwie filtra i krzyżyk przy pigułce. Bez JavaScriptu
           są zwykłymi przejściami między stronami i tak mają zostać, więc
           przejście wstrzymujemy dopiero tutaj. */
        var link = zdarzenie.target.closest('.js-search-link');

        if (link) {
            zdarzenie.preventDefault();
            zawez(link.href);
        }
    });

    /* „Pokaż więcej” pod długą grupą filtra. Panel filtrów przychodzi po każdym
       zawężeniu jako nowy znacznik, zwinięty, więc rozwinięte grupy pamiętamy
       po nazwie i rozwijamy je znowu. Inaczej klient, który właśnie zaznaczył
       wartość z dalszej części listy, traciłby jej sąsiadów z oczu. */
    var rozwinieteGrupy = {};

    function rozwinGrupe(przycisk, rozwin) {
        var cialo = przycisk.parentNode;
        var grupa = przycisk.closest('[data-name]');

        cialo.classList.toggle('is-expanded', rozwin);
        przycisk.setAttribute('aria-expanded', rozwin ? 'true' : 'false');
        przycisk.querySelector('[data-q-filter-more-show]').hidden = rozwin;
        przycisk.querySelector('[data-q-filter-more-hide]').hidden = !rozwin;

        if (grupa) {
            rozwinieteGrupy[grupa.getAttribute('data-name')] = rozwin;
        }
    }

    function przywrocRozwiniete() {
        document.querySelectorAll('[data-q-filter-more]').forEach(function (przycisk) {
            var grupa = przycisk.closest('[data-name]');

            if (grupa && rozwinieteGrupy[grupa.getAttribute('data-name')]) {
                rozwinGrupe(przycisk, true);
            }
        });
    }

    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-q-filter-more]');

        if (przycisk) {
            rozwinGrupe(przycisk, przycisk.getAttribute('aria-expanded') !== 'true');
        }
    });

    /**
     * Podmiana kawałka strony gotowym znacznikiem z odpowiedzi.
     */
    function zamien(wybor, znaczniki) {
        var stary = document.querySelector(wybor);

        if (!stary || typeof znaczniki !== 'string') {
            return;
        }

        var kosz = document.createElement('div');
        kosz.innerHTML = znaczniki;

        var nowy = kosz.firstElementChild;

        if (nowy) {
            stary.parentNode.replaceChild(nowy, stary);
        }
    }

    /**
     * Liczba wyników na przycisku zamykającym szufladę. Szuflada stoi poza
     * kawałkami strony, które przychodzą po zawężeniu, więc liczbę trzeba w niej
     * przestawić samemu. Skrypt nie zna napisu w żadnym języku, zna tylko
     * liczbę, którą ma w nim znaleźć.
     */
    function przestawLiczbeWSzufladzie(ile) {
        var przycisk = szuflada && szuflada.querySelector('[data-q-total]');

        if (!przycisk || typeof ile !== 'number') {
            return;
        }

        przycisk.textContent = przycisk.textContent.replace(przycisk.dataset.qTotal, String(ile));
        przycisk.dataset.qTotal = String(ile);
    }

    /**
     * Po podmianie belki panel filtrów bywa w kodzie strony dwa razy: jeden
     * przeniesiony wcześniej do szuflady, drugi świeżo przysłany w belce.
     * Zostaje świeży, bo tylko on zna nowe liczby przy zawężeniach.
     */
    function jedenPanel() {
        if (!gniazdo) {
            return;
        }

        var wTresci = listing.querySelector('.q-listing__filters');
        var wSzufladzie = gniazdo.querySelector('.q-listing__filters');

        if (wTresci && wSzufladzie) {
            wSzufladzie.remove();
        }
    }

    ustawMiejsce();
    przywrocWidok();
    ustawPodkategorie();

    window.addEventListener('resize', function () {
        ustawMiejsce();
        ustawPodkategorie();
    });

    /* --- dokładanie produktów przyciskiem --- */

    /**
     * Drugi rodzaj stronicowania: zamiast przejść na kolejną stronę dokładamy
     * jej produkty do tej samej listy.
     *
     * Odpowiedź przychodzi tą samą drogą co przy zawężaniu, czyli jako gotowe
     * kawałki strony. Bierzemy z niej SAME zajawki i dopisujemy je na koniec
     * siatki, bo podmiana całej siatki skasowałaby to, co klient już dołożył.
     */
    function dolozPorcje(odnosnik) {
        if (odnosnik.dataset.loading === 'true'
            || odnosnik.getAttribute('aria-disabled') === 'true'
            || !odnosnik.getAttribute('href')) {
            return;
        }

        odnosnik.dataset.loading = 'true';

        var widoczny = new URL(odnosnik.getAttribute('href'), window.location.href);
        var adres = new URL(widoczny.toString());
        adres.searchParams.set('from-xhr', '1');

        /* Rdzeń rozpoznaje żądanie AJAX po nagłówku `Accept` (Controller::isAjax),
           a nie po `X-Requested-With`. Bez niego odsyła całą stronę w HTML-u. */
        fetch(adres.toString(), { headers: { Accept: 'application/json' } })
            .then(function (odpowiedz) { return odpowiedz.json(); })
            .then(function (dane) {
                var siatka = listing.querySelector('.q-grid');
                var kosz = document.createElement('div');
                kosz.innerHTML = dane.rendered_products || '';

                var nowa = kosz.querySelector('.q-grid');

                if (siatka && nowa) {
                    while (nowa.firstElementChild) {
                        siatka.appendChild(nowa.firstElementChild);
                    }

                    /* Dołożone zajawki przychodzą bez podpiętych wysp: szybki
                       podgląd, serce, licznik promocji. Zawężanie filtrami
                       podpina je przez zdarzenie `updatedProductList`, a to
                       dołożenie go nie wysyła. `hydrate` pomija zajawki już
                       obsłużone, więc pierwsze nie dostają zdarzeń drugi raz. */
                    if (window.Quince && typeof window.Quince.hydrate === 'function') {
                        window.Quince.hydrate(siatka);
                    }
                }

                /* Przycisk stoi w strefie pod listą, a ta nie wraca w odpowiedzi:
                   rdzeń odsyła tylko belkę, siatkę i pasek pod nią. Adres kolejnej
                   porcji i licznik przestawiamy więc sami, z danych stronicowania. */
                odswiezDokladanie(dane);

                /* Numer dołożonej porcji w adresie: odświeżenie strony i skopiowany
                   odnośnik mają prowadzić tam, gdzie klient skończył czytać.
                   `replaceState`, a nie `pushState`: wszystkie porcje to ta sama
                   lista, więc „wstecz" ma wrócić tam, skąd klient na nią wszedł,
                   a nie przewijać porcje po jednej. */
                window.history.replaceState({ current_url: widoczny.toString() },
                    document.title, widoczny.toString());
            })
            .catch(function () {
                odnosnik.dataset.loading = 'false';
            });
    }

    /**
     * Stan przycisku po każdej zmianie listy: po doładowaniu porcji i po
     * zawężeniu filtrami.
     *
     * Odpowiedź rdzenia nie zawiera listy stron. Ma tylko numer bieżącej,
     * liczbę wszystkich i zakres pokazanych pozycji. Adres kolejnej porcji
     * składamy więc z adresu listy, a nie z gotowego odnośnika.
     *
     * Przycisk stoi w strefie pod listą, którą sklep może przestawić, więc
     * szukamy go w całym listingu, a nie w jednym pojemniku.
     */
    function odswiezDokladanie(dane) {
        var blok = listing.querySelector('[data-q-more]');

        if (!blok || !dane || !dane.pagination) {
            return;
        }

        var stan = dane.pagination;
        var odnosnik = blok.querySelector('[data-q-more-link]');
        var licznik = blok.querySelector('[data-q-more-count]');

        /* Zawężenie potrafi zejść do jednej strony i wrócić z powrotem do kilku,
           a strefa pod listą nie wraca w odpowiedzi, więc chowamy węzeł,
           zamiast go usuwać. */
        blok.hidden = stan.pages_count <= 1;

        var koniec = stan.current_page >= stan.pages_count;

        if (licznik) {
            var zdanie = koniec ? licznik.dataset.tplEnd : licznik.dataset.tpl;

            if (zdanie) {
                licznik.textContent = zdanie
                    .replace('%shown%', String(stan.items_shown_to))
                    .replace('%total%', String(stan.total_items));
            }
        }

        if (!odnosnik) {
            return;
        }

        odnosnik.dataset.loading = 'false';

        /* Na końcu listy przycisk zostaje widoczny, ale wyłączony: zniknięcie
           nie mówi klientowi, czy lista się skończyła, czy coś poszło nie tak. */
        if (koniec) {
            odnosnik.setAttribute('aria-disabled', 'true');
            odnosnik.removeAttribute('href');
            odnosnik.removeAttribute('rel');

            return;
        }

        odnosnik.removeAttribute('aria-disabled');
        odnosnik.setAttribute('rel', 'next');

        var adres = new URL(dane.current_url || window.location.href, window.location.origin);
        adres.searchParams.delete('from-xhr');
        adres.searchParams.delete('ajax');
        adres.searchParams.set('page', String(stan.current_page + 1));
        odnosnik.href = adres.toString();
    }

    listing.addEventListener('click', function (zdarzenie) {
        var odnosnik = zdarzenie.target.closest('[data-q-more-link]');

        if (!odnosnik) {
            return;
        }

        zdarzenie.preventDefault();
        dolozPorcje(odnosnik);
    });

    /* Cofnięcie w przeglądarce. Rdzeń zapisuje adres każdego zawężenia
       w historii, ale wczytać go z powrotem musi motyw. */
    window.addEventListener('popstate', function (zdarzenie) {
        if (zdarzenie.state && zdarzenie.state.current_url) {
            window.location.href = zdarzenie.state.current_url;
        }
    });

    /* Zawężona lista wraca gotowymi kawałkami strony. Panel filtrów i siatka są
       wtedy nowymi węzłami, więc miejsce panelu i wybrany widok trzeba ustawić
       jeszcze raz. */
    if (window.prestashop && typeof window.prestashop.on === 'function') {
        window.prestashop.on('updateProductList', function (dane) {
            if (!dane) {
                return;
            }

            zamien('#js-product-list-top', dane.rendered_products_top);
            zamien('#js-product-list', dane.rendered_products);
            zamien('#js-product-list-bottom', dane.rendered_products_bottom);

            /* Panel i pigułki stoją w belce tylko w części wariantów, w reszcie
               są poza nią i trzeba je podmienić osobno. */
            zamien('#search-filters', dane.rendered_facets);
            zamien('#js-active-search-filters', dane.rendered_active_filters);
            przywrocRozwiniete();

            jedenPanel();
            przestawLiczbeWSzufladzie(dane.pagination && dane.pagination.total_items);
            odswiezDokladanie(dane);

            /* Pas nad listą przychodzi z serwera zwinięty, bo o rozwinięciu
               wie tylko przeglądarka. Zamykanie go po każdym zaznaczonym
               zawężeniu kazałoby otwierać panel od nowa przy każdym kolejnym. */
            if (rozwiniety) {
                var pas = panel();

                if (pas) {
                    pas.classList.add('is-open');
                }

                listing.querySelectorAll('[data-q-filters-open]').forEach(function (przycisk) {
                    przycisk.setAttribute('aria-expanded', 'true');
                });
            }

            dom = null;
            kotwica = null;
            ustawMiejsce();
            przywrocWidok();
            ustawPodkategorie();
        });
    }
}());
