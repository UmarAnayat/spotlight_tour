# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.0.0

### Added

* **Analytics callbacks:** `onTourStarted`, `onTourCompleted`, `onTourSkipped`, `onStepChanged`.
* **Global event stream:** `SpotlightTour.events` with `TourEventType` lifecycle events.
* **Lottie support:** `TourStep.lottieAsset` with looping animations in tooltips.
* **JSON-driven tours:** `TourJsonLoader.loadAsset()`, `loadString()`, `loadMap()`.
* **Tooltip animations:** `TooltipAnimationType` — fade, slide, scale, bounce.
* **Step indicators:** `StepIndicatorType` — text, dots, linear.
* **Multi-target spotlight:** `TourStep.targetKeys` for highlighting multiple widgets.
* **Programmatic control:** `pause()`, `resume()`, `previous()`, `finish()` on controller.
* **Accessibility:** Semantics labels, keyboard navigation (Enter, Tab, Escape).
* **Theme extensions:** button, progress, indicator, and animation style customization.

### Changed

* `SpotlightTour.start()` accepts `indicatorType` and `animationType`.
* `SpotlightPainter` and `SpotlightHitTest` support multiple spotlight cutouts.
* `TourAnalytics` ensures lifecycle callbacks fire exactly once.

### Notes

* All V1 APIs remain backward compatible.
* `onComplete` and `onSkip` continue to work alongside new analytics callbacks.

## 1.0.2

### Fixed

* Added missing `1.0.1` entry to `CHANGELOG.md` for pub.dev validation.
* Added dartdoc to `SpotlightTourController` constructor.

## 1.0.1

### Changed

* Updated `pubspec.yaml` homepage, repository, and issue tracker URLs.
* Improved README with screenshots and professional documentation layout.
* Updated LICENSE copyright holder.

### Added

* Package screenshots in `doc/screenshots/`.
* LinkedIn launch assets in `doc/linkedin/`.

## 1.0.0

### Added

* Initial release.
* Interactive step validation (tap, double-tap, long-press, custom validators).
* Premium spotlight effects with dimming, cutout, glow, and pulse animation.
* Smart tooltips with auto-positioning.
* Progress indicators and navigation controls (Next, Back, Skip).
* Material 3 and Cupertino theme support.
* Android, iOS, and Web support.
