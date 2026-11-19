# ORBIT — Apollo Reborn feature audit and product scope

## Purpose

Use Apollo and Apollo Reborn as a feature benchmark, not as source code or branding to copy. ORBIT remains an independent SwiftUI Reddit client with its own visual identity, interaction model, and implementation.

**Product target:** a full-featured, fast, customizable Reddit client for iPhone. Features that require Reddit approval, API access, push infrastructure, or platform entitlements remain explicitly gated until verified.

## 1. Feed and navigation

- [ ] Home, Popular, All, Latest, Rising, Top, Controversial, and other API-supported listings.
- [ ] Custom multireddits and combined community feeds.
- [ ] Favorites, pinned communities, reorderable community list.
- [ ] Feed sorting with time ranges where supported.
- [ ] Pull to refresh, infinite pagination, restore scroll position.
- [ ] Hide header on scroll; jump-to-top and return-to-reading-position.
- [ ] Search posts, communities, users, and comments with filters and search history.
- [ ] Jump Bar / fast community navigation.
- [ ] Floating post tabs / keep multiple discussions open.
- [ ] Recently viewed and reading history.
- [ ] Feed layouts: compact, classic, comfortable, gallery/grid.
- [ ] Adjustable thumbnails, text density, metadata, and preview behavior.
- [ ] Rich link cards and inline media previews.
- [ ] Community highlights / pinned post carousel when supported.
- [ ] Loading skeletons, empty states, offline states, retry and rate-limit feedback.

## 2. Posts and actions

- [ ] Text, image, gallery, video, GIF, link, poll, and supported interactive post types.
- [ ] Upvote, downvote, remove vote, save, hide, report, share, copy link.
- [ ] Post menu with configurable/reorderable actions.
- [ ] Crosspost and submit post where supported.
- [ ] Flair display and flair filtering.
- [ ] Spoiler and NSFW handling with user-controlled blur preferences.
- [ ] Keyword, domain, author, community, flair, and content filters.
- [ ] Block/mute controls only where the API exposes them.
- [ ] Rich previews for supported domains and safe external-link handling.
- [ ] Share sheet and iOS share extension if signing/distribution supports extensions.

## 3. Comments and discussion

- [ ] Deeply nested comment trees, collapse/expand branches.
- [ ] Sort: Best, Top, New, Controversial, Old, Q&A and supported alternatives.
- [ ] Live comment refresh / live updates where permitted.
- [ ] Find in comments.
- [ ] Highlight new comments since last visit.
- [ ] Auto-collapse pinned/moderator comments as an option.
- [ ] User avatars, flairs, moderator indicators and awards where available.
- [ ] Markdown rendering: headings, lists, quotes, code, tables, links and inline media.
- [ ] Composer with formatting toolbar, drafts, emoji and GIF/media attachment where supported.
- [ ] Reply, edit, delete, vote, report, copy and share actions where supported.
- [ ] Deleted/removed comment labels; recovery only if a legitimate supported source provides the content.
- [ ] Thread context and parent-comment navigation.

## 4. Media experience

- [ ] Full-screen image viewer with pinch zoom, double-tap zoom, pan and swipe navigation.
- [ ] Gallery carousel and gallery grid.
- [ ] Save/share/copy individual media and save all media in a gallery.
- [ ] Video playback, scrubbing, playback speed where technically supported.
- [ ] GIF playback and optional autoplay.
- [ ] Per-network autoplay controls and data-saving mode.
- [ ] Picture in Picture where iOS media support and source format allow it.
- [ ] Inline media in feeds, posts, comments and supported messages.
- [ ] Media caching with size limits and clear-cache controls.
- [ ] Robust handling for Reddit-hosted media, Imgur albums, and supported external hosts.
- [ ] Clear fallback for unsupported media providers; never silently show a broken player.

## 5. Accounts, profiles and communities

- [ ] OAuth sign-in and secure Keychain token storage, after API approval.
- [ ] Multiple accounts and a fast account switcher.
- [ ] Per-account feed, saved items, history, preferences and drafts.
- [ ] Profile pages: posts, comments, about, avatar, banner and available metadata.
- [ ] Community pages: description, rules, moderators, members, flair search and related communities.
- [ ] Follow/favorite/reorder communities.
- [ ] Mod tools only if approved API scopes and endpoints support them.
- [ ] Account-specific settings and account export.

