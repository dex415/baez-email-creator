# BAEZ Email Creator

Marketing email bodies for BAEZ, for pasting into
**Shopify Messaging → Add section → Custom → Custom Liquid**. Shopify renders the
logo band above and the unsubscribe footer below; this tool builds the middle.

One self-contained file (`index.html`), no build step. Open it locally or host it
on GitHub Pages with `bash deploy.sh`.

## Where this came from

A fork of the TWNTY-TWO® Email Creator (`dex415/twntytwo-email-creator`). The
email markup each block emits is the same — for identical content the two tools
produce identical HTML — so a layout fix in one can be copied to the other.
What is different here:

| | TWNTY-TWO | BAEZ |
|---|---|---|
| Brand config | scattered defaults | one `BRAND` block at the top of the script |
| Language | English only | **English / Español** per template |
| Drop starter | bar, lockup, hero, CTA, details, grid, footer | tag, lockup, hero, CTA, details |
| Footer Grid | four fixed buttons with icon assets | editable button list, text only |
| Empty image | broken image | dashed placeholder + warning |
| Pre-send checks | none | warning strip above the preview |
| Storage keys | `tt_ec_*`, table `tt_email_templates` | `bz_ec_*`, table `bz_email_templates` |

## Brand settings

Everything BAEZ-specific is the `BRAND` object near the top of the first
`<script>`: store URL, help centre URL, Instagram URL, subscribe URL, policy
URLs, logo URL and the accent colour. A link left empty is simply left out of
the email (for example the Instagram and Subscribe footer buttons), so nothing
dead ships. This repo is public — URLs only, never keys.

## Language

`Email language` in the Email panel switches the built-in labels (Drop Details
rows, pre-order fine print). Starter copy that has not been edited flips with
it; anything typed by hand is left exactly as typed. New blocks are created in
the template's language, and the tool remembers the last language used.

## Pre-send checks

The amber strip above the preview lists what should not reach a customer list:
empty image slots and starter placeholders (`COLLECTION NAME`, `YOURCODE`, the
Announcement Bar placeholder). `Copy Liquid` still copies, but says so.

## Critical layout note

The card table carries `width:100%; max-width:520px; margin:0 auto`. The
`margin:0 auto` is load-bearing — a width:100% table with a max-width is a block
box and `<td align="center">` does NOT centre it. Without it Shopify renders the
card flush left. Card padding lives on a `<td>`, never on the width:100% table.

## What does and doesn't export

Subject and preheader are stored with the template but never appear in the
Liquid — Custom Liquid cannot set them. Copy them into Shopify's Email details
panel by hand (there are Copy buttons next to each).

## Shopify Messaging setup

1. Messaging → Create message → Email
2. **Email colors**: Content background `#000000`, Border `#000000`
3. Delete the default image + button sections
4. Add section → Custom → **Custom Liquid** → paste
5. Set Subject + Preview text by hand
6. Send a test before scheduling

## Product image sizing — Shopify CDN behaviour (measured)

On `/files/` URLs the Shopify CDN **ignores** `crop=center` and the legacy
`_1200x1200_crop_center` filename form — it only honours `width`. It DOES honour
`pad_color`, which returns the exact box requested and letterboxes the
remainder. So **Match all image shapes** appends
`&width=1200&height=1200&pad_color=<hex>`. Set the pad colour to match the image
background and the padding is invisible. The per-product **Size** slider only
shrinks — email clients don't support the CSS needed to zoom in.

## Saved templates

Browser localStorage by default. For shared storage, run `supabase-schema.sql`
on an **internal** Supabase project and paste its URL + anon key into Settings.
Do not use the BAEZ app's production project for this: its anon key ships inside
the mobile apps, and the simple policy in the schema lets anon read and write.
