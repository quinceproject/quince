/* ===================================================================
   Quince: lista list życzeń (tworzenie, zmiana nazwy, udostępnianie,
   usuwanie)

   JS modułu dla tej strony jest w kilku miejscach zepsuty: woła złą akcję
   PHP przy tworzeniu nowej listy (`action=getAllWishlist` zamiast
   `action=createNewWishList`), a przy zmianie nazwy/udostępnianiu/usuwaniu
   zamyka swój wewnętrzny stan menu przy każdym kliknięciu w środku, więc
   ikony znikają zaraz po pierwszym użyciu. Wszystkie cztery działania
   prowadzi więc ten plik, naszymi oknami (`.q-modal q-modal--drawer`)
   i naszym rozwijanym menu (`.q-dropdown`). Moduł zostaje właścicielem
   danych (lista list, numery, adresy udostępniania), czytamy je z jego
   własnego stanu Vue (`.wishlist-container`.__vue__.lists), nic nie
   duplikujemy.

   Zero zapamiętanych referencji do węzłów DOM w zmiennych: Vue montuje się
   też na `.wishlist-rename`/`.wishlist-share`/`.wishlist-delete` i w pewnym
   momencie po starcie strony podmienia te węzły na nowe, równe co do
   znaczników, ale inne jako obiekty. Referencja złapana wcześniej zostaje
   odcięta od dokumentu (`.showModal()` na niej wywala
   `InvalidStateError: not in a Document`). Każde okno jest więc odpytywane
   na nowo, dokładnie w chwili użycia, przez delegację zdarzeń na
   `document`.
   =================================================================== */

