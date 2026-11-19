# ORBIT

**A personal, premium social reading client for iPhone.**

ORBIT brings community feeds, thoughtful reading tools, rich media, and personal curation into one focused iOS experience. It takes inspiration from the best interaction patterns in classic social readers while maintaining its own identity, interface, and implementation.

> The internet, in your orbit.

## Product principles

- **Reader first:** fast scanning, comfortable reading, excellent typography, and low-friction navigation.
- **Personal control:** configurable feeds, sorting, filters, saved items, and appearance.
- **Native feel:** SwiftUI, platform conventions, accessibility, haptics, and system integrations.
- **Trustworthy integration:** use only authorized platform APIs and respect platform terms, rate limits, privacy, and attribution requirements.
- **No app-inserted advertising:** ORBIT will not add its own advertising. Platform-provided sponsored content and API restrictions must be handled according to the platform's rules.
- **Quality over shortcuts:** modular architecture, tests, documentation, and explicit release gates.

## Current status

The repository foundation is being established. The first milestone documents product scope, technical architecture, and delivery constraints before feature implementation.

- [Product specification](docs/PRODUCT_SPEC.md)
- [Roadmap](docs/ROADMAP.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Platform integration and compliance](docs/PLATFORM_INTEGRATION.md)

## Planned technology

- iOS, Swift, SwiftUI
- Feature-oriented MVVM and dependency injection
- Authorized platform API integration through OAuth
- SwiftData for local persistence where appropriate
- URLSession, structured concurrency, and explicit caching
- XCTest / Swift Testing and UI tests
- GitHub Actions on macOS runners for build and test automation

## Important integration gate

Live account features depend on current developer/API access requirements and approval. ORBIT must not ship unofficial scraping, credential harvesting, or API-policy circumvention. If an API capability is unavailable or restricted, the feature will be clearly marked unavailable rather than simulated as working.

## Build and distribution

A successful GitHub Actions build is not the same as a signed, installable IPA. Device distribution requires an appropriate Apple signing and provisioning setup. CI build validation will be kept separate from signed release distribution.

## Project identity

- Product: ORBIT
- Repository: https://github.com/72cbbw422f-alt/orb
- Bundle identifier: to be finalized before the first device build
- Minimum iOS version: to be finalized after API and feature compatibility review
