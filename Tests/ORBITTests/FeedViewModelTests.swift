import XCTest
@testable import ORBIT

final class FeedViewModelTests: XCTestCase {
    @MainActor
    func testLoadTransitionsToLoadedAndUsesRepositoryPosts() async {
        let expected = FeedPreviewData.posts
        let viewModel = FeedViewModel(repository: QueueFeedRepository([.success(expected)]))

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.posts, expected)
    }

    @MainActor
    func testLoadTransitionsToEmptyWhenRepositoryReturnsNoPosts() async {
        let viewModel = FeedViewModel(repository: QueueFeedRepository([.success([])]))

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .empty)
        XCTAssertTrue(viewModel.posts.isEmpty)
    }

    @MainActor
    func testLoadTransitionsToFailedWhenRepositoryThrows() async {
        let viewModel = FeedViewModel(repository: QueueFeedRepository([.failure(.unavailable)]))

        await viewModel.load()

        guard case .failed = viewModel.state else {
            return XCTFail("Expected failed state")
        }
    }

    @MainActor
    func testLoadDeduplicatesPostsByStableIdentifier() async {
        let post = FeedPreviewData.posts[0]
        let viewModel = FeedViewModel(repository: QueueFeedRepository([.success([post, post])]))

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.posts, [post])
    }

    @MainActor
    func testRefreshReplacesPostsAndRecoversFromFailure() async {
        let original = FeedPreviewData.posts
        let updated = Array(original.dropFirst())
        let repository = QueueFeedRepository([
            .failure(.unavailable),
            .success(original),
            .success(updated)
        ])
        let viewModel = FeedViewModel(repository: repository)

        await viewModel.load()
        guard case .failed = viewModel.state else {
            return XCTFail("Expected initial failure")
        }

        await viewModel.load()
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.posts, original)

        await viewModel.refresh()
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.posts, updated)
        XCTAssertFalse(viewModel.isRefreshing)
    }

    @MainActor
    func testQueryIsAppliedLocallyToRepositoryResults() async {
        let viewModel = FeedViewModel(repository: QueueFeedRepository([.success(FeedPreviewData.posts)]))
        await viewModel.load()

        let query = FeedQuery(
            scope: .home,
            sort: .title,
            kind: .image,
            searchText: ""
        )

        let result = viewModel.visiblePosts(for: query)

        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.allSatisfy { $0.kind == .image })
    }
}

private actor QueueFeedRepository: FeedRepository {
    private var results: [Result<[FeedPost], FeedTestError>]

    init(_ results: [Result<[FeedPost], FeedTestError>]) {
        self.results = results
    }

    func fetchPosts() async throws -> [FeedPost] {
        guard !results.isEmpty else {
            throw FeedTestError.unavailable
        }
        return try results.removeFirst().get()
    }
}

private enum FeedTestError: Error {
    case unavailable
}
