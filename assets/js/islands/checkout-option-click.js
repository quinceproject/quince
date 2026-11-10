(function () {
    'use strict';

    /* Kursor "pointer" ze stylu obejmuje całą kartę, ale klikalny `<label>`
       rdzenia — mniej. Dla płatności owija samą nazwę metody, pomijając
       resztę karty. Dla przewoźnika owija treść, ale nie dopełnienie wokół
       niej (karta ma padding, którego label nie wypełnia), więc brzegi karty
       też nie reagują na klik. */
    document.addEventListener('click', function (zdarzenie) {
        var karta = zdarzenie.target.closest('.payment-option, .delivery-option__item');
        if (!karta) return;

        if (zdarzenie.target.closest('label, input, a, button, textarea, select')) return;

        var radio = karta.querySelector('input[type="radio"]');
        if (radio && !radio.checked) radio.click();
    });
}());
