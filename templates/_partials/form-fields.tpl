{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{if $field.type == 'hidden'}

  {block name='form_field_item_hidden'}
    <input type="hidden" name="{$field.name}" value="{$field.value}">
  {/block}

{else}

  {* Pływająca etykieta: napis startuje pośrodku pola, a po kliknięciu albo po
     wpisaniu treści przesuwa się do jego górnej krawędzi i tam zostaje. To nie jest placeholder, tylko
     prawdziwa etykieta powiązana z polem, więc czytnik ekranu i klikanie w napis
     działają jak wcześniej, a po wypełnieniu formularza nadal wiadomo, co jest
     w którym polu (placeholder by wtedy zniknął).

     Stan pola rozpoznajemy w CSS, po `:placeholder-shown` na kontrolce obok,
     dlatego pola bez własnego napisu podpowiedzi dostają pusty placeholder.
     Kolejność znaczników zostaje ta sama, etykieta przed polem: przenoszenie
     jej za pole psułoby kolejność czytania w czytniku ekranu.

     Wybory (pole wyboru, przełączniki) tego nie dostają: tam etykieta stoi obok
     kontrolki i nie ma dokąd pływać. *}
  {assign var=qPlywa value=!in_array($field.type, ['checkbox', 'radio-buttons', 'birthday'])}


  {* Obszar wieloliniowy dostaje napis NAD polem: pływający przy przewijanym
     tekście rozjeżdża się względem treści. Listy rozwijane i pola dat pokazują
     wartość od początku, więc napis stoi u nich uniesiony zawsze. *}
  <div class="mb-3{if $qPlywa} q-float{/if}{if $field.type === 'textarea'} q-float--multiline{/if}{if $field.name === 'vat_number' && !empty($qViesLookup)} q-float--action{/if}{if $field.type === 'password'} q-float--action q-float--eye{/if}{if $field.type === 'select' || $field.type === 'countrySelect' || $field.type === 'date'} q-float--stale{/if}{if !empty($field.errors)} has-error{/if}">
    {if ($field.type !== 'checkbox')}
      <label class="form-label{if $field.required} required{/if}" for="field-{$field.name}">
        {if $field.type !== 'checkbox'}
          {$field.label}
        {/if}
      </label>
    {/if}

    {if $field.type === 'select'}

      {block name='form_field_item_select'}
        <select class="form-select" name="{$field.name}" id="field-{$field.name}" {if $field.required}required{/if}>
          <option value disabled selected>{l s='-- please choose --' d='Shop.Forms.Labels'}</option>
          {foreach from=$field.availableValues item="label" key="value"}
            <option value="{$value}" {if $value eq $field.value} selected {/if}>{$label}</option>
          {/foreach}
        </select>
      {/block}

    {elseif $field.type === 'countrySelect'}

      {block name='form_field_item_country'}
        <select
        class="form-select js-country"
        name="{$field.name}"
        id="field-{$field.name}"
        {if $field.required}required{/if}
        >
          <option value disabled selected>{l s='-- please choose --' d='Shop.Forms.Labels'}</option>
          {foreach from=$field.availableValues item="label" key="value"}
            <option value="{$value}" {if $value eq $field.value} selected {/if}>{$label}</option>
          {/foreach}
        </select>
      {/block}

    {elseif $field.type === 'radio-buttons'}

      {block name='form_field_item_radio'}
        <div aria-labelledby="field-{$field.name}-label">
          <p class="visually-hidden" id="field-{$field.name}-label">{$field.label}</p>
          {foreach from=$field.availableValues item="label" key="value"}
            <div class="form-check form-check-inline">
              <input
                class="form-check-input"
                type="radio"
                name="{$field.name}"
                id="field-{$field.name}_{$value}"
                value="{$value}"
                {if $field.required}required{/if}
                {if $value eq $field.value} checked {/if}
              >
              <label class="form-check-label" for="field-{$field.name}_{$value}">
                {$label}
              </label>
            </div>
          {/foreach}
        </div>
      {/block}

    {elseif $field.type === 'checkbox'}

      {block name='form_field_item_checkbox'}
        <div class="form-check">
          <input
            class="form-check-input"
            name="{$field.name}"
            type="checkbox"
            value="1"
            id="field-{$field.name}"
            value="1" {if $field.value}checked="checked"{/if}
            {if $field.required}required{/if}
          >
          <label class="form-check-label{if $field.required} required{/if}" for="field-{$field.name}">
            {$field.label nofilter}
          </label>
        </div>
      {/block}

    {elseif $field.type === 'date'}

      {block name='form_field_item_date'}
        <input
          name="{$field.name}"
          class="form-control"
          type="date"
          id="field-{$field.name}"
          value="{$field.value}"
          {if isset($field.availableValues.placeholder)}
            placeholder="{$field.availableValues.placeholder}"
            aria-label="{$field.availableValues.placeholder}"
          {/if}
          {if $field.required}required{/if}
        >
        {* Podpowiedź rdzenia opisuje regułę walidacji („Only letters and the
           dot (.) character…"), a nie to, co klient ma zrobić. W kasie jej nie
           pokazujemy: komunikat pojawia się dopiero przy błędzie i mówi wprost,
           co poprawić. Na pozostałych stronach zostaje. *}
        {if isset($field.availableValues.comment)}
          <span class="form-text form-text--rule">
            {$field.availableValues.comment}
          </span>
        {/if}
      {/block}

    {elseif $field.type === 'birthday'}

      {block name='form_field_item_birthday'}
        <div class="js-parent-focus">
          {html_select_date
          field_order=DMY
          time={$field.value}
          field_array={$field.name}
          prefix=false
          reverse_years=true
          field_separator='<br>'
          day_extra='class="form-select"'
          month_extra='class="form-select"'
          year_extra='class="form-select"'
          day_empty={l s='-- day --' d='Shop.Forms.Labels'}
          month_empty={l s='-- month --' d='Shop.Forms.Labels'}
          year_empty={l s='-- year --' d='Shop.Forms.Labels'}
          start_year={'Y'|date}-100 end_year={'Y'|date}
          }
        </div>
      {/block}

    {elseif $field.type === 'password'}

      {block name='form_field_item_password'}
        {* Enforce policy check only for new passwords (autocomplete="new-password") existing ones may predate the current policy and must stay usable. *}
        {assign var='apply_password_policy' value=($field.autocomplete|default:'') === 'new-password'}

        {* Podgląd hasła stoi W POLU, przy jego prawym końcu — jak przycisk
           pobrania danych przy NIP-ie. Rdzeń stawia go OBOK pola, jako drugi
           człon `input-group`, i daje mu wygląd przycisku głównego: pole
           hasła wyglądało wtedy jak pole z doklejonym żółtym klockiem.

           Znak rysuje wpisany tu SVG, a nie krój znaków PrestaShopa:
           Quince go nie ładuje, więc znak z kroju jest pustym kwadratem. *}
        <input
            class="form-control"
            name="{$field.name}"
            id="field-{$field.name}"
            type="password"
            placeholder=" "
              {if $field.autocomplete}autocomplete="{$field.autocomplete}"{/if}
            value=""
            {if $apply_password_policy}
              minlength="{$configuration.password_policy.minimum_length|default:8}"
              maxlength="{$configuration.password_policy.maximum_length|default:72}"
              data-minscore="{$configuration.password_policy.minimum_score|default:3}"
              data-bs-placement="top"
              data-bs-trigger="manual"
              data-ps-ref="password-policy-input"
            {/if}
            spellcheck="false"
            {if $field.required}required{/if}
          >

        <button
          class="q-float__action q-float__eye"
          type="button"
          hidden
          data-q-eye
          data-text-show="{l s='Show password' d='Shop.Theme.Actions'}"
          data-text-hide="{l s='Hide password' d='Shop.Theme.Actions'}"
          aria-label="{l s='Show password' d='Shop.Theme.Actions'}"
          aria-controls="field-{$field.name}"
        >
          <svg class="q-float__eye-on" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5s3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5s-3.879-1.168-5.168-2.457A13 13 0 0 1 1.172 8z"/><path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/></svg>
          <svg class="q-float__eye-off" width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M13.359 11.238C15.06 9.72 16 8 16 8s-3-5.5-8-5.5a7 7 0 0 0-2.79.588l.77.771A6 6 0 0 1 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755q-.247.248-.517.486z"/><path d="M11.297 9.176a3.5 3.5 0 0 0-4.474-4.474l.823.823a2.5 2.5 0 0 1 2.829 2.829zm-2.943 1.299.822.822a3.5 3.5 0 0 1-4.474-4.474l.823.823a2.5 2.5 0 0 0 2.829 2.829"/><path d="M3.35 5.47q-.27.24-.518.487A13 13 0 0 0 1.172 8l.195.288c.335.48.83 1.12 1.465 1.755C4.121 11.332 5.881 12.5 8 12.5c.716 0 1.39-.133 2.02-.36l.77.772A7 7 0 0 1 8 13.5C3 13.5 0 8 0 8s.939-1.721 2.641-3.238l.708.709z"/><path d="m13.646 14.354-12-12 .708-.708 12 12z"/></svg>
        </button>

        {if $apply_password_policy}
          <div data-ps-target="password-feedback-target"></div>
        {/if}
      {/block}

    {elseif $field.type === 'textarea'}

      {block name='form_field_item_textarea'}
        <textarea
          id="field-{$field.name}"
          class="form-control"
          name="{$field.name}"
          placeholder=" "
          {if $field.maxLength}maxlength="{$field.maxLength}"{/if}
          {if $field.required}required{/if}
          {if isset($field.availableValues.rows)}rows="{$field.availableValues.rows}"{/if}
          {if isset($field.availableValues.cols)}cols="{$field.availableValues.cols}"{/if}
        >{$field.value|default}</textarea>
        {* Podpowiedź rdzenia opisuje regułę walidacji („Only letters and the
           dot (.) character…"), a nie to, co klient ma zrobić. W kasie jej nie
           pokazujemy: komunikat pojawia się dopiero przy błędzie i mówi wprost,
           co poprawić. Na pozostałych stronach zostaje. *}
        {if isset($field.availableValues.comment)}
          <span class="form-text form-text--rule">
            {$field.availableValues.comment}
          </span>
        {/if}
      {/block}

    {else}

      {block name='form_field_item_other'}
        <input
          class="form-control"
          name="{$field.name}"
          id="field-{$field.name}"
          type="{$field.type}"
          value="{$field.value}"
          {if $field.autocomplete}autocomplete="{$field.autocomplete}"{/if}
          placeholder=" "
          {if $field.maxLength}maxlength="{$field.maxLength}"{/if}
          {if !empty($field.minLength)}minlength="{$field.minLength}"{/if}
          aria-label="{$field.label}"
          {if $field.required}required{/if}
        >
        {* Podpowiedź rdzenia opisuje regułę walidacji („Only letters and the
           dot (.) character…"), a nie to, co klient ma zrobić. W kasie jej nie
           pokazujemy: komunikat pojawia się dopiero przy błędzie i mówi wprost,
           co poprawić. Na pozostałych stronach zostaje. *}
        {if isset($field.availableValues.comment)}
          <span class="form-text form-text--rule">
            {$field.availableValues.comment}
          </span>
        {/if}

        {* Pobranie danych firmy z rejestru. Przycisk stoi W POLU, przy jego
           prawym końcu, a napis i wartość dostają tam tyle miejsca, żeby pod
           niego nie wchodziły. Zapytanie idzie przez silnik (`quince_engine`,
           kontroler `vies`), bo przeglądarka nie odpyta rejestru bezpośrednio.
           `$qViesLookup` ustawia silnik według zakładki „Zamówienie” w panelu. *}
        {if $field.name === 'vat_number' && !empty($qViesLookup)}
          <button type="button" class="q-btn q-btn--secondary q-float__action" data-q-vies>
            {l s='Fetch details' d='Shop.Theme.Actions'}
          </button>
        {/if}
      {/block}

    {/if}

    {* Zdanie mówiące, po co pole. Stoi W GRUPIE POLA, nad komunikatem
       o błędzie — tak ma prototyp kasy. Doklejone za grupą lądowałoby przy
       polu poniżej, bo to grupa niesie odstęp do następnego wiersza.

       Pisze je ten szablon, a nie nadpisanie w `customer-form.tpl`:
       `form-fields.tpl` jest DOŁĄCZANY, a nie dziedziczony, więc bloków
       z jego wnętrza nie da się nadpisać z zewnątrz. *}
    {if $field.type === 'email' && $page.page_name === 'checkout' && !isset($qLogowanie)}
      <div class="form-text">{l s='We will send the order confirmation and the invoice here.' d='Shop.Theme.Checkout'}</div>
    {/if}

    {block name='form_field_errors'}
      {include file='_partials/form-errors.tpl' errors=$field.errors}
    {/block}

    {* Przykład formatu stoi POD polem, nie w nim: pole ma już napis w środku,
       a druga podpowiedź w tym samym miejscu przebijałaby spod niego.

       Pole urodzin ma już ten sam format w `comment` wyżej („Np.: 1970-05-31”) —
       nie dokładamy więc tu drugiej linijki z gołym wzorcem („RRRR-MM-DD”),
       bo mówi dokładnie to samo drugi raz. *}
    {block name='form_field_placeholder'}
      {if isset($field.availableValues.placeholder) && $qPlywa && $field.name !== 'birthday'}
        <div class="form-text">{$field.availableValues.placeholder}</div>
      {/if}
    {/block}

    {* Jedna konwencja oznaczeń w formularzu: gwiazdka przy polach wymaganych
       i legenda nad formularzem. Osobny wiersz „Optional" pod każdym polem bez
       gwiazdki mówił to samo po raz drugi i rozbijał rytm listy. *}
    {block name='form_field_comment'}{/block}
  </div>
{/if}
