/**
 * Skok do sekcji akordeonu na karcie produktu.
 *
 * Sam skok pod kotwicę zostawia zwiniętą sekcję: klient trafia na nagłówek
 * akordeonu i musi kliknąć drugi raz, żeby zobaczyć to, po co przyszedł.
 * Otwieramy ją więc od razu.
 *
 * Jedna wyspa na wszystkie takie odnośniki („Pełna specyfikacja" pod cechami,
 * ocena pod nazwą produktu), bo robią dokładnie to samo. Osobne pliki
 * rozjechałyby się przy pierwszej poprawce.
 *
 * Odstęp od przyklejonego nagłówka robi arkusz (`scroll-margin`), a nie
 * przeliczanie pozycji w skrypcie: przeglądarka zna wysokość paska i sama
 * uwzględnia margines przy skoku do kotwicy.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    Quince.register('[data-q-do-sekcji]', function (odnosnik) {
        odnosnik.addEventListener('click', function (zdarzenie) {
            var cel = document.querySelector(odnosnik.getAttribute('href'));

            if (!cel) {
                return;
            }

            zdarzenie.preventDefault();

            if (cel.tagName === 'DETAILS') {
                cel.open = true;
            }

            cel.scrollIntoView({ behavior: 'smooth', block: 'start' });

            // Adres zostaje z kotwicą: odświeżenie strony wraca w to samo miejsce,
            // a odnośnik da się skopiować i wysłać.
            if (window.history && window.history.replaceState) {
                window.history.replaceState(null, '', odnosnik.getAttribute('href'));
            }
        });
    });
}());
