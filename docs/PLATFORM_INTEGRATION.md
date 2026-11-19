# ORBIT — Platform Integration and Compliance Gates

## Purpose
Account-backed features depend on access to the source platform's documented API. Verify current official requirements before implementation or release.

## Required verification
1. Can a new application be registered and approved?
2. Which OAuth flows and scopes are permitted for this app type?
3. Are there additional approval requirements for personal/third-party clients?
4. What are current rate limits, attribution requirements, caching rules, and sponsored-content restrictions?
5. Which endpoints support feeds, search, communities, posts, comments, voting, saved items, inbox, mentions, and notifications?
6. Is there a documented and approved chat API available to third-party clients?
7. Is push notification delivery permitted, and what server-side requirements apply?

## Non-negotiable implementation rules
- Use documented, authorized endpoints only.
- Do not scrape pages as a substitute for API access.
- Do not use private or reverse-engineered endpoints.
- Do not collect or store a platform password.
- Do not bypass rate limits, ads requirements, access controls, or attribution.
- Do not claim chat, push, or inbox support until the relevant API capability is verified.
- If access is denied or a capability is unavailable, gate the feature and document the limitation.

## Advertising
ORBIT will not add its own advertisements. This does not mean the app can remove or suppress platform-sponsored content where the platform's rules require it. Product behavior must follow current approved API terms.

## Notifications
iOS background execution is opportunistic; it is not a persistent polling service. Reliable push generally requires an approved server-side component and APNs. Any such component needs a documented purpose, secure credential handling, privacy controls, and an operational plan.

## Decision
Until official requirements are checked, account integration is a **release-blocking dependency**. UI prototypes may proceed with fixture data, but must not present simulated account access as live functionality.
