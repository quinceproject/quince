{**
 * Okno „napisz opinię" modułu — celowo puste.
 *
 * Moduł otwiera je Bootstrapem (`data-bs-toggle="modal"`), którego motyw nie
 * wgrywa, więc okno leżało na stronie jako niezwijalny kawał tekstu.
 *
 * Formularz opinii jest w motywie, jako szuflada przy sekcji opinii w akordeonie
 * (`catalog/_partials/product-reviews.tpl`). Wysyła się do tego samego punktu
 * końcowego modułu, `productcomments/PostComment`, więc moderacja, kryteria
 * i zapis do bazy pozostają po stronie modułu.
 *}
