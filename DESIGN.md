# Design System Specification: The Sacred Script

## 1. Overview & Creative North Star
**Creative North Star: "The Digital Illuminated Manuscript"**

This design system rejects the "utilitarian app" aesthetic in favor of a high-end editorial experience. It draws inspiration from the heritage of Ethiopic manuscripts—where every stroke of the Ge’ez script carries weight and every margin provides room for contemplation. 

We break the "template" look by utilizing **intentional asymmetry** and **tonal layering**. Instead of rigid grids and boxes, we use expansive white space and shifting surface tones to guide the eye. The interface should feel less like a software tool and more like a curated, sacred space that breathes.

---

## 2. Colors & Surface Philosophy
The palette is rooted in tradition but executed with modern sophistication. We use deep burgundies (`primary`) and muted golds (`secondary`) to signify importance, set against a canvas of soft off-whites.

### The "No-Line" Rule
**Explicit Instruction:** Traditional 1px solid borders are strictly prohibited for sectioning. Structural boundaries must be defined solely through:
1.  **Background Color Shifts:** Placing a `surface-container-low` component on a `surface` background.
2.  **Negative Space:** Using the Spacing Scale to create "islands" of content.
3.  **Tonal Transitions:** Subtle shifts from `surface` to `surface-variant`.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of premium vellum.
*   **Base:** `surface` (#fcf9f8) is the foundation.
*   **Depth:** Use `surface-container-low` (#f6f3f2) for large background sections and `surface-container-highest` (#e5e2e1) for interactive elements like cards.
*   **Nesting:** An inner container must always be a different tier than its parent (e.g., a `surface-container-lowest` card sitting on a `surface-container-low` section).

### The "Glass & Gradient" Rule
For floating navigation or immersive headers, use **Glassmorphism**. Apply `surface` with 80% opacity and a `20px` backdrop-blur. 
*   **Signature Textures:** For primary CTAs, use a subtle linear gradient from `primary` (#570013) to `primary-container` (#800020) at a 135-degree angle. This adds "soul" and prevents the deep burgundy from appearing flat.

---

## 3. Typography: The Ge'ez Priority
Typography is the heart of this system. The Ge'ez script requires more vertical breathing room than Latin scripts due to its character complexity.

*   **Display & Headlines (Noto Serif Ethiopic):** Used for book titles and chapter headers. The serif qualities evoke the hand-inked tradition of Ethiopian scribes. Use `headline-lg` (2rem) for major entry points.
*   **Body (Inter / Noto Sans Ethiopic):** High-legibility sans-serif for the biblical text. The "Modern Premium" feel is achieved through increased line-height (use 1.6x the font size) to ensure the Ge’ez characters don’t feel cramped.
*   **Editorial Hierarchy:** Contrast large `display-md` (2.75rem) numerals for chapter numbers against `body-lg` text to create a high-fashion, editorial layout.

---

## 4. Elevation & Depth
We eschew traditional "Material" shadows for a more organic, ambient light model.

*   **Tonal Layering:** 90% of elevation should be achieved through the surface-container tiers. Placing `surface-container-lowest` (#ffffff) on `surface-dim` (#dcd9d9) creates a natural lift.
*   **Ambient Shadows:** When a float is required (e.g., a Reading Mode menu), use a shadow with `blur: 32px`, `y: 8px`, and `color: #584141` (on-surface-variant) at **6% opacity**. It should feel like a soft glow, not a dark drop shadow.
*   **The "Ghost Border" Fallback:** If a border is necessary for accessibility (e.g., input fields), use `outline-variant` (#e0bfbf) at **15% opacity**. Never use a 100% opaque border.

---

## 5. Components

### Reading Cards & Verse Lists
*   **Forbid Dividers:** Do not use horizontal lines between verses. Use `spacing-4` (1.4rem) to separate blocks of text.
*   **Active State:** Use a `surface-container-high` background with a `primary` left-accent bar (4px width) to indicate a selected verse.

### Primary Action Buttons
*   **Style:** Pill-shaped (`rounded-full`). 
*   **Color:** Gradient of `primary` to `primary-container`.
*   **Typography:** `label-md` in all-caps (for Latin) or medium weight (for Ge'ez), tracked out slightly for a premium feel.

### Chips (Category/Tag)
*   **Style:** `surface-container-lowest` with a `15% outline-variant` ghost border.
*   **Interaction:** On selection, transition to `secondary-container` (#fed488) with `on-secondary-container` (#785a1a) text.

### Refined Iconography
*   **Style:** Thin-stroke (1.5pt) "Light" weight icons. 
*   **Color:** Use `on-surface-variant` for inactive states and `secondary` (gold) for active states. Avoid filled icons unless indicating a "saved" or "bookmarked" status.

### Custom Component: The "Scripture Scrubber"
A horizontal scroll component for jumping between chapters. Use `display-sm` for the active chapter number and `surface-dim` with 50% opacity for adjacent numbers, creating a focal-point effect.

---

## 6. Do's and Don'ts

### Do:
*   **Do** use asymmetrical margins. A wider left margin (e.g., `spacing-8`) and a tighter right margin can make a verse layout feel like a modern magazine.
*   **Do** prioritize the Ge'ez script's vertical rhythm; always err on the side of more line-height.
*   **Do** use `secondary` (gold) sparingly for "moments of delight" like bookmark icons or verse highlights.

### Don't:
*   **Don't** use pure black (#000000). Use `tertiary` (#272727) or `on-background` (#1c1b1b) to maintain the "Modern Premium" softness.
*   **Don't** use standard 1px dividers. If a separation is needed, use a `1.5rem` vertical gap or a subtle background shift.
*   **Don't** crowd the interface. If a screen feels busy, increase the spacing scale by one increment (e.g., move from `spacing-4` to `spacing-5`).

---

## 7. Spacing & Rhythm
Use the **1.4 Scale**. 
*   **Base Unit:** `3` (1rem).
*   **Gutters:** Use `6` (2rem) for mobile page margins to create a high-end, "un-crowded" feel.
*   **Paragraph Spacing:** Use `4` (1.4rem) to ensure the Ge'ez script characters don't overlap vertically.