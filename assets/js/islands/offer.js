/**
 * Oferta PDF: szuflada, lista ofertowa i wysyłka.
 *
 * Znaczniki przynosi moduł `quince_offers`, zachowanie jest tutaj, bo dotyczy
 * okna i formularza motywu. Rozmowa z modułem idzie jednym adresem i czterema
 * czynnościami: dodaj, usuń, pokaż listę, wyślij.
 *
 * Okno jest natywnym `dialog`, więc pułapkę ogniska, klawisz Escape i tło ma
 * z przeglądarki. Zostaje otwieranie, zamykanie i kliknięcie w tło.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    Quince.register('[data-q-offer-root]', function (korzen) {
        var okno = document.querySelector('[data-q-offer]');
        var adres = korzen.getAttribute('data-url');
        var idProduktu = korzen.getAttribute('data-id-product');

        if (!okno || !adres || typeof okno.showModal !== 'function') {
            return;
        }

        var lista = okno.querySelector('[data-q-offer-list]');
        var licznik = okno.querySelector('[data-q-offer-count]');
        var blokListy = okno.querySelector('[data-q-offer-box]');
        var komunikat = okno.querySelector('[data-q-offer-message]');
        var formularz = okno.querySelector('[data-q-offer-form]');
        var potwierdzenie = okno.querySelector('[data-q-offer-done]');
        var pola = {
            email: okno.querySelector('[data-q-offer-email]'),
            name: okno.querySelector('[data-q-offer-name]'),
            phone: okno.querySelector('[data-q-offer-phone]'),
            newsletter: okno.querySelector('[data-q-offer-newsletter]')
        };

        /** Pola strażnika formularzy: jadą z każdym żądaniem, tak jak w formularzu. */
        function polaStraznika(dane) {
            var opakowanie = okno.querySelector('[data-q-offer-guard]');

            if (!opakowanie) {
                return dane;
            }

            opakowanie.querySelectorAll('input[name]').forEach(function (pole) {
                dane.set(pole.name, pole.value);
            });

            return dane;
        }

        function zapytaj(akcja, dodatkowe) {
            var dane = polaStraznika(new URLSearchParams());
            dane.set('action', akcja);

            Object.keys(dodatkowe || {}).forEach(function (klucz) {
                dane.set(klucz, dodatkowe[klucz]);
            });

            // Najpierw dostawcy oceny formularzy (reCAPTCHA) dopisują swoje pola.
            return Quince.prepareForm(dane).then(function () {
                return fetch(adres, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    credentials: 'same-origin',
                    body: dane.toString()
                });
            }).then(function (odpowiedz) {
                return odpowiedz.json();
            });
        }

        function pokazKomunikat(tekst, czyBlad) {
            if (!komunikat) {
                return;
            }

            komunikat.className = 'q-offer__message q-alert q-alert--' + (czyBlad ? 'danger' : 'success');
            komunikat.textContent = tekst;
            komunikat.hidden = !tekst;
        }

        function rysujListe(pozycje) {
            if (!lista) {
                return;
            }

            lista.textContent = '';

            (pozycje || []).forEach(function (pozycja) {
                var wiersz = document.createElement('li');
                wiersz.className = 'q-offer__item';

                var foto = document.createElement('span');
                foto.className = 'q-offer__photo';

                if (pozycja.image) {
                    var obraz = document.createElement('img');
                    obraz.src = pozycja.image;
                    obraz.alt = '';
                    obraz.loading = 'lazy';
                    foto.appendChild(obraz);
                }

                var tresc = document.createElement('span');
                tresc.className = 'q-offer__text';

                var nazwa = document.createElement('span');
                nazwa.className = 'q-offer__name';
                nazwa.textContent = pozycja.name;

                var cena = document.createElement('span');
                cena.className = 'q-offer__price';
                cena.textContent = pozycja.price;

                tresc.appendChild(nazwa);
                tresc.appendChild(cena);

                var usun = document.createElement('button');
                usun.type = 'button';
                usun.className = 'q-offer__remove';
                usun.setAttribute('data-q-offer-remove', String(pozycja.id_product));
                usun.setAttribute('aria-label', korzen.getAttribute('data-label-remove') || 'x');
                usun.innerHTML = '<svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">'
                    + '<path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/></svg>';

                wiersz.appendChild(foto);
                wiersz.appendChild(tresc);
                wiersz.appendChild(usun);
                lista.appendChild(wiersz);
            });

            var ile = (pozycje || []).length;

            if (licznik) {
                licznik.textContent = String(ile);
            }

            // Pusta lista nie pokazuje się wcale. Nagłówek „Lista ofertowa (0)"
            // nad zdaniem o pustej liście zajmował miejsce w oknie i mówił
            // o czymś, czego klient jeszcze nie zaczął robić.
            if (blokListy) {
                blokListy.hidden = ile === 0;
            }
        }

        /**
         * Widok po wysłaniu: formularz znika, zostaje potwierdzenie z numerem.
         *
         * Pasek nad przyciskiem zostawiał klienta w formularzu, który przed chwilą
         * wysłał, i kazał mu się domyślać, czy coś jeszcze ma zrobić.
         */
        function pokazPotwierdzenie(adresEmail, numer, adresPliku) {
            var adresat = okno.querySelector('[data-q-offer-done-email]');
            var numerPola = okno.querySelector('[data-q-offer-done-number]');

            if (adresat) {
                adresat.textContent = adresEmail;
            }

            if (numerPola) {
                numerPola.textContent = numer;
            }

            var pobierz = okno.querySelector('[data-q-offer-download]');

            if (pobierz) {
                pobierz.href = adresPliku || '#';
                pobierz.hidden = !adresPliku;
            }

            if (formularz) {
                formularz.hidden = true;
            }

            if (potwierdzenie) {
                potwierdzenie.hidden = false;
            }

            okno.querySelectorAll('[data-q-offer-send], [data-q-offer-add]').forEach(function (przycisk) {
                przycisk.hidden = true;
            });

            var zamkniecie = okno.querySelector('[data-q-offer-done-close]');

            if (zamkniecie) {
                zamkniecie.hidden = false;
                zamkniecie.focus();
            }
        }

        var zamknijPoWyslaniu = okno.querySelector('[data-q-offer-done-close]');

        if (zamknijPoWyslaniu) {
            zamknijPoWyslaniu.addEventListener('click', function () {
                okno.close();
            });
        }

        korzen.querySelector('[data-q-offer-open]').addEventListener('click', function () {
            okno.showModal();
            zapytaj('list', {}).then(function (wynik) {
                rysujListe(wynik.items);
            }).catch(function () {
                rysujListe([]);
            });
        });

        var zamknij = okno.querySelector('[data-q-offer-close]');

        if (zamknij) {
            zamknij.addEventListener('click', function () {
                okno.close();
            });
        }

        okno.addEventListener('click', function (zdarzenie) {
            // Tło to samo okno: `dialog` maluje je własnym pseudoelementem, więc
            // kliknięcie w tło ma za cel `dialog`, a kliknięcie w treść — element
            // w środku. Sam pomiar współrzędnych nie wystarczy: klawisz Enter na
            // przycisku wysyła kliknięcie w punkcie (0, 0), czyli „poza oknem",
            // i zamykał szufladę osobie obsługującej sklep klawiaturą.
            if (zdarzenie.target !== okno) {
                return;
            }

            var r = okno.getBoundingClientRect();
            var wSrodku = zdarzenie.clientX >= r.left && zdarzenie.clientX <= r.right
                && zdarzenie.clientY >= r.top && zdarzenie.clientY <= r.bottom;

            if (!wSrodku) {
                okno.close();
            }
        });

        // Usunięcie pozycji: nasłuch na liście, bo wiersze powstają w locie.
        if (lista) {
            lista.addEventListener('click', function (zdarzenie) {
                var przycisk = zdarzenie.target.closest('[data-q-offer-remove]');

                if (!przycisk) {
                    return;
                }

                zapytaj('remove', { id_product: przycisk.getAttribute('data-q-offer-remove') })
                    .then(function (wynik) {
                        rysujListe(wynik.items);
                    });
            });
        }

        var dodaj = okno.querySelector('[data-q-offer-add]');

        if (dodaj) {
            dodaj.addEventListener('click', function () {
                zapytaj('add', { id_product: idProduktu }).then(function (wynik) {
                    rysujListe(wynik.items);
                });
            });
        }

        var wyslij = okno.querySelector('[data-q-offer-send]');

        if (wyslij) {
            wyslij.addEventListener('click', function () {
                var adresEmail = pola.email ? pola.email.value.trim() : '';

                if (adresEmail === '' || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(adresEmail)) {
                    pokazKomunikat(korzen.getAttribute('data-msg-email') || '', true);

                    if (pola.email) {
                        pola.email.focus();
                    }

                    return;
                }

                wyslij.disabled = true;

                zapytaj('send', {
                    id_product: idProduktu,
                    email: adresEmail,
                    customer_name: pola.name ? pola.name.value.trim() : '',
                    phone: pola.phone ? pola.phone.value.trim() : '',
                    newsletter: pola.newsletter && pola.newsletter.checked ? '1' : '0'
                }).then(function (wynik) {
                    if (wynik.ok) {
                        rysujListe([]);
                        pokazPotwierdzenie(adresEmail, wynik.number, wynik.pdf);
                    } else {
                        pokazKomunikat(korzen.getAttribute('data-msg-failure') || '', true);
                    }
                }).catch(function () {
                    pokazKomunikat(korzen.getAttribute('data-msg-failure') || '', true);
                }).then(function () {
                    wyslij.disabled = false;
                });
            });
        }
    });
}());
