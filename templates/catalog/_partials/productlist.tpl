{**
 * Quince — siatka zajawek produktu.
 *
 * Liczba kolumn pochodzi z ustawień sklepu (token --q-grid-columns), ale karta
 * nigdy nie schodzi poniżej 220 px — patrz .q-grid w theme.css. Dzięki temu ta
 * sama siatka obsługuje pełną szerokość i układ z kolumną filtrów.
 *
 * Między kafle wchodzą miejsca promocyjne. Sklep podaje numer RZĘDU, po którym
 * miejsce ma stanąć, a silnik przelicza go na numer kafla z bieżącej liczby
 * kolumn. Dzięki temu pas na całą szerokość zawsze trafia na granicę rzędu:
 * postawiony w środku rzędu przeskakiwałby do następnego i zostawiał po sobie
 * puste komórki.
 *
 * Wokół siatki produktów PrestaShop nie daje żadnego hooka, więc te miejsca są
 * w całości nasze. Miejsce, którego moduł nie ma czym wypełnić, nie renderuje
 * się wcale i nie zostawia dziury.
 *}

{assign var=qList value=$modules.quince_engine.listing}

{* Ile produktów pokazały wcześniejsze strony. Przy zasięgu „raz na całej
   liście" silnik potrzebuje tej liczby, żeby wiedzieć, czy miejsce wypada na
   tę stronę. *}
{assign var=qSkipped value=($listing.pagination.items_shown_from|default:1) - 1}
{assign var=qSlots value=$qList.columns|qslots:$qSkipped}

<div class="q-grid products js-product-list-grid{if $qList.view == 'list'} q-grid--list{/if}">

  {* Miejsce w rzędzie zerowym stoi przed pierwszym produktem. *}
  {if isset($qSlots[0])}
    {foreach from=$qSlots[0] item=qSlot}
      {capture assign='qSlotHtml'}{hook h=$qSlot.hook}{/capture}
      {if $qSlotHtml|trim}
        <div class="q-grid__slot q-grid__slot--{$qSlot.type} q-grid__slot--{$qSlot.views}">{$qSlotHtml nofilter}</div>
      {/if}
    {/foreach}
  {/if}

  {foreach from=$products item='product' key='position'}
    {include file='catalog/_partials/miniatures/product.tpl' product=$product position=$position}

    {assign var=qTile value=$position + 1}
    {if isset($qSlots[$qTile])}
      {foreach from=$qSlots[$qTile] item=qSlot}
        {capture assign='qSlotHtml'}{hook h=$qSlot.hook}{/capture}
        {if $qSlotHtml|trim}
          <div class="q-grid__slot q-grid__slot--{$qSlot.type} q-grid__slot--{$qSlot.views}">{$qSlotHtml nofilter}</div>
        {/if}
      {/foreach}
    {/if}
  {/foreach}
</div>
