{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{* Rdzeń odsyła ten kawałek przy każdym zawężeniu bez przeładowania strony.
   Niesie świeże numery stron w ukrytym `template`: stronicowanie stoi
   w strefie „Pod listą”, której rdzeń nie odsyła, więc skrypt listingu
   przenosi je stamtąd w miejsce starych (`[data-q-pagination]`).
   `template` nic nie pokazuje i nie wchodzi do drzewa strony. *}
<div id="js-product-list-bottom">
  <template data-q-pagination-fresh>
    {include file='_partials/pagination.tpl' pagination=$listing.pagination}
  </template>
</div>
