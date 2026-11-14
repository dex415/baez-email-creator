# BAEZ Email Creator

Marketing email bodies for BAEZ, for pasting into
**Shopify Messaging → Add section → Custom → Custom Liquid**. Shopify renders the
logo band above and the unsubscribe footer below; this tool builds the middle.

One self-contained file (`index.html`), no build step. Open it locally or host it
on GitHub Pages with `bash deploy.sh`.

## Where this came from

A fork of the TWNTY-TWO® Email Creator (`dex415/twntytwo-email-creator`). The
email markup each block emits is the same, so a layout fix in one can be
copied to the other.
What is different here:

| | TWNTY-TWO | BAEZ |
|---|---|---|
| Brand config | scattered defaults | one `BRAND` block at the top of the script |
| Language | English only | **English / Español** per template |
| Brand look | one | **BAEZ** or **UNDERGOLD × BAEZ** per template |
| Drop starter | bar, lockup, hero, CTA, details, grid, footer | tag, lockup, hero, CTA, details |
| Footer | Footer Grid block with icon assets | **socials footer** under the card (+ optional Footer Grid block) |
| Empty image | broken image | dashed placeholder + warning |
| Pre-send checks | none | warning strip above the preview |
| Storage keys | `tt_ec_*`, table `tt_email_templates` | `bz_ec_*`, table `bz_email_templates` |

For identical content in the BAEZ look the two tools still emit identical HTML.

## Brand settings

Everything BAEZ-specific is the `BRAND` object near the top of the first
`<script>`: store URL, help centre URL, Instagram URL, subscribe URL, policy
URLs, logo URL and the accent colour. A link left empty is simply left out of
the email (for example the Instagram and Subscribe footer buttons), so nothing
dead ships. This repo is public — URLs only, never keys.

## Blocks added here

- **Stacked Rows** — centred two-line pairs (a date and what happens on it, key
  facts). The free-form version of Drop Details.
- **Image** — the Size slider goes down to 20% so logos can sit small.

## Socials footer

`BAEZ socials footer` (on for new templates) adds the block from
`baezonline.com/pages/subscribe` in its own row under the card: Download BAEZ,
Instagram, TikTok, Threads, Facebook, Contact, then the three channels. It
follows the email language. In the BAEZ look the markup is that block exactly;
in UNDERGOLD × BAEZ it is restyled to the guide (capitals, Acumin Pro, square,
white app button, dark-green outlines) and kept neutral so the registration
button stays the only green one. Links and labels live in the `SOCIALS` object.

**Icons.** They load from Shopify Files as `bz-email-<name>.png` — eight files
(72×72, transparent): `apple-black`, `instagram-white`, `tiktok-white`,
`threads-white`, `facebook-white`, `mail-white`, `ig-channel-white`,
`whatsapp-white`. The exact `?v=` of each upload is in `SOCIALS.iconV`; if an
icon is re-uploaded, put its new `?v=` there. The tool tries to load each one
and warns when any is missing; `Icons on the socials buttons` turns them off,
and the footer then goes out as centred text buttons.

The old **Footer Grid** block is still in the palette but no longer part of the
starters.

## Import / export

`.json` downloads the open template; **Import** loads one back (on any machine,
no Supabase needed). Unknown blocks are dropped and missing fields filled in.
Importing does not save — hit Save to keep it in this browser.

## Brand looks

`Brand look` in the Email panel restyles the same blocks; the markup and the
Shopify layout rules do not change. New templates start in the last look used.

**BAEZ** — the default dark card.

**UNDERGOLD × BAEZ** — the collaboration look, taken from the Undergold brand
book (`UG_BRANDBOOK.pdf`) and the collab colour sheet:

| Rule in the guide | In the email |
|---|---|
| Palette: black `#000000`, grey `#737373`, white `#F1F1F1` | canvas + card black, labels grey, text white |
| `#65C128` main colour | Shop button, campaign tag, links, outline buttons |
| `#39FF14` highlights / lighting | channel line under the lockup + the glow on it and on the Shop button |
| `#194D13` depth | card border, hairlines, bar and well borders |
| Acumin Pro for text and pieces | first in the font stack (see below) |
| Sustained capitals, tracking 50–100 | everything uppercase, letter-spacing held between 0.05em and 0.10em |
| Bold + regular pairing in headings | collection name bold, status line regular |
| Square, technical layouts | all corner radii 0 |

Glows are `text-shadow` / `box-shadow`; inboxes that drop them just show the
flat colour. Bahnschrift (the guide's secondary face, for the logo) is not
used: the logo should go in as an image.

## Brand font (Acumin Pro)

Email can only show a custom font where the inbox supports web fonts — Apple
Mail and iOS Mail do; Gmail and Outlook never do and show the fallback
(Helvetica / Arial), which is why the stack is
`acumin-pro,'Acumin Pro','Helvetica Neue',Helvetica,Arial,sans-serif`.

Acumin Pro is an Adobe font. Adobe licenses it for email only through an
Adobe Fonts **web project** embed, not by hosting the font files yourself, so:

1. In Adobe Fonts (the Creative Cloud account that owns the licence) create a
   web project with Acumin Pro **Regular** and **Bold**.
2. Copy the project ID (the 7 characters in `use.typekit.net/xxxxxxx.css`).
3. Paste it into `Adobe Fonts web project ID`. The Liquid then starts with
   `<style>@import url("https://use.typekit.net/xxxxxxx.css");</style>`.

Leave the field blank and the email goes out with the fallback everywhere.
**Never commit the .otf files to this repo — it is public.** Install them on
your own machine (Font Book) and the preview shows Acumin Pro without the
project ID. The `Font:` button above the preview switches to the fallback so
you can see what Gmail and Outlook readers get; it never changes the Liquid.

## Language

`Email language` in the Email panel switches the built-in labels (Drop Details
rows, pre-order fine print). Starter copy that has not been edited flips with
it; anything typed by hand is left exactly as typed. New blocks are created in
the template's language, and the tool remembers the last language used.

## Pre-send checks

The amber strip above the preview lists what should not reach a customer list:
empty image slots, starter placeholders (`COLLECTION NAME`, `YOURCODE`, the
Announcement Bar placeholder), Liquid over Shopify's 50 KB limit for a Custom
Liquid section, and a malformed Adobe Fonts ID. `Copy Liquid` still copies, but
says so.

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
