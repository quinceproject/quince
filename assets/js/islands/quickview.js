/**
 * Quince — szybki podgląd produktu.
 *
 * Oko na zajawce dociąga z rdzenia treść podglądu (`action=quickview`)
 * i wsuwa ją w szufladę. Szuflada jest jedna na całą stronę i powstaje przy
 * pierwszym otwarciu: dwadzieścia zajawek na listingu to nie powód, żeby
 * trzymać w kodzie strony dwadzieścia pustych okien.
 *
 * Bez tego pliku oko nic nie robi, a klient wchodzi na kartę produktu
 * odnośnikiem, który i tak jest na zajawce.
 *
 * Projekt: makieta strony produktu, szuflada „podglad".
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    var szuflada = null;

    Quince.register('.js-quickview', function (przycisk) {
        przycisk.addEventListener('click', function (zdarzenie) {
            zdarzenie.preventDefault();
            otworz(przycisk);
        });
    });

    /** Szuflada powstaje raz i wraca przy każdym kolejnym podglądzie. */
    function panel(przycisk) {
        if (szuflada) {
            return szuflada;
        }

        szuflada = document.createElement('dialog');
        szuflada.className = 'q-modal q-modal--drawer q-modal--quickview';
        szuflada.setAttribute('data-q-quickview', '');
        szuflada.innerHTML =
            '<div class="q-modal__head">'
            + '<h2 class="q-modal__title">'
            + '<svg class="q-modal__icon" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5s3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5s-3.879-1.168-5.168-2.457A13 13 0 0 1 1.172 8z"/><path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/></svg>'
            + '<span data-q-quickview-title></span>'
            + '</h2>'
            + '<button class="q-modal__close" type="button" data-q-quickview-close>'
            + '<svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>'
            + '</button>'
            + '</div>'
            + '<div class="q-modal__body" data-q-quickview-content></div>'
            + '<div class="q-modal__foot" data-q-quickview-footer-slot hidden></div>';

        document.body.appendChild(szuflada);

        // Napisy przychodzą z przycisku na zajawce, żeby wyspa nie znała języka
        // sklepu: oko ma je już przetłumaczone przez szablon.
        szuflada.querySelector('[data-q-quickview-title]').textContent = przycisk.getAttribute('title') || '';
        szuflada.querySelector('[data-q-quickview-close]')
            .setAttribute('aria-label', przycisk.getAttribute('data-q-quickview-close') || '');

        szuflada.addEventListener('click', function (zdarzenie) {
            if (zdarzenie.target.closest('[data-q-quickview-close]')) {
                szuflada.close();

                return;
            }

            // Przełączenie zdjęcia miniaturą albo kropką.
            var wybor = zdarzenie.target.closest('[data-q-quickview-photo]');

            if (wybor) {
                showPhoto(wybor);

                return;
            }

            // Kliknięcie w tło: `dialog` nie odróżnia go sam, więc porównujemy
            // miejsce kliknięcia z prostokątem panelu.
            if (zdarzenie.target === szuflada) {
                var r = szuflada.getBoundingClientRect();
                var wSrodku = zdarzenie.clientX >= r.left && zdarzenie.clientX <= r.right
                    && zdarzenie.clientY >= r.top && zdarzenie.clientY <= r.bottom;

                if (!wSrodku) {
                    szuflada.close();
                }
            }
        });

        return szuflada;
    }

    function showPhoto(wybor) {
        var main = szuflada.querySelector('[data-q-quickview-main]');
        var adres = wybor.getAttribute('data-q-quickview-photo');

        if (!main || !adres || main.getAttribute('src') === adres) {
            return;
        }

        szuflada.querySelectorAll('[data-q-quickview-photo]').forEach(function (inny) {
            inny.classList.toggle('is-active', inny === wybor);
        });

        // Przenikanie zamiast cięcia: zdjęcie gaśnie, podmienia się i wraca.
        main.classList.add('is-zmiana');

        window.setTimeout(function () {
            main.src = adres;
            main.classList.remove('is-zmiana');
        }, 150);
    }

    function otworz(przycisk) {
        var okno = panel(przycisk);
        var karta = przycisk.closest('.js-product-miniature');
        var odnosnik = karta && karta.querySelector('a[href]');

        if (!odnosnik || typeof okno.showModal !== 'function') {
            return;
        }

        /* Adres składamy przez `URL`, a nie doklejeniem znaku zapytania:
           odnośnik zajawki nosi kotwicę wybranej wersji (`#/1-rozmiar-s`),
           więc doklejone parametry lądowały w kotwicy i rdzeń oddawał zwykłą
           stronę zamiast odpowiedzi podglądu. */
        var adres = new URL(odnosnik.href, window.location.href);

        adres.hash = '';
        adres.searchParams.set('action', 'quickview');
        adres.searchParams.set('ajax', '1');

        if (karta.getAttribute('data-id-product-attribute')) {
            adres.searchParams.set('id_product_attribute', karta.getAttribute('data-id-product-attribute'));
        }

        przycisk.setAttribute('aria-busy', 'true');

        fetch(adres.href, { credentials: 'same-origin', headers: { Accept: 'application/json', 'X-Requested-With': 'XMLHttpRequest' } })
            .then(function (odpowiedz) {
                return odpowiedz.json();
            })
            .then(function (wynik) {
                if (!wynik || !wynik.quickview_html) {
                    return;
                }

                var content = okno.querySelector('[data-q-quickview-content]');
                var footer = okno.querySelector('[data-q-quickview-footer-slot]');

                content.innerHTML = wynik.quickview_html;
                content.scrollTop = 0;

                /* Odnośnik do pełnej karty przenosimy do stopki panelu: ma zostać
                   na widoku, gdy treść podglądu przewija się w środku. */
                var toFooter = content.querySelector('[data-q-quickview-footer]');

                footer.innerHTML = '';
                footer.hidden = !toFooter;

                if (toFooter) {
                    footer.appendChild(toFooter);
                }

                // Licznik ilości, „Kup teraz", serce i zegar to te same wyspy,
                // co na karcie produktu — treść przyszła po wczytaniu strony,
                // więc trzeba je uruchomić na niej ręcznie.
                Quince.hydrate(okno);

                okno.showModal();
            })
            .catch(function () {
                // Podgląd jest udogodnieniem: gdy nie przyszedł, zostaje
                // odnośnik na zajawce i klient wchodzi na kartę produktu.
            })
            .then(function () {
                przycisk.removeAttribute('aria-busy');
            });
    }
})();
