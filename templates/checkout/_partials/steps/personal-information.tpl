{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{extends file='checkout/_partials/steps/checkout-step.tpl'}

{$stepName = 'personnal-information'}

{* „Masz już konto? Zaloguj się" w wierszu z nazwą kroku, po prawej.
   Klient bez konta ma przed sobą jeden formularz, a nie wybór między dwiema
   drogami; ten z kontem widzi wyjście od razu, nie szukając go pod polami. *}
{block name='step_title_aside'}
  {if !$customer.is_logged}
    <span class="q-checkout2__aside">
      {l s='Already have an account?' d='Shop.Theme.Checkout'}
      <button type="button" class="q-linkbtn" data-q-login-open>
        {l s='Sign in' d='Shop.Theme.Actions'}
      </button>
    </span>
  {/if}
{/block}

{* Krok ukończony: imię, nazwisko i e-mail zamiast pustych pól, czyli dokładnie to,
   co klient wpisał. `$customer` ma te dane bez względu na to, czy zalogował
   się, czy zamawia jako gość: krok 1 zapisuje je od razu po wysłaniu. *}
{block name='step_summary'}
  {$customer.firstname} {$customer.lastname} · {$customer.email}
{/block}

{block name='step_content'}
  {hook h='displayPersonalInformationTop' customer=$customer}

  {if $customer.is_logged && !$customer.is_guest}

    {* Klient zalogowany: kto zamawia i wyjście do zmiany konta. Dane i adresy wczytają się w kolejnych krokach. *}
    <div class="q-opc__account">
      <span class="q-opc__account-text">
        {l s='Signed in as' d='Shop.Theme.Checkout'}
        <strong>{$customer.firstname} {$customer.lastname}</strong>
      </span>
      <a class="q-linkbtn" href="{$urls.actions.logout}">{l s='Sign out' d='Shop.Theme.Customeraccount'}</a>
    </div>

    {if !isset($empty_cart_on_logout) || $empty_cart_on_logout}
      <p class="q-checkout2__sub">{l s='If you sign out now, your cart will be emptied.' d='Shop.Theme.Checkout'}</p>
    {/if}

    <form id="checkout-continue-form" method="GET" action="{$urls.pages.order}">
      <div class="buttons-wrapper">
        {include file='checkout/_partials/checkout-step-buttons.tpl' submit_name='controller' submit_value='order'}
      </div>
    </form>

  {else}

    {render file='checkout/_partials/customer-form.tpl' ui=$register_form guest_allowed=$guest_allowed}

    {* Logowanie w szufladzie, a nie w drugiej zakładce obok zakupu. Zakładki
       stawiały obie drogi jako równorzędne i kazały wybierać, zanim klient
       zobaczył formularz. Szuflada dokłada się z boku i zostawia widoczne to,
       co już wypełnił.

       Ta sama konwencja, co szuflada koszyka: `dialog.q-modal--drawer`
       z nagłówkiem, treścią i stopką, otwierana przez `data-q-login-open`,
       zamykana przyciskiem, klawiszem Escape i kliknięciem w tło. *}
    <dialog class="q-modal q-modal--drawer q-login-drawer"
            data-q-login-drawer aria-labelledby="q-login-drawer-title">
      <div class="q-modal__head">
        <h2 class="q-modal__title" id="q-login-drawer-title">{l s='Sign in' d='Shop.Theme.Actions'}</h2>
        <button class="q-modal__close" type="button" data-q-login-close
                aria-label="{l s='Close' d='Shop.Theme.Global'}">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor"
               stroke-width="1.8" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg>
        </button>
      </div>

      <div class="q-modal__body">
        <p class="q-checkout2__sub">{l s='We will load your details and addresses. Your order stays where you left it.' d='Shop.Theme.Checkout'}</p>
        {render file='checkout/_partials/login-form.tpl' ui=$login_form qLogowanie=true}
      </div>

      <div class="q-modal__foot">
        <button type="button" class="q-linkbtn" data-q-login-close>
          {l s='Order without signing in' d='Shop.Theme.Checkout'}
        </button>
      </div>
    </dialog>

  {/if}

  {hook h='displayPersonalInformationBottom' customer=$customer}
{/block}
