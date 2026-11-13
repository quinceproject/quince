/* ===================================================================
   Quince: sprawdzanie formularza przy wysyłaniu

   Przeglądarka sama pilnuje pól `required`, ale pokazuje własny dymek:
   znika po kilku sekundach, wygląda jak komunikat systemu operacyjnego,
   nie da się go ustawić ani przetłumaczyć razem ze stroną, a przy kilku
   pustych polach pokazuje tylko pierwsze. Prototyp ma zamiast tego czerwoną
   ramkę pola i jedno zdanie pod nim, i tak to tu działa.

   Formularz dostaje `novalidate`, żeby dymek się nie pokazał, a sprawdzanie
   przejmuje ten skrypt. Reguły zostają te same, co w znacznikach: `required`,
   `type="email"`, `minlength`, `pattern`.

   Wyspa: bez JavaScriptu `novalidate` się nie doklei i pilnuje przeglądarka,
   a po wysłaniu i tak sprawdza PrestaShop po swojej stronie.
   =================================================================== */

(function () {
    'use strict';

    function grupa(pole) {
        return pole.closest('.q-float') || pole.closest('.mb-3');
    }

    function napis(pole, nazwa) {
        var zrodlo = pole.closest('[' + nazwa + ']');
        return zrodlo ? zrodlo.getAttribute(nazwa) : '';
    }

    function komunikat(pole) {
        /* Dwa zdania, oba z rdzenia PrestaShopa: to samo, które pokaże serwer,
           gdy formularz dojdzie do niego z pustym albo źle wypełnionym polem.
           Klient widzi więc jeden napis niezależnie od tego, kto sprawdził.
           Przeglądarka ma tu swój opis, ale w swoim języku, nie w języku sklepu. */
        var tekst = pole.validity.valueMissing
            ? napis(pole, 'data-q-msg-required')
            : napis(pole, 'data-q-msg-format');

        return tekst || pole.validationMessage;
    }

    function oznacz(pole, tekst) {
        var g = grupa(pole);
        if (!g) return;

        g.classList.add('has-error');
        pole.setAttribute('aria-invalid', 'true');

        var nota = g.querySelector('.q-fld-err[data-q-auto]');

        if (!nota) {
            nota = document.createElement('div');
            nota.className = 'q-fld-err';
            nota.setAttribute('data-q-auto', '');
            nota.setAttribute('role', 'alert');
            g.appendChild(nota);
        }

        nota.textContent = tekst;
    }

    function wyczysc(pole) {
        var g = grupa(pole);
        if (!g) return;

        g.classList.remove('has-error');
        pole.removeAttribute('aria-invalid');

        var nota = g.querySelector('.q-fld-err[data-q-auto]');
        if (nota) nota.remove();
    }

    function sprawdz(formularz) {
        var pierwszeZle = null;

        /* `form.elements`, nie `querySelectorAll`: pole związane z formularzem
           atrybutem `form` leży poza nim w drzewie, a należy do niego. Tak
           właśnie stoi zgoda przeniesiona do kolumny zamówienia. */
        [].forEach.call(formularz.elements, function (pole) {
            if (pole.type === 'hidden' || pole.disabled || !pole.offsetParent) return;

            if (pole.checkValidity()) {
                wyczysc(pole);
                return;
            }

            oznacz(pole, komunikat(pole));
            if (!pierwszeZle) pierwszeZle = pole;
        });

        if (pierwszeZle) {
            pierwszeZle.focus();
            pierwszeZle.scrollIntoView({ block: 'center', behavior: 'smooth' });
        }

        return !pierwszeZle;
    }

    function ustaw(formularz) {
        if (formularz.dataset.qWalidacja) return;
        formularz.dataset.qWalidacja = '1';
        formularz.setAttribute('novalidate', '');

        formularz.addEventListener('submit', function (zdarzenie) {
            if (!sprawdz(formularz)) zdarzenie.preventDefault();
        });

        /* Pole poprawione przestaje być czerwone od razu, a nie dopiero przy
           następnej próbie wysłania. */
        formularz.addEventListener('input', function (zdarzenie) {
            var pole = zdarzenie.target;
            if (pole.matches('input, select, textarea') && pole.checkValidity()) wyczysc(pole);
        });
    }

    function start() {
        document.querySelectorAll('.q-checkout2__form form, .q-checkout2-page form').forEach(ustaw);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }

    if (window.prestashop && typeof prestashop.on === 'function') {
        prestashop.on('changedCheckoutStep', start);
        prestashop.on('updatedAddressForm', start);
    }
}());
