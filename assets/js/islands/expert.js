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
            phone: okno.querySelector('[data-q-expert-phone]'),
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
            var telefon = (pola.phone && pola.phone.value || '').trim();

            // Obowiązkowe są pola z `data-q-required` (ustawia je moduł według
            // ekranu Kontakty), a e-mail i wiadomość zawsze, także przy module,
            // który tego atrybutu jeszcze nie stawia.
            var wymagane = [pola.email, pola.message];
            formularz.querySelectorAll('[data-q-required]').forEach(function (pole) {
                if (wymagane.indexOf(pole) === -1) {
                    wymagane.push(pole);
                }
            });

            var puste = wymagane.filter(function (pole) {
                return pole && (pole.value || '').trim() === '';
            });

            [pola.name, pola.email, pola.phone, pola.message].forEach(function (pole) {
                oznacz(pole, puste.indexOf(pole) !== -1);
            });

            if (puste.length) {
                pokazPodpowiedz(korzen.getAttribute('data-msg-empty') || '');

                return false;
            }

            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                oznacz(pola.email, true);
                pokazPodpowiedz(korzen.getAttribute('data-msg-invalid') || '');

                return false;
            }

            // Ta sama reguła co Validate::isPhoneNumber() w rdzeniu.
            if (telefon !== '' && !/^[+0-9. ()\/-]*$/.test(telefon)) {
                oznacz(pola.phone, true);
                pokazPodpowiedz(korzen.getAttribute('data-msg-phone') || korzen.getAttribute('data-msg-empty') || '');

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

        // Okno przy produkcie ma własny przycisk. Okno zapytania ogólnego
        // (quince_contacts 0.7.0, `data-q-contact-root`) go nie ma: otwiera je
        // każdy przycisk z `data-q-contact-open` w dowolnym miejscu strony.
        var otworz = korzen.querySelector('[data-q-expert-open]');

        if (otworz) {
            otworz.addEventListener('click', function () {
                okno.showModal();
            });
        }

        var ogolne = korzen.hasAttribute('data-q-contact-root');
        var ludzie = {};
        var temat = '';
        var osoba = korzen.getAttribute('data-default') || '';

        try {
            ludzie = JSON.parse(korzen.getAttribute('data-people') || '{}') || {};
        } catch (blad) {
            ludzie = {};
        }

        /** Napis i odnośnik kafla kontaktu; pusty kafel znika. */
        function kafel(element, adres, tekst) {
            if (!element) {
                return;
            }

            element.hidden = !tekst;
            element.setAttribute('href', tekst ? adres : '#');

            var napis = element.querySelector('span');

            if (napis) {
                napis.textContent = tekst || '';
            }
        }

        /**
         * Osoba w oknie według numeru z przycisku. Numer nieznany zostawia
         * osobę domyślną: tę samą, do której serwer wtedy skieruje wiadomość.
         */
        function pokazOsobe(numer) {
            var dane = ludzie[numer] ? ludzie[numer] : ludzie[korzen.getAttribute('data-default') || ''];

            osoba = ludzie[numer] ? numer : (korzen.getAttribute('data-default') || '');

            if (!dane) {
                return;
            }

            var awatar = okno.querySelector('[data-q-expert-person-avatar]');

            if (awatar) {
                awatar.textContent = '';

                if (dane.photo) {
                    var obraz = document.createElement('img');
                    obraz.src = dane.photo;
                    obraz.alt = '';
                    obraz.width = 96;
                    obraz.height = 96;
                    awatar.appendChild(obraz);
                } else {
                    awatar.textContent = awatar.getAttribute('data-label') || '';
                }
            }

            var imie = okno.querySelector('[data-q-expert-person-name]');
            var rola = okno.querySelector('[data-q-expert-person-role]');
            var gotowe = okno.querySelector('[data-q-expert-person-done]');

            if (imie) {
                imie.textContent = dane.name || '';
            }

            if (rola) {
                rola.textContent = dane.job || '';
                rola.hidden = !dane.job;
            }

            if (gotowe) {
                gotowe.textContent = dane.name || '';
            }

            kafel(okno.querySelector('[data-q-expert-person-phone]'), 'tel:' + String(dane.phone || '').replace(/\s/g, ''), dane.phone);
            kafel(okno.querySelector('[data-q-expert-person-email]'), 'mailto:' + (dane.email || ''), dane.email);
        }

        /** Po wysłanej wiadomości kolejne otwarcie pokazuje znowu formularz. */
        function odNowa() {
            if (!potwierdzenie || potwierdzenie.hidden) {
                return;
            }

            potwierdzenie.hidden = true;

            if (formularz) {
                formularz.hidden = false;
            }

            if (wyslij) {
                wyslij.hidden = false;
            }

            if (zamknijPo) {
                zamknijPo.hidden = true;
            }

            if (pola.message) {
                pola.message.value = '';
            }
        }

        if (ogolne) {
            document.addEventListener('click', function (zdarzenie) {
                var przycisk = zdarzenie.target.closest ? zdarzenie.target.closest('[data-q-contact-open]') : null;

                if (!przycisk) {
                    return;
                }

                zdarzenie.preventDefault();
                odNowa();
                pokazOsobe((przycisk.getAttribute('data-q-contact-open') || '').trim());
                temat = (przycisk.getAttribute('data-q-contact-topic') || '').trim();
                okno.showModal();
            });
        }

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
            dane.set('phone', (pola.phone && pola.phone.value || '').trim());
            dane.set('message', (pola.message && pola.message.value || '').trim());
            dane.set('id_product', (pola.product && pola.product.value) || '0');

            // Zapytanie ogólne: osoba z przycisku, jego temat i strona, z której
            // klient pisał. Serwer przyjmuje tylko adres tego sklepu.
            if (ogolne) {
                dane.set('id_contact', osoba);
                dane.set('topic', temat);
                dane.set('page_url', window.location.href.split('#')[0]);
            }

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
