# ORBIT

**A personal, premium social reading client for iPhone.**

ORBIT brings community feeds, thoughtful reading tools, and personal curation into one focused iOS experience. It takes inspiration from the best interaction patterns in classic social readers while maintaining its own identity, interface, and implementation.

> The internet, in your orbit.

## Current implementation

The first interactive SwiftUI prototype is now in the repository:

- Five-tab app navigation: Home, Discover, Saved, Inbox, Settings.
- Midnight visual foundation and reusable feed cards.
- Home, Popular, and All sample feed modes.
- Local feed search across post titles, communities, and excerpts.
- Comfortable and Compact feed density preferences.
- Post detail preview screen.
- Persistent local bookmarks and a Saved screen.
- Community discovery search, community detail pages, and local follow/unfollow.
- Stable sample post identifiers so saved items survive app relaunches.
- XcodeGen project configuration and GitHub Actions build/test workflow.

**Important:** sample posts and communities are fictional development fixtures. The prototype does not yet connect to a live social account or platform API. The Inbox is intentionally a placeholder until message API capabilities are verified.

## Product principles

- **Reader first:** fast scanning, comfortable reading, excellent typography, and low-friction navigation.
- **Personal control:** configurable feeds, sorting, filters, saved items, and appearance.
- **Native feel:** SwiftUI, platform conventions, accessibility, haptics, and system integrations.
- **Trustworthy integration:** use only authorized platform APIs and respect platform terms, rate limits, privacy, and attribution requirements.
- **No app-inserted advertising:** ORBIT will not add its own advertising. Platform-provided sponsored content and API restrictions must be handled according to the platform's rules.
- **Quality over shortcuts:** modular architecture, tests, documentation, and explicit release gates.

## Project documentation

- [Product specification](docs/PRODUCT_SPEC.md)
- [Roadmap](docs/ROADMAP.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Platform integration and compliance](docs/PLATFORM_INTEGRATION.md)
- [Build instructions](docs/BUILDING.md)

## Technology

- iOS 17+, Swift 5.9, SwiftUI
- Feature-oriented SwiftUI views and small observable stores
- URLSession and structured concurrency for future authorized API integration
- UserDefaults for prototype preferences and local fixture bookmarks
- XCTest
- XcodeGen and GitHub Actions on macOS runners

## Important integration gate

Live account features depend on current developer/API access requirements and approval. ORBIT must not ship unofficial scraping, credential harvesting, or API-policy circumvention. If an API capability is unavailable or restricted, the feature will be clearly marked unavailable rather than simulated as working.

## Build and distribution

The Xcode project is generated from `project.yml`. See [Build instructions](docs/BUILDING.md).

GitHub Actions builds and tests the iOS Simulator target. FlareStore is the planned signing/sideloading route for physical-device testing. A simulator build is not an installable device IPA; signing and installation must be verified separately on a device.

## Project identity

- Product: ORBIT
- Repository: https://github.com/72cbbw422f-alt/orb
- Bundle identifier: `app.orbit.reader`
- Minimum iOS version: 17.0
