{**
 * Quince: opis przelewu bankowego pod opcją płatności w kasie.
 *
 * Pokazuje tekst dla klienta ustawiony w panelu modułu („Informacje dla
 * klienta”), więc sklep zmienia go sam, bez zmian w motywie. Bez tego tekstu
 * zostaje zdanie modułu. Moduł dokładał jeszcze odnośnik „Więcej informacji”
 * z oknem z danymi konta. Tu go nie ma: dane konta klient dostaje na stronie
 * potwierdzenia zamówienia i w mailu.
 *}
<section>
  {if $bankwireCustomText}
    {$bankwireCustomText nofilter}
  {else}
    <p>{l s='Please transfer the invoice amount to our bank account. You will receive our order confirmation by email containing bank details and order number.' d='Modules.Wirepayment.Shop'}</p>
  {/if}
</section>
