# Minimal Focus Launcher (SwiftUI)

An original iOS SwiftUI app concept focused on intentional, low-distraction app launching.

## Features
- Text-based home screen of user-selected app shortcuts.
- Add/remove apps from a saved list.
- 25-minute focus timer.
- Optional grayscale display mode.
- Screen Time display placeholder that uses Apple APIs when available/authorized.
- Local persistence with `UserDefaults`.
- StoreKit 2 in-app purchase to unlock premium themes.

## Notes
- This implementation is intentionally minimal and original, with no copied branding or assets from third-party apps.
- Deep-link launching for third-party apps depends on URL schemes and user-installed apps.
- Screen Time metrics require entitlement/authorization and may be unavailable in some contexts.
