/**
 * Quince: select (język, waluta, kraj dostawy)
 *
 * Otwiera i zamyka listę przy przycisku. Sama zmiana jest przejściem pod adres
 * pozycji, więc skrypt nie odpowiada za nic poza pokazaniem listy. Bez niego
 * przełączenie języka nadal działa, tylko lista zostaje rozwinięta na stałe.
 *
 * Projekt: widok paska górnego.
 */
(function () {
    'use strict';

    Quince.register('[data-q-picker]', function (picker) {
        var button = picker.querySelector('[data-q-picker-button]');
        var menu = picker.querySelector('[data-q-dropdown]');

        if (!button || !menu) {
            return;
        }

        function open(state) {
            menu.hidden = !state;
            button.setAttribute('aria-expanded', state ? 'true' : 'false');
        }

        button.addEventListener('click', function (event) {
            event.stopPropagation();

            // Otwarcie jednego selecta zamyka pozostałe: dwie rozwinięte listy
            // obok siebie nachodzą na siebie i nie wiadomo, która jest czyja.
            document.querySelectorAll('[data-q-dropdown]').forEach(function (other) {
                if (other !== menu) {
                    other.hidden = true;
                    var owner = other.closest('[data-q-picker]');
                    var ownerButton = owner && owner.querySelector('[data-q-picker-button]');

                    if (ownerButton) {
                        ownerButton.setAttribute('aria-expanded', 'false');
                    }
                }
            });

            open(menu.hidden);
        });

        document.addEventListener('click', function (event) {
            if (!menu.hidden && !picker.contains(event.target)) {
                open(false);
            }
        });

        // Escape zamyka i oddaje ognisko przyciskowi. Bez tego osoba
        // poruszająca się klawiaturą zostaje wewnątrz zamkniętej listy.
        picker.addEventListener('keydown', function (event) {
            if (event.key === 'Escape' && !menu.hidden) {
                open(false);
                button.focus();
            }
        });
    });
})();
