/* ===================================================================
   Quince: przejście między krokami wstecz

   Rdzeń renderuje wszystkie kroki naraz w jednej stronie i pokazuje
   bieżący klasami (`active`, `show`, `q-step--current`); przejście DALEJ to
   zwykłe wysłanie formularza i przeładowanie strony przez serwer, ale
   przejścia WSTECZ serwer nie obsługuje wcale. Dane wcześniejszego kroku
   już leżą w DOM-ie, więc trzeba tylko przełączyć, który krok jest widoczny.

   Rdzeń liczy na to, że zrobi to JS motywu, stąd `js-back` i `data-step`
   w znacznikach przycisku.
   =================================================================== */

(function () {
    'use strict';

    /* Nagłówek kroku ma trzy warianty tytułu i dwa warianty czynności przy
       nim ([]„Zmień" / „Zaloguj się" itp.) gotowe w DOM-ie naraz, chowane
       atrybutem `hidden`. Przełączenie kroku tu musi je odkryć/schować
       razem z samymi klasami `q-step--*`, inaczej zostaje nagłówek
       z poprzedniego stanu, jak przy kroku bieżącym pokazanym z „Zmień"
       i bez „Zaloguj się". */
    function pokazJakoUkonczony(krok) {
        var otwarty = krok.querySelector('[data-q-step-title-open]');
        var ukonczony = krok.querySelector('[data-q-step-title-done]');
        var zwykly = krok.querySelector('[data-q-step-title-plain]');
        var zmien = krok.querySelector('[data-q-step-change]');
        var aside = krok.querySelector('[data-q-step-aside]');
        var podsumowanie = krok.querySelector('[data-q-step-summary]');

        if (otwarty) otwarty.hidden = true;
        if (zwykly) zwykly.hidden = true;
        if (ukonczony) ukonczony.hidden = false;
        if (zmien) zmien.hidden = false;
        if (aside) aside.hidden = true;
        if (podsumowanie) podsumowanie.hidden = false;
    }

    function pokazJakoBiezacy(krok) {
        var otwarty = krok.querySelector('[data-q-step-title-open]');
        var ukonczony = krok.querySelector('[data-q-step-title-done]');
        var zwykly = krok.querySelector('[data-q-step-title-plain]');
        var zmien = krok.querySelector('[data-q-step-change]');
        var aside = krok.querySelector('[data-q-step-aside]');
        var podsumowanie = krok.querySelector('[data-q-step-summary]');

        if (zwykly) zwykly.hidden = true;
        if (ukonczony) ukonczony.hidden = true;
        if (otwarty) otwarty.hidden = false;
        if (zmien) zmien.hidden = true;
        if (aside) aside.hidden = false;
        if (podsumowanie) podsumowanie.hidden = true;
    }

    function przelacz(docelowy) {
        var biezacy = document.querySelector('.q-step--current');
        if (!docelowy || docelowy === biezacy) return;

        if (biezacy) {
            biezacy.classList.remove('q-step--current', 'active', 'show');
            /* Krok, z którego klient wraca, ma już zapisane dane,
               więc zostaje oznaczony jako ukończony, nie jako nieosiągalny. */
            biezacy.classList.add('q-step--done');
            biezacy.classList.remove('q-step--upcoming');
            pokazJakoUkonczony(biezacy);
        }

        docelowy.classList.add('q-step--current', 'active', 'show');
        docelowy.classList.remove('q-step--done', 'q-step--upcoming');
        pokazJakoBiezacy(docelowy);

        docelowy.scrollIntoView({ block: 'start', behavior: 'smooth' });

        var tytul = docelowy.querySelector('h1, .js-step-title');
        if (tytul) tytul.focus({ preventScroll: true });

        if (window.prestashop && typeof prestashop.emit === 'function') {
            prestashop.emit('changedCheckoutStep', { step: docelowy.id });
        }
    }

    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-step].js-back, .js-back[data-step]');
        if (!przycisk) return;

        zdarzenie.preventDefault();
        przelacz(document.getElementById(przycisk.getAttribute('data-step')));
    });
}());