## 6. Inbox, chat and notifications

- [ ] Inbox: replies, mentions, messages and mod mail where supported.
- [ ] Read/unread state, inbox filters, badges and notification center.
- [ ] Modern Direct Chat only after current API support is verified.
- [ ] Chat drafts per account and conversation if API supports it.
- [ ] Inline image/GIF attachments only where permitted.
- [ ] Push notifications require a compliant backend/APNs architecture and user consent.
- [ ] Fine-grained notification preferences by event/community/account.
- [ ] Never promise push delivery from a client-only app if a server component is required.

## 7. Personalization and accessibility

- [ ] Midnight dark theme, Pearl light theme, OLED pure-black theme.
- [ ] Theme manager with custom accent, surfaces, typography and shareable theme presets.
- [ ] App icon packs and optional wallpapers.
- [ ] Dynamic Type, VoiceOver labels, contrast and reduced-motion support.
- [ ] Adjustable text size, line spacing, profile-picture shape and avatar visibility.
- [ ] Configurable swipe gestures and haptics.
- [ ] Reorderable tab bar and configurable tab destinations.
- [ ] Settings search and settings shortcuts.
- [ ] Content controls: hide keywords, domains, communities, users and post types.
- [ ] Translation in place for post titles, text and comments using a provider selected by the user.
- [ ] AI summaries as an optional feature with explicit privacy disclosure and cost/provider controls.
- [ ] Localization-ready strings.

## 8. Personal library, backup and widgets

- [ ] Saved posts and saved categories/folders.
- [ ] Reading queue / read later.
- [ ] Reading history with clear and retention settings.
- [ ] Hidden posts and hidden communities, with restore controls.
- [ ] Offline reading cache for saved text and supported media.
- [ ] Export/import settings and app data in a documented format.
- [ ] Automatic local backups with retention controls; cloud sync only when a secure supported design exists.
- [ ] Home Screen widgets for feeds, multireddits, saved posts and account activity where API/background limits allow.
- [ ] Lock Screen widgets where iOS/widget APIs allow.
- [ ] Share extension and shortcuts only if distribution/signing setup supports app extensions.

## 9. Reliability, privacy and performance

- [ ] API client with rate-limit awareness, retry/backoff and cancellation.
- [ ] Image/video prefetching and memory-aware caches.
- [ ] Smooth scrolling in media-heavy feeds.
- [ ] Network diagnostics without collecting unnecessary personal data.
- [ ] Privacy-first analytics: off by default unless genuinely needed and disclosed.
- [ ] Clear local data, account disconnect and token revocation flows.
- [ ] Crash-safe persistence and migration tests.
- [ ] Unit, integration and UI tests for core journeys.
- [ ] Accessibility and performance test pass before release.

## 10. Explicit constraints and non-goals

- Do not scrape Reddit, impersonate official clients, bypass access controls, or evade API rate limits.
- Do not assume every Apollo feature maps to a supported Reddit API endpoint.
- Do not promise access to deleted content, modern chat, mod tools, live updates, or push unless verified.
- No app-inserted advertising. However, the app cannot guarantee removal of platform-required or server-delivered sponsored content.
- Keep API credentials and user tokens out of source control and logs.
- AI features must be optional, transparent about data processing, and disabled until a provider/privacy design is approved.
- App extensions and widgets are conditional on build/signing/distribution capabilities and iOS limits.

## Prioritization

**P0 — Foundation and usability:** feed navigation, API/auth approval, posts, comments, search, media viewer, saved library, history, robust settings, accessibility.

**P1 — Power-user experience:** gallery/grid, gestures, filters, multireddits, multiple accounts, saved categories, reading queue, translation, backup/restore, jump bar and floating post tabs.

**P2 — Platform expansion:** widgets, share extension, notifications, chat, AI summaries, live updates, mod tools and advanced media integrations.

A feature is not marked complete merely because a screen exists. It must work with real data where applicable, handle failure states, pass tests, and respect API/platform constraints.
