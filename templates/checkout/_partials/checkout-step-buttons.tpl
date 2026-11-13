{**
 * For the full copyright and license information, please view the
 * LICENSE.md file that was distributed with this source code.
 *}
{* Przyciski kroku: „Wstecz" przy lewej krawędzi, „Dalej" przy prawej:
   ten sam rząd, rozsunięty na boki. Nazwa kroku, do którego prowadzą,
   stoi już w pasku kroków i w nagłówku sekcji, więc napis na przycisku
   zostaje krótki: samo „Dalej", samo „Wstecz". *}

{if isset($previous_step) && (!isset($show_back_button) || $show_back_button)}
  <button class="q-linkbtn q-linkbtn--back js-back" type="button" data-step="{$previous_step.identifier}">
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 6l-6 6 6 6"></path></svg>
    {l s='Back' d='Shop.Theme.Actions'}
  </button>
{/if}

{if isset($next_step) && (!isset($show_next_button) || $show_next_button)}
  <button type="{if isset($submit_type)}{$submit_type}{else}submit{/if}" class="btn btn-primary" {if isset($submit_name)}name="{$submit_name}"{/if} {if isset($submit_value)}value="{$submit_value}"{/if}>
    {l s='Continue' d='Shop.Theme.Actions'}
  </button>
{/if}
