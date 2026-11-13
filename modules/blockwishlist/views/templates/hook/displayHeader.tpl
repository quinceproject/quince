{**
 * Quince: nadpisanie modułu blockwishlist, hook nagłówka.
 *
 * Pusto z zamiaru. Moduł wypisuje tu okna swojej aplikacji Vue: wybór listy,
 * zakładanie nowej, logowanie i powiadomienie. Quince ma własne serce na karcie
 * i w panelu zakupu, a silnik zdejmuje pliki tamtej aplikacji
 * (`quince_engine.php`, `hookActionFrontControllerSetMedia`), więc te okna
 * nigdy się nie uruchamiają. Zostawione, lądowały pod stopką jako goły tekst
 * z podstawieniami Vue w rodzaju `((title))`.
 *
 * Zdejmujemy szablon, nie hook: rejestracje hooków trzeba by odtwarzać po każdej
 * reinstalacji tamtego modułu, a jego dane w JS są nam nadal potrzebne.
 *}
