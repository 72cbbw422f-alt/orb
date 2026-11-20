# ORBIT — Reddit Data API access and integration gate

**Status:** blocked pending Reddit authorization and app-registration decision  
**Reviewed:** 2026-11-20  
**Repository branch:** `feature/testable-feed-query`

## Decision

Do not send requests to Reddit's Data API, probe unauthenticated endpoints, scrape Reddit pages, or ship a live Reddit repository until ORBIT has the required Reddit approval and registered OAuth application credentials.

Reddit's current Responsible Builder Policy says explicit approval is required before accessing Reddit data through its API. Reddit's Data API Wiki also says API clients must use a registered OAuth token and a descriptive, truthful User-Agent. The current free-access guidance documents 100 queries per minute per OAuth client ID; this is a ceiling, not a target, and Reddit can apply other limits.

The existing `FeedRepository` boundary and `PreviewFeedRepository` remain the production-safe default. No live API behavior is claimed.

## Current Reddit policy checkpoints

- Request Data API access and obtain explicit approval before API data access.
- Review and comply with the Responsible Builder Policy, Developer Terms, and Data API Terms.
- Commercial use (including monetization, ads, subscriptions, or use on behalf of a business) requires Reddit's prior permission and may require a separate contract.
- Use OAuth 2.0 and the OAuth token supplied for the registered app. Do not disguise the OAuth identity or User-Agent.
- Send a descriptive User-Agent in Reddit's documented form: `<platform>:<app ID>:<version> (by /u/<reddit username>)`. It must be accurate and unique to ORBIT.
- Monitor `X-Ratelimit-Used`, `X-Ratelimit-Remaining`, and `X-Ratelimit-Reset`; treat 100 QPM per OAuth client ID as the published free-access guidance, subject to approval and changes.
- Remove stored Reddit content and author-identifying data when Reddit deletes the underlying content/account. Reddit recommends routinely deleting stored content within 48 hours.
- Re-check the live policy and terms before implementation and before release; legacy OAuth documentation may be outdated.

## Developer Platform registration transition

Reddit's app-registration page currently states:
- Existing Data API apps should be registered with the Reddit Developer Platform.
- Starting 2027-01-12, Reddit will begin removing API access for apps/users that have not registered or engaged with the Developer Platform team.
- Remaining public API access is scheduled to end in March 2027.
- The porting bounty mentioned by Reddit is for eligible existing apps registered by 2026-11-30; do not assume ORBIT qualifies, especially if it does not already have an API app.

This is a material platform dependency. Before investing in a legacy Data API implementation, confirm with Reddit whether ORBIT should use the Data API, migrate to Devvit, or follow another approved path. Devvit is intended for apps running on Reddit; it is not automatically a replacement for an external iOS client.

## Proposed implementation after approval

1. Record Reddit's written approval, app registration status, permitted use, and any usage limits in the project decision log. Do not commit credentials.
2. Confirm whether ORBIT is strictly non-commercial. If there is any commercial use or monetization, obtain the required permission/contract first.
3. Confirm the supported OAuth client type, redirect URI, authorization grant, PKCE requirements (if any), scopes, token lifetime, refresh behavior, and revocation endpoint against the current Reddit documentation and the approved app configuration. Do not assume a generic OAuth profile is sufficient.
4. Implement the system-browser authorization session for iOS; never collect a Reddit password in ORBIT.
5. Store user tokens in Keychain. Keep client configuration separate from secrets; never ship a confidential client secret in the iOS binary.
6. Implement typed Reddit DTOs and map them into domain `FeedPost` values inside a Reddit-backed `FeedRepository`.
7. Add authorization, rate-limit, retry-after, cancellation, pagination, deleted-content removal, and redacted logging behavior.
8. Keep `PreviewFeedRepository` for previews and deterministic tests. Unit tests must not depend on live Reddit.
9. Run CI, verify the approved endpoints and scopes, and only then enable the live repository in app configuration.

## Minimum scope principle

Do not request write permissions for a read-only feed. The final scopes must be selected from the approved feature set and the current Reddit OAuth documentation. Candidate read capabilities must be verified against the registered app; no scope list is approved by this document.

## Verification ledger

| Capability | Status |
|---|---|
| FeedRepository contract | Implemented |
| PreviewFeedRepository | Implemented and CI-tested |
| Shared URLSession JSON transport | Implemented and CI-tested |
| Reddit app registration | Not verified |
| Reddit Data API approval | Not verified |
| OAuth client credentials/configuration | Not available in repository |
| OAuth login / refresh / revoke | Not implemented |
| Keychain token storage | Not implemented |
| Reddit endpoint mapping | Not implemented |
| Live feed requests | Not implemented |
| Rate-limit header handling | Not implemented |
| Deleted-content compliance workflow | Not implemented |

## Official references

- Reddit Responsible Builder Policy: https://support.reddithelp.com/hc/en-us/articles/42728983564564-Responsible-Builder-Policy
- Reddit Data API Wiki: https://support.reddithelp.com/hc/en-us/articles/16160319875092-Reddit-Data-API-Wiki
- Reddit Data API Terms: https://redditinc.com/policies/data-api-terms
- Reddit Developer Terms: https://redditinc.com/policies/developer-terms
- Reddit app registration: https://developers.reddit.com/app-registration
- Reddit OAuth technical reference (legacy guidance; verify against current approval): https://github.com/reddit-archive/reddit/wiki/OAuth2

## Exit criteria

This gate can be closed only when Reddit's approval and the app-registration path are documented, the approved OAuth client details are known, and the permitted scopes/use case are confirmed. Until then, the preview feed remains the only enabled repository.
