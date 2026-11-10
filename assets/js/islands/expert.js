/**
 * Zapytanie do specjalisty: szuflada i wysyłka wiadomości.
 *
 * Znaczniki przynosi moduł `quince_contacts`, zachowanie jest tutaj, bo dotyczy
 * okna i formularza motywu.
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

    Quince.register('[data-q-expert-root]', function (korzen) {
        var okno = korzen.querySelector('[data-q-expert]');
        var adres = korzen.getAttribute('data-url');

        if (!okno || !adres || typeof okno.showModal !== 'function') {
            return;
        }

        var formularz = okno.querySelector('[data-q-expert-form]');
        var potwierdzenie = okno.querySelector('[data-q-expert-done]');
        var podpowiedz = okno.querySelector('[data-q-expert-hint]');
        var wyslij = okno.querySelector('[data-q-expert-send]');
        var zamknijPo = okno.querySelector('[data-q-expert-done-close]');
        var pola = {
            name: okno.querySelector('[data-q-expert-name]'),
            email: okno.querySelector('[data-q-expert-email]'),
            message: okno.querySelector('[data-q-expert-message]'),
            product: okno.querySelector('[data-q-expert-product]')
        };

        /** Pola strażnika formularzy: jadą z żądaniem, tak jak w każdym formularzu. */
        function polaStraznika(dane) {
            var opakowanie = okno.querySelector('[data-q-expert-guard]');

            if (opakowanie) {
                opakowanie.querySelectorAll('input[name]').forEach(function (pole) {
                    dane.set(pole.name, pole.value);
                });
            }

            return dane;
        }

        function pokazPodpowiedz(tekst) {
            if (!podpowiedz) {
                return;
            }

            podpowiedz.textContent = tekst || '';
            podpowiedz.hidden = !tekst;
        }

        function oznacz(pole, czyBlad) {
            var owijka = pole ? pole.closest('.q-float') : null;

            if (owijka) {
                owijka.classList.toggle('has-error', czyBlad);
            }

            if (pole) {
                pole.setAttribute('aria-invalid', czyBlad ? 'true' : 'false');
            }
        }

        /**
         * Sprawdzenie własne, a nie przeglądarki: jej komunikat wychodzi czarnym
         * dymkiem przy polu, którego nie da się ani ostylować, ani przenieść.
         */
        function wypelnione() {
            var email = (pola.email && pola.email.value || '').trim();
            var tresc = (pola.message && pola.message.value || '').trim();

            oznacz(pola.email, false);
            oznacz(pola.message, false);

            if (email === '' || tresc === '') {
                oznacz(pola.email, email === '');
                oznacz(pola.message, tresc === '');
                pokazPodpowiedz(korzen.getAttribute('data-msg-empty') || '');

                return false;
            }

            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                oznacz(pola.email, true);
                pokazPodpowiedz(korzen.getAttribute('data-msg-invalid') || '');

                return false;
            }

            pokazPodpowiedz('');

            return true;
        }

        /** Widok po wysłaniu: formularz znika, zostaje potwierdzenie. */
        function pokazPotwierdzenie() {
            if (formularz) {
                formularz.hidden = true;
            }

            if (potwierdzenie) {
                potwierdzenie.hidden = false;
            }

            if (wyslij) {
                wyslij.hidden = true;
            }

            if (zamknijPo) {
                zamknijPo.hidden = false;
                zamknijPo.focus();
            }
        }

        korzen.querySelector('[data-q-expert-open]').addEventListener('click', function () {
            okno.showModal();
        });

        okno.querySelectorAll('[data-q-expert-close]').forEach(function (przycisk) {
            przycisk.addEventListener('click', function () {
                okno.close();
            });
        });

        if (zamknijPo) {
            zamknijPo.addEventListener('click', function () {
                okno.close();
            });
        }

        // Kliknięcie w tło: `dialog` nie odróżnia go sam, więc porównujemy
        // miejsce kliknięcia z prostokątem okna.
        okno.addEventListener('click', function (zdarzenie) {
            var r = okno.getBoundingClientRect();
            var wSrodku = zdarzenie.clientX >= r.left && zdarzenie.clientX <= r.right
                && zdarzenie.clientY >= r.top && zdarzenie.clientY <= r.bottom;

            if (!wSrodku) {
                okno.close();
            }
        });

        if (!wyslij) {
            return;
        }

        wyslij.addEventListener('click', function () {
            if (!wypelnione()) {
                (pola.email || {}).focus && pola.email.focus();

                return;
            }

            var dane = polaStraznika(new URLSearchParams());
            dane.set('name', (pola.name && pola.name.value || '').trim());
            dane.set('email', (pola.email && pola.email.value || '').trim());
            dane.set('message', (pola.message && pola.message.value || '').trim());
            dane.set('id_product', (pola.product && pola.product.value) || '0');

            wyslij.disabled = true;

            // Najpierw dostawcy oceny formularzy (reCAPTCHA) dopisują swoje pola.
            Quince.prepareForm(dane).then(function () {
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
            }).then(function (wynik) {
                if (wynik && wynik.ok) {
                    pokazPotwierdzenie();
                } else {
                    pokazPodpowiedz(korzen.getAttribute('data-msg-failure') || '');
                }
            }).catch(function () {
                pokazPodpowiedz(korzen.getAttribute('data-msg-failure') || '');
            }).then(function () {
                wyslij.disabled = false;
            });
        });
    });
}());
