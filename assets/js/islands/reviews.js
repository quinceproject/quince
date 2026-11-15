/**
 * Opinie o produkcie: doładowanie kolejnych porcji, głos „przydatne"
 * i szuflada pisania opinii.
 *
 * Pierwsza porcja i podsumowanie wychodzą z serwera, więc bez tego pliku sekcja
 * nadal pokazuje opinie. Znika tylko doładowanie, głosowanie i formularz.
 *
 * Znaczniki doładowanych opinii przychodzą gotowe z kontrolera silnika, a nie
 * powstają tutaj: gdyby opinię rysował także JavaScript, dwa zapisy tego samego
 * rozjechałyby się przy pierwszej poprawce wyglądu.
 *
 * Wysyłka opinii i głosowanie idą do punktów końcowych modułu `productcomments`:
 * moderacja, kryteria i zapis do bazy zostają po jego stronie.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    Quince.register('[data-q-reviews]', function (korzen) {
        var adresListy = korzen.getAttribute('data-url');
        var adresWysylki = korzen.getAttribute('data-url-post');
        var adresGlosu = korzen.getAttribute('data-url-useful');
        var produkt = korzen.getAttribute('data-product');

        doladowanie(korzen, adresListy, produkt);
        glosowanie(korzen, adresGlosu);
        szuflada(korzen, adresWysylki, produkt);
    });

    /** Przycisk dokłada kolejną porcję pod ostatnią opinią, nie zastępuje listy. */
    function doladowanie(korzen, adres, produkt) {
        var lista = korzen.querySelector('[data-q-reviews-list]');
        var wiecej = korzen.querySelector('[data-q-reviews-more]');
        var strona = 1;

        if (!adres || !lista || !wiecej) {
            return;
        }

        wiecej.addEventListener('click', function () {
            wiecej.disabled = true;

            fetch(zPytaniem(adres, { id_product: produkt, page: strona + 1 }), {
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
                // obiecywałby więcej opinii, niż ich jest.
                if (!wynik.hasMore) {
                    wiecej.remove();
                }
            }).catch(function () {
                // Cisza jest tu lepsza niż komunikat: opinie już widoczne
                // zostają, a klient może kliknąć jeszcze raz.
            }).then(function () {
                if (wiecej.isConnected) {
                    wiecej.disabled = false;
                }
            });
        });
    }

    /**
     * Głos „przydatne".
     *
     * Nasłuch stoi na liście, a nie na przycisku, bo opinie dochodzą po
     * doładowaniu i wtedy własnego nasłuchu by nie miały.
     */
    function glosowanie(korzen, adres) {
        var lista = korzen.querySelector('[data-q-reviews-list]');

        if (!adres || !lista) {
            return;
        }

        lista.addEventListener('click', function (zdarzenie) {
            var przycisk = zdarzenie.target.closest('[data-q-review-helpful]');

            if (!przycisk) {
                return;
            }

            var opinia = przycisk.closest('[data-q-review]');
            var licznik = przycisk.querySelector('[data-q-review-helpful-count]');

            if (!opinia) {
                return;
            }

            przycisk.disabled = true;

            var dane = new URLSearchParams();
            dane.set('id_product_comment', opinia.getAttribute('data-q-review'));
            dane.set('usefulness', '1');

            fetch(adres, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                credentials: 'same-origin',
                body: dane.toString()
            }).then(function (odpowiedz) {
                return odpowiedz.json();
            }).then(function (wynik) {
                // Moduł odmawia głosu gościowi i temu, kto już głosował.
                // Przycisk zostaje wtedy nieklikalny, bez komunikatu: to nie
                // jest błąd, tylko koniec sprawy.
                if (!wynik || !wynik.success || !licznik) {
                    return;
                }

                // Liczba jedzie w atrybucie, a zdanie powstaje ze wzorca
                // z tłumaczenia. Wydłubywanie cyfr z gotowego zdania psułoby się
                // w każdym języku, który zapisuje liczby inaczej.
                var ile = parseInt(licznik.getAttribute('data-count'), 10) + 1;
                var wzorzec = korzen.getAttribute('data-msg-helpful') || '';

                licznik.setAttribute('data-count', String(ile));
                licznik.textContent = wzorzec.replace('%count%', String(ile));
                licznik.hidden = false;
            }).catch(function () {
                przycisk.disabled = false;
            });
        });
    }

    /** Szuflada z formularzem: otwarcie, sprawdzenie pól, wysyłka. */
    function szuflada(korzen, adres, produkt) {
        var okno = korzen.querySelector('[data-q-review-form]');
        var otworz = korzen.querySelector('[data-q-review-open]');

        if (!okno || !otworz || typeof okno.showModal !== 'function') {
            return;
        }

        var pola = okno.querySelector('[data-q-review-fields]');
        var potwierdzenie = okno.querySelector('[data-q-review-done]');
        var potwierdzenieTekst = okno.querySelector('[data-q-review-done-text]');
        var podpowiedz = okno.querySelector('[data-q-review-hint]');
        var wyslij = okno.querySelector('[data-q-review-send]');
        var zamknijPo = okno.querySelector('[data-q-review-done-close]');
        var tytul = okno.querySelector('[data-q-review-title]');
        var tresc = okno.querySelector('[data-q-review-content]');
        var podpis = okno.querySelector('[data-q-review-name]');

        function pokazPodpowiedz(tekst) {
            if (!podpowiedz) {
                return;
            }

            podpowiedz.textContent = tekst || '';
            podpowiedz.hidden = !tekst;
        }

        otworz.addEventListener('click', function () {
            okno.showModal();
        });

        okno.querySelectorAll('[data-q-review-close]').forEach(function (przycisk) {
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
            var oceny = okno.querySelectorAll('[data-q-review-criterion]');
            var braki = false;
            var dane = new URLSearchParams();

            oceny.forEach(function (zestaw) {
                var wybrana = zestaw.querySelector('input:checked');

                if (!wybrana) {
                    braki = true;

                    return;
                }

                dane.set(wybrana.name, wybrana.value);
            });

            var tytulTekst = (tytul && tytul.value || '').trim();
            var trescTekst = (tresc && tresc.value || '').trim();
            var podpisTekst = (podpis && podpis.value || '').trim();

            if (braki || tytulTekst === '' || trescTekst === '' || (podpis && podpisTekst === '')) {
                pokazPodpowiedz(korzen.getAttribute('data-msg-empty') || '');

                return;
            }

            pokazPodpowiedz('');

            dane.set('id_product', produkt);
            dane.set('comment_title', tytulTekst);
            dane.set('comment_content', trescTekst);

            if (podpis) {
                dane.set('customer_name', podpisTekst);
            }

            var straznik = okno.querySelector('[data-q-review-guard]');

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
                if (!wynik || !wynik.success) {
                    // Komunikat modułu bywa ze znacznikami w środku, a wypisujemy
                    // go jako tekst. Bez tego klient zobaczyłby gołe `<a href>`.
                    pokazPodpowiedz(
                        bezZnacznikow(wynik && wynik.error)
                        || korzen.getAttribute('data-msg-failure')
                        || ''
                    );

                    return;
                }

                if (pola) {
                    pola.hidden = true;
                }

                if (potwierdzenie) {
                    potwierdzenie.hidden = false;
                }

                if (potwierdzenieTekst) {
                    // O moderacji mówi ustawienie sklepu, nie odpowiedź modułu:
                    // ta niesie samo `success` i treść opinii, więc nie da się
                    // z niej wyczytać, czy opinia jest już widoczna.
                    potwierdzenieTekst.textContent = korzen.getAttribute(
                        korzen.getAttribute('data-moderated') === '1'
                            ? 'data-msg-moderated'
                            : 'data-msg-published'
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

    /**
     * Tekst komunikatu bez znaczników.
     *
     * Odpowiedź modułu bywa zdaniem z odnośnikami. Wypisujemy ją jako tekst,
     * więc znaczniki trzeba zdjąć, zamiast wstawiać cudzy kod do strony.
     */
    function bezZnacznikow(tekst) {
        if (!tekst) {
            return '';
        }

        // DOMParser buduje osobny dokument, w którym nic się nie wykonuje.
        // `innerHTML` na odłączonym elemencie i tak ładuje obrazki i odpala `onerror`.
        var dokument = new DOMParser().parseFromString(String(tekst), 'text/html');

        return (dokument.body.textContent || '').trim();
    }

    /** Adres z doklejonymi parametrami, niezależnie od tego, czy już je miał. */
    function zPytaniem(adres, parametry) {
        var pytanie = new URLSearchParams(parametry).toString();

        return adres + (adres.indexOf('?') === -1 ? '?' : '&') + pytanie;
    }
}());
