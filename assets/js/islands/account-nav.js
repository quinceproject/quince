/**
 * Quince: sidebar konta na telefonie
 *
 * Na szerokim ekranie to zwykła, pionowa lista, nic do zrobienia. Poniżej
 * 992px staje się rozwijaną listą: przycisk pokazuje bieżącą pozycję,
 * kliknięcie otwiera resztę jako panel nad treścią.
 *
 * Etykieta przycisku bierze się z pozycji oznaczonej `is-active` w samej
 * liście, nie z osobnego źródła: dwa miejsca z tą samą nazwą prędzej czy
 * później się rozjadą. Bez skryptu przycisk pokazuje stałe „Moje konto”
 * (patrz szablon) i lista jest zawsze widoczna, tyle że bez rozwijania.
 */
(function () {
    'use strict';

    Quince.register('[data-q-account-nav]', function (nav) {
        var trigger = nav.querySelector('[data-q-account-nav-trigger]');
        var list = nav.querySelector('.q-account-nav__list');

        if (!trigger || !list) {
            return;
        }

        var label = trigger.querySelector('[data-q-account-nav-trigger-label]');
        var active = list.querySelector('.q-account-nav__item.is-active a, .q-account-nav__item.is-active button');

        if (label && active) {
            var tekst = active.textContent.replace(/\s+/g, ' ').trim();

            if (tekst) {
                label.textContent = tekst;
            }
        }

        function open(state) {
            list.classList.toggle('is-open', state);
            trigger.setAttribute('aria-expanded', state ? 'true' : 'false');
        }

        trigger.addEventListener('click', function () {
            open(!list.classList.contains('is-open'));
        });

        document.addEventListener('click', function (event) {
            if (list.classList.contains('is-open') && !nav.contains(event.target)) {
                open(false);
            }
        });

        nav.addEventListener('keydown', function (event) {
            if (event.key === 'Escape' && list.classList.contains('is-open')) {
                open(false);
                trigger.focus();
            }
        });

        // Wybór pozycji z poziomu panelu zamyka go. Inaczej lista zostaje
        // rozwinięta nad nową treścią, kiedy strona wczyta się z pamięci wstecz.
        list.addEventListener('click', function (event) {
            if (event.target.closest('a, button')) {
                open(false);
            }
        });
    });
})();
