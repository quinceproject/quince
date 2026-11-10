{**
 * Okno szuflady koszyka.
 *
 * Treść rysuje widżet ps_shoppingcart (modules/ps_shoppingcart/ps_shoppingcart.tpl),
 * bo to jego moduł koszyka odświeża po każdej zmianie. Bez modułu widżet jest
 * pusty, a przycisk koszyka w nagłówku prowadzi wtedy po prostu na stronę koszyka.
 *
 * Zachowanie: assets/js/islands/cart-drawer.js
 *}

{if !$configuration.is_catalog}
  {capture name='qCartDrawer'}{widget name='ps_shoppingcart'}{/capture}
  {if $smarty.capture.qCartDrawer|trim}
    <dialog class="q-modal q-modal--drawer" data-q-cart-drawer aria-labelledby="q-cart-drawer-title">
      {$smarty.capture.qCartDrawer nofilter}
    </dialog>
  {/if}
{/if}
