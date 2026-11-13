/**
 * Quince: panel zakupu na karcie produktu.
 *
 * Cztery drobne zachowania, których PrestaShop nie przynosi sam:
 *   licznik ilości (rdzeń zostawia to motywowi),
 *   szuflada z tabelą progów ilościowych,
 *   podpis pola wgrywania pliku w personalizacji,
 *   „Kup teraz", czyli dodanie do koszyka i przejście prosto do zamówienia.
 *
 * Bez tego pliku panel nadal działa: ilość da się wpisać z klawiatury, progi
 * zostają w treści strony, plik wybiera się tym samym polem, a „Kup teraz"
 * kończy się jak zwykłe dodanie do koszyka.
 *
 * Nasłuchy stoją na panelu, a nie na pojedynczych przyciskach: PrestaShop po
 * zmianie wariantu podmienia w panelu całe bloki, a podmieniony przycisk nie
 * miałby własnego nasłuchu.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    Quince.register('.q-buy', function (panel) {
        licznik(panel);
        progi(panel);
        wgrywanie(panel);
        kupTeraz(panel);
        skladniki(panel);
    });

    Quince.register('.q-pdp__aside', przyklejenie);
    Quince.register('[data-q-mobilebar]', pasekTelefonu);
    Quince.register('[data-q-bundles]', zestawy);

    /**
     * Sekcja zestawów pod kartą: „Kup zestaw teraz".
     *
     * Licznikiem promocji zestawu zajmuje się wyspa zegara, ta sama co przy
     * pasie nad panelem zakupu i przy kafelku produktu.
     */
    function zestawy(sekcja) {
        kupTeraz(sekcja);
    }

    /**
     * Pasek zakupu na telefonie i warstwa z panelem.
     *
     * Pasek jest wtedy, kiedy panelu zakupu NIE WIDAĆ: i przed dojechaniem do
     * niego, i po minięciu. Gdy panel jest na ekranie, pasek powtarzałby to,
     * na co klient właśnie patrzy.
     *
     * Stan liczymy z położenia, a nie z obserwatora przecięcia: przy skoku
     * (odnośnik kotwicy, wznowienie pozycji po odświeżeniu, przewinięcie gestem
     * do końca) panel przechodzi spod dolnej krawędzi nad górną ani razu nie
     * będąc widocznym i zdarzenie przecięcia wtedy nie pada.
     *
     * Warstwa panelu nie kopiuje: POŻYCZA go na czas otwarcia i oddaje przy
     * zamknięciu. Dwie kopie znaczyłyby dwa niezależne stany: wybrany wariant,
     * wpisana personalizacja i ustawiona ilość rozjechałyby się między stroną
     * a warstwą. Przenoszony węzeł jest fizycznie ten sam, więc nie ma czego
     * uzgadniać.
     */
    function pasekTelefonu(pasek) {
        var kolumna = document.querySelector('.q-pdp__aside');
        var panel = kolumna && kolumna.querySelector('.q-buy');

        if (!panel) {
            return;
        }

        // Kotwicą jest BLOK CENY, nie przycisk zakupu: pasek niesie kwotę, więc
        // z chwilą, gdy klient widzi cenę na stronie, pasek powtarza to, na co
        // patrzy. Mierzenie przycisku trzymałoby pasek na ekranie przez całą
        // wysokość panelu, z kwotą tuż nad kwotą.
        var kotwica = panel.querySelector('.q-buy__slot--price') || panel;
        var czeka = false;

        function sprawdz() {
            czeka = false;

            // Przy otwartej warstwie panel jest w niej, więc kotwica ma zerowy
            // obrys. Traktujemy to jak „nie widać" i pasek zostaje pod spodem,
            // gotowy na moment zamknięcia.
            var p = kotwica.getBoundingClientRect();
            var naEkranie = p.height > 0 && p.bottom > 0 && p.top < window.innerHeight;

            pasek.classList.toggle('is-shown', !naEkranie);

            // Wysokość oddawana stronie jako dolne dopełnienie. Mierzona, bo
            // zależy od kroju pisma, długości kwoty i zawinięcia napisu.
            document.documentElement.style.setProperty(
                '--q-mobilebar-h',
                Math.round(pasek.getBoundingClientRect().height) + 'px'
            );
        }

        var warstwa = document.querySelector('[data-q-sheet]');
        var gniazdo = warstwa && warstwa.querySelector('[data-q-sheet-body]');

        function doWarstwy() {
            if (!warstwa || !gniazdo || typeof warstwa.showModal !== 'function') {
                return;
            }

            // Kolumna oddaje panel, ale NIE oddaje miejsca. Bez tego strona
            // skraca się o wysokość panelu w chwili otwarcia: przeglądarka
            // trzyma pozycję przewinięcia, a treść pod nią jedzie w górę
            // i klient po zamknięciu ląduje w innym miejscu, niż czytał.
            kolumna.style.blockSize = kolumna.getBoundingClientRect().height + 'px';
            kolumna.dataset.pozyczony = '';

            ustawPoczatek();
            gniazdo.appendChild(panel);
            warstwa.showModal();
        }

        // Ile paska widać nad dolną krawędzią ekranu: przy wysuniętym cały
        // pasek, przy schowanym samo koło. Warstwa rusza z tej wysokości
        // i do niej wraca, więc jej koło ląduje dokładnie na kole paska.
        // Mierzone w chwili ruchu, bo pasek sam zmienia stan przy przewijaniu.
        function ustawPoczatek() {
            var widac = Math.max(0, window.innerHeight - pasek.getBoundingClientRect().top);

            warstwa.style.setProperty('--q-sheet-start', Math.round(widac) + 'px');
        }

        function zwin() {
            ustawPoczatek();
            warstwa.close();
        }

        function doKolumny() {
            if (panel.parentNode === kolumna) {
                return;
            }

            kolumna.insertBefore(panel, kolumna.firstChild);
            kolumna.style.blockSize = '';
            delete kolumna.dataset.pozyczony;
            sprawdz();
        }

        var uchwyt = pasek.querySelector('[data-q-sheet-toggle]');

        if (warstwa && uchwyt) {
            // Panel wraca do kolumny dopiero PO zakończeniu zwijania. Oddany
            // od razu zostawiłby warstwę pustą w trakcie ruchu: zjeżdżałby sam
            // nagłówek z nazwą i wyglądałoby to jak zupełnie inny element.
            // Kolumna trzyma przez ten czas swoją wysokość, więc strona pod
            // warstwą nie drgnie. Zapasowy zegar na wypadek, gdyby przejście
            // nie wystartowało (ograniczony ruch w ustawieniach systemu).
            warstwa.addEventListener('close', function () {
                var oddane = false;

                function oddaj() {
                    if (oddane || warstwa.open) {
                        return;
                    }

                    oddane = true;
                    warstwa.removeEventListener('transitionend', poRuchu);
                    doKolumny();
                }

                function poRuchu(zdarzenie) {
                    if (zdarzenie.target === warstwa && zdarzenie.propertyName === 'translate') {
                        oddaj();
                    }
                }

                warstwa.addEventListener('transitionend', poRuchu);
                window.setTimeout(oddaj, 400);
            });

            // Escape zamyka warstwę bez naszego udziału, więc pomiar paska
            // musi zdążyć przed nim.
            warstwa.addEventListener('cancel', ustawPoczatek);

            // Uchwyt ZWIJA I ROZWIJA, a nie tylko otwiera: to jeden przełącznik,
            // więc jedno kliknięcie musi działać w obie strony.
            uchwyt.addEventListener('click', function () {
                if (warstwa.open) {
                    zwin();
                } else {
                    doWarstwy();
                }
            });

            warstwa.querySelectorAll('[data-q-sheet-close]').forEach(function (przycisk) {
                przycisk.addEventListener('click', zwin);
            });

            // Kliknięcie w tło. Celem jest wtedy sam `dialog`, bo tło maluje on
            // własnym pseudoelementem; klik w treść ma za cel element w środku.
            warstwa.addEventListener('click', function (zdarzenie) {
                if (zdarzenie.target !== warstwa) {
                    return;
                }

                var r = warstwa.getBoundingClientRect();
                var wSrodku = zdarzenie.clientX >= r.left && zdarzenie.clientX <= r.right
                    && zdarzenie.clientY >= r.top && zdarzenie.clientY <= r.bottom;

                if (!wSrodku) {
                    zwin();
                }
            });

            // Stan czytamy ze zdarzeń warstwy, a nie ustawiamy przy kliknięciu:
            // warstwę zamyka także Escape i kliknięcie w tło, a strzałka ma
            // pokazywać prawdę niezależnie od tego, którą drogą ją zamknięto.
            function stan() {
                uchwyt.setAttribute('aria-expanded', warstwa.open ? 'true' : 'false');
            }

            warstwa.addEventListener('close', stan);
            new MutationObserver(stan).observe(warstwa, { attributes: true, attributeFilter: ['open'] });
        }

        window.addEventListener('scroll', function () {
            if (czeka) {
                return;
            }

            czeka = true;
            window.requestAnimationFrame(sprawdz);
        }, { passive: true });

        window.addEventListener('resize', sprawdz);
        sprawdz();
    }

    /**
     * Przyklejenie panelu zakupu do górnej krawędzi.
     *
     * Panel jedzie z treścią, dopóki mieści się w oknie. Wyższy niż okno
     * zatrzymywałby się z przyciskiem zakupu pod dolną krawędzią i nie dałoby
     * się do niego dojechać. Wtedy przyklejenie się wyłącza.
     *
     * O tym rozstrzyga zmierzona wysokość, a nie szerokość okna, więc nie da
     * się tego zapisać zapytaniem o nośnik. Mierzymy przy wejściu, przy zmianie
     * rozmiaru okna i przy każdej zmianie wysokości panelu: wybór wariantu,
     * rozwinięcie personalizacji i komunikat pod polem zmieniają ją w locie.
     */
    function przyklejenie(kolumna) {
        var siatka = kolumna.closest('.q-pdp__grid');

        if (!siatka) {
            return;
        }

        function zmierz() {
            var naglowek = parseFloat(
                getComputedStyle(document.documentElement).getPropertyValue('--q-header-h')
            ) || 64;

            // Zapas większy niż wysokość komunikatu walidacji: przy ciasnym progu
            // jeden komunikat pod polem przerzucałby wyłącznik tam i z powrotem,
            // a panel skakałby o kilkaset pikseli.
            var zapas = 96;
            var mieszczaSie = kolumna.getBoundingClientRect().height
                <= window.innerHeight - naglowek - zapas;

            siatka.classList.toggle('is-tall', !mieszczaSie);
        }

        zmierz();
        window.addEventListener('resize', zmierz);

        if (window.ResizeObserver) {
            new ResizeObserver(zmierz).observe(kolumna);
        }
    }

    /**
     * Składniki zestawu: szuflada z listą, zaznaczanie i dodanie zaznaczonych
     * do koszyka.
     *
     * Dodajemy po kolei, nie naraz: każde dodanie zmienia ten sam koszyk, a dwa
     * równoległe zapisy potrafią się nadpisać. Po ostatnim wysyłamy jedno
     * zdarzenie `updateCart`, tak jak rdzeń po zwykłym dodaniu, więc licznik
     * w nagłówku i podgląd koszyka odświeżają się raz.
     *
     * Dodane pozycje tracą zaznaczenie; te, których sklep nie przyjął, zostają
     * zaznaczone, a szuflada zostaje otwarta z komunikatem.
     */
    function skladniki(panel) {
        var szuflada = panel.querySelector('[data-q-pack-drawer]');

        if (!szuflada || typeof szuflada.showModal !== 'function') {
            return;
        }

        var wszystkie = szuflada.querySelector('[data-q-pack-all]');
        var licznik = szuflada.querySelector('[data-q-pack-count]');
        var dodaj = szuflada.querySelector('[data-q-pack-add]');

        function pola() {
            return Array.prototype.slice.call(szuflada.querySelectorAll('[data-q-pack-item]:not(:disabled)'));
        }

        function zaznaczone() {
            return pola().filter(function (pole) {
                return pole.checked;
            });
        }

        function odswiez() {
            if (!licznik || !dodaj) {
                return;
            }

            var ile = zaznaczone().length;

            licznik.textContent = licznik.getAttribute('data-q-pack-count').replace('#', ile);
            dodaj.disabled = ile === 0;

            if (wszystkie) {
                wszystkie.checked = ile > 0 && ile === pola().length;
            }
        }

        function dodajZaznaczone() {
            var kolejka = zaznaczone();
            var ostatnia = null;
            var bledy = [];

            if (!kolejka.length) {
                return;
            }

            dodaj.disabled = true;

            function nastepny(i) {
                if (i >= kolejka.length) {
                    koniec();

                    return;
                }

                var pole = kolejka[i];
                var dane = new URLSearchParams();

                dane.append('token', szuflada.getAttribute('data-q-pack-token'));
                dane.append('id_product', pole.value);
                dane.append('id_product_attribute', pole.getAttribute('data-id-product-attribute') || '0');
                dane.append('qty', pole.getAttribute('data-qty') || '1');
                dane.append('add', '1');
                dane.append('action', 'update');
                dane.append('ajax', '1');

                fetch(szuflada.getAttribute('data-q-pack-cart'), {
                    method: 'POST',
                    body: dane,
                    credentials: 'same-origin',
                    headers: { Accept: 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
                })
                    .then(function (odpowiedz) {
                        return odpowiedz.json();
                    })
                    .then(function (wynik) {
                        if (wynik.hasError) {
                            bledy = bledy.concat(wynik.errors || []);

                            return;
                        }

                        ostatnia = wynik;
                        pole.checked = false;
                    })
                    .catch(function () {
                        bledy.push('');
                    })
                    .then(function () {
                        nastepny(i + 1);
                    });
            }

            function koniec() {
                var sklep = window.prestashop;

                odswiez();

                if (ostatnia && sklep && typeof sklep.emit === 'function') {
                    sklep.emit('updateCart', {
                        reason: {
                            idProduct: ostatnia.id_product,
                            idProductAttribute: ostatnia.id_product_attribute,
                            idCustomization: ostatnia.id_customization,
                            linkAction: 'add-to-cart',
                            cart: ostatnia.cart,
                        },
                        resp: ostatnia,
                    });
                }

                if (bledy.length) {
                    var tekst = bledy.filter(Boolean).join(' ') || szuflada.getAttribute('data-q-pack-error');

                    if (typeof Quince.toast === 'function') {
                        Quince.toast(tekst, 'danger');
                    }

                    return;
                }

                szuflada.close();
            }

            nastepny(0);
        }

        panel.addEventListener('click', function (zdarzenie) {
            if (zdarzenie.target.closest('[data-q-pack-open]')) {
                szuflada.showModal();
            }
        });

        szuflada.addEventListener('click', function (zdarzenie) {
            if (zdarzenie.target.closest('[data-q-pack-close]')) {
                szuflada.close();

                return;
            }

            if (zdarzenie.target.closest('[data-q-pack-add]')) {
                dodajZaznaczone();

                return;
            }

            // Kliknięcie w tło: `dialog` nie odróżnia go sam, więc porównujemy
            // miejsce kliknięcia z prostokątem panelu.
            var r = szuflada.getBoundingClientRect();
            var wSrodku = zdarzenie.clientX >= r.left && zdarzenie.clientX <= r.right
                && zdarzenie.clientY >= r.top && zdarzenie.clientY <= r.bottom;

            if (!wSrodku) {
                szuflada.close();
            }
        });

        szuflada.addEventListener('change', function (zdarzenie) {
            if (wszystkie && zdarzenie.target === wszystkie) {
                pola().forEach(function (pole) {
                    pole.checked = wszystkie.checked;
                });
            }

            odswiez();
        });
    }

    /** Przyciski „mniej" i „więcej" przy polu ilości. */
    function licznik(panel) {
        panel.addEventListener('click', function (zdarzenie) {
            var przycisk = zdarzenie.target.closest('[data-q-qty]');

            if (!przycisk) {
                return;
            }

            var pole = panel.querySelector('.q-qty__input');

            if (!pole) {
                return;
            }

            ustawIlosc(
                pole,
                liczba(pole.value, 1) + (przycisk.getAttribute('data-q-qty') === '+' ? 1 : -1)
            );
        });
    }

    /**
     * Szuflada z tabelą progów.
     *
     * Klik w wiersz ustawia tę ilość w liczniku i zamyka szufladę: klient wybrał
     * próg, a nie chciał go tylko obejrzeć.
     */
    function progi(panel) {
        /* Wszystko wyszukiwane przy każdym użyciu, a nie raz na starcie:
           rdzeń podmienia cały blok progów po zmianie wariantu, więc zapamiętany
           węzeł zostałby poza stroną razem ze swoim nasłuchem. */
        function szuflada() {
            return panel.querySelector('[data-q-tier-drawer]');
        }

        /* Próg osiągnięty bieżącą ilością: podświetlony wiersz w szufladzie,
           przepisane zdanie pod nim i wiersz w panelu zmieniony z zachęty
           w potwierdzenie. Rdzeń podaje progi, ale nie mówi, przy którym
           z nich klient właśnie jest. */
        function odswiez() {
            var okno = szuflada();
            var wyzwalacz = panel.querySelector('[data-q-tier-open]');

            if (!okno || !wyzwalacz) {
                return;
            }

            var pole = panel.querySelector('.q-qty__input');
            var ile = liczba(pole && pole.value, 1);
            var wiersze = Array.prototype.slice.call(okno.querySelectorAll('[data-q-tier-row]'));
            var trafiony = null;

            wiersze.forEach(function (wiersz) {
                if (ile >= liczba(wiersz.getAttribute('data-quantity'), 1)) {
                    trafiony = wiersz;
                }
            });

            wiersze.forEach(function (wiersz) {
                wiersz.classList.toggle('is-active', wiersz === trafiony);
            });

            var cena = trafiony ? (trafiony.querySelector('.q-tiers__price') || {}).textContent.trim() : '';

            // Pierwszy wiersz to cena bez rabatu, więc potwierdzenie zaczyna się
            // dopiero od drugiego.
            var maRabat = !!trafiony && trafiony !== wiersze[0];
            var haslo = wyzwalacz.querySelector('[data-q-tier-tagline]');
            var opis = wyzwalacz.querySelector('[data-q-tier-tiers]');
            var stan = okno.querySelector('[data-q-tier-status]');

            wyzwalacz.classList.toggle('has-discount', maRabat);

            if (haslo) {
                haslo.textContent = maRabat
                    ? wyzwalacz.getAttribute('data-q-tier-hit').replace('#', liczba(trafiony.getAttribute('data-quantity'), 1))
                    : haslo.getAttribute('data-q-tier-base');
            }

            if (opis) {
                opis.textContent = maRabat
                    ? wyzwalacz.getAttribute('data-q-tier-hit-note').replace('#', cena)
                    : opis.getAttribute('data-q-tier-base');
            }

            if (stan) {
                stan.innerHTML = stan.getAttribute('data-q-tier-status-template')
                    .replace('#q', '<b>' + ile + '</b>')
                    .replace('#c', cena);
            }
        }

        panel.addEventListener('click', function (zdarzenie) {
            var okno = szuflada();

            if (!okno || typeof okno.showModal !== 'function') {
                return;
            }

            if (zdarzenie.target.closest('[data-q-tier-open]')) {
                odswiez();
                okno.showModal();

                return;
            }

            if (zdarzenie.target.closest('[data-q-tier-close]')) {
                okno.close();

                return;
            }

            var wiersz = zdarzenie.target.closest('[data-q-tier-row]');

            if (wiersz) {
                var pole = panel.querySelector('.q-qty__input');

                if (pole) {
                    ustawIlosc(pole, liczba(wiersz.getAttribute('data-quantity'), 1));
                }

                odswiez();
                okno.close();

                return;
            }

            // Kliknięcie w tło: `dialog` nie odróżnia go sam, więc porównujemy
            // miejsce kliknięcia z prostokątem panelu.
            if (zdarzenie.target === okno) {
                var r = okno.getBoundingClientRect();
                var wSrodku = zdarzenie.clientX >= r.left && zdarzenie.clientX <= r.right
                    && zdarzenie.clientY >= r.top && zdarzenie.clientY <= r.bottom;

                if (!wSrodku) {
                    okno.close();
                }
            }
        });

        // Ilość zmienia się z klawiatury (`input`) i przyciskami licznika,
        // które zgłaszają `change`. Oba zdarzenia znaczą to samo: trzeba
        // policzyć próg od nowa.
        ['input', 'change'].forEach(function (nazwa) {
            panel.addEventListener(nazwa, function (zdarzenie) {
                if (zdarzenie.target.classList && zdarzenie.target.classList.contains('q-qty__input')) {
                    odswiez();
                }
            });
        });

        odswiez();
    }

    /**
     * Nazwa wybranego pliku na etykiecie.
     *
     * Pole `input type=file` jest schowane, bo przeglądarka rysuje przy nim
     * własny przycisk z własnym napisem, nieostylowalny i nieprzetłumaczalny.
     * Skoro schowane, to ono nie pokaże nazwy pliku i musi zrobić to etykieta.
     */
    function wgrywanie(panel) {
        panel.addEventListener('change', function (zdarzenie) {
            var pole = zdarzenie.target;

            if (!pole.matches || !pole.matches('input[type="file"]')) {
                return;
            }

            var etykieta = pole.closest('[data-q-upload]');
            var napis = etykieta && etykieta.querySelector('[data-q-upload-name]');

            if (!etykieta || !napis) {
                return;
            }

            var plik = pole.files && pole.files[0];

            if (plik) {
                napis.textContent = plik.name;
                etykieta.classList.add('ma-plik');
            } else {
                etykieta.classList.remove('ma-plik');
            }
        });
    }

    /**
     * „Kup teraz": dodanie do koszyka robi rdzeń, my dokładamy przejście dalej.
     *
     * Adres zamówienia siedzi w znaczniku przycisku, a nie w skrypcie: to sklep
     * wie, gdzie prowadzi jego kasa, i to on może ten przycisk wyłączyć.
     */
    function kupTeraz(panel) {
        var sklep = window.prestashop;

        if (!sklep || typeof sklep.on !== 'function') {
            return;
        }

        var adres = null;

        panel.addEventListener('click', function (zdarzenie) {
            var przycisk = zdarzenie.target.closest('[data-q-buy-now]');

            adres = przycisk ? przycisk.getAttribute('data-q-buy-now') : null;
        });

        sklep.on('updateCart', function (wynik) {
            if (!adres) {
                return;
            }

            var cel = adres;
            adres = null;

            // Odmowa dodania (brak towaru, nieustawiony wariant) kończy się tym
            // samym zdarzeniem co powodzenie, więc pytamy o błędy: przejście do
            // kasy z pustym koszykiem byłoby gorsze niż zostanie na karcie.
            if (wynik && wynik.resp && wynik.resp.hasError) {
                return;
            }

            window.location.assign(cel);
        });
    }

    /** Ilość nie schodzi poniżej minimum sklepu ani powyżej dostępnego stanu. */
    function ustawIlosc(pole, ile) {
        var min = liczba(pole.getAttribute('min'), 1);
        var max = pole.getAttribute('max') === null ? null : liczba(pole.getAttribute('max'), 0);

        ile = Math.max(min, ile);

        if (max !== null) {
            ile = Math.min(max, ile);
        }

        if (String(ile) === String(pole.value)) {
            return;
        }

        pole.value = ile;
        pole.dispatchEvent(new Event('change', { bubbles: true }));
    }

    function liczba(wartosc, zapasowa) {
        var n = parseInt(wartosc, 10);

        return isNaN(n) ? zapasowa : n;
    }
}());
