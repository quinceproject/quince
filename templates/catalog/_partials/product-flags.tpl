{**
 * Quince: plakietki produktu
 *
 * PrestaShop podaje gotową listę w `$product.flags`, gdzie `type` to jedna
 * z wartości: new, on-sale, discount, pack, out_of_stock, online-only, used,
 * refurbished oraz (od 9.2) open_box, damaged, new_with_defects.
 *
 * Rozdzielamy je na dwie grupy, bo znaczą co innego:
 *   handlowe: zachęta do zakupu, kolor z palety promocji i statusów,
 *   stan:     informacja o towarze, celowo neutralna, żeby nie konkurowała
 *             z rabatem o uwagę klienta.
 *
 * Klasa listy przychodzi z zewnątrz (`$qBadgesClass`), bo miejsce jest różne:
 * na kafelku plakietki leżą NA zdjęciu (warstwa bezwzględna w rogu kadru),
 * a na stronie produktu płyną w kolumnie opisu. Klasa kafelka na stronie
 * produktu pozycjonowałaby je bezwzględnie względem przypadkowego przodka.
 *
 * Klasy: components/badge.css
 *}

{assign var=qBadgesClass value=$qBadgesClass|default:'q-pcard__badges'}

{* Typy plakietek wyłączone dla tego miejsca (zajawka: Quince Engine → Karta
   produktu). Lista bez żadnej widocznej plakietki nie renderuje się wcale. *}
{assign var=qHiddenFlags value=$qHiddenFlags|default:[]}
{assign var=qWidoczne value=0}
{foreach from=$product.flags item=flag}{if !in_array($flag.type, $qHiddenFlags)}{assign var=qWidoczne value=$qWidoczne+1}{/if}{/foreach}

{if $qWidoczne > 0}
  {block name='product_flags'}
    <ul class="{$qBadgesClass|escape:'html':'UTF-8'} js-product-flags">
      {foreach from=$product.flags item=flag}
        {if in_array($flag.type, $qHiddenFlags)}{continue}{/if}
        {* Stany produktu z PrestaShopa 9.2 dostają wariant neutralny. *}
        {if in_array($flag.type, ['used', 'refurbished', 'open_box', 'damaged', 'new_with_defects'])}
          <li class="q-badge q-badge--condition">{$flag.label nofilter}</li>
        {elseif $flag.type === 'discount'}
          <li class="q-badge q-badge--discount">{$flag.label nofilter}</li>
        {elseif $flag.type === 'new'}
          <li class="q-badge q-badge--new">{$flag.label nofilter}</li>
        {elseif $flag.type === 'on-sale'}
          <li class="q-badge q-badge--sale">{$flag.label nofilter}</li>
        {elseif $flag.type === 'pack'}
          <li class="q-badge q-badge--bundle">{$flag.label nofilter}</li>
        {else}
          {* out_of_stock, online-only i wszystko, co PrestaShop doda w przyszłości.
             Nieznana wartość ma wyglądać poprawnie, a nie zniknąć. *}
          <li class="q-badge q-badge--condition">{$flag.label nofilter}</li>
        {/if}
      {/foreach}
    </ul>
  {/block}
{/if}
