{**
 * Quince — stopka.
 *
 * Cztery kolumny: pierwsza z danymi firmy i kontaktem, pozostałe wypełniają
 * moduły przez hooki przypisane do kolumn w ustawieniach silnika. Kolumna bez
 * treści nie zostaje pusta — wypada, żeby siatka nie miała dziury.
 *
 * Klasy: themes/quince/assets/css/components/footer.css
 * Projekt: makieta strony produktu.
 *}
{assign var=qf value=$modules.quince_engine.footer}

{capture name="pasek_nad_stopka"}
  {foreach from=$qf.strip.hooks item=hook}{hook h=$hook}{/foreach}
{/capture}

{if $smarty.capture.pasek_nad_stopka|trim}
  <div class="q-footer-strip{if $qf.strip.full} q-footer-strip--full{/if}">
    <div class="q-container">
      {$smarty.capture.pasek_nad_stopka nofilter}
    </div>
  </div>
{/if}

<footer class="q-footer" id="footer" data-q-footer>
  <div class="q-container">
    <div class="q-footer__cols">

      {* ── firma i kontakt ── *}
      <div class="q-footer__col q-footer__col--wide">
        {if $qf.company.title}
          <h2 class="q-footer__title" id="q-footer-firma">{$qf.company.title}</h2>
        {/if}

        {if $qf.company.text}
          <p class="q-footer__text">{$qf.company.text}</p>
        {/if}

        <div class="q-footer__contact">
          {foreach from=['address', 'phone', 'email', 'hours'] item=klucz}
            {assign var=wiersz value=$qf.contact.$klucz}

            {if $wiersz.value}
              <div class="q-footer__contact-item">
                <svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">{$wiersz.icon nofilter}</svg>

                <span>
                  {if $klucz === 'phone'}
                    <a href="tel:{$wiersz.value|replace:' ':''}">{$wiersz.value}</a>
                  {elseif $klucz === 'email'}
                    <a href="mailto:{$wiersz.value}">{$wiersz.value}</a>
                  {else}
                    {$wiersz.value}
                  {/if}
                </span>
              </div>
            {/if}
          {/foreach}
        </div>

        {if $qf.socials}
          <div class="q-footer__socials">
            {foreach from=$qf.socials item=social}
              <a class="q-footer__social" href="{$social.url|escape:'html':'UTF-8'}"
                 target="_blank" rel="noopener"
                 aria-label="{$social.name|replace:'-':' '|capitalize|escape:'html':'UTF-8'}">
                <svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">{$social.icon nofilter}</svg>
              </a>
            {/foreach}
          </div>
        {/if}
      </div>

      {* ── kolumny modułów ── *}
      {foreach from=$qf.columns item=column name=kolumny}
        {capture name="kolumna_{$smarty.foreach.kolumny.index}"}
          {foreach from=$column.hooks item=hook}{hook h=$hook}{/foreach}
        {/capture}

        {assign var=tresc value=$smarty.capture["kolumna_{$smarty.foreach.kolumny.index}"]}

        {if $tresc|trim}
          <div class="q-footer__col">
            {if $column.label}
              <h2 class="q-footer__title" id="q-footer-kol-{$smarty.foreach.kolumny.index}">{$column.label}</h2>
            {/if}

            <nav class="q-footer__nav"{if $column.label} aria-labelledby="q-footer-kol-{$smarty.foreach.kolumny.index}"{/if}>
              {$tresc nofilter}
            </nav>
          </div>
        {/if}
      {/foreach}

    </div>
  </div>

  <div class="q-footer__bar">
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
  </div>
</footer>

{* Zbiorczy hook PrestaShopa. Moduły wrzucają w niego i treść, i własne szablony
   JavaScriptu, więc gdy sklep nie przypisał go do żadnej kolumny, wypisujemy go
   tutaj — poza stopką, żeby jej treść została treścią. *}
{if !$qf.catchAllInColumn}
  {hook h='displayFooter'}
{/if}

{if $qf.totop}
  <button class="q-totop" type="button" data-q-totop
          aria-label="{l s='Back to top' d='Shop.Theme.Actions'}">
    <svg width="18" height="18" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true">
      <path fill-rule="evenodd" d="M8 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 1 0 .708.708L7.5 2.707V14.5a.5.5 0 0 0 .5.5"/>
    </svg>
  </button>
{/if}
