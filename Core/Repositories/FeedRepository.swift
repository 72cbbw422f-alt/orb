import Foundation

/// Data boundary for loading the posts available to the feed layer.
///
/// Implementations own the source of truth (remote API, local cache, or
/// development fixtures). Presentation and filtering must not depend on
/// a concrete implementation.
protocol FeedRepository {
    func fetchPosts() async throws -> [FeedPost]
}