(function () {
    'use strict';

    var Quince = window.Quince || {};

    /* Teksty i adresy złapane TERAZ, zanim Vue zdąży podmienić
       `.wishlist-container` (korzeń aplikacji, jedyny element, który
       realnie się tu przebudowuje) i zabrać ze sobą jego atrybuty
       `data-*`. Odczyt dopiero przy pierwszym kliknięciu kebaba dałby
       puste etykiety „Zmień nazwę”/„Udostępnij” w menu. Adresy statycznych
       okien (`.wishlist-create` itp.) łapiemy tym samym sposobem. */
    var qWishlistKontener = document.querySelector('.wishlist-container');
    var qWishlistTeksty = {
        rename: (qWishlistKontener && qWishlistKontener.dataset.renameText) || '',
        share: (qWishlistKontener && qWishlistKontener.dataset.shareText) || '',
    };
    var qWishlistAdresy = {
        create: pobierzAdresBazowy('wishlist-create'),
        rename: pobierzAdresBazowy('wishlist-rename'),
        delete: pobierzAdresBazowy('wishlist-delete'),
    };

    function pobierzAdresBazowy(nazwaKlasy) {
        var kontener = document.querySelector('.' + nazwaKlasy);

        return kontener ? kontener.dataset.url : null;
    }

    function wywolajAkcje(adresBazowy, akcja, parametry) {
        var adres = new URL(adresBazowy, window.location.origin);
        adres.searchParams.set('action', akcja);
        adres.searchParams.set('ajax', '1');

        Object.keys(parametry || {}).forEach(function (klucz) {
            adres.searchParams.set('params[' + klucz + ']', parametry[klucz]);
        });

        return fetch(adres, { credentials: 'same-origin' }).then(function (odpowiedz) {
            return odpowiedz.json();
        });
    }

    function pobierzListy() {
        var kontener = document.querySelector('.wishlist-container');
        var vue = kontener && kontener.__vue__;

        return (vue && Array.isArray(vue.lists)) ? vue.lists : [];
    }

    /** Numer listy na podstawie miejsca elementu w DOM: ten sam porządek
     *  co dane Vue, bo rysuje je ten sam `v-for`. */
    function listaDlaElementu(el) {
        var wszystkie = Array.from(document.querySelectorAll('.wishlist-list-item'));
        var pozycja = wszystkie.indexOf(el.closest('.wishlist-list-item'));

        return pobierzListy()[pozycja] || null;
    }

    /* ---- Zamykanie: wspólne dla wszystkich czterech okien, przyciskiem
       X/Anuluj albo kliknięciem w tło. Zero referencji trzymanych między
       otwarciem a zamknięciem, więc podmiana węzła przez Vue niczego tu
       nie psuje. ---- */
    document.addEventListener('click', function (zdarzenie) {
        var przyciskZamknij = zdarzenie.target.closest(
            '[data-q-wishlist-create-close],'
            + '[data-q-wishlist-rename-close],'
            + '[data-q-wishlist-share-close],'
            + '[data-q-wishlist-delete-close]'
        );

        if (przyciskZamknij) {
            var oknoDoZamkniecia = przyciskZamknij.closest('dialog');

            if (oknoDoZamkniecia) {
                oknoDoZamkniecia.close();
            }
        }
    });

    document.addEventListener('click', function (zdarzenie) {
        if (zdarzenie.target.tagName !== 'DIALOG' || !zdarzenie.target.hasAttribute('open')) {
            return;
        }

        var okno = zdarzenie.target;
        var r = okno.getBoundingClientRect();
        var wSrodku = zdarzenie.clientX >= r.left && zdarzenie.clientX <= r.right
            && zdarzenie.clientY >= r.top && zdarzenie.clientY <= r.bottom;

        if (!wSrodku) {
            okno.close();
        }
    });

    /* ---- Tworzenie nowej listy. ---- */
    document.addEventListener('click', function (zdarzenie) {
        if (!zdarzenie.target.closest('.wishlist-add-to-new')) {
            return;
        }

        var okno = document.querySelector('[data-q-wishlist-create]');
        var pole = okno && okno.querySelector('[data-q-wishlist-create-input]');

        if (!okno || typeof okno.showModal !== 'function') {
            return;
        }

        if (pole) {
            pole.value = '';
        }

        okno.showModal();

        if (pole) {
            pole.focus();
        }
    }, true);

    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-q-wishlist-create-submit]');

        if (!przycisk) {
            return;
        }

        var okno = przycisk.closest('dialog');
        var pole = okno && okno.querySelector('[data-q-wishlist-create-input]');
        var adresBazowy = qWishlistAdresy.create;
        var nazwa = pole ? pole.value.trim() : '';

        if (!pole || !adresBazowy || nazwa === '') {
            if (pole) {
                pole.focus();
            }

            return;
        }

        przycisk.setAttribute('aria-busy', 'true');

        wywolajAkcje(adresBazowy, 'createNewWishList', { name: nazwa })
            .then(function (wynik) {
                if (!wynik || wynik.success === false) {
                    var komunikat = (wynik && wynik.message) || null;

                    if (typeof Quince.toast === 'function' && komunikat) {
                        Quince.toast(komunikat, 'danger');
                    }

                    przycisk.removeAttribute('aria-busy');

                    return;
                }

                window.location.reload();
            })
            .catch(function () {
                przycisk.removeAttribute('aria-busy');
            });
    });

    /* ---- Zmiana nazwy. ---- */
    var listaDoZmianyNazwy = null;

    function otworzRename(lista) {
        var okno = document.querySelector('[data-q-wishlist-rename]');
        var pole = okno && okno.querySelector('[data-q-wishlist-rename-input]');

        if (!okno || typeof okno.showModal !== 'function' || !pole) {
            return;
        }

        listaDoZmianyNazwy = lista;
        pole.value = lista.name;
        okno.showModal();
        pole.focus();
        pole.select();
    }

    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-q-wishlist-rename-submit]');

        if (!przycisk || listaDoZmianyNazwy === null) {
            return;
        }

        var okno = przycisk.closest('dialog');
        var pole = okno && okno.querySelector('[data-q-wishlist-rename-input]');
        var adresBazowy = qWishlistAdresy.rename;
        var nazwa = pole ? pole.value.trim() : '';

        if (!pole || !adresBazowy || nazwa === '') {
            if (pole) {
                pole.focus();
            }

            return;
        }

        przycisk.setAttribute('aria-busy', 'true');

        wywolajAkcje(adresBazowy, 'renameWishList', { idWishList: listaDoZmianyNazwy.id_wishlist, name: nazwa })
            .then(function (wynik) {
                if (!wynik || wynik.success === false) {
                    var komunikat = (wynik && wynik.message) || null;

                    if (typeof Quince.toast === 'function' && komunikat) {
                        Quince.toast(komunikat, 'danger');
                    }

                    przycisk.removeAttribute('aria-busy');

                    return;
                }

                window.location.reload();
            })
            .catch(function () {
                przycisk.removeAttribute('aria-busy');
            });
    });

    /* ---- Udostępnianie: link jest już znany, bez zapytania do serwera. ---- */
    function otworzShare(lista) {
        var okno = document.querySelector('[data-q-wishlist-share]');
        var pole = okno && okno.querySelector('[data-q-wishlist-share-input]');

        if (!okno || typeof okno.showModal !== 'function' || !pole) {
            return;
        }

        pole.value = lista.shareUrl;
        okno.showModal();
    }

    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-q-wishlist-share-copy]');

        if (!przycisk) {
            return;
        }

        var okno = przycisk.closest('dialog');
        var pole = okno && okno.querySelector('[data-q-wishlist-share-input]');

        if (!pole) {
            return;
        }

        pole.select();

        if (navigator.clipboard && typeof navigator.clipboard.writeText === 'function') {
            navigator.clipboard.writeText(pole.value).catch(function () {
                // Pole zostaje zaznaczone, klient skopiuje ręcznie (Ctrl+C).
            });
        }
    });

    /* ---- Usuwanie. ---- */
    var listaDoUsuniecia = null;

    function otworzDelete(lista) {
        var okno = document.querySelector('[data-q-wishlist-delete]');
        var nazwaEl = okno && okno.querySelector('[data-q-wishlist-delete-name]');

        if (!okno || typeof okno.showModal !== 'function' || !nazwaEl) {
            return;
        }

        listaDoUsuniecia = lista;
        nazwaEl.textContent = lista.name;
        okno.showModal();
    }

    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-q-wishlist-delete-submit]');

        if (!przycisk || listaDoUsuniecia === null) {
            return;
        }

        var adresBazowy = qWishlistAdresy.delete;

        if (!adresBazowy) {
            return;
        }

        przycisk.setAttribute('aria-busy', 'true');

        wywolajAkcje(adresBazowy, 'deleteWishList', { idWishList: listaDoUsuniecia.id_wishlist })
            .then(function (wynik) {
                if (!wynik || wynik.success === false) {
                    var komunikat = (wynik && wynik.message) || null;

                    if (typeof Quince.toast === 'function' && komunikat) {
                        Quince.toast(komunikat, 'danger');
                    }

                    przycisk.removeAttribute('aria-busy');

                    return;
                }

                window.location.reload();
            })
            .catch(function () {
                przycisk.removeAttribute('aria-busy');
            });
    });

    /* ---- Menu pod kebabem: nasz `.q-dropdown`, doklejony do `document.body`
       (nie do wiersza listy). Ten sam powód co z resztą tej strony: węzeł
       doklejony do wnętrza karty zniknąłby razem z nią przy kolejnej
       podmianie przez Vue. Jeden, wspólny panel dla wszystkich list na
       stronie, przenoszony pod kliknięty kebab i wypełniany na nowo przy
       każdym otwarciu. ---- */
    var menu = null;
    var listaDlaMenu = null;

    function zbudujMenu() {
        if (menu) {
            return menu;
        }

        var tekstZmienNazwe = qWishlistTeksty.rename;
        var tekstUdostepnij = qWishlistTeksty.share;
        var przyciskUsunWModalu = document.querySelector('[data-q-wishlist-delete-submit]');
        var tekstUsun = przyciskUsunWModalu ? przyciskUsunWModalu.textContent.trim() : '';

        menu = document.createElement('div');
        menu.className = 'q-dropdown';
        menu.setAttribute('role', 'menu');
        menu.hidden = true;
        menu.style.position = 'fixed';

        function dodajOpcje(tekst, akcja) {
            var opcja = document.createElement('button');
            opcja.type = 'button';
            opcja.className = 'q-dropdown__option';
            opcja.setAttribute('role', 'menuitem');
            opcja.textContent = tekst;
            opcja.addEventListener('click', function () {
                zamknijMenu();

                if (listaDlaMenu) {
                    akcja(listaDlaMenu);
                }
            });
            menu.appendChild(opcja);
        }

        dodajOpcje(tekstZmienNazwe, otworzRename);
        dodajOpcje(tekstUdostepnij, otworzShare);
        dodajOpcje(tekstUsun, otworzDelete);

        document.body.appendChild(menu);

        return menu;
    }

    function zamknijMenu() {
        if (menu) {
            menu.hidden = true;
        }

        document.removeEventListener('click', zamknijNaZewnatrzMenu, true);
    }

    function zamknijNaZewnatrzMenu(zdarzenie) {
        if (menu && !menu.contains(zdarzenie.target)) {
            zamknijMenu();
        }
    }

    document.addEventListener('click', function (zdarzenie) {
        var kebab = zdarzenie.target.closest('.wishlist-list-item-actions');

        if (!kebab) {
            return;
        }

        // Zatrzymujemy zdarzenie na etapie przechwytywania: własna obsługa
        // kebaba w module otwiera (i od razu, w tym samym cyklu,
        // zamyka) swój wewnętrzny stan, przez co ikony znikają po każdym
        // kliknięciu. Nasze menu nigdy do niej nie dociera.
        zdarzenie.stopImmediatePropagation();
        zdarzenie.preventDefault();

        var lista = listaDlaElementu(kebab);

        if (!lista) {
            return;
        }

        var panel = zbudujMenu();
        listaDlaMenu = lista;

        var r = kebab.getBoundingClientRect();

        panel.hidden = false;
        panel.style.insetInlineStart = Math.round(r.left) + 'px';
        panel.style.insetBlockStart = Math.round(r.bottom + 4) + 'px';

        var panelRect = panel.getBoundingClientRect();

        if (panelRect.right > window.innerWidth) {
            panel.style.insetInlineStart = Math.round(r.right - panelRect.width) + 'px';
        }

        window.setTimeout(function () {
            document.addEventListener('click', zamknijNaZewnatrzMenu, true);
        }, 0);
    }, true);

    /* Serce na liście domyślnej ma tylko jedną akcję (udostępnij), więc
       zamiast menu otwiera okno wprost. */
    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('.wishlist-list-item-default .wishlist-list-item-right button');

        if (!przycisk) {
            return;
        }

        zdarzenie.stopImmediatePropagation();
        zdarzenie.preventDefault();

        var lista = listaDlaElementu(przycisk);

        if (lista) {
            otworzShare(lista);
        }
    }, true);
})();
