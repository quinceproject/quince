/**
 * Pytania o produkt: doładowanie kolejnych porcji i szuflada z pytaniem.
 *
 * Pierwsza porcja wychodzi z serwera, więc bez tego pliku sekcja nadal pokazuje
 * pytania z odpowiedziami — znika tylko doładowanie i formularz.
 *
 * Znaczniki doładowanych pytań przychodzą gotowe z kontrolera modułu, a nie
 * powstają tutaj: gdyby pytanie rysował także JavaScript, dwa zapisy tego samego
 * rozjechałyby się przy pierwszej poprawce wyglądu.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    Quince.register('[data-q-qa]', function (korzen) {
        doladowanie(korzen);
        szuflada(korzen);
    });

    /** Przycisk dokłada kolejną porcję pod ostatnim pytaniem, nie zastępuje listy. */
    function doladowanie(korzen) {
        var adres = korzen.getAttribute('data-url');
        var produkt = korzen.getAttribute('data-product');
        var lista = korzen.querySelector('[data-q-qa-list]');
        var wiecej = korzen.querySelector('[data-q-qa-more]');
        var strona = 1;

        if (!adres || !lista || !wiecej) {
            return;
        }

        wiecej.addEventListener('click', function () {
            wiecej.disabled = true;

            var pytanie = adres
                + (adres.indexOf('?') === -1 ? '?' : '&')
                + 'id_product=' + encodeURIComponent(produkt)
                + '&page=' + (strona + 1);

            fetch(pytanie, {
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                credentials: 'same-origin'
            }).then(function (odpowiedz) {
                return odpowiedz.json();
            }).then(function (wynik) {
                if (!wynik || !wynik.ok) {
                    return;
                }

                var pojemnik = document.createElement('div');
                pojemnik.innerHTML = wynik.html;

                while (pojemnik.firstElementChild) {
                    lista.appendChild(pojemnik.firstElementChild);
                }

                strona = wynik.page;

                // Przycisk znika, gdy nie ma czego dokładać: zostawiony
                // obiecywałby więcej pytań, niż ich jest.
                if (!wynik.hasMore) {
                    wiecej.remove();
                }
            }).catch(function () {
                // Cisza jest tu lepsza niż komunikat: pytania już widoczne
                // zostają, a klient może kliknąć jeszcze raz.
            }).then(function () {
                if (wiecej.isConnected) {
                    wiecej.disabled = false;
                }
            });
        });
    }

    /** Szuflada z formularzem: otwarcie, sprawdzenie pól, wysyłka. */
    function szuflada(korzen) {
        var okno = korzen.querySelector('[data-q-qa-form]');
        var otworz = korzen.querySelector('[data-q-qa-open]');
        var adres = korzen.getAttribute('data-url-ask');

        if (!okno || !otworz || typeof okno.showModal !== 'function') {
            return;
        }

        var pola = okno.querySelector('[data-q-qa-fields]');
        var potwierdzenie = okno.querySelector('[data-q-qa-done]');
        var potwierdzenieTekst = okno.querySelector('[data-q-qa-done-text]');
        var podpowiedz = okno.querySelector('[data-q-qa-hint]');
        var wyslij = okno.querySelector('[data-q-qa-send]');
        var zamknijPo = okno.querySelector('[data-q-qa-done-close]');
        var tresc = okno.querySelector('[data-q-qa-question]');
        var imie = okno.querySelector('[data-q-qa-name]');
        var email = okno.querySelector('[data-q-qa-email]');

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
            var pytanie = (tresc && tresc.value || '').trim();
            var adresEmail = (email && email.value || '').trim();
            var podpis = (imie && imie.value || '').trim();

            oznacz(tresc, false);
            oznacz(email, false);
            oznacz(imie, false);

            if (pytanie === '' || (imie && podpis === '') || (email && adresEmail === '')) {
                oznacz(tresc, pytanie === '');
                oznacz(imie, imie && podpis === '');
                oznacz(email, email && adresEmail === '');
                pokazPodpowiedz(korzen.getAttribute('data-msg-empty') || '');

                return false;
            }

            if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(adresEmail)) {
                oznacz(email, true);
                pokazPodpowiedz(korzen.getAttribute('data-msg-invalid') || '');

                return false;
            }

            pokazPodpowiedz('');

            return true;
        }

        otworz.addEventListener('click', function () {
            okno.showModal();
        });

        okno.querySelectorAll('[data-q-qa-close]').forEach(function (przycisk) {
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

        if (!wyslij || !adres) {
            return;
        }

        wyslij.addEventListener('click', function () {
            if (!wypelnione()) {
                (tresc || {}).focus && tresc.focus();

                return;
            }

            var dane = new URLSearchParams();
            dane.set('id_product', korzen.getAttribute('data-product'));
            dane.set('question', (tresc && tresc.value || '').trim());

            if (imie) {
                dane.set('name', imie.value.trim());
            }

            if (email) {
                dane.set('email', email.value.trim());
            }

            var straznik = okno.querySelector('[data-q-qa-guard]');

            if (straznik) {
                straznik.querySelectorAll('input[name]').forEach(function (pole) {
                    dane.set(pole.name, pole.value);
                });
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
                if (!wynik || !wynik.ok) {
                    pokazPodpowiedz(korzen.getAttribute('data-msg-failure') || '');

                    return;
                }

                if (pola) {
                    pola.hidden = true;
                }

                if (potwierdzenie) {
                    potwierdzenie.hidden = false;
                }

                if (potwierdzenieTekst) {
                    // O tym, czy sklep czyta pytania przed odpowiedzią, mówi
                    // jego ustawienie, a nie odpowiedź serwera.
                    potwierdzenieTekst.textContent = korzen.getAttribute(
                        korzen.getAttribute('data-moderated') === '1'
                            ? 'data-msg-moderated'
                            : 'data-msg-sent'
                    ) || '';
                }

                wyslij.hidden = true;

                if (zamknijPo) {
                    zamknijPo.hidden = false;
                    zamknijPo.focus();
                }
            }).catch(function () {
                pokazPodpowiedz(korzen.getAttribute('data-msg-failure') || '');
            }).then(function () {
                wyslij.disabled = false;
            });
        });
    }
}());
