{**
 * Potwierdzenie dodania do koszyka.
 *
 * Moduł koszyka po dodaniu produktu odsyła ten szablon osobno od podglądu.
 * Motyw nie stawia z niego okna: szuflada koszyka otwiera się sama, a ten
 * komunikat trafia na jej górę (`data-q-cart-alert`). Po zwykłym otwarciu
 * szuflady z nagłówka komunikatu nie ma, bo nie ma czego potwierdzać.
 *
 * Projekt: makieta strony produktu, szuflada koszyka.
 *}

<div class="q-drawer__alert" role="status">
  <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
    <path d="M8 1a7 7 0 1 0 0 14A7 7 0 0 0 8 1m3.3 5.2-4 4a.7.7 0 0 1-1 0L4.7 8.6l1-1L7.8 9.7l3.5-3.5z"/>
  </svg>
  {l s='Product added to cart' d='Shop.Theme.Checkout'}
</div>
