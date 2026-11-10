/* ===================================================================
   Quince — zakup na firmę w formularzu adresu

   Dwie rzeczy: przełącznik „Kupuję jako" odsłania NIP i nazwę firmy, a
   przycisk w polu NIP pobiera z rejestru nazwę i adres siedziby.

   PrestaShop nie ma pola na rodzaj kupującego. Przełącznik niesie je jako
   `quince_buyer` i czyta go silnik (`quince_engine`) przy zapisie adresu.

   Wyspa: działa tylko tam, gdzie formularz adresu stoi na stronie. Bez
   JavaScriptu widoczne zostają wszystkie pola, razem z NIP-em i nazwą firmy
   — klient wypełni je ręcznie. To nie jest awaria, tylko brak udogodnienia.
   =================================================================== */

(function () {
    'use strict';

    /* Pola firmowe rozpoznajemy po nazwie, a nie po kolejności: kolejność
       pól ustawia format adresu kraju i sprzedawca może ją zmienić. */
    var POLA_FIRMY = ['vat_number', 'company'];

    /* Szukamy w otoczeniu przełącznika, nie w całym formularzu: kasa
       jednostronicowa trzyma w jednym `<form>` zarówno wbudowany formularz
       adresu, jak i ukryty formularz w oknie modalnym „Dodaj adres" —
       oba mają pola o tych samych nazwach. Szukanie po całym formularzu
       trafiałoby w pierwszą pasującą nazwę w dokumencie, czyli w modal,
       a nie w ten formularz, który klient naprawdę widzi. Rodzic
       przełącznika to zarazem rodzic pól: oba stoją w płaskim wyjściu
       tego samego dołączenia `address-fields.tpl`. */
    function grupaPola(zasieg, nazwa) {
        var pole = zasieg.querySelector('[name="' + nazwa + '"]');
        return pole ? pole.closest('.q-float') : null;
    }

    /* Wiersz, w którym stoi pole — razem z sąsiadem, jeśli para dzieli wiersz. */
    function wierszPola(zasieg, nazwa) {
        var grupa = grupaPola(zasieg, nazwa);
        if (!grupa) return null;

        var wiersz = grupa.closest('.q-checkout2__row');
        return wiersz || grupa;
    }

    function pokazFirme(zasieg, widac) {
        var zrobione = [];

        POLA_FIRMY.forEach(function (nazwa) {
            var cel = wierszPola(zasieg, nazwa);
            if (!cel || zrobione.indexOf(cel) !== -1) return;

            zrobione.push(cel);
            cel.hidden = !widac;
        });

        /* Nazwa firmy jest wymagana tylko przy zakupie na firmę: przy osobie
           prywatnej pole jest schowane, a ukryte pole wymagane zablokowałoby
           wysłanie formularza bez żadnego widocznego powodu. */
        var nazwaFirmy = zasieg.querySelector('[name="company"]');
        if (nazwaFirmy) nazwaFirmy.required = widac;
    }

    /* Nagłówek nad polami, etykieta checkboxa „inny adres" i nagłówek panelu
       pod nim zmieniają tekst z rolą kupującego: oba warianty stoją gotowe
       w `data-text-priv`/`data-text-firm` (wpisane przez Smarty, przetłumaczone),
       JS tylko wybiera właściwy — żeby nie trzymać tłumaczeń w skrypcie. */
    function przelaczTeksty(zasieg, firma) {
        zasieg.querySelectorAll('[data-text-priv][data-text-firm]').forEach(function (el) {
            el.textContent = firma ? el.dataset.textFirm : el.dataset.textPriv;
        });
    }

    /* Telefon przy drugim adresie pokazuje się tylko wtedy, gdy ten adres
       jest adresem dostawy — czyli przy firmie. Dla osoby prywatnej drugi
       adres jest fakturą, telefon zostaje przy adresie dostawy u góry. */
    function pokazTelefonDrugiegoAdresu(zasieg, firma) {
        var wiersz = zasieg.querySelector('[data-q-other-phone-row]');
        if (wiersz) wiersz.hidden = !firma;
    }

    function ustaw(formularz) {
        var kto = formularz.querySelector('[data-q-buyer]');
        /* Znacznik gotowości na `kto`, nie na `formularz`: w OPC sam formularz
           przeżywa przebudowę sekcji adresu przez AJAX, a tylko środek
           (razem z przełącznikiem) dostaje nowe węzły. Znacznik na formularzu
           blokowałby wtedy podpięcie się pod świeży, jeszcze „martwy"
           przełącznik, bo formularz „pamiętałby" starą inicjalizację. */
        if (!kto || kto.dataset.qKtoGotowe) return;
        kto.dataset.qKtoGotowe = '1';

        var zasieg = kto.parentElement || formularz;
        var inny = zasieg.querySelector('[data-q-other-toggle]');
        var panel = zasieg.querySelector('[data-q-other-panel]');

        /* Nagłówek roli, etykieta checkboxa i nagłówek panelu stoją POZA
           `kto.parentElement` w OPC (ten jest zawężony celowo, patrz wyżej) —
           ale ich zamiana tekstu nie koliduje z polami w oknie modalnym, bo
           modal nigdy nie renderuje przełącznika „Kupuję jako" ani tych
           nagłówków. Dlatego dla samej zamiany tekstu bierzemy szerszy
           zasięg: całą kartę sekcji (OPC) albo cały krok (kasa krokowa). */
        var zasiegSzeroki = kto.closest('.one-page-checkout__section') || kto.closest('.q-step') || zasieg;

        var odswiez = function () {
            var wybrany = kto.querySelector('input[name="quince_buyer"]:checked');
            var firma = !!wybrany && wybrany.value === 'firm';

            pokazFirme(zasieg, firma);
            przelaczTeksty(zasiegSzeroki, firma);
            pokazTelefonDrugiegoAdresu(zasiegSzeroki, firma);
        };

        kto.addEventListener('change', odswiez);
        odswiez();

        /* Checkbox „inny adres": odkrywa/chowa panel od razu, bez wysyłania
           formularza — to on, nie „Dalej", robi tu robotę. */
        if (inny && panel) {
            inny.addEventListener('change', function () {
                panel.hidden = !inny.checked;
            });
        }
    }

    /* ── pobranie danych z rejestru ─────────────────────────────────── */

    function komunikat(grupa, tekst, blad) {
        /* Nota siedzi WEWNATRZ grupy pola, nie za nia. Grupa bywa komorka
           wiersza dwoch pol; nota wstawiona za nia zajmowalaby druga komorke
           i wypychala sasiada do nastepnego wiersza. */
        var nota = grupa.querySelector('[data-q-vies-info]');

        if (!nota) {
            nota = document.createElement('div');
            nota.className = 'form-text';
            nota.setAttribute('data-q-vies-info', '');
            nota.setAttribute('role', 'status');
            grupa.appendChild(nota);
        }

        nota.textContent = tekst || '';
        nota.hidden = !tekst;
        nota.classList.toggle('q-float__error', !!blad);
    }

    function wypelnij(formularz, dane) {
        Object.keys(dane).forEach(function (nazwa) {
            var pole = formularz.querySelector('[name="' + nazwa + '"]');

            /* Pustego pola z rejestru nie wpisujemy: lepiej zostawić to, co
               klient wpisał sam, niż wyczyścić mu formularz. */
            if (!pole || !dane[nazwa]) return;

            pole.value = dane[nazwa];
            pole.dispatchEvent(new Event('input', { bubbles: true }));
            pole.dispatchEvent(new Event('change', { bubbles: true }));
        });
    }

    function pobierz(formularz, przycisk) {
        var ustawienia = window.quinceCheckout;
        if (!ustawienia || !ustawienia.vies) return;

        var pole = formularz.querySelector('[name="vat_number"]');
        var grupa = pole ? pole.closest('.q-float') : null;
        if (!pole || !grupa) return;

        /* Kliknięcie przy pustym polu nie jest błędem: klient dopiero zaczyna.
           Ustawiamy mu kursor, zamiast pokazywać komunikat. */
        if (!pole.value.trim()) {
            komunikat(grupa, '', false);
            pole.focus();
            return;
        }

        /* Lista krajów rdzenia niesie identyfikator, nie kod ISO, więc kod
           rozwiązuje moduł po swojej stronie. */
        var kraj = formularz.querySelector('[name="id_country"]');
        var idKraju = kraj ? kraj.value : '';

        var napisy = ustawienia.napisy || {};
        przycisk.disabled = true;
        przycisk.textContent = napisy.pobieram || '…';
        komunikat(grupa, '', false);

        var adres = ustawienia.vies
            + (ustawienia.vies.indexOf('?') === -1 ? '?' : '&')
            + 'vat_number=' + encodeURIComponent(pole.value)
            + '&id_country=' + encodeURIComponent(idKraju);

        fetch(adres, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
            .then(function (o) { return o.json(); })
            .then(function (wynik) {
                if (wynik.stan === 'znaleziony') {
                    wypelnij(formularz, wynik.dane || {});
                }

                komunikat(grupa, wynik.komunikat || '', wynik.stan !== 'znaleziony');
            })
            .catch(function () {
                komunikat(grupa, napisy.blad || '', true);
            })
            .finally(function () {
                przycisk.disabled = false;
                przycisk.textContent = napisy.pobierz || 'VIES';
            });
    }

    function start() {
        document.querySelectorAll('form').forEach(function (formularz) {
            if (formularz.querySelector('[data-q-buyer]')) ustaw(formularz);
        });
    }

    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-q-vies]');
        if (!przycisk) return;

        var formularz = przycisk.closest('form');
        if (formularz) pobierz(formularz, przycisk);
    });

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }

    /* Kasa krokowa przerysowuje krok adresu po zmianie kraju i po przejściu
       dalej; kasa jednostronicowa (moduł `ps_onepagecheckout`) przebudowuje
       samą sekcję adresu dostawy po tych samych okazjach, ale własnym
       zdarzeniem — oba nasłuchy muszą stać obok siebie, bo każda kasa gada
       innym słownikiem zdarzeń `prestashop`. */
    if (window.prestashop && typeof prestashop.on === 'function') {
        prestashop.on('updatedAddressForm', start);
        prestashop.on('changedCheckoutStep', start);
        prestashop.on('opcDeliveryAddressUpdated', start);
    }
}());
