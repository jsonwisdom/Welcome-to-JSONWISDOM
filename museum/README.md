# JSONWisdom Digital Museum — Professional Gallery Draft

A clean, museum-style presentation of 20 independently verifiable mathematical artworks.

## Visual design

- Dark gallery aesthetic with refined typography (Inter + Playfair Display)
- Exhibit cards with framed canvases, type badges, and clear verification states
- Header with verification principle and meta bar
- “Verify All” control and per-exhibit Verify buttons
- Status shown as MATCH / MISMATCH / UNVERIFIED with the actual SHA-256 hashes

## Files

- `index.html` — professional gallery page
- `renderers.js` — pure deterministic rendering (browser + Node)
- `manifest.json` — exhibit definitions + frozen reference hashes
- `compute-hashes.js` — regenerates reference hashes

Open `index.html` (serve the folder locally) to view the gallery. Click Verify on any exhibit to recompute the exact 200×200 RGBA pixels and compare the SHA-256.
