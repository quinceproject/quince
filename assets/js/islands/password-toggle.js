/* ===================================================================
   Quince — podgląd hasła

   Przycisk w polu hasła przełącza je między zasłoniętym a odsłoniętym.
   PrestaShop daje na ten przycisk zaczep `data-ps-action="toggle-password"`,
   ale obsługę trzyma w pakiecie skryptów swojego motywu, którego Quince nie
   ładuje — przycisk stał martwy.

   Wyspa: bez JavaScriptu przycisku nie ma po co pokazywać, więc skrypt sam
   go odsłania. Hasło zostaje wtedy zasłonięte, czyli tak, jak działa pole
   hasła bez żadnego dodatku.
   =================================================================== */

(function () {
    'use strict';

    function przelacz(przycisk) {
        var pole = document.getElementById(przycisk.getAttribute('aria-controls'));
        if (!pole) return;

        var odslaniamy = pole.type === 'password';
        pole.type = odslaniamy ? 'text' : 'password';

        przycisk.classList.toggle('q-float__eye--on', odslaniamy);
        przycisk.setAttribute(
            'aria-label',
            odslaniamy ? przycisk.dataset.textHide : przycisk.dataset.textShow
        );

        /* Ognisko wraca do pola, żeby klient pisał dalej od miejsca, w którym
           przerwał. Zmiana `type` przesuwa kursor na początek, więc ustawiamy
           go z powrotem na koniec. */
        var koniec = pole.value.length;
        pole.focus();

        try {
            pole.setSelectionRange(koniec, koniec);
        } catch (e) {
            /* Część przeglądarek nie pozwala na zaznaczenie w polu hasła. */
        }
    }

    function start() {
        document.querySelectorAll('[data-q-eye]').forEach(function (przycisk) {
            przycisk.hidden = false;
        });
    }

    document.addEventListener('click', function (zdarzenie) {
        var przycisk = zdarzenie.target.closest('[data-q-eye]');
        if (przycisk) przelacz(przycisk);
    });

    /* ── konto zakładane przy zamówieniu ───────────────────────────

       Pole hasła w kasie stoi schowane do chwili, w której klient zaznaczy
       „Załóż konto". Rdzeń daje na to zaczepy `js-password-form__check`
       i `js-password-form__input-wrapper`, ale obsługę trzyma w pakiecie
       skryptów swojego motywu — bez niej pole nie wychodziło nigdy i konta
       nie dało się założyć.

       Odznaczenie czyści wpisane hasło: hasło zostające w schowanym polu
       założyłoby konto, choć klient się z tego wycofał. */
    document.addEventListener('change', function (zdarzenie) {
        var ptaszek = zdarzenie.target.closest('.js-password-form__check');
        if (!ptaszek) return;

        var zasieg = ptaszek.closest('form') || document;
        var opakowanie = zasieg.querySelector('.js-password-form__input-wrapper');
        if (!opakowanie) return;

        opakowanie.classList.toggle('d-none', !ptaszek.checked);

        var pole = opakowanie.querySelector('input[name="password"]');
        if (!pole) return;

        if (ptaszek.checked) {
            pole.focus();
        } else {
            pole.value = '';
        }
    });

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }

    /* Kasa przerysowuje kroki po każdym przejściu dalej. */
    if (window.prestashop && typeof prestashop.on === 'function') {
        prestashop.on('changedCheckoutStep', start);
    }
}());
