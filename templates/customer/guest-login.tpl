{**
 * Quince: śledzenie zamówienia gościa.
 *
 * Układ jak na stronie logowania (customer/authentication.tpl): okruszki
 * w kontenerze i karta z formularzem, bez kolumny z korzyściami konta.
 * Numer zamówienia i e-mail stoją obok siebie, przycisk po prawej.
 *
 * Formularz jest formularzem rdzenia: ta sama akcja, metoda GET i ukryte pole
 * `controller`. Błędy (zły numer albo e-mail) pokazuje motyw jako dymki
 * (_partials/notifications.tpl).
 *
 * Klasy: assets/css/components/auth.css
 *}
{extends file=$layout}

{* Okruszki idą do środka strony, jak na stronie logowania. *}
{block name='breadcrumb'}{/block}

{block name='content'}
  <main class="q-container q-auth">
    {include file='_partials/breadcrumb.tpl'}

    <section class="q-auth__card">
      <header class="q-auth__head">
        <h1 class="q-section-title q-auth__title">{l s='Guest Order Tracking' d='Shop.Theme.Customeraccount'}</h1>
        <p class="q-auth__lead">{l s='To track your order, please enter the following information:' d='Shop.Theme.Customeraccount'}</p>
      </header>

      <form id="guestOrderTrackingForm" class="q-auth__form" action="{$urls.pages.guest_tracking}" method="get">
        <input type="hidden" name="controller" value="guest-tracking">

        <div class="q-auth__pair">
          <div class="mb-3 q-float">
            <label class="form-label required" for="field-order_reference">
              {l s='Order Reference' d='Shop.Forms.Labels'}
            </label>
            <input
              class="form-control"
              name="order_reference"
              id="field-order_reference"
              type="text"
              placeholder=" "
              value="{if isset($smarty.request.order_reference)}{$smarty.request.order_reference|escape:'html':'UTF-8'}{/if}"
              required
            >
            <span class="form-text">
              {l s='For example: QIIXJXNUI or QIIXJXNUI#1' d='Shop.Theme.Customeraccount'}
            </span>
          </div>

          <div class="mb-3 q-float">
            <label class="form-label required" for="field-email">
              {l s='Email' d='Shop.Forms.Labels'}
            </label>
            <input
              class="form-control"
              name="email"
              id="field-email"
              type="email"
              placeholder=" "
              autocomplete="email"
              value="{if isset($smarty.request.email)}{$smarty.request.email|escape:'html':'UTF-8'}{/if}"
              required
            >
          </div>
        </div>

        <div class="q-auth__actions">
          <button class="q-btn q-btn--primary q-btn--lg" type="submit">
            {l s='Send' d='Shop.Theme.Actions'}
            <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4"/></svg>
          </button>
        </div>
      </form>
    </section>
  </main>
{/block}
