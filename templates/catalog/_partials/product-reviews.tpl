{**
 * Quince — treść sekcji opinii w akordeonie karty produktu.
 *
 * Podsumowanie ocen i pierwsza porcja opinii wychodzą z serwera, więc widać je
 * bez JavaScriptu i czyta je wyszukiwarka. Przycisk dokłada kolejne porcje
 * w tym samym miejscu, bez szuflady i bez osobnej strony — obsługuje go wyspa
 * `islands/reviews.js`, która woła kontroler `quince_engine/reviews`.
 *
 * Dane liczy silnik: `Product\Rating` (średnia i rozkład) oraz `Product\Reviews`
 * (lista). Bez modułu opinii obie są puste i nie renderuje się nic.
 *
 * Formularz opinii jest tu jako szuflada, a nie jako okno modułu: moduł otwiera
 * swoje Bootstrapem, którego motyw nie wgrywa. Wysyłamy do jego punktu
 * końcowego, więc moderacja, kryteria i zapis zostają po jego stronie.
 *}

{assign var=qOcena value=$modules.quince_engine.rating|default:null}
{assign var=qOpinie value=$modules.quince_engine.reviews|default:null}

{if $qOcena && $qOcena.count > 0 && $qOpinie}
  <div class="q-reviews"
       data-q-reviews
       data-url="{url entity='module' name='quince_engine' controller='reviews'}"
       data-url-post="{url entity='module' name='productcomments' controller='PostComment'}"
       data-url-useful="{url entity='module' name='productcomments' controller='UpdateCommentUsefulness'}"
       data-product="{$product.id|intval}"
       data-moderated="{if $modules.quince_engine.reviews.moderated|default:false}1{else}0{/if}"
       data-msg-empty="{l s='Fill in the rating, the title and the review.' d='Shop.Theme.Catalog'}"
       data-msg-failure="{l s='The review could not be sent. Please try again in a moment.' d='Shop.Theme.Catalog'}"
       data-msg-moderated="{l s='Your review will appear once it has been approved.' d='Shop.Theme.Catalog'}"
       data-msg-published="{l s='Your review is now visible on this page.' d='Shop.Theme.Catalog'}"
       data-msg-helpful="{l s='Helpful to %count% people' d='Shop.Theme.Catalog'}">

    {* Podsumowanie: średnia po lewej, rozkład ocen po prawej. Paski porównują
       oceny między sobą, dlatego liczy je silnik od najliczniejszej, a nie od
       sumy — inaczej przy rozkładzie 37/7/2/1/0 widać byłoby tylko piątkę. *}
    <div class="q-reviews__summary">
      <div class="q-reviews__avg">
        <div class="q-reviews__avg-number">{$qOcena.averageText}</div>

        <div class="q-rating">
          <span class="q-rating__stars" aria-hidden="true">
            {foreach from=$qOcena.stars item=qStan}
              <span{if $qStan == 'full'} class="q-rating__star--filled"{elseif $qStan == 'half'} class="q-rating__star--half"{/if}>&#9733;</span>
            {/foreach}
          </span>
        </div>

        <div class="q-reviews__avg-count">
          {l s='%count% reviews' sprintf=['%count%' => $qOcena.count] d='Shop.Theme.Catalog'}
        </div>
      </div>

      <div class="q-reviews__bars">
        {foreach from=$qOcena.breakdown item=qWiersz}
          <div class="q-reviews__bar">
            <span class="q-reviews__bar-label">{$qWiersz.stars|intval}&#9733;</span>
            <span class="q-reviews__bar-track">
              <span class="q-reviews__bar-fill" style="inline-size:{$qWiersz.percent|intval}%"></span>
            </span>
            <span class="q-reviews__bar-count">{$qWiersz.count|intval}</span>
          </div>
        {/foreach}
      </div>
    </div>

    <div class="q-reviews__list" data-q-reviews-list>
      {foreach from=$qOpinie.items item=qOpinia}
        {include file='catalog/_partials/product-review.tpl' qOpinia=$qOpinia qPrzydatnosc=$qOpinie.usefulness}
      {/foreach}
    </div>

    <div class="q-reviews__actions">
      {* Przycisk doładowania znika, gdy nie ma czego doładować: zostawiony
         obiecywałby więcej opinii, niż ich jest. *}
      {if $qOpinie.hasMore}
        <button class="q-btn q-btn--ghost q-btn--sm" type="button" data-q-reviews-more>
          {l s='Show all reviews' d='Shop.Theme.Actions'}
        </button>
      {/if}

      {* Przycisk pisania stoi tylko wtedy, gdy moduł na pewno przyjmie opinię.
         Przy wyłączonych opiniach od gości kończyłby się jego odmową, więc
         niezalogowany dostaje w tym miejscu drogę do konta, a nie ślepy
         przycisk. Adres wraca na tę stronę po zalogowaniu. *}
      {if $qOpinie.canPost}
        <button class="q-btn q-btn--secondary q-btn--sm" type="button" data-q-review-open>
          {l s='Write a review' d='Shop.Theme.Actions'}
        </button>
      {else}
        <a class="q-btn q-btn--secondary q-btn--sm"
           href="{$urls.pages.authentication}?back={$urls.current_url|urlencode}">
          {l s='Sign in to write a review' d='Shop.Theme.Catalog'}
        </a>
      {/if}
    </div>

    {if $qOpinie.canPost}
      {include file='catalog/_partials/product-review-form.tpl' qKryteria=$qOpinie.criteria}
    {/if}
  </div>
{else}
  <div class="q-reviews q-reviews--empty"
       data-q-reviews
       data-url="{url entity='module' name='quince_engine' controller='reviews'}"
       data-url-post="{url entity='module' name='productcomments' controller='PostComment'}"
       data-url-useful="{url entity='module' name='productcomments' controller='UpdateCommentUsefulness'}"
       data-product="{$product.id|intval}"
       data-moderated="{if $modules.quince_engine.reviews.moderated|default:false}1{else}0{/if}"
       data-msg-empty="{l s='Fill in the rating, the title and the review.' d='Shop.Theme.Catalog'}"
       data-msg-failure="{l s='The review could not be sent. Please try again in a moment.' d='Shop.Theme.Catalog'}"
       data-msg-moderated="{l s='Your review will appear once it has been approved.' d='Shop.Theme.Catalog'}"
       data-msg-published="{l s='Your review is now visible on this page.' d='Shop.Theme.Catalog'}"
       data-msg-helpful="{l s='Helpful to %count% people' d='Shop.Theme.Catalog'}">

    <div class="q-empty">
      <p>{l s='This product has no reviews yet.' d='Shop.Theme.Catalog'}</p>

      {if $modules.quince_engine.reviews.canPost|default:false}
        <button class="q-btn q-btn--secondary q-btn--sm" type="button" data-q-review-open>
          {l s='Write the first review' d='Shop.Theme.Catalog'}
        </button>
      {else}
        <a class="q-btn q-btn--secondary q-btn--sm"
           href="{$urls.pages.authentication}?back={$urls.current_url|urlencode}">
          {l s='Sign in to write a review' d='Shop.Theme.Catalog'}
        </a>
      {/if}
    </div>

    {if $modules.quince_engine.reviews.canPost|default:false}
      {include file='catalog/_partials/product-review-form.tpl' qKryteria=$modules.quince_engine.reviews.criteria|default:[]}
    {/if}
  </div>
{/if}
