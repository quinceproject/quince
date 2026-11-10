{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
 {block name='account_transformation_form'}
  <h3>{l s='Save time on your next order, sign up now' d='Shop.Theme.Checkout'}</h3>

  <div class="rich-text">
    <ul>
      <li>{l s='Personalized and secure access' d='Shop.Theme.Customeraccount'}</li>
      <li>{l s='Fast and easy checkout' d='Shop.Theme.Customeraccount'}</li>
      <li>{l s='Easier merchandise return' d='Shop.Theme.Customeraccount'}</li>
    </ul>
  </div>

  <form method="post">
    <input type="hidden" name="submitTransformGuestToCustomer" value="1">

    <div class="mb-3 q-float q-float--action q-float--eye">
      <label class="form-label" for="field-password">
        {l s='Set your password:' d='Shop.Forms.Labels'}
      </label>

      <input
        class="form-control"
        name="password"
        id="field-password"
        type="password"
        placeholder=" "
        autocomplete="new-password"
        value=""
        minlength="{$configuration.password_policy.minimum_length|default:8}"
        maxlength="{$configuration.password_policy.maximum_length|default:72}"
        data-minscore="{$configuration.password_policy.minimum_score|default:3}"
        data-bs-placement="top"
        data-bs-trigger="manual"
        data-ps-ref="password-policy-input"
        data-validate="isPasswd"
        spellcheck="false"
        required
      >

      <button
        class="q-float__action q-float__eye"
        type="button"
        hidden
        data-q-eye
        data-text-show="{l s='Show password' d='Shop.Theme.Actions'}"
        data-text-hide="{l s='Hide password' d='Shop.Theme.Actions'}"
        aria-label="{l s='Show password' d='Shop.Theme.Actions'}"
        aria-controls="field-password"
      >
        <svg class="q-float__eye-on" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5s3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5s-3.879-1.168-5.168-2.457A13 13 0 0 1 1.172 8z"/><path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/></svg>
        <svg class="q-float__eye-off" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M13.359 11.238C15.06 9.72 16 8 16 8s-3-5.5-8-5.5a7 7 0 0 0-2.79.588l.77.771A6 6 0 0 1 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755q-.247.248-.517.486z"/><path d="M11.297 9.176a3.5 3.5 0 0 0-4.474-4.474l.823.823a2.5 2.5 0 0 1 2.829 2.829zm-2.943 1.299.822.822a3.5 3.5 0 0 1-4.474-4.474l.823.823a2.5 2.5 0 0 0 2.829 2.829"/><path d="M3.35 5.47q-.27.24-.518.487A13 13 0 0 0 1.172 8l.195.288c.335.48.83 1.12 1.465 1.755C4.121 11.332 5.881 12.5 8 12.5c.716 0 1.39-.133 2.02-.36l.77.772A7 7 0 0 1 8 13.5C3 13.5 0 8 0 8s.939-1.721 2.641-3.238l.708.709z"/><path d="m13.646 14.354-12-12 .708-.708 12 12z"/></svg>
      </button>

      <div data-ps-target="password-feedback-target"></div>
    </div>

    <div class="buttons-wrapper buttons-wrapper--end">
      <button class="btn btn-primary" type="submit">{l s='Create account' d='Shop.Theme.Actions'}</button>
    </div>
  </form>
{/block}
