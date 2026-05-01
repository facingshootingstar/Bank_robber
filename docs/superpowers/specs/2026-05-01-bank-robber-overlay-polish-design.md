# Bank Robber Overlay Polish Design

## Goal

Make pause and result overlays match the heist UI style already used by the HUD and menus.

## Design

Use dark translucent panels, warm accent borders, styled buttons, and stronger label colors. Keep overlay layout unchanged so no gameplay flow changes.

## Testing

Static verification requires `_panel_style` helpers in pause and result overlays.
