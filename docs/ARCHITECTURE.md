# ORBIT — Technical Architecture

## Platform
- iOS, Swift, SwiftUI.
- Swift concurrency.
- URLSession.
- SwiftData for appropriate local persistence.
- Keychain for secrets and tokens.
- XCTest / Swift Testing.

The deployment target and package choices will be finalized after the first CI build and API compatibility review.

## Architectural approach
Feature-oriented MVVM with clear boundaries:
- **Presentation:** SwiftUI views, view models, reusable design components.
- **Domain:** entities, value types, use cases, repository protocols.
- **Data:** API clients, DTOs, persistence, cache, repository implementations.
- **Platform:** Keychain, notifications, media playback, share sheet, background tasks.

Views do not make network requests directly. View models coordinate use cases and expose observable state. Domain logic remains testable without SwiftUI.

## Suggested source layout
```
ORBIT/
├── App/
│   ├── ORBITApp.swift
│   ├── AppContainer.swift
│   └── AppConfiguration.swift
├── Core/
│   ├── DesignSystem/
│   ├── Networking/
│   ├── Persistence/
│   ├── Security/
│   ├── Utilities/
│   └── Components/
├── Features/
│   ├── Feed/
│   ├── Discover/
│   ├── Community/
│   ├── PostDetail/
│   ├── MediaViewer/
│   ├── Saved/
│   ├── Inbox/
│   ├── Notifications/
│   └── Settings/
├── Domain/
│   ├── Models/
│   ├── Repositories/
│   └── UseCases/
├── Resources/
└── Tests/
    ├── UnitTests/
    └── UITests/
```

## API boundary
Isolate integration behind protocols such as AuthenticationProviding, FeedRepository, CommunityRepository, PostRepository, SearchRepository, and InboxRepository. API DTOs must not leak into SwiftUI views or domain models. Use documented and approved endpoints only.

## Authentication and secrets
- Use the supported OAuth flow, with PKCE where required.
- Use a system browser authorization session, not an embedded credential form.
- Store credentials in Keychain.
- Apply least-privilege scopes.
- Support expiry and revocation.
- Redact authorization headers and credentials from logs.
- Never commit secrets, certificates, or provisioning profiles.

## Networking and resilience
- Typed request/response models.
- Centralized authorization, API versioning, and error mapping.
- Respect rate-limit and retry-after headers.
- Bounded exponential backoff for safe transient failures only.
- Do not blindly retry non-idempotent writes.
- Support cancellation and stale-request protection.
- Distinguish offline, unauthorized, rate-limited, unavailable, and decoding errors.

## Persistence and caching
Use SwiftData for preferences, reading queue, history, and suitable local records. Cache only in ways allowed by upstream terms and response headers. Separate user-owned data from remote cache. Provide clear-cache and history controls.

## State management
Represent screen states explicitly: idle, loading, loaded, empty, refreshing, and failed. Optimistic updates require a defined rollback. Server-confirmed state is authoritative.

## Testing
- Unit tests for models, decoding, pagination, sorting, and view-model transitions.
- Repository tests with deterministic mocked transport.
- Persistence tests with isolated stores.
- UI tests for launch, navigation, feed states, and critical interactions.
- Contract fixtures; ordinary CI must not depend on live API calls.

## CI and distribution
GitHub Actions macOS runners can compile and test the iOS project. A successful simulator build or archive is not a signed, installable IPA. Device installation requires valid signing, provisioning, and distribution configuration. CI must not report a signed release if signing was skipped.


## Feed query boundary
Feed scope selection, local search, post-type filtering, and deterministic sorting are implemented as the pure `FeedQuery` value in `Core/Models/FeedQuery.swift`. SwiftUI owns only the current selection state; it passes that state to the query and renders the returned posts. This keeps fixture-backed behavior testable without introducing network dependencies. When live repositories arrive, this query can remain the local presentation/query layer while server-side sorting and filtering are selected only for supported API capabilities.


## HTTP transport boundary
`Core/Networking/HTTPClient.swift` provides an injectable URLSession-backed JSON transport. It accepts a prepared URLRequest and decodes a typed Decodable response. `HTTPClientError` distinguishes transport failures, invalid responses, non-2xx HTTP statuses (including rate-limit responses such as 429), and decoding failures. The transport does not own credentials, Reddit-specific endpoints, retry policy, or OAuth; those responsibilities remain in dedicated API/authentication layers.


## Feed repository boundary
`Core/Repositories/FeedRepository.swift` defines the asynchronous `FeedRepository` contract. The contract returns domain-level `FeedPost` values and does not expose URLSession, HTTP response types, or API DTOs. `Features/Feed/PreviewFeedRepository.swift` is the current fixture-backed implementation and supports dependency injection for deterministic tests. The feed screen is intentionally not wired to this repository in this architecture change; that presentation integration belongs to the feed feature workstream. A future authorized Reddit-backed implementation can satisfy the same contract after API access and endpoint behavior are verified.
