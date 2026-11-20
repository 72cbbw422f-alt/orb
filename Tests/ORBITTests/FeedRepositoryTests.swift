import XCTest
@testable import ORBIT

final class FeedRepositoryTests: XCTestCase {
    func testPreviewRepositoryReturnsItsInjectedPosts() async throws {
        let expected = FeedPreviewData.posts
        let repository = PreviewFeedRepository(posts: expected)

        let result = try await repository.fetchPosts()

        XCTAssertEqual(result, expected)
    }

    func testPreviewRepositoryPreservesEmptyResult() async throws {
        let repository = PreviewFeedRepository(posts: [])

        let result = try await repository.fetchPosts()

        XCTAssertTrue(result.isEmpty)
    }

    func testDefaultPreviewRepositoryUsesStableFixtureIdentifiers() async throws {
        let repository = PreviewFeedRepository()

        let result = try await repository.fetchPosts()

        XCTAssertEqual(result.map(\.id), FeedPreviewData.posts.map(\.id))
        XCTAssertEqual(Set(result.map(\.id)).count, result.count)
    }
}
