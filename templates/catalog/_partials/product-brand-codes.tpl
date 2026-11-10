{**
 * Quince: marka i kody produktu.
 *
 * Ten sam kształt co cechy podstawowe: nazwa po lewej, wartość po prawej, bez
 * nagłówka. To jest ten sam rodzaj treści, dane do odczytania, a nie do
 * przeczytania, więc nie zasługuje na drugi wzór na tej samej stronie.
 *
 * Osobno od cech, bo cechy dobiera ranking po zróżnicowaniu w kategorii i bywa
 * ich raz pięć, a raz dwie, natomiast marka i kody mają stać zawsze.
 *
 * Które wiersze się pokazują, ustawia sklep w panelu przy elemencie „Brand and
 * codes". Wiersz bez wartości nie powstaje: pusty EAN nie jest informacją.
 *
 * Projekt: makieta strony produktu.
 *
 * Zmienne: $qMarka, $qLogo, $qSku, $qEan, $qMpn, $qStan — włączniki z panelu.
 *}

{* Kody z PrestaShopa przychodzą pod PRZETŁUMACZONYMI kluczami: presenter
   buduje tablicę `specific_references` z etykietą jako kluczem, więc
   `$product.specific_references.ean13` jest zawsze puste. Przechodzimy tablicę
   i rozpoznajemy klucz po nazwie bez względu na wielkość liter, zamiast zgadywać
   jego brzmienie w danym języku.

   Bierzemy je stamtąd, a nie wprost z produktu, bo przy produkcie z wariantami
   kod wybranego wariantu przebija kod produktu i tę logikę ma już presenter. *}
{assign var=qKody value=$product.specific_references|default:[]}
{assign var=qEanNazwa value=''}
{assign var=qEanWartosc value=''}
{assign var=qMpnNazwa value=''}
{assign var=qMpnWartosc value=''}

{foreach from=$qKody key=qKlucz item=qWartosc}
  {if $qKlucz|strtolower == 'ean13'}
    {assign var=qEanNazwa value=$qKlucz}
    {assign var=qEanWartosc value=$qWartosc}
  {elseif $qKlucz|strtolower == 'mpn'}
    {assign var=qMpnNazwa value=$qKlucz}
    {assign var=qMpnWartosc value=$qWartosc}
  {/if}
{/foreach}

{assign var=qMaMarke value=(($qMarka|default:true) && isset($product_manufacturer->id) && $product_manufacturer->active)}
{assign var=qMaSku value=(($qSku|default:true) && $product.reference_to_display)}
{assign var=qMaEan value=(($qEan|default:false) && $qEanWartosc)}
{assign var=qMaMpn value=(($qMpn|default:false) && $qMpnWartosc)}
{assign var=qMaStan value=(($qStan|default:false) && $product.condition)}

{* Adres logotypu marki. `$product_manufacturer->image` to tablica formatów
   (`bySize.small_default.url` i tak dalej), a nie adres: wstawiona wprost dawała
   ostrzeżenie „Array to string conversion" i obrazek bez źródła. *}
{assign var=qLogoUrl value=''}
{if $qMaMarke && ($qLogo|default:false)}
  {assign var=qLogoUrl value=$product_manufacturer->image.bySize.small_default.url|default:''}
{/if}

{if $qMaMarke || $qMaSku || $qMaEan || $qMaMpn || $qMaStan}
  <div class="q-facts q-facts--codes">
    <dl class="q-facts__list">
      {if $qMaMarke}
        <div class="q-facts__row">
          <dt class="q-facts__key">{l s='Brand' d='Shop.Theme.Catalog'}</dt>
          <dd class="q-facts__val">
            <a href="{$product_manufacturer->url}"
               aria-label="{l s='Product brand: %brand_name%' sprintf=['%brand_name%' => $product_manufacturer->name] d='Shop.Theme.Catalog'}">
              {* Logo zamiast nazwy, gdy sklep tak ustawi. Nazwa zostaje w tekście
                 zastępczym obrazka, więc czytnik ekranu mówi to samo co wcześniej. *}
              {if ($qLogo|default:false) && $qLogoUrl}
                <img class="q-facts__logo" src="{$qLogoUrl}"
                     alt="{$product_manufacturer->name}" loading="lazy" decoding="async">
              {else}
                {$product_manufacturer->name}
              {/if}
            </a>
          </dd>
        </div>
      {/if}

      {if $qMaSku}
        <div class="q-facts__row">
          <dt class="q-facts__key">{l s='SKU' d='Shop.Theme.Catalog'}</dt>
          <dd class="q-facts__val">{$product.reference_to_display}</dd>
        </div>
      {/if}

      {if $qMaEan}
        <div class="q-facts__row">
          <dt class="q-facts__key">{$qEanNazwa}</dt>
          <dd class="q-facts__val">{$qEanWartosc}</dd>
        </div>
      {/if}

      {if $qMaMpn}
        <div class="q-facts__row">
          <dt class="q-facts__key">{$qMpnNazwa}</dt>
          <dd class="q-facts__val">{$qMpnWartosc}</dd>
        </div>
      {/if}

      {if $qMaStan}
        <div class="q-facts__row">
          {* Napis rdzenia niesie dwukropek („Stan:"), a pozostałe wiersze
             zestawienia są bez niego. Ucinamy go, żeby kolumna była równa. *}
          {assign var=qStanNazwa value={l s='Condition' d='Shop.Theme.Catalog'}}
          <dt class="q-facts__key">{$qStanNazwa|trim:': '}</dt>
          <dd class="q-facts__val">{$product.condition.label}</dd>
        </div>
      {/if}
    </dl>
  </div>
{/if}
