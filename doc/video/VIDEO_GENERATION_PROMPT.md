# Spotlight Tour — Video Generation Prompt

Copy everything inside the block below into your AI video tool (Runway, Pika, Kling, etc.) or use as a screen-recording storyboard.

---

```
Create a realistic vertical mobile screen recording demo video (9:16, 1080x1920, 30fps, 45-60 seconds total) of a Flutter app called "Spotlight Tour Demo" — a professional onboarding package showcase. The video must look 100% like a real iPhone/Android screen recording, NOT a marketing mockup. Include subtle finger tap ripples, natural UI transitions, and authentic Material 3 micro-animations.

=== APP DESIGN (consistent across all scenes) ===
- Platform: Flutter Material 3
- Primary color: Indigo (#3F51B5 / Colors.indigo)
- App bar: white/light surface, title "Spotlight Tour Demo" centered-left
- App bar icons (right side): Search magnifying glass, Person/profile outline, Shopping cart outline
- Home body: waving hand emoji icon (indigo), headline "Interactive Onboarding", subtitle "Unlike traditional showcase packages, Spotlight Tour requires real user interaction before advancing."
- Blue filled button: "Start Tour" with play icon
- Outlined button below: "Add to Cart (for step 3)" with cart icon
- Floating Action Button: circular indigo "+" button bottom-right
- Status bar: realistic iOS-style (time, battery, signal)
- NO debug banner, NO watermarks

=== SPOTLIGHT TOUR OVERLAY STYLE (when tour is active) ===
- Full screen dark dimmed overlay (75% black opacity) on everything EXCEPT the highlighted target
- Highlighted target has a premium spotlight cutout with pulsing indigo/blue glowing border (3-4px stroke, soft outer glow)
- White rounded tooltip card (16px radius, subtle drop shadow) with title (bold) + description (gray)
- Small arrow pointing from tooltip to highlighted element
- Bottom navigation panel (white frosted card): progress section + Back | Skip | Next buttons
- Next button DISABLED = grayed out/faded when validation not met
- Next button ENABLED = indigo filled when user can proceed
- Last step shows "Done" instead of "Next"
- Linear progress bar with "Step X of 4" and "Progress: XX%"

=== SCENE-BY-SCENE (follow exactly in order) ===

SCENE 1 — HOME (0:00 - 0:04)
Show clean home screen. No overlay. Camera static. After 2 seconds, realistic finger taps the blue "Start Tour" button. Brief Material ripple on button. Tour overlay begins fading in.

SCENE 2 — STEP 1: TAP VALIDATION (0:04 - 0:12)
Spotlight highlights SEARCH icon in app bar with ROUNDED RECTANGLE cutout, pulsing blue glow.
Tooltip below search icon:
  Title: "Search Products"
  Description: "Tap the search button to find products."
Bottom panel: "Step 1 of 4", progress bar 25%, Back disabled, Skip visible, Next button DISABLED (gray).
Show realistic finger TAP on search icon. Icon gets a small badge dot. Green snackbar slides up: "Search opened — step validated!"
Tour AUTO-ADVANCES to step 2 (smooth crossfade, no Next tap needed).

SCENE 3 — STEP 2: LONG-PRESS VALIDATION (0:12 - 0:22)
Spotlight highlights PROFILE/PERSON icon with CIRCULAR cutout, pulsing glow.
Tooltip auto-positioned to the side:
  Title: "Your Profile"
  Description: "Long-press the profile icon to open settings."
Bottom panel: "Step 2 of 4", progress 50%, Next DISABLED.
Show finger pressing and HOLDING on profile icon for ~1 second (long-press). Profile icon gets badge. Tour auto-advances to step 3.

SCENE 4 — STEP 3: CUSTOM VALIDATOR (0:22 - 0:34)
Spotlight highlights SHOPPING CART icon with rounded rectangle cutout.
Tooltip ABOVE cart icon:
  Title: "Shopping Cart"
  Description: "Add an item to your cart, then tap Next."
Bottom panel: "Step 3 of 4", progress 75%, Next DISABLED.
Finger scrolls slightly, taps "Add to Cart (for step 3)" button on home screen. Cart badge updates to "1".
Next button becomes ENABLED (turns indigo). Finger taps Next. Advances to step 4.

SCENE 5 — STEP 4: DOUBLE-TAP VALIDATION (0:34 - 0:44)
Spotlight highlights FLOATING ACTION BUTTON (+) bottom-right with CIRCULAR cutout, strong glow (4px border).
Tooltip on LEFT of FAB:
  Title: "Quick Add"
  Description: "Double-tap the + button to add items quickly."
Bottom panel: "Step 4 of 4", progress 100%, button says "Done" DISABLED.
Show finger DOUBLE-TAPPING the FAB quickly. Cart badge jumps to 3. Tour auto-completes.

SCENE 6 — TOUR COMPLETED (0:44 - 0:50)
Overlay fades away completely. Clean app visible. Cart shows badge "3". Search and profile badges visible.
Green snackbar at bottom: "Tour completed!"
Hold 2 seconds. Subtle zoom out or fade to black.

=== OPTIONAL TEXT OVERLAYS (subtle, bottom third, semi-transparent dark pill background) ===
- Scene 2: "Tap Validation — user must tap before advancing"
- Scene 3: "Long-Press Validation"
- Scene 4: "Custom Validator — Next enabled when condition met"
- Scene 5: "Double-Tap Validation"
- End card (2 sec): "spotlight_tour · pub.dev" in white text on dark gradient

=== TECHNICAL REQUIREMENTS ===
- Photorealistic mobile UI, NOT illustrated/cartoon
- Consistent indigo Material 3 design language throughout
- Smooth 60fps feel, no jarring cuts between steps
- Authentic touch interactions (finger visible optional but ripples required)
- Spotlight pulse animation must be subtle and premium
- Tooltip must never overflow screen edges
- Must feel like developer recorded this on a real phone testing their Flutter package

=== PACKAGE FEATURES BEING DEMONSTRATED ===
1. Interactive step validation (tap, long-press, double-tap)
2. Custom async validator (cart must have items)
3. Premium spotlight effects (dim, cutout, glow, pulse)
4. Smart auto-positioning tooltips (bottom, side, top, left)
5. Multiple spotlight shapes (rounded rect + circle)
6. Progress system (step counter + linear bar + percentage)
7. Navigation controls (Back, Skip, Next/Done)
8. Auto-advance on gesture validation
9. Material 3 theme
10. Real touch pass-through to underlying widgets

Output: MP4, 1080x1920, 30fps, H.264, under 60 seconds.
```

---

## Tips for best results

| Tool | Suggestion |
|---|---|
| **Runway / Kling / Pika** | Paste full prompt, generate 9:16 |
| **Screen recording (best)** | Run `cd example && flutter run` on iOS Simulator, record with QuickTime |
| **CapCut / Premiere** | Use prompt as scene storyboard, edit clips together |

## Real recording commands (recommended)

```bash
cd example
flutter run -d "iPhone 16 Pro"
# macOS: QuickTime → File → New Screen Recording → select Simulator
```
