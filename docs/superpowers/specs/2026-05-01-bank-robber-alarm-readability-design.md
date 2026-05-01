# Bank Robber Alarm Readability Design

## Goal

Make alarm pressure readable at a glance.

## Design

The HUD alarm fill changes color by alarm ratio:

- Low alarm: cool green.
- Medium alarm: amber.
- High alarm: red.

This keeps the HUD compact while giving stronger feedback during stealth mistakes.

## Testing

Static verification requires the `_alarm_color` helper.
