{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}

{extends file=$layout}
{$componentName = 'order-confirmation'}

{* Okruszki idą do środka strony, tak jak na każdej innej podstronie.
   Inaczej zostają bez górnego odstępu, bo goły layout im go nie daje. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  <div class="q-container {$componentName}__crumbs">
    {include file='_partials/breadcrumb.tpl'}
  </div>

  {* Ten sam układ dwóch kolumn co kasa krokowa (`.q-checkout2`), bo to ta sama
     strona z innym stanem: formularz zastępują karty z wynikiem, kolumna
     zamówienia zostaje ta sama, tylko bez niczego, co dałoby się jeszcze
     zmienić. *}
  <div class="q-checkout2">
    <div class="q-checkout2__form">
      {block name='order_confirmation_header'}
        <section class="q-checkout2__section">
          <div class="q-checkout2__thanks">
            <span class="q-checkout2__tick" aria-hidden="true">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <path d="M5 12l5 5 9-10"/>
              </svg>
            </span>

            <div>
              <h1 tabindex="-1">{l s='Your order is confirmed' d='Shop.Theme.Checkout'}</h1>
              <p class="q-checkout2__sub">
                {l s='An email has been sent to your mail address %email%.' d='Shop.Theme.Checkout' sprintf=['%email%' => $order_customer.email]}
                {if $order.details.invoice_url}
                  {l
                    s='You can also [1]download your invoice[/1].'
                    d='Shop.Theme.Checkout'
                    sprintf=[
                      '[1]' => "<a href='{$order.details.invoice_url}'>",
                      '[/1]' => '</a>'
                    ]
                  }
                {/if}
              </p>
            </div>
          </div>
        </section>
      {/block}

      {block name='hook_payment_return'}
        {capture name='hook_payment_return'}{$HOOK_PAYMENT_RETURN nofilter}{/capture}
        {if !empty($smarty.capture.hook_payment_return)}
          <section class="q-checkout2__section">{$smarty.capture.hook_payment_return nofilter}</section>
        {/if}
      {/block}

      {block name='hook_order_confirmation'}
        {capture name='hook_order_confirmation'}{$HOOK_ORDER_CONFIRMATION nofilter}{/capture}
        {if !empty($smarty.capture.hook_order_confirmation)}
          <section class="q-checkout2__section">{$smarty.capture.hook_order_confirmation nofilter}</section>
        {/if}
      {/block}

      {block name='hook_order_confirmation_1'}
        {capture name='hook_order_confirmation_1'}{hook h='displayOrderConfirmation1'}{/capture}
        {if !empty($smarty.capture.hook_order_confirmation_1)}
          <section class="q-checkout2__section">{$smarty.capture.hook_order_confirmation_1 nofilter}</section>
        {/if}
      {/block}

      {if !$registered_customer_exists}
        {block name='account_transformation_form'}
          <section class="q-checkout2__section {$componentName}__account-transformation">
            {include file='customer/_partials/account-transformation-form.tpl'}
          </section>
        {/block}
      {/if}

      {block name='order_details'}
        <section class="q-checkout2__section">
          <h2>{l s='Order details' d='Shop.Theme.Checkout'}</h2>
          <p class="q-checkout2__sub">{l s='Order reference: %reference%' d='Shop.Theme.Checkout' sprintf=['%reference%' => $order.details.reference]}</p>

          {block name='order_confirmation_table'}
            <div class="q-checkout2__detail-grid">
              {if !$order.details.is_virtual && !($is_multishipment_enabled|default:false)}
                <div>
                  <b>{l s='Shipping method' d='Shop.Theme.Checkout'}</b>
                  <span>{$order.carrier.name}</span>
                  <span>{$order.carrier.delay}</span>
                </div>
              {/if}

              <div>
                <b>{l s='Invoice address' d='Shop.Theme.Checkout'}</b>
                <span>{$order.addresses.invoice.formatted nofilter}</span>
              </div>

              <div>
                <b>{l s='Payment method' d='Shop.Theme.Checkout'}</b>
                <span>{$order.details.payment}</span>
              </div>
            </div>
          {/block}
        </section>
      {/block}

      {* Miejsce na dowolny hook pod „Order details". Ten sam mechanizm, co
         hook w elementach strony produktu (`ProductPageSettings`): sklep sam
         wpisuje nazwę w ustawieniach Checkout, a tu tylko ją wywołujemy.

         Bez karty `.q-checkout2__section`, w odróżnieniu od
         `hook_payment_return`/`hook_order_confirmation` wyżej w tym pliku:
         tamte niosą zwykły tekst modułu. Tu docelowa treść (np. baner
         WiseBlocka) zwykle ma już własne tło na pełną szerokość, tak jak
         `hook_order_confirmation_2` niżej dla karuzel. Odstęp od sąsiadów
         liczy `gap` na `.q-checkout2__form`, nie margines karty, więc
         nieopakowany hook dostaje go tak samo. Przechwycone, żeby pusty hook nie zostawiał żadnego
         elementu w siatce. *}
      {block name='hook_order_confirmation_column'}
        {if $modules.quince_engine.checkout.orderConfirmationHook|default:''}
          {capture name='hookOrderConfirmationColumn'}
            {hook h=$modules.quince_engine.checkout.orderConfirmationHook}
          {/capture}
          {if trim($smarty.capture.hookOrderConfirmationColumn) !== ''}
            {$smarty.capture.hookOrderConfirmationColumn nofilter}
          {/if}
        {/if}
      {/block}

      <div class="q-checkout2__nav">
        <a class="q-btn q-btn--secondary" href="{$urls.base_url}">{l s='Back to shop' d='Shop.Theme.Checkout'}</a>
      </div>
    </div>

    <aside class="q-ordersum q-ordersum--open" data-q-sum aria-label="{l s='Your order' d='Shop.Theme.Checkout'}">
      {include file='checkout/_partials/order-confirmation-summary.tpl' order=$order}
    </aside>
  </div>

  {* Poza siatką dwóch kolumn: karuzele zajawek mają zajmować całą szerokość
     strony, tak jak wszędzie indziej, nie szerokość samej kolumny formularza. *}
  {block name='hook_order_confirmation_2'}
    {hook h='displayOrderConfirmation2'}
  {/block}
{/block}
