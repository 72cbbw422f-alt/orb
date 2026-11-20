import Foundation

/// Fixture-backed repository used until an authorized live API repository
/// is implemented. The injected posts make repository consumers deterministic
/// in previews and tests.
struct PreviewFeedRepository: FeedRepository {
    private let posts: [FeedPost]

    init(posts: [FeedPost] = FeedPreviewData.posts) {
        self.posts = posts
    }

    func fetchPosts() async throws -> [FeedPost] {
        posts
    }
}
