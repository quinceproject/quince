/* ===================================================================
   Quince: kolumna zamówienia

   Dwie rzeczy z prototypu checkoutu: zwijanie
   kolumny głową z chevronem i odsłanianie pola kodu rabatowego.

   Po zwinięciu zostaje widoczna kwota do zapłaty i stopka. Chowa się tylko
   lista pozycji i kwoty składowe.

   Wyspa: bez JavaScriptu kolumna zostaje rozwinięta, a pole kodu widoczne.
   To nie jest awaria, tylko brak udogodnienia.
   =================================================================== */

(function () {
    'use strict';

    function zwijanie(karta) {
        if (karta.dataset.qSumGotowe) return;
        karta.dataset.qSumGotowe = '1';

        var glowa = karta.querySelector('[data-q-sum-toggle]');
        if (!glowa) return;

        var ustaw = function (otwarte) {
            karta.classList.toggle('q-ordersum--open', otwarte);
            glowa.setAttribute('aria-expanded', otwarte ? 'true' : 'false');
        };

        glowa.addEventListener('click', function () {
            ustaw(!karta.classList.contains('q-ordersum--open'));
        });

        /* Kolumna startuje rozwinięta, tak jak w prototypie, także na
           wąskim ekranie, gdzie stoi nad formularzem. */
        ustaw(karta.classList.contains('q-ordersum--open'));
    }

    /* ── zgoda i przycisk zapłaty do kolumny ──────────────────────

       W prototypie zgoda na regulamin i „Zamawiam i płacę" stoją w kolumnie,
       pod kwotą. PrestaShop renderuje je w kroku płatności, bo tylko ten krok
       zna wybraną metodę i listę zgód. Smarty nie przeniesie ich wyżej, do
       szablonu strony. Dlatego przenosi je przeglądarka, całymi węzłami.

       Przenosimy węzły, a nie ich treść: skrypt rdzenia (`checkout-payment.js`)
       szuka węzła zgody po `id` (`conditions-to-approve`) i po przeniesieniu
       znajduje go tak samo. Przycisk nie musi stać w formularzu metody: rdzeń
       po kliknięciu sam wysyła formularz wybranej płatności.

       Węzeł przycisku ma dwa możliwe id, zależnie od wariantu kasy:
       `payment-confirmation` w krokowej (tam to naumyślnie ten sam węzeł,
       którym zarządza `checkout-payment.js`) i `opc-payment-confirmation-wrap`
       w OPC (inny id naumyślnie: ten sam id w OPC wystawiłby przycisk na to
       samo zarządzanie rdzenia, liczone pod kasę krokową, które gasi przycisk
       mimo kompletnego kroku; `opc-submit.js` ma własną, kompletną logikę).
       Każda pozycja niżej to lista kandydatów, bierzemy pierwszy, jaki
       istnieje na stronie.

       Tylko na szerokim ekranie. Wąski ma kolumnę NAD formularzem i jej stopkę
       schowaną; przeniesiona tam zgoda zjechałaby nad niewypełnione kroki albo
       zniknęłaby razem ze stopką, i zamówienia nie dałoby się złożyć. Dlatego
       na telefonie zostają w kroku płatności, tak jak w prototypie.

       OPC osobno: moduł (`opc-submit.js`, `getConditionsToApproveInputs`)
       szuka pola zgody TYLKO wewnątrz `.one-page-checkout__footer`, ani
       globalnie, ani po samym id, jak robi to skrypt kasy krokowej. Po
       przeniesieniu węzła do kolumny ten pasek zostaje pusty i moduł nie
       widzi zaznaczonej zgody wcale: przycisk włącza się (bo walidacja
       klienta na pustym zestawie pól wychodzi „bez błędu"), ale `opcsubmit`
       odrzuca zamówienie serwerowym błędem „Please accept the terms of
       service", mimo zaznaczonego checkboxa. Klasę `.one-page-checkout__footer`
       przenosimy więc razem z węzłem `#conditions-to-approve` (patrz
       `ustawKlaseStopki` niżej). W kasie krokowej ta klasa nigdzie nie
       występuje, więc tam to i tak nic nie zmienia. */

    var SZEROKI = '(min-width: 992px)';
    var PRZENOSZONE = [
        ['conditions-to-approve'],
        ['payment-confirmation', 'opc-payment-confirmation-wrap']
    ];
    var KLASA_STOPKI_OPC = 'one-page-checkout__footer';

    var licznik = 0;

    function zapamietajDom(wezel) {
        if (wezel.dataset.qDom) return;

        licznik += 1;
        wezel.dataset.qDom = wezel.id || ('q-dom-' + licznik);

        var znacznik = document.createElement('span');
        znacznik.hidden = true;
        znacznik.setAttribute('data-q-dom-dla', wezel.dataset.qDom);
        wezel.parentElement.insertBefore(znacznik, wezel);
    }

    function wrocDoDomu(wezel) {
        var dom = document.querySelector('[data-q-dom-dla="' + wezel.dataset.qDom + '"]');
        if (dom && wezel.previousElementSibling !== dom) {
            dom.parentElement.insertBefore(wezel, dom.nextSibling);
        }
    }

    /* Węzeł zgody (`#conditions-to-approve`) nosi `.one-page-checkout__footer`
       tylko gdy faktycznie tam stoi, czyli na przemian z opakowaniem OPC
       (`[data-q-pay-source]`), nigdy oba naraz. `document.querySelector`
       bierze pierwsze trafienie w dokumencie: gdyby klasa została na obu,
       `opc-submit.js` zawsze znalazłby najpierw (puste po przeniesieniu)
       opakowanie, nie węzeł zgody. */
    function ustawKlaseStopki(wezelWarunkow, szeroko) {
        var oryginalnyPasek = document.querySelector('[data-q-pay-source]');

        if (szeroko) {
            if (oryginalnyPasek) oryginalnyPasek.classList.remove(KLASA_STOPKI_OPC);
            wezelWarunkow.classList.add(KLASA_STOPKI_OPC);
        } else {
            wezelWarunkow.classList.remove(KLASA_STOPKI_OPC);
            if (oryginalnyPasek) oryginalnyPasek.classList.add(KLASA_STOPKI_OPC);
        }
    }

    function doKolumny() {
        var miejsce = document.querySelector('[data-q-pay-slot]');
        if (!miejsce) return;

        var szeroko = window.matchMedia(SZEROKI).matches;

        PRZENOSZONE.forEach(function (kandydaci) {
            var wezel = null;
            for (var i = 0; i < kandydaci.length; i += 1) {
                wezel = document.getElementById(kandydaci[i]);
                if (wezel) break;
            }
            if (!wezel) return;

            zapamietajDom(wezel);

            if (kandydaci[0] === 'conditions-to-approve') {
                ustawKlaseStopki(wezel, szeroko);
            }

            if (szeroko) {
                if (wezel.parentElement !== miejsce) miejsce.appendChild(wezel);
                return;
            }

            wrocDoDomu(wezel);
        });

        /* Pasek, z którego przycisk odszedł, zostaje pustą szarą belką.
           `:empty` go nie złapie, bo w środku są jeszcze białe znaki. */
        document.querySelectorAll('[data-q-pay-source]').forEach(function (pasek) {
            /* Znacznik miejsca też jest dzieckiem, a nie liczy się jako treść. */
            var tresc = [].filter.call(pasek.children, function (e) {
                return !e.hasAttribute('data-q-dom-dla');
            });

            pasek.hidden = tresc.length === 0;
        });
    }

    function start() {
        document.querySelectorAll('[data-q-sum]').forEach(zwijanie);
        doKolumny();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }

    /* Rdzeń przerysowuje kolumnę po zmianie przewoźnika i po przejściu dalej. */
    /* Obrócenie telefonu albo zmiana szerokości okna przenosi zgodę
       i przycisk w drugą stronę. */
    window.matchMedia(SZEROKI).addEventListener('change', doKolumny);

    if (window.prestashop && typeof prestashop.on === 'function') {
        prestashop.on('updatedCart', start);
        prestashop.on('changedCheckoutStep', start);
    }
}());
