# ORBIT — Roadmap

This is a delivery plan, not a claim that listed features are already implemented. A milestone is complete only after its exit criteria are met.

## M0 — Project foundation
- [x] Confirm product name and repository.
- [x] Establish product principles and initial scope.
- [x] Document architecture and integration risks.
- [x] Add initial SwiftUI app shell.
- [x] Add XcodeGen project configuration and CI workflow.
- [x] Add baseline model tests.
**Exit:** source project is generated in CI; final build/test result is still pending.

## M1 — Design system and navigation
- [x] Define Midnight color, spacing, radius, and surface tokens.
- [x] Build reusable feed cards and community rows.
- [x] Implement five-tab navigation.
- [ ] Implement Pearl theme.
- [ ] Add complete accessibility and Dynamic Type review.
**Exit:** navigable prototype with consistent visual language and accessibility review.

## M2 — Feed experience
- [x] Feed models and stable preview fixtures.
- [x] Home, Popular, and All feed selection.
- [x] Comfortable and Compact card density preferences.
- [x] Local feed search.
- [x] Post detail preview.
- [x] Local persistent bookmark action and Saved screen.
- [ ] Classic layout as a distinct presentation.
- [ ] Sorting controls beyond the initial feed presets.
- [ ] Pagination, refresh, skeleton, and network error states.
- [ ] Post action menu and share sheet.
**Exit:** complete fixture-backed feed prototype with tests and verified interactions.

## M3 — Authorization and API foundation
- [ ] Verify current developer registration and API approval requirements.
- [ ] Register OAuth application only after requirements are understood.
- [ ] Implement secure supported OAuth flow.
- [ ] Store credentials in Keychain.
- [ ] Add API client, rate-limit handling, decoding, and fixtures.
**Exit:** approved credentials successfully make read-only requests. Blocked until legitimate API access exists.

## M4 — Post detail and comments
- [x] Initial post detail screen.
- [x] Fixture-backed threaded comments with nested replies.
- [x] Collapse and expand comment threads.
- [x] Local preview voting and Top/Newest sorting.
- [x] Local root-comment and nested-reply composition.
- [ ] Markdown and safe link rendering.
- [ ] Draft persistence.
- [ ] Replace preview comments with approved API-backed comments.
**Exit:** reliable discussion reading and supported reply workflow.

## M5 — Actions and discovery
- [x] Local bookmark/save interaction.
- [x] Local preview upvote interaction.
- [x] Community discovery search prototype.
- [x] Community detail screen.
- [x] Local follow/unfollow state.
- [ ] Server-backed vote and save actions.
- [ ] Live community pages and follow actions.
- [ ] Live search posts and communities.
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
- [x] Initial reading preferences and haptics setting.
- [ ] Pearl theme and complete theme switching.
- [ ] Gestures and haptics implementation.
- [ ] Feed filters and content controls.
- [ ] Performance and memory profiling.
- [ ] Accessibility and reduced-motion review.
**Exit:** release-quality UX baseline.

## M9 — Stabilization and release
- [ ] Unit, integration, and UI tests pass.
- [ ] API compliance and privacy review.
- [ ] Crash and network failure review.
- [ ] GitHub Actions build validation.
- [ ] FlareStore signing and device distribution verification.
- [ ] Release notes and known limitations.
**Exit:** reproducible build, tested core flows, and valid signing/distribution path.

## Status vocabulary
- **Planned:** in scope, not started.
- **In progress:** implementation underway.
- **Blocked:** requires approval, credentials, or another dependency.
- **Complete:** implemented, tested, and meets exit criteria.
