{**
 * Quince: słupek narzędzi karty produktu
 *
 * Szybki podgląd i ulubione siedzą razem przy dolnej krawędzi kadru. Ramkę nosi
 * słupek, nie każdy znak z osobna: to jedna grupa narzędzi do tego produktu,
 * a dwa oddzielne pudełka czytałyby się jak dwie niezależne rzeczy.
 *
 * Serce wysyła zapis do modułu list życzeń. Bez zalogowania prowadzi na
 * logowanie i wraca tutaj, bo dodanie do listy wymaga konta.
 *
 * Zachowanie: assets/js/islands/wishlist.js
 *}

<div class="q-pcard__tools">
  {include file='catalog/_partials/miniatures/product-quickview.tpl'}

  {* Serce stoi tylko wtedy, gdy sklep ma moduł list życzeń (ta sama decyzja,
     która stawia serce w nagłówku). Bez modułu nie ma gdzie zapisać. *}
  {if isset($modules.quince_engine.header.wishlist) && $modules.quince_engine.header.wishlist.visible}
    <button type="button"
            class="q-pcard__tool q-pcard__wish"
            data-q-wish
            data-q-wish-produkt="{$product.id_product|intval}"
            data-q-wish-wariant="{$product.id_product_attribute|intval}"
            aria-pressed="false"
            aria-label="{l s='Add %product_name% to your saved products' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Actions'}"
            title="{l s='Saved products' d='Shop.Theme.Global'}">
      {* Dwa rysunki, po jednym na stan: pusty i wypełniony. Wypełnienia obrysu
         nie da się zrobić stylem, bo to inny kształt, a nie inna barwa. *}
      <svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
        <path class="q-pcard__wish-outline" d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143q.09.083.176.171a3 3 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15"/>
        <path class="q-pcard__wish-filled" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314"/>
      </svg>
    </button>
  {/if}
</div>
