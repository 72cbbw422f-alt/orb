# ORBIT — Roadmap

This is a delivery plan, not a claim that listed features are already implemented. A milestone is complete only after its exit criteria are met.

## M0 — Project foundation
- [x] Confirm product name and repository.
- [x] Establish product principles and initial scope.
- [x] Document architecture and integration risks.
- [ ] Add initial SwiftUI app shell.
- [ ] Add CI workflow and baseline tests.
**Exit:** documented repository structure and app shell builds in CI.

## M1 — Design system and navigation
- [ ] Define color, typography, spacing, radius, and icon tokens.
- [ ] Build reusable cards, rows, buttons, and loading states.
- [ ] Implement navigation structure.
- [ ] Implement Midnight and Pearl themes.
- [ ] Add accessibility and Dynamic Type baseline.
**Exit:** navigable prototype with consistent visual language.

## M2 — Feed experience
- [ ] Feed models and deterministic fixtures.
- [ ] Home feed layouts: Comfortable, Compact, Classic.
- [ ] Sorting and feed selection UI.
- [ ] Pagination, refresh, skeleton, empty, and error states.
- [ ] Post action menu and share sheet.
**Exit:** complete fixture-backed feed prototype with tests.

## M3 — Authorization and API foundation
- [ ] Verify current developer registration and API approval requirements.
- [ ] Register OAuth application only after requirements are understood.
- [ ] Implement secure supported OAuth flow.
- [ ] Store credentials in Keychain.
- [ ] Add API client, rate-limit handling, decoding, and fixtures.
**Exit:** approved credentials successfully make read-only requests. Blocked until legitimate API access exists.

## M4 — Post detail and comments
- [ ] Post detail.
- [ ] Threaded comments and collapse behavior.
- [ ] Markdown and safe link rendering.
- [ ] Comment sorting where supported.
- [ ] Reply composition and draft persistence.
**Exit:** reliable discussion reading and supported reply workflow.

## M5 — Actions and discovery
- [ ] Vote and save actions.
- [ ] Community pages and follow actions.
- [ ] Search posts and communities.
- [ ] Search history and filters.
**Exit:** supported interactions work with server-confirmed state.

## M6 — Media and reading tools
- [ ] Image viewer and zoom.
- [ ] Gallery navigation.
- [ ] Video and animated media handling.
- [ ] Reading queue and history.
- [ ] Offline/cache controls.
**Exit:** media and personal library handle common failure cases.

## M7 — Inbox and notifications
- [ ] Verify supported inbox/message API capabilities.
- [ ] Build in-app notification center for supported events.
- [ ] Evaluate approved push architecture.
- [ ] Add APNs/backend only if permitted and justified.
- [ ] Evaluate chat separately; do not assume API parity with inbox.
**Exit:** only verified and approved capabilities are exposed.

## M8 — Personalization and polish
- [ ] Theme and reading preferences.
- [ ] Gestures and haptics.
- [ ] Feed filters and content controls.
- [ ] Performance and memory profiling.
- [ ] Accessibility and reduced-motion review.
**Exit:** release-quality UX baseline.

## M9 — Stabilization and release
- [ ] Unit, integration, and UI tests pass.
- [ ] API compliance and privacy review.
- [ ] Crash and network failure review.
- [ ] GitHub Actions build validation.
- [ ] Signing and device distribution plan.
- [ ] Release notes and known limitations.
**Exit:** reproducible build, tested core flows, and valid signing/distribution path.

## Status vocabulary
- **Planned:** in scope, not started.
- **In progress:** implementation underway.
- **Blocked:** requires approval, credentials, signing, or another dependency.
- **Complete:** implemented, tested, and meets exit criteria.
