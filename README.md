# Spotlight Tour

[![pub package](https://img.shields.io/pub/v/spotlight_tour.svg)](https://pub.dev/packages/spotlight_tour)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Professional Flutter onboarding with real interactive step validation.**

Users must perform required actions before advancing — not just click Next. V2 adds analytics, JSON tours, Lottie animations, multi-target spotlights, and a full event stream.

## Demo

<p align="center">
  <img src="doc/video/spotlight_tour_demo.gif" alt="Spotlight Tour demo — tap, long-press, validator, and double-tap steps" width="320"/>
</p>

<p align="center">
  <sub>Interactive tour: tap → long-press → custom validator → double-tap → complete</sub>
</p>

<p align="center">
  <img src="doc/screenshots/comparison_traditional_vs_spotlight.png" alt="Traditional Showcase vs Spotlight Tour" width="700"/>
</p>

---

## Screenshots

> Full demo video: [`doc/video/spotlight_tour_demo.mp4`](doc/video/spotlight_tour_demo.mp4)

<table>
  <tr>
    <td align="center">
      <img src="doc/screenshots/spotlight_search_step.png" alt="Tap validation" width="260"/><br/>
      <b>Tap validation</b>
    </td>
    <td align="center">
      <img src="doc/screenshots/spotlight_profile_step.png" alt="Long-press validation" width="260"/><br/>
      <b>Long-press validation</b>
    </td>
    <td align="center">
      <img src="doc/screenshots/spotlight_cart_step.png" alt="Custom validator" width="260"/><br/>
      <b>Custom validator</b>
    </td>
  </tr>
</table>

---

## Feature Comparison

| Feature | V1 | V2 |
|---|---|---|
| Interactive validation | ✅ | ✅ |
| Spotlight effects | ✅ | ✅ |
| Smart tooltips | ✅ | ✅ |
| Analytics callbacks | — | ✅ |
| Global event stream | — | ✅ |
| JSON-driven tours | — | ✅ |
| Lottie animations | — | ✅ |
| Tooltip animations | — | ✅ |
| Step indicators (dots/text/linear) | — | ✅ |
| Multi-target spotlight | — | ✅ |
| Pause / Resume | — | ✅ |
| Accessibility | — | ✅ |

---

## Installation

```yaml
dependencies:
  spotlight_tour: ^2.0.0
```

```bash
flutter pub get
```

---

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

final GlobalKey searchKey = GlobalKey();

SpotlightTour.start(
  context,
  steps: [
    TourStep(
      targetKey: searchKey,
      title: 'Search Products',
      description: 'Tap here to find products.',
      requiredAction: RequiredAction.tap,
    ),
  ],
);
```

---

## Analytics (V2)

```dart
SpotlightTour.start(
  context,
  steps: steps,
  onTourStarted: () => analytics.log('tour_started'),
  onTourCompleted: () => analytics.log('tour_completed'),
  onTourSkipped: () => analytics.log('tour_skipped'),
  onStepChanged: (index) => analytics.log('step_$index'),
);
```

Callbacks fire **exactly once** per tour lifecycle.

---

## Global Events (V2)

```dart
SpotlightTour.events.listen((event) {
  switch (event.type) {
    case TourEventType.tourStarted:
      break;
    case TourEventType.validationPassed:
      break;
    case TourEventType.stepChanged:
      print('Step ${event.stepIndex}');
      break;
    default:
      break;
  }
});
```

---

## JSON Tours (V2)

`assets/onboarding.json`:

```json
{
  "steps": [
    {
      "id": "search",
      "title": "Search Products",
      "description": "Tap search button",
      "requiredAction": "tap",
      "tooltipPosition": "bottom",
      "shape": "roundedRectangle",
      "animationType": "bounce"
    }
  ]
}
```

```dart
final steps = await TourJsonLoader.loadAsset(
  'assets/onboarding.json',
  keyRegistry: {'search': searchKey},
  validatorRegistry: {
    'cart_ready': () async => cartCount > 0,
  },
);

SpotlightTour.start(context, steps: steps);
```

---

## Lottie (V2)

```dart
TourStep(
  targetKey: searchKey,
  title: 'Search',
  description: 'Tap the search button.',
  lottieAsset: 'assets/lottie/search.json',
  requiredAction: RequiredAction.tap,
)
```

---

## Multi-Target Spotlight (V2)

```dart
TourStep(
  targetKey: searchKey,
  targetKeys: [searchKey, filterKey, sortKey],
  title: 'Toolbar',
  description: 'Use these controls to find products.',
)
```

---

## Tooltip Animations (V2)

```dart
SpotlightTour.start(
  context,
  steps: steps,
  animationType: TooltipAnimationType.bounce,
);

TourStep(
  targetKey: myKey,
  animationType: TooltipAnimationType.slide,
  title: 'Hello',
);
```

---

## Step Indicators (V2)

```dart
SpotlightTour.start(
  context,
  steps: steps,
  indicatorType: StepIndicatorType.dots,
);
```

Options: `StepIndicatorType.text` · `dots` · `linear`

---

## Programmatic Control (V2)

```dart
final controller = SpotlightTour.controller;

controller?.next();
controller?.previous();
controller?.skip();
controller?.finish();
controller?.pause();
controller?.resume();
```

---

## Migration Guide (V1 → V2)

V2 is **fully backward compatible**. No code changes required.

| V1 API | V2 Status |
|---|---|
| `SpotlightTour.start()` | Unchanged |
| `TourStep(targetKey: ...)` | Unchanged |
| `onComplete` / `onSkip` | Still works |
| `RequiredAction` | Unchanged |

New features are opt-in via additional optional parameters.

---

## Roadmap

| Version | Features |
|---|---|
| **V2** ✅ | Analytics, JSON, Lottie, events, multi-target |
| **V3** | Remote config, A/B testing, dashboard |

---

## FAQ

**Does V2 break my existing code?**  
No. All V1 APIs work exactly as before.

**Can I mix JSON and code-defined steps?**  
Load JSON into `List<TourStep>`, then pass to `SpotlightTour.start()`.

**Does Lottie work on Web?**  
Yes. Add assets to `pubspec.yaml` in your app.

---

## License

MIT © [Umar Anayat](https://github.com/UmarAnayat) — see [LICENSE](LICENSE).
