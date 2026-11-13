/**
 * Zapis na powiadomienie o dostępności w szufladzie.
 *
 * Formularz modułu stoi w oknie bocznym, a przy stanie zostaje sam przycisk:
 * dotyczy sytuacji, w której klient i tak nie kupi teraz, więc nie ma powodu,
 * żeby zajmował w kolumnie tyle miejsca co blok cech.
 *
 * Okno jest natywnym `dialog`, więc pułapkę ogniska, klawisz Escape i tło ma
 * z przeglądarki. Zostaje tylko otwieranie, zamykanie i kliknięcie w tło.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    Quince.register('[data-q-notify-open]', function (przycisk) {
        var okno = document.querySelector('[data-q-notify]');

        if (!okno || typeof okno.showModal !== 'function') {
            return;
        }

        przycisk.addEventListener('click', function () {
            okno.showModal();
        });

        var zamknij = okno.querySelector('[data-q-notify-close]');

        if (zamknij) {
            zamknij.addEventListener('click', function () {
                okno.close();
            });
        }

        // Kliknięcie w tło: `dialog` nie odróżnia go sam, więc porównujemy
        // miejsce kliknięcia z prostokątem okna.
        okno.addEventListener('click', function (zdarzenie) {
            // Tło to samo okno: `dialog` maluje je własnym pseudoelementem, więc
            // kliknięcie w tło ma za cel `dialog`, a kliknięcie w treść element
            // w środku. Sam pomiar współrzędnych nie wystarczy: klawisz Enter na
            // przycisku wysyła kliknięcie w punkcie (0, 0), czyli „poza oknem",
            // i zamknąłby szufladę osobie obsługującej sklep klawiaturą.
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
    });

    /**
     * Wysyłka zapisu na powiadomienie.
     *
     * Moduł ma własny skrypt, ale szuka w stronie swoich klas (`js-mailalert`),
     * a nasz szablon rysuje formularz znacznikami motywu, więc jego skrypt nie
     * ma czego znaleźć. Adres i odpowiedź zostają modułowe: wysyłamy trzy pola
     * pod ten sam adres i czytamy tę samą odpowiedź, więc sklep bez motywu
     * działa tak samo.
     */
    Quince.register('[data-ps-ref="emailalerts"]', function (blok) {
        var przycisk = blok.querySelector('[data-ps-action="emailalerts-subscribe"]');
        var pole = blok.querySelector('[data-ps-ref="emailalerts-email"]');
        var skrzynka = blok.querySelector('[data-ps-target="emailalerts-alerts"]');
        var tresc = blok.querySelector('[data-ps-ref="emailalerts-content"]');
        var adres = blok.getAttribute('data-url');

        if (!przycisk || !skrzynka || !adres) {
            return;
        }

        var dane = {};

        try {
            dane = JSON.parse(przycisk.getAttribute('data-ps-data') || '{}');
        } catch (blad) {
            dane = {};
        }

        function pokaz(tekst, czyBlad) {
            skrzynka.className = 'q-alerts__message q-alert q-alert--' + (czyBlad ? 'danger' : 'success');
            skrzynka.textContent = tekst;
            skrzynka.hidden = false;
        }

        var podpowiedz = blok.querySelector('[data-ps-ref="emailalerts-hint"]');

        function podpowiedzPokaz(tekst) {
            if (!podpowiedz) {
                return;
            }

            podpowiedz.textContent = tekst || '';
            podpowiedz.hidden = !tekst;
        }

        function oznacz(czyBlad) {
            var owijka = pole ? pole.closest('.q-float') : null;

            if (owijka) {
                owijka.classList.toggle('has-error', czyBlad);
            }

            if (pole) {
                pole.setAttribute('aria-invalid', czyBlad ? 'true' : 'false');
            }
        }

        przycisk.addEventListener('click', function (zdarzenie) {
            zdarzenie.preventDefault();

            // Sprawdzenie własne, a nie przeglądarki: jej komunikat wychodzi
            // czarnym dymkiem przy polu, którego nie da się ani ostylować, ani
            // przenieść. Wzór jest celowo luźny, bo o tym, czy adres istnieje,
            // i tak rozstrzyga serwer.
            if (pole) {
                var wpis = pole.value.trim();
                var brak = wpis === '';
                var zly = !brak && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(wpis);

                if (brak || zly) {
                    oznacz(true);
                    podpowiedzPokaz(blok.getAttribute(brak ? 'data-q-notify-empty' : 'data-q-notify-invalid'));
                    skrzynka.hidden = true;
                    pole.focus();

                    return;
                }
            }

            podpowiedzPokaz('');
            oznacz(false);
            przycisk.disabled = true;

            var tresci = new URLSearchParams();
            tresci.set('id_product', dane.id_product || '');
            tresci.set('id_product_attribute', dane.id_product_attribute || '');

            if (pole) {
                tresci.set('customer_email', pole.value);
            }

            var straznik = blok.querySelector('[data-q-notify-guard]');

            if (straznik) {
                straznik.querySelectorAll('input[name]').forEach(function (poleStraznika) {
                    tresci.set(poleStraznika.name, poleStraznika.value);
                });
            }

            // Najpierw dostawcy oceny formularzy (reCAPTCHA) dopisują swoje pola.
            Quince.prepareForm(tresci).then(function () {
                return fetch(adres, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    credentials: 'same-origin',
                    body: tresci.toString()
                });
            }).then(function (odpowiedz) {
                return odpowiedz.text();
            }).then(function (napis) {
                var wynik = null;

                try {
                    wynik = JSON.parse(napis);
                } catch (blad) {
                    wynik = null;
                }

                if (!wynik || typeof wynik.message !== 'string') {
                    pokaz(blok.getAttribute('data-q-notify-failure') || '', true);

                    return;
                }

                pokaz(wynik.message, Boolean(wynik.error));
                oznacz(Boolean(wynik.error));

                // Zapis się udał, więc formularz nie ma po co stać dalej:
                // zostaje samo potwierdzenie.
                if (!wynik.error && tresc) {
                    tresc.hidden = true;
                }
            }).catch(function () {
                pokaz(blok.getAttribute('data-q-notify-failure') || '', true);
            }).then(function () {
                przycisk.disabled = false;
            });
        });
    });
}());
