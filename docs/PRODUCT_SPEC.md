# ORBIT — Product Specification

## Product vision
ORBIT is a premium, personal iPhone client for community-driven content. It combines a highly readable feed, deep discussion tools, media viewing, discovery, and personal organization in a cohesive native app. It is not a web wrapper or a visual clone of another client.

## Target experience
- Single primary user initially; iPhone-first.
- SwiftUI-native interaction and accessibility.
- Midnight dark appearance by default, plus a carefully designed light appearance.
- Three feed density modes: Comfortable, Compact, and Classic.
- Configurable navigation and feed behavior.

## Core navigation
1. Home
2. Discover
3. Saved
4. Inbox
5. Profile / Settings

## Feed
- Home, Popular, All, Latest, and followed-community feeds where supported.
- Custom feed collections where supported by the platform.
- API-supported sort options.
- Comfortable, Compact, and Classic layouts.
- Text, image, video, link, and gallery post cards.
- Community, author, timestamp, score, and comment metadata.
- Hide, save, share, vote, and open actions when authorized.
- Feed filters, pull-to-refresh, pagination, loading, empty, and error states.

## Post and discussion
- Dedicated post detail.
- Nested comments with collapse/expand.
- Comment sorting where supported.
- Safe Markdown rendering, links, and code blocks.
- Reply and vote actions when authorized.
- Server-confirmed state, with defined rollback for optimistic updates.
- Draft composition with recovery.

## Discovery and communities
- Search posts and communities through supported endpoints.
- Community overview, rules, description, and available sorting.
- Follow/unfollow where supported.
- Recent searches and suggestions stored locally.

## Media
- Full-screen image viewer with zoom.
- Gallery navigation.
- Native video playback when media sources permit.
- Animated media where technically and legally supported.
- Controlled external-link handling.
- Graceful handling of deleted, unavailable, or restricted media.

## Personal library
- Saved posts and reading queue.
- Recently viewed history with clear/disable controls.
- Optional local notes and tags in a later phase.
- Offline access only for content that may lawfully and technically be cached.
- User-controlled cache limits.

## Inbox, notifications, messaging
These are distinct capabilities:
- Classic inbox/messages/replies/mentions only where authorized API support exists.
- Chat only if a documented, approved API is available.
- In-app notification center for supported events.
- Push requires a permitted backend/event source, APNs configuration, and user consent.
- iOS background polling is not reliable and must not be promised.
- Modmail/moderation features are later scope and permission-dependent.

## Personalization
- Midnight: deep navy/near-black with restrained lime accent.
- Pearl: light theme.
- Classic: high-density theme.
- Dynamic Type, adjustable reading size, haptics, gestures.
- Reduced motion and VoiceOver support.

## Advertising
ORBIT will not insert its own ads. It will not promise to suppress platform-mandated sponsored content or bypass platform rules.

## Quality requirements
- No blocking network calls on the main actor.
- Explicit loading, empty, offline, and error states.
- Bounded retry with backoff for transient errors.
- Respect rate limits and caching headers.
- Secure token storage in Keychain.
- Never log tokens or private message bodies.
- Unit tests for decoding, pagination, persistence, and state transitions.
- UI tests for core navigation and critical flows.

## Out of scope initially
- Multi-account support.
- Moderation dashboard.
- Android/macOS clients.
- Unofficial scraping or unsupported private endpoints.
