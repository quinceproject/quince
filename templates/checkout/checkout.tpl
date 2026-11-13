{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file=$layout}

{block name='notifications'}
{/block}

{block name='breadcrumb'}
{/block}

{block name='content_columns'}

  {* ── skrócona oprawa kasy ─────────────────────────────────────────────
     Bez menu i bez wyszukiwarki: na tym ekranie nie ma już czego szukać,
     a każde wyjście z niego to porzucony koszyk. Strona bierze układ
     `layout-content-only`, który nie rysuje nagłówka ani stopki sklepu,
     więc oprawę podajemy tutaj. *}
  <header class="q-checkout-head">
    <div class="q-container q-checkout-head__in">
      <a class="q-checkout-head__logo" href="{$urls.base_url}">
        {if $shop.logo_details}
          <img src="{$shop.logo_details.src}" alt="{$shop.name}"
               width="{$shop.logo_details.width}" height="{$shop.logo_details.height}">
        {else}
          <b>{$shop.name}</b>
        {/if}
      </a>

      <div class="q-checkout-head__right">
        <a class="q-checkout-head__item q-checkout-head__item--contact" href="{$urls.pages.cart}?action=show">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 6l-6 6 6 6"></path></svg>
          {l s='Back to cart' d='Shop.Theme.Checkout'}
        </a>
      </div>
    </div>
  </header>

  {* Napis przy niezaznaczonej zgodzie bierzemy z rdzenia. To ten sam, którego
     PrestaShop używa przy brakującym polu wymaganym po stronie serwera, więc
     klient widzi to samo zdanie niezależnie od tego, kto sprawdził formularz.
     Wisi na całej stronie kasy, nie na kolumnie formularza: zgoda wędruje do
     kolumny zamówienia i poza tamtą kolumną przestawałaby go znajdować. *}
  <main class="q-container q-checkout2-page"
        data-q-msg-required="{l s='Required field' d='Shop.Forms.Errors'}"
        data-q-msg-format="{l s='Invalid format.' d='Shop.Forms.Errors'}">
    <h1 class="q-checkout2__title">{l s='Order' d='Shop.Theme.Checkout'}</h1>

    {* Pasek kroków. Krok bieżący ma krążek wypełniony, krok przebyty sam
       obrys w barwie marki: wypełnienie mówi „jesteś tutaj", obrys „to już za
       tobą", a cała ścieżka trzyma się jednej barwy. Łącznik między krążkami
       pokazuje przebytą drogę; na telefonie znikają napisy, zostają numery.

       Rysowany tutaj, a nie przez `checkout-navigation.tpl`, bo tamten nie
       przenosi stanu kroku na pozycję paska, a `$checkout_steps` go niesie. *}
    <div class="q-checkout-steps">
      <div class="q-container q-checkout-steps__in">
        {foreach from=$checkout_steps item="krok" key="i"}
          {if !$krok@first}
            <span class="q-checkout-steps__connector{if $krok.is_complete || $krok.is_current} q-checkout-steps__connector--done{/if}"></span>
          {/if}
          <span class="q-checkout-steps__step{if $krok.is_current} q-checkout-steps__step--current{elseif $krok.is_complete} q-checkout-steps__step--done{/if}"
                {if $krok.is_current}aria-current="step"{/if}>
            <span class="q-checkout-steps__number">{$i + 1}</span>
            <span>{$krok.title}</span>
          </span>
        {/foreach}
      </div>
    </div>

    {block name='checkout_notifications'}
      {include file='_partials/notifications.tpl'}
    {/block}

    {* Dwie kolumny: po lewej to, co klient wypełnia, po prawej przyklejona
       kolumna zamówienia z kwotami. Na wąskim ekranie kolumna zamówienia
       idzie na górę, żeby klient widział, za co płaci, zanim zacznie
       wypełniać pola. *}
    {* Podział szerokości ten sam, co na stronie produktu: ustawienie panelu
       zakupu rządzi też kolumną zamówienia. *}
    {assign var=qPdp value=$modules.quince_engine.product|default:null}
    <div class="q-checkout2"{if $qPdp && isset($qPdp.split)} style="--q-pdp-glowna: {$qPdp.split.main}fr; --q-pdp-panel: {$qPdp.split.panel}fr"{/if}>
      <div class="q-checkout2__form">
        {block name='checkout_process'}
          {render file='checkout/checkout-process.tpl' ui=$checkout_process}
        {/block}
      </div>

      {* Kolumna zamówienia. Stopka z przyciskiem zapłaty stoi POZA zwijanym
         ciałem i poza krokiem: klient przez cały czas widzi, czym zakup się
         skończy.

         Prawdziwy przycisk składający zamówienie zostaje w kroku płatności:
         razem z nim idą pola wybranej metody i wyjęcie go stamtąd zrywa
         składanie zamówienia.

         Klauzuli „Administratorem Twoich danych jest..." tu nie ma: informacja
         o przetwarzaniu danych stoi w kroku 1, przy zakładaniu konta, bo tam
         wymagana jest zgoda RODO. Pod przyciskiem stoi tylko w checkoucie
         jednostronicowym (OPC), który nie ma osobnego kroku 1. *}
      <aside class="q-checkout__side" aria-label="{l s='Your order' d='Shop.Theme.Checkout'}">
        <div class="q-ordersum q-ordersum--open" data-q-sum>
          {block name='cart_summary'}
            {include file='checkout/_partials/cart-summary.tpl' cart=$cart}
          {/block}

          {assign var=qPlatnosc value=false}
          {foreach from=$checkout_steps item="k"}
            {if $k.identifier === 'checkout-payment-step' && $k.is_current}{assign var=qPlatnosc value=true}{/if}
          {/foreach}

          <div class="q-ordersum__foot">
            {* Miejsce na zgodę i prawdziwy przycisk kończący zakup. Renderuje je
               krok płatności (tylko on zna wybraną metodę i listę zgód), a wyspa
               `checkout-summary` przenosi je tutaj, do kwoty.

               Dopóki klient tam nie dojdzie, w DOM-ie nie ma czego przenieść:
               poniżej stoi nieaktywny podgląd tej samej zgody, z tym samym
               odnośnikiem do regulaminu, żeby kolumna nie zmieniała układu
               w ostatnim kroku. Bez `name`, więc formularza nie dotyczy i
               nigdzie się nie wysyła. *}
            <div data-q-pay-slot></div>

            {* OPC nie ma kroku płatności, więc `$qPlatnosc` nigdy nie bywa
               prawdziwe. Bez dodatkowego warunku ten podgląd stałby tam
               już ZAWSZE, obok prawdziwej treści, którą OPC renderuje od
               razu (nie dopiero w kroku 4). `$checkout_steps` zasila pasek
               kroków kawałek wyżej w tym samym pliku: w OPC jest pusty,
               więc to bezpieczny sygnał „to nie jest kasa krokowa". *}
            {if !$qPlatnosc && $checkout_steps|default:[]|count}
              {if isset($qRegulaminUrl)}
                <label class="q-choice q-choice--preview">
                  <input class="q-choice__input" type="checkbox" disabled>
                  <span class="q-choice__label">
                    {l s='I agree to the [1]terms of service[/1] and will adhere to them unconditionally.' sprintf=['[1]' => "<a href=\"{$qRegulaminUrl}\">", '[/1]' => '</a>'] d='Shop.Theme.Checkout'}
                  </span>
                </label>
              {/if}

              <button type="button" class="q-btn q-btn--primary q-ordersum__pay" disabled>
                {l s='Order and pay' d='Shop.Theme.Checkout'}
              </button>
            {/if}
          </div>
        </div>
      </aside>
    </div>
  </main>

  {* Zapis o ochronie reCAPTCHA. Nie stoi przy zgodach w kroku 1: to nie jest
     zgoda, tylko informacja o zabezpieczeniu formularza, więc żyje poza
     obszarem kroków, nad stopką, widoczna niezależnie od tego, który krok
     jest akurat rozwinięty. Pola strażnika (token, pułapka) zostają tam,
     gdzie faktycznie chronią zgłoszenie: w formularzu kroku 1
     (`checkout/_partials/customer-form.tpl`). *}
  <div class="q-container">
    {hook h='displayQuinceFormNotice' form_id='checkout'}
  </div>

  {* Sam dolny pasek stopki sklepu, bez kolumn. Klasy i dane te same, co
     w `_partials/footer.tpl` (`q-footer__bar*`, `$qf.barLinks`,
     `$qf.copyright`, `$qf.payments`): link do regulaminu, akceptowane
     płatności i prawa autorskie ustawia się raz, w panelu silnika. *}
  {assign var=qf value=$modules.quince_engine.footer}
  <footer class="q-checkout-foot q-footer__bar">
    <div class="q-container q-footer__bar-inner">
      <span class="q-footer__bar-links">
        {foreach from=$qf.barLinks item=odnosnik}
          <a href="{$odnosnik.url|escape:'html':'UTF-8'}">{$odnosnik.label}</a>
        {/foreach}
      </span>

      <span class="q-footer__bar-text">
        {if $qf.copyright}{$qf.copyright}{else}&copy; {'now'|date_format:'%Y'} {$shop.name}{/if}
      </span>

      <span class="q-footer__pay">
        {foreach from=$qf.payments item=payment}<span>{$payment}</span>{/foreach}
      </span>
    </div>
  </footer>

  {* `checkout/_partials/modal-terms.tpl` (rdzeń) celowo pominięty: to okno
     Bootstrapa, chowane jego własnym CSS-em, którego Quince nie ładuje, więc
     zostaje widoczne jako goły przycisk „Close" pod stopką. Link do
     regulaminu prowadzi wprost na stronę CMS (patrz `conditions_to_approve`),
     więc modal nie jest potrzebny. *}
{/block}
