{**
 * Lista opinii modułu — celowo pusta.
 *
 * Opinie rysuje motyw, w akordeonie karty produktu: podsumowanie ocen, listę
 * i doładowanie kolejnych porcji robi `catalog/_partials/product-reviews.tpl`
 * na danych z `Quince\Engine\Product\Reviews`.
 *
 * Blok modułu wypisywał to samo drugi raz, pod kartą, razem z oknami, których
 * nie da się otworzyć: moduł otwiera je Bootstrapem, a motyw go nie wgrywa.
 * Zamiast wygaszać go stylem, nie wypisujemy go wcale.
 *
 * Sam moduł zostaje włączony i potrzebny: prowadzi tabele opinii, moderację
 * w panelu i punkty końcowe, do których strzela motyw.
 *}
