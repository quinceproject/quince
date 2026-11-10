/* ===================================================================
   Quince — zamykanie paska komunikatu

   Wyspa: działa tylko wtedy, gdy sprzedawca włączył zamykanie i pasek jest
   na stronie. Bez JavaScriptu pasek po prostu zostaje widoczny — to nie jest
   awaria, tylko brak udogodnienia.

   Wybór pamiętamy na czas sesji, nie na stałe. Komunikat bywa sezonowy
   i sprzedawca ma prawo, żeby przy kolejnej wizycie klient go zobaczył
   ponownie — inaczej jednorazowe kliknięcie kasowałoby przekaz na zawsze.
   =================================================================== */

(function () {
    'use strict';

    var KEY = 'quince.promobar.closed';

    function setup(bar) {
        var button = bar.querySelector('[data-q-promobar-close]');
        if (!button) {
            return;
        }

        // Ten sam komunikat zamknięty wcześniej w tej sesji — nie pokazujemy go
        // ponownie. Porównujemy treść, nie sam fakt zamknięcia: sprzedawca mógł
        // w międzyczasie zmienić przekaz i nowy ma prawo się pojawić.
        var text = (bar.textContent || '').trim();

        try {
            if (window.sessionStorage.getItem(KEY) === text) {
                bar.hidden = true;

                return;
            }
        } catch (e) {
            // Tryb prywatny bywa blokuje magazyn sesji — wtedy pasek po prostu
            // zostaje widoczny i zamykanie działa do przeładowania strony.
        }

        button.addEventListener('click', function () {
            bar.hidden = true;

            try {
                window.sessionStorage.setItem(KEY, text);
            } catch (e) {
                // jak wyżej
            }
        });
    }

    if (window.Quince && typeof window.Quince.register === 'function') {
        window.Quince.register('[data-q-promobar]', setup);
    }
})();
