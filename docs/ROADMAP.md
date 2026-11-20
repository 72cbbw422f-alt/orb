# ORBIT — Roadmap

This roadmap tracks delivery, not aspirations. A feature is complete only after implementation, tests, failure handling, and API/platform verification where relevant.

## M0 — Project foundation
- [x] Product name, repository, scope and principles.
- [x] SwiftUI app shell and XcodeGen configuration.
- [x] GitHub Actions build/test and unsigned IPA packaging workflow.
- [x] Baseline model tests.
- [x] Confirm a clean CI build and test run.
- [ ] Confirm FlareStore signing and installation on a physical device.

## M1 — Design system and navigation
- [x] Midnight design tokens and reusable components.
- [x] Five-tab navigation.
- [x] Compact, Classic and Comfortable feed density.
- [ ] Pearl, OLED black and theme manager.
- [ ] Reorderable tabs and configurable navigation.
- [ ] Accessibility, Dynamic Type, VoiceOver and reduced-motion review (in progress: feed search hints, selected filter announcements, and post action states added; full audit and device verification remain).

## M2 — Feed and discovery
- [x] Feed models and stable preview fixtures.
- [x] Feed repository protocol and injectable preview implementation.
- [x] Home, Popular and All prototype feeds.
- [x] Local feed search.
- [x] Community discovery and local follow state.
- [x] Local prototype sorting: recommended, most discussed and title A–Z.
- [x] Local post-type filters for text, images, links and video.
- [x] Repository-backed feed presentation, explicit load states, refresh, retry, cancellation recovery and deduplication (verified by CI run #72 on the current feature branch head).
- [ ] Full supported feed sorts and time ranges.
- [ ] Multireddits, favorites and reorderable community list.
- [ ] Live search for posts, communities, users and comments.
- [ ] Pagination, scroll restoration and network-state UX.
- [ ] Jump Bar, jump-to-top and return-to-reading-position.
- [ ] Gallery/grid feed layout and rich link cards.

## M3 — API, authentication and accounts
- [ ] Verify current Reddit API registration, approval and policy requirements.
- [ ] Register supported OAuth application and implement OAuth flow.
- [ ] Keychain token storage, refresh and revoke/disconnect.
- [ ] Rate-limit-aware API client, pagination, retries and cancellation.
- [ ] Multiple accounts and account switcher.
- [ ] Account-specific state, preferences and drafts.
**Gate:** no scraping, credential workarounds or API policy evasion. Live integration waits for legitimate access.

## M4 — Posts and comments
- [x] Post detail prototype.
- [x] Fixture-backed threaded comments, collapse/expand, local vote and reply.
- [ ] Real post types: text, image, gallery, video, link and polls where supported.
- [ ] Server-backed vote, save, hide, report, share and submit actions where supported.
- [ ] Markdown rendering and safe rich links.
- [ ] Comment sorting, find-in-comments and new-comment highlighting.
- [ ] Draft persistence and full composer.
- [ ] Avatars, flair, awards and moderator metadata where available.
- [ ] Live comment updates only if API support permits.

## M5 — Media
- [ ] Full-screen viewer, zoom, swipe and gallery navigation.
- [ ] Save/share/copy media and save-all gallery action.
- [ ] Video playback, scrubbing and GIF autoplay controls.
- [ ] Picture in Picture where supported.
- [ ] Inline media previews and external provider fallbacks.
- [ ] Media cache, data saver and cache controls.
- [ ] Performance tests for video-heavy feeds.

## M6 — Personal library
- [x] Local persistent bookmarks and Saved view.
- [x] Local persistent reading history.
- [ ] Saved categories/folders.
- [ ] Reading queue / read later.
- [ ] Hidden posts and communities.
- [ ] Offline reading and cache retention controls.
- [ ] Export/import and automatic backups.
- [ ] History retention and privacy controls.

## M7 — Profiles, communities and power tools
- [x] Community discovery and detail prototype.
- [ ] Full profile pages and profile navigation.
- [ ] Community rules, moderators, related communities and flair search.
- [ ] Advanced keyword, domain, author, community and flair filters.
- [ ] Configurable post action menus.
- [ ] Custom swipe gestures and haptics.
- [ ] Translation in place.
- [ ] Optional AI summaries with explicit privacy/provider controls.

## M8 — Inbox, chat and notifications
- [ ] Verify current inbox, modern chat and mod-mail API capabilities.
- [ ] Inbox filters, read/unread state and notification center.
- [ ] Chat and message drafts only where officially supported.
- [ ] Evaluate push architecture and APNs requirements.
- [ ] User-controlled notification preferences.
**Gate:** do not expose nonfunctional chat or promise client-only push delivery.

## M9 — Widgets and iOS integration
- [ ] Home Screen widgets.
- [ ] Lock Screen widgets where supported.
- [ ] Share extension and Shortcuts integration.
- [ ] Deep links and share-link handling.
- [ ] App icon packs and theme backup.
**Gate:** app extensions require separate targets and must be verified with the chosen signing/distribution method.

## M10 — Stabilization and release
- [ ] Unit, integration and UI tests pass.
- [ ] API compliance and privacy review.
- [ ] Crash, offline, rate-limit and media failure review.
- [ ] Performance, memory and battery profiling.
- [ ] Accessibility and localization review.
- [x] CI produces a verified unsigned IPA artifact.
- [ ] FlareStore signing and device installation verified.
- [ ] Release notes, privacy disclosure and known limitations.

## Status vocabulary
- **Planned:** scoped, not implemented.
- **In progress:** implementation underway.
- **Blocked:** requires approval, credentials, backend or platform capability.
- **Complete:** implemented, tested and meets exit criteria.

See [APOLLO_FEATURE_AUDIT.md](APOLLO_FEATURE_AUDIT.md) for the full feature catalogue and priority rationale.
