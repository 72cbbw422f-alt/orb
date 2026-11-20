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
    func testFailedRefreshPreservesExistingPostsAndCanRecover() async {
        let original = FeedPreviewData.posts
        let updated = Array(original.dropFirst())
        let repository = QueueFeedRepository([
            .success(original),
            .failure(.unavailable),
            .success(updated)
        ])
        let viewModel = FeedViewModel(repository: repository)

        await viewModel.load()
        await viewModel.refresh()

        guard case .failed = viewModel.state else {
            return XCTFail("Expected failed refresh state")
        }
        XCTAssertEqual(viewModel.posts, original)
        XCTAssertFalse(viewModel.isRefreshing)

        await viewModel.refresh()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.posts, updated)
    }

    @MainActor
    func testCancelledInitialLoadReturnsToIdleAndCanRetry() async {
        let expected = FeedPreviewData.posts
        let repository = QueueFeedRepository([
            .failure(.cancelled),
            .success(expected)
        ])
        let viewModel = FeedViewModel(repository: repository)

        await viewModel.load()
        XCTAssertEqual(viewModel.state, .idle)

        await viewModel.loadIfNeeded()
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.posts, expected)
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

private final class QueueFeedRepository: FeedRepository {
    private var results: [Result<[FeedPost], FeedTestError>]

    init(_ results: [Result<[FeedPost], FeedTestError>]) {
        self.results = results
    }

    func fetchPosts() async throws -> [FeedPost] {
        guard !results.isEmpty else {
            throw FeedTestError.unavailable
        }
        switch results.removeFirst() {
        case .success(let posts):
            return posts
        case .failure(.cancelled):
            throw CancellationError()
        case .failure(let error):
            throw error
        }
    }
}

private enum FeedTestError: Error {
    case unavailable
    case cancelled
}
