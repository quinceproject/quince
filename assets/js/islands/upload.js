/**
 * Quince — podpis pola wgrywania pliku (`.q-upload`).
 *
 * Ta sama logika co `wgrywanie()` w `buybox.js`, wyniesiona osobno: tamta
 * wyspa wiąże się tylko z panelem zakupu produktu (`.q-buy`), a `.q-upload`
 * ma teraz drugiego konsumenta — załącznik w formularzu kontaktowym — poza
 * kartą produktu.
 *
 * Pole `input type=file` jest schowane, bo przeglądarka rysuje przy nim
 * własny przycisk z własnym napisem — nieostylowalny i nieprzetłumaczalny.
 * Skoro schowane, to ono nie pokaże nazwy pliku i musi zrobić to etykieta.
 */
(function () {
    'use strict';

    var Quince = window.Quince;

    if (!Quince || typeof Quince.register !== 'function') {
        return;
    }

    Quince.register('[data-q-upload]', function (etykieta) {
        var pole = etykieta.querySelector('input[type="file"]');
        var napis = etykieta.querySelector('[data-q-upload-name]');

        if (!pole || !napis) {
            return;
        }

        pole.addEventListener('change', function () {
            var plik = pole.files && pole.files[0];

            if (plik) {
                napis.textContent = plik.name;
                etykieta.classList.add('ma-plik');
            } else {
                etykieta.classList.remove('ma-plik');
            }
        });
    });
})();
